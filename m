Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39DB87D51DF
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 15:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234487AbjJXNey (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 09:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234551AbjJXNet (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 09:34:49 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D7A6A79
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 06:27:55 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-408ffb55b35so1895205e9.1
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 06:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1698154074; x=1698758874; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JzJW8mbLnPSn6J2V5LPD0tHMd0DjHcRVmnBobw7QLdA=;
        b=kfUuov924bX+nrLrP99Now6Jt4E8SxBVArsWKIkP6wV3PXv/CRCQ/1O5fQAgn0MR45
         t+N1OfyxRV0RO+UYlbZGWvvaD1OMQv50iZ2FiLsoldp7chcXFrNc7ck/fwEyRE9vBIjI
         dyJqxo0TbTdcFvpR95FdjTdgLKaGVj3ESQD+U/MTM1NqPzSKstlqr6lk42wpZbPuGzK6
         CElg8PIP0DBL5kdiK6XJgMPnv5z5ECBeyeIu9u+A0uoQjkqk63HcIMSY3DeH8J0vcA3Q
         2qmPyB/Ue7hDuh4Z4yFpOBHUKotr65sLHUTkE1AwxFdMSLX7pt1Ja/L+51Jxq6sjZwRq
         FEtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698154074; x=1698758874;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JzJW8mbLnPSn6J2V5LPD0tHMd0DjHcRVmnBobw7QLdA=;
        b=RS8VWCpz1klRPtoobxqHVn6SSE2kCEV8m+1u4cceDNOumfKSlrK4QtEI2zMBYdCgLk
         lWj2W6UQJuCwZUUCQt5/Xmc0ymMZqjuyKwQUzVMYomYu+zOOIGnI8/nGGbGea5dJf84u
         UVZZJ79JYX5a+Y7uEz8L9+P39qF14Mns70YbUJK7hhaCdIEWeMYE8KS++bLVEENHCySY
         WZaGs+qLNqf+2jV0PCd8eb4yk7Y5duZQT9kLe3tFaufVjdbgtFkp2A25JGSJdwrVXSjn
         BNvZCJgXRDO8pShvg7s37fEPtuxh+OL/u5w5QmVIdXjry0wzhKY3WvuR+8olxG3jXkQh
         0q+Q==
X-Gm-Message-State: AOJu0YyYf5pNkWMHo8B227BP8Z+7ZF9inPs6n7zIL4BLjeNzfkGF9wG/
        sUf1QVteJj+2ZaOkDeEzceZMTA==
X-Google-Smtp-Source: AGHT+IERNbVtk7/d9BXKHcuFefqmMm7PIZc2yEvA/OiXxfNb0j+FczZRM6x6rXgzSE6bj8c3/9Em7g==
X-Received: by 2002:adf:a455:0:b0:32d:d8ed:d6e0 with SMTP id e21-20020adfa455000000b0032dd8edd6e0mr7575871wra.0.1698154074488;
        Tue, 24 Oct 2023 06:27:54 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:597d:e2c5:6741:bac9])
        by smtp.gmail.com with ESMTPSA id c17-20020a5d4151000000b0032d87b13240sm10034964wrq.73.2023.10.24.06.27.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Oct 2023 06:27:53 -0700 (PDT)
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: [PATCH v2 3/5] riscv: kernel: Use correct SYM_DATA_*() macro for data
Date:   Tue, 24 Oct 2023 15:26:53 +0200
Message-ID: <20231024132655.730417-4-cleger@rivosinc.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231024132655.730417-1-cleger@rivosinc.com>
References: <20231024132655.730417-1-cleger@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some data were incorrectly annotated with SYM_FUNC_*() instead of
SYM_DATA_*() ones. Use the correct ones.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/kernel/entry.S | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
index 64ac0dd6176b..a7aa2fd599d6 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -324,7 +324,7 @@ SYM_FUNC_END(__switch_to)
 	.section ".rodata"
 	.align LGREG
 	/* Exception vector table */
-SYM_CODE_START(excp_vect_table)
+SYM_DATA_START_LOCAL(excp_vect_table)
 	RISCV_PTR do_trap_insn_misaligned
 	ALT_INSN_FAULT(RISCV_PTR do_trap_insn_fault)
 	RISCV_PTR do_trap_insn_illegal
@@ -342,12 +342,11 @@ SYM_CODE_START(excp_vect_table)
 	RISCV_PTR do_page_fault   /* load page fault */
 	RISCV_PTR do_trap_unknown
 	RISCV_PTR do_page_fault   /* store page fault */
-excp_vect_table_end:
-SYM_CODE_END(excp_vect_table)
+SYM_DATA_END_LABEL(excp_vect_table, SYM_L_LOCAL, excp_vect_table_end)
 
 #ifndef CONFIG_MMU
-SYM_CODE_START(__user_rt_sigreturn)
+SYM_DATA_START(__user_rt_sigreturn)
 	li a7, __NR_rt_sigreturn
 	ecall
-SYM_CODE_END(__user_rt_sigreturn)
+SYM_DATA_END(__user_rt_sigreturn)
 #endif
-- 
2.42.0

