Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFED476F794
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 04:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233328AbjHDCMA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 22:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233321AbjHDCLf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 22:11:35 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF92046A8
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 19:11:06 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id af79cd13be357-76ad8892d49so132768485a.1
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 19:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1691115056; x=1691719856;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+3U++cEq45L7iITV+zLwLaldo0Na07T+o+hHDfRRKC4=;
        b=ayC0Day7CXdP53wwIDs0tv4bKX6RYBEbt+WDQyLb8tpMqzB8hUHeS+pZ/fmXrx4qpA
         3JkEy7VvFQFPwmFiZrOcgMEo3fzpW+ldBC+JO6eugwsbDr7vJSjP1/35CxXsN0MB0Irt
         mkx9hB89+CUahHSi5pi8nO9KgVUWFgp8tr4jlCEdJmhvewPu4OWQqZ3baJYZwvTPdBfy
         +HdxqmvQtuuS7UKmZq8wZJhY55hKFLVGi3/KRn4eaZy7GtYIOEbVuJ5qIJOIr+oSnw4f
         I7cK7giGeGjDDUCgXif5SspsldvYp/giTIrzSG6SdHe7tpD9OaruV+cA9piG0QSIk91/
         G56g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691115056; x=1691719856;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+3U++cEq45L7iITV+zLwLaldo0Na07T+o+hHDfRRKC4=;
        b=Kf/2IX7YRAV7BNHa95vqras79MVN8xv/W7Cz1qWxJh5deiAznweYSGRreDsSFZVvk3
         ghPfRMUNGFLYulMFwHRrmXyZ69mpFaGmkUpJpwoB5Zx4Zuf87bg7ssfQ5vP24iNietfK
         vX78sG5Gi5yAlUVu2x64KmfLDVZn50XkOy4VhUXs+bSqBqPKZ7k/g2+eMJwzs8cAG5/s
         aTotBGjUW4pUedjIa4BKq/8SMUDiekGEgWaM41NyQ9qo6HhS+fL8VJRWtFmWtSwXKJj+
         RBJidREaOMLlkdVDgbemU0k5gZ8J2NvkQWjWA0u9ZWd2zX9Wpwqg3fz5kz1idRl3zHqN
         r14w==
X-Gm-Message-State: AOJu0YyScRwC2WiF0fhRNcxboZlMYahTQdOICC2pI63H6pzmAGkm/iqS
        GgvCGUqXnIe96tfx/NQwnCPkEA==
X-Google-Smtp-Source: AGHT+IG+6EaYMDmn7R52Jc4ascni7z5WQFwfR/PJzZqWfgRRzwdONmN63Q30hGcwUi7GhkBgKxKI9A==
X-Received: by 2002:a05:620a:1918:b0:76c:a187:13be with SMTP id bj24-20020a05620a191800b0076ca18713bemr687807qkb.33.1691115056542;
        Thu, 03 Aug 2023 19:10:56 -0700 (PDT)
Received: from charlie.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id g6-20020a655806000000b0055c558ac4edsm369499pgr.46.2023.08.03.19.10.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 19:10:56 -0700 (PDT)
From:   Charlie Jenkins <charlie@rivosinc.com>
Date:   Thu, 03 Aug 2023 19:10:28 -0700
Subject: [PATCH 03/10] RISC-V: Refactor jump label instructions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230803-master-refactor-instructions-v4-v1-3-2128e61fa4ff@rivosinc.com>
References: <20230803-master-refactor-instructions-v4-v1-0-2128e61fa4ff@rivosinc.com>
In-Reply-To: <20230803-master-refactor-instructions-v4-v1-0-2128e61fa4ff@rivosinc.com>
To:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        bpf@vger.kernel.org
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jason Baron <jbaron@akamai.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        =?utf-8?q?Bj=C3=B6rn_T=C3=B6pel?= <bjorn@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>, Nam Cao <namcaov@gmail.com>,
        Charlie Jenkins <charlie@rivosinc.com>
X-Mailer: b4 0.12.3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use shared instruction definitions in insn.h instead of manually
constructing them.

Signed-off-by: Charlie Jenkins <charlie@rivosinc.com>
---
 arch/riscv/include/asm/insn.h  |  2 +-
 arch/riscv/kernel/jump_label.c | 13 ++++---------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/riscv/include/asm/insn.h b/arch/riscv/include/asm/insn.h
index 04f7649e1add..124ab02973a7 100644
--- a/arch/riscv/include/asm/insn.h
+++ b/arch/riscv/include/asm/insn.h
@@ -1984,7 +1984,7 @@ static __always_inline bool riscv_insn_is_branch(u32 code)
 		<< RVC_J_IMM_10_OFF) | \
 	(RVC_IMM_SIGN(x_) << RVC_J_IMM_SIGN_OFF); })
 
-#define RVC_EXTRACT_BTYPE_IMM(x) \
+#define RVC_EXTRACT_BZ_IMM(x) \
 	({typeof(x) x_ = (x); \
 	(RVC_X(x_, RVC_BZ_IMM_2_1_OPOFF, RVC_BZ_IMM_2_1_MASK) \
 		<< RVC_BZ_IMM_2_1_OFF) | \
diff --git a/arch/riscv/kernel/jump_label.c b/arch/riscv/kernel/jump_label.c
index e6694759dbd0..fdaac2a13eac 100644
--- a/arch/riscv/kernel/jump_label.c
+++ b/arch/riscv/kernel/jump_label.c
@@ -9,11 +9,9 @@
 #include <linux/memory.h>
 #include <linux/mutex.h>
 #include <asm/bug.h>
+#include <asm/insn.h>
 #include <asm/patch.h>
 
-#define RISCV_INSN_NOP 0x00000013U
-#define RISCV_INSN_JAL 0x0000006fU
-
 void arch_jump_label_transform(struct jump_entry *entry,
 			       enum jump_label_type type)
 {
@@ -26,13 +24,10 @@ void arch_jump_label_transform(struct jump_entry *entry,
 		if (WARN_ON(offset & 1 || offset < -524288 || offset >= 524288))
 			return;
 
-		insn = RISCV_INSN_JAL |
-			(((u32)offset & GENMASK(19, 12)) << (12 - 12)) |
-			(((u32)offset & GENMASK(11, 11)) << (20 - 11)) |
-			(((u32)offset & GENMASK(10,  1)) << (21 -  1)) |
-			(((u32)offset & GENMASK(20, 20)) << (31 - 20));
+		insn = RVG_OPCODE_JAL;
+		riscv_insn_insert_jtype_imm(&insn, (s32)offset);
 	} else {
-		insn = RISCV_INSN_NOP;
+		insn = RVG_OPCODE_NOP;
 	}
 
 	mutex_lock(&text_mutex);

-- 
2.34.1

