Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBECF51F3DF
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 07:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbiEIFhp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 01:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233752AbiEIFg1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 01:36:27 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB15E154FA4
        for <kvm@vger.kernel.org>; Sun,  8 May 2022 22:32:34 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id e24so17804486wrc.9
        for <kvm@vger.kernel.org>; Sun, 08 May 2022 22:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TtVlY+C8hBffv2WPWsAMedVX+O+Qs5k+jY37q9IS2fI=;
        b=0vsykZ6evwtInjYhpdg1T3hdzuqsT6eE8R38QmPbmqijiPuhM+01C1O3V6PEv8x1td
         4mWBAFpOgYgyila+zVnf5YjPy9YR37wmU1+LZde6kEOTD1xtW1GukTWOElwTGFT3c28V
         mBR0gJjrJmOE2Ml8f5MgvGUNNZQdDAp/et0x9ddlnz+p+i74yUPBB+8ldCkkb8sVEgkF
         YAxP1zmD2GXOZLOYcwz3jgZj/4ZAmPib00IQhCemqwIoOO2qpTaI1CBsC3hzYzr0M9XH
         J1znsFDFy2BZU6ctDL6CVlD5z/LAzhU5Uxh7wd7GJ5B+d/Dge1CbcsAR69slnGd81vE1
         oyMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TtVlY+C8hBffv2WPWsAMedVX+O+Qs5k+jY37q9IS2fI=;
        b=zf7e6G9hLytRscve5ZCybsXOmJahF+hGY/Kj/guPS4gVhPFy3FSL87LXcKeyzIt9Ke
         SaKDN11PeEzAjQdrkdE3b2JjcpvJfZJfao54qou9zGyly5eHhWnunwyB5JnCYZLM6hJb
         9C5AM/Wu8kis19OAq6i+5LgN8DeUnLHG9sPAT+3vwA2B293SbCEoHFVIFbiAqWsvdT4M
         smwck+F0voIVurT2+1Ic9CZ8f51rFbfT/tNMTmk6u283PIJFXmhAKtR28ugMGRVDwY2K
         583G+QqV6tiLr5ABtc23mDOs3h6fPuUcmfHaHDXfUuyavO7XdNwNWboAIkGyUid+vN37
         wpbQ==
X-Gm-Message-State: AOAM530IROMzrrsPiV4z29Kz7YUOfslsLg8C7yy05bnjaAL+HRwUCiW1
        zK20dwG9B5Yu2do2dp7dUprUkd47FEhZouDWl158Xg==
X-Google-Smtp-Source: ABdhPJy1pZWq2QSk+ODRo0bbjzB7ThwjgRWpktjes5LTN4O1ngkJ3gctzS/rpBEs6nAGoo+eF0WjnQT4pwOPU56k0Mw=
X-Received: by 2002:a05:6000:799:b0:20c:6e3c:a28c with SMTP id
 bu25-20020a056000079900b0020c6e3ca28cmr12234422wrb.346.1652074353208; Sun, 08
 May 2022 22:32:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220420112450.155624-1-apatel@ventanamicro.com>
 <20220420112450.155624-4-apatel@ventanamicro.com> <CAOnJCU+sDbJERnrcTUiLowvpfRDJ=-YPkc2dxzbfsD+qFBMUKw@mail.gmail.com>
In-Reply-To: <CAOnJCU+sDbJERnrcTUiLowvpfRDJ=-YPkc2dxzbfsD+qFBMUKw@mail.gmail.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 9 May 2022 11:02:21 +0530
Message-ID: <CAAhSdy281_AgjQyUXLfF8ZP2SXpyKGVd68XwVEGuQVFoz16_3g@mail.gmail.com>
Subject: Re: [PATCH v2 3/7] RISC-V: KVM: Treat SBI HFENCE calls as NOPs
To:     Atish Patra <atishp@atishpatra.org>
Cc:     Anup Patel <apatel@ventanamicro.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 4, 2022 at 7:44 AM Atish Patra <atishp@atishpatra.org> wrote:
>
> On Wed, Apr 20, 2022 at 4:25 AM Anup Patel <apatel@ventanamicro.com> wrote:
> >
> > We should treat SBI HFENCE calls as NOPs until nested virtualization
> > is supported by KVM RISC-V. This will help us test booting a hypervisor
> > under KVM RISC-V.
> >
> > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > ---
> >  arch/riscv/kvm/vcpu_sbi_replace.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/vcpu_sbi_replace.c
> > index 0f217365c287..3c1dcd38358e 100644
> > --- a/arch/riscv/kvm/vcpu_sbi_replace.c
> > +++ b/arch/riscv/kvm/vcpu_sbi_replace.c
> > @@ -117,7 +117,11 @@ static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run
> >         case SBI_EXT_RFENCE_REMOTE_HFENCE_GVMA_VMID:
> >         case SBI_EXT_RFENCE_REMOTE_HFENCE_VVMA:
> >         case SBI_EXT_RFENCE_REMOTE_HFENCE_VVMA_ASID:
> > -       /* TODO: implement for nested hypervisor case */
> > +               /*
> > +                * Until nested virtualization is implemented, the
> > +                * SBI HFENCE calls should be treated as NOPs
> > +                */
> > +               break;
> >         default:
> >                 ret = -EOPNOTSUPP;
> >         }
> > --
> > 2.25.1
> >
>
>
> Reviewed-by: Atish Patra <atishp@rivosinc.com>

Queued this patch for 5.19

Thanks,
Anup

> --
> Regards,
> Atish
