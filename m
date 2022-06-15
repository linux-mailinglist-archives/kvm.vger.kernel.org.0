Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 632C254C65B
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 12:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345940AbiFOKks (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 06:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238993AbiFOKkr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 06:40:47 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC5C506FD
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 03:40:47 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id f8so10046736plo.9
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 03:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7AW1W09LSbc0AKeBzhbbJRYawCgr5kPp9j0he58N2L0=;
        b=P1wNqgu+aTWdnGrFY3sOgB9OzXAQGI2zy4bwVExY9eRylwBxDd/kr8+hiqtNXdyvsE
         CL13R/NI5b0vtsBPy49ewUIhf5ahjDEO7xhhnIspj5rIiTqX2cbqw+KjsEV0J/Q1KUEZ
         u2cbeE4nNEHGH/M/MNVLa9rgW+uhr4nu6Qbcbp6metOVqSW/08QOAwH0iS3S9CBbgI0O
         ARWCiJDCmvnijdD35ok5B9pZtUHo+D0ak703gpJdniBDaJt03yHgQasxgQfhl97y6ELY
         PXVQIlTbrxin/EwJk7po/Gpya3kFE51rZO5rvAusdqQgQ9ciGh+rYsNYxc72w9yWV8le
         L+OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7AW1W09LSbc0AKeBzhbbJRYawCgr5kPp9j0he58N2L0=;
        b=5daFNONkkh4W0bWYUmC1euQCbZAiRRbNuqLxfJtiLg2im7zKHz7Cwu7DdbkkT7Efd+
         GbiQoZjpA73rUEFiOYW/CD6GDJDstBQyVd8DtQJ22PH8BJyYfV71/du0VKWfDhUX2JcW
         VEL4aGxR3l/GSPdZe/2RNWIHlRElh7w4JW7IUz+UaEU+dazkmYyyBADOd8MDHt2g9ZIX
         K+4MLX68m2mTw+2QYuoeYokwgyUeT0fFUIhPMRjCUNYYL5UNM3Am0GgfQpGGMnktkPGk
         EHUP1E2IGYnruxTxkkTmA8SXPGxXbadbBaujXHGnVJP502pweayP1w9LkrDph4oljHIZ
         meaw==
X-Gm-Message-State: AJIora/dkyYPTJKfgXAKPKjvQwGj/TLasOASK0t+wzL8OO+U0BbDSCMN
        S4tJDK0OdYmOfWrKywNotmsMog==
X-Google-Smtp-Source: AGRyM1vyMoS8OEQqhgBrKgCKa5j36/nBcdYxDHmc5RV/6JecYTKtu4JVmOBla7MYDyJ0GnJ4MMdZHw==
X-Received: by 2002:a17:902:c40d:b0:164:1a71:f7c0 with SMTP id k13-20020a170902c40d00b001641a71f7c0mr8626759plk.90.1655289646565;
        Wed, 15 Jun 2022 03:40:46 -0700 (PDT)
Received: from anup-ubuntu64-vm.. ([171.76.104.191])
        by smtp.gmail.com with ESMTPSA id i19-20020a056a00225300b00522c365225csm1427273pfu.3.2022.06.15.03.40.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 03:40:45 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH v2 0/3] Improve instruction and CSR emulation in KVM RISC-V
Date:   Wed, 15 Jun 2022 16:10:22 +0530
Message-Id: <20220615104025.941382-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
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

Currently, the instruction emulation for MMIO traps and Virtual instruction
traps co-exist with general VCPU exit handling. The instruction and CSR
emulation will grow with upcoming SBI PMU, AIA, and Nested virtualization
in KVM RISC-V. In addition, we also need a mechanism to allow user-space
emulate certain CSRs under certain situation (example, host has AIA support
but user-space does not wants to use in-kernel AIA IMSIC and APLIC support).

This series improves instruction and CSR emulation in KVM RISC-V to make
it extensible based on above.

These patches can also be found in riscv_kvm_csr_v2 branch at:
https://github.com/avpatel/linux.git

Changes since v1:
 - Added a switch-case in PATCH3 to process MMIO, CSR, and SBI returned
   from user-space
 - Removed hard-coding in PATCH3 for determining type of CSR instruction

Anup Patel (3):
  RISC-V: KVM: Factor-out instruction emulation into separate sources
  RISC-V: KVM: Add extensible system instruction emulation framework
  RISC-V: KVM: Add extensible CSR emulation framework

 arch/riscv/include/asm/kvm_host.h           |  16 +-
 arch/riscv/include/asm/kvm_vcpu_insn.h      |  48 ++
 arch/riscv/kvm/Makefile                     |   1 +
 arch/riscv/kvm/vcpu.c                       |  34 +-
 arch/riscv/kvm/vcpu_exit.c                  | 490 +----------------
 arch/riscv/kvm/{vcpu_exit.c => vcpu_insn.c} | 563 +++++++++++---------
 include/uapi/linux/kvm.h                    |   8 +
 7 files changed, 392 insertions(+), 768 deletions(-)
 create mode 100644 arch/riscv/include/asm/kvm_vcpu_insn.h
 copy arch/riscv/kvm/{vcpu_exit.c => vcpu_insn.c} (63%)

-- 
2.34.1

