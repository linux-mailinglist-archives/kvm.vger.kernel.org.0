Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61F2B6F80A4
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 12:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbjEEKP0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 06:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbjEEKPZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 06:15:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF8D21A1D2
        for <kvm@vger.kernel.org>; Fri,  5 May 2023 03:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683281675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TPVIM24PKk5g37ZHgBt57G9GRMgxgcEe7F5iaLYcDqI=;
        b=hU73yW+dZZ3NiBHtB8uTJgYRJ1tRmte3LGSeWpkdmAciHGr/yWOd7Qa78fXXsyxAHcMO0T
        lmwljEDOm8EaBJFqZhXvrWTR/F4weB1vEucsQ7tzMadMuYi2G1dX+NsieZR/E5rBL24V3A
        Qhv8i7u4+cavnJS6Kndj4DfBBqUl1cc=
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com
 [209.85.217.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-132-ZorrN6rKOne_1YikV9s48Q-1; Fri, 05 May 2023 06:14:33 -0400
X-MC-Unique: ZorrN6rKOne_1YikV9s48Q-1
Received: by mail-vs1-f72.google.com with SMTP id ada2fe7eead31-4346c6cac99so1073852137.3
        for <kvm@vger.kernel.org>; Fri, 05 May 2023 03:14:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683281673; x=1685873673;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TPVIM24PKk5g37ZHgBt57G9GRMgxgcEe7F5iaLYcDqI=;
        b=aEleRwHfQdTaSSaRpYCKGTK/6S0tYRl+NXqnlYiteEOEFg230F0t0ZWqvE+zw3hp0x
         6SCt8Quu05vhW/LdNlQqqsln7Wk0+PBKNkFXYctKB7G/6pynyh8KY8AshiFfb3AYH9xn
         i+OihFZ/mGz+XWq6657u5byeFEPr3LGbw5G2VBapXIh+iixW2LxQjPko/yWNPEFFRPur
         t/FlILf4skk5AI2vF1WssNJeOPM9gUTcDfzmPeCKifkNIJesKyoLZ6/CKoHUg9VDX/Ci
         zcSlprEdE8f3RRaGRCyDpMRBw9kyNAzFC9GYTha9YPYVqpm9qmNhhlmRG9uftrO2qNB8
         IK6A==
X-Gm-Message-State: AC+VfDzV0//eH3ieqSR72jFhGYkA4J7n92H8s0HViWR9k3sfCZ1tIMQ/
        iNuY9y/A5uTIOU/L+uDFsH1Zo5pDyRKXoeFNUeMX7fKRX6zeb5nYw5qt27oSAcvTQzlFIY5pUBm
        A69b5Mf8liKwtCQpcIevep7Xm03Tl
X-Received: by 2002:a67:ed8b:0:b0:42f:fca5:981e with SMTP id d11-20020a67ed8b000000b0042ffca5981emr292996vsp.2.1683281673337;
        Fri, 05 May 2023 03:14:33 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7kgYekDc5jvZq85aeZ+Rv0kw0bccU6lCf3wGCZ87x22sGLYSiEwuOcajU5MZTaLvD93DtKk/3CTlGt+nLMHz4=
X-Received: by 2002:a67:ed8b:0:b0:42f:fca5:981e with SMTP id
 d11-20020a67ed8b000000b0042ffca5981emr292984vsp.2.1683281673030; Fri, 05 May
 2023 03:14:33 -0700 (PDT)
MIME-Version: 1.0
References: <CAAhSdy2RLinG5Gx-sfOqrYDAT=xDa3WAk8r1jTu8ReO5Jo0LVA@mail.gmail.com>
In-Reply-To: <CAAhSdy2RLinG5Gx-sfOqrYDAT=xDa3WAk8r1jTu8ReO5Jo0LVA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Fri, 5 May 2023 12:14:22 +0200
Message-ID: <CABgObfYtH-Lxsoe+X1FVv3s_q6N07pvfxQ6Ta5yDtepExteePw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.4
To:     Anup Patel <anup@brainfault.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Atish Patra <atishp@atishpatra.org>,
        Atish Patra <atishp@rivosinc.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 21, 2023 at 7:34=E2=80=AFPM Anup Patel <anup@brainfault.org> wr=
ote:
>
> Hi Paolo,
>
> We have the following KVM RISC-V changes for 6.4:
> 1) ONE_REG interface to enable/disable SBI extensions
> 2) Zbb extension for Guest/VM
> 3) AIA CSR virtualization
> 4) Few minor cleanups and fixes
>
> Please pull.
>
> Please note that the Zicboz series has been taken by
> Palmer through the RISC-V tree which results in few
> minor conflicts in the following files:
> arch/riscv/include/asm/hwcap.h
> arch/riscv/include/uapi/asm/kvm.h
> arch/riscv/kernel/cpu.c
> arch/riscv/kernel/cpufeature.c
> arch/riscv/kvm/vcpu.c
>
> I am not sure if a shared tag can make things easy
> for you or Palmer.

