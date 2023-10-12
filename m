Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05E397C647F
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 07:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377248AbjJLFRA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 01:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235278AbjJLFQ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 01:16:29 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9602109
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 22:15:55 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-690bf8fdd1aso424562b3a.2
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 22:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1697087754; x=1697692554; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OF/0DZOVOE1sZojsrN9hmq2DR3MNn3xhzg86O8Xb4xI=;
        b=WYjq3fg+8kKiVa5lkt3Ks+ekmj+gy00U9BX1uXQVGlpx/A1AFhE38CRYGV1BzRmkSe
         6C4AtQhwGvXkRKCeq3U2VYQl6StssivMYavEveO0X22ivPNkDvRLZxqzJ3CMinEfdGox
         sbv4g8Ozapgl3IoNbjw7S2QuOQzQORhlJR9hLWSWMhTzIP1MsCoZtd4NbPF//KgABS4P
         wjM3QofnJce4VWzVmEhAPSVVZ3KxtJ0BEbf8FtONP9r3TEZrS5xbkL7hESyFco+/8Q5g
         Qvm11BtO62vFh2YbUD2Crh01K3/rCZxnPlAQAL0AC9IUwQDmC3mTEg2S2tXpVO5/daZy
         zssg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697087754; x=1697692554;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OF/0DZOVOE1sZojsrN9hmq2DR3MNn3xhzg86O8Xb4xI=;
        b=F/uAMStvzAmzZLkuJ4y9O+oE2dBmi7U9MoTjdQXCysP7hnbSop1k7UkqYnHlJKPls/
         joEpBqTdf5pt1KuG1HUlrYyPDJ9urscGFPBT/dbbIdI6STOjcrnq0F/CzrZ6f7YPZcBf
         0798T/zD1lLlvtufdRvYjn+Ur5wwpG0vJeqwON/il4dyPdYOe2rontsM2+ioF5kW+Atz
         9hJz8VbCVR8g6DrtePaEMckQhg3KK1xMIwBqPwg2mGk/XZ0hXHsculsRo61q34gvpf9X
         j5OYqffHDzPHpD2k32CGoQzKtiVXgaUKsFvIENBjiqqr+HfrvMOb8VX1Pr8OMegvQBY3
         dUwA==
X-Gm-Message-State: AOJu0YwYvXZh0uWEHaGOIEEXKL/nXG7YLU0+qNnbtlBq/kOt+NGZaMlp
        uORqSaqFtKDvcUOrIzUznkzaIw==
X-Google-Smtp-Source: AGHT+IHHIH1Tdrtn/mSat4PHYLTk01ptLU1brEyLKx+dYtjl1X4EaH3wN0nwyAyQPO2cGFlvgUSgrQ==
X-Received: by 2002:a05:6a20:918e:b0:162:edc2:4e9f with SMTP id v14-20020a056a20918e00b00162edc24e9fmr22994297pzd.62.1697087754489;
        Wed, 11 Oct 2023 22:15:54 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([106.51.83.242])
        by smtp.gmail.com with ESMTPSA id s18-20020a17090330d200b001b9d95945afsm851309plc.155.2023.10.11.22.15.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Oct 2023 22:15:54 -0700 (PDT)
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
Subject: [PATCH v2 8/8] RISC-V: Enable SBI based earlycon support
Date:   Thu, 12 Oct 2023 10:45:09 +0530
Message-Id: <20231012051509.738750-9-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231012051509.738750-1-apatel@ventanamicro.com>
References: <20231012051509.738750-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
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

