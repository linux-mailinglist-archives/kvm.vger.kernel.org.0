Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AACBB3EF690
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 02:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237119AbhHRAKM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 20:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235474AbhHRAKK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 20:10:10 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D5DFC0613C1
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 17:09:36 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id w200-20020a25c7d10000b02905585436b530so916389ybe.21
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 17:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=XnfybGu+87+miuQ86Eq90I+xRdQ1e4VAwRlrC+XjLzk=;
        b=XgNza7n/eBbTQj3WntMfw2QRiUqB9GvNLflMu+AZJIFJKiW7sfwXG/2AM1ATlk/6WT
         LuHCAEIKUmbW+CVvvVJHsruNkQughuFg4yGsyXi7YJvCs6jRUhiPiTteMIY+I48E5o94
         Qp7bO6SHaEPOVxZm2jYXUdCTTqEni6D2mAVnypXthNAKzYgnOogDHwBiGHZ4Bd1OuboZ
         G+/H88OQ8+FeVz3LI71gV830n7mzK1KSEuEwwiCsFY+XUHgCRavYMmBLxODgpOFUyis4
         /pXsPoUsiWgmgvE0ulTyZZjVaG1QChWzE6YOFWKLk97RGDrdkyWVQSF6MMphwC0fbekD
         rZ7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=XnfybGu+87+miuQ86Eq90I+xRdQ1e4VAwRlrC+XjLzk=;
        b=eFIMKNpzgaQwdAY4Z2zhqkuUfipGTW/I2uNr14j7l3rAIreV8RkrI1J7BHJCEpcGQt
         8x1+4XoR66wzUrskz2BN3AswMDsIGfgFJsksJNz7EW33ehsz2bD6+79wWM3qfTdJ23rA
         W0Q878utZPwPBsYlHusSucAYUjClN51kDCxQ4W+pVlCOIGbyvNt5Egpa6Aibk+SdEwQA
         PRh8xKjL+M3cNkiSNjw96BMWWbYQPknFu/i21IxjEyWGglZ4MqGBn4ehUladPnUlcuyC
         nY1EHYRGgcJqekrXryirvTf8d8Y2+w1hu2KxqcdZ2Z1W+BXs6qjLSsONsuGzm7jrltv0
         M21Q==
X-Gm-Message-State: AOAM530zUap3c3LbplPdJwTRyYrGXlEnUpnsUOuLRIgLwsb5fY5y9Wfk
        Fy3QFTg0+57IBpAxSvk/VQsZm8HErK4SC8Wsu0fzj7XKu8xKXYGiUBqYqCmA4HID/mZi43+dUci
        CHhLTxtCN8qKlbnRIGPe0WmsSg5KU3tAft6knm1exlp3E0jcssSE22izNAQZzU1EXKHz1
X-Google-Smtp-Source: ABdhPJxJs+cdGwBSSDC+W6+6aEv9a4ThOuIiF2WTK0U5++zBh3G9P9uW/IjdQhPAndiw4bYTupyLQ8AE4NUA4BRq
X-Received: from zxwang42.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2936])
 (user=zixuanwang job=sendgmr) by 2002:a25:c056:: with SMTP id
 c83mr6143702ybf.228.1629245375575; Tue, 17 Aug 2021 17:09:35 -0700 (PDT)
Date:   Wed, 18 Aug 2021 00:09:01 +0000
In-Reply-To: <20210818000905.1111226-1-zixuanwang@google.com>
Message-Id: <20210818000905.1111226-13-zixuanwang@google.com>
Mime-Version: 1.0
References: <20210818000905.1111226-1-zixuanwang@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [kvm-unit-tests RFC 12/16] x86 AMD SEV-ES: Check SEV-ES status
From:   Zixuan Wang <zixuanwang@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de,
        Zixuan Wang <zixuanwang@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This commit provides initial start up code for KVM-Unit-Tests to run in
an SEV-ES guest VM. This start up code checks if SEV-ES feature is
supported and enabled for the guest.

In this commit, KVM-Unit-Tests can pass the SEV-ES check and enter
setup_efi() function, but crashes in setup_gdt_tss(), which will be
fixed by follow-up commits.

Signed-off-by: Zixuan Wang <zixuanwang@google.com>
---
 lib/x86/amd_sev.c | 11 +++++++++++
 lib/x86/amd_sev.h |  9 +++++++--
 lib/x86/setup.c   | 16 ++++++++++++++++
 3 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/lib/x86/amd_sev.c b/lib/x86/amd_sev.c
index 535f0e8..a31d352 100644
--- a/lib/x86/amd_sev.c
+++ b/lib/x86/amd_sev.c
@@ -44,6 +44,17 @@ EFI_STATUS setup_amd_sev(void)
 	return EFI_SUCCESS;
 }
 
+#ifdef CONFIG_AMD_SEV_ES
+EFI_STATUS setup_amd_sev_es(void){
+	/* Test if SEV-ES is enabled */
+	if (!(rdmsr(MSR_SEV_STATUS) & SEV_ES_ENABLED_MASK)) {
+		return EFI_UNSUPPORTED;
+	}
+
+	return EFI_SUCCESS;
+}
+#endif /* CONFIG_AMD_SEV_ES */
+
 unsigned long long get_amd_sev_c_bit_mask(void)
 {
 	return 1ull << amd_sev_c_bit_pos;
diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
index e1ef777..a2eccfc 100644
--- a/lib/x86/amd_sev.h
+++ b/lib/x86/amd_sev.h
@@ -32,10 +32,15 @@
 /* AMD Programmer's Manual Volume 2
  *   - Section "SEV_STATUS MSR"
  */
-#define MSR_SEV_STATUS   0xc0010131
-#define SEV_ENABLED_MASK 0b1
+#define MSR_SEV_STATUS      0xc0010131
+#define SEV_ENABLED_MASK    0b1
+#define SEV_ES_ENABLED_MASK 0b10
 
 EFI_STATUS setup_amd_sev(void);
+#ifdef CONFIG_AMD_SEV_ES
+EFI_STATUS setup_amd_sev_es(void);
+#endif /* CONFIG_AMD_SEV_ES */
+
 unsigned long long get_amd_sev_c_bit_mask(void);
 unsigned long long get_amd_sev_c_bit_pos(void);
 
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index aaa1cce..d29f415 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -231,6 +231,22 @@ EFI_STATUS setup_efi_pre_boot(UINTN *mapkey, efi_bootinfo_t *efi_bootinfo)
 		}
 		return status;
 	}
+
+#ifdef CONFIG_AMD_SEV_ES
+	status = setup_amd_sev_es();
+	if (EFI_ERROR(status)) {
+		printf("setup_amd_sev_es() failed: ");
+		switch (status) {
+		case EFI_UNSUPPORTED:
+			printf("SEV-ES is not supported\n");
+			break;
+		default:
+			printf("Unknown error\n");
+			break;
+		}
+		return status;
+	}
+#endif /* CONFIG_AMD_SEV_ES */
 #endif /* CONFIG_AMD_SEV */
 
 	return EFI_SUCCESS;
-- 
2.33.0.rc1.237.g0d66db33f3-goog

