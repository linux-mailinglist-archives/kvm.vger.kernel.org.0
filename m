Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 481AD58F323
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 21:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233039AbiHJTax (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 15:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232362AbiHJTaq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 15:30:46 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7744F74CE1
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 12:30:45 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-31f46b4759bso132562427b3.0
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 12:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=Kifgnty8wg8EK2E1LOfDfA0Z3FKljaVXfcfUN76Fd74=;
        b=AEHXNbwIZkZmVSCglicIZVkv9ps8jS4TWInv+dVN6TvLyORjLLwspMXTxneW8qNDkP
         pAvdD4cPTox2bYSpmt3hvFRKQWu3Oe6oqizbPO1YzT3OTytXBJznpfosafaQfsxFWzCP
         R3VelrImNZlAzUBz6UYiVXt5vclJnonNTMm+u7KzDpUNo+mItmtuI7f3+WiR9V8D1YIW
         oWank4bbjF/xuhdGeroyngL5kZXu8anYXjXXIwA4o29qD0xbr/Xn3FmWsor98lllNBgp
         NPUyaSKF6Y+U0lldeeYKnX7kHBt72E7mKKaKgsVVZV4129FiPlUPaDN5p0JT75uhKmwX
         J7YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=Kifgnty8wg8EK2E1LOfDfA0Z3FKljaVXfcfUN76Fd74=;
        b=gn/5vqnz5qB6uPU2z52GiaihKYbT6W9pj2wU5UhwlpzcHMhTa9qzZvOe5eM6stbDOh
         i23GI6fWdwNYNvW8PFHvlUsQXJD7JEEOUJNHo4s38r3ip5OEvtFyvGgpEcT38Umuk/4B
         +fhUXpu0nljBG1PiprBs6krrYBXOxRJgaMaIZZhUDx04Tpd9E8uSR2yUQyKQYnUh7GA1
         YWwX7umXEJ25yIcctjWfygvDbC7/4NDyjiXczu/epFfvGJr9VytAHhLIMBARdIViP0rs
         7NQnul3NylX3mLhlDgIsrEVS4u0qxfCt/zr8roQNkuhTBuFf2svUBxoFkHnT3gV03cML
         hFeA==
X-Gm-Message-State: ACgBeo2SZvCyyECfTAMJYCD5V5FitUXBW9ME1A/nZYfdr9EkxdTa1/lV
        eyKOP5u+kauzLWPz9/XfjwMV7HU=
X-Google-Smtp-Source: AA6agR5Kth9/FBYXU8AQovDLBQ+DreNq4HSnqEXzSbwbLJ9mXTKOmVoF4L3eTu2vV2OQ4bzGuxXgOBA=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:4d8b:fb2a:2ecb:c2bb])
 (user=pcc job=sendgmr) by 2002:a0d:ed83:0:b0:31d:3928:31b6 with SMTP id
 w125-20020a0ded83000000b0031d392831b6mr30111017ywe.98.1660159844817; Wed, 10
 Aug 2022 12:30:44 -0700 (PDT)
Date:   Wed, 10 Aug 2022 12:30:29 -0700
In-Reply-To: <20220810193033.1090251-1-pcc@google.com>
Message-Id: <20220810193033.1090251-4-pcc@google.com>
Mime-Version: 1.0
References: <20220810193033.1090251-1-pcc@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH v3 3/7] mm: Add PG_arch_3 page flag
From:   Peter Collingbourne <pcc@google.com>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc:     Peter Collingbourne <pcc@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>, kvm@vger.kernel.org,
        Steven Price <steven.price@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As with PG_arch_2, this flag is only allowed on 64-bit architectures due
to the shortage of bits available. It will be used by the arm64 MTE code
in subsequent patches.

Signed-off-by: Peter Collingbourne <pcc@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Steven Price <steven.price@arm.com>
[catalin.marinas@arm.com: added flag preserving in __split_huge_page_tail()]
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
v3:
- fix page flag dumping

 fs/proc/page.c                    | 1 +
 include/linux/kernel-page-flags.h | 1 +
 include/linux/page-flags.h        | 1 +
 include/trace/events/mmflags.h    | 7 ++++---
 mm/huge_memory.c                  | 1 +
 tools/vm/page-types.c             | 2 ++
 6 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/proc/page.c b/fs/proc/page.c
