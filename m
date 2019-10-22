Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48F3FDFAD3
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 04:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387933AbfJVCBe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 22:01:34 -0400
Received: from mga14.intel.com ([192.55.52.115]:61609 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387658AbfJVB74 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 21:59:56 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 18:59:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,325,1566889200"; 
   d="scan'208";a="196293879"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 21 Oct 2019 18:59:54 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Marc Zyngier <maz@kernel.org>, James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 32/45] KVM: Move initialization of preempt notifier to kvm_vcpu_init()
Date:   Mon, 21 Oct 2019 18:59:12 -0700
Message-Id: <20191022015925.31916-33-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191022015925.31916-1-sean.j.christopherson@intel.com>
References: <20191022015925.31916-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Initialize the preempt notifier immediately in kvm_vcpu_init() to pave
the way for removing kvm_arch_vcpu_setup(), i.e. to allow arch specific
code to call vcpu_load() during kvm_arch_vcpu_create().

Back when preemption support was added, the location of the call to init
the preempt notifier was perfectly sane.  The overall vCPU creation flow
featured a single arch specific hook and the preempt notifer was used
immediately after its initialization (by vcpu_load()).  E.g.:

        vcpu = kvm_arch_ops->vcpu_create(kvm, n);
        if (IS_ERR(vcpu))
                return PTR_ERR(vcpu);

        preempt_notifier_init(&vcpu->preempt_notifier, &kvm_preempt_ops);

        vcpu_load(vcpu);
        r = kvm_mmu_setup(vcpu);
        vcpu_put(vcpu);
        if (r < 0)
                goto free_vcpu;

Today, the call to preempt_notifier_init() is sandwiched between two
arch specific calls, kvm_arch_vcpu_create() and kvm_arch_vcpu_setup(),
which needlessly forces x86 (and possibly others?) to split its vCPU
creation flow.  Init the preempt notifier prior to any arch specific
call so that each arch can independently decide how best to organize
its creation flow.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 virt/kvm/kvm_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1d84ae0e3893..4a4d2992d915 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -314,6 +314,7 @@ static int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 	kvm_vcpu_set_dy_eligible(vcpu, false);
 	vcpu->preempted = false;
 	vcpu->ready = false;
+	preempt_notifier_init(&vcpu->preempt_notifier, &kvm_preempt_ops);
 
 	r = kvm_arch_vcpu_init(vcpu);
 	if (r < 0)
@@ -2677,8 +2678,6 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 	if (r)
 		goto vcpu_uninit;
 
-	preempt_notifier_init(&vcpu->preempt_notifier, &kvm_preempt_ops);
-
 	r = kvm_arch_vcpu_setup(vcpu);
 	if (r)
 		goto vcpu_destroy;
-- 
2.22.0

