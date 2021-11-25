Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71DA445D2C7
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 03:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353355AbhKYCDU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:03:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353057AbhKYCBM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 21:01:12 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8680FC0619E4
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:47 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id ce19-20020a17090aff1300b001a6f72e2dbdso1683772pjb.7
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=yvEUaS/OEcjyq4fYfb/W6xTPdCIC+9s1zuGcq5whCoQ=;
        b=dUjmtF7frzK7xQ1tq4UovmbCAcWJ3p00JDW94FN82H9Wm5lfDxj37OIbU+zAUQMkHz
         P5WCxS+xRVD3d2wnYdgOoCej200Azh/nMCOGQMOr/I37U5uDl9Y/fAZfl45U1rjEeYj3
         M59oDpX0GcvE7A+y+ep9psYCx7biPOpLpSZ63nsYCIDWT1+OV7GRV95lMj5PsZ5J+nHV
         xdkbwhr+C+8adkJ9FtT44CNyle4Z1E5roYtNF1Bo1vt8NI2geAc3CNft1KIiHCAas5Y/
         rVeHwEADmsvEV795AoW2ujcvCi9ImjlubOVl5r8+/2NX1ZqfP+xws8D1sH3G10w3USMp
         RwTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=yvEUaS/OEcjyq4fYfb/W6xTPdCIC+9s1zuGcq5whCoQ=;
        b=ROWbq7h7HLnH/WyxiUCVRTUGAWhXYgTioXjzWYBZcOXx/jBM9nVQ+uoQqUwklKBV1l
         3njp0RSAkZy+dgDCc3uG499Td1rCdtVD5S70avM8vcW0auhznrAwBQSDfV7e3PEoOGPn
         5asVaacSp4tcWAeTiNdrjTwc9tAXzUHIxkbqJdVK2M3AzAhRgfGwnJ2bWhfgjJ7k3GGK
         ZT/LRoW3jNypYXioiyO17BCoOavDwe51uyji2/AyRgGXhWxYSfhjxjDhuAzfnODoe5U9
         zeWobltVcZstCzxl4sXvBwgB0Gjw6/4acYaE5WT276BWSSYwnp4A8CKW9+sSTyL9dDeT
         hlEA==
X-Gm-Message-State: AOAM530TBTDhgIosvq0OYQaycVKduxkNRKLgce2UCLDeTHIuPAq6OFxs
        5veOFETkJzf80MEjKWOBH2maP4kmIRU=
X-Google-Smtp-Source: ABdhPJzMSONCpQ39yA/7nJ5ncwIYo/1pB3MFvAgERTkKZoXZjXq562xGZDta3NtTl1XFw+n2zjgq6HWHTEA=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:e74a:b0:142:114c:1f1e with SMTP id
 p10-20020a170902e74a00b00142114c1f1emr24943826plf.78.1637803787011; Wed, 24
 Nov 2021 17:29:47 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Nov 2021 01:28:47 +0000
In-Reply-To: <20211125012857.508243-1-seanjc@google.com>
Message-Id: <20211125012857.508243-30-seanjc@google.com>
Mime-Version: 1.0
References: <20211125012857.508243-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [kvm-unit-tests PATCH 29/39] nVMX: Add helper to check if INVVPID
 type is supported
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a helper to deduplicate code, now and in the future, and to avoid a
RDMSR every time a VPID test wants to do a basic functionality check.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx.h       |  8 ++++++++
 x86/vmx_tests.c | 17 +++++------------
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/x86/vmx.h b/x86/vmx.h
index 4936120..289f175 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -823,6 +823,14 @@ static inline bool is_invept_type_supported(u64 type)
 	return ept_vpid.val & (EPT_CAP_INVEPT_SINGLE << (type - INVEPT_SINGLE));
 }
 
+static inline bool is_invvpid_type_supported(unsigned long type)
+{
+	if (type < INVVPID_ADDR || type > INVVPID_CONTEXT_LOCAL)
+		return false;
+
+	return ept_vpid.val & (VPID_CAP_INVVPID_ADDR << (type - INVVPID_ADDR));
+}
+
 extern u64 *bsp_vmxon_region;
 extern bool launched;
 
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 507e485..950f527 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -3161,14 +3161,7 @@ static void ept_access_test_force_2m_page(void)
 
 static bool invvpid_valid(u64 type, u64 vpid, u64 gla)
 {
-	u64 msr = rdmsr(MSR_IA32_VMX_EPT_VPID_CAP);
-
-	TEST_ASSERT(msr & VPID_CAP_INVVPID);
-
-	if (type < INVVPID_ADDR || type > INVVPID_CONTEXT_LOCAL)
-		return false;
-
-	if (!(msr & (1ull << (type + VPID_CAP_INVVPID_TYPES_SHIFT))))
+	if (!is_invvpid_type_supported(type))
 		return false;
 
 	if (vpid >> 16)
@@ -3321,13 +3314,13 @@ static void invvpid_test(void)
 	if (!(msr & VPID_CAP_INVVPID))
 		test_skip("INVVPID not supported.\n");
 
-	if (msr & VPID_CAP_INVVPID_ADDR)
+	if (is_invvpid_type_supported(INVVPID_ADDR))
 		types |= 1u << INVVPID_ADDR;
-	if (msr & VPID_CAP_INVVPID_CXTGLB)
+	if (is_invvpid_type_supported(INVVPID_CONTEXT_GLOBAL))
 		types |= 1u << INVVPID_CONTEXT_GLOBAL;
-	if (msr & VPID_CAP_INVVPID_ALL)
+	if (is_invvpid_type_supported(INVVPID_ALL))
 		types |= 1u << INVVPID_ALL;
-	if (msr & VPID_CAP_INVVPID_CXTLOC)
+	if (is_invvpid_type_supported(INVVPID_CONTEXT_LOCAL))
 		types |= 1u << INVVPID_CONTEXT_LOCAL;
 
 	if (!types)
-- 
2.34.0.rc2.393.gf8c9666880-goog

