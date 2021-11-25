Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB4EF45D2C9
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 03:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353441AbhKYCFB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:05:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352870AbhKYCDA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 21:03:00 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33BECC0619E8
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:54 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id w2-20020a627b02000000b0049fa951281fso2535586pfc.9
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=hUKQ7m53qMfc26S+Ac4M63+D9+4SotvfDsEQbu2jLik=;
        b=Q9GY1R8fZ8EIanY+DXM0N3WjTGvuSjTCWwB2G6bkPrqGbi6m3tKeHx23SHMF4AXuKg
         OUkA1k43NGlC+u2DgMYtjxscgHu63ZPmjHT4mdFArQnSii+UlaqHVRz6b5UHF09zvhVE
         2QALEp1wJiAfTw9p13RtUD8MVGDCcPXW91mT/UN5GteRRZUWvrL67VGv/yFKB1oZHbxN
         9uwEOpUxgqlSDWoRbYkJwo8Z9go59PjI1zKwtmXWo50fVYhfNMMktchgoXKUtdjuqgiN
         AiR/VEu4C0AB3cQ+GpDv87jjZLqk1uJ9lGg6myQXIyv16oIQOTPmjoTsQYqIBm1gOtkt
         ExcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=hUKQ7m53qMfc26S+Ac4M63+D9+4SotvfDsEQbu2jLik=;
        b=xhJLy9ENpVFIassonpklLZcoSaEWgVV03dJvQlt3y4oGtoTKy2PE9Wcv6xCp+Gt521
         09ZTa9dzmnKTxl3NitQNVAtGXia2SnV8cD3Go6O9m1IUoggiORDPnyvYHb8mDbr5rM6J
         9OqIOSztEmvis8eRZWC7lV2IzWmcoOhMV3XpRkwz1LERXy4vpHrx6pn2aJYfVVKFa760
         Z6f5WyA2UjGNHnh6mgDPvMghseSCa5HAV9kGKXJ5nJ9DPlogMTp8eFIFvhlswbqnJPll
         jF7p8FQ0766nk8V1Sv2xcaidhyZj1lWd49d2v+O22GPwwIxMO/WkKMiqvaTjqyZzo9Of
         S/lw==
X-Gm-Message-State: AOAM532XRKMLCN/QY3XpcI98K5BpfGWsshyzxrFZxujxd+MmaInbe3jG
        R11YoM9Az7S0HMnL/I8yapry0ZtjnCM=
X-Google-Smtp-Source: ABdhPJy1ZB8VngI90e3JcVL3Ucn8NNoQoxDeRmivBDYfXOm0YCcJ6IzmZi27+3MgWJDw4uNgGkDsBlQniCs=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a63:4a63:: with SMTP id j35mr14029124pgl.409.1637803793710;
 Wed, 24 Nov 2021 17:29:53 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Nov 2021 01:28:51 +0000
In-Reply-To: <20211125012857.508243-1-seanjc@google.com>
Message-Id: <20211125012857.508243-34-seanjc@google.com>
Mime-Version: 1.0
References: <20211125012857.508243-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [kvm-unit-tests PATCH 33/39] nVMX: Add helpers to check for 4/5-level
 EPT support
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add helpers to check for 4-level and 5-level EPT support.  Yet another
baby step toward removing unnecessary RDMSRs...

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx.h       | 10 ++++++++++
 x86/vmx_tests.c |  4 ++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/x86/vmx.h b/x86/vmx.h
index 9f91602..e6126e4 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -815,6 +815,16 @@ static inline bool ept_ad_bits_supported(void)
 	return ept_vpid.val & EPT_CAP_AD_FLAG;
 }
 
+static inline bool is_4_level_ept_supported(void)
+{
+	return ept_vpid.val & EPT_CAP_PWL4;
+}
+
+static inline bool is_5_level_ept_supported(void)
+{
+	return ept_vpid.val & EPT_CAP_PWL5;
+}
+
 static inline bool is_invept_type_supported(u64 type)
 {
 	if (type < INVEPT_SINGLE || type > INVEPT_GLOBAL)
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 116ae66..2bfc794 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -4735,7 +4735,7 @@ static void test_ept_eptp(void)
 		wr_bk = true;
 
 	/* Support for 4-level EPT is mandatory. */
-	report(msr & EPT_CAP_PWL4, "4-level EPT support check");
+	report(is_4_level_ept_supported(), "4-level EPT support check");
 
 	primary |= CPU_SECONDARY;
 	vmcs_write(CPU_EXEC_CTRL0, primary);
@@ -4784,7 +4784,7 @@ static void test_ept_eptp(void)
 	for (i = 0; i < 8; i++) {
 		eptp = (eptp & ~EPTP_PG_WALK_LEN_MASK) |
 		    (i << EPTP_PG_WALK_LEN_SHIFT);
-		if (i == 3 || (i == 4 && (msr & EPT_CAP_PWL5)))
+		if (i == 3 || (i == 4 && is_5_level_ept_supported()))
 			ctrl = true;
 		else
 			ctrl = false;
-- 
2.34.0.rc2.393.gf8c9666880-goog

