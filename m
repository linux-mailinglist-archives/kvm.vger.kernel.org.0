Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5E445D2CC
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 03:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbhKYCFD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:05:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347838AbhKYCDB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 21:03:01 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C215C0619EA
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:57 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id p12-20020a17090b010c00b001a65bfe8054so2305425pjz.8
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=JBDOYHOK2DhSA1nXoHqfL44xC3AdOj+zCRP7btHlCLs=;
        b=QaleV3S9lSZct52oFl1IgamOFGcLvBaoj8GaReg0/s/Ajk5+5+EZZLu55bO0DccX2o
         iTABAOzA5kN8fLi3OmAT/a2DlAFP0wXqqg7UcDTPeHbIB7TbXYOacEUbdRmJjr9HAbfY
         bM43u8QXS4feS5g/lPbyGB1mrMvW0SKKcV6VxNMHvd7zioIaZsjBg2G6l8monLIZqzXL
         pnXqgvKX2uTSupFY6gLCMdRYf+sYdt6KBbQ0cx2B8AIiIwLPWIiNSmkV56SK+UXF420W
         a63neCSz5fdBBWzYY0a86L4TYvm+FBMjWh0kNn156FECn8IWsaQMKM5tirdDFQG29iw8
         pcUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=JBDOYHOK2DhSA1nXoHqfL44xC3AdOj+zCRP7btHlCLs=;
        b=SVO8qdZOhKtoaEO28aTHR316EI9GhmBWV+240unLwhjCqJeIs5Tx7CDqU5D1kQnnYb
         SxTjiTF9EyaHqimc+SOBLe5Dei6cH+Fv+vKxTJ6I25VN9t4tqk5NIbsfAaJG+t2Ny/kn
         CEX3nRHNAdOG3xtx4JapLWwYfN1etsOIERvyL7pQiyLLLAKs2l5kZSZQbWT5+8GBQeA1
         4lAbFkWY0L56RfrBRJBNbLkL7Sdm0WgqBqhW3IecZSAEFQToOmL3yaHq03NU2ncQZeVY
         SWYnlQKvgvMDTg0chLniE+6yuX8kOGrSvbKiwlM0E7RHia8mZxAbU1Lg/W0rLcYICn2e
         4WhA==
X-Gm-Message-State: AOAM530J11FzQxGMHpZuPfjmI9zgv+0r0YvBpz+GvsTzVELoCiDm1j9L
        NXAn6iIIY+5tuLejuuXG2JBizgAN0UA=
X-Google-Smtp-Source: ABdhPJxmigD5SWZqsKkvXxIYid8nDCgkiUH/U3w+o1ci8SBe90yIeUVx3HG1OgkXVLjXGP8owTfKhRYG+GY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:e8d8:b0:142:5622:f9e5 with SMTP id
 v24-20020a170902e8d800b001425622f9e5mr25821349plg.42.1637803796941; Wed, 24
 Nov 2021 17:29:56 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Nov 2021 01:28:53 +0000
In-Reply-To: <20211125012857.508243-1-seanjc@google.com>
Message-Id: <20211125012857.508243-36-seanjc@google.com>
Mime-Version: 1.0
References: <20211125012857.508243-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [kvm-unit-tests PATCH 35/39] nVMX: Add helper to check if a memtype
 is supported for EPT structures
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a helper to check if a given memtype can be used for EPT structures,
and use the helper to clean up the EPT test code.  An informational
message is lost along the way, but that's not necessarily a bad thing.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx.h       | 11 +++++++++++
 x86/vmx_tests.c | 33 ++-------------------------------
 2 files changed, 13 insertions(+), 31 deletions(-)

diff --git a/x86/vmx.h b/x86/vmx.h
index d3e95f5..401715c 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -825,6 +825,17 @@ static inline bool is_5_level_ept_supported(void)
 	return ept_vpid.val & EPT_CAP_PWL5;
 }
 
+static inline bool is_ept_memtype_supported(int type)
+{
+	if (type == EPT_MEM_TYPE_UC)
+		return ept_vpid.val & EPT_CAP_UC;
+
+	if (type == EPT_MEM_TYPE_WB)
+		return ept_vpid.val & EPT_CAP_WB;
+
+	return false;
+}
+
 static inline bool is_invept_type_supported(u64 type)
 {
 	if (type < INVEPT_SINGLE || type > INVEPT_GLOBAL)
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 2bfc794..27150cb 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -4712,9 +4712,7 @@ static void test_ept_eptp(void)
 	u64 eptp_saved = vmcs_read(EPTP);
 	u32 primary = primary_saved;
 	u32 secondary = secondary_saved;
-	u64 msr, eptp = eptp_saved;
-	bool un_cache = false;
-	bool wr_bk = false;
+	u64 eptp = eptp_saved;
 	bool ctrl;
 	u32 i, maxphysaddr;
 	u64 j, resv_bits_mask = 0;
@@ -4725,15 +4723,6 @@ static void test_ept_eptp(void)
 		return;
 	}
 
-	/*
-	 * Memory type (bits 2:0)
-	 */
-	msr = rdmsr(MSR_IA32_VMX_EPT_VPID_CAP);
-	if (msr & EPT_CAP_UC)
-		un_cache = true;
-	if (msr & EPT_CAP_WB)
-		wr_bk = true;
-
 	/* Support for 4-level EPT is mandatory. */
 	report(is_4_level_ept_supported(), "4-level EPT support check");
 
@@ -4746,29 +4735,11 @@ static void test_ept_eptp(void)
 	vmcs_write(EPTP, eptp);
 
 	for (i = 0; i < 8; i++) {
-		if (i == 0) {
-			if (un_cache) {
-				report_info("EPT paging structure memory-type is Un-cacheable\n");
-				ctrl = true;
-			} else {
-				ctrl = false;
-			}
-		} else if (i == 6) {
-			if (wr_bk) {
-				report_info("EPT paging structure memory-type is Write-back\n");
-				ctrl = true;
-			} else {
-				ctrl = false;
-			}
-		} else {
-			ctrl = false;
-		}
-
 		eptp = (eptp & ~EPT_MEM_TYPE_MASK) | i;
 		vmcs_write(EPTP, eptp);
 		report_prefix_pushf("Enable-EPT enabled; EPT memory type %lu",
 		    eptp & EPT_MEM_TYPE_MASK);
-		if (ctrl)
+		if (is_ept_memtype_supported(i))
 			test_vmx_valid_controls();
 		else
 			test_vmx_invalid_controls();
-- 
2.34.0.rc2.393.gf8c9666880-goog

