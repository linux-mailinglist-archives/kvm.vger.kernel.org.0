Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A66FC6E7C54
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 16:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232775AbjDSOW3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 10:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232908AbjDSOW0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 10:22:26 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E496E85
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 07:22:22 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 41be03b00d2f7-51fcf5d1e44so1401680a12.3
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 07:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20221208.gappssmtp.com; s=20221208; t=1681914141; x=1684506141;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5AZVoE4cKl5QalUTwIQY3oWUmaoZBRuHIhA+cy8XC/s=;
        b=Uf44G7eShP45n3mvQsLaHp0FYljwSoqFn6ycGUo7jd19P0ovDq0zYsO0ygVV7IKtio
         62GMonB9A3vjZu1wyukptFhBL0UVngK7V1lKn91S6YHJ9GKWhxd2JJSCkJgX/wqWtIWq
         vdMtgwI9BniFnWkT/DM8X4F7S0AoBst+qlNVr7aMrthHGVnBzZ8mHmYnMX/BvLizCfaf
         Op6DDgLsT2wxXL+ei+EhK2jh9XRwQejhOSQ3f/JkW3Zr2x0MF7G9eAHbJ/+1yNMXNskk
         Sv/hclJBzlFlROh6qKbo40F7WQvNJ2OONsVjtIzOodYF+GmVl0Ubw7jvMEEarc5i+L2h
         Pq0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681914141; x=1684506141;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5AZVoE4cKl5QalUTwIQY3oWUmaoZBRuHIhA+cy8XC/s=;
        b=XTJbcWnF8zkU801YFncskmJFo5aqw+rTNzZ6Ux9HOQqfaq5wLJMuK61C4NSiLYNBfF
         O44T9Pq/9ExGcjidkjMcHkBQaczmMRAiTp4Z4nJfcwHzJ4IgbM7ZWiI9TVwFsI3kyeBD
         NRY9/YxR+z6DtnkhadSHNBrmLGrc6bwece7YbqvKyhGh0mQabu0ElwpvqMvJSeIZaC+Q
         bRmk6DnkpdN1tWU4ELK+PYEuMIof7iafltc42AOKAiAiSNUclRbU+UZZOT+ZqxGjBbtu
         VO2n/l4uIp4PHgbO5JOUioXmuT3591aUb21d8OcIkxmJ/hlwi196IizH6Ew4QSFvigTE
         k1xw==
X-Gm-Message-State: AAQBX9clOdpoF/7hN7IaAyAFuxzp0FnpDPLwcTxXxBrzr5mmjKFpOpu6
        GzdyLDu/Fzc/xXUF2xpVPRNMsw==
X-Google-Smtp-Source: AKy350ZTJwE2aWSzstOmJ0YW285PJ4i358w4phfkGLXLXpb0SQnSrIkea7QeQB4AECwuoTp9GpufSA==
X-Received: by 2002:a17:90a:f196:b0:236:73d5:82cf with SMTP id bv22-20020a17090af19600b0023673d582cfmr3147217pjb.9.1681914141039;
        Wed, 19 Apr 2023 07:22:21 -0700 (PDT)
Received: from localhost ([135.180.227.0])
        by smtp.gmail.com with ESMTPSA id x1-20020a1709029a4100b001a687c505e9sm11329933plv.237.2023.04.19.07.22.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 07:22:20 -0700 (PDT)
