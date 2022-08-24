Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F318859F1B6
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 05:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234362AbiHXDED (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 23:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234288AbiHXDDT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 23:03:19 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A962480F49
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:02 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id k16-20020a635a50000000b0042986056df6so6907894pgm.2
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=2f5in9xiCUGukX0yzapzi0DGwZFKCGq/sBaxe64YopQ=;
        b=emGGhoJsMjpQRubWfKe8pvn+AucaeclDQ7cBJuOKkigR+pAZBk/6cGaZkcRJ1sysjC
         f/jqucZnXftNfU48QOfK+4g+QEaZPwOTiMgXnsFKsAFLzwb2sE4S3+goYpwIVG/mfjf7
         +2+H3/k2sDE8i9KI+6bzP+rRmqVEeMHTOZlvegj5OBqIvnmU1Smo0lvUlxqMQdLpbAgS
         l3sjymzGDJhpZVVV2zOMRhrjRwOHyVlFjmXbz8FckCZF/hZNJ29sSPS9tyHORKllu9mv
         ZYuW4NZqIop5anU1ECz6hyqBiNFWZXEj8BENcBFVbqbJPtEeGNofBArEHIX/Nd9C7kfC
         vTRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=2f5in9xiCUGukX0yzapzi0DGwZFKCGq/sBaxe64YopQ=;
        b=SqDf6u81ehB+8HBnCRREEuJgmQ3kWzCEhU4JQzMV1HxRNX9aTGjJ3k6I0O2XdxkoQ9
         mrPY0b9s+nno9kNTyECP+jJ/P46dWPXBoR53XrAOW55waX+crCypMJuc18gvSElVl9tT
         OZnBqeu0mdj7gn3Ty0h8exoSweE1ilQt/pOoz7AoUUdcn/fpC469YLRepkFHyzoB8lt4
         JO/hVhFwlJWsik/yC1zLMHUv1nYaZJmLwHKRTuNOg/ivNoHyaX7vVPKJNpo01SHxuYqZ
         GDH9I4QO0QJFIELsxrOYMk+78EuKixu0aVg7lu6yo7rmQX2IwN4W5ixksXp7+VHJIUvV
         LhrA==
X-Gm-Message-State: ACgBeo3E6JziPplX3ZPT73FqVFZNFl/3eF32N06vijWD6Zcyuu8KT66w
        kt1CQCHnIXI97EVvKJZlA4EF0sTca5U=
X-Google-Smtp-Source: AA6agR5Eb6axJU4p4mhZBPH5x0HG6VQP920MR5fYvUqNIxpUJ26jw7W7bHTEZD7e3FStQsWrMvRXy1URGGQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:64c1:b0:1fa:d891:adc0 with SMTP id
 i1-20020a17090a64c100b001fad891adc0mr6343502pjm.147.1661310121780; Tue, 23
 Aug 2022 20:02:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 24 Aug 2022 03:01:14 +0000
In-Reply-To: <20220824030138.3524159-1-seanjc@google.com>
Message-Id: <20220824030138.3524159-13-seanjc@google.com>
Mime-Version: 1.0
References: <20220824030138.3524159-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [RFC PATCH v6 12/36] KVM: x86: hyper-v: Cache HYPERV_CPUID_NESTED_FEATURES
 CPUID leaf
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

From: Vitaly Kuznetsov <vkuznets@redhat.com>

KVM has to check guest visible HYPERV_CPUID_NESTED_FEATURES.EBX CPUID
leaf to know which Enlightened VMCS definition to use (original or 2022
update). Cache the leaf along with other Hyper-V CPUID feature leaves
to make the check quick.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 2 ++
 arch/x86/kvm/hyperv.c           | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2209724b765e..fa399329c9f8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -615,6 +615,8 @@ struct kvm_vcpu_hv {
 		u32 enlightenments_eax; /* HYPERV_CPUID_ENLIGHTMENT_INFO.EAX */
 		u32 enlightenments_ebx; /* HYPERV_CPUID_ENLIGHTMENT_INFO.EBX */
 		u32 syndbg_cap_eax; /* HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES.EAX */
+		u32 nested_eax; /* HYPERV_CPUID_NESTED_FEATURES.EAX */
+		u32 nested_ebx; /* HYPERV_CPUID_NESTED_FEATURES.EBX */
 	} cpuid_cache;
 };
 
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index bf4729e8cc80..a7478b61088b 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2018,6 +2018,12 @@ void kvm_hv_set_cpuid(struct kvm_vcpu *vcpu, bool hyperv_enabled)
 	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES);
 	if (entry)
 		hv_vcpu->cpuid_cache.syndbg_cap_eax = entry->eax;
+
+	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_NESTED_FEATURES);
+	if (entry) {
+		hv_vcpu->cpuid_cache.nested_eax = entry->eax;
+		hv_vcpu->cpuid_cache.nested_ebx = entry->ebx;
+	}
 }
 
 int kvm_hv_set_enforce_cpuid(struct kvm_vcpu *vcpu, bool enforce)
-- 
2.37.1.595.g718a3a8f04-goog

