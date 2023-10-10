Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06CB97C021F
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 19:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233690AbjJJRFR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 13:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232520AbjJJRFQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 13:05:16 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D1DC99
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 10:05:14 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1c9c5a1b87bso2814905ad.3
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 10:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1696957514; x=1697562314; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WPT4Fkg+ojgLC0XZKWvgq9PlzRbEr2TYZf8y6H1Pt5Y=;
        b=YirICCXYVt9Ox0tLS8QVqxe4hwnncJxDIXDBkpwP6tDWjXlwRJUMMtmCq+sh4NwuTT
         e8XvwdZ7NGTsdar5bQNOiQwFu6+y2hA+wxr6gigT9xbSlm30fGm9654rluwArjXCp4oN
         Z1JPI5tDDcC5JxFdEcLzJ/4tnS3V1Y/FbloHdesQ2EK9xvYlFhmgRLrifNdFoQIDhX5D
         39r0nBIJ+yXfHoOUG9cpduWoYKU3jHble0n6cxP6RedVlB46w71ncc9dXPYsiNZDbrqm
         4tL5QNPKO5clun+TkXD48HsY3dq5kd8g9M3Ic5BJskEA/1k4xIFcDUvxdwd8WeW+NAhK
         QzKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696957514; x=1697562314;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WPT4Fkg+ojgLC0XZKWvgq9PlzRbEr2TYZf8y6H1Pt5Y=;
        b=HbBW9pncHQqAWOTeHFe+85Ov9DWmh9S7nCK91hBqcsuMgxK9vqCsKKaZP5UJ8PxI+a
         WCTWmYO9pBZcBMXvTAi8wq+J+NrK9aQcMiC4nfrU8TEF+sB2o4FsRG45I7Vf+MP1LOzn
         Na1A5DeIkahyWVfVu/uK6oClTbhXxZUePyTqkT8SefsNDeaNl9vVyHAuDgiY8Pp/jlMX
         XxQZEdD7J5nEUgL3mq4P7kr4Y2YWAqoklsZfFc6pgBZboY4lWqkTZCx6rOAq5h1ibEib
         9/847TV7840oyZWnbH2SIOE+9pP6FgjFvISEXAcO7cBNGOnFT5CLQeB32uXaArK4geDN
         H5oA==
X-Gm-Message-State: AOJu0YyLEWiuECfrP9D8br+ZjDBallMPlTIdPsiZpRRFpWUQwQ9Ii3xq
        MV1lHMOW0M7IXGtZymxbMCYP5g==
X-Google-Smtp-Source: AGHT+IFym/OscZjdiaKnZudFAiUw/7t8pHDcgobeGgruKdPyihzD8VGIHQ5tw7zHoHGLJR6WzQgjAQ==
X-Received: by 2002:a17:902:eb46:b0:1c9:c5a6:1d00 with SMTP id i6-20020a170902eb4600b001c9c5a61d00mr895380pli.1.1696957513651;
        Tue, 10 Oct 2023 10:05:13 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id w19-20020a1709027b9300b001b89536974bsm11979868pll.202.2023.10.10.10.05.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 10:05:12 -0700 (PDT)
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
Subject: [PATCH 0/6] RISC-V SBI debug console extension support
Date:   Tue, 10 Oct 2023 22:34:57 +0530
Message-Id: <20231010170503.657189-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds support for SBI debug console extension in KVM RISC-V
and Linux RISC-V.

To try these patches with KVM RISC-V, use KVMTOOL from riscv_sbi_dbcn_v1
branch at: https://github.com/avpatel/kvmtool.git

These patches can also be found in the riscv_sbi_dbcn_v1 branch at:
https://github.com/avpatel/linux.git

Anup Patel (5):
  RISC-V: Add defines for SBI debug console extension
  RISC-V: KVM: Change the SBI specification version to v2.0
  RISC-V: KVM: Forward SBI DBCN extension to user-space
  tty/serial: Add RISC-V SBI debug console based earlycon
  RISC-V: Enable SBI based earlycon support

Atish Patra (1):
  tty: Add SBI debug console support to HVC SBI driver

 arch/riscv/configs/defconfig            |  1 +
 arch/riscv/configs/rv32_defconfig       |  1 +
 arch/riscv/include/asm/kvm_vcpu_sbi.h   |  3 +-
 arch/riscv/include/asm/sbi.h            |  7 +++
 arch/riscv/include/uapi/asm/kvm.h       |  1 +
 arch/riscv/kvm/vcpu_sbi.c               |  4 ++
 arch/riscv/kvm/vcpu_sbi_replace.c       | 31 ++++++++++
 drivers/tty/hvc/Kconfig                 |  2 +-
 drivers/tty/hvc/hvc_riscv_sbi.c         | 80 ++++++++++++++++++++++---
 drivers/tty/serial/Kconfig              |  2 +-
 drivers/tty/serial/earlycon-riscv-sbi.c | 35 +++++++++--
 11 files changed, 153 insertions(+), 14 deletions(-)

-- 
2.34.1

