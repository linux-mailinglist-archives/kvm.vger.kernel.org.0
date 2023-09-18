Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8790A7A4A4F
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 14:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242012AbjIRM6j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 08:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242000AbjIRM6L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 08:58:11 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00927109
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 05:57:40 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 41be03b00d2f7-5780001d312so3249595a12.0
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 05:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1695041860; x=1695646660; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1Beljry/IwhQwBQeT7aWsgo1E5496cfRJbJFPTGnyPI=;
        b=RX/0hS9WaVdRuIMWKuTujqE2knailNb79AiQ7VbxZTfWAtxouC/nONB1cqBfjlDC6x
         Sp667877yJMURR/bv94Xh+EEXoGHQDgoMGMuwjfNwzDObENOTZp/M8ytQA4fME9D2ynd
         00C1nW1oanXIKlKLl30bL9ioQ2mxJAnI802ZQ/lelyXDVJQQyerjCWQrQ2EL9n0tqBRH
         Cmv2pYT4EQtb3kPVw6ctv2oG+q8wg2fViv4wt46SrAxPw8SpLYYHl4JFCAuyGGhGY/CE
         ZFzVTqA6+jV7oabqeoTi/N24O/FoxxFx3mUmf8dms0U+Uf4TZNrkvoA9WrxRojmw3zQO
         iG2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695041860; x=1695646660;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1Beljry/IwhQwBQeT7aWsgo1E5496cfRJbJFPTGnyPI=;
        b=lA4Tf4B88wqKDgi4bQwR0y6PakoN9rSMvwXuvsYvYkcPr80aLvmjeOtj5951a6oO0s
         BtJBhqylw1REgKDmjbWTPBppo78qkI/Dw7/G/PHO42tMzO5vSPL1OBQxyNtwvfh9sRXJ
         gGiOH2Z3U7FllhsB8ivlG/u4ivkh9/tTSWqkbcaZ7W0qzpZbWMhyConhDaWPGBudp0+S
         UlhbWkE+v38t6NkG30unZV4xrA/5nJj1eOoRVUhwWiAJY43XlbezfPMt11X+JGd6rubG
         dtfKrw/hmXRHGTiL6x2Mnu1nOF77Pp2rBeSUqjjvWWlvEwPhZVWz6c4Zxc/ytj0qwYg/
         84Tg==
X-Gm-Message-State: AOJu0YxgRzI0uCvM0MiO25tRcv07ETG+lC88jCtNFRX1Pjh5a3Yh+KFp
        LDNd5a/jhZ+FAMTV4emdkPDgFg==
X-Google-Smtp-Source: AGHT+IHwugPjVxcqkVE6Uu9Ymn1P0IdCnD196rikPb2cP83RCsP6YcD7QTUipawah18llIRDaQa2kQ==
X-Received: by 2002:a17:90a:43c5:b0:269:85d:2aef with SMTP id r63-20020a17090a43c500b00269085d2aefmr7912810pjg.20.1695041859992;
        Mon, 18 Sep 2023 05:57:39 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id n14-20020a17090ac68e00b002680b2d2ab6sm8890237pjt.19.2023.09.18.05.57.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 05:57:39 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH v2 0/6] RISC-V AIA irqchip and Svnapot support
Date:   Mon, 18 Sep 2023 18:27:24 +0530
Message-Id: <20230918125730.1371985-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The latest KVM in Linux-6.5 has support for:
1) Svnapot ISA extension support
2) AIA in-kernel irqchip support

This series adds corresponding changes in KVMTOOL to use the above
mentioned features for Guest/VM.

These patches can also be found in the riscv_aia_v2 branch at:
https://github.com/avpatel/kvmtool.git

Changes since v1:
 - Rebased on commit 9cb1b46cb765972326a46bdba867d441a842af56
 - Updated PATCH1 to sync header with released Linux-6.5

Anup Patel (6):
  Sync-up header with Linux-6.5 for KVM RISC-V
  riscv: Add Svnapot extension support
  riscv: Make irqchip support pluggable
  riscv: Add IRQFD support for in-kernel AIA irqchip
  riscv: Use AIA in-kernel irqchip whenever KVM RISC-V supports
  riscv: Fix guest/init linkage for multilib toolchain

 Makefile                            |   3 +
 include/linux/kvm.h                 |   6 +-
 riscv/aia.c                         | 227 ++++++++++++++++++++++++++++
 riscv/fdt.c                         |  15 +-
 riscv/include/asm/kvm.h             |  81 ++++++++++
 riscv/include/kvm/fdt-arch.h        |   8 +-
 riscv/include/kvm/kvm-arch.h        |  38 ++++-
 riscv/include/kvm/kvm-config-arch.h |   3 +
 riscv/irq.c                         | 138 ++++++++++++++++-
 riscv/kvm.c                         |   2 +
 riscv/pci.c                         |  32 ++--
 riscv/plic.c                        |  61 ++++----
 12 files changed, 563 insertions(+), 51 deletions(-)
 create mode 100644 riscv/aia.c

-- 
2.34.1

