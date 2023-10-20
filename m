Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26E697D094E
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 09:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376400AbjJTHVx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 03:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235626AbjJTHVw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 03:21:52 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73601AE
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 00:21:50 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id 46e09a7af769-6ce37d0f1a9so158996a34.0
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 00:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1697786510; x=1698391310; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vbaUx5tgc13C+fDPGJz++EpIqc5R/EjgaTQRdQ/gzH0=;
        b=IQJxLwRnkVJswQiTcQ3xGR/+3EunbGluullE4WmjRR1F3aiazKBSlwTp3x6/MDhojj
         7wgvd9gAOfUGEbtRVNUKCD/tVmzRyeN3gpaJJTGSrwZWs9qZtz2mk3tM7NmJGVxAOGi1
         gRHv/MxPhOODdRGWEMk0c4RB/uOVuX6+tc5lJ64YK7NANRncHXaezJ34/1M4iFHI0dSd
         syTMDZgoJhnJ+pWmDd0bz0aQGF/ArsTDkXb0QZGr7oKjhK89aZP3sxZ7BoD7ZIPmj4oY
         ZdsaU5zldRjJhSOCPJnNH8pYLrJV5ji6LcsVv7t9sVfhQkYwjTfrIGqkurVDAnomQ8+m
         q2sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697786510; x=1698391310;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vbaUx5tgc13C+fDPGJz++EpIqc5R/EjgaTQRdQ/gzH0=;
        b=fu1HbtOUM7oXNMsO/ZgRK6uC7lp3y9XicIwF0oNh018R7Tl5pTFvgn6Dkz0SFkwzvK
         IoC9qBvqEYHz3Nj47rLBElv9HgAmvkyqCWyv9KEc779Bn4ck2JnAZWY3yPya1h3xH/Ls
         WS1qAW165I0bp4BiKAeNK6bntLGCbX59apmT8xuFuvl7wBBM4YmI7uuLKtVC7uoRFD9j
         9tMPDQvuDjZnev77Gm2Bzq8DyqAeAQO9AIVRjgjIQ9ERpzRVxyYYqCs3C/0sBmGjg0/f
         lbwQOsTb+n7lCs1fzmsyqsGyTxORDOt1XjEpH9qfS8Xl5ffs8bWKKjgVTqilqVvrcIc/
         Amaw==
X-Gm-Message-State: AOJu0YwfnJ4Fu1G6lIg7iwNWzNLjRiLpiWShRw8/44cODbOdBEdNnQGz
        QucrvrrV9/biSuaLoW1WBfKbbQ==
X-Google-Smtp-Source: AGHT+IGd8XOYNX5Cl6NNnHjukDwjUbSrOdVya8xac9O1HehPftFC2/Zt55vtSezxHy+OiVL/3DWrYQ==
X-Received: by 2002:a05:6358:5927:b0:168:a3b2:945a with SMTP id g39-20020a056358592700b00168a3b2945amr1087904rwf.0.1697786509722;
        Fri, 20 Oct 2023 00:21:49 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([171.76.83.81])
        by smtp.gmail.com with ESMTPSA id v12-20020a63f20c000000b005b32d6b4f2fsm828204pgh.81.2023.10.20.00.21.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Oct 2023 00:21:49 -0700 (PDT)
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
Subject: [PATCH v3 0/9] RISC-V SBI debug console extension support
Date:   Fri, 20 Oct 2023 12:51:31 +0530
Message-Id: <20231020072140.900967-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
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

The SBI v2.0 specification is now frozen. The SBI v2.0 specification defines
SBI debug console (DBCN) extension which replaces the legacy SBI v0.1
functions sbi_console_putchar() and sbi_console_getchar().
(Refer v2.0-rc5 at https://github.com/riscv-non-isa/riscv-sbi-doc/releases)

This series adds support for SBI debug console (DBCN) extension in KVM RISC-V
and Linux RISC-V.

To try these patches with KVM RISC-V, use KVMTOOL from riscv_sbi_dbcn_v1
branch at: https://github.com/avpatel/kvmtool.git

These patches can also be found in the riscv_sbi_dbcn_v3 branch at:
https://github.com/avpatel/linux.git

Changes since v2:
 - Rebased on Linux-6.6-rc5
 - Handled page-crossing in PATCH7 of v2 series
 - Addressed Drew's comment in PATCH3 of v2 series
 - Added new PATCH5 to make get-reg-list test aware of SBI DBCN extension

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

Anup Patel (8):
  RISC-V: Add defines for SBI debug console extension
  RISC-V: KVM: Change the SBI specification version to v2.0
  RISC-V: KVM: Allow some SBI extensions to be disabled by default
  RISC-V: KVM: Forward SBI DBCN extension to user-space
  KVM: riscv: selftests: Add SBI DBCN extension to get-reg-list test
  RISC-V: Add stubs for sbi_console_putchar/getchar()
  tty/serial: Add RISC-V SBI debug console based earlycon
  RISC-V: Enable SBI based earlycon support

Atish Patra (1):
  tty: Add SBI debug console support to HVC SBI driver

 arch/riscv/configs/defconfig                  |  1 +
 arch/riscv/configs/rv32_defconfig             |  1 +
 arch/riscv/include/asm/kvm_vcpu_sbi.h         |  7 +-
 arch/riscv/include/asm/sbi.h                  | 12 +++
 arch/riscv/include/uapi/asm/kvm.h             |  1 +
 arch/riscv/kvm/vcpu.c                         |  6 ++
 arch/riscv/kvm/vcpu_sbi.c                     | 61 +++++++-------
 arch/riscv/kvm/vcpu_sbi_replace.c             | 32 ++++++++
 drivers/tty/hvc/Kconfig                       |  2 +-
 drivers/tty/hvc/hvc_riscv_sbi.c               | 82 +++++++++++++++++--
 drivers/tty/serial/Kconfig                    |  2 +-
 drivers/tty/serial/earlycon-riscv-sbi.c       | 32 +++++++-
 .../selftests/kvm/riscv/get-reg-list.c        |  2 +
 13 files changed, 198 insertions(+), 43 deletions(-)

-- 
2.34.1

