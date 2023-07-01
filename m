Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF7307448C0
	for <lists+kvm@lfdr.de>; Sat,  1 Jul 2023 13:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbjGALiL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Jul 2023 07:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjGALiK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Jul 2023 07:38:10 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25456128
        for <kvm@vger.kernel.org>; Sat,  1 Jul 2023 04:38:09 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id 2adb3069b0e04-4fb5bcb9a28so4498018e87.3
        for <kvm@vger.kernel.org>; Sat, 01 Jul 2023 04:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20221208.gappssmtp.com; s=20221208; t=1688211487; x=1690803487;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZAuIfqT5Gll/OkRGnZNYzkmmC2G5kvlC5phjaj1JvNo=;
        b=FvLbCvH7C5oKNFAor8rQlEixGwXADb1QO32R+faYApfpeKdx7p12r6p6VzT+2O83UD
         moAO+kXJbdjGSuQs1EwijJOMNOeifqbxxWx7HRS/oJ3MX6KEEnPCHKNcWpTq5KwgoXZC
         SjF+23XCoQ22NJdaIhrXeAzrifaf/sHObVo12iFO7YD+NuuNnUqhx+C46jtGwzsjkNM4
         kzCJyJqzjeVqsNaBJ8Ne++BpXHncaNPoG4CxXvIq0JbdnF74YCDd+Vpat0+lJ+gkQSZP
         UjSs7Pj33OfHC5xQGTDESBSyaRb81/TevLPtjAAuST0uwl505aYAks4kZU5EQyvvOi33
         HTIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688211487; x=1690803487;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZAuIfqT5Gll/OkRGnZNYzkmmC2G5kvlC5phjaj1JvNo=;
        b=A+ZJSyT1ywqSSR/zY9Dz0dp7gb1+pOKAYTSMf/JhQkbpwdj5h5hsiyzDpsIepT6HRk
         7kVZQ454x3kXGtTexENWZJDOPWmYkld3VGJpkSy9T3UJ3JFATjzQM2X45tJOlgheXhI+
         6q8UkHToRqN6jh4xOT5HQmR7bZ40oVMy1pLt7HO7jeLQryO9XafygxkZihvyMvjG3I7G
         m2gNnaX8wxE+4Xs/L83c72S9yA6s1z1fOqqkrk0OaE9TWnQ4CUQu0uYhAcIBYTcbYUVP
         pxCnloeBKpU6LNmiCpo17LUnuwIswfu/9VrYTMBu9rt1DwMUmF13VGVM4nYC5G8Le2BX
         iQjw==
X-Gm-Message-State: ABy/qLbIfg/bv5O5KS0BJTeIYzOd16xRDxnXbGsR2k61sdYIDyJxXkwo
        Gqzy3sZwu2IezhdH41wC2IytBN0V4poEfYiPbULk/w==
X-Google-Smtp-Source: APBJJlFPF7EYCx4bAivjCDW+lZ5Fb7Qn3wBMLcBCl1tZ64ObT+EZbhZGWQGeLCVhLl/0nq7a5RUQ2xOAkBaiLlciJDk=
X-Received: by 2002:a05:6512:10d4:b0:4fb:b11:c99e with SMTP id
 k20-20020a05651210d400b004fb0b11c99emr4727305lfg.56.1688211486473; Sat, 01
 Jul 2023 04:38:06 -0700 (PDT)
MIME-Version: 1.0
References: <CAAhSdy1iT=SbjSvv_7SDygSo0HhmgLjD-y+DU1_Q+6tnki7w+A@mail.gmail.com>
 <CABgObfZ5E58OpEzmRgVQ8axSZdoW-mfsq1wbPp=cfOX304O6uw@mail.gmail.com>
In-Reply-To: <CABgObfZ5E58OpEzmRgVQ8axSZdoW-mfsq1wbPp=cfOX304O6uw@mail.gmail.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Sat, 1 Jul 2023 17:07:54 +0530
Message-ID: <CAAhSdy04b6TxLC78yXSUipX5dkYbWnOuuLMm56HDAy1MS2MzfQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.5
To:     Paolo Bonzini <pbonzini@redhat.com>
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
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jul 1, 2023 at 4:34=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>
> On Thu, Jun 22, 2023 at 4:13=E2=80=AFPM Anup Patel <anup@brainfault.org> =
wrote:
> >
> > Hi Paolo,
> >
> > We have the following KVM RISC-V changes for 6.5:
> > 1) Redirect AMO load/store misaligned traps to KVM guest
> > 2) Trap-n-emulate AIA in-kernel irqchip for KVM guest
> > 3) Svnapot support for KVM Guest
> >
> > Please pull.
> >
> > Please note that there is a minor conflict with the RISC-V
> > tree in the arch/riscv/include/uapi/asm/kvm.h header due to
> > KVM vector virtualization going through the RISC-V tree.
>
> Thanks for the heads up. I also appreciate that you have fixed the
> workflow and the author/committer date are now okay!

