Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA48B36772D
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 04:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbhDVCMT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 22:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234258AbhDVCMO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 22:12:14 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15B6C06138B
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 19:11:37 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id p9-20020a2574090000b02904e2cb6a90e7so18259805ybc.17
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 19:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=1liYysJ3eeU46p86NlfI13l6frN4VAYxjtKgCgGI5Aw=;
        b=dLZIjckIx4vhaH9jf3s1tvzHBCcevj8tN6o79e/TBuCZp63Nb71kJZ7352CbA2fDBb
         YqEyiY4gmH5NMnkas8bZ8+t5JOU1Afj3+zZCis2puySf+VGyaQirfoqzAGiiPJVcNaKK
         Ye053tyNyW6Ck/1o0J3U/xdLcTB1su/NZq7ZETFh/JNLJj/mDzxKrY//J86tUGbtCo7m
         oUuZIZw4GQnJvbD5OQYMErm6nS74uxRqM70i7U0+2EkFrnX2SBz68pibCSRP6UBTHepV
         RCAxd/iSBp49ZkaB/W+INP49URGxJ6iW6J3RYpiEzZlM3+lF8EYlnF4fpthuhLBkO1+O
         /B7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=1liYysJ3eeU46p86NlfI13l6frN4VAYxjtKgCgGI5Aw=;
        b=RTN+mwQl0tdCBTmr4lNac+oZYTHQMzE3rb1OlixIDknuhJM3vSvHazXLpng1zd6I9o
         wfYBaNr3thBEbVadRAeTYLOdyV3YvhtZX3KVqP9lQu9DrBSl9bBfH5omjjBAIjQNU1aE
         WQWQ7UN9sq8A0c2gVVOjhDi904W4UOhFxB7CMbDsax9CLmQQ/+QZ/gk6jNBGBdvhkjVo
         G2I79sLwFldK14uFQTt7slbAC4I2tSmL41zxX6rYwVW07N5DeyT5tIS/5R118p4WrO3T
         PvJTW/ZTq21mqBZMeeL8M5yoNR72Mjw6aTYffbmhVt6Yap8jcvKZ4Oza5zWp1PYtTefT
         1hSw==
X-Gm-Message-State: AOAM530NBLMXuC0PNVevVZGwNg4sHBIBWfTGhEkmZxtP0KRfI30ZjsOI
        IpgLzH2+Wpa1d2gbekABmqQssPGUY6E=
X-Google-Smtp-Source: ABdhPJyRUxHKU+/NjWtQNBGGkJtV2JE7WE99hyzLjpN02y1vrcLgNlHJ2u+bhZYeLBvJ2m9l5vTNUsgKyiw=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e012:374c:592:6194])
 (user=seanjc job=sendgmr) by 2002:a25:ce4d:: with SMTP id x74mr1353938ybe.217.1619057497202;
 Wed, 21 Apr 2021 19:11:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Apr 2021 19:11:14 -0700
In-Reply-To: <20210422021125.3417167-1-seanjc@google.com>
Message-Id: <20210422021125.3417167-5-seanjc@google.com>
Mime-Version: 1.0
References: <20210422021125.3417167-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH v5 04/15] KVM: SVM: Move SEV module params/variables to sev.c
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
 arch/x86/kvm/svm/svm.c | 16 ++--------------
 arch/x86/kvm/svm/svm.h |  2 --
 3 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 5ff8a202cc01..fb32b93e325c 100644
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
@@ -1762,6 +1770,9 @@ void __init sev_hardware_setup(void)
 	bool sev_es_supported = false;
 	bool sev_supported = false;
 
+	if (!IS_ENABLED(CONFIG_KVM_AMD_SEV) || !sev || !npt_enabled)
+		goto out;
+
 	/* Does the CPU support SEV? */
 	if (!boot_cpu_has(X86_FEATURE_SEV))
 		goto out;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0e8489908216..12b2c04076bb 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -185,14 +185,6 @@ module_param(vls, int, 0444);
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
 
@@ -984,12 +976,8 @@ static __init int svm_hardware_setup(void)
 	kvm_configure_mmu(npt_enabled, get_max_npt_level(), PG_LEVEL_1G);
 	pr_info("kvm: Nested Paging %sabled\n", npt_enabled ? "en" : "dis");
 
-	if (IS_ENABLED(CONFIG_KVM_AMD_SEV) && sev && npt_enabled) {
-		sev_hardware_setup();
-	} else {
-		sev = false;
-		sev_es = false;
-	}
+	/* Note, SEV setup consumes npt_enabled. */
+	sev_hardware_setup();
 
 	svm_adjust_mmio_mask();
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 454da1c1d9b7..ec0407f41458 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -397,8 +397,6 @@ static inline bool gif_set(struct vcpu_svm *svm)
 /* svm.c */
 #define MSR_INVALID				0xffffffffU
 
-extern int sev;
-extern int sev_es;
 extern bool dump_invalid_vmcb;
 
 u32 svm_msrpm_offset(u32 msr);
-- 
2.31.1.498.g6c1eba8ee3d-goog

