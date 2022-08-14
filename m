Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B72E259200C
	for <lists+kvm@lfdr.de>; Sun, 14 Aug 2022 16:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239668AbiHNONF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Aug 2022 10:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbiHNOM5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 14 Aug 2022 10:12:57 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B47B29FD3
        for <kvm@vger.kernel.org>; Sun, 14 Aug 2022 07:12:55 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id p10so6348674wru.8
        for <kvm@vger.kernel.org>; Sun, 14 Aug 2022 07:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=conchuod.ie; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=pPv0l6vD5WlLpI1nTN7zzV3sMR7lS/dRIy37KSKLV6k=;
        b=HMMTLU/p8YLEHSGr0JdrSHHzL+KPSzr/2SbHVIYZPefUDLh0i6BEpVFmoM7PonqAQu
         XHK1xmVw1UBg2BPE8d6h3iPvrE+h3Ms+3mRmDMA9Wb50IKTeWvZ0qIOlXZ1ZkoUbFGHE
         0mUhMOI5/9Bp3r2iu5qSOoF2uZw6OohSrtuVWL1610+z/NlAO6QENPP2PWA5I1CD3+Ng
         euh7jve2sSLkFojItamUEEE3h9vElikeXBeEWacM1nyspNJDM6MQj9pdpf6uA3YdvvbX
         JHdWK+memg4nFTSgdmc6BoFrjCm7SFf/6eVZhXMvj+kHJE/DRuNDbHBIhxDKgeNhP0WF
         Scrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=pPv0l6vD5WlLpI1nTN7zzV3sMR7lS/dRIy37KSKLV6k=;
        b=mMhomIaO1IZ3G7jO8veMLM3YxKZbB68vlKAtoAPWKLCifsuGe2uv6BMt1ASI2lY4Y7
         x8bezScxeDeMavwAtizSHZwFkYGBKrh7ustbLJQSX6l0m0y7U5B4XWUA1w15UZn6YggJ
         NIlJ8ITUHdCHjldL6GUKUGifJ81s5q6ksgyvgFo4vnIRxPUVQgxS7SaOdqrMyqX2gQZh
         aE9pAyEx1aCbwjILvbOw5/XOjJgbOBKb6PA/QiIaHdROUEXBLRGZbhVWOeLfoUJ9GRXf
         Fj6a/GqoU6Y9uGkvjAi6XGohmyJNW/dyOzYWNSQVERRpLiWAbTOy1el4wlYPhodCHH2V
         bkxA==
X-Gm-Message-State: ACgBeo0BCJOhSuHMkDoyxbdSRoxYx723jx8Vw8/39Z//dQltZAXOJjd+
        dW5k4562TedYpFC6H9goWMIF2Q==
X-Google-Smtp-Source: AA6agR6BPhLCEYbGHWwFtW7IA0BVcNy4nXrlbW7af92IxkgTrJMJnNk9uz1mkz0iwWDTuJ1TmfrDbA==
X-Received: by 2002:a5d:4705:0:b0:21f:3890:8619 with SMTP id y5-20020a5d4705000000b0021f38908619mr6285685wrq.104.1660486374334;
        Sun, 14 Aug 2022 07:12:54 -0700 (PDT)
Received: from henark71.. ([109.76.58.63])
        by smtp.gmail.com with ESMTPSA id b8-20020adfde08000000b0021db7b0162esm4625419wrm.105.2022.08.14.07.12.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Aug 2022 07:12:53 -0700 (PDT)
From:   Conor Dooley <mail@conchuod.ie>
To:     Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Cc:     Conor Dooley <conor.dooley@microchip.com>,
        Guo Ren <guoren@kernel.org>,
        Vincent Chen <vincent.chen@sifive.com>,
        Xianting Tian <xianting.tian@linux.alibaba.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Tong Tiangen <tongtiangen@huawei.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] riscv: signal: fix missing prototype warning
Date:   Sun, 14 Aug 2022 15:12:37 +0100
Message-Id: <20220814141237.493457-4-mail@conchuod.ie>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220814141237.493457-1-mail@conchuod.ie>
References: <20220814141237.493457-1-mail@conchuod.ie>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Conor Dooley <conor.dooley@microchip.com>

Fix the warning:
arch/riscv/kernel/signal.c:316:27: warning: no previous prototype for function 'do_notify_resume' [-Wmissing-prototypes]
asmlinkage __visible void do_notify_resume(struct pt_regs *regs,

All other functions in the file are static & none of the existing
headers stood out as an obvious location. Create signal.h to hold the
declaration.

Fixes: e2c0cdfba7f6 ("RISC-V: User-facing API")
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
---
 arch/riscv/include/asm/signal.h | 12 ++++++++++++
 arch/riscv/kernel/signal.c      |  1 +
 2 files changed, 13 insertions(+)
 create mode 100644 arch/riscv/include/asm/signal.h

diff --git a/arch/riscv/include/asm/signal.h b/arch/riscv/include/asm/signal.h
new file mode 100644
index 000000000000..532c29ef0376
--- /dev/null
+++ b/arch/riscv/include/asm/signal.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef __ASM_SIGNAL_H
+#define __ASM_SIGNAL_H
+
+#include <uapi/asm/signal.h>
+#include <uapi/asm/ptrace.h>
+
+asmlinkage __visible
+void do_notify_resume(struct pt_regs *regs, unsigned long thread_info_flags);
+
+#endif
diff --git a/arch/riscv/kernel/signal.c b/arch/riscv/kernel/signal.c
index 38b05ca6fe66..5a2de6b6f882 100644
--- a/arch/riscv/kernel/signal.c
+++ b/arch/riscv/kernel/signal.c
@@ -15,6 +15,7 @@
 
 #include <asm/ucontext.h>
 #include <asm/vdso.h>
+#include <asm/signal.h>
 #include <asm/signal32.h>
 #include <asm/switch_to.h>
 #include <asm/csr.h>
-- 
2.37.1

