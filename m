Return-Path: <kvm+bounces-48930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C8A5AD474E
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 02:12:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C04E2189B7C1
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 00:12:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E97613213E;
	Wed, 11 Jun 2025 00:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HRJNnWok"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646732E403
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 00:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749600654; cv=none; b=GXIS3PiyJxuS0PAINlBRAvjL6It6Iy+ndCuF+/Kc/AN/4Xir5NXbdC11ik7WWqXaWOzAJEVwNKFFThvOHlxnVVVgCD/ikivuvWAeyHjZf2SYC1sfP5l9z26weAws9C5+AlRkVyn8UegS0pSNDDvm6itJrOf0PkmBmoKkBQlxoMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749600654; c=relaxed/simple;
	bh=DpElpv38Km3z88hWj7L7ltQkAiroQboKh3ua23RYJns=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cd2+0gE/rXMvMP9aCKygLsejzNpAxaY8KbygHugbHP1gLMRnSEsTOLPH42ptsHxufWaEOlWDFlSe38aCniH3Sf7fo0nASpvWnQmfK09b+/v5T31AYG2xNDwC5mLC8TVoL8GdZan7FTkiG7nfmuNeZO0Gt/4o3logUPhm1DAuP24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HRJNnWok; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3138e65efe2so2343928a91.1
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 17:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749600652; x=1750205452; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=2yZMyl9DsHgqKNlFS7xPspHEMiNKaL3c340/uFTvPNQ=;
        b=HRJNnWokiNxA+oSoz5xpwZFj6zjCZPCDx8INqKLIQsrmgQsl75pv61QUTtTw4LLeYl
         kDaEOmvE/Hxjhonx3OBmYfwdiXCQ1LTDPMis/4hoadTY/uw7w0h1E7vlCmljZrJ3XlMB
         yDo5Uo6p8V1/iFy+jojWmy5r9EJsOTCbv7EsifrHzhzPxrfDlGkXnnYL+DEZ96WveXyE
         XGiXT/iq3tjA/giN6LoBO0p0Fzfc/bpkDsLqqFiNhkxF2HyL602gvzuJL/aADSZGTko3
         KMDn7FG0cPhvWi54kGcuuL7k7daGs5QoXI9ClpHa5Q/RlZ5RdV7uoBAXL0CgbWwP6uVu
         HeOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749600652; x=1750205452;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2yZMyl9DsHgqKNlFS7xPspHEMiNKaL3c340/uFTvPNQ=;
        b=RWO07ze2ujWdeIRSby/Mq4hkMARpX+mHUpeia8fhF0AyRmnWK1FDkj0g0lZB8k8T2m
         ee/3RW/u2sdx4m/W6F61O8Aynz35jU/1RM+Ue+awKtJwNstpdaOrbafpDBmYuSShoS/T
         vi/zxS6lbdKR6C6tPJGsO0JLksZyrRXGKF3VQUlhHA0fgZP154tANliD9EMFDQsigvVN
         Ka4fHTR1KOHEzX9N/fzk8mx7RllaCdw0jE4Avs4DkrDe+nXp4KLlWnps8oOSnxxaJW4u
         DmRCFEIRHVT05tcOpCV8iJfv6fSdduj0uBYTuq79lm27607LoNlvuRt72eqkXHYZmR52
         Tqvw==
X-Forwarded-Encrypted: i=1; AJvYcCU67o70fMn30Rn97G/3ykBxMiOUW93JZ6qbTVJ09OlC5F39cZ+CRuMaZf1JjTynDf7rPiQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwElJoVMAtN+WWLFVwIXKsB1uVXVReLPXTJYVeV/QTLhtMebxYt
	S+EI06zVQYujbXXFV9OzEHOWe8Pq1deWWuhn1roCKzdmZwzBLzdo93hPTQvwsobNXW9U906TElY
	CsHc4JQ==
