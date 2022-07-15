Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F33CF576A48
	for <lists+kvm@lfdr.de>; Sat, 16 Jul 2022 01:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbiGOXAv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 19:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiGOXAY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 19:00:24 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D594AD4F
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 16:00:23 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id q8-20020a17090a304800b001ef82a71a9eso3611513pjl.3
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 16:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=V+ijd0IpTmqqqLjto4/xJJjuTl9mPDgkHleQw8xA900=;
        b=g2f2U6dAMh2svtMNa0Gg+5Wo0SupEJFUQDZb4iOR1xe/N8YGAQMOLjhFPelZfKgo/c
         ey5P2g+Qwc12BJCqJLeZZ27863S5UOGpryHde4e5Z1+5/gk0cH07cYblwVoMeGKubPug
         Q5SWn8SZOfKaTQKlEECe/t/qWODjgKTW49O97PDpDPhy/9oa1bTWWSYNTjALE9yfqGFH
         D1aT+2F0D63s/iwgfYnUdeFxR+XZXlEIlp0EgfgjQsue3DRFxWn70QkWMilm+nOsOXu+
         67VYZ/MdkbCDsj6eJon214a52MGGbx3XX2e2rZwMTAy0CE4OHw8PNeudcRN+Bf2KWINS
         Y24w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=V+ijd0IpTmqqqLjto4/xJJjuTl9mPDgkHleQw8xA900=;
        b=AfSEKS3rOTHG1aoMFwbD2YCbDCMcPGbrXCXzeNXtttAtpoIab8t2DnnMzfbUn04q/1
         fIS4UxUVP0ZcticnWcy431vG6Awj/SmxDe9OEkWCr9I2HKrhQhhxrZQCtPkd5QzxdlKk
         6e+uT74lhKUBekAFpD781OYwRxcH75db2ngsFwY8PnKTrLYem3wmOPTa8XMGGEAjYmCl
         IBpdgvt5Ahk4dxxgEwBZtikoauhrv3P87aHevdgkbQQ5XOyLm3iiQY9BPt9YouLZ5Jf2
         LgtgUAspXK9AnPQwAapwLmrX8zTFUqwrQ/AY0KmvccbZ8bwlRCcpi9RZzgrgBkcboc63
         TnHw==
X-Gm-Message-State: AJIora+mhcPFQg+iBX7SjhPzmRSmHdN4rUtFLphZCcMnaPptjObNe3oT
        qBps21tFZcyxioOx/j1xII0gYQAbyL0=
X-Google-Smtp-Source: AGRyM1tWkRhKexMwNka8pMZLwhRDlIvKyPaqRa57ONwmleNE0JM3aPXeIWSQNInSCOIPyAw8GygZDNqnLQU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:6d05:0:b0:528:99a2:b10 with SMTP id
 i5-20020a626d05000000b0052899a20b10mr16101370pfc.72.1657926022849; Fri, 15
 Jul 2022 16:00:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Jul 2022 23:00:14 +0000
In-Reply-To: <20220715230016.3762909-1-seanjc@google.com>
Message-Id: <20220715230016.3762909-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220715230016.3762909-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH 2/4] KVM: x86: Drop unnecessary goto+label in kvm_arch_init()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Return directly if kvm_arch_init() detects an error before doing any real
work, jumping through a label obfuscates what's happening and carries the
unnecessary risk of leaving 'r' uninitialized.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 12199c40f2bc..41aa3137665c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9146,21 +9146,18 @@ int kvm_arch_init(void *opaque)
 
 	if (kvm_x86_ops.hardware_enable) {
 		pr_err("kvm: already loaded vendor module '%s'\n", kvm_x86_ops.name);
-		r = -EEXIST;
-		goto out;
+		return -EEXIST;
 	}
 
 	if (!ops->cpu_has_kvm_support()) {
 		pr_err_ratelimited("kvm: no hardware support for '%s'\n",
 				   ops->runtime_ops->name);
-		r = -EOPNOTSUPP;
-		goto out;
+		return -EOPNOTSUPP;
 	}
 	if (ops->disabled_by_bios()) {
 		pr_err_ratelimited("kvm: support for '%s' disabled by bios\n",
 				   ops->runtime_ops->name);
-		r = -EOPNOTSUPP;
-		goto out;
+		return -EOPNOTSUPP;
 	}
 
 	/*
@@ -9170,14 +9167,12 @@ int kvm_arch_init(void *opaque)
 	 */
 	if (!boot_cpu_has(X86_FEATURE_FPU) || !boot_cpu_has(X86_FEATURE_FXSR)) {
 		printk(KERN_ERR "kvm: inadequate fpu\n");
-		r = -EOPNOTSUPP;
-		goto out;
+		return -EOPNOTSUPP;
 	}
 
 	if (IS_ENABLED(CONFIG_PREEMPT_RT) && !boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
 		pr_err("RT requires X86_FEATURE_CONSTANT_TSC\n");
-		r = -EOPNOTSUPP;
-		goto out;
+		return -EOPNOTSUPP;
 	}
 
 	/*
@@ -9190,21 +9185,19 @@ int kvm_arch_init(void *opaque)
 	if (rdmsrl_safe(MSR_IA32_CR_PAT, &host_pat) ||
 	    (host_pat & GENMASK(2, 0)) != 6) {
 		pr_err("kvm: host PAT[0] is not WB\n");
-		r = -EIO;
-		goto out;
+		return -EIO;
 	}
 
-	r = -ENOMEM;
-
 	x86_emulator_cache = kvm_alloc_emulator_cache();
 	if (!x86_emulator_cache) {
 		pr_err("kvm: failed to allocate cache for x86 emulator\n");
-		goto out;
+		return -ENOMEM;
 	}
 
 	user_return_msrs = alloc_percpu(struct kvm_user_return_msrs);
 	if (!user_return_msrs) {
 		printk(KERN_ERR "kvm: failed to allocate percpu kvm_user_return_msrs\n");
+		r = -ENOMEM;
 		goto out_free_x86_emulator_cache;
 	}
 	kvm_nr_uret_msrs = 0;
@@ -9235,7 +9228,6 @@ int kvm_arch_init(void *opaque)
 	free_percpu(user_return_msrs);
 out_free_x86_emulator_cache:
 	kmem_cache_destroy(x86_emulator_cache);
-out:
 	return r;
 }
 
-- 
2.37.0.170.g444d1eabd0-goog

