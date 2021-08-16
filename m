Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9DB03ECBF4
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 02:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232304AbhHPAM7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Aug 2021 20:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232180AbhHPAM4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Aug 2021 20:12:56 -0400
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22F8C061764
        for <kvm@vger.kernel.org>; Sun, 15 Aug 2021 17:12:25 -0700 (PDT)
Received: by mail-io1-xd4a.google.com with SMTP id f10-20020a6b620a0000b02904e5ab8bdc6cso8268061iog.22
        for <kvm@vger.kernel.org>; Sun, 15 Aug 2021 17:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=E6Kp8VbK7wYZ6N9mrulVFPxuQLG+WCCQs9laQvbnKBA=;
        b=eK7WWUKmJs5BwvM+R2hcGD3Ji+r55jFV4Y/m0xTcQXO98TkC2SBcgDjIkEKOS9I1Dz
         Z+KOH8cQFMH84TGr26zZrToaIDDcz6SXm6LdwgOCkRBlwDQQ5lVdgLyuM5sH5fLSk9fc
         JhMeDb3aUR/SqI4YoPBMrFE4S+q+z+YOsV2INlxYp+KJ0vfmin10q/SkJ/PkzJpd6YF9
         HZXZfIaCHE0BNeGw8ZyDDB0LknniqFmW5oeMGIGzpNd+2D+alqEycIL9pYhyFfyJyI+q
         R19Dnfa2/y4llJ/H8cnGQAjI4S4uO2CP9g91opOsuqp2kVlxEIrFtgU6V7IqCgXM47tr
         unWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=E6Kp8VbK7wYZ6N9mrulVFPxuQLG+WCCQs9laQvbnKBA=;
        b=R4H3k2AzyCj0XuB/3rpnB97fdx8cZHuTgBvcJQUubx9AslEVaETA8Syb48JB2ptv3Z
         nnJHm6Q81SZB5wnBWWIWhCWUj79Ig8CiVaR/fd36oL/rjN4PuSW/Br1w1m27siMeG0DX
         FwKZx1KDE8pJxfaVaI0fLcKW61FITerEg+HLpSdZtoumUBY9s9TqQGwquZgX1Qstec5z
         M4Ho5VZh2bLiKgvckwh6Nn5g53KnxdE1CRoXunHFKQpBfv3ALrKIb29p3l28321m78FU
         3mcStIS0lOXEXYgch9MTQ7DDZ6vVqHB7hIWiqt1uDW0esBFOWUZyWCZ5os8wdEW3v2AO
         PWBg==
X-Gm-Message-State: AOAM531JuWus6oqQRf0yu61GD73gcV3/bD23EeysHPrhU6Qp9yMc7V3z
        rredhyJUmNUCiaEkHxyDrQhZqU2IEQRP2HuMMYbG6x9tkKy2+wvf7oK8Bcw07ThWGLmZCHjlHQo
        n4LU/NYIBneuQ/qe13ZABT9Z7X/9Is4b3mTOY8Jxa49oUK5dnIaKDIT0mlQ==
X-Google-Smtp-Source: ABdhPJxOjPTqr7vVT3cx9Io5XzVFMI5B6VGMeC/E76yIdgKYAKoQGgpGvWdy7jxo2YMnwnmcnxIE8cMv4gU=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:1d1a:: with SMTP id
 i26mr147868ila.96.1629072745284; Sun, 15 Aug 2021 17:12:25 -0700 (PDT)
Date:   Mon, 16 Aug 2021 00:12:14 +0000
In-Reply-To: <20210816001217.3063400-1-oupton@google.com>
Message-Id: <20210816001217.3063400-5-oupton@google.com>
Mime-Version: 1.0
References: <20210816001217.3063400-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v7 4/7] arm64: cpufeature: Enumerate support for FEAT_ECV >= 0x2
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
counter virtualization (i.e. ID_AA64MMFR0_EL1.ECV>=0x2).

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/sysreg.h |  1 +
 arch/arm64/kernel/cpufeature.c  | 10 ++++++++++
 arch/arm64/tools/cpucaps        |  1 +
 3 files changed, 12 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 943d31d92b5b..c7ddf9a71134 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -847,6 +847,7 @@
 #define ID_AA64MMFR0_ASID_SHIFT		4
 #define ID_AA64MMFR0_PARANGE_SHIFT	0
 
+#define ID_AA64MMFR0_ECV_PHYS		0x2
 #define ID_AA64MMFR0_TGRAN4_NI		0xf
 #define ID_AA64MMFR0_TGRAN4_SUPPORTED	0x0
 #define ID_AA64MMFR0_TGRAN64_NI		0xf
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 0ead8bfedf20..b44cef8deacc 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2301,6 +2301,16 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		.min_field_value = 1,
 	},
+	{
+		.desc = "Enhanced Counter Virtualization (Physical)",
+		.capability = ARM64_HAS_ECV2,
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
index 49305c2e6dfd..f73a30d5fb1c 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -18,6 +18,7 @@ HAS_CRC32
 HAS_DCPODP
 HAS_DCPOP
 HAS_E0PD
+HAS_ECV2
 HAS_EPAN
 HAS_GENERIC_AUTH
 HAS_GENERIC_AUTH_ARCH
-- 
2.33.0.rc1.237.g0d66db33f3-goog

