Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6657B75BF
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 02:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238857AbjJDAVQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 20:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238406AbjJDAVP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 20:21:15 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA2608E
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 17:21:11 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a23ad271d7so23629967b3.1
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 17:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696378871; x=1696983671; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xgPwohGXCtmI6X+8NYz58Cu3MtfPGyJKCVYsJcgu7r0=;
        b=HTPTYaMvJ4XMJhXOmCDWNhNlLxwvBifZC33o6nWGeXenkb03yF+ZzIA9Y1ACVH0VBY
         4rptWvBydbP4WxY1WHjpFsGCCzsVx0qqBgHrYNSCPVeMu6CYQ+T1mp3i+5asll/tZ44B
         GGdGTmsHiOYaUhwmeYHJQMuJbWQvGGaecdZ7UD7tFWZXVIeGsoMwN75YPYDLaf9N6DxB
         ftPinHHxR0W62jrUC/vgGXpHVytWw2j1qNSsXgNO4t9+XcGUn3J24sGxUxb0DmVwi6gL
         Vk7kNU0gEjwuQtNmPwAaP1mMITixICOBeh+evxTzMdFuVBXG60SsZyeRcaBiZoBF0G/F
         Qe9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696378871; x=1696983671;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xgPwohGXCtmI6X+8NYz58Cu3MtfPGyJKCVYsJcgu7r0=;
        b=taDO/+L/moAaGVIycpq6guOKx83j3VSPUyhXG2UVl/+c3iV2rKjeTODqGJY4/1w1u9
         NJFc47Le10/o5OXJoYJKDacWH8M5QuzFyA9LwaAQ64TM+UzLzmm87bGrNsEjS2w+Ig5w
         8EEHXQDokZb1bnuxOTl3vSONT4EzAu4bZueEu9WRX5ihAZL0Dq39FGBLLxZPold7HXPV
         lPwRBkFC1v4hlgRI/olYBgGMMfyIbYbg4ItzEB19xLyj1YshBU/OOy2ro66ojFCXb+wP
         Y5k8oD4/D5U9/VHofkwCF4A+0YanjKdRUggR4W2WSidmq4VilubTI29/wDsT/WwvW2tN
         JOww==
X-Gm-Message-State: AOJu0Yz8zPl/YKggc1qQTzj+T5Go5cDzWMLWDzDcpPaTJ+Xemd4tPu3z
        ulNh/H7eRz9e2WA5veUtEgWZBPo8wuhg+hyIk/V/seCoclMmh/muL2HHjL+2C2OLYr0B/57/lrt
        LULenTXtOjeSHVT785GP3RWsWDZr85AG86OYdziRbVUmhzA+P2iKmnNCKEfD+sTI=
X-Google-Smtp-Source: AGHT+IGZOolNXNZMg3/qqiGOW15TwcOLWHbp980C5EtVlDTVP6T5L3RJV+dtT4EkQyzAFq9Nc35Fb0zOXgDYRQ==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a81:7609:0:b0:59b:f3a2:cd79 with SMTP id
 r9-20020a817609000000b0059bf3a2cd79mr18329ywc.8.1696378870385; Tue, 03 Oct
 2023 17:21:10 -0700 (PDT)
Date:   Tue,  3 Oct 2023 17:20:38 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Message-ID: <20231004002038.907778-1-jmattson@google.com>
Subject: [PATCH] x86: KVM: Add feature flag for AMD's FsGsKernelGsBaseNonSerializing
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Jim Mattson <jmattson@google.com>
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

Define an X86_FEATURE_* flag for
CPUID.80000021H:EAX.FsGsKernelGsBaseNonSerializing[bit 1], and
advertise the feature to userspace via KVM_GET_SUPPORTED_CPUID.

This feature is not yet documented in the APM. See AMD's "Processor
Programming Reference (PPR) for AMD Family 19h Model 61h, Revision B1
Processors (56713-B1-PUB)."

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kvm/cpuid.c               | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 58cb9495e40f..b53951c83d1d 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -443,6 +443,7 @@
 
 /* AMD-defined Extended Feature 2 EAX, CPUID level 0x80000021 (EAX), word 20 */
 #define X86_FEATURE_NO_NESTED_DATA_BP	(20*32+ 0) /* "" No Nested Data Breakpoints */
+#define X86_FEATURE_BASES_NON_SERIAL	(20*32+ 1) /* "" FSBASE, GSBASE, and KERNELGSBASE are non-serializing */
 #define X86_FEATURE_LFENCE_RDTSC	(20*32+ 2) /* "" LFENCE always serializing / synchronizes RDTSC */
 #define X86_FEATURE_NULL_SEL_CLR_BASE	(20*32+ 6) /* "" Null Selector Clears Base */
 #define X86_FEATURE_AUTOIBRS		(20*32+ 8) /* "" Automatic IBRS */
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 0544e30b4946..5e776e8619be 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -761,7 +761,8 @@ void kvm_set_cpu_caps(void)
 
 	kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
 		F(NO_NESTED_DATA_BP) | F(LFENCE_RDTSC) | 0 /* SmmPgCfgLock */ |
-		F(NULL_SEL_CLR_BASE) | F(AUTOIBRS) | 0 /* PrefetchCtlMsr */
+		F(NULL_SEL_CLR_BASE) | F(AUTOIBRS) | 0 /* PrefetchCtlMsr */ |
+		F(BASES_NON_SERIAL)
 	);
 
 	if (cpu_feature_enabled(X86_FEATURE_SRSO_NO))
-- 
2.42.0.582.g8ccd20d70d-goog

