Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A841DFB1A
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 04:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387802AbfJVCDB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 22:03:01 -0400
Received: from mga14.intel.com ([192.55.52.115]:61583 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387445AbfJVB7m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 21:59:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 18:59:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,325,1566889200"; 
   d="scan'208";a="196293804"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 21 Oct 2019 18:59:41 -0700
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
Subject: [PATCH 14/45] KVM: PPC: e500mc: Move reset of oldpir below call to kvm_vcpu_init()
Date:   Mon, 21 Oct 2019 18:58:54 -0700
Message-Id: <20191022015925.31916-15-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191022015925.31916-1-sean.j.christopherson@intel.com>
References: <20191022015925.31916-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the initialization of oldpir so that the call to kvm_vcpu_init() is
at the top of kvmppc_core_vcpu_create_e500mc().  oldpir is only use
when loading/putting a vCPU, which currently cannot be done until after
kvm_arch_vcpu_create() completes.  Reording the call to kvm_vcpu_init()
paves the way for moving the invocation to common PPC code.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/powerpc/kvm/e500mc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/e500mc.c b/arch/powerpc/kvm/e500mc.c
index aea588f73bf7..f2902e612150 100644
--- a/arch/powerpc/kvm/e500mc.c
+++ b/arch/powerpc/kvm/e500mc.c
@@ -310,13 +310,13 @@ static int kvmppc_core_vcpu_create_e500mc(struct kvm *kvm, struct kvm_vcpu *vcpu
 	BUILD_BUG_ON(offsetof(struct kvmppc_vcpu_e500, vcpu) != 0);
 	vcpu_e500 = to_e500(vcpu);
 
-	/* Invalid PIR value -- this LPID dosn't have valid state on any cpu */
-	vcpu->arch.oldpir = 0xffffffff;
-
 	err = kvm_vcpu_init(vcpu, kvm, id);
 	if (err)
 		return err;
 
+	/* Invalid PIR value -- this LPID dosn't have valid state on any cpu */
+	vcpu->arch.oldpir = 0xffffffff;
+
 	err = kvmppc_e500_tlb_init(vcpu_e500);
 	if (err)
 		goto uninit_vcpu;
-- 
2.22.0

