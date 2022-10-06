Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71E3F5F5E04
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 02:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbiJFAvd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 20:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiJFAva (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 20:51:30 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB7D93FEEE
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 17:51:29 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id q3-20020a17090311c300b0017898180dddso210471plh.0
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 17:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=XxYR0Lkn6CCkh677bL/wbSatCverNNjIGoBZGWzb7uE=;
        b=rtjuEcE8eBMnkiZsklkvRGCWw/lx47FXOLn+am0B7nOEEhCrZXnANcvhuxEpH8py/u
         vUaoQ8N7ffoa+n3j2ZtBA+ptziQwxa/weJ/tLVkkXtKEngUdq85Ipuu5KWtfCQ6hcIUy
         KrcWToxXF/H3T9llkPPcbX9FnZ+rkEoR8mGoJvsQDnhenxbdN7l1UnUwXkEt+NfiGrk5
         6QBqHbWyTpUaHz5GmpCW5qwahozR+cc5iuTU7ee/FoFObTfn92Rx8Npzo/p+04vJsXGe
         zNWrYAjfm47S/0NPCBWXEndYFsFaSYb9CHObQO7pjg1bdrmF8i9SIFepGHQf/IHWPDuJ
         Gxjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XxYR0Lkn6CCkh677bL/wbSatCverNNjIGoBZGWzb7uE=;
        b=AkWfzfQ2MoRTzthiPdSrvsxC9FfJwULVbyVWzbw52UMxJ032P1ezxAz1zlWIPgxMoH
         Hf49Q+LeIxx5vU0nJJFYB8tddcDBZiEtLDjV8AWvv+4g+8U2VkHOOGcCy+jZzu1+r96Z
         JJ4KGmabQ9KTnjiUu2qln2FSEB0anhG0RG6viYE0DvNOhvfhTlt4VKls1HcpQy4me3ty
         XH+JR7OhApCgE5Qqsa4b7lTFM4kTloTajTRIf6vzeN02LCtlzoalcDrurH3kKeoEaRy2
         y2I2dziBkduawoOiUNioRalYQYrq01Z7bnW3fs4ZReTqckIx+b6Lb/P1gHfERT/o3Bxo
         HeXQ==
X-Gm-Message-State: ACrzQf2DqlpWmFOB0YiiMYKE0WmQC2w1MbVatchzdAEgYHXlEupikHu0
        zLsAuyA9GymC7JYVLux8tVq43vbtwlo=
X-Google-Smtp-Source: AMsMyM6Sr7oPHPIqLpUIKlwFZraTv88JsjN/i7EZ62EoPfwIRZyfDc4x7Zs2nmulI0UyAHbg1Hc+uQZoTU0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3147:b0:203:6eaa:4894 with SMTP id
 ip7-20020a17090b314700b002036eaa4894mr7897314pjb.230.1665017489582; Wed, 05
 Oct 2022 17:51:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  6 Oct 2022 00:51:14 +0000
In-Reply-To: <20221006005125.680782-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221006005125.680782-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221006005125.680782-2-seanjc@google.com>
Subject: [PATCH 01/12] KVM: selftests: Add X86_FEATURE_PAE and use it calc
 "fallback" MAXPHYADDR
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
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

Add X86_FEATURE_PAE and use it to guesstimate the MAXPHYADDR when the
MAXPHYADDR CPUID entry isn't supported.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h | 1 +
 tools/testing/selftests/kvm/lib/x86_64/processor.c     | 4 +---
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index e8ca0d8a6a7e..bb9c5f34a893 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -89,6 +89,7 @@ struct kvm_x86_cpu_feature {
 #define	X86_FEATURE_XSAVE		KVM_X86_CPU_FEATURE(0x1, 0, ECX, 26)
 #define	X86_FEATURE_OSXSAVE		KVM_X86_CPU_FEATURE(0x1, 0, ECX, 27)
 #define	X86_FEATURE_RDRAND		KVM_X86_CPU_FEATURE(0x1, 0, ECX, 30)
+#define X86_FEATURE_PAE			KVM_X86_CPU_FEATURE(0x1, 0, EDX, 6)
 #define	X86_FEATURE_MCE			KVM_X86_CPU_FEATURE(0x1, 0, EDX, 7)
 #define	X86_FEATURE_APIC		KVM_X86_CPU_FEATURE(0x1, 0, EDX, 9)
 #define	X86_FEATURE_CLFLUSH		KVM_X86_CPU_FEATURE(0x1, 0, EDX, 19)
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 39c4409ef56a..ca49944a6bce 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1060,12 +1060,10 @@ bool is_amd_cpu(void)
 void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits)
 {
 	const struct kvm_cpuid_entry2 *entry;
-	bool pae;
 
 	/* SDM 4.1.4 */
 	if (kvm_get_cpuid_max_extended() < 0x80000008) {
-		pae = kvm_get_supported_cpuid_entry(1)->edx & (1 << 6);
-		*pa_bits = pae ? 36 : 32;
+		*pa_bits == kvm_cpu_has(X86_FEATURE_PAE) ? 36 : 32;
 		*va_bits = 32;
 	} else {
 		entry = kvm_get_supported_cpuid_entry(0x80000008);
-- 
2.38.0.rc1.362.ged0d419d3c-goog

