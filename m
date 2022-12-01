Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0AE263FBFF
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 00:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbiLAX2W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 18:28:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231708AbiLAX1t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 18:27:49 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE8FACCED8
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 15:27:17 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id c10-20020a17090aa60a00b00212e91df6acso2941957pjq.5
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 15:27:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=T4fKy3rsoDeg9TcItgm719DIQWhJRDtEiEGAdRW9bCs=;
        b=BlKLkceE/MZzKU1chFtrlSK8BRam4GW1b+pEyW8oCQsRojYO+kFKCToEPx4UQQRweG
         q9MvoW7cjJbdcO4Gv9BYOu4/II6TPltvYOy2zCoxKE4Wr5vZEYObcLExn+/TJqgxLCwR
         ObMfEyhtP5H8QHkFsRqCNAD3tus2yhawcBHu3bXzcGte0zk1r0YZ4JYi8oLZ9k7LKYRu
         5nZQoBma6hoh08WelfwSv5FgVK6G3NAVm2YSRUg7Ev5tR/f1LMXz0szwD0O7ZNnSwhg0
         7rEaHiNYNnp1OcyMH0hOskiAO3CUMlSW02MfQkeyE7g8dujy67jAZC5+ke3bg7W7xrmS
         A5uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T4fKy3rsoDeg9TcItgm719DIQWhJRDtEiEGAdRW9bCs=;
        b=ve7XIpcOfMbo1YKyj0Li8BhpItTcJocQI7JoSDfKDczmXBEqDXIMIa7hMipYgguXs7
         G/51hvWySCqc/zz78tkkKtp3pucniXFDDdKRmrmq5oVZ5QcpSjz5RkWBmdmnbgDlWoqX
         /b2WTvo3FvFr1hSIYx0npQeQEy9pFTcxvWOBMS2KH9VyA46Ma4yW5i26kz8j/Y29nl2a
         3dbHMU0NrkVD0XGc/PTBcO6g8nmxyR4arEWQJ7FiYPWy87qfw4lVpbDKavUFw9ohST+J
         9ANWctCJkTTD5ukaPyoQ2Dov/jvh5fSGiT7OvfcHQjzoZ7ZZjSTQW+HyBEjyC7UxLy5R
         WVuA==
X-Gm-Message-State: ANoB5plw+45hdSaxygMTz4wque29/61saaW6fsyAgEG+DIun5c7sCHYF
        O2ijbhHevNoG2fLGtK9pvVyT5pv80mI=
X-Google-Smtp-Source: AA0mqf5usr/pO/baVlQfScpjJx3z2ov/8/MiXiFA/IdjyZbPp4o0eX12ADXBEcXlx4QR/AKgsuyG+Ood2ts=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:dd82:b0:212:fdb1:720b with SMTP id
 l2-20020a17090add8200b00212fdb1720bmr79232894pjv.66.1669937237499; Thu, 01
 Dec 2022 15:27:17 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  1 Dec 2022 23:26:48 +0000
In-Reply-To: <20221201232655.290720-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221201232655.290720-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221201232655.290720-10-seanjc@google.com>
Subject: [PATCH 09/16] x86/virt: KVM: Open code cpu_has_vmx() in KVM VMX
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Andrew Cooper <Andrew.Cooper3@citrix.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fold the raw CPUID check for VMX into kvm_is_vmx_supported(), its sole
user.  Keep the check even though KVM also checks X86_FEATURE_VMX, as the
intent is to provide a unique error message if VMX is unsupported by
hardware, whereas X86_FEATURE_VMX may be clear due to firmware and/or
kernel actions.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/virtext.h | 10 ----------
 arch/x86/kvm/vmx/vmx.c         |  2 +-
 2 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/virtext.h b/arch/x86/include/asm/virtext.h
index 97349410c937..c5df63c606be 100644
--- a/arch/x86/include/asm/virtext.h
+++ b/arch/x86/include/asm/virtext.h
@@ -22,14 +22,6 @@
 /*
  * VMX functions:
  */
-
-static inline int cpu_has_vmx(void)
-{
-	unsigned long ecx = cpuid_ecx(1);
-	return test_bit(5, &ecx); /* CPUID.1:ECX.VMX[bit 5] -> VT */
-}
-
-
 /**
  * cpu_vmxoff() - Disable VMX on the current CPU
  *
@@ -61,8 +53,6 @@ static inline int cpu_vmx_enabled(void)
 }
 
 /** Disable VMX if it is enabled on the current CPU
- *
- * You shouldn't call this if cpu_has_vmx() returns 0.
  */
 static inline void __cpu_emergency_vmxoff(void)
 {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6f3ade75a670..5bdcae435897 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2713,7 +2713,7 @@ static bool kvm_is_vmx_supported(void)
 {
 	int cpu = raw_smp_processor_id();
 
-	if (!cpu_has_vmx()) {
+	if (!(cpuid_ecx(1) & feature_bit(VMX))) {
 		pr_err("VMX not supported by CPU %d\n", cpu);
 		return false;
 	}
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

