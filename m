Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 896F7618D7E
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 02:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbiKDBLS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 21:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiKDBLK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 21:11:10 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E064D23145
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 18:11:09 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id t6-20020a25b706000000b006b38040b6f7so3615635ybj.6
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 18:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rPYxlKSPJfSZtg3Q9jRN1rfy7iNW7lamdhzlzuPASYU=;
        b=EK2CfW/zJnZP96rUOilP2BktF4iuKcovvHFosZ0YeJeb3KtLyxVdRs+D+ycgLZnrDs
         /U1zBGKJpog9nLofxSIuFaqr2jVa7nL1vUHMZeBDya1ZBBx/l0v/fomj9VLAOL9zzhwn
         /Vpcsgo66C+hsDcSK7koi10JNVEgt5RMOa9zq41iBuvOQ9uSU0tZOW2vSe0r/Iq4/ojB
         sK2FOPfqs+DBQU+SdmnHptlRBihaxWXN/QOq4hb+Lj8xIpzIrJhxT+t9qkI/1UnsPe8M
         aaLWMX2hJsQBFMgxL5zDMHc5kkYNBCaDT1sNb4CTMZrELH7Yhw/M7cLA8ZI7KXAf6w3M
         7SlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rPYxlKSPJfSZtg3Q9jRN1rfy7iNW7lamdhzlzuPASYU=;
        b=GHa6f7Ga1UkJyp20dZVqVJtXgVDC5ook8tDxblLe4jCg39k7z0PAtnz6V/AsCPjChZ
         KBqytDOGRZQrp7xvsPL+04K7M8DnAzIbgpTmKVcoiFEDytJEk1O7/BsLh+QD+lqtBlUV
         2g5vk+weV04BYp69Tc8az7Su/wvytsUNi0vvKHvQodVxpDr6PRImG4XwTNHqIve5cgVu
         aLYt35zdEaU8j1++qFq5VNo4pLeL9xDqeOiMMLoI8ZCbHF8t+Fgt9ybFTr0VDiU90nGN
         KFuk5V9UDIbb2pRlafioiHVecvoOpQ2gy/Q6MGS92k2oNerbsQjjNMrkdTnZXwsgf1IK
         u01Q==
X-Gm-Message-State: ACrzQf2e/NzfZepa2tcLdlxf4uEHTVNTAtzTOnBrzXNhFbdMsQ19H9+Z
        YykIZHiRGZ/XEuoeDam3wYuMcHw=
X-Google-Smtp-Source: AMsMyM4lZ0RBt0V0qrjSEpyMHEmom8fBptSXrmNmTvgvtT7vTA4SH5SZJVwz3XGowF95qq3jHThGkOU=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:2844:b0ec:e556:30d8])
 (user=pcc job=sendgmr) by 2002:a81:5385:0:b0:370:b29:abb3 with SMTP id
 h127-20020a815385000000b003700b29abb3mr30405462ywb.2.1667524269214; Thu, 03
 Nov 2022 18:11:09 -0700 (PDT)
Date:   Thu,  3 Nov 2022 18:10:37 -0700
In-Reply-To: <20221104011041.290951-1-pcc@google.com>
Message-Id: <20221104011041.290951-5-pcc@google.com>
Mime-Version: 1.0
References: <20221104011041.290951-1-pcc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH v5 4/8] mm: Add PG_arch_3 page flag
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
Reviewed-by: Steven Price <steven.price@arm.com>
---
 fs/proc/page.c                    | 1 +
 include/linux/kernel-page-flags.h | 1 +
 include/linux/page-flags.h        | 1 +
 include/trace/events/mmflags.h    | 1 +
 mm/huge_memory.c                  | 1 +
 5 files changed, 5 insertions(+)

diff --git a/fs/proc/page.c b/fs/proc/page.c
index 882525c8e94c..6249c347809a 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -221,6 +221,7 @@ u64 stable_page_flags(struct page *page)
 	u |= kpf_copy_bit(k, KPF_ARCH,		PG_arch_1);
 #ifdef CONFIG_ARCH_USES_PG_ARCH_X
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
index 5dc7977edf9d..c50ce2812f17 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -134,6 +134,7 @@ enum pageflags {
 #endif
 #ifdef CONFIG_ARCH_USES_PG_ARCH_X
 	PG_arch_2,
+	PG_arch_3,
 #endif
 #ifdef CONFIG_KASAN_HW_TAGS
 	PG_skip_kasan_poison,
diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index 4673e58a7626..9db52bc4ce19 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -130,6 +130,7 @@ IF_HAVE_PG_HWPOISON(PG_hwpoison,	"hwpoison"	)		\
 IF_HAVE_PG_IDLE(PG_young,		"young"		)		\
 IF_HAVE_PG_IDLE(PG_idle,		"idle"		)		\
 IF_HAVE_PG_ARCH_X(PG_arch_2,		"arch_2"	)		\
+IF_HAVE_PG_ARCH_X(PG_arch_3,		"arch_3"	)		\
 IF_HAVE_PG_SKIP_KASAN_POISON(PG_skip_kasan_poison, "skip_kasan_poison")
 
 #define show_page_flags(flags)						\
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 5d87dc4611b9..c509011bd4a2 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2403,6 +2403,7 @@ static void __split_huge_page_tail(struct page *head, int tail,
 			 (1L << PG_unevictable) |
 #ifdef CONFIG_ARCH_USES_PG_ARCH_X
 			 (1L << PG_arch_2) |
+			 (1L << PG_arch_3) |
 #endif
 			 (1L << PG_dirty) |
 			 LRU_GEN_MASK | LRU_REFS_MASK));
-- 
2.38.1.431.g37b22c650d-goog

