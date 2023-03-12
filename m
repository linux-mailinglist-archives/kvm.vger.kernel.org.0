Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9256B6482
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbjCLJ6t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbjCLJ6Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:58:16 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B3637B79
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:57:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615057; x=1710151057;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wyYEo6YJDdlPKbTkqGfh56FH/MODjIsdzIQZjUhE0HU=;
  b=eICbKl01g8rUzvmyll7N/5rtEhi8j1p5p6IvEIgc8nIxl1g0z5b7Vt9g
   a3qh3wJofrI5wkJWIhd4ooyDKtsZM4yt3KyECGw324j13Kk6yoNJWqfQx
   4pZY6QkPKbR7EMJ3Agal8ag3DbefXNooNhIGxEK4sfOvplEI5gwd3u9Tj
   833ruxJmWJcMGVaEV3ttQhXfBaZpJPqSEyvbMKT+dTaPnJWJKeGsKJ5dg
   1VxWZekZcmFf5O8n3ZTVOlNz6URBCr1GQC3HKr2CAeJ9/Rth8PdTnHUVD
   FlW3xs+OUhANqYegi25FHMIM0JJNu5WT+B3QsBIvvY4tHDOxZapnXWLrN
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="336998099"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="336998099"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="680677658"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="680677658"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:12 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Haiwei Li <haiwei.li@intel.com>
Subject: [RFC PATCH part-5 04/22] pkvm: x86: Add check for guest address translation
Date:   Mon, 13 Mar 2023 02:02:45 +0800
Message-Id: <20230312180303.1778492-5-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180303.1778492-1-jason.cj.chen@intel.com>
References: <20230312180303.1778492-1-jason.cj.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Haiwei Li <haiwei.li@intel.com>

During guest address translation, it needs to check if there is
an exception happens, triggered by invalid address or permission.

For the callers who invoke read_gva/write_gva, should check the
`exception` and handle it, such as inject a #PF to guest.

Signed-off-by: Haiwei Li <haiwei.li@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/memory.c | 97 ++++++++++++++++++++++++++++--
 1 file changed, 92 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/memory.c b/arch/x86/kvm/vmx/pkvm/hyp/memory.c
index a42669ccf89c..6a400aef1bd8 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/memory.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/memory.c
@@ -78,11 +78,97 @@ static struct pkvm_mm_ops mm_ops = {
 	.phys_to_virt = host_gpa2hva,
 };
 
-static int check_translation(struct kvm_vcpu *vcpu, gpa_t gpa,
+static int check_translation(struct kvm_vcpu *vcpu, gva_t gva, gpa_t gpa,
 		u64 prot, u32 access, struct x86_exception *exception)
 {
-	/* TODO: exception for #PF */
+	u16 errcode = 0;
+	bool page_rw_flags_on = true;
+	bool user_mode_addr = true;
+	const int user_mode_access = access & PFERR_USER_MASK;
+	const int write_access = access & PFERR_WRITE_MASK;
+	bool cr4_smap = vmcs_readl(GUEST_CR4) & X86_CR4_SMAP;
+	bool cr0_wp = vmcs_readl(GUEST_CR0) & X86_CR0_WP;
+
+	/*
+	 * As pkvm hypervisor will not do instruction emulation, here we do not
+	 * expect guest memory access for instruction fetch.
+	 */
+	WARN_ON(access & PFERR_FETCH_MASK);
+
+	/* pte is not present */
+	if (gpa == INVALID_ADDR) {
+		goto check_fault;
+	} else {
+		errcode |= PFERR_PRESENT_MASK;
+
+		/*TODO: check reserved bits and PK */
+
+		/* check for R/W */
+		if ((prot & _PAGE_RW) == 0) {
+			if (write_access && (user_mode_access || cr0_wp))
+				/*
+				 * case 1: Supermode and wp is 1
+				 * case 2: Usermode
+				 */
+				goto check_fault;
+			page_rw_flags_on = false;
+		}
+
+		/* check for U/S */
+		if ((prot & _PAGE_USER) == 0) {
+			user_mode_addr = false;
+			if (user_mode_access)
+				goto check_fault;
+		}
+
+		/*
+		 * When SMAP is on, we only need to apply check when address is
+		 * user-mode address.
+		 *
+		 * Also SMAP only impacts the supervisor-mode access.
+		 */
+		/* if SMAP is enabled and supervisor-mode access */
+		if (cr4_smap && (!user_mode_access) && user_mode_addr) {
+			bool acflag = vmcs_readl(GUEST_RFLAGS) & X86_EFLAGS_AC;
+
+			/* read from user mode address, eflags.ac = 0 */
+			if ((!write_access) && (!acflag)) {
+				goto check_fault;
+			} else if (write_access) {
+				/* write to user mode address */
+
+				/* cr0.wp = 0, eflags.ac = 0 */
+				if ((!cr0_wp) && (!acflag))
+					goto check_fault;
+
+				/*
+				 * cr0.wp = 1, eflags.ac = 1, r/w flag is 0
+				 * on any paging structure entry
+				 */
+				if (cr0_wp && acflag && (!page_rw_flags_on))
+					goto check_fault;
+
+				/* cr0.wp = 1, eflags.ac = 0 */
+				if (cr0_wp && (!acflag))
+					goto check_fault;
+			} else {
+				/* do nothing */
+			}
+		}
+	}
+
 	return 0;
+
+check_fault:
+	errcode |= write_access | user_mode_access;
+	exception->error_code = errcode;
+	exception->vector = PF_VECTOR;
+	exception->error_code_valid = true;
+	exception->address = gva;
+	exception->nested_page_fault = false;
+	exception->async_page_fault = false;
+	return -EFAULT;
+
 }
 
 int gva2gpa(struct kvm_vcpu *vcpu, gva_t gva, gpa_t *gpa,
@@ -104,10 +190,8 @@ int gva2gpa(struct kvm_vcpu *vcpu, gva_t gva, gpa_t *gpa,
 	pkvm_pgtable_lookup(&guest_mmu, (unsigned long)gva,
 			(unsigned long *)&_gpa, &prot, &pg_level);
 	*gpa = _gpa;
-	if (_gpa == INVALID_ADDR)
-		return -EFAULT;
 
-	return check_translation(vcpu, _gpa, prot, access, exception);
+	return check_translation(vcpu, gva, _gpa, prot, access, exception);
 }
 
 static inline int __copy_gpa(struct kvm_vcpu *vcpu, void *addr, gpa_t gpa,
@@ -138,6 +222,9 @@ static int copy_gva(struct kvm_vcpu *vcpu, gva_t gva, void *addr,
 	unsigned int len;
 	int ret = 0;
 
+	if (!from_guest)
+		access |= PFERR_WRITE_MASK;
+
 	while ((bytes > 0) && (ret == 0)) {
 		ret = gva2gpa(vcpu, gva, &gpa, access, exception);
 		if (ret >= 0) {
-- 
2.25.1

