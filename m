Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 222786FD99E
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 10:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236726AbjEJIjY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 04:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236591AbjEJIjE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 04:39:04 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB0A7AA5
        for <kvm@vger.kernel.org>; Wed, 10 May 2023 01:38:02 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id 46e09a7af769-6ab032b33cdso3090419a34.0
        for <kvm@vger.kernel.org>; Wed, 10 May 2023 01:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1683707881; x=1686299881;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=komBnaKizhJMv9OVU8U7Vmtw0gZsjxgLIP8S/qwvUCM=;
        b=TyV2o27o9veCOIaROjzCm+jthPBJbDDjyLzWnSwqbxPPdjMfys08N+6/USVsM0riVc
         KRtmlcLNeXKz50Ef2O9CNlAGK73LaAW/02aEs7/PMFnBsZtuuILQioOI3VdUli/k7rrc
         QlioY7z9SA5LkIHqt7uMW7xVOokXDk+RrUi+0xJXI06NOi65XLS5ci6elYGa5z+eE/Iq
         6PjA/2wpJ/UQ3hau0X9X6y48pTEidGwrwHt50NQOh7GOGIxLWFVxo9xvzyVX3NBVpExP
         /xZwkiL3JxW0vtlgVjG+raLfTyYKSn5InyUkD/2b33xUdc9EYnzaHJzPG73y+2vUEfAs
         pWpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683707881; x=1686299881;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=komBnaKizhJMv9OVU8U7Vmtw0gZsjxgLIP8S/qwvUCM=;
        b=eOub2whfqHJ2wSCkv9SbFtnIbezFvKWyzPq5ssG5+VgnokFhAkaXmIrLZ60tAhfQ0X
         KjeTQrvRugHSU4OQA6TklI1ArqBdXKEWK/fwJwKQg0InfPUGrHciFUOPluu2ywT5UpRA
         pX4DbdHDPYbHGnOz7Xg3SWtfP2qq4nMAxEmPm1uzgGBFgY6bVtD/NXkBBpQOp27ViJzr
         cMCaH1x7t+tnrCFrvUh3WzHaeIS/max39oQPbLTeZY9KVZTT17NkpIfDAC5YoHdcs0m3
         SviSH4IyZbR7/28Chtnw/fjtdL1yW4Qmvr6xuQlN/jPg8diCTHRghEVkm5Pjh3fd0yh2
         xzPQ==
X-Gm-Message-State: AC+VfDw5n7pBenvntOwrqOcn3t9V7OmtWTTAVFWgfZhYWoVSiiXGW3+g
        iT+/6zP1Ghop2PGOKsEANfbtVv0gFpVEBE6AQ8w=
X-Google-Smtp-Source: ACHHUZ5aR0uosAohTV6db0oXDfJJoiL5nRKeo0SFn7hEsHs23lQdlSf9sWi0Mhu/uH5KwhsbYgeVsQ==
X-Received: by 2002:a9d:764d:0:b0:6a6:4053:2089 with SMTP id o13-20020a9d764d000000b006a640532089mr2244056otl.14.1683707881633;
        Wed, 10 May 2023 01:38:01 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id n12-20020a9d64cc000000b006a65be836acsm6049711otl.16.2023.05.10.01.37.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 01:38:01 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH kvmtool 0/8] RISC-V SBI enable/disable, Zbb, Zicboz, and Ssaia support
Date:   Wed, 10 May 2023 14:07:40 +0530
Message-Id: <20230510083748.1056704-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
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

The latest KVM in Linux-6.4-rc1 has support for:
1) Enabling/disabling SBI extensions from KVM user-space
2) Zbb ISA extension support
3) Zicboz ISA extension support
4) Ssaia ISA extension support

This series adds corresponding changes in KVMTOOL to use the above
mentioned features for Guest/VM.

These patches can also be found in the riscv_sbi_zbb_zicboz_ssaia_v1
branch at: https://github.com/avpatel/kvmtool.git

Andrew Jones (1):
  riscv: Add Zicboz extension support

Anup Patel (7):
  Sync-up headers with Linux-6.4-rc1
  riscv: Allow setting custom mvendorid, marchid, and mimpid
  riscv: Allow disabling SBI extensions for Guest
  riscv: Sort the ISA extension array alphabetically
  riscv: Add zbb extension support
  riscv: Add Ssaia extension support
  riscv: Fix guest RAM alloc size computation for RV32

 arm/aarch64/include/asm/kvm.h       |  38 ++++++++++
 include/linux/kvm.h                 |  57 +++++++++------
 include/linux/virtio_blk.h          | 105 ++++++++++++++++++++++++++++
 include/linux/virtio_config.h       |   6 ++
 include/linux/virtio_net.h          |   5 ++
 riscv/fdt.c                         |  19 ++++-
 riscv/include/asm/kvm.h             |  56 ++++++++++++++-
 riscv/include/kvm/kvm-config-arch.h |  51 +++++++++++++-
 riscv/include/kvm/kvm-cpu-arch.h    |  19 +++--
 riscv/kvm-cpu.c                     |  45 +++++++++++-
 riscv/kvm.c                         |  15 +++-
 x86/include/asm/kvm.h               |  50 ++++++++++---
 12 files changed, 419 insertions(+), 47 deletions(-)

-- 
2.34.1

