Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 348EB761D52
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 17:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbjGYPZ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 11:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233321AbjGYPZP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 11:25:15 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99DA71BFB
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 08:25:09 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id 98e67ed59e1d1-26824c32cfbso1304138a91.1
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 08:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1690298708; x=1690903508;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PLRXOOGttm4jqNzNqsuvXJMSfkiuChzPWjXb8EuGGXQ=;
        b=j/uCAFtX5D8nsg6CTVL4hOXq1wBcxJeRaKPntypHcVWJhvoyAJPl9p833QU2sUeyRn
         yni8Ikuc9kGzvDxO/NBKiiYeSLvo1bosuZLkvIeExmGDcOs/PA9+tGnKJkjXnaYEFDka
         /I/dixnqCpVzNirIZFSzjsm2mQzvA74jPVxniW+0lGqV01s4/RMgB29MW9dENTy2kdKP
         AyT5NHkOSckZ/AXQNzYOlO7Fo/YNvQ4fTWRZ9u1KkzUUGAC3j4W5CnEGPle0+7Vc1MgS
         pvH8zKWMdzlkacKv571oxuIEKsQO7jxE8qc9WD1DjPFpcx105VYvor7gi3ssSMs0yFsj
         nUGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690298708; x=1690903508;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PLRXOOGttm4jqNzNqsuvXJMSfkiuChzPWjXb8EuGGXQ=;
        b=Z5xEY8SNeT5Ot+krn/zto0z0pFgBgfN7f4z3ugLkK6M0l6aQeZOFlbP8I6DY2G/Sb3
         rZx/F9SwIpiQHTu4KkGruWjxLu3xeQwKPaQXN8Zq0cBpLzCM39YcQKtDX4j8sDgnnHST
         h1rnYh8QavydxI0qrITRedk3p8DxWza0F2Ys7PCad+obg3XI64Xst2RSz83ltQdW9avY
         obLZyCx1PRxNV2QmR9JoY0QANPXGiyjgm1pySTfRpQ1oju48XybTdCKoyBCgQ6yeWBqU
         DQ0bEfcNLB7V/t/7Vj3xk7Ywk7nWOw3TsUULB0Na7zP7ZwAc8ojbz7h3u7TXWrncEl5/
         5syQ==
X-Gm-Message-State: ABy/qLaBL0+Z3582qrFy4pts0+M+9DBuemPYvXnufVVC8m0VEz7f2JNF
        KQMqC9iv3dx3N3lWel8XE2kesg==
X-Google-Smtp-Source: APBJJlHubUrdjKhlt6Knk3SUKA6AS1tTqxghFPr+YsigGYGH2vplu3zuEmHwfkFsG1KXPHh11qjcBw==
X-Received: by 2002:a17:90a:c395:b0:268:409:e795 with SMTP id h21-20020a17090ac39500b002680409e795mr3539549pjt.22.1690298708488;
        Tue, 25 Jul 2023 08:25:08 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id g11-20020a17090adb0b00b002683fd66663sm980372pjv.22.2023.07.25.08.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jul 2023 08:25:08 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH 6/6] riscv: Fix guest/init linkage for multilib toolchain
Date:   Tue, 25 Jul 2023 20:54:30 +0530
Message-Id: <20230725152430.3351564-7-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230725152430.3351564-1-apatel@ventanamicro.com>
References: <20230725152430.3351564-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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

