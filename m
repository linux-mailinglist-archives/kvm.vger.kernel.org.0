Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B166332F7A1
	for <lists+kvm@lfdr.de>; Sat,  6 Mar 2021 03:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbhCFB7m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 20:59:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbhCFB7Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Mar 2021 20:59:25 -0500
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4720C06175F
        for <kvm@vger.kernel.org>; Fri,  5 Mar 2021 17:59:24 -0800 (PST)
Received: by mail-qt1-x84a.google.com with SMTP id t5so3273500qti.5
        for <kvm@vger.kernel.org>; Fri, 05 Mar 2021 17:59:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=dbGf2sFPrKUPGT4uEZ+Wu4j2K44kxAvtE1nu1LazwmA=;
        b=FcTwOfg/HVrfBNyD7EtGEbhNNeD4nJ7B/nGn6bjTwPe1UreEwxF1Qvne5MI8RmMh+L
         XrInuTOe992oIWYNj95VOJNuskFeKjn8mT9W+MnYGvPb4IwFDZ8zNAVMEA2AK6sVW3Zx
         wtpHZB0+26JxLmREzihxKLrPgkLfyhNcJBDeTD4ZXd+AUuy8+C46xmiOCHq9Niw9TqPO
         OlaG94ugYcpy7eJ5AREom1hnkUfpNcVWIX628ASQp20jfiU3S89WBH1VxwR/s3wLnt9a
         ZS6vYEheFUjFG8D2s+AoTrHzZFqjEcaA7uUjHYNnkzh9c5ao6PNkUAvdaV7J0sNV2Sj1
         G4zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=dbGf2sFPrKUPGT4uEZ+Wu4j2K44kxAvtE1nu1LazwmA=;
        b=FfhVFeK9p4OVySHJb1wwXfGq4NO4yVTfskYspFJ43jIBzExeDtkd9IDSV/RMnJc6GF
         diMReenIhm94oH/XmHw6ueQCK44t0jTE+Ckr4FyZtJakmou9ZamEk89MEGiyepml4KDG
         3AQXI8bRjGCS6vRKR5BFP/zZSfbHm0Rqnj1ERe38skDZW+DpYvRZpzlFMFxX/sLHU8bb
         NEtP6CE4ijqnqb2cKzLi6uvy6vgE9883U4d5Z6qYrhkdfnf4uGv+8xibgBZlAxEQbRlW
         fvX9AV9cHNSt3NKtPknal/WoL8p5w4Jb3L1wuWKwEPd/1fb/+G3CtKxU8EHdQ8CdHnKp
         cwVA==
X-Gm-Message-State: AOAM533GZmDzZgRKNuQdp1Bg4tq5v7NgTtGX/E9Y+pGAxj4BZE4kNVho
        oScO9YxTQA9Cry9kMxIGbHVmgNIdDIs=
X-Google-Smtp-Source: ABdhPJyp8HGmbS9rp7NhF11FjFbJffbQH5paiwL07hLttoCCGpctkJCJOSo75f5IiPWP4WcqZxi5q5NQbOw=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:fc04:f9df:1efb:bf0c])
 (user=seanjc job=sendgmr) by 2002:a05:6214:180d:: with SMTP id
 o13mr11612431qvw.10.1614995964026; Fri, 05 Mar 2021 17:59:24 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  5 Mar 2021 17:58:54 -0800
In-Reply-To: <20210306015905.186698-1-seanjc@google.com>
Message-Id: <20210306015905.186698-4-seanjc@google.com>
Mime-Version: 1.0
References: <20210306015905.186698-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v4 03/14] KVM: SVM: Move SEV module params/variables to sev.c
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

Unconditionally invoke sev_hardware_setup() when configuring SVM and
handle clearing the module params/variable 'sev' and 'sev_es' in
sev_hardware_setup().  This allows making said variables static within
sev.c and reduces the odds of a collision with guest code, e.g. the guest
side of things has already laid claim to 'sev_enabled'.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 11 +++++++++++
 arch/x86/kvm/svm/svm.c | 15 +--------------
 arch/x86/kvm/svm/svm.h |  2 --
 3 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 5533f37ce50e..871e040aad16 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -28,6 +28,14 @@
 
 #define __ex(x) __kvm_handle_fault_on_reboot(x)
 
+/* enable/disable SEV support */
+static int sev = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
+module_param(sev, int, 0444);
+
+/* enable/disable SEV-ES support */
+static int sev_es = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
+module_param(sev_es, int, 0444);
+
 static u8 sev_enc_bit;
 static int sev_flush_asids(void);
 static DECLARE_RWSEM(sev_deactivate_lock);
@@ -1324,6 +1332,9 @@ void __init sev_hardware_setup(void)
 	bool sev_es_supported = false;
 	bool sev_supported = false;
 
+	if (!IS_ENABLED(CONFIG_KVM_AMD_SEV) || !sev)
+		goto out;
+
 	/* Does the CPU support SEV? */
 	if (!boot_cpu_has(X86_FEATURE_SEV))
 		goto out;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 01ce8ac77a07..6dd8bcf3e8fa 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -190,14 +190,6 @@ module_param(vls, int, 0444);
 static int vgif = true;
 module_param(vgif, int, 0444);
 
-/* enable/disable SEV support */
-int sev = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
-module_param(sev, int, 0444);
-
-/* enable/disable SEV-ES support */
-int sev_es = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
-module_param(sev_es, int, 0444);
-
 bool __read_mostly dump_invalid_vmcb;
 module_param(dump_invalid_vmcb, bool, 0644);
 
@@ -972,12 +964,7 @@ static __init int svm_hardware_setup(void)
 		kvm_enable_efer_bits(EFER_SVME | EFER_LMSLE);
 	}
 
-	if (IS_ENABLED(CONFIG_KVM_AMD_SEV) && sev) {
-		sev_hardware_setup();
-	} else {
-		sev = false;
-		sev_es = false;
-	}
+	sev_hardware_setup();
 
 	svm_adjust_mmio_mask();
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 39e071fdab0c..aec70f6cd243 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -387,8 +387,6 @@ static inline bool gif_set(struct vcpu_svm *svm)
 /* svm.c */
 #define MSR_INVALID				0xffffffffU
 
-extern int sev;
-extern int sev_es;
 extern bool dump_invalid_vmcb;
 
 u32 svm_msrpm_offset(u32 msr);
-- 
2.30.1.766.gb4fecdf3b7-goog

