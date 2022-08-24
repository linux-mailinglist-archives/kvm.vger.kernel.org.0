Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60CF459F1AD
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 05:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234008AbiHXDDo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 23:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234376AbiHXDDI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 23:03:08 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B3C80363
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:01:48 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id k16-20020a635a50000000b0042986056df6so6907610pgm.2
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=UZJytL5MJMz9s/bQcRB6Fp79579HOUS3QPL/VGz+lBA=;
        b=PvE7zUQJbpOgzkDfM4l7ivL4NwIXXNHpU+0wx6jnKsass9WTQdagByTedADjKVCZJe
         0dbaxa8yUkU6nP7nijBTRbvYmrCZ4KpiNTX2I/4IWKBC9Bu3egDu6SGdLcEWLlJsXZNK
         p8CdIG0RrUymx/uHds39nn74ttMXhgkE7BOxF9/h1GZ5ZzU9aUCAfc7xowy7oRd+gxzo
         sTifh5fC7Epyos9Q/BLTMmkIySGlXUO4kwDrgsWPw+LQoJhRyYqVC58GwGb8JghqCkoB
         LkvjotSlksM3OVU9v/Hp2/fmdkL6WzNbOzZ7wPxGJRvDSlbnj0uQgwCRiig9qNqrii+8
         IZ+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=UZJytL5MJMz9s/bQcRB6Fp79579HOUS3QPL/VGz+lBA=;
        b=LSUjZPLnOGejMqFx7g5Zphzw6DVp6LB0y98MSL5Xhj+uOBmFCQsKodYjb7HPHjK7NO
         V5YacHYcRpnLzTcbihKRDiiRXUc/tKrmnF/AqH+UrxNLg3KNwm9TDIAGWlwLvnzK5HWI
         nb2JU0h2tn+mjdPysiagfmhrggM8kdUmSFzemz+0+Ondmf50wQrH3ubR7w+QyuhRhWNn
         /igyki5mYx+H4boJgYOcmGKQ+wNyB4AO2zVBABQLwWHVdUpOXdu9mxUisvVC7UykhQbK
         tP2+qUUhfmvTDKw04VDWM+dQyE7Gh84UprV7yaaXCVJcjTEJy4oAEBlQuku0JC4KjoKp
         HLhw==
X-Gm-Message-State: ACgBeo3QJUfUAZ2xSNeY8k6TlRocFj5hX7/EmtqgRMMR9UVyPmkYGyrz
        NXrMstldJ3f+qeJRBZgYudspDAoqoE4=
X-Google-Smtp-Source: AA6agR5PBDYRXoGuc8kGKYBu+pTkyD0oqvc9Lvt8UJAswXCO0zCilEVHiYjVGpgYLbJfgv43xHq7GdSTHQo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:228c:b0:536:b82b:e427 with SMTP id
 f12-20020a056a00228c00b00536b82be427mr10783052pfe.17.1661310107744; Tue, 23
 Aug 2022 20:01:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 24 Aug 2022 03:01:06 +0000
In-Reply-To: <20220824030138.3524159-1-seanjc@google.com>
Message-Id: <20220824030138.3524159-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220824030138.3524159-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [RFC PATCH v6 04/36] KVM: x86: Check for existing Hyper-V vCPU in kvm_hv_vcpu_init()
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When potentially allocating/initializing the Hyper-V vCPU struct, check
for an existing instance in kvm_hv_vcpu_init() instead of requiring
callers to perform the check.  Relying on callers to do the check is
risky as it's all too easy for KVM to overwrite vcpu->arch.hyperv and
leak memory, and it adds additional burden on callers without much
benefit.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/hyperv.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 611c349a08bf..8aadd31ed058 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -936,9 +936,12 @@ static void stimer_init(struct kvm_vcpu_hv_stimer *stimer, int timer_index)
 
 static int kvm_hv_vcpu_init(struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu_hv *hv_vcpu;
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 	int i;
 
+	if (hv_vcpu)
+		return 0;
+
 	hv_vcpu = kzalloc(sizeof(struct kvm_vcpu_hv), GFP_KERNEL_ACCOUNT);
 	if (!hv_vcpu)
 		return -ENOMEM;
@@ -962,11 +965,9 @@ int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool dont_zero_synic_pages)
 	struct kvm_vcpu_hv_synic *synic;
 	int r;
 
-	if (!to_hv_vcpu(vcpu)) {
-		r = kvm_hv_vcpu_init(vcpu);
-		if (r)
-			return r;
-	}
+	r = kvm_hv_vcpu_init(vcpu);
+	if (r)
+		return r;
 
 	synic = to_hv_synic(vcpu);
 
@@ -1660,10 +1661,8 @@ int kvm_hv_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 	if (!host && !vcpu->arch.hyperv_enabled)
 		return 1;
 
-	if (!to_hv_vcpu(vcpu)) {
-		if (kvm_hv_vcpu_init(vcpu))
-			return 1;
-	}
+	if (kvm_hv_vcpu_init(vcpu))
+		return 1;
 
 	if (kvm_hv_msr_partition_wide(msr)) {
 		int r;
@@ -1683,10 +1682,8 @@ int kvm_hv_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
 	if (!host && !vcpu->arch.hyperv_enabled)
 		return 1;
 
-	if (!to_hv_vcpu(vcpu)) {
-		if (kvm_hv_vcpu_init(vcpu))
-			return 1;
-	}
+	if (kvm_hv_vcpu_init(vcpu))
+		return 1;
 
 	if (kvm_hv_msr_partition_wide(msr)) {
 		int r;
@@ -2000,7 +1997,7 @@ void kvm_hv_set_cpuid(struct kvm_vcpu *vcpu)
 		return;
 	}
 
-	if (!to_hv_vcpu(vcpu) && kvm_hv_vcpu_init(vcpu))
+	if (kvm_hv_vcpu_init(vcpu))
 		return;
 
 	hv_vcpu = to_hv_vcpu(vcpu);
-- 
2.37.1.595.g718a3a8f04-goog

