Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7868D5BF50C
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 05:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbiIUDxH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 23:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbiIUDxE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 23:53:04 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2431A25580
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 20:53:03 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-34558a60c39so41258607b3.16
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 20:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date;
        bh=HHCJMOz1PMG82DQmjUuOPo5k0H/Opjm/8PtzbIkPyNo=;
        b=SN1sMLBxlit2X7oFwY/sWO1LFKwUpplAezDsBIxaraCcU6jYzpP2/vkmHYHXHDlP0Q
         u7nq/HQUyFgmKfdGJdxn5nPk8sRzVVss7iybg2+VCD00b9zwdXZjt90zwyeFHKvMYhFZ
         uOr0kyZAQoW056MNg5y19el28LHLf1faWAsXNs2mss8i6B288E3u8lr+wIUiK7aCviEM
         LfW3uQ2AO1blNKP3/ob1IZ3N+Qd9XFfxEBCatSRpOjnBhAWgkRBuMJAJiNnBlWewL8Kr
         xEB+eIyN/U04VxGAO1tRSUOeb3K9kv71h3UPvx3r/x4o1TO3b9np3/QToA2S4MMqwVny
         eYbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=HHCJMOz1PMG82DQmjUuOPo5k0H/Opjm/8PtzbIkPyNo=;
        b=l60TOVJiJfWARQMSeoFoVw+YxaOwob2jBlBSH3diH5lrTHbS5zm+AvRWk1zXfwGwOq
         kv1G3m/IOn5NZIRldPBrYo7O5CUNzbsm/6+HDq7ZCXRYa1ARu4meSVFI3NTkT62/BkFy
         w4ZlujXeBapNgiUdSX28TOTUJ1L6ZznWlPyNu9sIlnIz1TUy42zHunJo3MvDa+eEl0nI
         EPTzucycxJxcHypZQwkzP18Ujs0G2BV+wQVOw6foQKN3KJuhHEqzrMIFJ0bqykekq3Bs
         A+0PfoseFFlmKcGHU4GjKTRkHbf44Bs674/xVZA+0HkMU3eAzi+FkAU3HzQDtFcYTpbq
         5q8Q==
X-Gm-Message-State: ACrzQf3wAzst4uALHiyCiltigp47hHVYT+2Gm4U6v/atCq7C9+yQlXIT
        qRNTMV+ALlgpB87uvl7SBEVCZMQ=
X-Google-Smtp-Source: AMsMyM5cHIxx3BGamuUDyHW0NPVNke58O5XSz5v6UmrGOsmBcjAu7uIaew2O8hgxFF92rZiXUGymBjI=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:1b89:96f1:d30:e3c])
 (user=pcc job=sendgmr) by 2002:a25:8b10:0:b0:6b0:58a:f8f5 with SMTP id
 i16-20020a258b10000000b006b0058af8f5mr20788531ybl.524.1663732382089; Tue, 20
 Sep 2022 20:53:02 -0700 (PDT)
Date:   Tue, 20 Sep 2022 20:51:36 -0700
In-Reply-To: <20220921035140.57513-1-pcc@google.com>
Message-Id: <20220921035140.57513-5-pcc@google.com>
Mime-Version: 1.0
References: <20220921035140.57513-1-pcc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Subject: [PATCH v4 4/8] mm: Add PG_arch_3 page flag
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
 fs/proc/page.c                    | 1 +
 include/linux/kernel-page-flags.h | 1 +
 include/linux/page-flags.h        | 1 +
 include/trace/events/mmflags.h    | 1 +
 mm/huge_memory.c                  | 1 +
 5 files changed, 5 insertions(+)

diff --git a/fs/proc/page.c b/fs/proc/page.c
index 6f4b4bcb9b0d..43d371e6b366 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -220,6 +220,7 @@ u64 stable_page_flags(struct page *page)
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
index 24974a4ce28f..c7c5f9fb226d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2446,6 +2446,7 @@ static void __split_huge_page_tail(struct page *head, int tail,
 			 (1L << PG_unevictable) |
 #ifdef CONFIG_ARCH_USES_PG_ARCH_X
 			 (1L << PG_arch_2) |
+			 (1L << PG_arch_3) |
 #endif
 			 (1L << PG_dirty) |
 			 LRU_GEN_MASK | LRU_REFS_MASK));
-- 
2.37.3.968.ga6b4b080e4-goog