X-Google-Smtp-Source: AGHT+IEQs2JsVTUXveb/V9I06jm4zaYAh3wZWMzb/QDiH8+SAZVfaf+ke/+9FbLvW15z7wPEbMAuKp579iM=
X-Received: from pjboh5.prod.google.com ([2002:a17:90b:3a45:b0:2fb:fa85:1678])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2dc1:b0:313:28e7:af14
 with SMTP id 98e67ed59e1d1-313b1fdabadmr842732a91.19.1749600651929; Tue, 10
 Jun 2025 17:10:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 17:10:38 -0700
In-Reply-To: <20250611001042.170501-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611001042.170501-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250611001042.170501-5-seanjc@google.com>
Subject: [PATCH 4/8] KVM: Move include/kvm/iodev.h to include/linux as kvm_iodev.h
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Anish Ghulati <aghulati@google.com>, Colton Lewis <coltonlewis@google.com>, 
	Thomas Huth <thuth@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Move iodev.h, the last remaining holdout in include/kvm, to the standard
include/linux directory as kvm_iodev.h and delete include/kvm.

Acked-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 MAINTAINERS                                | 1 -
 arch/arm64/include/asm/kvm_vgic.h          | 2 +-
 arch/arm64/kvm/vgic/vgic-mmio-v2.c         | 2 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c         | 2 +-
 arch/arm64/kvm/vgic/vgic-mmio.c            | 2 +-
 arch/loongarch/include/asm/kvm_eiointc.h   | 2 +-
 arch/loongarch/include/asm/kvm_ipi.h       | 2 +-
 arch/loongarch/include/asm/kvm_pch_pic.h   | 2 +-
 arch/mips/include/asm/kvm_host.h           | 3 +--
 arch/powerpc/kvm/mpic.c                    | 2 +-
 arch/riscv/kvm/aia_aplic.c                 | 2 +-
 arch/riscv/kvm/aia_imsic.c                 | 2 +-
 arch/x86/kvm/i8254.h                       | 2 +-
 arch/x86/kvm/ioapic.h                      | 2 +-
 arch/x86/kvm/irq.h                         | 2 +-
 arch/x86/kvm/lapic.h                       | 2 +-
 include/{kvm/iodev.h => linux/kvm_iodev.h} | 0
 virt/kvm/coalesced_mmio.c                  | 3 +--
 virt/kvm/eventfd.c                         | 2 +-
 virt/kvm/kvm_main.c                        | 3 +--
 20 files changed, 18 insertions(+), 22 deletions(-)
 rename include/{kvm/iodev.h => linux/kvm_iodev.h} (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 10cf54c8f727..a2cd432273e5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13011,7 +13011,6 @@ W:	http://www.linux-kvm.org
 T:	git git://git.kernel.org/pub/scm/virt/kvm/kvm.git
 F:	Documentation/virt/kvm/
 F:	include/asm-generic/kvm*
-F:	include/kvm/iodev.h
 F:	include/linux/kvm*
 F:	include/trace/events/kvm.h
 F:	include/uapi/asm-generic/kvm*
diff --git a/arch/arm64/include/asm/kvm_vgic.h b/arch/arm64/include/asm/kvm_vgic.h
index 4a34f7f0a864..09d7f628fa3b 100644
--- a/arch/arm64/include/asm/kvm_vgic.h
+++ b/arch/arm64/include/asm/kvm_vgic.h
@@ -14,7 +14,7 @@
 #include <linux/static_key.h>
 #include <linux/types.h>
 #include <linux/xarray.h>
-#include <kvm/iodev.h>
+#include <linux/kvm_iodev.h>
 #include <linux/list.h>
 #include <linux/jump_label.h>
 
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v2.c b/arch/arm64/kvm/vgic/vgic-mmio-v2.c
index d00c8a74fad6..889440a8b129 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v2.c
@@ -6,9 +6,9 @@
 #include <linux/irqchip/arm-gic.h>
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
+#include <linux/kvm_iodev.h>
 #include <linux/nospec.h>
 
-#include <kvm/iodev.h>
 #include <asm/kvm_vgic.h>
 
 #include "vgic.h"
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 505d4e389885..db95d3ccbd14 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -7,8 +7,8 @@
 #include <linux/irqchip/arm-gic-v3.h>
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
+#include <linux/kvm_iodev.h>
 #include <linux/interrupt.h>
-#include <kvm/iodev.h>
 
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_arm.h>
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
index ec1b13abc728..de689e0e881f 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -9,7 +9,7 @@
 #include <linux/irq.h>
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
-#include <kvm/iodev.h>
+#include <linux/kvm_iodev.h>
 #include <asm/kvm_arch_timer.h>
 #include <asm/kvm_vgic.h>
 
diff --git a/arch/loongarch/include/asm/kvm_eiointc.h b/arch/loongarch/include/asm/kvm_eiointc.h
index a3a40aba8acf..0049b0b79477 100644
--- a/arch/loongarch/include/asm/kvm_eiointc.h
+++ b/arch/loongarch/include/asm/kvm_eiointc.h
@@ -6,7 +6,7 @@
 #ifndef __ASM_KVM_EIOINTC_H
 #define __ASM_KVM_EIOINTC_H
 
-#include <kvm/iodev.h>
+#include <linux/kvm_iodev.h>
 
 #define EIOINTC_IRQS			256
 #define EIOINTC_ROUTE_MAX_VCPUS		256
diff --git a/arch/loongarch/include/asm/kvm_ipi.h b/arch/loongarch/include/asm/kvm_ipi.h
index 060163dfb4a3..3956b230f087 100644
--- a/arch/loongarch/include/asm/kvm_ipi.h
+++ b/arch/loongarch/include/asm/kvm_ipi.h
@@ -6,7 +6,7 @@
 #ifndef __ASM_KVM_IPI_H
 #define __ASM_KVM_IPI_H
 
-#include <kvm/iodev.h>
+#include <linux/kvm_iodev.h>
 
 #define LARCH_INT_IPI			12
 
diff --git a/arch/loongarch/include/asm/kvm_pch_pic.h b/arch/loongarch/include/asm/kvm_pch_pic.h
index e6df6a4c1c70..4b37e3134e52 100644
--- a/arch/loongarch/include/asm/kvm_pch_pic.h
+++ b/arch/loongarch/include/asm/kvm_pch_pic.h
@@ -6,7 +6,7 @@
 #ifndef __ASM_KVM_PCH_PIC_H
 #define __ASM_KVM_PCH_PIC_H
 
-#include <kvm/iodev.h>
+#include <linux/kvm_iodev.h>
 
 #define PCH_PIC_SIZE			0x3e8
 
diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index c14b10821817..0d7dd89ca5bf 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -16,6 +16,7 @@
 #include <linux/interrupt.h>
 #include <linux/types.h>
 #include <linux/kvm.h>
+#include <linux/kvm_iodev.h>
 #include <linux/kvm_types.h>
 #include <linux/threads.h>
 #include <linux/spinlock.h>
@@ -24,8 +25,6 @@
 #include <asm/inst.h>
 #include <asm/mipsregs.h>
 
-#include <kvm/iodev.h>
-
 /* MIPS KVM register ids */
 #define MIPS_CP0_32(_R, _S)					\
 	(KVM_REG_MIPS_CP0 | KVM_REG_SIZE_U32 | (8 * (_R) + (_S)))
diff --git a/arch/powerpc/kvm/mpic.c b/arch/powerpc/kvm/mpic.c
index 23e9c2bd9f27..b25a03251544 100644
--- a/arch/powerpc/kvm/mpic.c
+++ b/arch/powerpc/kvm/mpic.c
@@ -26,6 +26,7 @@
 #include <linux/slab.h>
 #include <linux/mutex.h>
 #include <linux/kvm_host.h>
+#include <linux/kvm_iodev.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
 #include <linux/anon_inodes.h>
@@ -33,7 +34,6 @@
 #include <asm/mpic.h>
 #include <asm/kvm_para.h>
 #include <asm/kvm_ppc.h>
-#include <kvm/iodev.h>
 
 #define MAX_CPU     32
 #define MAX_SRC     256
diff --git a/arch/riscv/kvm/aia_aplic.c b/arch/riscv/kvm/aia_aplic.c
index f59d1c0c8c43..bf163724aec5 100644
--- a/arch/riscv/kvm/aia_aplic.c
+++ b/arch/riscv/kvm/aia_aplic.c
@@ -9,10 +9,10 @@
 
 #include <linux/irqchip/riscv-aplic.h>
 #include <linux/kvm_host.h>
+#include <linux/kvm_iodev.h>
 #include <linux/math.h>
 #include <linux/spinlock.h>
 #include <linux/swab.h>
-#include <kvm/iodev.h>
 
 struct aplic_irq {
 	raw_spinlock_t lock;
diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
index 29ef9c2133a9..ae3c0807baa9 100644
--- a/arch/riscv/kvm/aia_imsic.c
+++ b/arch/riscv/kvm/aia_imsic.c
@@ -11,10 +11,10 @@
 #include <linux/bitmap.h>
 #include <linux/irqchip/riscv-imsic.h>
 #include <linux/kvm_host.h>
+#include <linux/kvm_iodev.h>
 #include <linux/math.h>
 #include <linux/spinlock.h>
 #include <linux/swab.h>
-#include <kvm/iodev.h>
 #include <asm/csr.h>
 
 #define IMSIC_MAX_EIX	(IMSIC_MAX_ID / BITS_PER_TYPE(u64))
diff --git a/arch/x86/kvm/i8254.h b/arch/x86/kvm/i8254.h
index a768212ba821..4de7a0b88e4f 100644
--- a/arch/x86/kvm/i8254.h
+++ b/arch/x86/kvm/i8254.h
@@ -4,7 +4,7 @@
 
 #include <linux/kthread.h>
 
-#include <kvm/iodev.h>
+#include <linux/kvm_iodev.h>
 
 struct kvm_kpit_channel_state {
 	u32 count; /* can be 65536 */
diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
index aa8cb4ac0479..cb36c36affd3 100644
--- a/arch/x86/kvm/ioapic.h
+++ b/arch/x86/kvm/ioapic.h
@@ -3,7 +3,7 @@
 #define __KVM_IO_APIC_H
 
 #include <linux/kvm_host.h>
-#include <kvm/iodev.h>
+#include <linux/kvm_iodev.h>
 #include "irq.h"
 
 struct kvm;
diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
index 76d46b2f41dd..b21b03aa2ee7 100644
--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -13,9 +13,9 @@
 #include <linux/mm_types.h>
 #include <linux/hrtimer.h>
 #include <linux/kvm_host.h>
+#include <linux/kvm_iodev.h>
 #include <linux/spinlock.h>
 
-#include <kvm/iodev.h>
 #include "lapic.h"
 
 #define PIC_NUM_PINS 16
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 4ce30db65828..43ffbded5f72 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -2,7 +2,7 @@
 #ifndef __KVM_X86_LAPIC_H
 #define __KVM_X86_LAPIC_H
 
-#include <kvm/iodev.h>
+#include <linux/kvm_iodev.h>
 
 #include <linux/kvm_host.h>
 
diff --git a/include/kvm/iodev.h b/include/linux/kvm_iodev.h
similarity index 100%
rename from include/kvm/iodev.h
rename to include/linux/kvm_iodev.h
diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 375d6285475e..d0f84e3611da 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -9,8 +9,7 @@
  *
  */
 
-#include <kvm/iodev.h>
-
+#include <linux/kvm_iodev.h>
 #include <linux/kvm_host.h>
 #include <linux/slab.h>
 #include <linux/kvm.h>
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 11e5d1e3f12e..35786d59b233 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -26,7 +26,7 @@
 #include <linux/irqbypass.h>
 #include <trace/events/kvm.h>
 
-#include <kvm/iodev.h>
+#include <linux/kvm_iodev.h>
 
 #ifdef CONFIG_HAVE_KVM_IRQCHIP
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index eec82775c5bf..a401ba32ecaa 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -10,9 +10,8 @@
  *   Yaniv Kamay  <yaniv@qumranet.com>
  */
 
-#include <kvm/iodev.h>
-
 #include <linux/kvm_host.h>
+#include <linux/kvm_iodev.h>
 #include <linux/kvm.h>
 #include <linux/module.h>
 #include <linux/errno.h>
-- 
2.50.0.rc0.642.g800a2b2222-goog


