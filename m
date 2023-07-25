Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29D4F761D4E
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 17:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbjGYPYz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 11:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbjGYPYx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 11:24:53 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C6E187
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 08:24:52 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id 5614622812f47-3a43cbb432aso3950926b6e.3
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 08:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1690298692; x=1690903492;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8NMJrD+DJLbJV3iwMT7tndl51Y/nhmykJEirAlnEkHg=;
        b=M61Sswbi5ReXBaZKWbH0t/tp2V2vtl4/nTiAI0mdYNizeNPh/3aIYP61yy0GTDeK6A
         2gfXaIrKnEJU1BEmy7fGbjqnO5/hSQmR3G1ptSfUCUk6/XkH+kpN/vgVSJmzSWE/9oTj
         /ZKWswWqd03jY1BrxMwnVdRokzAnofFpyy0p5ztDTjmyHNZTJbkzVNGCJdLh4WklXh5e
         I2/z6ihMYf2yp720V05kfEHfW6ylXfE2YuPlsBEoHt5B42NwqA+XpWD1gg8SchpvHBWW
         N9YIOmoJVvOO7cgAQER/YEISCoUWaXfZF4TlBizvbVA5bV2x/hzeCt92B9Bis4QkG24k
         Vhfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690298692; x=1690903492;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8NMJrD+DJLbJV3iwMT7tndl51Y/nhmykJEirAlnEkHg=;
        b=P0dpYSqA8+PXouVSGg8RMSTkBhCH9vMVY/JZiNV5ie+g6wvPIoN7YSAdCWXGumVgm1
         FXN7X5xdH4qJLTAjFS67FOM8nPk3w/fMRz6ayF0edFUbSilIuEC5zrO864/20n7cwlru
         XWuadNU6tQZ9Y/nWdRq7JjEmckQg8D5x6NSaFjxqb+jRLJLOdCTukDQ6zvliBFu2a2YO
         n+90Xw+zMCGaM+w/6obHMYkG6YdXvfzBqlt2slqZso8op2WHJwe0LZwu9fx00ky2Px/C
         YRHBI/VgHXy6wkBUAsumOppvc4/k5sc0qnZsIiagj2HYtYSVSGLxEnITTgcfcdpACgHP
         5xfA==
X-Gm-Message-State: ABy/qLb/EKp7wKgWlzdm2v9MGPIxxvOBGbBa2W5qlxnEM6NPatkkV8cG
        LM/zaCPz7DpvIeSGCVzpbz4ang==
X-Google-Smtp-Source: APBJJlHOcps1L1MmuAhBFamjf2tLasOZ7Jp94ZCHeAXs7prPYI9Dujqg7T9ug0noq1cxEmpmQf97qQ==
X-Received: by 2002:a05:6808:1a2a:b0:3a1:eb0e:ddc6 with SMTP id bk42-20020a0568081a2a00b003a1eb0eddc6mr16922851oib.29.1690298691731;
        Tue, 25 Jul 2023 08:24:51 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id g11-20020a17090adb0b00b002683fd66663sm980372pjv.22.2023.07.25.08.24.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jul 2023 08:24:51 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH 2/6] riscv: Add Svnapot extension support
Date:   Tue, 25 Jul 2023 20:54:26 +0530
Message-Id: <20230725152430.3351564-3-apatel@ventanamicro.com>
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

When the Svnapot extension is available expose it to the guest via
device tree so that guest can use it.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index df71ed4..2724c6e 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -19,6 +19,7 @@ struct isa_ext_info isa_info_arr[] = {
 	{"ssaia", KVM_RISCV_ISA_EXT_SSAIA},
 	{"sstc", KVM_RISCV_ISA_EXT_SSTC},
 	{"svinval", KVM_RISCV_ISA_EXT_SVINVAL},
+	{"svnapot", KVM_RISCV_ISA_EXT_SVNAPOT},
 	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
 	{"zbb", KVM_RISCV_ISA_EXT_ZBB},
 	{"zicbom", KVM_RISCV_ISA_EXT_ZICBOM},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index b0a7e25..863baea 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -34,6 +34,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-svinval",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SVINVAL],	\
 		    "Disable Svinval Extension"),			\
+	OPT_BOOLEAN('\0', "disable-svnapot",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SVNAPOT],	\
+		    "Disable Svnapot Extension"),			\
 	OPT_BOOLEAN('\0', "disable-svpbmt",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SVPBMT],	\
 		    "Disable Svpbmt Extension"),			\
-- 
2.34.1

