Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36AAC750EAF
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 18:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232571AbjGLQgD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 12:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232475AbjGLQgA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 12:36:00 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0FF11BFB
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:35:38 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1b9cd6a0051so27259925ad.1
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1689179738; x=1691771738;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UIYA8beJZmA2NMdlgIpBmajMkuQ+bKy8H3Ug9/MSXpA=;
        b=fAWnPhqPs8yqpYbPgaZDF2jVsu12P+2jnW9/nvlbBXLgzH6FCBM1eSccAclJnyMj0z
         QlI+BeGrOi2GUsiAKm/nSDHlV8znGUeaSxy9pnVIKkND/bCW0CNss6abigG08o5DAKBK
         t4RgX7q6rkSgXS9X/MidED+Jk1U6DtTBDMzuIk0nfEzYsU8M2ivi2Y1zbQlM4zYpk8vT
         skrBhiUR9EqQwTaUxgLzjHAQlV34F5XXGhBv7vMduVxX5oY6JIZYN+IZimunTkdEfUBG
         hGFTrZdpteqHN7n5o6iYi/UQ4nIIa0YY6yKqxmZjBAxvtG+WDVqIwcAiCR3iVC8EncCW
         AB5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689179738; x=1691771738;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UIYA8beJZmA2NMdlgIpBmajMkuQ+bKy8H3Ug9/MSXpA=;
        b=iffTIqTVzJ1OYtARTDcfo1MuneEC0zI2qF0RsnZPLgETrM2ieBjQR27Ox316n9LJ5v
         20Im12mw+7ootPjOaaVosA778yMc3WorerbtUl8Q+5NkzBi+wzVJcBt8OjOUXGLrO9+X
         JCt1NyApj3jBuU8jw9v1Y0pgvn/n3cq8wtx6KOxxdB11AY2e8f/PxcZ2Lk2fToXSZHGe
         3rrvNVBX7Pt50fEEpZ0K9e3ZjZFylqFcrdr/JTKywK5tUS0nV0zS3KsGcfbWpFkPoLD5
         2rohltqG0pvpBCdt3oeN8AVt7a2LuHKuZZBIiUIFaO0UC6GmwEloCmDsKeEiCeDoqe/Q
         PhIg==
X-Gm-Message-State: ABy/qLZxaakD1q+yM8UDuRW1HuSxGqFLmZ8JZc1HnA6qpWFtRc7hFczI
        4+vrx5SrpVUi0G51TjV1NW5crg==
X-Google-Smtp-Source: APBJJlHGtkn2B8a5339+4tfpJ7q/GhVUbf3pJrUtb5AT/WM57FBv03xGm94HhyHzQE+Bvcxq2ySxVQ==
X-Received: by 2002:a17:902:b708:b0:1b8:ae8c:7bfb with SMTP id d8-20020a170902b70800b001b8ae8c7bfbmr14199843pls.17.1689179738062;
        Wed, 12 Jul 2023 09:35:38 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([171.76.82.173])
        by smtp.gmail.com with ESMTPSA id w15-20020a1709027b8f00b001b9df74ba5asm4172164pll.210.2023.07.12.09.35.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 09:35:37 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH v4 9/9] riscv: Fix guest RAM alloc size computation for RV32
Date:   Wed, 12 Jul 2023 22:05:01 +0530
Message-Id: <20230712163501.1769737-10-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230712163501.1769737-1-apatel@ventanamicro.com>
References: <20230712163501.1769737-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, we ensure that guest RAM alloc size is at least 2M for
THP which works well for RV64 but breaks hugepage support for RV32.
To fix this, we use 4M as hugepage size for RV32.

Fixes: 867159a7963b ("riscv: Implement Guest/VM arch functions")
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/kvm.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/riscv/kvm.c b/riscv/kvm.c
index 4d6f5cb..8daad94 100644
--- a/riscv/kvm.c
+++ b/riscv/kvm.c
@@ -61,16 +61,25 @@ void kvm__arch_set_cmdline(char *cmdline, bool video)
 {
 }
 
+#if __riscv_xlen == 64
+#define HUGEPAGE_SIZE	SZ_2M
+#else
+#define HUGEPAGE_SIZE	SZ_4M
+#endif
+
 void kvm__arch_init(struct kvm *kvm)
 {
 	/*
 	 * Allocate guest memory. We must align our buffer to 64K to
 	 * correlate with the maximum guest page size for virtio-mmio.
-	 * If using THP, then our minimal alignment becomes 2M.
-	 * 2M trumps 64K, so let's go with that.
+	 * If using THP, then our minimal alignment becomes hugepage
+	 * size. The hugepage size is always greater than 64K, so
+	 * let's go with that.
 	 */
 	kvm->ram_size = min(kvm->cfg.ram_size, (u64)RISCV_MAX_MEMORY(kvm));
-	kvm->arch.ram_alloc_size = kvm->ram_size + SZ_2M;
+	kvm->arch.ram_alloc_size = kvm->ram_size;
+	if (!kvm->cfg.hugetlbfs_path)
+		kvm->arch.ram_alloc_size += HUGEPAGE_SIZE;
 	kvm->arch.ram_alloc_start = mmap_anon_or_hugetlbfs(kvm,
 						kvm->cfg.hugetlbfs_path,
 						kvm->arch.ram_alloc_size);
-- 
2.34.1

