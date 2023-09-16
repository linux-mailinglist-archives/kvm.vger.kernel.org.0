Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1207A2C3D
	for <lists+kvm@lfdr.de>; Sat, 16 Sep 2023 02:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238711AbjIPAc6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 20:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238781AbjIPAco (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 20:32:44 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C74D42D76
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 17:31:51 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-59c0dd156e5so14959287b3.3
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 17:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694824311; x=1695429111; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=K+4wLZRg/fEoTWN91R6Hud4ODei52D2o77Nnp/okXhc=;
        b=HpUBRAj0XTY8DTNT1FZXthO/kSUOHmAEXO4Q6EhzM0LLh4eWwJNsfSzzJQy4JG7wgl
         uHgcmdWBUTyHrwKfxFI1+YiDBQO8Q4eOGiwgTmrQYiIyq9FNgYNvubdkVnIXolF31lan
         kIpDyUwVM02vSYN09CzeS1b9JuIlEyUmMXh2avqsuwVm+aUDzIgzyqffJyUNWLq1YpC+
         XHGxYiWcZerKCRd5PCOzWM65cPccrVVJi69aEx0/jpc49BkOL/VFoEwz06TfXemgmndW
         rW0QrCRYemg3jK3M21kw/9dNwqFf/AsmVtFrgU6jqfsvmj2p1mlsQ9AmgCQ9m6lIVqqy
         dc1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694824311; x=1695429111;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K+4wLZRg/fEoTWN91R6Hud4ODei52D2o77Nnp/okXhc=;
        b=YIhFTHnd2tYo1rIrB3kEqTD/Ur1CYrKPg8yEGx/nhuWAx26wLqlv1DbwF9qI7hKSLL
         cmRuJFpwYuvtEtZtVr8BiDk9kKpzzHa/jwZ+kYoASwXnm4685Ts4VLylYJsXrt1YigTw
         5rDP0k3H6Q+vc76amvb5qv2gS9DXZiyv123YdQ+vit8PvAc8BWNex/+2xe11Z/vVsrCA
         QfrauAgKivlbcQYHdprDzS8o1VuX/xwb7B29jlJ6PSxZfoF8TwDRlcb8/ogbpttE61uD
         FZJ2nOlq6/jDDxmZPC7FTx4aILqz/1ghAu+0OyrBg48HP7WZPV0bwPJkf6m6kiJscfRV
         KrMA==
X-Gm-Message-State: AOJu0YwphMfEOz2cSc6KnwB8Y+IE/t85/K/kz4dt3GEKkXONBpN3LTxl
        /XLdDwjxoZHkUCsaAGBlfwhvJLFimDc=
X-Google-Smtp-Source: AGHT+IGeLhjeWaYzJPE1mCnK9Csjwjlwkmu8U9lPUcubvqyfYiZpHoa2TM+ffhRiOESL+mVFdN06uDg2kmM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ca08:0:b0:59b:f493:813c with SMTP id
 p8-20020a81ca08000000b0059bf493813cmr84977ywi.9.1694824310900; Fri, 15 Sep
 2023 17:31:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Sep 2023 17:31:07 -0700
In-Reply-To: <20230916003118.2540661-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230916003118.2540661-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
Message-ID: <20230916003118.2540661-16-seanjc@google.com>
Subject: [PATCH 15/26] KVM: Move include/kvm/iodev.h to include/linux as kvm_iodev.h
From:   Sean Christopherson <seanjc@google.com>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Andy Lutomirski <luto@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Anish Ghulati <aghulati@google.com>,
        Venkatesh Srinivas <venkateshs@chromium.org>,
        Andrew Thornton <andrewth@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move iodev.h, the last remaining holdout in include/kvm, to the standard
include/linux directory as kvm_iodev.h and delete include/kvm.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 MAINTAINERS                                | 1 -
 arch/arm64/include/asm/kvm_vgic.h          | 2 +-
 arch/arm64/kvm/vgic/vgic-mmio-v2.c         | 2 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c         | 2 +-
 arch/arm64/kvm/vgic/vgic-mmio.c            | 2 +-
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
 17 files changed, 15 insertions(+), 19 deletions(-)
 rename include/{kvm/iodev.h => linux/kvm_iodev.h} (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 90f13281d297..ddc8375d536c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11498,7 +11498,6 @@ W:	http://www.linux-kvm.org
 T:	git git://git.kernel.org/pub/scm/virt/kvm/kvm.git
 F:	Documentation/virt/kvm/
 F:	include/asm-generic/kvm*
-F:	include/kvm/iodev.h
 F:	include/linux/kvm*
 F:	include/trace/events/kvm.h
 F:	include/uapi/asm-generic/kvm*
diff --git a/arch/arm64/include/asm/kvm_vgic.h b/arch/arm64/include/asm/kvm_vgic.h
index 5b27f94d4fad..2ca52888bc75 100644
--- a/arch/arm64/include/asm/kvm_vgic.h
+++ b/arch/arm64/include/asm/kvm_vgic.h
@@ -13,7 +13,7 @@
 #include <linux/spinlock.h>
 #include <linux/static_key.h>
 #include <linux/types.h>
-#include <kvm/iodev.h>
+#include <linux/kvm_iodev.h>
 #include <linux/list.h>
 #include <linux/jump_label.h>
 
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v2.c b/arch/arm64/kvm/vgic/vgic-mmio-v2.c
index bba0cfeefffe..646053ee892f 100644
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
index d54a90beef61..b79a2e860415 100644
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
index 68a3d8062473..4feca3b1d915 100644
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
 
diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 54a85f1d4f2c..f8f63d0aa399 100644
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
index 39e72aa016a4..b49e747f2bad 100644
--- a/arch/riscv/kvm/aia_aplic.c
+++ b/arch/riscv/kvm/aia_aplic.c
@@ -11,7 +11,7 @@
 #include <linux/math.h>
 #include <linux/spinlock.h>
 #include <linux/swab.h>
-#include <kvm/iodev.h>
+#include <linux/kvm_iodev.h>
 #include <asm/kvm_aia_aplic.h>
 
 struct aplic_irq {
diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
index 6cf23b8adb71..586e466a1c6d 100644
--- a/arch/riscv/kvm/aia_imsic.c
+++ b/arch/riscv/kvm/aia_imsic.c
@@ -10,10 +10,10 @@
 #include <linux/atomic.h>
 #include <linux/bitmap.h>
 #include <linux/kvm_host.h>
+#include <linux/kvm_iodev.h>
 #include <linux/math.h>
 #include <linux/spinlock.h>
 #include <linux/swab.h>
-#include <kvm/iodev.h>
 #include <asm/csr.h>
 #include <asm/kvm_aia_imsic.h>
 
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
index 539333ac4b38..2beec2daf1a3 100644
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
index c2d7cfe82d00..f9530e9a66f8 100644
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
index 0a0ea4b5dd8c..bfd99ad1882e 100644
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
index 1b90acb6e3fe..cfcb4b84d632 100644
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
index 89912a17f5d5..4d7cfb1095fd 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -26,7 +26,7 @@
 #include <linux/irqbypass.h>
 #include <trace/events/kvm.h>
 
-#include <kvm/iodev.h>
+#include <linux/kvm_iodev.h>
 
 #ifdef CONFIG_HAVE_KVM_IRQFD
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 486800a7024b..f585a159b4f5 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -13,9 +13,8 @@
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
2.42.0.459.ge4e396fd5e-goog

