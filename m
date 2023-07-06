Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7128874A33D
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 19:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbjGFRj2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 13:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbjGFRj0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 13:39:26 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0B501FE6
        for <kvm@vger.kernel.org>; Thu,  6 Jul 2023 10:39:07 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id ca18e2360f4ac-78666994bc2so34611439f.0
        for <kvm@vger.kernel.org>; Thu, 06 Jul 2023 10:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1688665147; x=1691257147;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UIYA8beJZmA2NMdlgIpBmajMkuQ+bKy8H3Ug9/MSXpA=;
        b=YiUseGS++NnZP5HYtNORUhBq4BPckrWLkmidqcclaQe4tMk9YoaIBfE+vG/OMmIKvI
         fwk3URZqqS99ijG8L5cbuJADwqXO1xLkS1mfVKz87qiUcedEkGpgoiZkz6+5LsNRv+Fq
         TKh9iDvmkrNf+LkbVsRl5+Qj6JD3NNIy8mV+/VQaQFduUVjvYRn2KS3j9QQ7UhZwBpR0
         f3Xj7qHHIhVTp12qVxEYPifnk8WCahxoCUmyQdfadBV/0Xs14MHZ8Cu70AsSsfEsY880
         cAfJ/Zg3NtWnqWxAVzlUO03DC+w0fbMqE/VVPEQzHRf135Kfi0GyVJQsQGcVxyf0VjGl
         cAQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688665147; x=1691257147;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UIYA8beJZmA2NMdlgIpBmajMkuQ+bKy8H3Ug9/MSXpA=;
        b=FNIsbBDdwITlHj2j3z3SsTb8vh0fDFvZp1PpM4tDKpI5UAb473GvnRarLOsLrBNJfu
         ZdhRQN1yUrt8WVuyuQLh8R7yibCMEYfE6N0bVCpYYYGcfY9aotw++MlC6v8ekvooWuin
         pjnj5S4k+xs4IiuzT4qkzPkVTgJJvHKpSdKYAIes+TTeBgNhv40fm1/XEDij0W11vwEn
         b+xjCNaa3WBowShBr7hx2IMgdjzKGgXQKBGvOeUGYIyLOeaZR6K5e3A9oLM8DhQumdVe
         YrcEcmpRieJDuUnHkKhRaHLUelY29yLlw2V0lQYdKh17XG88PmaHZeagqN4Nh2jEl40d
         gQ3w==
X-Gm-Message-State: ABy/qLYOTOMO3uk92L0MPMvwyF7x3GNJjwYM5gJuVlZYVPB2oC3ZCakZ
        O1PGtXRwb/vdR0Bk05PvdIbWAA==
X-Google-Smtp-Source: APBJJlGO5febAOpcUaBoLA4EyZCXXCdSIHwz/JG901yWz0oqePeSfgIHDeICDdFHW2H3bHgKg5QiIw==
X-Received: by 2002:a5d:9eda:0:b0:783:58f4:2e2e with SMTP id a26-20020a5d9eda000000b0078358f42e2emr2274826ioe.0.1688665146895;
        Thu, 06 Jul 2023 10:39:06 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id q8-20020a0566380ec800b0042b70c5d242sm633528jas.116.2023.07.06.10.39.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jul 2023 10:39:06 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH v3 8/8] riscv: Fix guest RAM alloc size computation for RV32
Date:   Thu,  6 Jul 2023 23:08:04 +0530
Message-Id: <20230706173804.1237348-9-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230706173804.1237348-1-apatel@ventanamicro.com>
References: <20230706173804.1237348-1-apatel@ventanamicro.com>
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

