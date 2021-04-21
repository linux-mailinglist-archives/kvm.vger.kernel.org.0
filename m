Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C92836634C
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 03:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233947AbhDUBJb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 21:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233836AbhDUBJa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 21:09:30 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 136A7C061763
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 18:08:58 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id e65-20020a25e7440000b02904ecfeff1ed8so2538539ybh.19
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 18:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=yreWuj6mbfdz2hyYXXMbP0/DSYeQPnhKZL0KcCdj5RA=;
        b=ZbDT9mkvb5FK7FzLr7cfj2U79ll5HDNS55F9gFZCf1XL+zG4bER5KOmpLo+luFBH1y
         z6wx2wRtBQhLMzugVmjygM8c+UaZPwB+F/91Yu6mHwe7Jid7BCant0asWBzggzZcrXSI
         CK6w7nugeazI5joXFIfVIVrMehCfvKOhjVt7bKrvdCtcAFOgnJobdETedO7AHEFuQke+
         fXil1H0AWX07UX0+278pdG6jkXSCk39dn6YWMo2ypw052A1On/OYkGUVq7hmucyudBRO
         uqII9Af0fXBBrUcs1ChZIo8b1KR/REgE6OtCTU2nZom6Qy/dcipBIPSKMOE+G0nx9Vax
         6vIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=yreWuj6mbfdz2hyYXXMbP0/DSYeQPnhKZL0KcCdj5RA=;
        b=BO9ONb/rKqBek0zijUgTQJP70AbsvuY8MkP468EMKxOgm+gg+ZTvincbM2N2lczOmJ
         cIH11e4a4x0DABNrE7jGWtVj/ATK44a61CNn0r1YSGK0tGbU7skDrh8TT7uj1xgD2zVJ
         ig4wg909f0/FpmyQuomzIik5yFBbFxzcM4t6vE61SrF3DclmA47H3N0djbEiJC/R087F
         jPcH0AqTtLlcZBM08qADKGsrCNEH9FXZNZSPpCNG3G9vCCkmsCBufUveiyaoT6xip2bY
         QiN6+aNrjcpA/aaEuOEG6wnERfqFCM1FX0oYuDDUnK1n2+O7KoD1DoHogrxY6rxl0rET
         zm+g==
X-Gm-Message-State: AOAM5319hvBg6ser/baU8Sw9f6/TQAWJKbdCUmwyvvb7SHZR6DVg36/6
        z2OMp0sbDP4Gprakn7F8a7jx6DHRpko=
X-Google-Smtp-Source: ABdhPJx0KB0ZGkUiqj3A1BLGcno/kXT67zz5NuprBq16lIqKPtuL+i3wvD5/JWILMhKvqSlKgkvs7O/Df/E=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:a116:ecd1:5e88:1d40])
 (user=seanjc job=sendgmr) by 2002:a25:d051:: with SMTP id h78mr28826991ybg.497.1618967337262;
 Tue, 20 Apr 2021 18:08:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 20 Apr 2021 18:08:50 -0700
Message-Id: <20210421010850.3009718-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.368.gbe11c130af-goog
Subject: [PATCH] KVM: x86: Fix implicit enum conversion goof in scattered
 reverse CPUID code
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        clang-built-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Take "enum kvm_only_cpuid_leafs" in scattered specific CPUID helpers
(which is obvious in hindsight), and use "unsigned int" for leafs that
can be the kernel's standard "enum cpuid_leaf" or the aforementioned
KVM-only variant.  Loss of the enum params is a bit disapponting, but
gcc obviously isn't providing any extra sanity checks, and the various
BUILD_BUG_ON() assertions ensure the input is in range.

This fixes implicit enum conversions that are detected by clang-11.

Fixes: 4e66c0cb79b7 ("KVM: x86: Add support for reverse CPUID lookup of scattered features")
Cc: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

Hopefully it's not too late to squash this...

 arch/x86/kvm/cpuid.c | 5 +++--
 arch/x86/kvm/cpuid.h | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 96e41e1a1bde..e9d644147bf5 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -365,7 +365,7 @@ int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
 }
 
 /* Mask kvm_cpu_caps for @leaf with the raw CPUID capabilities of this CPU. */
-static __always_inline void __kvm_cpu_cap_mask(enum cpuid_leafs leaf)
+static __always_inline void __kvm_cpu_cap_mask(unsigned int leaf)
 {
 	const struct cpuid_reg cpuid = x86_feature_cpuid(leaf * 32);
 	struct kvm_cpuid_entry2 entry;
@@ -378,7 +378,8 @@ static __always_inline void __kvm_cpu_cap_mask(enum cpuid_leafs leaf)
 	kvm_cpu_caps[leaf] &= *__cpuid_entry_get_reg(&entry, cpuid.reg);
 }
 
-static __always_inline void kvm_cpu_cap_init_scattered(enum cpuid_leafs leaf, u32 mask)
+static __always_inline
+void kvm_cpu_cap_init_scattered(enum kvm_only_cpuid_leafs leaf, u32 mask)
 {
 	/* Use kvm_cpu_cap_mask for non-scattered leafs. */
 	BUILD_BUG_ON(leaf < NCAPINTS);
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index eeb4a3020e1b..7bb4504a2944 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -236,7 +236,7 @@ static __always_inline void cpuid_entry_change(struct kvm_cpuid_entry2 *entry,
 }
 
 static __always_inline void cpuid_entry_override(struct kvm_cpuid_entry2 *entry,
-						 enum cpuid_leafs leaf)
+						 unsigned int leaf)
 {
 	u32 *reg = cpuid_entry_get_reg(entry, leaf * 32);
 
-- 
2.31.1.368.gbe11c130af-goog

