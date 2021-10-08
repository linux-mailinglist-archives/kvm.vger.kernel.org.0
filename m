Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB6AA427304
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 23:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243458AbhJHV06 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 17:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243459AbhJHV05 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 17:26:57 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62989C061570
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 14:25:01 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id oj6-20020a17090b4d8600b001a0596b80b2so2324110pjb.9
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 14:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=eW7SeQiMofHKuRGbbPMYPoEEDHp28bXQjINmApR3c3g=;
        b=EVR/c9IzFbIeaLfuP3JGsRjva5sqBYKlDOqPgYNdSCkyxNhEtI4yvZLNWIpFq06kxB
         B2k/bwvLdSpTbnDKsETCV2rW3k3z5rqhpGxOXX/W7EO0Bx6ePPTvBFXsXv9vkx6tn5SI
         yiAwuVFjRVEZu66ELUgzDRoqrwgz6BJp4cEWCnKBiKe9WY6mGCgHD3BYLiVTMoPlZwMQ
         5m3wYOhPrVI0hN7YpG0ofCc9gkxR1MuhCf9RhETjfFS1TGPLiUkC8yVz2PMW+YNjLHHe
         ybRJbn8qBrfPyXDFW5ZQElGDwwZjaa01NgKBUqUb6XMX56emsFdSTdBFe3A0uDQRa14q
         ep+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=eW7SeQiMofHKuRGbbPMYPoEEDHp28bXQjINmApR3c3g=;
        b=VKLFLa5xa5ebeE4v/KCLtEW93XDUbwUGMiROaXp38yfA8Clcq+vjuw42VmSGFdKFaO
         MdaMvMh6wiyywyqqwr4l+K8+M/31xVzyMPuyfhmFD6k9X2sa2mhbpON1XcinrKK96sIu
         F3yPB5EZ2mWUfKAr7/5wNEnSmBX606UdUjPW82V3pYbsF9onuAjwLDQmnCzSLsVtka5E
         a0ZnSjyqYR7dbiC4DFdTEWHyDo+NPqAWv99B7JZMRFHNdkLr5x+ENG38l6hfB3Wj2eYN
         IWZG9ZLS44r2u4t2HbZ3oqXSV2iup5gl0uaQIMQTnntUbGwbZy37+0WSrhZcrK6tzQzG
         3AdA==
X-Gm-Message-State: AOAM530xI0Xuuk+hiT7prwN0Yx2trVXviFVHGxefmz9OLkuzOBxkvYSJ
        5Mod2rVDWinz1vwwI7QgY0ZKrjaIMgA4ZZ9TSaNnsLfkAoy43cFfX951vUt+8e9KYqkBNyWIliy
        QpdYsQc5us8eIG5gnIc5AnsoPwAaLFhVNzORei2KzAvRH78i8lGKlpQaDsQ4EiBU=
X-Google-Smtp-Source: ABdhPJygvRMm8x07Yq85OuXd8UvNjrtouIqKGtjT191Ud+FeL2+BsA/Gdv3u6GOUU5BACN2rj8IZjCwi7bHW6w==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a05:6a00:1248:b0:44c:84cd:f795 with SMTP
 id u8-20020a056a00124800b0044c84cdf795mr12592898pfi.79.1633728300671; Fri, 08
 Oct 2021 14:25:00 -0700 (PDT)
Date:   Fri,  8 Oct 2021 14:24:47 -0700
In-Reply-To: <20211008212447.2055660-1-jmattson@google.com>
Message-Id: <20211008212447.2055660-4-jmattson@google.com>
Mime-Version: 1.0
References: <20211008212447.2055660-1-jmattson@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [kvm-unit-tests PATCH 3/3] x86: Add a regression test for L1 LDTR
 persistence bug
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org
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
index 4f712ebccc08..9aafaa786ab6 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -8369,6 +8369,44 @@ static void vmentry_movss_shadow_test(void)
 	vmcs_write(GUEST_RFLAGS, X86_EFLAGS_FIXED);
 }
 
+static void vmx_ldtr_test_guest(void)
+{
+	u16 ldtr = sldt();
+
+	report(ldtr == NP_SEL, "L2 LDTR selector is %x (actual %x)",
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
+	report(!sel, "L1 LDTR selector is 0 (actual %x)", sel);
+}
+
 static void vmx_single_vmcall_guest(void)
 {
 	vmcall();
@@ -10730,6 +10768,7 @@ struct vmx_test vmx_tests[] = {
 	/* VMCS Shadowing tests */
 	TEST(vmx_vmcs_shadow_test),
 	/* Regression tests */
+	TEST(vmx_ldtr_test),
 	TEST(vmx_cr_load_test),
 	TEST(vmx_cr4_osxsave_test),
 	TEST(vmx_nm_test),
-- 
2.33.0.882.g93a45727a2-goog

