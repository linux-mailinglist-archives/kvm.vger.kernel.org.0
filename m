Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2632B5AA16A
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 23:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234110AbiIAVSi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 17:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbiIAVSh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 17:18:37 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D00672857
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 14:18:36 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id y16-20020a17090aa41000b001fdf0a76a4eso58092pjp.3
        for <kvm@vger.kernel.org>; Thu, 01 Sep 2022 14:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=c2WitT/tE1qbywkS6XRK3QEEf67FVJV8wq/kxKQuycE=;
        b=GfV4SjV5CZ+owAHNrgWo15g1gCfixHKj+X/QoAYDx0rXRLNLTBUP2JXSp07BUwU9dn
         D6vPYPGzGw6eByrO8uirH7ODk2YLlXURfCuExc71QXo9Ok8W7jKLB608oSoV0DI6PAzv
         cnODe7v6m/04d5/RS+Z3GXT2jOu3GgF6TtdAhiYvyjpzXnSt0Q3pEvcAmWe9SN6M5WPb
         oDh/fA4bSNn6prx9eHeq7K2dimArpQ4zFHw94F+rZyUvx9oa4FrujU8NmT2dHBB5tiPX
         HcM04OlPu7gfwjJlf9/DkfBP5zo7JhQunSCW2mMkNiNtNthkrqtV+s8mRevNcDTV7YpE
         H4MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=c2WitT/tE1qbywkS6XRK3QEEf67FVJV8wq/kxKQuycE=;
        b=fLPxoueU9ntYXDL2IOnj9bBIUBkPuJNVVSqC+xJl7uX2BrYYzLKcUFBXTx31Zn8BZe
         sAf2HBwcPOW8ep8tcdRzxqYO22z4H6WWW5dg998QLHxBmdFvLWvtlRcfipPQUnmf9wyC
         8LwFZW7xClaV76JJJ5YT5MBv1ti9MR1GMBGAEVwDAz2k+nxeL9DaXczpT0Rfm/h3zraq
         e54U86fBuDPMQbzPvkSAb9pCMMbeTMEAn1tWZLHDW32IipEPyjQ430doxV+TpE/MDJcq
         jKu9cG7akAH5t7FIhE+SgWy9Eo5mcp9sEICrCVcVs9vXXnEy/hp7pQO5f8UwPPqWwE7I
         A1Vg==
X-Gm-Message-State: ACgBeo0ouKB/A4B3cmstyRZzVyyCxJE4wajPg9X55MmOOoh3urSbwknA
        b3cMpJ5tPB7/PWi4Y5MGFdQx7gZXWYtd0A==
X-Google-Smtp-Source: AA6agR4DbKP7+lxqS/fjuzDHUnCbRZL5YR6c6T3bKX3oIg0r9hXRQbJ/vc9sB5oMdN0tyL+knzzZu7FeGuerbQ==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a05:6a00:1496:b0:52f:734f:9122 with SMTP
 id v22-20020a056a00149600b0052f734f9122mr33475818pfu.85.1662067115834; Thu,
 01 Sep 2022 14:18:35 -0700 (PDT)
Date:   Thu,  1 Sep 2022 14:18:06 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220901211811.2883855-1-jmattson@google.com>
Subject: [PATCH v3 1/2] x86/cpufeatures: Add macros for Intel's new fast rep
 string features
From:   Jim Mattson <jmattson@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jim Mattson <jmattson@google.com>,
        Babu Moger <babu.moger@amd.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Wyes Karny <wyes.karny@amd.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)" 
        <kvm@vger.kernel.org>
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

KVM_GET_SUPPORTED_CPUID should reflect these host CPUID bits. The bits
are already cached in word 12. Give the bits X86_FEATURE names, so
that they can be easily referenced. Hide these bits from
/proc/cpuinfo, since the host kernel makes no use of them at present.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/include/asm/cpufeatures.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index ef4775c6db01..454f0faa8e90 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -308,6 +308,9 @@
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
 #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructions */
+#define X86_FEATURE_FZRM		(12*32+10) /* "" Fast zero-length REP MOVSB */
+#define X86_FEATURE_FSRS		(12*32+11) /* "" Fast short REP STOSB */
+#define X86_FEATURE_FSRC		(12*32+12) /* "" Fast short REP {CMPSB,SCASB} */
 
 /* AMD-defined CPU features, CPUID level 0x80000008 (EBX), word 13 */
 #define X86_FEATURE_CLZERO		(13*32+ 0) /* CLZERO instruction */
-- 
2.37.2.789.g6183377224-goog

