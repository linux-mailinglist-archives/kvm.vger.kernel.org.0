Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8B326FD9A6
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 10:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236688AbjEJIjo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 04:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236751AbjEJIjP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 04:39:15 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA83A5FF1
        for <kvm@vger.kernel.org>; Wed, 10 May 2023 01:38:51 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-18b1c643219so2801048fac.2
        for <kvm@vger.kernel.org>; Wed, 10 May 2023 01:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1683707930; x=1686299930;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UIYA8beJZmA2NMdlgIpBmajMkuQ+bKy8H3Ug9/MSXpA=;
        b=D4cGe8gY8Xl3/CpkIKCO0Hhk6J+mhlPUcRZFd3Nvjx4WDq8fvK2yfQNxMs0PaEtTQg
         5bfTsjF+JKHFOzavodeQj1JeaRm92L0toCyZufL+tSxgUT9XJNlc8d+RSA3u+NblFukD
         nHeEtGM66fy2IQvWpcrRj9MwQimjWy9hm7cqtnXV+7V1XQ4vJzq3V5zziB+1x/TopweM
         Oc2TkRa/lRv1ktSz5CAMMoaq7KOP3NOh6nYMxF/qm+nsuQb1Hbv7u+cE/XNZflZ4KwGF
         BgmdCJYO5ZMrrsXBpxl7WvGI0P+hXB3IDxhhd0B3rUmYg5g8GvUdddbjxkuEqEwQlmDE
         vNoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683707930; x=1686299930;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UIYA8beJZmA2NMdlgIpBmajMkuQ+bKy8H3Ug9/MSXpA=;
        b=KYfyHKrLnyMLyM/kTv9jme4tYFenpXgmuzZYQqX+0smDp54RctWpi2rLrC/DfrvLzY
         oDtL6OVzmRlOoov1FAVnetDoziK6wm3623uXqB5QefKa32EhR//WvC7CsHyA3AP3axlO
         3xDKMJD+NqNBFUyZcuv6LiUDrrAitQDTP+0tIT9zxy9+CUL7mZBJTbSURZx8Pmb0JZWj
         TnvtMiZTA9u8mLfZiIJhv45kaQPFnIjqI8mld6HNlH/T+rHCNGvTbxapSU0DggXjD4Y3
         s77lT87rOsOp7992+KWgp9chmOaEZjM3yflbNMUnZg65ZUAFZu5EZzovqJNiaYWkZbye
         1XIQ==
X-Gm-Message-State: AC+VfDy7xIiqny4pelrnqap8+2qrq+sTtHzSeHqrmjCQifU+tXM2adlU
        7E3m+7laRXigDy7XL/NOS/pKKw==
X-Google-Smtp-Source: ACHHUZ6sogvBjtHFRozzhu5KwT2UIUSBvh8ixz3U327hzB/z7lrXqT0sHh0Yq4hoI4D8o71Tde7M6g==
X-Received: by 2002:a05:6870:d501:b0:184:5f08:a130 with SMTP id b1-20020a056870d50100b001845f08a130mr6271903oan.33.1683707930140;
        Wed, 10 May 2023 01:38:50 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id n12-20020a9d64cc000000b006a65be836acsm6049711otl.16.2023.05.10.01.38.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 01:38:49 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH kvmtool 8/8] riscv: Fix guest RAM alloc size computation for RV32
Date:   Wed, 10 May 2023 14:07:48 +0530
Message-Id: <20230510083748.1056704-9-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230510083748.1056704-1-apatel@ventanamicro.com>
References: <20230510083748.1056704-1-apatel@ventanamicro.com>
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