Done, finally.

Thanks,

Paolo

> Regards,
> Anup
>
> The following changes since commit 6a8f57ae2eb07ab39a6f0ccad60c7607430510=
26:
>
>   Linux 6.3-rc7 (2023-04-16 15:23:53 -0700)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.4-1
>
> for you to fetch changes up to 2f4d58f7635aec014428e73ef6120c4d0377c430:
>
>   RISC-V: KVM: Virtualize per-HART AIA CSRs (2023-04-21 18:10:27 +0530)
>
> ----------------------------------------------------------------
> KVM/riscv changes for 6.4
>
> - ONE_REG interface to enable/disable SBI extensions
> - Zbb extension for Guest/VM
> - AIA CSR virtualization
>
> ----------------------------------------------------------------
> Andrew Jones (1):
>       RISC-V: KVM: Alphabetize selects
>
> Anup Patel (10):
>       RISC-V: KVM: Add ONE_REG interface to enable/disable SBI extensions
>       RISC-V: KVM: Allow Zbb extension for Guest/VM
>       RISC-V: Add AIA related CSR defines
>       RISC-V: Detect AIA CSRs from ISA string
>       RISC-V: KVM: Drop the _MASK suffix from hgatp.VMID mask defines
>       RISC-V: KVM: Initial skeletal support for AIA
>       RISC-V: KVM: Implement subtype for CSR ONE_REG interface
>       RISC-V: KVM: Add ONE_REG interface for AIA CSRs
>       RISC-V: KVM: Use bitmap for irqs_pending and irqs_pending_mask
>       RISC-V: KVM: Virtualize per-HART AIA CSRs
>
> David Matlack (1):
>       KVM: RISC-V: Retry fault if vma_lookup() results become invalid
>
>  arch/riscv/include/asm/csr.h          | 107 +++++++++-
>  arch/riscv/include/asm/hwcap.h        |   8 +
>  arch/riscv/include/asm/kvm_aia.h      | 127 +++++++++++
>  arch/riscv/include/asm/kvm_host.h     |  14 +-
>  arch/riscv/include/asm/kvm_vcpu_sbi.h |   8 +-
>  arch/riscv/include/uapi/asm/kvm.h     |  51 ++++-
>  arch/riscv/kernel/cpu.c               |   2 +
>  arch/riscv/kernel/cpufeature.c        |   2 +
>  arch/riscv/kvm/Kconfig                |  10 +-
>  arch/riscv/kvm/Makefile               |   1 +
>  arch/riscv/kvm/aia.c                  | 388 ++++++++++++++++++++++++++++=
++++++
>  arch/riscv/kvm/main.c                 |  22 +-
>  arch/riscv/kvm/mmu.c                  |  28 ++-
>  arch/riscv/kvm/vcpu.c                 | 194 +++++++++++++----
>  arch/riscv/kvm/vcpu_insn.c            |   1 +
>  arch/riscv/kvm/vcpu_sbi.c             | 247 ++++++++++++++++++++--
>  arch/riscv/kvm/vcpu_sbi_base.c        |   2 +-
>  arch/riscv/kvm/vm.c                   |   4 +
>  arch/riscv/kvm/vmid.c                 |   4 +-
>  19 files changed, 1129 insertions(+), 91 deletions(-)
>  create mode 100644 arch/riscv/include/asm/kvm_aia.h
>  create mode 100644 arch/riscv/kvm/aia.c
>

