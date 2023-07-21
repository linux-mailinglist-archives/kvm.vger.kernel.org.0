Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5346375D78C
	for <lists+kvm@lfdr.de>; Sat, 22 Jul 2023 00:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbjGUWd6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 18:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjGUWd4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 18:33:56 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 954293583
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 15:33:55 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-56942442eb0so25670127b3.1
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 15:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689978835; x=1690583635;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=USyIrgY7glI2I6Y1FEnoLFsj21yaEAeGNlnCwa16vxU=;
        b=ck1pTWUbkvhYUxYB5e3viKVyP78tg8VHF5sR2juNPhLSnFq0EFHX1xxLtMdZ+DlJHv
         53/ZCwbpK6IoS+/Gxs3zFHg/n/JJ+ZBUR/hLZDr7H+g4ZbMdK2oYX44p9KWLXISfiszC
         D2Ctel3HzQBxkhJy0RmGB4dvaF40UH2HQq3B6wEV3oddZVylMso+Y87Zf4PFRd891SKy
         3KNFLw1jukABNrr0YMUU09sAsKYBtlDBZKlWrVXDI9KK6tbdrmTpH0vQPklpryYRKLLY
         2i6keBlqyy/wOYi6IYGOQ65X03CutWtBYcMPgafqDrRpI3xA7Jni8BLbJDCOC5Tn/DGj
         B05w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689978835; x=1690583635;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=USyIrgY7glI2I6Y1FEnoLFsj21yaEAeGNlnCwa16vxU=;
        b=NPktj62lsmn0A7UnFuvFfNzJ01jnS60lwN7NIHjV/4WXbrJBZMkLI15lKYb5+WZYWo
         EpzzPFtnq9EnqLVd8XS+DJzQvt2X7Af4CiEN1a5qls5NInblyKYofQNWTYykE44ABNwx
         W9MrwIdEAA0u8d1IrrjwTyB70qUjvBLZb6LLJVMl/TuE1zDVwxH/aNTRH1KFrrArpAho
         m1k0H2Z5uK3Kw+cbwsxlbeLwXMAWGwHSN8YLv7EfM30u5rmTRy02Pck9x1fEg6r51t/A
         3tgTHmcWmRH6NyI+O68oK3ZDJpWjMt6W4H1j/lYqUBBsCbeb//TYafvojTGVH6nvi5aB
         hGDA==
X-Gm-Message-State: ABy/qLZAK4rdbtdlTw4nOH4K0qveVaCzOmDc/5/ZgRB+gI+Qxh7n+rOh
        cJ3R35aBIQZZsv85h0k2Jj8VSqAmRzw=
X-Google-Smtp-Source: APBJJlH3r7Bida35VU4uL5e0ibtdttucr6EEWOFLP+th9pzb1aucpDZ9X30Dx96SzQEYp4ro5KvPm1YaqH8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:24a:b0:cea:fb07:7629 with SMTP id
 k10-20020a056902024a00b00ceafb077629mr22897ybs.10.1689978834851; Fri, 21 Jul
 2023 15:33:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 21 Jul 2023 15:33:52 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230721223352.2333911-1-seanjc@google.com>
Subject: [PATCH] selftests/rseq: Play nice with binaries statically linked
 against glibc 2.35+
From:   Sean Christopherson <seanjc@google.com>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>
Cc:     linux-kernel@vger.kernel.org, Aaron Lewis <aaronlewis@google.com>,
        kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To allow running rseq and KVM's rseq selftests as statically linked
binaries, initialize the various "trampoline" pointers to point directly
at the expect glibc symbols, and skip the dlysm() lookups if the rseq
size is non-zero, i.e. the binary is statically linked *and* the libc
registered its own rseq.

Define weak versions of the symbols so as not to break linking against
libc versions that don't support rseq in any capacity.

The KVM selftests in particular are often statically linked so that they
can be run on targets with very limited runtime environments, i.e. test
machines.

Fixes: 233e667e1ae3 ("selftests/rseq: Uplift rseq selftests for compatibility with glibc-2.35")
Cc: Aaron Lewis <aaronlewis@google.com>
Cc: kvm@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

Note, this is very much the result of throwing noodles until something
stuck, it seems like there's gotta be a less awful way to handle this :-(

I Cc'd stable@ because I know I'm not the only person that runs statically
linked KVM selftests, and figuring all this out was quite painful.

 tools/testing/selftests/rseq/rseq.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/rseq/rseq.c b/tools/testing/selftests/rseq/rseq.c
index 4e4aa006004c..a723da253244 100644
--- a/tools/testing/selftests/rseq/rseq.c
+++ b/tools/testing/selftests/rseq/rseq.c
@@ -34,9 +34,17 @@
 #include "../kselftest.h"
 #include "rseq.h"
 
-static const ptrdiff_t *libc_rseq_offset_p;
-static const unsigned int *libc_rseq_size_p;
-static const unsigned int *libc_rseq_flags_p;
+/*
+ * Define weak versions to play nice with binaries that are statically linked
+ * against a libc that doesn't support registering its own rseq.
+ */
+__weak ptrdiff_t __rseq_offset;
+__weak unsigned int __rseq_size;
+__weak unsigned int __rseq_flags;
+
+static const ptrdiff_t *libc_rseq_offset_p = &__rseq_offset;
+static const unsigned int *libc_rseq_size_p = &__rseq_size;
+static const unsigned int *libc_rseq_flags_p = &__rseq_flags;
 
 /* Offset from the thread pointer to the rseq area. */
 ptrdiff_t rseq_offset;
@@ -155,9 +163,17 @@ unsigned int get_rseq_feature_size(void)
 static __attribute__((constructor))
 void rseq_init(void)
 {
-	libc_rseq_offset_p = dlsym(RTLD_NEXT, "__rseq_offset");
-	libc_rseq_size_p = dlsym(RTLD_NEXT, "__rseq_size");
-	libc_rseq_flags_p = dlsym(RTLD_NEXT, "__rseq_flags");
+	/*
+	 * If the libc's registered rseq size isn't already valid, it may be
+	 * because the binary is dynamically linked and not necessarily due to
+	 * libc not having registered a restartable sequence.  Try to find the
+	 * symbols if that's the case.
+	 */
+	if (!*libc_rseq_size_p) {
+		libc_rseq_offset_p = dlsym(RTLD_NEXT, "__rseq_offset");
+		libc_rseq_size_p = dlsym(RTLD_NEXT, "__rseq_size");
+		libc_rseq_flags_p = dlsym(RTLD_NEXT, "__rseq_flags");
+	}
 	if (libc_rseq_size_p && libc_rseq_offset_p && libc_rseq_flags_p &&
 			*libc_rseq_size_p != 0) {
 		/* rseq registration owned by glibc */

base-commit: 88bb466c9dec4f70d682cf38c685324e7b1b3d60
-- 
2.41.0.487.g6d72f3e995-goog