Yes, the next branch of KVM RISC-V tree is now part of regular
integration testing in linux-next and I am actively pushing accepted
patches to the next branch much before the actual PR.

Thanks to your suggestions and guidance.

Regards,
Anup

>
> Paolo
>
> > Regards,
> > Anup
> >
> > The following changes since commit 9561de3a55bed6bdd44a12820ba81ec416e7=
05a7:
> >
> >   Linux 6.4-rc5 (2023-06-04 14:04:27 -0400)
> >
> > are available in the Git repository at:
> >
> >   https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.5-1
> >
> > for you to fetch changes up to 07f225b5842420ae9c18cba17873fc71ed69c28e=
:
> >
> >   RISC-V: KVM: Remove unneeded semicolon (2023-06-20 10:48:38 +0530)
> >
> > ----------------------------------------------------------------
> > KVM/riscv changes for 6.5
> >
> > - Redirect AMO load/store misaligned traps to KVM guest
> > - Trap-n-emulate AIA in-kernel irqchip for KVM guest
> > - Svnapot support for KVM Guest
> >
> > ----------------------------------------------------------------
> > Andrew Jones (3):
> >       RISC-V: KVM: Rename dis_idx to ext_idx
> >       RISC-V: KVM: Convert extension_disabled[] to ext_status[]
> >       RISC-V: KVM: Probe for SBI extension status
> >
> > Anup Patel (11):
> >       RISC-V: KVM: Implement guest external interrupt line management
> >       RISC-V: KVM: Add IMSIC related defines
> >       RISC-V: KVM: Add APLIC related defines
> >       RISC-V: KVM: Set kvm_riscv_aia_nr_hgei to zero
> >       RISC-V: KVM: Skeletal in-kernel AIA irqchip support
> >       RISC-V: KVM: Implement device interface for AIA irqchip
> >       RISC-V: KVM: Add in-kernel emulation of AIA APLIC
> >       RISC-V: KVM: Expose APLIC registers as attributes of AIA irqchip
> >       RISC-V: KVM: Add in-kernel virtualization of AIA IMSIC
> >       RISC-V: KVM: Expose IMSIC registers as attributes of AIA irqchip
> >       RISC-V: KVM: Allow Svnapot extension for Guest/VM
> >
> > Ben Dooks (1):
> >       riscv: kvm: define vcpu_sbi_ext_pmu in header
> >
> > Yang Li (1):
> >       RISC-V: KVM: Remove unneeded semicolon
> >
> > Ye Xingchen (1):
> >       RISC-V: KVM: use bitmap_zero() API
> >
> > wchen (1):
> >       RISC-V: KVM: Redirect AMO load/store misaligned traps to guest
> >
> >  arch/riscv/include/asm/csr.h           |    2 +
> >  arch/riscv/include/asm/kvm_aia.h       |  107 +++-
> >  arch/riscv/include/asm/kvm_aia_aplic.h |   58 ++
> >  arch/riscv/include/asm/kvm_aia_imsic.h |   38 ++
> >  arch/riscv/include/asm/kvm_host.h      |    4 +
> >  arch/riscv/include/asm/kvm_vcpu_sbi.h  |   11 +-
> >  arch/riscv/include/uapi/asm/kvm.h      |   73 +++
> >  arch/riscv/kvm/Kconfig                 |    4 +
> >  arch/riscv/kvm/Makefile                |    3 +
> >  arch/riscv/kvm/aia.c                   |  274 +++++++-
> >  arch/riscv/kvm/aia_aplic.c             |  619 ++++++++++++++++++
> >  arch/riscv/kvm/aia_device.c            |  673 ++++++++++++++++++++
> >  arch/riscv/kvm/aia_imsic.c             | 1084 ++++++++++++++++++++++++=
++++++++
> >  arch/riscv/kvm/main.c                  |    3 +-
> >  arch/riscv/kvm/tlb.c                   |    2 +-
> >  arch/riscv/kvm/vcpu.c                  |    4 +
> >  arch/riscv/kvm/vcpu_exit.c             |    2 +
> >  arch/riscv/kvm/vcpu_sbi.c              |   80 ++-
> >  arch/riscv/kvm/vm.c                    |  118 ++++
> >  include/uapi/linux/kvm.h               |    2 +
> >  20 files changed, 3100 insertions(+), 61 deletions(-)
> >  create mode 100644 arch/riscv/include/asm/kvm_aia_aplic.h
> >  create mode 100644 arch/riscv/include/asm/kvm_aia_imsic.h
> >  create mode 100644 arch/riscv/kvm/aia_aplic.c
> >  create mode 100644 arch/riscv/kvm/aia_device.c
> >  create mode 100644 arch/riscv/kvm/aia_imsic.c
> >
>
