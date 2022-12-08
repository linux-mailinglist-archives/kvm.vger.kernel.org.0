Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 814996476BF
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 20:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbiLHTl1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 14:41:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbiLHTkk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 14:40:40 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F4D389CD
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 11:40:20 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-39afd53dcdbso24756187b3.8
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 11:40:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9jkEeOR+eFVYLdV/biNhqONLCqpOOeuWNQBN9kUw+a4=;
        b=RcX1fA9WGa6w4C9PUxG4OPVBo1zxjA/xcbKeSP6a3foCAqZ7FzqI1mFwD63t1Zj64f
         dUcsVkx5+LL+NIjjNV1LqNWVddFOpYikSd3WUTyGFLn96H50k7PwdHsttsFJt9P1ez0b
         1mfPx6AlqK6ylftXIU2F9Nj5hSc+ikFrGZ/z1f/qPxYxfvx/OXVl/tDLZo61SUF3zvKK
         PYv1RXX6MMcltPMtFw1Jp+095PHbtWtFgqbpJbKkr0cp5YLn1DUp9X/nB2YNG55HXF6K
         /rKkgYv9i7/aE4/qJBLcexm7xz9bNSYN/tkjp5XaQYlxAPljLege78wWIo+X1uBQR1Re
         /MJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9jkEeOR+eFVYLdV/biNhqONLCqpOOeuWNQBN9kUw+a4=;
        b=j7g0ZXLgALwEFBKS5lanE7XCmTG9lvmu/N5a/IFd7SDh8RM7K1cokbDf45S9+kDRy3
         KBxqND/rkOIl91etfvpsfH1GIBO1ypeIqNt07+jgutTHncGvj/2IPtXeCd2iddAvWtKD
         08C7vNZ6aPbrfQLfwXAT4BI+MTJs9+NGphS6FFF9+X8XARMnwSeZbu5FvOZcccrlRlAb
         h7jSR/OMUA+u/UZhxcwhAyBODrhcXE3zl+ikmGhV+lhYPOGdq6u4JPgW7G0qHJ69Hz/h
         e56wXIyBPgFGnp3c57FJoaGBRUTeQ4gI1MqCpQWa0WqZesgDP2qDPY7VxoBjNzHimot2
         AkOQ==
X-Gm-Message-State: ANoB5plgEKWK5fjSZ7GtL5Gl0dntB3FM6DiMh1xFFbwt9kd6GaPhoyNh
        Z+8gHR6mfT8rChWVL7tgO+2YphIXZbrPqg==
X-Google-Smtp-Source: AA0mqf5Y/oazogGX+tpbF7bdOJO4aayzIsYsnlV7zDudirQdvI5dtEVAX371oDYlEt+kHPpaNkmdcoOtQ7CEag==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:c6c2:0:b0:6f0:b351:c300 with SMTP id
 k185-20020a25c6c2000000b006f0b351c300mr63444626ybf.102.1670528409549; Thu, 08
 Dec 2022 11:40:09 -0800 (PST)
Date:   Thu,  8 Dec 2022 11:38:57 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-38-dmatlack@google.com>
Subject: [RFC PATCH 37/37] KVM: MMU: Move the TDP MMU to common code
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move tdp_mmu.[ch] from arch/x86 and into the common code directories.
This will allow other architectures to use the TDP MMU in the future.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/Makefile                       | 2 +-
 arch/x86/kvm/mmu/mmu.c                      | 3 ++-
 {arch/x86/kvm/mmu => include/kvm}/tdp_mmu.h | 6 +++++-
 virt/kvm/Makefile.kvm                       | 1 +
 {arch/x86 => virt}/kvm/mmu/tdp_mmu.c        | 8 +++-----
 5 files changed, 12 insertions(+), 8 deletions(-)
 rename {arch/x86/kvm/mmu => include/kvm}/tdp_mmu.h (94%)
 rename {arch/x86 => virt}/kvm/mmu/tdp_mmu.c (99%)

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index cb9ae306892a..06b61fdea539 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -18,7 +18,7 @@ ifdef CONFIG_HYPERV
 kvm-y			+= kvm_onhyperv.o
 endif
 
-kvm-$(CONFIG_X86_64) += mmu/tdp_pgtable.o mmu/tdp_mmu.o
+kvm-$(CONFIG_X86_64)	+= mmu/tdp_pgtable.o
 kvm-$(CONFIG_KVM_XEN)	+= xen.o
 kvm-$(CONFIG_KVM_SMM)	+= smm.o
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f2602ee1771f..8653776bca6f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -19,7 +19,6 @@
 #include "ioapic.h"
 #include "mmu.h"
 #include "mmu_internal.h"
-#include "tdp_mmu.h"
 #include "x86.h"
 #include "kvm_cache_regs.h"
 #include "smm.h"
@@ -27,6 +26,8 @@
 #include "cpuid.h"
 #include "spte.h"
 
+#include <kvm/tdp_mmu.h>
+
 #include <linux/kvm_host.h>
 #include <linux/types.h>
 #include <linux/string.h>
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/include/kvm/tdp_mmu.h
similarity index 94%
rename from arch/x86/kvm/mmu/tdp_mmu.h
rename to include/kvm/tdp_mmu.h
index 607c1417abd1..538c848149c9 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/include/kvm/tdp_mmu.h
@@ -5,7 +5,11 @@
 
 #include <linux/kvm_host.h>
 
-#include "spte.h"
+#include <kvm/mmu_types.h>
+#include <kvm/mmu.h>
+#include <kvm/tdp_iter.h>
+#include <kvm/tdp_pgtable.h>
+#include <kvm/mmutrace.h>
 
 int kvm_mmu_init_tdp_mmu(struct kvm *kvm);
 void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
diff --git a/virt/kvm/Makefile.kvm b/virt/kvm/Makefile.kvm
index 58b595ac9b8d..942681308140 100644
--- a/virt/kvm/Makefile.kvm
+++ b/virt/kvm/Makefile.kvm
@@ -14,3 +14,4 @@ kvm-$(CONFIG_HAVE_KVM_DIRTY_RING) += $(KVM)/dirty_ring.o
 kvm-$(CONFIG_HAVE_KVM_PFNCACHE) += $(KVM)/pfncache.o
 
 kvm-$(CONFIG_HAVE_TDP_MMU) += $(KVM)/mmu/tdp_iter.o
+kvm-$(CONFIG_HAVE_TDP_MMU) += $(KVM)/mmu/tdp_mmu.o
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/virt/kvm/mmu/tdp_mmu.c
similarity index 99%
rename from arch/x86/kvm/mmu/tdp_mmu.c
rename to virt/kvm/mmu/tdp_mmu.c
index c950d688afea..5ca8892ebef5 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/virt/kvm/mmu/tdp_mmu.c
@@ -1,11 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
 
-#include "mmu.h"
-#include "mmu_internal.h"
-#include "tdp_mmu.h"
-#include "spte.h"
-
+#include <kvm/mmu_types.h>
+#include <kvm/mmu.h>
 #include <kvm/tdp_iter.h>
+#include <kvm/tdp_mmu.h>
 #include <kvm/tdp_pgtable.h>
 #include <kvm/mmutrace.h>
 
-- 
2.39.0.rc1.256.g54fd8350bd-goog

