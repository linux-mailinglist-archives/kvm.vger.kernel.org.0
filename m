Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB5A01DFE9F
	for <lists+kvm@lfdr.de>; Sun, 24 May 2020 13:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728219AbgEXL2y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 May 2020 07:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbgEXL2x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 May 2020 07:28:53 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E33ADC061A0E;
        Sun, 24 May 2020 04:28:53 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id v2so2477847pfv.7;
        Sun, 24 May 2020 04:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RWO/OXRQH9YkelBLwEYecdeR67q1epheVXYbx2GpxBc=;
        b=r9QxSHJ8nQf+eymT3i4PzZz9D6z+K4lZqsW5QzXR3GrLdJqRplt9eVxy1ye31t/xVo
         JMzInJOHqSWGdOdEThXadpbpxTt/yU65A55vuNalQWhEmiANM1fSrwWGW1h1QzcrPFhL
         B+qetvll5C58yT4DDcvw212m/C8a/HOzkYqTudm5V7obuJ+ZQDfTU6Aag+IQPmmTIqG8
         GW04xwOt+C7WkzQmeRjMekCW9HFcnfcY4u6ofmKM4YPkIlIXq+V9m/QdVEzwCfl/NQP0
         Q6JXqmSIQvMyOiXbuI/jfE3lNKxTYTYZgBYXo1WCWNadOqw876EqWMoDm6zmnsI+gDKt
         yR5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=RWO/OXRQH9YkelBLwEYecdeR67q1epheVXYbx2GpxBc=;
        b=rzVCulDVNR6qbVnAKhc4fnlfeEDJVGh1Ryk03hkGkQqcfRF6YyQp7Sa55hl0TG+JJb
         bzsT9HLaBTm1a+wwYGaadWG2tYY0oAgRY4QybyEnyHXAYOJ63929XJck9yoVfVOWLHyN
         xSbtpHO4LkXieejaErmf1XiKyRtlJiUJgK6VCejCyCBIUnLt8PwVj+KD6tllbMh8GQ3P
         6UqaOTx4MEKv0XC/3MxgDX02knkzc8bqsD8YAw/d1esjYofcK7pk6ubZawpOe5nwl2ge
         kkYEqMz35LD1u3UN9M9d5IZoGv07OjIzxhMhygBdCL5HEQ6X2tbKrZWmsVYULQeUum0M
         SPpg==
X-Gm-Message-State: AOAM530V9+GrJcO7qSUuw+Xd4VD4IoVf7X+SYn4pDFUbbAw1AccS/H8D
        xeew0Zo3nbTTyY6AhwCaMpo=
X-Google-Smtp-Source: ABdhPJzz7dQQsTSg7SdEJKBefgmI3yYwyjDTv3Nu7LWGwQTb4D655Cgl6Fa/+RLSJLtc4OcFZIQfeg==
X-Received: by 2002:a63:454c:: with SMTP id u12mr22135248pgk.153.1590319733503;
        Sun, 24 May 2020 04:28:53 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id 192sm1971719pfu.202.2020.05.24.04.28.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 May 2020 04:28:53 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V8 14/15] KVM: MIPS: Enable KVM support for Loongson-3
Date:   Sun, 24 May 2020 19:13:38 +0800
Message-Id: <1590318819-24520-15-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1590318819-24520-1-git-send-email-chenhc@lemote.com>
References: <1590318819-24520-1-git-send-email-chenhc@lemote.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch enable KVM support for Loongson-3 by selecting HAVE_KVM, but
only enable KVM/VZ on Loongson-3A R4+ (because VZ of early processors
are incomplete). Besides, Loongson-3 support SMP guests, so we clear the
linked load bit of LLAddr in kvm_vz_vcpu_load() if the guest has more
than one VCPUs.

Acked-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Signed-off-by: Huacai Chen <chenhc@lemote.com>
Co-developed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/mips/Kconfig            | 1 +
 arch/mips/kernel/cpu-probe.c | 1 +
 arch/mips/kvm/vz.c           | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 690718b..219a2ee 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1466,6 +1466,7 @@ config CPU_LOONGSON64
 	select MIPS_L1_CACHE_SHIFT_6
 	select GPIOLIB
 	select SWIOTLB
+	select HAVE_KVM
 	help
 		The Loongson GSx64(GS264/GS464/GS464E/GS464V) series of processor
 		cores implements the MIPS64R2 instruction set with many extensions,
diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index 5bf0821..c46724e 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -1958,6 +1958,7 @@ static inline void cpu_probe_loongson(struct cpuinfo_mips *c, unsigned int cpu)
 		c->writecombine = _CACHE_UNCACHED_ACCELERATED;
 		c->ases |= (MIPS_ASE_LOONGSON_MMI | MIPS_ASE_LOONGSON_CAM |
 			MIPS_ASE_LOONGSON_EXT | MIPS_ASE_LOONGSON_EXT2);
+		c->ases &= ~MIPS_ASE_VZ; /* VZ of Loongson-3A2000/3000 is incomplete */
 		break;
 	case PRID_IMP_LOONGSON_64G:
 		c->cputype = CPU_LOONGSON64;
diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
index ed9bf31..2dd17e4 100644
--- a/arch/mips/kvm/vz.c
+++ b/arch/mips/kvm/vz.c
@@ -2697,7 +2697,7 @@ static int kvm_vz_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	 * prevents a SC on the next VCPU from succeeding by matching a LL on
 	 * the previous VCPU.
 	 */
-	if (cpu_guest_has_rw_llb)
+	if (vcpu->kvm->created_vcpus > 1)
 		write_gc0_lladdr(0);
 
 	return 0;
-- 
2.7.0

