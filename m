Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B27A8DFAE9
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 04:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387737AbfJVCCC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 22:02:02 -0400
Received: from mga14.intel.com ([192.55.52.115]:61596 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387592AbfJVB7v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 21:59:51 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 18:59:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,325,1566889200"; 
   d="scan'208";a="196293855"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 21 Oct 2019 18:59:50 -0700
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
Subject: [PATCH 26/45] KVM: s390: Invoke kvm_vcpu_init() before allocating sie_page
Date:   Mon, 21 Oct 2019 18:59:06 -0700
Message-Id: <20191022015925.31916-27-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191022015925.31916-1-sean.j.christopherson@intel.com>
References: <20191022015925.31916-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that s390's implementation of kvm_arch_vcpu_init() is empty, move
the call to kvm_vcpu_init() above the allocation of the sie_page.  This
paves the way for moving vcpu allocation and initialization into common
KVM code without any associated functional change.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/s390/kvm/kvm-s390.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 43be136682bb..9289ed10561b 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3030,10 +3030,16 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 	if (!vcpu)
 		goto out;
 
+	rc = kvm_vcpu_init(vcpu, kvm, id);
+	if (rc)
+		goto out_free_cpu;
+
+	rc = -ENOMEM;
+
 	BUILD_BUG_ON(sizeof(struct sie_page) != 4096);
 	sie_page = (struct sie_page *) get_zeroed_page(GFP_KERNEL);
 	if (!sie_page)
-		goto out_free_cpu;
+		goto out_uninit_vcpu;
 
 	vcpu->arch.sie_block = &sie_page->sie_block;
 	vcpu->arch.sie_block->itdba = (unsigned long) &sie_page->itdb;
@@ -3049,10 +3055,6 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 		vcpu->arch.sie_block->gd |= GISA_FORMAT1;
 	seqcount_init(&vcpu->arch.cputm_seqcount);
 
-	rc = kvm_vcpu_init(vcpu, kvm, id);
-	if (rc)
-		goto out_free_sie_block;
-
 	vcpu->arch.pfault_token = KVM_S390_PFAULT_TOKEN_INVALID;
 	kvm_clear_async_pf_completion_queue(vcpu);
 	vcpu->run->kvm_valid_regs = KVM_SYNC_PREFIX |
@@ -3081,7 +3083,7 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 	if (kvm_is_ucontrol(vcpu->kvm)) {
 		rc = __kvm_ucontrol_vcpu_init(vcpu);
 		if (rc)
-			goto out_uninit_vcpu;
+			goto out_free_sie_block;
 	}
 
 	VM_EVENT(kvm, 3, "create cpu %d at 0x%pK, sie block at 0x%pK", id, vcpu,
@@ -3089,10 +3091,10 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 	trace_kvm_s390_create_vcpu(id, vcpu, vcpu->arch.sie_block);
 
 	return vcpu;
-out_uninit_vcpu:
-	kvm_vcpu_uninit(vcpu);
 out_free_sie_block:
 	free_page((unsigned long)(vcpu->arch.sie_block));
+out_uninit_vcpu:
+	kvm_vcpu_uninit(vcpu);
 out_free_cpu:
 	kmem_cache_free(kvm_vcpu_cache, vcpu);
 out:
-- 
2.22.0

