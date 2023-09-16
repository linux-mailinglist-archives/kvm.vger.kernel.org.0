Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7507A2C73
	for <lists+kvm@lfdr.de>; Sat, 16 Sep 2023 02:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238639AbjIPAdY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 20:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238870AbjIPAdJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 20:33:09 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F53197
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 17:31:45 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-59beb3a8291so33634067b3.1
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 17:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694824304; x=1695429104; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=T4d9JtkzBqCpjbUcqi6GepdBrHqatH15LR+RcbQRSno=;
        b=TRJ05qkikeAFbtjeAVx1soHRBMwfMmICSMxDL3NqsjXKuPVJFKwL/Xj9QGZFgLO+XY
         NQsEOkCJLeopu+07c1zKvPw/bjH3fDjxvda9AVeqF5ZOGzmKImlUk2N/QBYa8b+dIBST
         jO1PE1VbwLZlbiC5oSro83X1D5XECqRnvUxeL91RtnK33fWA5CGmW1IUB0EaiAkazUdg
         7/+Vcxnp6FwTEfdMwaTKGZvMEhrWdRuhv/00SCWeK7G46wfFINhKKIQyUB9ct1yVSAbK
         t28d8TgxkozGsV2svrC1aaS0dJFxM+x1IMmpSf3VkggGAZ9WdoZh9z1sAgE0ZsrimOyz
         TVog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694824304; x=1695429104;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T4d9JtkzBqCpjbUcqi6GepdBrHqatH15LR+RcbQRSno=;
        b=kjyFVpDXzo4lXIf8mr3vJgXDnsxqyYKaFbGLmEnt74SZy714o+rHM/8Xr/PClfbHHC
         0bY8AaIEpaAqnZ40DoZorOFJtTTLaBW7geNhXqjMkCrLafNEv98uyaNGpMLfBqQiLHyj
         MN2KexI2KfVwJqLbF1nWjBX28N5UbAAjObJX2b4021FhF41ZSyyIERp3zmKaqlL83aWU
         yR00nsY9kve5qJc3ieIy/VglR9+0/8NTojPaPNKxEALLo2eBdk3AGnta+gCwn/Ybfg8F
         jLNPnISP5TQeUZS659GcPqgSRUwZT6GEfkmbX1UOnJaAyFWFm0wl+O5AKp1PawKzBQEv
         /nbw==
X-Gm-Message-State: AOJu0YwLA7x/I8HMW7L3n2Qvdc5iGhdctDCeioNpjiURq6eZpnWkqKb1
        qgGaDxKwgaQqnBFrLwgW9HxYHgWe5sg=
X-Google-Smtp-Source: AGHT+IFHuI3+InjaYoGpeoRnBjmpOWBEwR2qvNTEjtEAfl3mVa5tl1N1hW80goIMLDXxJcvVvIl5YUYpSE0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:181b:b0:d81:4107:7a1 with SMTP id
 cf27-20020a056902181b00b00d81410707a1mr70396ybb.2.1694824304643; Fri, 15 Sep
 2023 17:31:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Sep 2023 17:31:04 -0700
In-Reply-To: <20230916003118.2540661-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230916003118.2540661-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
Message-ID: <20230916003118.2540661-13-seanjc@google.com>
Subject: [PATCH 12/26] KVM: arm64: Move arm_{psci,hypercalls}.h to an internal
 KVM path
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
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Anish Ghulati <aghulati@google.com>

Move arm_hypercalls.h and arm_psci.h into arch/arm64/kvm now that KVM
no longer supports 32-bit ARM, i.e. now that there's no reason to make
the hypercall and PSCI APIs "public".

