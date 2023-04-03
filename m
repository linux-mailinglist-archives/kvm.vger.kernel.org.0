Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7056D40A5
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 11:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232090AbjDCJdk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 05:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232098AbjDCJdc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 05:33:32 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E54A96A41
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 02:33:27 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id ca2-20020a056830610200b006a11ab58c3fso14600095otb.4
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 02:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1680514404; x=1683106404;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DZznhaLgkR5BAQNz1oF8xOUpsQ8iqxB7L0RTGOfw/xU=;
        b=UbT8vAYvDN6OqpJ+R+oA5J2u0aFC3YpjFuymekDS1vJOIssNIUqJ/Pr3rv0yghLjmE
         nIxx6L1TUeuDgIDJ019Jf0UeIZ58zJdh6Y2grtRYP1XtOThcq/pq/rx9rxRNbPw5qF1V
         4nuDEeWZz/UVV7pTd1am8hEkRAUheoHcXvbHlNyStdimjkD1sooaunPwp7euGstILn3n
         +mY3ZBa5sLKAA5EGL8LopqgiC1TeAMnE+6/66rwt9TGtsPu1M3P9ot92vCMhj5h7q6sw
         mpmfQYgdfVIH9aSIKIjwU0fOBTTMTg4ynSFui75ag+jt6eXYFd+bKHPVU1SdwYvfwI76
         gcCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680514404; x=1683106404;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DZznhaLgkR5BAQNz1oF8xOUpsQ8iqxB7L0RTGOfw/xU=;
        b=UGLtQkAweFWZQH2VQ075cowqWLGocN/DKUWNbGmPwh1CGhp9v5lxoZk3m97gwdLjMe
         ix9yzBlW0NG5lR9OGF//iCrdBy/OmMIzZyQ8VUv1J2v6amI6m9Cccd/eV5IPcp2+KED9
         COxc2z/ePl93E5/qRH5aOO3BXh6dHnYyCSeBxjX1BuoqW8SlpcLZxjieIHAq+ta9GRr/
         cYnyboxovFSpPfAHkPW3I8xbD9+/fILZ4dHxpM+Bk4vkGkBjKkq1PzCzPtU54yBRH2GM
         jXedDWb4kHASnYQuuL/EropE38pPZrN8vAUIKV90b17mM7wSAZAI+HFElOQO5RspsyZD
         aWag==
X-Gm-Message-State: AAQBX9dBGQRG9eB7dWDS19h6v9PrqNNLLnRXeUfYUK85zEjH9WNpc/L4
        11EbDCrzWPHNE3Ob/Qb9LC7pqw==
X-Google-Smtp-Source: AKy350aA5Ixs2WBzjri+SklllWtPpSloyccBIm2AHc49ql1/dCwqDARVWDxRF+zMDpQSH0NUaUW7RQ==
X-Received: by 2002:a9d:668:0:b0:6a3:7e52:c3ae with SMTP id 95-20020a9d0668000000b006a37e52c3aemr434930otn.13.1680514404560;
        Mon, 03 Apr 2023 02:33:24 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id f5-20020a9d6c05000000b006a154373578sm3953953otq.39.2023.04.03.02.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 02:33:24 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH v3 0/8] RISC-V KVM virtualize AIA CSRs
Date:   Mon,  3 Apr 2023 15:03:02 +0530
Message-Id: <20230403093310.2271142-1-apatel@ventanamicro.com>
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

These patches can also be found in the riscv_kvm_aia_csr_v3 branch at:
https://github.com/avpatel/linux.git

Changes since v2:
 - Rebased on Linux-6.3-rc5
 - Split PATCH5 into two separate patches as suggested by Atish.

Changes since v1:
 - Addressed from Drew and Conor in PATCH1
 - Use alphabetical ordering for SMAIA and SSAIA enum in PATCH2
 - Use GENMASK() in PATCH3

Anup Patel (8):
  RISC-V: Add AIA related CSR defines
  RISC-V: Detect AIA CSRs from ISA string
  RISC-V: KVM: Drop the _MASK suffix from hgatp.VMID mask defines
  RISC-V: KVM: Initial skeletal support for AIA
  RISC-V: KVM: Implement subtype for CSR ONE_REG interface
  RISC-V: KVM: Add ONE_REG interface for AIA CSRs
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
 arch/riscv/kvm/aia.c              | 624 ++++++++++++++++++++++++++++++
 arch/riscv/kvm/main.c             |  23 +-
 arch/riscv/kvm/mmu.c              |   3 +-
 arch/riscv/kvm/vcpu.c             | 185 +++++++--
 arch/riscv/kvm/vcpu_insn.c        |   1 +
 arch/riscv/kvm/vm.c               |   4 +
 arch/riscv/kvm/vmid.c             |   4 +-
 15 files changed, 1077 insertions(+), 56 deletions(-)
 create mode 100644 arch/riscv/include/asm/kvm_aia.h
 create mode 100644 arch/riscv/kvm/aia.c

-- 
2.34.1

