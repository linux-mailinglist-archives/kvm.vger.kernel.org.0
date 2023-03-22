Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1A886C41C1
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 05:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbjCVE6d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 00:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjCVE6b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 00:58:31 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A98B92CFEF
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 21:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679461110; x=1710997110;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mnOVivUtb2g/JwqUJZXHwBmZS4QFM+1d8SxgF3VhJC8=;
  b=EJ5jv8GPpdvZMb6MVj75vuYBuKeLtxXxG2ZDcEaKpJ1KDyslTxDFDjef
   9GCBwsw23lDuapa7+LBJAdx+9PuAfCAQRJLE7/h1N7uj0kajXFDOlYvOb
   j9yL55C76iRLfpsy0V9gYoM8rFj2sRMOjXj/j5KJdblKla7MOZh0lanEV
   AZ8SSZ2/i9t/ESjvpvwiHaJTV4ptcwf0djtI+SW1j6V3qKTxhXnFO5gRD
   yO40orHdAPh7sKfRTZP0gstBquW1Sl3dUchrW/n11m8szalHMeZ+QxBlG
   w9wwQipwxoDQIUcPKHL4Js84us/uSYxngjSQTyd8RarhNibpcQYZOBKSR
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="327507190"
X-IronPort-AV: E=Sophos;i="5.98,280,1673942400"; 
   d="scan'208";a="327507190"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 21:58:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="750908540"
X-IronPort-AV: E=Sophos;i="5.98,280,1673942400"; 
   d="scan'208";a="750908540"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.238.8.235])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 21:58:28 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com
Cc:     binbin.wu@linux.intel.com, robert.hu@linux.intel.com
Subject: [PATCH 1/4] KVM: x86: Add helpers to check bit set in CR0/CR4 and return in bool
Date:   Wed, 22 Mar 2023 12:58:21 +0800
Message-Id: <20230322045824.22970-2-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230322045824.22970-1-binbin.wu@linux.intel.com>
References: <20230322045824.22970-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add helps kvm_is_cr0_bit_set()/kvm_is_cr4_bit_set() to check if one
specific bit is set or not in CR0/CR4 of vCPU and return the result
in bool.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
 arch/x86/kvm/kvm_cache_regs.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 4c91f626c058..f2bf930a3cd4 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -157,6 +157,14 @@ static inline ulong kvm_read_cr0_bits(struct kvm_vcpu *vcpu, ulong mask)
 	return vcpu->arch.cr0 & mask;
 }
 
+static __always_inline bool kvm_is_cr0_bit_set(struct kvm_vcpu *vcpu,
+					       unsigned long cr0_bit)
+{
+	BUILD_BUG_ON(!is_power_of_2(cr0_bit));
+
+	return !!kvm_read_cr0_bits(vcpu, cr0_bit);
+}
+
 static inline ulong kvm_read_cr0(struct kvm_vcpu *vcpu)
 {
 	return kvm_read_cr0_bits(vcpu, ~0UL);
@@ -171,6 +179,14 @@ static inline ulong kvm_read_cr4_bits(struct kvm_vcpu *vcpu, ulong mask)
 	return vcpu->arch.cr4 & mask;
 }
 
+static __always_inline bool kvm_is_cr4_bit_set(struct kvm_vcpu *vcpu,
+					       unsigned long cr4_bit)
+{
+	BUILD_BUG_ON(!is_power_of_2(cr4_bit));
+
+	return !!kvm_read_cr4_bits(vcpu, cr4_bit);
+}
+
 static inline ulong kvm_read_cr3(struct kvm_vcpu *vcpu)
 {
 	if (!kvm_register_is_available(vcpu, VCPU_EXREG_CR3))
-- 
2.25.1

