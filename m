Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E56140EA65
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 20:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245242AbhIPS5q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 14:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239821AbhIPS51 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Sep 2021 14:57:27 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74998C05BD0B
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 11:15:29 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id t10-20020a056e02160a00b0022c6a64f952so14894851ilu.20
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 11:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=cEhucRmtScLoOKkKtz+kjGRHoUKux13Tg6JxfwC7i5M=;
        b=HV2MQTLtXFdc7iP17P6mtu+8Vde3/FS+kVARy2QXPbgRRHo/PT+peFbVCuiaH0L5hX
         gSyOjL5ewzJr4u8bsZbz32+QGydoZ5YuWBRsCNIry5m7huzZ+AbSGfdYoxN2H8aHJbXj
         7G1zF3VnT84BPqUqiqGevGw+SQjR95LA/evNsHyqbSl1a71OYGwzy5hbxeovonQ8nWDT
         NmOu/+teU1YRy4QgHPRSPdwkcKDemlLDByX1iQlHdBdDXfAnRIE8/jmNRPEfzJgkNw/D
         RpAdtoNqtqAhzyrlabI1525AGpzYZ2bUogOFN3u0p5FmQ/P48kbO0hOfsdUlKlIAFS+t
         tYLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=cEhucRmtScLoOKkKtz+kjGRHoUKux13Tg6JxfwC7i5M=;
        b=Pso9pNOnMIzwdnkuiAJnxqztUCPk8Y6OriVLQiq7Z4XxuftPZ49DYU2E8IYgcela7H
         kzaxDfiktXsUBLukpsUdd5j6MUD9xHz0Eu+LC05GYTPdZpBL3mWbyX1kIo9EieLncfiq
         AUy/R6uSxnXb/2EUr4npW/Y0Nyq9H6TKG8a2UbEls2yrTos8n+xG0exGnv4x9uWTXrdY
         bl6YdLemFdPubpFXqqccZ2+Z/yoLNx8AxOLtDDPFR8kuddq5+biPKFzG4tOZkbtPhxAm
         9Bg6Y+yPSFHd0eIMTTHDdtgP2Qc5DH4ZtyDRMqKowTrGRBfodT8jHgK4+WE3xyk35Xsh
         gqkA==
X-Gm-Message-State: AOAM531bx4YAmZ2J3eN1mFt7DKhk5ThOFZkIjH0Tc8D3XEyduYkc3Cp6
        CUWanfCexEaFyVA6K7NExrc0soJucr15xfmBhfau2nABEGDZAnazlFQip1lmrNXNgqfdomA1b9k
        Fn6mTi/Zpr/x0oSQy0y8DObi8fweFuoShPGLklnogypJ3YOHV2sWxznnY0Q==
X-Google-Smtp-Source: ABdhPJxCd+H8v05h4eupFeeC2qY4icp5YVNK41l2UrN+lmRvW+IkyY3ujFedG7GRyGUSTbLIM5HEy4qonJo=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a92:3642:: with SMTP id d2mr4967295ilf.234.1631816128784;
 Thu, 16 Sep 2021 11:15:28 -0700 (PDT)
Date:   Thu, 16 Sep 2021 18:15:07 +0000
In-Reply-To: <20210916181510.963449-1-oupton@google.com>
Message-Id: <20210916181510.963449-6-oupton@google.com>
Mime-Version: 1.0
References: <20210916181510.963449-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v8 5/8] arm64: cpufeature: Enumerate support for FEAT_ECV >= 0x2
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
index b268082d67ed..3fa6b091384d 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -849,6 +849,7 @@
 #define ID_AA64MMFR0_ASID_8		0x0
 #define ID_AA64MMFR0_ASID_16		0x2
 
+#define ID_AA64MMFR0_ECV_PHYS		0x2
 #define ID_AA64MMFR0_TGRAN4_NI			0xf
 #define ID_AA64MMFR0_TGRAN4_SUPPORTED_MIN	0x0
 #define ID_AA64MMFR0_TGRAN4_SUPPORTED_MAX	0x7
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index f8a3067d10c6..2f5042bb107c 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2328,6 +2328,16 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
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
2.33.0.309.g3052b89438-goog

