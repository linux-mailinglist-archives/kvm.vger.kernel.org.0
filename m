Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE3487A4A55
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 14:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241625AbjIRM7H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 08:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241998AbjIRM6i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 08:58:38 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59230CCD
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 05:58:06 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id 98e67ed59e1d1-274b9b3e0e1so860990a91.1
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 05:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1695041886; x=1695646686; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PLRXOOGttm4jqNzNqsuvXJMSfkiuChzPWjXb8EuGGXQ=;
        b=nnANjch5uL1aOKDWkoWHk+GPxhwDLIaICQOHLlSvma7e/ok9n2PF0CcjwfJaD29LY4
         zVqnzlw7TMf0yY3r2G2ITYQCeA4AP/j0Jmw8QzOHN9QvkzcF9qx77GGFSzbeFL2aEwXi
         fSwcP/AThW/wCRPsBsuqznhpknwF3O6D310nXdUbFwh6P5soCZ8h9s7Kd8wcgfBHeJcE
         mGRj3EdxTk2qi3CxmB6Q73n+xqTEp19UsRXkgUR+n5K+SuhuY4blKgDEHX7hBfyxN2nb
         V9p+y2uPv4POFZUUhg1yNY1QfTl4u+C+C9a+2gwqw0tSLiwJhwszkCnlANZ+fBmpKKoM
         57kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695041886; x=1695646686;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PLRXOOGttm4jqNzNqsuvXJMSfkiuChzPWjXb8EuGGXQ=;
        b=rBl5G2AwtaikcoN1R1TLsg/untxu9Bl/fKvnr775ZMJbQlYF5Ew2ANhvtvR1paR+7n
         rxubUu3EjQ9FjsfbKEB5QdaUohplPc/wd+HQaonXSnErMvDKWFWfiqAQ4vHHXQ67XX72
         tjbXLO64Vp7ciVjuwi/2EGw6mlvmoM6lMtXGAV2kpFV1ezH+6DzFyi64FMl9TwZh0zeP
         XHCumAJ1hxiKVMOKbVd0Q8n+hHvYVPE45GkonsnP0G2uKcbQm8DNK2G+SvOEcIi+X2WB
         FuS/jLLCyVBSpQkkIMC8LdeofHz+4M9q3mil10Vws5j6zcOVgmikBRVoLcUZN7XesJIM
         Nlow==
X-Gm-Message-State: AOJu0YycLP/shoGE2PtmFrgLbqqKSR7pHJPVJJLVj5nvgWMCLzI5aInp
        CT2XEYDCIbfSRAr7CBQoEsNo5A==
X-Google-Smtp-Source: AGHT+IHU6W0EcWCxNgtbPfwjseqUBdugbBbjyp7R9B9CgwysyPMR4XXDRqQm9vzAgMYvJnGEVsVKeQ==
X-Received: by 2002:a17:90a:128c:b0:263:3386:9da8 with SMTP id g12-20020a17090a128c00b0026333869da8mr5381160pja.49.1695041885592;
        Mon, 18 Sep 2023 05:58:05 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id n14-20020a17090ac68e00b002680b2d2ab6sm8890237pjt.19.2023.09.18.05.58.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 05:58:05 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH v2 6/6] riscv: Fix guest/init linkage for multilib toolchain
Date:   Mon, 18 Sep 2023 18:27:30 +0530
Message-Id: <20230918125730.1371985-7-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230918125730.1371985-1-apatel@ventanamicro.com>
References: <20230918125730.1371985-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For RISC-V multilib toolchains, we must specify -mabi and -march
options when linking guest/init.

Fixes: 2e99678314c2 ("riscv: Initial skeletal support")
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Makefile b/Makefile
index acd5ffd..d84dc8e 100644
--- a/Makefile
+++ b/Makefile
@@ -223,9 +223,11 @@ ifeq ($(ARCH),riscv)
 	OBJS		+= riscv/aia.o
 	ifeq ($(RISCV_XLEN),32)
 		CFLAGS	+= -mabi=ilp32d -march=rv32gc
+		GUEST_INIT_FLAGS += -mabi=ilp32d -march=rv32gc
 	endif
 	ifeq ($(RISCV_XLEN),64)
 		CFLAGS	+= -mabi=lp64d -march=rv64gc
+		GUEST_INIT_FLAGS += -mabi=lp64d -march=rv64gc
 	endif
 
 	ARCH_WANT_LIBFDT := y
-- 
2.34.1

