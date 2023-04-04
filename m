Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C796B6D6774
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 17:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235265AbjDDPfN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 11:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235123AbjDDPfM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 11:35:12 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 176DB211D
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 08:35:11 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id f14so10938109oiw.10
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 08:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1680622510; x=1683214510;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=C6R4aOyJyDkIgHIVotRNcx/chT2oC7UuU6Y6qIEoUAE=;
        b=j4Q5gDOHHnM+qB7ifoJy+oxC06Zdjb9mpbd7zIX7SMvhGKkBoDsWify1l6fwb3SssM
         N02pq7k5H0o9Hmlxm2NiGEwFdUER2roPwv10kwFFy8YE0Cd1C9H9eKvfB9OdFpJGozYm
         FLMkRMNBQgL5JkXiSaR9238raAY8paxS8rmwYLS0pnfW/uIN0NBYqUNKOCd7kVKcKPZ6
         h82T3FzgWs/iIAjpTKhFEh4nrllSp/gPvdowFqLjmartx45XFKmLMN5j2Y8yOzH0ZsPm
         s+sy5jMukDwXigjWAVzcmaRwq7jf3mWiySiJcR0XOvU1ROc3iKWZ+dVPDzUVm+60yFZg
         KeNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680622510; x=1683214510;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C6R4aOyJyDkIgHIVotRNcx/chT2oC7UuU6Y6qIEoUAE=;
        b=tMXGQD54CM2QLO76O3aKD+rmBxHzoj9nveuFNLdEY2+cERmMA9SQwGvtqaMg4p4EHw
         WZmEUVu4WP2GzPgF+SEIk6d8BnLJMc5zVbgJCbwTq/38EZFEBXg2vXQU33O6CIRUBPho
         bPRW1UHg30uIvG5RPsSXNe91igHIJueeI67pxi2dKutEJRpoY47lfQg0B+4C2Wx0dJ45
         fmpiA62ZyhY9YB7h33DbeNU57GWfa6jFLmEk2ru51NBzkfrcej19JJS3bRP4uO4btayP
         SYCBCoKPNBpZ1Gx2woL4j0IWVhlc2p0Yywbq0gKatszb14NCM+8A3aUrJEF1DVsDZCPz
         2uLw==
X-Gm-Message-State: AAQBX9djJPgnm5tS1kC8faRUXOn4EBw8hKXFGtzcJALJ6t9P8VaDJo/J
        8vuCeRRJBkft/ijLZA5xZiUsyw==
X-Google-Smtp-Source: AKy350bhAMUu2udM02Eak5zwTeupgQEs2dp62vPjEaPrpcdme8sxsXnyn58f0Ujpp4CaSj2io/h7JQ==
X-Received: by 2002:a05:6808:2d5:b0:386:d629:81a1 with SMTP id a21-20020a05680802d500b00386d62981a1mr1300978oid.35.1680622510321;
        Tue, 04 Apr 2023 08:35:10 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id w124-20020acadf82000000b00387384dc768sm5325803oig.9.2023.04.04.08.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 08:35:09 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH v4 0/9] RISC-V KVM virtualize AIA CSRs
Date:   Tue,  4 Apr 2023 21:04:43 +0530
Message-Id: <20230404153452.2405681-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The RISC-V AIA specification is now frozen as-per the RISC-V international
process. The latest frozen specifcation can be found at:
https://github.com/riscv/riscv-aia/releases/download/1.0-RC3/riscv-interrupts-1.0-RC3.pdf

This series implements first phase of AIA virtualization which targets
virtualizing AIA CSRs. This also provides a foundation for the second
phase of AIA virtualization which will target in-kernel AIA irqchip
(including both IMSIC and APLIC).

The first two patches are shared with the "Linux RISC-V AIA Support"
series which adds AIA driver support.

To test this series, use AIA drivers from the "Linux RISC-V AIA Support"
series and use KVMTOOL from the riscv_aia_v1 branch at:
https://github.com/avpatel/kvmtool.git

These patches can also be found in the riscv_kvm_aia_csr_v4 branch at:
https://github.com/avpatel/linux.git

Based-on: 20230401112730.2105240-1-apatel@ventanamicro.com
(https://lore.kernel.org/lkml/20230401112730.2105240-1-apatel@ventanamicro.com/)

Based-on: 20230403121527.2286489-1-apatel@ventanamicro.com
(https://lore.kernel.org/lkml/20230403121527.2286489-1-apatel@ventanamicro.com/)

Changes since v3:
 - Split PATCH7 into two patches
 - Addressed comments in PATCH7, PATCH8 and PATCH9

Changes since v2:
 - Rebased on Linux-6.3-rc5
 - Split PATCH5 into two separate patches as suggested by Atish.

Changes since v1:
 - Addressed from Drew and Conor in PATCH1
 - Use alphabetical ordering for SMAIA and SSAIA enum in PATCH2
 - Use GENMASK() in PATCH3

Anup Patel (9):
  RISC-V: Add AIA related CSR defines
  RISC-V: Detect AIA CSRs from ISA string
  RISC-V: KVM: Drop the _MASK suffix from hgatp.VMID mask defines
  RISC-V: KVM: Initial skeletal support for AIA
  RISC-V: KVM: Implement subtype for CSR ONE_REG interface
  RISC-V: KVM: Add ONE_REG interface for AIA CSRs
  RISC-V: KVM: Use bitmap for irqs_pending and irqs_pending_mask
  RISC-V: KVM: Virtualize per-HART AIA CSRs
  RISC-V: KVM: Implement guest external interrupt line management

 arch/riscv/include/asm/csr.h      | 107 ++++-
 arch/riscv/include/asm/hwcap.h    |   8 +
 arch/riscv/include/asm/kvm_aia.h  | 137 +++++++
 arch/riscv/include/asm/kvm_host.h |  14 +-
 arch/riscv/include/uapi/asm/kvm.h |  18 +-
 arch/riscv/kernel/cpu.c           |   2 +
 arch/riscv/kernel/cpufeature.c    |   2 +
 arch/riscv/kvm/Makefile           |   1 +
 arch/riscv/kvm/aia.c              | 627 ++++++++++++++++++++++++++++++
 arch/riscv/kvm/main.c             |  23 +-
 arch/riscv/kvm/mmu.c              |   3 +-
 arch/riscv/kvm/vcpu.c             | 190 +++++++--
 arch/riscv/kvm/vcpu_insn.c        |   1 +
 arch/riscv/kvm/vm.c               |   4 +
 arch/riscv/kvm/vmid.c             |   4 +-
 15 files changed, 1083 insertions(+), 58 deletions(-)
 create mode 100644 arch/riscv/include/asm/kvm_aia.h
 create mode 100644 arch/riscv/kvm/aia.c

-- 
2.34.1