Signed-off-by: Anish Ghulati <aghulati@google.com>
[sean: squash into one patch, write changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/arm.c                         | 5 +++--
 {include => arch/arm64}/kvm/arm_hypercalls.h | 0
 {include => arch/arm64}/kvm/arm_psci.h       | 0
 arch/arm64/kvm/guest.c                       | 2 +-
 arch/arm64/kvm/handle_exit.c                 | 2 +-
 arch/arm64/kvm/hyp/Makefile                  | 4 ++--
 arch/arm64/kvm/hyp/include/hyp/switch.h      | 4 ++--
 arch/arm64/kvm/hyp/nvhe/switch.c             | 4 ++--
 arch/arm64/kvm/hyp/vhe/switch.c              | 4 ++--
 arch/arm64/kvm/hypercalls.c                  | 4 ++--
 arch/arm64/kvm/psci.c                        | 4 ++--
 arch/arm64/kvm/pvtime.c                      | 2 +-
 arch/arm64/kvm/trng.c                        | 2 +-
 13 files changed, 19 insertions(+), 18 deletions(-)
 rename {include => arch/arm64}/kvm/arm_hypercalls.h (100%)
 rename {include => arch/arm64}/kvm/arm_psci.h (100%)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 4866b3f7b4ea..6de1d63b981b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -41,9 +41,10 @@
 #include <asm/kvm_emulate.h>
 #include <asm/sections.h>
 
-#include <kvm/arm_hypercalls.h>
 #include <kvm/arm_pmu.h>
-#include <kvm/arm_psci.h>
+
+#include "arm_hypercalls.h"
+#include "arm_psci.h"
 
 static enum kvm_mode kvm_mode = KVM_MODE_DEFAULT;
 
diff --git a/include/kvm/arm_hypercalls.h b/arch/arm64/kvm/arm_hypercalls.h
similarity index 100%
rename from include/kvm/arm_hypercalls.h
rename to arch/arm64/kvm/arm_hypercalls.h
diff --git a/include/kvm/arm_psci.h b/arch/arm64/kvm/arm_psci.h
similarity index 100%
rename from include/kvm/arm_psci.h
rename to arch/arm64/kvm/arm_psci.h
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 95f6945c4432..32045ad51ec4 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -18,7 +18,6 @@
 #include <linux/string.h>
 #include <linux/vmalloc.h>
 #include <linux/fs.h>
-#include <kvm/arm_hypercalls.h>
 #include <asm/cputype.h>
 #include <linux/uaccess.h>
 #include <asm/fpsimd.h>
@@ -27,6 +26,7 @@
 #include <asm/kvm_nested.h>
 #include <asm/sigcontext.h>
 
+#include "arm_hypercalls.h"
 #include "trace.h"
 
 const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 617ae6dea5d5..f1d02d6f8683 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -21,7 +21,7 @@
 #include <asm/stacktrace/nvhe.h>
 #include <asm/traps.h>
 
-#include <kvm/arm_hypercalls.h>
+#include "arm_hypercalls.h"
 
 #define CREATE_TRACE_POINTS
 #include "trace_handle_exit.h"
diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index a38dea6186c9..4ce8c86967b5 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -4,7 +4,7 @@
 #
 
 incdir := $(srctree)/$(src)/include
-subdir-asflags-y := -I$(incdir)
-subdir-ccflags-y := -I$(incdir)
+subdir-asflags-y := -I$(incdir) -I$(srctree)/arch/arm64/kvm
+subdir-ccflags-y := -I$(incdir) -I$(srctree)/arch/arm64/kvm
 
 obj-$(CONFIG_KVM) += vhe/ nvhe/ pgtable.o
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 9cfe6bd1dbe4..cd21cf71d7db 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -16,8 +16,6 @@
 #include <linux/jump_label.h>
 #include <uapi/linux/psci.h>
 
-#include <kvm/arm_psci.h>
-
 #include <asm/barrier.h>
 #include <asm/cpufeature.h>
 #include <asm/extable.h>
@@ -31,6 +29,8 @@
 #include <asm/debug-monitors.h>
 #include <asm/processor.h>
 
+#include "arm_psci.h"
+
 struct kvm_exception_table_entry {
 	int insn, fixup;
 };
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index c353a06ee7e6..c0553ac36a46 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -13,8 +13,6 @@
 #include <linux/jump_label.h>
 #include <uapi/linux/psci.h>
 
-#include <kvm/arm_psci.h>
-
 #include <asm/barrier.h>
 #include <asm/cpufeature.h>
 #include <asm/kprobes.h>
@@ -29,6 +27,8 @@
 #include <nvhe/fixed_config.h>
 #include <nvhe/mem_protect.h>
 
+#include "arm_psci.h"
+
 /* Non-VHE specific context */
 DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
 DEFINE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 6537f58b1a8c..f7423c890b5c 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -13,8 +13,6 @@
 #include <linux/percpu.h>
 #include <uapi/linux/psci.h>
 
-#include <kvm/arm_psci.h>
-
 #include <asm/barrier.h>
 #include <asm/cpufeature.h>
 #include <asm/kprobes.h>
@@ -28,6 +26,8 @@
 #include <asm/thread_info.h>
 #include <asm/vectors.h>
 
+#include "arm_psci.h"
+
 /* VHE specific context */
 DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
 DEFINE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 7fb4df0456de..d34a31c9ace2 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -6,8 +6,8 @@
 
 #include <asm/kvm_emulate.h>
 
-#include <kvm/arm_hypercalls.h>
-#include <kvm/arm_psci.h>
+#include "arm_hypercalls.h"
+#include "arm_psci.h"
 
 #define KVM_ARM_SMCCC_STD_FEATURES				\
 	GENMASK(KVM_REG_ARM_STD_BMAP_BIT_COUNT - 1, 0)
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 1f69b667332b..c461e15026c9 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -13,8 +13,8 @@
 #include <asm/cputype.h>
 #include <asm/kvm_emulate.h>
 
-#include <kvm/arm_psci.h>
-#include <kvm/arm_hypercalls.h>
+#include "arm_hypercalls.h"
+#include "arm_psci.h"
 
 /*
  * This is an implementation of the Power State Coordination Interface
diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
index 4ceabaa4c30b..b07d250d223c 100644
--- a/arch/arm64/kvm/pvtime.c
+++ b/arch/arm64/kvm/pvtime.c
@@ -8,7 +8,7 @@
 #include <asm/kvm_mmu.h>
 #include <asm/pvclock-abi.h>
 
-#include <kvm/arm_hypercalls.h>
+#include "arm_hypercalls.h"
 
 void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/arm64/kvm/trng.c b/arch/arm64/kvm/trng.c
index 99bdd7103c9c..b5dc0f09797a 100644
--- a/arch/arm64/kvm/trng.c
+++ b/arch/arm64/kvm/trng.c
@@ -6,7 +6,7 @@
 
 #include <asm/kvm_emulate.h>
 
-#include <kvm/arm_hypercalls.h>
+#include "arm_hypercalls.h"
 
 #define ARM_SMCCC_TRNG_VERSION_1_0	0x10000UL
 
-- 
2.42.0.459.ge4e396fd5e-goog

