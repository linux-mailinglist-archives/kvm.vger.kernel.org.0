Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D34A457D821
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 03:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233577AbiGVBvG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 21:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233520AbiGVBvE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 21:51:04 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EAE390DB0
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 18:51:03 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id m123-20020a253f81000000b0066ff6484995so2613897yba.22
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 18:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=TwIGZxOgt6rBe9wTaWtA8OadqnubKpslEOefQ0KlBYc=;
        b=NkaUVQiJc5jp+Kd2jx7nqyeLgTuFuMR+XL7JQsjYclkpdvHDVQSs++oKJUciE3moo+
         ++QPlhiRnCM5hnKWWKwiBeCGYNzfZRM70Zb8d/mMX9XxKQqkFWrFDMZRSYO/twzB9DN0
         tUhyOaKS+2VpTg2zP8AIXPINcgEvdnjIZfzofEXHRALLETPHGbIv2z7g7sbF89BagsaZ
         b/KrKcET0FOT7cYFKscqtzCKR+RGicAklN0CDyJtWmUdIv3BlWspqKD84OugLk/Qv9tT
         Dz4fo2RX85w/ryKRTsUDeumOGudpVjHMJzJIinDSj8vhiCxEZz5hgyjnyNLfK01rFbYu
         Z+iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=TwIGZxOgt6rBe9wTaWtA8OadqnubKpslEOefQ0KlBYc=;
        b=NwZwoEkxOLBh2VD/7LUTIipoPONPMIxspitRyFaJDbEvCT+0RJnm06MwDjopa210fr
         6ryXynx9Odp4BKQ8wyS+p9bqgxtOQhp5tkf1U34cMzeJDgl1gpI2Yz9+cb+kNMz1rQja
         SDIHyj9YKHo26Uy6Xquk/EHT67qpu/oPJa2jWmzhu+MDrGeKpa+RkEpEQalw7OEqhjSu
         7nhIJLtZH5yBzFF7xBBA27ZVvN2+qFxmj+VgGN3Pcfqoxz4oB6+ApkHWoAc+d0i0V4VL
         0Q2lWvEFKixrKySaOlayW0yOepuSPRXgtP1IGvJ2d3KbSGT9krhX4sHVGPd5nO+aFllY
         jEuQ==
X-Gm-Message-State: AJIora/joCTpWDK1+R2Rl4Y59MDPRIDgEcFv+8tJ3MyYsqYfrzlN1BPf
        q+gAfbGCdel74mqFUYJ8qjWhrsc=
X-Google-Smtp-Source: AGRyM1v5HWTX6JYtiwrUXhpyDwH9QneRyI4FxOnAArRXJ2u1OihyxjWyM/5NJuRzTZObSJn7lnprhPc=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:7ed4:5864:d5e1:ffe1])
 (user=pcc job=sendgmr) by 2002:a25:d512:0:b0:670:9301:a997 with SMTP id
 r18-20020a25d512000000b006709301a997mr1176046ybe.351.1658454662450; Thu, 21
 Jul 2022 18:51:02 -0700 (PDT)
Date:   Thu, 21 Jul 2022 18:50:29 -0700
In-Reply-To: <20220722015034.809663-1-pcc@google.com>
Message-Id: <20220722015034.809663-4-pcc@google.com>
Mime-Version: 1.0
References: <20220722015034.809663-1-pcc@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v2 3/7] mm: Add PG_arch_3 page flag
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
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
 fs/proc/page.c                 | 1 +
 include/linux/page-flags.h     | 1 +
 include/trace/events/mmflags.h | 7 ++++---
 mm/huge_memory.c               | 1 +
 4 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/proc/page.c b/fs/proc/page.c
index a2873a617ae8..438b8aa7249d 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -220,6 +220,7 @@ u64 stable_page_flags(struct page *page)
 	u |= kpf_copy_bit(k, KPF_ARCH,		PG_arch_1);
 #ifdef CONFIG_64BIT
 	u |= kpf_copy_bit(k, KPF_ARCH_2,	PG_arch_2);
+	u |= kpf_copy_bit(k, KPF_ARCH_2,	PG_arch_3);
 #endif
 
 	return u;
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
index 8320874901f1..d6e8789e9ebb 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2399,6 +2399,7 @@ static void __split_huge_page_tail(struct page *head, int tail,
 			 (1L << PG_unevictable) |
 #ifdef CONFIG_64BIT
 			 (1L << PG_arch_2) |
+			 (1L << PG_arch_3) |
 #endif
 			 (1L << PG_dirty)));
 
-- 
2.37.1.359.gd136c6c3e2-goog

