Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF68A6476B9
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 20:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbiLHTlS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 14:41:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbiLHTka (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 14:40:30 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59CC185D13
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 11:40:14 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id x79-20020a633152000000b004785d1cf6bbso1616409pgx.6
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 11:40:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7el2leYxw6DuE2TKpxO/GVa0AQVZhVPYSCMmz19ZHuI=;
        b=O++bFFpSURwB8JUZDeWwEc8lxc4/9crS2K4HsyuyBbvilW8kdB4FZPUpBapa95NsxY
         0xO+2BUFvsH7Lv9OpM/ZNw6lAX1BZkwmvpchLqFMC1N46mGiLFFJBG/HkNWtdDFKz0HV
         gaJZcacGlJwuJDiHLoKW0WYD/nKr6azk72Tngx5olXe8pBzakRuhI16DprQMVZTjM2QI
         klMPqFL6afDQzxyjJFzvNFwT6YpAogs4p8iE9rScX7ZpN21ivdBFghpL37wrQT+9CnOv
         tdduCPP5Ti74kCPUwjTk76Ln1pEwMrFI/tCITETf7aNuyVpMp2Rq1UKSZarbJfTksvTP
         6Wqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7el2leYxw6DuE2TKpxO/GVa0AQVZhVPYSCMmz19ZHuI=;
        b=gox+HenjPYLQgj/F4pFXz9SdZivFqd4atJWdTU56J1waXUqHX7wuDOJJEb8Bpq7boB
         tru6x1XusYRLagluaebq6RBDAKDWQvqPo4Ll6rjU/aYvxnFldV+6Q7ePJg1MLKoI5mkZ
         9EztEjJvdMYGdm7oteKOFUzfjU+qBWMtpTc8ndnVQaN6qEz7dkDUJnBOuIUC+lw07fJp
         9zULphH+bwptXa7U7bjR4k5KJTxeGm7eNQLd46aoNwZsI4Y8pOTmEnzgLEXCOC14amaA
         TDJjLunY6+p0JZD90RnKQOGTcHuMQpKNGRMnFmobFzGOhIseV5Pn+ymKZMRY1Uo5wG1x
         sR9g==
X-Gm-Message-State: ANoB5pldSTShI1pWtBcdytdVKlMl/5WY2TDfmmSIPu527eLTP2x8zf9u
        vfHe6eV40Y5c5sh62YNig2NxvE758JwOOA==
X-Google-Smtp-Source: AA0mqf4ImIWXetG7XX1SXxRXGnECaJ0ODlsgksb3SPKCTTh3sr1uwrp/2qso+8Xm6A48WDYB3HG6hZIxDgKp9g==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:2183:b0:574:2104:5657 with SMTP
 id h3-20020a056a00218300b0057421045657mr5713585pfi.58.1670528404717; Thu, 08
 Dec 2022 11:40:04 -0800 (PST)
Date:   Thu,  8 Dec 2022 11:38:54 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-35-dmatlack@google.com>
Subject: [RFC PATCH 34/37] KVM: MMU: Move the TDP iterator to common code
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Matlack <dmatlack@google.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Nadav Amit <namit@vmware.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Yu Zhao <yuzhao@google.com>,
        Colin Cross <ccross@google.com>,
        Hugh Dickins <hughd@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move arch/x86/kvm/mmu/tdp_iter.{c,h} to into common code so that it can
be used by other architectures in the future.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 MAINTAINERS                                  | 2 +-
 arch/x86/kvm/Makefile                        | 2 +-
 arch/x86/kvm/mmu/tdp_mmu.c                   | 2 +-
 arch/x86/kvm/mmu/tdp_pgtable.c               | 2 +-
 {arch/x86/kvm/mmu => include/kvm}/tdp_iter.h | 9 +++------
 virt/kvm/Makefile.kvm                        | 2 ++
 {arch/x86 => virt}/kvm/mmu/tdp_iter.c        | 4 +---
 7 files changed, 10 insertions(+), 13 deletions(-)
 rename {arch/x86/kvm/mmu => include/kvm}/tdp_iter.h (96%)
 rename {arch/x86 => virt}/kvm/mmu/tdp_iter.c (98%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7e586d7ba78c..3c33eca85480 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11206,7 +11206,7 @@ F:	include/uapi/asm-generic/kvm*
 F:	include/uapi/linux/kvm*
 F:	tools/kvm/
 F:	tools/testing/selftests/kvm/
-F:	virt/kvm/*
+F:	virt/kvm/
 
 KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)
 M:	Marc Zyngier <maz@kernel.org>
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index c294ae51caba..cb9ae306892a 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -18,7 +18,7 @@ ifdef CONFIG_HYPERV
 kvm-y			+= kvm_onhyperv.o
 endif
 
-kvm-$(CONFIG_X86_64) += mmu/tdp_pgtable.o mmu/tdp_iter.o mmu/tdp_mmu.o
+kvm-$(CONFIG_X86_64) += mmu/tdp_pgtable.o mmu/tdp_mmu.o
 kvm-$(CONFIG_KVM_XEN)	+= xen.o
 kvm-$(CONFIG_KVM_SMM)	+= smm.o
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 1f1f511cd1a0..c035c051161c 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -2,10 +2,10 @@
 
 #include "mmu.h"
 #include "mmu_internal.h"
-#include "tdp_iter.h"
 #include "tdp_mmu.h"
 #include "spte.h"
 
+#include <kvm/tdp_iter.h>
 #include <kvm/tdp_pgtable.h>
 #include <kvm/mmutrace.h>
 
diff --git a/arch/x86/kvm/mmu/tdp_pgtable.c b/arch/x86/kvm/mmu/tdp_pgtable.c
index cc7b10f703e1..fb40abdb9234 100644
--- a/arch/x86/kvm/mmu/tdp_pgtable.c
+++ b/arch/x86/kvm/mmu/tdp_pgtable.c
@@ -2,10 +2,10 @@
 
 #include <linux/kvm_types.h>
 #include <kvm/tdp_pgtable.h>
+#include <kvm/tdp_iter.h>
 
 #include "mmu.h"
 #include "spte.h"
-#include "tdp_iter.h"
 
 /* Removed SPTEs must not be misconstrued as shadow present PTEs. */
 static_assert(!(REMOVED_TDP_PTE & SPTE_MMU_PRESENT_MASK));
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/include/kvm/tdp_iter.h
similarity index 96%
rename from arch/x86/kvm/mmu/tdp_iter.h
rename to include/kvm/tdp_iter.h
index 6e3c38532d1d..0a154fcf2664 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/include/kvm/tdp_iter.h
@@ -1,14 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0
 
-#ifndef __KVM_X86_MMU_TDP_ITER_H
-#define __KVM_X86_MMU_TDP_ITER_H
+#ifndef __KVM_TDP_ITER_H
+#define __KVM_TDP_ITER_H
 
 #include <linux/kvm_host.h>
 #include <kvm/tdp_pgtable.h>
 
-#include "mmu.h"
-#include "spte.h"
-
 /*
  * TDP MMU SPTEs are RCU protected to allow paging structures (non-leaf SPTEs)
  * to be zapped while holding mmu_lock for read, and to allow TLB flushes to be
@@ -117,4 +114,4 @@ void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
 void tdp_iter_next(struct tdp_iter *iter);
 void tdp_iter_restart(struct tdp_iter *iter);
 
-#endif /* __KVM_X86_MMU_TDP_ITER_H */
+#endif /* __KVM_TDP_ITER_H */
diff --git a/virt/kvm/Makefile.kvm b/virt/kvm/Makefile.kvm
index 2c27d5d0c367..58b595ac9b8d 100644
--- a/virt/kvm/Makefile.kvm
+++ b/virt/kvm/Makefile.kvm
@@ -12,3 +12,5 @@ kvm-$(CONFIG_KVM_ASYNC_PF) += $(KVM)/async_pf.o
 kvm-$(CONFIG_HAVE_KVM_IRQ_ROUTING) += $(KVM)/irqchip.o
 kvm-$(CONFIG_HAVE_KVM_DIRTY_RING) += $(KVM)/dirty_ring.o
 kvm-$(CONFIG_HAVE_KVM_PFNCACHE) += $(KVM)/pfncache.o
+
+kvm-$(CONFIG_HAVE_TDP_MMU) += $(KVM)/mmu/tdp_iter.o
diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/virt/kvm/mmu/tdp_iter.c
similarity index 98%
rename from arch/x86/kvm/mmu/tdp_iter.c
rename to virt/kvm/mmu/tdp_iter.c
index d5f024b7f6e4..674d93f91979 100644
--- a/arch/x86/kvm/mmu/tdp_iter.c
+++ b/virt/kvm/mmu/tdp_iter.c
@@ -1,8 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 
-#include "mmu_internal.h"
-#include "tdp_iter.h"
-#include "spte.h"
+#include <kvm/tdp_iter.h>
 
 /*
  * Recalculates the pointer to the SPTE for the current GFN and level and
-- 
2.39.0.rc1.256.g54fd8350bd-goog

