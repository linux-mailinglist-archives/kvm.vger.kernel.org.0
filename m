Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 156A46E84DC
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 00:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233691AbjDSW1G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 18:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233700AbjDSW0r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 18:26:47 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF1865FFD
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:25:20 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1a6762fd23cso4520465ad.3
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1681943042; x=1684535042;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9TyRM4nmtqohXFcwttydo/M979fjFpXSQwmt1QhEq7M=;
        b=o6BPf3mJiKmzHDTQduMjlUPZ224ynCQVPjqAxFiYl/xtjQhTUbKlM14FTeWvmNMg/L
         l0DrouIryk3u/EqI3byzcjbrgz+G8kwOXpTd0QZK3d3sEG9AOlbIPNTOq+DH6PD+Epo3
         zKe9QwsowdLs42oiVJKkIvYtT/MItZZgmSKR5C8Ea2x67PbxuR6leIH+i/b17jseR8bM
         VBwwA8Z195NKwe50pkO3mLwwTJ4OtkL6UCepduj0leLb4C5T7elpUTzmBMMBASJjF094
         bjxf9OSnAjUqLeAmsOa6EGQ0N3vUcmm6xctjwRZKzfkPZSzkZvKP3toboLwrlJYiGk9k
         5odA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681943042; x=1684535042;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9TyRM4nmtqohXFcwttydo/M979fjFpXSQwmt1QhEq7M=;
        b=Ya7qjZi1hBQQhLybKQLl50qYxqniKHRvQhwjM2GWF2ZwQ7FvSt1hygTn/gaMlvJBJF
         k2Y1iwyl85sND7XqZZu4WHWa4fwVvluuFRkfD05cUo65tNql7H2dcMtfqDYoBFNlnWjh
         utxGNByuzqBbJ1XCJIpZkW1FHZ5QoZY1Qg67YE4BS5570fxPkzQg8MGYWsvTyHd9vWCt
         StBSKGJWScXO6rM2gZKGQY7VjNvBvE4dHzul3GzA8LUtIf0IG7SCjXXS1lCT0OYaJeJT
         Qlxpn/G8q30Li5RA1NnU13ZtiLH1HJAgAb1Uqgr4l/UmDFWmcUEC4w12Vg/lMiBXoySP
         xhSg==
X-Gm-Message-State: AAQBX9eyx5sNy7hAKp1O0nzFiZGLs1cKCjGt1hMqVDs4OESEdUfiXqFK
        wqUrhQ7gnrjgfHUdCcqxnbWz/Q==
X-Google-Smtp-Source: AKy350Zx1dYLas0QCJpvJzHJgHFaFLbK94X4eX2SqTOZj0B0MjJMPmSVHt7a/giQTdAZWOuX7bdQng==
X-Received: by 2002:a17:902:7244:b0:1a2:37fc:b5e2 with SMTP id c4-20020a170902724400b001a237fcb5e2mr5966265pll.7.1681943042538;
        Wed, 19 Apr 2023 15:24:02 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id e4-20020a170902744400b001a681fb3e77sm11867810plt.44.2023.04.19.15.24.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:24:02 -0700 (PDT)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>, Alexandre Ghiti <alex@ghiti.fr>,
        Andrew Jones <ajones@ventanamicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        linux-coco@lists.linux.dev, Dylan Reid <dylan@rivosinc.com>,
        abrestic@rivosinc.com, Samuel Ortiz <sameo@rivosinc.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-riscv@lists.infradead.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Rajnesh Kanwal <rkanwal@rivosinc.com>,
        Uladzislau Rezki <urezki@gmail.com>
Subject: [RFC kvmtool 00/10] RISC-V CoVE support
Date:   Wed, 19 Apr 2023 15:23:40 -0700
Message-Id: <20230419222350.3604274-1-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series is an initial version of the support for running confidential VMs on
riscv architecture. This is to get feedback on the proposed COVH, COVI and COVG
extensions for running Confidential VMs on riscv. The specification is available
here [0]. Make sure to build it to get the latest changes as it gets updated
from time to time.

We have added a new option, `--cove-vm` to the `run` command to mark the VM as
a confidential VM.

The host including the kernel and kvmtool, must not access any memory allocated
to the confidential VM. The TSM is responsible for providing all the required
information to handle faults and emulate devices.

The series adds support to manage CoVE VMs, which includes:
   * Configuration
   * Creation of CoVE VM and VCPUs.
   * Load initial memory images using measurement ioctls.
   * Virtio support for CoVE VMs.

We don't yet support APLIC and thus no line based interrupts. So we use pci
transport for all the virtio devices. As serial and rtc devices are only mmio
based so we don't yet support those as well.

virtio for the CoVE enforces VIRTIO_F_ACCESS_PLATFORM flag to force SWIOTLB
bounce buffers in confidential linux guest. The SWIOTLB buffers are shared
with the host using share/unshare calls in COVG extension. Thus host can
directly write to those buffers without TSM involvement.

This series depends on few RISC-V series which are not yet upstream.

* AIA support[1]
* SBI DBCN extension[2] 

It also reuses the arch specific virtio host flag hook from CCA series[4].

The patches are also available here:

	https://github.com/rivosinc/kvmtool/commits/cove-integration-03072023

The corresponding linux patches are also available here:
https://github.com/rivosinc/linux/tree/cove-integration

Running a CoVE VM
------------------

Extra options needed:
--cove-vm: Launches a confidential VM.
--virtio-transport: We don't yet support MMIO devices so we need to
                    force virtio device to use pci transport.


 $ lkvm run						\
	 --cove-vm					\
	 --virtio-transport=pci                         \
	 <normal-VM options>

The details instructions can be found at [5]

Links
============
[0] CoVE architecture Specification.
    https://github.com/riscv-non-isa/riscv-ap-tee/blob/main/specification/riscv-aptee-spec.pdf
[1] https://github.com/avpatel/kvmtool/tree/riscv_aia_v1
[2] https://github.com/avpatel/kvmtool/tree/riscv_sbi_dbcn_v1
[4] https://lore.kernel.org/lkml/20230127113932.166089-28-suzuki.poulose@arm.com/
[5] https://github.com/rivosinc/cove/wiki/CoVE-KVM-RISCV64-on-QEMU

Atish Patra (7):
riscv: Add a CoVE VM type.
riscv: Define a command line option for CoVE VM
riscv: Define a measure region IOCTL
riscv: Invoke measure region for VM images
riscv: Do not create APLIC for TVMs
riscv: Change initrd alignment to a page size
riscv: Define riscv specific vm_type function

Rajnesh Kanwal (3):
riscv: virtio: Enforce VIRTIO_F_ACCESS_PLATFORM feature flag.
riscv: Don't emit MMIO devices for CoVE VM.
riscv: cove: Don't emit interrupt_map for pci devices in fdt.

include/linux/kvm.h                 |  4 ++
riscv/aia.c                         | 31 +++++++----
riscv/fdt.c                         | 38 +++++++------
riscv/include/asm/kvm.h             |  6 +++
riscv/include/kvm/kvm-arch.h        |  4 +-
riscv/include/kvm/kvm-config-arch.h |  4 +-
riscv/kvm.c                         | 51 +++++++++++++++++-
riscv/pci.c                         | 83 +++++++++++++++--------------
8 files changed, 152 insertions(+), 69 deletions(-)

--
2.25.1

