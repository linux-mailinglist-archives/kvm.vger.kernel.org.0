Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76441221AE8
	for <lists+kvm@lfdr.de>; Thu, 16 Jul 2020 05:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728232AbgGPDl1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 23:41:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:49384 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727825AbgGPDlZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 23:41:25 -0400
IronPort-SDR: o2z56twEMc573M5VCWIdM1T/z81SYz8Ecfgs6kfhJG/X/2qow+B9CJEftnvYhJk7L052vOilyQ
 d+BlHOes5PZQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9683"; a="147310948"
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="147310948"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2020 20:41:25 -0700
IronPort-SDR: Eq7vSGi50vAzlkVRA/w3Ky5hkrfcwwmwP61S/b/Y2Flz4ni732GYXOvuFaspE6EaL/8OTdMPMP
 9v9oo4ejb76Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="316905470"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga008.jf.intel.com with ESMTP; 15 Jul 2020 20:41:24 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/9] KVM: nSVM: Correctly set the shadow NPT root level in its MMU role
Date:   Wed, 15 Jul 2020 20:41:14 -0700
Message-Id: <20200716034122.5998-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200716034122.5998-1-sean.j.christopherson@intel.com>
References: <20200716034122.5998-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the initialization of shadow NPT MMU's shadow_root_level into
kvm_init_shadow_npt_mmu() and explicitly set the level in the shadow NPT
MMU's role to be the TDP level.  This ensures the role and MMU levels
are synchronized and also initialized before __kvm_mmu_new_pgd(), which
consumes the level when attempting a fast PGD switch.

Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Fixes: 9fa72119b24db ("kvm: x86: Introduce kvm_mmu_calc_root_page_role()")
Fixes: a506fdd223426 ("KVM: nSVM: implement nested_svm_load_cr3() and use it for host->guest switch")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c    | 3 +++
 arch/x86/kvm/svm/nested.c | 1 -
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 77810ce66bdb4..678b6209dad50 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4963,6 +4963,9 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, u32 cr0, u32 cr4, u32 efer,
 	union kvm_mmu_role new_role =
 		kvm_calc_shadow_mmu_root_page_role(vcpu, false);
 
+	new_role.base.level = vcpu->arch.tdp_level;
+	context->shadow_root_level = new_role.base.level;
+
 	__kvm_mmu_new_pgd(vcpu, nested_cr3, new_role.base, false, false);
 
 	if (new_role.as_u64 != context->mmu_role.as_u64)
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 61378a3c2ce44..fb68467e60496 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -85,7 +85,6 @@ static void nested_svm_init_mmu_context(struct kvm_vcpu *vcpu)
 	vcpu->arch.mmu->get_guest_pgd     = nested_svm_get_tdp_cr3;
 	vcpu->arch.mmu->get_pdptr         = nested_svm_get_tdp_pdptr;
 	vcpu->arch.mmu->inject_page_fault = nested_svm_inject_npf_exit;
-	vcpu->arch.mmu->shadow_root_level = vcpu->arch.tdp_level;
 	reset_shadow_zero_bits_mask(vcpu, vcpu->arch.mmu);
 	vcpu->arch.walk_mmu              = &vcpu->arch.nested_mmu;
 }
-- 
2.26.0

