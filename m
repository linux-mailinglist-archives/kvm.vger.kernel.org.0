Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A36B76F7AA
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 04:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232543AbjHDCNM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 22:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233700AbjHDCMQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 22:12:16 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1644C32
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 19:11:37 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-686f38692b3so1487905b3a.2
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 19:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1691115071; x=1691719871;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ih06HArn9iAryRcOKi/nyaTeAf4B1pYQ5n3lzBGwExw=;
        b=ew4rB+H6wBVVmeh/ui4LIzo+yvnm98oRAW4V9bmZm0KpT/glMjqRgPghU5Pe7h4Esc
         ULiTigZbpum8dCcqLDUYCXDomBKmpj2JOHEklft07nNCBx1z82UYhCKCpuxj1PHAOzaE
         NMax1U3YW9v1aHa4//bwc1cTcDl4jdIR8DOmMX78OtylMdsneAv0M+DVuZ/oUvlzDjuy
         /Eo3HBz3BDHFXmGEXCMfBNAi9hv3UebxWREasDtlfQDxVygFxm5W9omrOT80TWEdv1+I
         6Q3E3HhXfnIfxGtKYjYgSXjJeDKzMUjL0JxLCdBqUgV5jfcWHjIg0Oq1bhb98rkkscuS
         E9Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691115071; x=1691719871;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ih06HArn9iAryRcOKi/nyaTeAf4B1pYQ5n3lzBGwExw=;
        b=KeZGZMH/WuRFE3z0pGL4vsxh5yYwKisV6cIMOKTIpX5+LFe2BC22JO96sQaeTjr3Ne
         qw+0bj8aUSTaokSYheJq3x5t1wdGsrOevXqg1m35XLApzOYGixXd2mAFlv8qrcAgKUPU
         SULtviSmlJZolCujuM3RGjCEOk7ezvNQODkYIAdEO+3FOPVm+lC2WFh2eIuJN2gNt1Pd
         A3YVIUsgqqCGkSPKrKTS5bjfqsfQnCNPrxYWDmuVtWPb9I0Y0l8dotMuo5Uc4qSBVqpl
         ahgj9klroDkK8IFhgaCSP27pBhX90hf/q38QmmjHuTUVM+pEoNYjfs+04ENKWWzkBWs2
         Htnw==
X-Gm-Message-State: AOJu0YwSkg5tf633y4QDRL9v8RjLRjFC1ZZt+/4N9sYO8UIGRAna5YQX
        wWEnf22GAbXpgkaPXqzq0thCmw==
X-Google-Smtp-Source: AGHT+IHuwaCo50Vehua+AGfdkcRKSRRWmSFHlzqzBP1tYtF/TOsW9qAWFW9rXyDnlZAMKZPqtqPdwQ==
X-Received: by 2002:a05:6a00:189d:b0:687:2be1:e2f6 with SMTP id x29-20020a056a00189d00b006872be1e2f6mr555577pfh.16.1691115071421;
        Thu, 03 Aug 2023 19:11:11 -0700 (PDT)
Received: from charlie.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id g6-20020a655806000000b0055c558ac4edsm369499pgr.46.2023.08.03.19.11.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 19:11:10 -0700 (PDT)
From:   Charlie Jenkins <charlie@rivosinc.com>
Date:   Thu, 03 Aug 2023 19:10:35 -0700
Subject: [PATCH 10/10] RISC-V: Refactor bug and traps instructions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230803-master-refactor-instructions-v4-v1-10-2128e61fa4ff@rivosinc.com>
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
 arch/riscv/include/asm/bug.h | 18 +++++-------------
 arch/riscv/kernel/traps.c    |  9 +++++----
 2 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/arch/riscv/include/asm/bug.h b/arch/riscv/include/asm/bug.h
index 1aaea81fb141..6d9002d93f85 100644
--- a/arch/riscv/include/asm/bug.h
+++ b/arch/riscv/include/asm/bug.h
@@ -11,21 +11,13 @@
 #include <linux/types.h>
 
 #include <asm/asm.h>
+#include <asm/insn.h>
 
-#define __INSN_LENGTH_MASK  _UL(0x3)
-#define __INSN_LENGTH_32    _UL(0x3)
-#define __COMPRESSED_INSN_MASK	_UL(0xffff)
+#define __IS_BUG_INSN_32(insn) riscv_insn_is_c_ebreak(insn)
+#define __IS_BUG_INSN_16(insn) riscv_insn_is_ebreak(insn)
 
-#define __BUG_INSN_32	_UL(0x00100073) /* ebreak */
-#define __BUG_INSN_16	_UL(0x9002) /* c.ebreak */
-
-#define GET_INSN_LENGTH(insn)						\
-({									\
-	unsigned long __len;						\
-	__len = ((insn & __INSN_LENGTH_MASK) == __INSN_LENGTH_32) ?	\
-		4UL : 2UL;						\
-	__len;								\
-})
+#define __BUG_INSN_32	RVG_MATCH_EBREAK
+#define __BUG_INSN_16	RVC_MATCH_C_EBREAK
 
 typedef u32 bug_insn_t;
 
diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
index f910dfccbf5d..970b118d36b5 100644
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -22,6 +22,7 @@
 #include <asm/asm-prototypes.h>
 #include <asm/bug.h>
 #include <asm/csr.h>
+#include <asm/insn.h>
 #include <asm/processor.h>
 #include <asm/ptrace.h>
 #include <asm/syscall.h>
@@ -243,7 +244,7 @@ static inline unsigned long get_break_insn_length(unsigned long pc)
 	if (get_kernel_nofault(insn, (bug_insn_t *)pc))
 		return 0;
 
-	return GET_INSN_LENGTH(insn);
+	return INSN_LEN(insn);
 }
 
 void handle_break(struct pt_regs *regs)
@@ -389,10 +390,10 @@ int is_valid_bugaddr(unsigned long pc)
 		return 0;
 	if (get_kernel_nofault(insn, (bug_insn_t *)pc))
 		return 0;
-	if ((insn & __INSN_LENGTH_MASK) == __INSN_LENGTH_32)
-		return (insn == __BUG_INSN_32);
+	if (INSN_IS_C(insn))
+		return __IS_BUG_INSN_16(insn);
 	else
-		return ((insn & __COMPRESSED_INSN_MASK) == __BUG_INSN_16);
+		return __IS_BUG_INSN_32(insn);
 }
 #endif /* CONFIG_GENERIC_BUG */
 

-- 
2.34.1

