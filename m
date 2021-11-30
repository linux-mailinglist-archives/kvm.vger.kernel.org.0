Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCDFF462C47
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 06:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238365AbhK3FnZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 00:43:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238360AbhK3FnT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 00:43:19 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F95C061574
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 21:40:00 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id u80so19410206pfc.9
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 21:40:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2O/hiQ03MFaYbbx3qyaBx+GPTTjxo7NbQIxhjjvNI2w=;
        b=FJaoREo5lr4D3hO1iEHEr3xWdnD0wwrtf7Ef1X1rSs8S4PWjhTbbX6jnw6DBltbsJX
         6i9Ywnw7JCOsnCL/UwEWjqp17HJkt4EzbZTxyBxuoWJG8/Of+n/SqA6za6RkHdE6SASr
         t6wu10M8KcnN+UXjYsY9yGCelVtKnbGPoQhZ/rPLX3b85pSxj+RB3R/kmxfVxxpG54+m
         FjTcQGEc9YCx64+fwylV3ylCk+0ERgSyEiXZ87vXZfSFh7ajfHECA38JLabu1lYOUZ4J
         1ktEAlEFRS5l1KibAPtXqfVpQMMEVdyQZjAA9POS4cKpRUN4R8mV+hoW2fGgdNxpid+B
         KG3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2O/hiQ03MFaYbbx3qyaBx+GPTTjxo7NbQIxhjjvNI2w=;
        b=lcD6GtEE9LgDoeMHK+ZrqNMs3tCT/5X4sRx71PLuiFRYR+Ccgaut9c91dN88hP4Dks
         7RT3iDxARAa0kdIXX+ZqnyqJyteuNVwcedPJKnM6W+gpJAnDoTAUC2p2+Q7I/s/OTAXW
         Vy5qAu057KWtR8rCizkCZgQEock8Mb4+2aXtlwBHd3UdScFneuPJ4eUSwE1GuLsh1pkO
         KQ+jBLSLXPdSGAh+WRDHK/grFIz8VZWZp1YjY3DJb56HTGW/TQoDylSnwlagkb1p3an0
         deAcC1/O+2KUJOm5Gr4alcJ5iLLudnxBai5f4V0f+9Xmr71moaRFlSUes5e7pT242L8i
         k51A==
X-Gm-Message-State: AOAM533VWfvuOVUqdRPx1ydY5Crba/PJbaxi9Rf5T/WhzBAT8xNjEmp0
        BJ6HmI7b7Dxw8jzDNVwJJQoKX0whcpFU9kDdB0BS0Hj68Bkj7w==
X-Google-Smtp-Source: ABdhPJzYoUPHGrIYMegTjTSSCO7W+6mHt9oLHSQoSM1blfLYXTNnPxnKfkEzBg1Vu3CUu/4qR3k0I2UA4fV59wak9oI=
X-Received: by 2002:a63:82c6:: with SMTP id w189mr26026217pgd.491.1638250799398;
 Mon, 29 Nov 2021 21:39:59 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com> <20211117064359.2362060-13-reijiw@google.com>
 <44073484-639e-3d23-2068-ae5c2cac3276@redhat.com>
In-Reply-To: <44073484-639e-3d23-2068-ae5c2cac3276@redhat.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 29 Nov 2021 21:39:43 -0800
Message-ID: <CAAeT=FyBaKvof6BpPB021MN6k797BcMP+sPMDeiZ9SR6nvXdCA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 12/29] KVM: arm64: Make ID_DFR1_EL1 writable
To:     Eric Auger <eauger@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On Thu, Nov 25, 2021 at 12:30 PM Eric Auger <eauger@redhat.com> wrote:
>
> Hi Reiji,
>
> On 11/17/21 7:43 AM, Reiji Watanabe wrote:
> > This patch adds id_reg_info for ID_DFR1_EL1 to make it writable
> > by userspace.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index fbd335ac5e6b..dda7001959f6 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -859,6 +859,11 @@ static struct id_reg_info id_dfr0_el1_info = {
> >       .get_reset_val = get_reset_id_dfr0_el1,
> >  };
> >
> > +static struct id_reg_info id_dfr1_el1_info = {
> > +     .sys_reg = SYS_ID_DFR1_EL1,
> > +     .ftr_check_types = S_FCT(ID_DFR1_MTPMU_SHIFT, FCT_LOWER_SAFE),
> what about the 0xF value which indicates the MTPMU is not implemented?

The field is treated as a signed field.
So, 0xf(== -1) is handled correctly.
(Does it answer your question?)

Thanks,
Reiji

>
> Eric
> > +};
> > +
> >  /*
> >   * An ID register that needs special handling to control the value for the
> >   * guest must have its own id_reg_info in id_reg_info_table.
> > @@ -869,6 +874,7 @@ static struct id_reg_info id_dfr0_el1_info = {
> >  #define      GET_ID_REG_INFO(id)     (id_reg_info_table[IDREG_IDX(id)])
> >  static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
> >       [IDREG_IDX(SYS_ID_DFR0_EL1)] = &id_dfr0_el1_info,
> > +     [IDREG_IDX(SYS_ID_DFR1_EL1)] = &id_dfr1_el1_info,
> >       [IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
> >       [IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
> >       [IDREG_IDX(SYS_ID_AA64DFR0_EL1)] = &id_aa64dfr0_el1_info,
> >
>
