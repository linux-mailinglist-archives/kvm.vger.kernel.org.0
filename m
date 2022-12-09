Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30233647D04
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 05:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbiLIEqU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 23:46:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiLIEqR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 23:46:17 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D02D7D05D
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 20:46:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670561173; x=1702097173;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uhiOuHLM0F8r6OVJk4a69yzS+slo/fvV8VfLB+cuWGk=;
  b=knIDucun3CDLkOEpVK20JKxYJyZXqbf4k5ZIYnuioX4jUYj1RJWLqVxs
   neYZSwytjhnHWBtja8ahwUh3xsdmyTOsUjwU+vv5g0HefHSfTMU7I6YEC
   8SbCe1vVGTrh3U0c3EBaYBhPY909Vcdljidrx+d6Pu0ANR/4KluNSzIH0
   KHlzvfcrXB2M3fUw8y6E5/MZoGbi8UT/nuKatY6TnWM5F4qoNca0GxxpH
   cIyZdnhmKkkWfKRm9DJXWb2v4tPativn7COTRiecnemLWZswx+iv1Ymaw
   mGBSwyENK+Wlzukt9kgi6mRnMD7OjCWebZgmxMBK/Z5K98Yo9yFssHfof
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="318530851"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="318530851"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 20:46:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="892524455"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="892524455"
Received: from sqa-gate.sh.intel.com (HELO robert-clx2.tsp.org) ([10.239.48.212])
  by fmsmga006.fm.intel.com with ESMTP; 08 Dec 2022 20:46:11 -0800
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org
Cc:     Robert Hoo <robert.hu@linux.intel.com>,
        Jingqi Liu <jingqi.liu@intel.com>
Subject: [PATCH v3 5/9] KVM: x86: MMU: Integrate LAM bits when build guest CR3
Date:   Fri,  9 Dec 2022 12:45:53 +0800
Message-Id: <20221209044557.1496580-6-robert.hu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221209044557.1496580-1-robert.hu@linux.intel.com>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When calc the new CR3 value, take LAM bits in.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Reviewed-by: Jingqi Liu <jingqi.liu@intel.com>
---
 arch/x86/kvm/mmu.h     | 5 +++++
 arch/x86/kvm/vmx/vmx.c | 3 ++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 6bdaacb6faa0..866f2b7cb509 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -142,6 +142,11 @@ static inline unsigned long kvm_get_active_pcid(struct kvm_vcpu *vcpu)
 	return kvm_get_pcid(vcpu, kvm_read_cr3(vcpu));
 }
 
+static inline u64 kvm_get_active_lam(struct kvm_vcpu *vcpu)
+{
+	return kvm_read_cr3(vcpu) & (X86_CR3_LAM_U48 | X86_CR3_LAM_U57);
+}
+
 static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
 {
 	u64 root_hpa = vcpu->arch.mmu->root.hpa;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cfa06c7c062e..9985dbb63e7b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3261,7 +3261,8 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			update_guest_cr3 = false;
 		vmx_ept_load_pdptrs(vcpu);
 	} else {
-		guest_cr3 = root_hpa | kvm_get_active_pcid(vcpu);
+		guest_cr3 = root_hpa | kvm_get_active_pcid(vcpu) |
+			    kvm_get_active_lam(vcpu);
 	}
 
 	if (update_guest_cr3)
-- 
2.31.1

