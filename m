Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0EA7448A9
	for <lists+kvm@lfdr.de>; Sat,  1 Jul 2023 13:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjGALFM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Jul 2023 07:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbjGALFL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Jul 2023 07:05:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08AA43C05
        for <kvm@vger.kernel.org>; Sat,  1 Jul 2023 04:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688209462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=usj2c3ViGBK68/uJN1vOeJSqiKiuoQd+nTxCRZLq9fA=;
        b=f3PqKK0JHG7xsCA5byFn011a8jPok/f0ItOf52PhGU/Vh3n/6eHgrbXFzJmhocDz7WFmR5
        kLmakWWLjsIQOS12gNrLh2zH9gtYZ/cnH9R/hZZMYoL24tlo4mH1+sOzWvdQ6L4XN5OUrD
        3o3v1R0sLcFLE/Gy/dgRlR7haYlTVsk=
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
 [209.85.222.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-BFKYmft2POaVGnKQxheEAA-1; Sat, 01 Jul 2023 07:04:21 -0400
X-MC-Unique: BFKYmft2POaVGnKQxheEAA-1
Received: by mail-ua1-f70.google.com with SMTP id a1e0cc1a2514c-7945b377709so619150241.1
        for <kvm@vger.kernel.org>; Sat, 01 Jul 2023 04:04:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688209460; x=1690801460;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=usj2c3ViGBK68/uJN1vOeJSqiKiuoQd+nTxCRZLq9fA=;
        b=Yp87D/kcfmIGfc3Gpho4BvR3zvkig3tzPYe6mxEJ15s1u9caVIxvCwRKiMKwgJ0Z86
         BWq8nwwj4B+8vyOfixsmbmQhlnLdCoG1nzhAYLkQR57ypufHADMVfIldDr5GwkG1OpSr
         dQ81ImOLX77xpPX6O567PUrjpwKk0G9lAJQnYNKZa1VXY1/cART08AbmYNgYN6QvoQ23
         Zsif/PHmdoc4mxaxH+BCQj3NyNaH7dokB1DXnQhNlYr6JaFwcJDviwnftrVZD73E3WhU
         yZ2VD1JiLDKuIWTVJkEAYWLGS6gFGnScARcSqC9F/qq1/+FNHM9ie9lxF5ftHoGeY92H
         qtwQ==
X-Gm-Message-State: ABy/qLbu4mfPnGxMLwQmPZErNWAZ/uJXmvvK89mHv9jQIki5MHBXtuPR
        lKqQk/Z6rO+SbwtqHkdxucsMOvfB0/fJmwg0JDGFGphNTr/Tm1TJs7btDxIRGP3O28oq7rrdC9K
        iYrGVH52G2nE8Z2jg3y0VvfapLAMD
X-Received: by 2002:a67:b14b:0:b0:443:70bd:719b with SMTP id z11-20020a67b14b000000b0044370bd719bmr3313815vsl.0.1688209460647;
        Sat, 01 Jul 2023 04:04:20 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFOQP3TLfCvY1U9O3p3HiSXflFh63RBDjtIKnxptpkvhxoaqz3LRDzbrfPqIDswBL+O/CNtNuz0b1RZL17327w=
X-Received: by 2002:a67:b14b:0:b0:443:70bd:719b with SMTP id
 z11-20020a67b14b000000b0044370bd719bmr3313775vsl.0.1688209459943; Sat, 01 Jul
 2023 04:04:19 -0700 (PDT)
MIME-Version: 1.0
References: <CAAhSdy1iT=SbjSvv_7SDygSo0HhmgLjD-y+DU1_Q+6tnki7w+A@mail.gmail.com>
In-Reply-To: <CAAhSdy1iT=SbjSvv_7SDygSo0HhmgLjD-y+DU1_Q+6tnki7w+A@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Sat, 1 Jul 2023 13:04:08 +0200
Message-ID: <CABgObfZ5E58OpEzmRgVQ8axSZdoW-mfsq1wbPp=cfOX304O6uw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.5
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 22, 2023 at 4:13=E2=80=AFPM Anup Patel <anup@brainfault.org> wr=
ote:
>
> Hi Paolo,
>
> We have the following KVM RISC-V changes for 6.5:
> 1) Redirect AMO load/store misaligned traps to KVM guest
> 2) Trap-n-emulate AIA in-kernel irqchip for KVM guest
> 3) Svnapot support for KVM Guest
>
> Please pull.
>
> Please note that there is a minor conflict with the RISC-V
> tree in the arch/riscv/include/uapi/asm/kvm.h header due to
> KVM vector virtualization going through the RISC-V tree.

