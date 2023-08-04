Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54BBC76F798
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 04:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233657AbjHDCMO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 22:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232818AbjHDCLi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 22:11:38 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B504E49CB
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 19:11:10 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1bbc06f830aso11574195ad.0
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 19:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1691115058; x=1691719858;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k6HgGLGtG7M3LESpN5nTWoHfsSRrv8ioEMKugiOnOTw=;
        b=tu7avlotyozMV/l8NRFA0DJ9nnNC6Iq43LymSGWeqaIFo+4SOLemWteCRxuxVqX1vN
         v5bb3l0plvTmmo2yGXB6uIC1F/QI4lTwiO69NqjpKxuMRfL+xYAnS4u+tegfJm0NuEKP
         0kChJuxf5ozsMipWf8xNnVMnHYeK7CIXvxUiE3DuPC17GkDDWyzdDHCq7v8KNNMZN3aR
         E+nUQYwRE0MLaL/LwTWHQGSQHIoxQ1RLPR4iRDtmnbokti7RepO5Ri/GxUt3bdFA6/dP
         pyxnjsEJpHF1MQS3xf8YsV6SjjvC5Eyd4tgBsMQxdwZBNR6xOFws8g38Zn3skjbBCBfO
         Im3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691115059; x=1691719859;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k6HgGLGtG7M3LESpN5nTWoHfsSRrv8ioEMKugiOnOTw=;
        b=HnnBKkp7naesXWDaHhoTcS6CU/3IRj4EnJMlLu6O22bUvW1HGI1hFfV0fhT0FsCj/l
         TVmKWQza0JizomjDyD/7+CvMepbFGtas2KkMSeMOolNRc6OPauVYpD6GB/i5sdhw2A7E
         eBtxWvE88klhNKpFn6O3SmikdDWof0aPaNQwwygenA+nET8i2+LdgGNcMNL0NxbihQuU
         5Nn2uVBdy5pAQQxd+lR3zs4nV+VVjyUS2eYXC3GTgkCkb1xepFZ9OgSrn4t5RtBKxF+Z
         5C1UouYh3f3QvnQYLSNtV1xmsKCZxGdtX5YSXIG4YgYScT4FhcRqMMhdpMWhJrZzWAdH
         rKSQ==
X-Gm-Message-State: AOJu0YxRvzcJYK8Z/bkHuW3fJkkqWNlkbWrvl0ypQuNEa34UubKYl1lq
        5myNTbawxiDk0rJL2VCPYibr7g==
X-Google-Smtp-Source: AGHT+IEN0Jt5wwNuskL0qGGhhGkOeUg3t8WkQm4o7XfOAfqqqzUJqOVX9dt6wxX88cfzTtEYQSuJcg==
X-Received: by 2002:a17:902:ab48:b0:1bc:e37:aa76 with SMTP id ij8-20020a170902ab4800b001bc0e37aa76mr516147plb.6.1691115058660;
        Thu, 03 Aug 2023 19:10:58 -0700 (PDT)
Received: from charlie.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id g6-20020a655806000000b0055c558ac4edsm369499pgr.46.2023.08.03.19.10.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 19:10:58 -0700 (PDT)
From:   Charlie Jenkins <charlie@rivosinc.com>
Date:   Thu, 03 Aug 2023 19:10:29 -0700
Subject: [PATCH 04/10] RISC-V: KGDB: Refactor instructions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230803-master-refactor-instructions-v4-v1-4-2128e61fa4ff@rivosinc.com>
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

Use shared instruction definitions in insn.h.

Signed-off-by: Charlie Jenkins <charlie@rivosinc.com>
---
 arch/riscv/kernel/kgdb.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/riscv/kernel/kgdb.c b/arch/riscv/kernel/kgdb.c
index 2393342ab362..e1305706120e 100644
--- a/arch/riscv/kernel/kgdb.c
+++ b/arch/riscv/kernel/kgdb.c
@@ -5,7 +5,6 @@
 
 #include <linux/ptrace.h>
 #include <linux/kdebug.h>
-#include <linux/bug.h>
 #include <linux/kgdb.h>
 #include <linux/irqflags.h>
 #include <linux/string.h>
@@ -25,12 +24,12 @@ static unsigned int stepped_opcode;
 
 static int decode_register_index(unsigned long opcode, int offset)
 {
-	return (opcode >> offset) & 0x1F;
+	return (opcode >> offset) & RV_STANDARD_REG_MASK;
 }
 
 static int decode_register_index_short(unsigned long opcode, int offset)
 {
-	return ((opcode >> offset) & 0x7) + 8;
+	return ((opcode >> offset) & RV_COMPRESSED_REG_MASK) + 8;
 }
 
 /* Calculate the new address for after a step */
@@ -43,7 +42,7 @@ static int get_step_address(struct pt_regs *regs, unsigned long *next_addr)
 
 	if (get_kernel_nofault(op_code, (void *)pc))
 		return -EINVAL;
-	if ((op_code & __INSN_LENGTH_MASK) != INSN_C_MASK) {
+	if (INSN_IS_C(op_code)) {
 		if (riscv_insn_is_c_jalr(op_code) ||
 		    riscv_insn_is_c_jr(op_code)) {
 			rs1_num = decode_register_index(op_code, RVC_C2_RS1_OPOFF);
@@ -55,14 +54,14 @@ static int get_step_address(struct pt_regs *regs, unsigned long *next_addr)
 			rs1_num = decode_register_index_short(op_code,
 							      RVC_C1_RS1_OPOFF);
 			if (!rs1_num || regs_ptr[rs1_num] == 0)
-				*next_addr = RVC_EXTRACT_BTYPE_IMM(op_code) + pc;
+				*next_addr = RVC_EXTRACT_BZ_IMM(op_code) + pc;
 			else
 				*next_addr = pc + 2;
 		} else if (riscv_insn_is_c_bnez(op_code)) {
 			rs1_num =
 			    decode_register_index_short(op_code, RVC_C1_RS1_OPOFF);
 			if (rs1_num && regs_ptr[rs1_num] != 0)
-				*next_addr = RVC_EXTRACT_BTYPE_IMM(op_code) + pc;
+				*next_addr = RVC_EXTRACT_BZ_IMM(op_code) + pc;
 			else
 				*next_addr = pc + 2;
 		} else {

-- 
2.34.1

