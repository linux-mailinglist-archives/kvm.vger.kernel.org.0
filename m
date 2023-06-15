Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC2F7310D3
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 09:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244744AbjFOHfN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 03:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244999AbjFOHem (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 03:34:42 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C3D3294B
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 00:34:04 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 41be03b00d2f7-51b4ef5378bso5314585a12.1
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 00:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1686814443; x=1689406443;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uSVZgRG5YqM/eFQOFzsv+7qQx2kR6U7K/exhbfh3iHo=;
        b=ZU5NKMa7G4ct8b3MBmjVWKrm9NhEKEL5tmHTacR2un8854Mv7M7pqhvPirLhVQlLKD
         yQJrWHCAeRXcVIuM2TcU0o7A0ieXOuLIj9mPpX0XJAvWzt397TT8XVjBsBEjPQmCjUHi
         G6wwzmRmXhg8W1M7ODggv7uVUuVaMsRhPBVt+shONlAZyFq4rVmMix++00q5mtjr/wK2
         rrsXFvjGIQZE5quFdViRsx8SRkNIb+eSdgUXVFzVNdJCEMBKlmIk39JaFHbnNrob+DWs
         TFLKaYjlcY2JbZxX3Ipx9OGlOT9J2DwPNPx4qP3MiX8qUURz0qzLsH3ZwbpHr1OFD3Gx
         2eVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686814443; x=1689406443;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uSVZgRG5YqM/eFQOFzsv+7qQx2kR6U7K/exhbfh3iHo=;
        b=dcT7kIRfWs/CzN7PvJDM/6Oqef4Ys+UgX6nFrbjblJu2GyGRMRoCWc5Ghn51Y+qWmw
         hSWThbfL6EaaK1C6Gm44kOFW7rPVPZ82tx9F1xnvpzHDdnISUkGz3lcWHQ2L0dYNp0Ai
         IKsxRAfQa+LskxRKXVnxeTLg+yjjILjHNg6Vn8FuOwyaMOTclbQfo84VRWM1kTHyDVPS
         Qh0DBOSDYv3PtZABV4GogcSiMYEev+3hN/op0TUPjHe4jteJ8LEf+r37kCZ/+d+sifg7
         00Quh1rSmQ7DDI/h1+rrDE+gLWBKOiCZc9oHyMLTdKGNF0vL1pd+wy1jCdpneioxgZAo
         Y3PA==
X-Gm-Message-State: AC+VfDzx7SMWtGQRv29e4/CrjlhOiwVtTiCsBwsjU3pAO9sH1cTiP+AL
        wCgbmrm+nxtLvVpMpZ+n/KrdXg==
X-Google-Smtp-Source: ACHHUZ6bJonZw603lvIGfQwVjskavYnCDRr4u1S4D2EB7M7IA9w4wtMrIHM/wnYPsW3vFEEdT710hg==
X-Received: by 2002:a05:6a21:329a:b0:10b:cdb1:3563 with SMTP id yt26-20020a056a21329a00b0010bcdb13563mr4810645pzb.46.1686814442720;
        Thu, 15 Jun 2023 00:34:02 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([106.51.83.242])
        by smtp.gmail.com with ESMTPSA id ji1-20020a170903324100b001b016313b1dsm8049855plb.86.2023.06.15.00.33.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 00:34:02 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH v3 00/10] RISC-V KVM in-kernel AIA irqchip
Date:   Thu, 15 Jun 2023 13:03:43 +0530
Message-Id: <20230615073353.85435-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds in-kernel AIA irqchip to KVM RISC-V which trap-n-emulate
IMSIC and APLIC MSI-mode for Guest. The APLIC MSI-mode trap-n-emulate is
optional so KVM user space can emulate APLIC entirely in user space.

The use of IMSIC HW guest files to accelerate IMSIC virtualization will be
done as separate series since this depends on AIA irqchip drivers to be
upstreamed. This series has no dependency on the AIA irqchip drivers.

There is also a KVM AIA irq-bypass (or device MSI virtualization) series
under development which depends on this series and upcoming IOMMU driver
series.

These patches (or this series) can also be found in the
riscv_kvm_aia_irqchip_v3 branch at: https://github.com/avpatel/linux.git

Changes since v2:
 - Added KVM_CAP_IRQCHIP in PATCH5
 - Fix check for KVM_DEV_RISCV_AIA_CONFIG_IDS write in PATCH6
 - Fix APLIC_IRQ_STATE_ENPEND usage in PATCH7

Changes since v1:
 - Rebased on Linux-6.4-rc6
 - Addressed Atish's comment in PATCH6
 - Added comments in arch/riscv/include/uapi/asm/kvm.h about APLIC and
   IMSIC device attribute type

Anup Patel (10):
  RISC-V: KVM: Implement guest external interrupt line management
  RISC-V: KVM: Add IMSIC related defines
  RISC-V: KVM: Add APLIC related defines
  RISC-V: KVM: Set kvm_riscv_aia_nr_hgei to zero
  RISC-V: KVM: Skeletal in-kernel AIA irqchip support
  RISC-V: KVM: Implement device interface for AIA irqchip
  RISC-V: KVM: Add in-kernel emulation of AIA APLIC
  RISC-V: KVM: Expose APLIC registers as attributes of AIA irqchip
  RISC-V: KVM: Add in-kernel virtualization of AIA IMSIC
  RISC-V: KVM: Expose IMSIC registers as attributes of AIA irqchip

 arch/riscv/include/asm/kvm_aia.h       |  107 ++-
 arch/riscv/include/asm/kvm_aia_aplic.h |   58 ++
 arch/riscv/include/asm/kvm_aia_imsic.h |   38 +
 arch/riscv/include/asm/kvm_host.h      |    4 +
 arch/riscv/include/uapi/asm/kvm.h      |   72 ++
 arch/riscv/kvm/Kconfig                 |    4 +
 arch/riscv/kvm/Makefile                |    3 +
 arch/riscv/kvm/aia.c                   |  274 +++++-
 arch/riscv/kvm/aia_aplic.c             |  619 ++++++++++++++
 arch/riscv/kvm/aia_device.c            |  673 +++++++++++++++
 arch/riscv/kvm/aia_imsic.c             | 1083 ++++++++++++++++++++++++
 arch/riscv/kvm/main.c                  |    3 +-
 arch/riscv/kvm/vcpu.c                  |    2 +
 arch/riscv/kvm/vm.c                    |  118 +++
 include/uapi/linux/kvm.h               |    2 +
 15 files changed, 3027 insertions(+), 33 deletions(-)
 create mode 100644 arch/riscv/include/asm/kvm_aia_aplic.h
 create mode 100644 arch/riscv/include/asm/kvm_aia_imsic.h
 create mode 100644 arch/riscv/kvm/aia_aplic.c
 create mode 100644 arch/riscv/kvm/aia_device.c
 create mode 100644 arch/riscv/kvm/aia_imsic.c

-- 
2.34.1

