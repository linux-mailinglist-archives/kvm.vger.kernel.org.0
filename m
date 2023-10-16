Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEFF7CAFDD
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234195AbjJPQj0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234594AbjJPQhv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:37:51 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBBA972B1;
        Mon, 16 Oct 2023 09:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473372; x=1729009372;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=75w4Y6RO2208HNHofqgFhmzuuMt1I2A8+tizXHUCKk0=;
  b=J/qkGV2DZD4GoMJB8PToRJufbwwRUiuFAyPuOIcDWG4xzoTklXWpFXTU
   yC2IRVL2NdpjHFDcY1BqCHi6eh3o8nfXghZJ1/kJVvFF5CTwghPiXKv3Z
   P8HSow7Bb5opLFs4uFJiM7qYQQ+Hq2+de7YFcHNE8iaTFN38Jmnb/GX/4
   WYhboRW3bFzEbwlM9cIEK3su4uDQVdm7Xe3BSjsbO1m4RIn6TH6wDSa7p
   yagUTpO4vG1DSbfsz4NPBQP69Eq5H0OKGW3x+qlyg/O+br7hVXfNIrcvT
   UziJ+1UiKrA/JvhLrZPxv5H6BrJh2PNBcpxI9gbPXxnJPUzjYAop7zaJ+
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="364922174"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="364922174"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:16:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="1003006496"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="1003006496"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:16:13 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com
Subject: [PATCH v16 114/116] RFC: KVM: x86: Add x86 callback to check cpuid
Date:   Mon, 16 Oct 2023 09:15:06 -0700
Message-Id: <e63cb9012a4a27b07696e9cd53cc0d0e8b5331b3.1697471314.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1697471314.git.isaku.yamahata@intel.com>
References: <cover.1697471314.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

The x86 backend should check the consistency of KVM_SET_CPUID2 because it
has its constraint.  Add a callback for it.  The backend code will come as
another patch.

Suggested-by: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/lkml/ZDiGpCkXOcCm074O@google.com/
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  2 ++
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/cpuid.c               | 20 ++++++++++++--------
 3 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 8b3c5f2179cf..ba74cb7199b3 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -20,6 +20,8 @@ KVM_X86_OP(hardware_disable)
 KVM_X86_OP(hardware_unsetup)
 KVM_X86_OP_OPTIONAL_RET0(offline_cpu)
 KVM_X86_OP(has_emulated_msr)
+/* TODO: Once all backend implemented this op, remove _OPTIONAL_RET0. */
+KVM_X86_OP_OPTIONAL_RET0(vcpu_check_cpuid)
 KVM_X86_OP(vcpu_after_set_cpuid)
 KVM_X86_OP(is_vm_type_supported)
 KVM_X86_OP_OPTIONAL(max_vcpus);
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f0674ef1c17e..8ac6f0555ac3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1619,6 +1619,7 @@ struct kvm_x86_ops {
 	void (*hardware_unsetup)(void);
 	int (*offline_cpu)(void);
 	bool (*has_emulated_msr)(struct kvm *kvm, u32 index);
+	int (*vcpu_check_cpuid)(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2, int nent);
 	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
 
 	bool (*is_vm_type_supported)(unsigned long vm_type);
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index da46f284ec65..7ce2fdba8fff 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -136,6 +136,7 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu,
 {
 	struct kvm_cpuid_entry2 *best;
 	u64 xfeatures;
+	int r;
 
 	/*
 	 * The existing code assumes virtual address is 48-bit or 57-bit in the
@@ -155,15 +156,18 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu,
 	 * enabling in the FPU, e.g. to expand the guest XSAVE state size.
 	 */
 	best = cpuid_entry2_find(entries, nent, 0xd, 0);
-	if (!best)
-		return 0;
-
-	xfeatures = best->eax | ((u64)best->edx << 32);
-	xfeatures &= XFEATURE_MASK_USER_DYNAMIC;
-	if (!xfeatures)
-		return 0;
+	if (best) {
+		xfeatures = best->eax | ((u64)best->edx << 32);
+		xfeatures &= XFEATURE_MASK_USER_DYNAMIC;
+		if (xfeatures) {
+			r = fpu_enable_guest_xfd_features(&vcpu->arch.guest_fpu,
+							  xfeatures);
+			if (r)
+				return r;
+		}
+	}
 
-	return fpu_enable_guest_xfd_features(&vcpu->arch.guest_fpu, xfeatures);
+	return static_call(kvm_x86_vcpu_check_cpuid)(vcpu, entries, nent);
 }
 
 /* Check whether the supplied CPUID data is equal to what is already set for the vCPU. */
-- 
2.25.1

