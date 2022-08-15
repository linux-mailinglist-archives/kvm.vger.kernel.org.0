Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A10C592D16
	for <lists+kvm@lfdr.de>; Mon, 15 Aug 2022 12:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242359AbiHOKPE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 06:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242525AbiHOKO0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 06:14:26 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FBEC237E0
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 03:13:57 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id o3so5982784ple.5
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 03:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=IWTUh3iHbEb9pKm4ekruP42bdO6T5Kf1OPdg5bKcFFY=;
        b=hs8JZ2qN2qrEX3eOADSLayJdksTSs20yujb94oPfHNp/Kv/0nWiquIFXCE7fgNIIPz
         xBzsS24ShG5QvwDFoFjVVyoxfZDKQ5N3Vy0jzzY8WEofn5IksBwqSnGC5jNSCOPhSxn+
         oFgx0IV5AydJ1t+97pSkFoLMuxtpX3suJ0zh5xTW7POWU/lbsINpCodwK4PgCzSGhV8m
         rPDsrxdR9ZAdDcwtZ+ZZZD0OLrtzQm/RYQwcucH3fg+L8Q97lwjdvTpNBBO2oRaBmOqi
         QoHI4OSJNUyKCY3+WGhqq8n8AOUQrC40yymajR26ktI2n2ij7U5qtmlloyBIqHFKkuMC
         G0YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=IWTUh3iHbEb9pKm4ekruP42bdO6T5Kf1OPdg5bKcFFY=;
        b=POfmRQyOvvAXjCBKz3U6D7pwzGWl/cFeLTbN9n0++dAc6WEvfxGVJEnL6FZfnn4HB8
         3F3BaXwAipQ75IzZzmvEEapMG8yXeZo6B6IYBGxLinIaPXLjocmc1baC1g2d7mgQz9KK
         3Ovsm5R43/wMZWViGWok8fGTOzNNq0iWjsSsMnu9oqHxOGZABmm5jayWL81/stNg9ExS
         Am2jg4MRvg6eNpM7wNSxuAM06+4eSdJuBwEIpn0x8fC39nlQz4o+7dQj4M0Csy13iqUF
         IACkJ89l0bz2qHWKLmKrwSWL/79vbNaQ3cywn5F9YK0XjlKX+WeHUNFWNsuIO4Wc5PQ1
         a5cg==
X-Gm-Message-State: ACgBeo2ZcOi3UzOfWDo4cjWSyPxrp+GrM42LuBwZPLAOyztJ2EGwcEtC
        YM9XLHZYpmUmYMGuIsgXUaiGeZfWDGlNwg==
X-Google-Smtp-Source: AA6agR7e4z4yL9cHsHmNZBsmwSBeF40lbm/phYGDuKLJVl2x6I+ye3+yQV+ERxuYj6vtGLmf4dcdlw==
X-Received: by 2002:a17:90a:7407:b0:1f4:fe7e:bd51 with SMTP id a7-20020a17090a740700b001f4fe7ebd51mr27412621pjg.218.1660558435881;
        Mon, 15 Aug 2022 03:13:55 -0700 (PDT)
Received: from anup-ubuntu64-vm.. ([171.76.84.46])
        by smtp.gmail.com with ESMTPSA id i190-20020a6254c7000000b0052d4f2e2f6asm6267437pfb.119.2022.08.15.03.13.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 03:13:55 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH kvmtool 5/5] riscv: Fix serial0 alias path
Date:   Mon, 15 Aug 2022 15:43:25 +0530
Message-Id: <20220815101325.477694-6-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220815101325.477694-1-apatel@ventanamicro.com>
References: <20220815101325.477694-1-apatel@ventanamicro.com>
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

We have all MMIO devices under "/smb" DT node so the serial0 alias
path should have "/smb" prefix.

Fixes: 7c9aac003925 ("riscv: Generate FDT at runtime for Guest/VM")
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index aeba042..e3d7717 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -122,6 +122,7 @@ static int setup_fdt(struct kvm *kvm)
 		cpu_to_fdt64(kvm->arch.memory_guest_start),
 		cpu_to_fdt64(kvm->ram_size),
 	};
+	char *str;
 	void *fdt		= staging_fdt;
 	void *fdt_dest		= guest_flat_to_host(kvm,
 						     kvm->arch.dtb_guest_start);
@@ -205,12 +206,15 @@ static int setup_fdt(struct kvm *kvm)
 	_FDT(fdt_end_node(fdt));
 
 	if (fdt_stdout_path) {
-		_FDT(fdt_begin_node(fdt, "aliases"));
-		_FDT(fdt_property_string(fdt, "serial0", fdt_stdout_path));
-		_FDT(fdt_end_node(fdt));
-
+		str = malloc(strlen(fdt_stdout_path) + strlen("/smb") + 1);
+		sprintf(str, "/smb%s", fdt_stdout_path);
 		free(fdt_stdout_path);
 		fdt_stdout_path = NULL;
+
+		_FDT(fdt_begin_node(fdt, "aliases"));
+		_FDT(fdt_property_string(fdt, "serial0", str));
+		_FDT(fdt_end_node(fdt));
+		free(str);
 	}
 
 	/* Finalise. */
-- 
2.34.1

