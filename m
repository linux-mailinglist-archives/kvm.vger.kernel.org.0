Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C03D7722823
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 16:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234341AbjFEODd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 10:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234288AbjFEODP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 10:03:15 -0400
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B92A131
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 07:03:00 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-19f6f8c840bso4439389fac.3
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 07:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1685973779; x=1688565779;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UIYA8beJZmA2NMdlgIpBmajMkuQ+bKy8H3Ug9/MSXpA=;
        b=IR/B/9KGcyrqBc4r//pqz1RV710rbcmsdYU8ISLpYI5nmpvcVOsg+vLcY3xl/w+Xm/
         brnbyjQpPH33FbOUEJjI0V2+U7Q77TTUKRYYMUJa79cyCirE6IWN89YA+KmRkjR/C57N
         OSJqlRVrMcpoWTpguGIszayxv2+vXbG7YtxE2Hfr/F+xtkr6fqyhESFysm/c0FhaSmqv
         jRlpOriP+v+YNMyE2qMFi68UgdwRl5Hqtj1Uvy9kdwcgoxt2lZdrjv2pZtogOYWT3VrQ
         zoviC4UVL7AxOm6vY1u7EDlktqauZ9EG9J5610Nfl7mFbc5uwL2fe87r6/UTMeVqNTtF
         e72w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685973779; x=1688565779;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UIYA8beJZmA2NMdlgIpBmajMkuQ+bKy8H3Ug9/MSXpA=;
        b=IwoOTcINFsCdce5Hli3h8KCngWQlcToIJYXdqyK1N71kzpHn+l31G7Qt1K5Lw7vLLd
         EjohqRJpXc+zib2a1lBz+d9y75i4sMstnlWJ8WNBSEtolLb3wK9GiPcTHOHVjuC3VoaD
         Db8MH0yc/VP7cBOhg/JGNQfdDciPfx5HfjKiv+eiqbpQkf7WegQ32yoDx4yA7dhIS7IW
         BQvwEsGZ5us+KqRTqgy8rgvPmZJIJ/zpg07+St53zClHU6eeBAsKS+l7kgU/+1oUxa/Z
         twb9J4jUX2cYGVL0O8LiKx0jbORzBcHrDYnXtBmvYiRlnyxrCfetNMaJsjOeeJZjtn9M
         8SyA==
X-Gm-Message-State: AC+VfDxCJ/EOnVp367AG+FX2Se2jBJ7lOPCnf+7uo0rt3bqzhgZmpIrw
        +kEG0BoKRkIFoWZgAKODn3HMxg==
X-Google-Smtp-Source: ACHHUZ4sRiUl8ZQ9Iel6R3RROXwWDQyrvXV1swcdDxV3nhK1shTguwNVIeCoxaUdLSKwUZtJTgbMug==
X-Received: by 2002:a05:6870:a242:b0:19f:63d1:3d4e with SMTP id g2-20020a056870a24200b0019f63d13d4emr9841870oai.33.1685973779564;
        Mon, 05 Jun 2023 07:02:59 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id f12-20020a4ace8c000000b0055ab0abaf31sm454787oos.19.2023.06.05.07.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 07:02:57 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH v2 8/8] riscv: Fix guest RAM alloc size computation for RV32
Date:   Mon,  5 Jun 2023 19:32:08 +0530
Message-Id: <20230605140208.272027-9-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230605140208.272027-1-apatel@ventanamicro.com>
References: <20230605140208.272027-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
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

