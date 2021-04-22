Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C757A367733
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 04:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234312AbhDVCMa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 22:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234149AbhDVCMU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 22:12:20 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A893BC06138B
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 19:11:46 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id e13-20020a25d30d0000b02904ec4109da25so18066122ybf.7
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 19:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=M+EV17K09Jw3Z2+bqjVXisuWTECXp2lypwrOyx6edfg=;
        b=WdjBYY714q1SkVGA3+8FJWIs7t1KO+Td1j8qqTAn2t8XbOY4FwT+cb3XDSglS/CmN3
         /h1eIwTnx4MMBV2bpq08Ovt1fNSVKIMnzfVDOMYAJoiNZLBTnooWjA/iynUcYuPZ3nE6
         2f+jOOGBYLanQ7YHhVNISUNniQ5QXERn5vEvCz0GEODVRwh3fReqBXWjT1PmwoQrIP6c
         /b31qsu+5OEQXl0HVKoY45f4Paur5Cfw1LvBxMcMza/PDZEjS1Ph162g7lZjfK8zlAdQ
         WCs/914EiqBCwBu4PU7d/rW+vDkl6cZ2Abnaj+shbydw0uf/azp7/Nvm1FAjBprdCYjM
         B6zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=M+EV17K09Jw3Z2+bqjVXisuWTECXp2lypwrOyx6edfg=;
        b=tsH+Jg0YUQ1fwrD6yNDfZ/T2BXbQ9bc5mIQZ3qzi4f7btBG3mu/aDJ7YoXGOaRicfI
         w+i0mQ/LC1XH6lXH+SON4M3kYOMAUouy7jnpFTwrNfi/HvDid652pJ5ShxU1zP2Ce3cS
         R38M1P6V5y4wK5rWZzTGewtxJR7YH5XCm6MjH8/pow293Eujd4Betzl7r1YqtZf8NcZ9
         3TPSGQ1n/yimOr9VCYyMnlmn19g1oLBK1PUwl26g9Cy7EOyRHNINlLEWoLL/qIVQmjME
         0jSZeJuMTsa0dg1K1wY+Kfqi5++7GE0yJRO1UHAIfDJaVd6MDqxQ8tQPM9HrU5CiTwz9
         ZOqg==
X-Gm-Message-State: AOAM530BKvTi8BtRQZ05GivABr4pcMXF7tAw2oJxV6YgRvXeyD04ZOro
        qsxmOZ8GyvOtqP3ITM59iERx+j1WDo0=
X-Google-Smtp-Source: ABdhPJzmkoZ/wR2M9/j0Oli7wOyopQFHQ7eWa7OLjd19YvFmX/zlUayyAhTAzAPlMHL6YWbvEXW5EyhunF8=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e012:374c:592:6194])
 (user=seanjc job=sendgmr) by 2002:a25:3251:: with SMTP id y78mr1332201yby.455.1619057505890;
 Wed, 21 Apr 2021 19:11:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Apr 2021 19:11:18 -0700
In-Reply-To: <20210422021125.3417167-1-seanjc@google.com>
Message-Id: <20210422021125.3417167-9-seanjc@google.com>
Mime-Version: 1.0
References: <20210422021125.3417167-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH v5 08/15] KVM: SVM: Condition sev_enabled and sev_es_enabled
 on CONFIG_KVM_AMD_SEV=y
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Define sev_enabled and sev_es_enabled as 'false' and explicitly #ifdef
out all of sev_hardware_setup() if CONFIG_KVM_AMD_SEV=n.  This kills
three birds at once:

  - Makes sev_enabled and sev_es_enabled off by default if
    CONFIG_KVM_AMD_SEV=n.  Previously, they could be on by default if
    CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT=y, regardless of KVM SEV
    support.

  - Hides the sev and sev_es modules params when CONFIG_KVM_AMD_SEV=n.

  - Resolves a false positive -Wnonnull in __sev_recycle_asids() that is
    currently masked by the equivalent IS_ENABLED(CONFIG_KVM_AMD_SEV)
    check in svm_sev_enabled(), which will be dropped in a future patch.

Reviewed by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 9b6adc493cc8..2fe545102d12 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -28,6 +28,7 @@
 
 #define __ex(x) __kvm_handle_fault_on_reboot(x)
 
+#ifdef CONFIG_KVM_AMD_SEV
 /* enable/disable SEV support */
 static bool sev_enabled = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
 module_param_named(sev, sev_enabled, bool, 0444);
@@ -35,6 +36,10 @@ module_param_named(sev, sev_enabled, bool, 0444);
 /* enable/disable SEV-ES support */
 static bool sev_es_enabled = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
 module_param_named(sev_es, sev_es_enabled, bool, 0444);
+#else
+#define sev_enabled false
+#define sev_es_enabled false
+#endif /* CONFIG_KVM_AMD_SEV */
 
 static u8 sev_enc_bit;
 static int sev_flush_asids(void);
@@ -1774,11 +1779,12 @@ void __init sev_set_cpu_caps(void)
 
 void __init sev_hardware_setup(void)
 {
+#ifdef CONFIG_KVM_AMD_SEV
 	unsigned int eax, ebx, ecx, edx;
 	bool sev_es_supported = false;
 	bool sev_supported = false;
 
-	if (!IS_ENABLED(CONFIG_KVM_AMD_SEV) || !sev_enabled || !npt_enabled)
+	if (!sev_enabled || !npt_enabled)
 		goto out;
 
 	/* Does the CPU support SEV? */
@@ -1834,6 +1840,7 @@ void __init sev_hardware_setup(void)
 out:
 	sev_enabled = sev_supported;
 	sev_es_enabled = sev_es_supported;
+#endif
 }
 
 void sev_hardware_teardown(void)
-- 
2.31.1.498.g6c1eba8ee3d-goog

