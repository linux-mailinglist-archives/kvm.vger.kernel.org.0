Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF7AC36773B
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 04:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234814AbhDVCMu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 22:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234627AbhDVCMb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 22:12:31 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EE46C06138C
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 19:11:57 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id v3-20020a05690204c3b02904e65b70792dso18391919ybs.1
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 19:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=aWI/oX9oWB/hl9QdG+c4lHwJM0nKmk+pq/bbva7Q8do=;
        b=F5XDDthI3v7lBZni4HzRvwmxbRK+QBMmfBrbmdlKYrxUcEeBzdil91bvCqSwqnP6BJ
         7Y2I0cpm2qKqiwlXTiOPbe94FNgQDJsMzjJw8fNYxE0NqdOYoQCdQ+dcIDNxjn+Bc9z3
         BJQ3/GdQymrk1VXrKbFANWGvJJEDzy/Nai75KPGWBrZazai9yCzM2/fh7tLN0qhid37J
         cU44VLXqF34QAuzAQ16I4hBOZj3E8GUb+xKYbkQZrS5lr2GzGDtD4761kTFNlqh3IXul
         ttJbAsPzV1vHPtMGNhBWSM3C+P9LS1LygqvoOm1/uZAQp+/HCsZLnruDRVTxr4Lubn5H
         FKGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=aWI/oX9oWB/hl9QdG+c4lHwJM0nKmk+pq/bbva7Q8do=;
        b=WQcfdGKrkTFN0zdSrCuqzXZwNkNW8t+UqnR8tbVto8UHvsG4UHLsTTbGsSCVZoENBs
         qDHeA47x1ZjxRtLVcK8kyDPCNsqD9xKLqYlf/oBBBSUah12zPOJuJYgt0diJ8dZnutY7
         1uzJBpmQgzESdU+FUFeOvIZWubHMS9kaanujNf+NCF3+8KvwWMXcqI34mguiRFeNGMH8
         IipEPQwm55xM0POso94h4maOicOCfGMmJHb7ewkVG9QZN2f/7JwEsccc6Hf9Nl4f9nyG
         xk7zLqp9lD3UWGy7iZYO5SHMOljRoQlguqNiF37+w3YfMMDQZSHCOji6ntG3uOXKSToK
         j7rw==
X-Gm-Message-State: AOAM533qCnh8BNTH+p954Gg2Taa5gshAdUN9hjuHAJbSmozJbDJcPcuV
        fzpoe8Z3KX0xeAU+idNZQXjsSs+hzJw=
X-Google-Smtp-Source: ABdhPJyMfd9ZDN8qlRdlHxrqdYLXMVflXu6wRslMAp5U4iF+w+rZvNT4XHi0I8J9Pmek9LZ1NAwAJKjtjgk=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e012:374c:592:6194])
 (user=seanjc job=sendgmr) by 2002:a5b:452:: with SMTP id s18mr1418504ybp.482.1619057516481;
 Wed, 21 Apr 2021 19:11:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Apr 2021 19:11:23 -0700
In-Reply-To: <20210422021125.3417167-1-seanjc@google.com>
Message-Id: <20210422021125.3417167-14-seanjc@google.com>
Mime-Version: 1.0
References: <20210422021125.3417167-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH v5 13/15] KVM: SVM: Drop redundant svm_sev_enabled() helper
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

Replace calls to svm_sev_enabled() with direct checks on sev_enabled, or
in the case of svm_mem_enc_op, simply drop the call to svm_sev_enabled().
This effectively replaces checks against a valid max_sev_asid with checks
against sev_enabled.  sev_enabled is forced off by sev_hardware_setup()
if max_sev_asid is invalid, all call sites are guaranteed to run after
sev_hardware_setup(), and all of the checks care about SEV being fully
enabled (as opposed to intentionally handling the scenario where
max_sev_asid is valid but SEV enabling fails due to OOM).

Reviewed by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 6 +++---
 arch/x86/kvm/svm/svm.h | 5 -----
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 68999085db6e..4440459cf8e3 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1457,7 +1457,7 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	struct kvm_sev_cmd sev_cmd;
 	int r;
 
-	if (!svm_sev_enabled() || !sev_enabled)
+	if (!sev_enabled)
 		return -ENOTTY;
 
 	if (!argp)
@@ -1844,7 +1844,7 @@ void __init sev_hardware_setup(void)
 
 void sev_hardware_teardown(void)
 {
-	if (!svm_sev_enabled())
+	if (!sev_enabled)
 		return;
 
 	bitmap_free(sev_asid_bitmap);
@@ -1855,7 +1855,7 @@ void sev_hardware_teardown(void)
 
 int sev_cpu_init(struct svm_cpu_data *sd)
 {
-	if (!svm_sev_enabled())
+	if (!sev_enabled)
 		return 0;
 
 	sd->sev_vmcbs = kcalloc(max_sev_asid + 1, sizeof(void *), GFP_KERNEL);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 0af638f97b5f..f455784519d7 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -568,11 +568,6 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
 
 extern unsigned int max_sev_asid;
 
-static inline bool svm_sev_enabled(void)
-{
-	return IS_ENABLED(CONFIG_KVM_AMD_SEV) ? max_sev_asid : 0;
-}
-
 void sev_vm_destroy(struct kvm *kvm);
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp);
 int svm_register_enc_region(struct kvm *kvm,
-- 
2.31.1.498.g6c1eba8ee3d-goog

