Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4C47D096B
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 09:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376515AbjJTHXR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 03:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376458AbjJTHWt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 03:22:49 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD476199D
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 00:22:32 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-1e9c9d181d6so399040fac.0
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 00:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1697786551; x=1698391351; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DQOTSMVYEAXB96lPNmfxUETXmF1nmywj/hDtdToDI6M=;
        b=Jb/OhA2L1vep8syvG8Ez0j19Zv4UJmFoTgTdokFmzHBwZ4335kx3ycYFl9tkj49v7A
         SrUVu0Yc5/p72SSDT8YEr2PnSMuCl1nyHZHLEstID6BlZ0u70WTwbmrt/7UcqgzTOO6e
         +dWWMmXA3qn9iSH47TlsGEyidwCYBBFSAH8RRhJE/Coq9M/mwunuX1rWpNyXgrttUWMf
         K4IKq7j3n5G6Kj+ZKnUUMfbAUodR7mVgPfnL6tT29PIsDC9qWxw5TMgY5t2hqnsgMGWB
         P2kOWbRUvHXaDqHm/nal0EmKzjiA+TF32CNinC5qTl5F0m2c2DQV6udtjFn8PRq/ZOS2
         JuWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697786551; x=1698391351;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DQOTSMVYEAXB96lPNmfxUETXmF1nmywj/hDtdToDI6M=;
        b=motpieE3EAyLsY9dI9ukqQJ25u3TX31EV7Uxl+CdrcZU/emCjX+VzJ723CfOSSttS+
         j+BtWjyOTZjy+z13H38A4j/5OOFCkuHkDyh23T5xVkkVPoLyCoHBmh2ObSSrshmoX7m0
         Qra1uGYD9oHBiHkevgwkEFlkDXzplhKtEwE458GV5c2/uwHoCxow8k2fAzSEjP/cgC7G
         T5dsMVqSpKf9LQaH7B0qGVUo1mHWrTEpEMP7CP0Vy3I0yJ9f91nf6YsTvrEzA87j4fox
         BBcuOKzDQMxE7+gCmrOAJj9z197JjKdo5zMv6XjuPJUA8Ao7XXsowp86UY9mdyiLBLZj
         pQ+Q==
X-Gm-Message-State: AOJu0YzmFLLUwjYiQLFXiPwKJlh5TBR/l/h7C3U8zYpXCWx75rkTI8kY
        fBUABnEbr2znMsfqY494NtNyYQ==
X-Google-Smtp-Source: AGHT+IHVpVTtGUUCbE9QtkhDvgB6PWIuexjVRbTOQpUxtFm1xcTHF7ruZ9rqINTCV8Ep/hVGmPBCuA==
X-Received: by 2002:a05:6871:3316:b0:1e9:9215:3987 with SMTP id nf22-20020a056871331600b001e992153987mr1427367oac.16.1697786550612;
        Fri, 20 Oct 2023 00:22:30 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([171.76.83.81])
        by smtp.gmail.com with ESMTPSA id v12-20020a63f20c000000b005b32d6b4f2fsm828204pgh.81.2023.10.20.00.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Oct 2023 00:22:30 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>
Cc:     Conor Dooley <conor@kernel.org>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH v3 9/9] RISC-V: Enable SBI based earlycon support
Date:   Fri, 20 Oct 2023 12:51:40 +0530
Message-Id: <20231020072140.900967-10-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231020072140.900967-1-apatel@ventanamicro.com>
References: <20231020072140.900967-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let us enable SBI based earlycon support in defconfigs for both RV32
and RV64 so that "earlycon=sbi" can be used again.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/configs/defconfig      | 1 +
 arch/riscv/configs/rv32_defconfig | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/riscv/configs/defconfig b/arch/riscv/configs/defconfig
index ab86ec3b9eab..f82700da0056 100644
--- a/arch/riscv/configs/defconfig
+++ b/arch/riscv/configs/defconfig
@@ -132,6 +132,7 @@ CONFIG_SERIAL_8250_CONSOLE=y
 CONFIG_SERIAL_8250_DW=y
 CONFIG_SERIAL_OF_PLATFORM=y
 CONFIG_SERIAL_SH_SCI=y
+CONFIG_SERIAL_EARLYCON_RISCV_SBI=y
 CONFIG_VIRTIO_CONSOLE=y
 CONFIG_HW_RANDOM=y
 CONFIG_HW_RANDOM_VIRTIO=y
diff --git a/arch/riscv/configs/rv32_defconfig b/arch/riscv/configs/rv32_defconfig
index 89b601e253a6..5721af39afd1 100644
--- a/arch/riscv/configs/rv32_defconfig
+++ b/arch/riscv/configs/rv32_defconfig
@@ -66,6 +66,7 @@ CONFIG_INPUT_MOUSEDEV=y
 CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_8250_CONSOLE=y
 CONFIG_SERIAL_OF_PLATFORM=y
+CONFIG_SERIAL_EARLYCON_RISCV_SBI=y
 CONFIG_VIRTIO_CONSOLE=y
 CONFIG_HW_RANDOM=y
 CONFIG_HW_RANDOM_VIRTIO=y
-- 
2.34.1

