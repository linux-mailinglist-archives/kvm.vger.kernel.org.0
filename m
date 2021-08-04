Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 377CA3DFD80
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 10:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236865AbhHDI7I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 04:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236863AbhHDI7F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 04:59:05 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD67C0613D5
        for <kvm@vger.kernel.org>; Wed,  4 Aug 2021 01:58:53 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id u11-20020ad45aab0000b029033e289c093aso1294470qvg.10
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 01:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=h8C+AkSSxjD2I6RXdGSsBwEWeDSTzFjVwyFJmn30s0c=;
        b=vdFpyj+9XNPjdYnHOx6TwDyWXfkwfTUZA5Sw6ri/Z+MfoVjX9B5ei1iIA6qchNTckg
         Js4/woRxok9rGl937dT5UR6w8jykMhwsS++V75ZeD8wlloCL6wCsYKsehUNaIOE43JeR
         Z2I0iFTOk5qzEKQKx3u2dbLLBMotmDxqqKCR94OqjLYyygFGecaxna6m9TnnTENZ1dlO
         BcCV64E3066DzzNmcmkPW3oPneJUjkCGeWxgt3hXPaU/8EVSRFSD6lZNyz1DT33Lkoi7
         qZmZBVlnNgK5BwZRYc/LHdxEGICI0QBX432vw8WwyIBzzYfANL3FddNoQdY4qIW6LGFV
         epqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=h8C+AkSSxjD2I6RXdGSsBwEWeDSTzFjVwyFJmn30s0c=;
        b=G4v2mRAdLq1jIkjxb1oWOaQ3Ogawn/gDdoGTnrut+Zsdz5tDJpUZrM7Y1ML+7hg8ZR
         3cm+R3T9Xby9/INUIPzuDMIYI29im1Gja3G0X1Iy4nMNe6K8Pxhh9sdj+SiVg39NwCxh
         KkheJxJjpEt3swGI5u4Id1JS3nPrUulsJ09EA9B5T6JA6s3YaMGYJkFV2ylDRBKmON9C
         othjTuyjg9gI2Jxg4F4I3ttOEsBm7Yu8zWCFu+VHymzhabQbGI2pke5MNAXMzS4CyfJF
         vfbGhvIjj9ScJ8E7+vuteDChfKSDvjsLtj5slvaZLWSLLpsclJOK+CsXUJZhxoT2WAsn
         Daxg==
X-Gm-Message-State: AOAM532rj5k+v8Z7ClZHkOJ0kiFteH4iOwC0wMgev+akqNdnugsw9FDU
        0B6reW/DcxzLx93HC6MghY4jhXTID4tPNfF92+AZB+79/+/Cph9RYNuRve3XYVrVSmsF+NVZj2S
        aN3P4JPU216I536YyVcfuobNd/6rwJfbBXtofoIr44whzNwkTbr0VKz5h5Q==
X-Google-Smtp-Source: ABdhPJx+GeA32n6jMUHsP7WogSpQpinH4eyTOFkLIo8qvlVC8zogWUDIRuiTAtVqSj3R5xgXeAPAlnAcOpw=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:134c:: with SMTP id
 b12mr24474131qvw.39.1628067532459; Wed, 04 Aug 2021 01:58:52 -0700 (PDT)
Date:   Wed,  4 Aug 2021 08:58:14 +0000
In-Reply-To: <20210804085819.846610-1-oupton@google.com>
Message-Id: <20210804085819.846610-17-oupton@google.com>
Mime-Version: 1.0
References: <20210804085819.846610-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v6 16/21] arm64: cpufeature: Enumerate support for Enhanced
 Counter Virtualization
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a new cpucap to indicate if the system supports full enhanced
counter virtualization (i.e. ID_AA64MMFR0_EL1.ECV==0x2).

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/sysreg.h |  2 ++
 arch/arm64/kernel/cpufeature.c  | 10 ++++++++++
 arch/arm64/tools/cpucaps        |  1 +
 3 files changed, 13 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 7b9c3acba684..4dfc44066dfb 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -847,6 +847,8 @@
 #define ID_AA64MMFR0_ASID_SHIFT		4
 #define ID_AA64MMFR0_PARANGE_SHIFT	0
 
+#define ID_AA64MMFR0_ECV_VIRT		0x1
+#define ID_AA64MMFR0_ECV_PHYS		0x2
 #define ID_AA64MMFR0_TGRAN4_NI		0xf
 #define ID_AA64MMFR0_TGRAN4_SUPPORTED	0x0
 #define ID_AA64MMFR0_TGRAN64_NI		0xf
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 0ead8bfedf20..94c349e179d3 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2301,6 +2301,16 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		.min_field_value = 1,
 	},
+	{
+		.desc = "Enhanced Counter Virtualization (Physical)",
+		.capability = ARM64_ECV,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.sys_reg = SYS_ID_AA64MMFR0_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64MMFR0_ECV_SHIFT,
+		.matches = has_cpuid_feature,
+		.min_field_value = ID_AA64MMFR0_ECV_PHYS,
+	},
 	{},
 };
 
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 49305c2e6dfd..d819ea614da5 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -3,6 +3,7 @@
 # Internal CPU capabilities constants, keep this list sorted
 
 BTI
+ECV
 # Unreliable: use system_supports_32bit_el0() instead.
 HAS_32BIT_EL0_DO_NOT_USE
 HAS_32BIT_EL1
-- 
2.32.0.605.g8dce9f2422-goog

