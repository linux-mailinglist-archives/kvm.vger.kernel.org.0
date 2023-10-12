Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5A47C6465
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 07:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376959AbjJLFPX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 01:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234099AbjJLFPV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 01:15:21 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1D0AB8
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 22:15:19 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1c60cec8041so4285875ad.3
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 22:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1697087719; x=1697692519; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xYp5d01yjoieOqk/RkEsuV4xU8mIT2wOo0WVBK9XVOw=;
        b=b2U2xlBdhLNmojbTWlKg6h/wiuEFBOwdQizMaSZpjhVJMTWnFOsEHP+Fb50ss4lvMb
         dRuHPLY1NY0g4VJYWnnjM6liqlo45EFsj5gtUyx/xTLsZW6ZJOkc6HpabmooBEU+hBlI
         oLSOw8FDL7DLp+3XhrWG3RNA6Bb2C21p8SU5G1o4WrHj5ODjEmOx0xAcdcwELl15hB7e
         Alxs6NtonfrE2TOx4iTPAymqXN2ptM/eiAx9kzLoBz9vV25srw+dvXoAc6bSHcAujstE
         xU4jp/ST3sU7ADIYxpNVDmbA16/R7uhjMFrdE4hnWINArbOhIOAgcIjgpOYX9amvO/hj
         Q3hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697087719; x=1697692519;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xYp5d01yjoieOqk/RkEsuV4xU8mIT2wOo0WVBK9XVOw=;
        b=RFhOSMUSUJGP8+GwcO0lc6DjpwaeaWr4eON406TXZU0PCU68Zax3zZjjL9RiCDD47t
         mnMuG/TJlkKdQUmcv/d7PzcPmTy3SVg74AwdAVcCFdHi7Y1Icqe6rvQoc1i5KjBMlURJ
         HZE+cA4qVeUXdsWtC/MhF/bL/b0ILx2nnr0qu3JojWQ5k0ZoDXqzwp8NtjU5xy4R8quk
         P+2EHrN3hWMScO91D3xDnGa2f1K5LS0YayzlC9g44A1k5VHGI5valerlhCKZeUyNotCO
         BaccgxF1qzxuxbjOlEiOLfbrXpOeUnTtvje7ndCSh1Nzy07aTips0/0eehGdhV8Ae/+h
         846A==
X-Gm-Message-State: AOJu0YzjlRuQwo7mEr5B4Pz94/jeXXE+OVD8rMoGdHaXNpv+Aa0rfT66
        Hq6kdndnFFPBG0pygHKZJKNEwA==
X-Google-Smtp-Source: AGHT+IHEPFFUqt3pliIbieg/aaMtAbi3pZkt/8nzFWa9PAcsbNguDQ6TUJOXLaRnVEd017jWXQ44gg==
X-Received: by 2002:a17:902:e888:b0:1c7:37e2:13fe with SMTP id w8-20020a170902e88800b001c737e213femr22891127plg.2.1697087719126;
        Wed, 11 Oct 2023 22:15:19 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([106.51.83.242])
        by smtp.gmail.com with ESMTPSA id s18-20020a17090330d200b001b9d95945afsm851309plc.155.2023.10.11.22.15.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Oct 2023 22:15:18 -0700 (PDT)
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
Subject: [PATCH v2 0/8] RISC-V SBI debug console extension support
Date:   Thu, 12 Oct 2023 10:45:01 +0530
Message-Id: <20231012051509.738750-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
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

The SBI v2.0 specification is now frozen. The SBI v2.0 specification defines
SBI debug console (DBCN) extension which replaces the legacy SBI v0.1
functions sbi_console_putchar() and sbi_console_getchar().
(Refer v2.0-rc5 at https://github.com/riscv-non-isa/riscv-sbi-doc/releases)

This series adds support for SBI debug console (DBCN) extension in KVM RISC-V
and Linux RISC-V.

To try these patches with KVM RISC-V, use KVMTOOL from riscv_sbi_dbcn_v1
branch at: https://github.com/avpatel/kvmtool.git

These patches can also be found in the riscv_sbi_dbcn_v2 branch at:
https://github.com/avpatel/linux.git

Changes since v1:
 - Remove use of #ifdef from PATCH4 and PATCH5 of the v1 series
 - Improved commit description of PATCH3 in v1 series
 - Introduced new PATCH3 in this series to allow some SBI extensions
   (such as SBI DBCN) do to disabled by default so that older KVM user space
   work fine and newer KVM user space have to explicitly opt-in for emulating
   SBI DBCN.
 - Introduced new PATCH5 in this series which adds inline version of
   sbi_console_getchar() and sbi_console_putchar() for the case where
   CONFIG_RISCV_SBI_V01 is disabled.

Anup Patel (7):
  RISC-V: Add defines for SBI debug console extension
  RISC-V: KVM: Change the SBI specification version to v2.0
  RISC-V: KVM: Allow some SBI extensions to be disabled by default
  RISC-V: KVM: Forward SBI DBCN extension to user-space
  RISC-V: Add inline version of sbi_console_putchar/getchar() functions
  tty/serial: Add RISC-V SBI debug console based earlycon
  RISC-V: Enable SBI based earlycon support

Atish Patra (1):
  tty: Add SBI debug console support to HVC SBI driver

 arch/riscv/configs/defconfig            |  1 +
 arch/riscv/configs/rv32_defconfig       |  1 +
 arch/riscv/include/asm/kvm_vcpu_sbi.h   |  7 ++-
 arch/riscv/include/asm/sbi.h            | 12 ++++
 arch/riscv/include/uapi/asm/kvm.h       |  1 +
 arch/riscv/kvm/vcpu.c                   |  6 ++
 arch/riscv/kvm/vcpu_sbi.c               | 49 +++++++++-------
 arch/riscv/kvm/vcpu_sbi_replace.c       | 32 +++++++++++
 drivers/tty/hvc/Kconfig                 |  2 +-
 drivers/tty/hvc/hvc_riscv_sbi.c         | 76 ++++++++++++++++++++++---
 drivers/tty/serial/Kconfig              |  2 +-
 drivers/tty/serial/earlycon-riscv-sbi.c | 32 +++++++++--
 12 files changed, 188 insertions(+), 33 deletions(-)

-- 
2.34.1

