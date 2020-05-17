Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 932C91D659F
	for <lists+kvm@lfdr.de>; Sun, 17 May 2020 06:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbgEQEKA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 May 2020 00:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbgEQEJ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 May 2020 00:09:59 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78FF4C061A0C;
        Sat, 16 May 2020 21:09:59 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id x10so2688791plr.4;
        Sat, 16 May 2020 21:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GcNjUC8+FQGiWISz7sNyZr0sACzYWzv953HqOAl2GuE=;
        b=KlnJq5ntBYySQGM+WgoquyYe8Ju1y2SyWQDhGLxTDKASyT74Yb2Eicmz+9Nnq6NDox
         zYuPIYc6y5fGk1TlDkkQHaRyuT4/ZsPGPtOCD6MrsqubnhM7ClJEV6t68NYH7rEkq+xc
         nEr07K4763gOwyM2iHga2pFsBtDzqEoO7N9RfHhd97C18EdVo15LzwYw7Kio+xeq8HfE
         vG0z09tc5yuyLLUKaiZmEojphqlherk5nk4ZfmVrelZVCq9ZWkUa5KCVEcDMf2XUFS14
         uHzyE5H9+OCSqgOYZgPGDugO6sJe7FSRwJpJ9xeejxecjujxUGVh0PLNIQERLLwzlO34
         k1ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=GcNjUC8+FQGiWISz7sNyZr0sACzYWzv953HqOAl2GuE=;
        b=N+Z/tQ8c/Of+7vpMaljc3K6ZocybuVMNBu3xz+W78YN94xX5ZvU8QHjNSwiSW1rStW
         39LybdRlfoe5m86ruwdL9TYbI435w161IELKYoB+RDi7QpTXKNg2DSmpRZjMBIdp1pNf
         m/AmKxQV85llEOhd/J5td6fJcl2bqgw90s9a63jgxbxMoeMIGetrDhvifI+YKUlg7pcA
         XQqZgzFsJagQ2jdVa6rLjgF9Ott79hGrZaIwIsfwPM0Y49ls0nZSR3DGuUkmE7Ic7tUK
         pBweHxD92k5HWzx5gjV4F4UEFJkuuknuLSLe+3KqH4LPVwoR3s8FV4ehbuZuBZsQqpqS
         ChLg==
X-Gm-Message-State: AOAM533k5KfSZwuOmY1/oNQBge9WwAHOQck/ZdM6Qs4M1LSvvSrYVG9e
        KX7eoEQE3LKGBvAIzp92KMNtUrNZCWoakw==
X-Google-Smtp-Source: ABdhPJxVTZA84pS8kHhKoKNbRHDVb9z2/iSWJlGABVNNFV3b7VpyOxgxjS22sjnU1dxH9uB28cNA+A==
X-Received: by 2002:a17:902:26f:: with SMTP id 102mr9642283plc.209.1589688599069;
        Sat, 16 May 2020 21:09:59 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id n9sm5081630pjt.29.2020.05.16.21.09.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 16 May 2020 21:09:58 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V6 14/15] KVM: MIPS: Enable KVM support for Loongson-3
Date:   Sun, 17 May 2020 12:06:11 +0800
Message-Id: <1589688372-3098-15-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1589688372-3098-1-git-send-email-chenhc@lemote.com>
References: <1589688372-3098-1-git-send-email-chenhc@lemote.com>
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
index ce1aacc..3a15f2b 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1405,6 +1405,7 @@ config CPU_LOONGSON64
 	select MIPS_L1_CACHE_SHIFT_6
 	select GPIOLIB
 	select SWIOTLB
+	select HAVE_KVM
 	help
 		The Loongson GSx64(GS264/GS464/GS464E/GS464V) series of processor
 		cores implements the MIPS64R2 instruction set with many extensions,
diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index 319c250..415fbd2 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -2008,6 +2008,7 @@ static inline void cpu_probe_loongson(struct cpuinfo_mips *c, unsigned int cpu)
 		c->writecombine = _CACHE_UNCACHED_ACCELERATED;
 		c->ases |= (MIPS_ASE_LOONGSON_MMI | MIPS_ASE_LOONGSON_CAM |
 			MIPS_ASE_LOONGSON_EXT | MIPS_ASE_LOONGSON_EXT2);
+		c->ases &= ~MIPS_ASE_VZ; /* VZ of Loongson-3A2000/3000 is incomplete */
 		break;
 	case PRID_IMP_LOONGSON_64G:
 		c->cputype = CPU_LOONGSON64;
diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
index 73701c3..dc753d0 100644
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