Thanks for the heads up. I also appreciate that you have fixed the
workflow and the author/committer date are now okay!

Paolo

> Regards,
> Anup
>
> The following changes since commit 9561de3a55bed6bdd44a12820ba81ec416e705=
a7:
>
>   Linux 6.4-rc5 (2023-06-04 14:04:27 -0400)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-riscv/linux.git tags/kvm-riscv-6.5-1
>
> for you to fetch changes up to 07f225b5842420ae9c18cba17873fc71ed69c28e:
>
>   RISC-V: KVM: Remove unneeded semicolon (2023-06-20 10:48:38 +0530)
>
> ----------------------------------------------------------------
> KVM/riscv changes for 6.5
>
> - Redirect AMO load/store misaligned traps to KVM guest
> - Trap-n-emulate AIA in-kernel irqchip for KVM guest
> - Svnapot support for KVM Guest
>
> ----------------------------------------------------------------
> Andrew Jones (3):
>       RISC-V: KVM: Rename dis_idx to ext_idx
>       RISC-V: KVM: Convert extension_disabled[] to ext_status[]
>       RISC-V: KVM: Probe for SBI extension status
>
> Anup Patel (11):
>       RISC-V: KVM: Implement guest external interrupt line management
>       RISC-V: KVM: Add IMSIC related defines
>       RISC-V: KVM: Add APLIC related defines
>       RISC-V: KVM: Set kvm_riscv_aia_nr_hgei to zero
>       RISC-V: KVM: Skeletal in-kernel AIA irqchip support
>       RISC-V: KVM: Implement device interface for AIA irqchip
>       RISC-V: KVM: Add in-kernel emulation of AIA APLIC
>       RISC-V: KVM: Expose APLIC registers as attributes of AIA irqchip
>       RISC-V: KVM: Add in-kernel virtualization of AIA IMSIC
>       RISC-V: KVM: Expose IMSIC registers as attributes of AIA irqchip
>       RISC-V: KVM: Allow Svnapot extension for Guest/VM
>
> Ben Dooks (1):
>       riscv: kvm: define vcpu_sbi_ext_pmu in header
>
> Yang Li (1):
>       RISC-V: KVM: Remove unneeded semicolon
>
> Ye Xingchen (1):
>       RISC-V: KVM: use bitmap_zero() API
>
> wchen (1):
>       RISC-V: KVM: Redirect AMO load/store misaligned traps to guest
>
>  arch/riscv/include/asm/csr.h           |    2 +
>  arch/riscv/include/asm/kvm_aia.h       |  107 +++-
>  arch/riscv/include/asm/kvm_aia_aplic.h |   58 ++
>  arch/riscv/include/asm/kvm_aia_imsic.h |   38 ++
>  arch/riscv/include/asm/kvm_host.h      |    4 +
>  arch/riscv/include/asm/kvm_vcpu_sbi.h  |   11 +-
>  arch/riscv/include/uapi/asm/kvm.h      |   73 +++
>  arch/riscv/kvm/Kconfig                 |    4 +
>  arch/riscv/kvm/Makefile                |    3 +
>  arch/riscv/kvm/aia.c                   |  274 +++++++-
>  arch/riscv/kvm/aia_aplic.c             |  619 ++++++++++++++++++
>  arch/riscv/kvm/aia_device.c            |  673 ++++++++++++++++++++
>  arch/riscv/kvm/aia_imsic.c             | 1084 ++++++++++++++++++++++++++=
++++++
>  arch/riscv/kvm/main.c                  |    3 +-
>  arch/riscv/kvm/tlb.c                   |    2 +-
>  arch/riscv/kvm/vcpu.c                  |    4 +
>  arch/riscv/kvm/vcpu_exit.c             |    2 +
>  arch/riscv/kvm/vcpu_sbi.c              |   80 ++-
>  arch/riscv/kvm/vm.c                    |  118 ++++
>  include/uapi/linux/kvm.h               |    2 +
>  20 files changed, 3100 insertions(+), 61 deletions(-)
>  create mode 100644 arch/riscv/include/asm/kvm_aia_aplic.h
>  create mode 100644 arch/riscv/include/asm/kvm_aia_imsic.h
>  create mode 100644 arch/riscv/kvm/aia_aplic.c
>  create mode 100644 arch/riscv/kvm/aia_device.c
>  create mode 100644 arch/riscv/kvm/aia_imsic.c
>