index a2873a617ae8..0129aa3cfb7a 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -220,6 +220,7 @@ u64 stable_page_flags(struct page *page)
 	u |= kpf_copy_bit(k, KPF_ARCH,		PG_arch_1);
 #ifdef CONFIG_64BIT
 	u |= kpf_copy_bit(k, KPF_ARCH_2,	PG_arch_2);
+	u |= kpf_copy_bit(k, KPF_ARCH_3,	PG_arch_3);
 #endif
 
 	return u;
diff --git a/include/linux/kernel-page-flags.h b/include/linux/kernel-page-flags.h
index eee1877a354e..859f4b0c1b2b 100644
--- a/include/linux/kernel-page-flags.h
+++ b/include/linux/kernel-page-flags.h
@@ -18,5 +18,6 @@
 #define KPF_UNCACHED		39
 #define KPF_SOFTDIRTY		40
 #define KPF_ARCH_2		41
+#define KPF_ARCH_3		42
 
 #endif /* LINUX_KERNEL_PAGE_FLAGS_H */
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 465ff35a8c00..ad01a3abf6c8 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -134,6 +134,7 @@ enum pageflags {
 #endif
 #ifdef CONFIG_64BIT
 	PG_arch_2,
+	PG_arch_3,
 #endif
 #ifdef CONFIG_KASAN_HW_TAGS
 	PG_skip_kasan_poison,
diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index 11524cda4a95..704380179986 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -91,9 +91,9 @@
 #endif
 
 #ifdef CONFIG_64BIT
-#define IF_HAVE_PG_ARCH_2(flag,string) ,{1UL << flag, string}
+#define IF_HAVE_PG_ARCH_2_3(flag,string) ,{1UL << flag, string}
 #else
-#define IF_HAVE_PG_ARCH_2(flag,string)
+#define IF_HAVE_PG_ARCH_2_3(flag,string)
 #endif
 
 #ifdef CONFIG_KASAN_HW_TAGS
@@ -129,7 +129,8 @@ IF_HAVE_PG_UNCACHED(PG_uncached,	"uncached"	)		\
 IF_HAVE_PG_HWPOISON(PG_hwpoison,	"hwpoison"	)		\
 IF_HAVE_PG_IDLE(PG_young,		"young"		)		\
 IF_HAVE_PG_IDLE(PG_idle,		"idle"		)		\
-IF_HAVE_PG_ARCH_2(PG_arch_2,		"arch_2"	)		\
+IF_HAVE_PG_ARCH_2_3(PG_arch_2,		"arch_2"	)		\
+IF_HAVE_PG_ARCH_2_3(PG_arch_3,		"arch_3"	)		\
 IF_HAVE_PG_SKIP_KASAN_POISON(PG_skip_kasan_poison, "skip_kasan_poison")
 
 #define show_page_flags(flags)						\
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 0611b2fd145a..262e9ca627fb 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2399,6 +2399,7 @@ static void __split_huge_page_tail(struct page *head, int tail,
 			 (1L << PG_unevictable) |
 #ifdef CONFIG_64BIT
 			 (1L << PG_arch_2) |
+			 (1L << PG_arch_3) |
 #endif
 			 (1L << PG_dirty)));
 
diff --git a/tools/vm/page-types.c b/tools/vm/page-types.c
index 381dcc00cb62..364373f5bba0 100644
--- a/tools/vm/page-types.c
+++ b/tools/vm/page-types.c
@@ -79,6 +79,7 @@
 #define KPF_UNCACHED		39
 #define KPF_SOFTDIRTY		40
 #define KPF_ARCH_2		41
+#define KPF_ARCH_3		42
 
 /* [47-] take some arbitrary free slots for expanding overloaded flags
  * not part of kernel API
@@ -138,6 +139,7 @@ static const char * const page_flag_names[] = {
 	[KPF_UNCACHED]		= "c:uncached",
 	[KPF_SOFTDIRTY]		= "f:softdirty",
 	[KPF_ARCH_2]		= "H:arch_2",
+	[KPF_ARCH_3]		= "H:arch_3",
 
 	[KPF_ANON_EXCLUSIVE]	= "d:anon_exclusive",
 	[KPF_READAHEAD]		= "I:readahead",
-- 
2.37.1.559.g78731f0fdb-goog