Date:   Wed, 19 Apr 2023 07:22:20 -0700 (PDT)
X-Google-Original-Date: Wed, 19 Apr 2023 07:22:13 PDT (-0700)
Subject:     Re: [PATCH v4 0/9] RISC-V KVM virtualize AIA CSRs
In-Reply-To: <20230404153452.2405681-1-apatel@ventanamicro.com>
CC:     pbonzini@redhat.com, atishp@atishpatra.org,
        Paul Walmsley <paul.walmsley@sifive.com>,
        ajones@ventanamicro.com, anup@brainfault.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, apatel@ventanamicro.com
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     apatel@ventanamicro.com
Message-ID: <mhng-72b96cbf-6edd-4b37-9549-200e2a3cb35d@palmer-ri-x1c9>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 04 Apr 2023 08:34:43 PDT (-0700), apatel@ventanamicro.com wrote:
> The RISC-V AIA specification is now frozen as-per the RISC-V international
> process. The latest frozen specifcation can be found at:
> https://github.com/riscv/riscv-aia/releases/download/1.0-RC3/riscv-interrupts-1.0-RC3.pdf
>
> This series implements first phase of AIA virtualization which targets
> virtualizing AIA CSRs. This also provides a foundation for the second
> phase of AIA virtualization which will target in-kernel AIA irqchip
> (including both IMSIC and APLIC).
>
> The first two patches are shared with the "Linux RISC-V AIA Support"
> series which adds AIA driver support.
>
> To test this series, use AIA drivers from the "Linux RISC-V AIA Support"
> series and use KVMTOOL from the riscv_aia_v1 branch at:
> https://github.com/avpatel/kvmtool.git
>
> These patches can also be found in the riscv_kvm_aia_csr_v4 branch at:
> https://github.com/avpatel/linux.git
>
> Based-on: 20230401112730.2105240-1-apatel@ventanamicro.com
> (https://lore.kernel.org/lkml/20230401112730.2105240-1-apatel@ventanamicro.com/)
>
> Based-on: 20230403121527.2286489-1-apatel@ventanamicro.com
> (https://lore.kernel.org/lkml/20230403121527.2286489-1-apatel@ventanamicro.com/)
>
> Changes since v3:
>  - Split PATCH7 into two patches
>  - Addressed comments in PATCH7, PATCH8 and PATCH9
>
> Changes since v2:
>  - Rebased on Linux-6.3-rc5
>  - Split PATCH5 into two separate patches as suggested by Atish.
>
> Changes since v1:
>  - Addressed from Drew and Conor in PATCH1
>  - Use alphabetical ordering for SMAIA and SSAIA enum in PATCH2
>  - Use GENMASK() in PATCH3
>
> Anup Patel (9):
>   RISC-V: Add AIA related CSR defines
>   RISC-V: Detect AIA CSRs from ISA string
>   RISC-V: KVM: Drop the _MASK suffix from hgatp.VMID mask defines
>   RISC-V: KVM: Initial skeletal support for AIA
>   RISC-V: KVM: Implement subtype for CSR ONE_REG interface
>   RISC-V: KVM: Add ONE_REG interface for AIA CSRs
>   RISC-V: KVM: Use bitmap for irqs_pending and irqs_pending_mask
>   RISC-V: KVM: Virtualize per-HART AIA CSRs
>   RISC-V: KVM: Implement guest external interrupt line management
>
>  arch/riscv/include/asm/csr.h      | 107 ++++-
>  arch/riscv/include/asm/hwcap.h    |   8 +
>  arch/riscv/include/asm/kvm_aia.h  | 137 +++++++
>  arch/riscv/include/asm/kvm_host.h |  14 +-
>  arch/riscv/include/uapi/asm/kvm.h |  18 +-
>  arch/riscv/kernel/cpu.c           |   2 +
>  arch/riscv/kernel/cpufeature.c    |   2 +
>  arch/riscv/kvm/Makefile           |   1 +
>  arch/riscv/kvm/aia.c              | 627 ++++++++++++++++++++++++++++++
>  arch/riscv/kvm/main.c             |  23 +-
>  arch/riscv/kvm/mmu.c              |   3 +-
>  arch/riscv/kvm/vcpu.c             | 190 +++++++--
>  arch/riscv/kvm/vcpu_insn.c        |   1 +
>  arch/riscv/kvm/vm.c               |   4 +
>  arch/riscv/kvm/vmid.c             |   4 +-
>  15 files changed, 1083 insertions(+), 58 deletions(-)
>  create mode 100644 arch/riscv/include/asm/kvm_aia.h
>  create mode 100644 arch/riscv/kvm/aia.c

Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
