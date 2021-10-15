Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E490742FC9E
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 21:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242888AbhJOT5t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 15:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242891AbhJOT5p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 15:57:45 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63A4C061767
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 12:55:38 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id t75-20020a63784e000000b002993a9284b0so5549619pgc.11
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 12:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=0gFWOxjXB0c1Q+Iin2AdfFN/hNj8vdZaeYPqs1MYJFM=;
        b=DgL3RlfCbekkTBwYgZbDMrMomstvCBRCNdOfenjBUmrVUcjnURtj7CUPv8GSzJLkKV
         As2JgZxfO0H6fJ4QYysNThuZ8d0y4mDUq0UA4kpE6kNzOVEcjPkTBGjFzqdLjPIF0elz
         sFGRnaGBeqR5Eun75Q4fa8KxWOokO7vUH98mzePNdBSlVZh+ef6XMvPr+rVEWNdc7kuK
         rPP06BEwi8Yx9Y1mtJefnNNma5wuZFMg31Qv2/2Fuov4gA6Gi3g9IlHnkdqTB6OwCOz1
         YPP8K/rO4ckphFt2O0tleoq4oBj8LFLZb4belOgN46nCqvD5G8JpJbswAGK15xTniojv
         /4XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0gFWOxjXB0c1Q+Iin2AdfFN/hNj8vdZaeYPqs1MYJFM=;
        b=H6jsCT7FQUunbxAIzvE/bXBTaV3cWfctrbhV1lRMpersaA16hXNsXmnbEfRzn5goTK
         4Yoc51qiwmGauMVnaXjZcBo5RK6E62KJ4SEgMTuunpVEJ66k0q4ih4oDrE4/wggXBOuK
         /ZD1oWi05e579f6S205igomM6NgY75EV1izwJCEmhAsqj5bz1GMi4cNt5E6aMXCv2klc
         doKrnEOmm6EfF+3b2YAELD+4WEDtoJcdTxhkDIqJNiHs5sSwNI2hTKChKkz8q232ZFbb
         3ZfgUD+mO4xVjdR2yC8Pxo5Jk2jZrfcElDs4cqm78UVwGpZV3RD5jlglbM7rbCQQeiUj
         c29A==
X-Gm-Message-State: AOAM530BnNFNfihftm3lzKGeK5hQxtDEupFWl8wE6tdWkqO+tGVSEKuO
        HRfUNZPMEy+aouByRHlYb8i4FlJOV45o3NigM9hp66omryGHjcRwHMncNHoHeOvJMgNCgBqg+FA
        aMLcBCltRflaNOVtXzvdP+SsR8SIqMKcoPFP/sUn7pt9HPqTxpyb5Y9FcIXK+1Ro=
X-Google-Smtp-Source: ABdhPJyvnRQ/HfZyPNBrat7GEkWvAtGioWVmDrRzxHEBBRYsqehP6RgzsFnAy9bzsGLdalg6fhHEhMSGp9bGnA==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a05:6a00:1346:b0:44d:242a:8151 with SMTP
 id k6-20020a056a00134600b0044d242a8151mr13510744pfu.62.1634327738178; Fri, 15
 Oct 2021 12:55:38 -0700 (PDT)
Date:   Fri, 15 Oct 2021 12:55:30 -0700
In-Reply-To: <20211015195530.301237-1-jmattson@google.com>
Message-Id: <20211015195530.301237-4-jmattson@google.com>
Mime-Version: 1.0
References: <20211015195530.301237-1-jmattson@google.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [kvm-unit-tests PATCH v2 3/3] x86: Add a regression test for L1 LDTR
 persistence bug
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a regression test for Linux commit afc8de0118be ("KVM: nVMX: Set
LDTR to its architecturally defined value on nested VM-Exit"). L1's
LDTR should be 0 after an emulated VM-exit from L2.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 x86/vmx_tests.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 3b97cfa6ed10..6093a90fd4ac 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -8363,6 +8363,44 @@ static void vmentry_movss_shadow_test(void)
 	vmcs_write(GUEST_RFLAGS, X86_EFLAGS_FIXED);
 }
 
+static void vmx_ldtr_test_guest(void)
+{
+	u16 ldtr = sldt();
+
+	report(ldtr == NP_SEL, "Expected %x for L2 LDTR selector (got %x)",
+	       NP_SEL, ldtr);
+}
+
+/*
+ * Ensure that the L1 LDTR is set to 0 on VM-exit.
+ */
+static void vmx_ldtr_test(void)
+{
+	const u8 ldt_ar = 0x82; /* Present LDT */
+	u16 sel = FIRST_SPARE_SEL;
+
+	/* Set up a non-zero L1 LDTR prior to VM-entry. */
+	set_gdt_entry(sel, 0, 0, ldt_ar, 0);
+	lldt(sel);
+
+	test_set_guest(vmx_ldtr_test_guest);
+	/*
+	 * Set up a different LDTR for L2. The actual GDT contents are
+	 * irrelevant, since we stuff the hidden descriptor state
+	 * straight into the VMCS rather than reading it from the GDT.
+	 */
+	vmcs_write(GUEST_SEL_LDTR, NP_SEL);
+	vmcs_write(GUEST_AR_LDTR, ldt_ar);
+	enter_guest();
+
+	/*
+	 * VM-exit should clear LDTR (and make it unusable, but we
+	 * won't verify that here).
+	 */
+	sel = sldt();
+	report(!sel, "Expected 0 for L1 LDTR selector (got %x)", sel);
+}
+
 static void vmx_single_vmcall_guest(void)
 {
 	vmcall();
@@ -10724,6 +10762,7 @@ struct vmx_test vmx_tests[] = {
 	/* VMCS Shadowing tests */
 	TEST(vmx_vmcs_shadow_test),
 	/* Regression tests */
+	TEST(vmx_ldtr_test),
 	TEST(vmx_cr_load_test),
 	TEST(vmx_cr4_osxsave_test),
 	TEST(vmx_nm_test),
-- 
2.33.0.1079.g6e70778dc9-goog

