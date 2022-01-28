Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D7749F319
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 06:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240377AbiA1Fnj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 00:43:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbiA1Fni (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jan 2022 00:43:38 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E21F5C061714
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 21:43:37 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id u11so4875131plh.13
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 21:43:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jdA8rdbgjgagcqv9xj/rVbPr7arzqXD97cl/2fIMdB8=;
        b=erv5Hgh9aPL15tqkMtnrjHVHwYx6LsZrowtgtX4GchvrzU9QCOe0moTftisr8Ze88t
         KJcJtB1McQbY3AbUaxFwYDbOc1vnQZyX9TSO7g1JfsyPhXSTXuRNaGfvm/K7yqVN64p1
         MeO4i/gJWF/UbWFnbNywHySk+KGZE8IPMwzBKy5+uYeNP8R9BLn25srcvzIZYl41gaQh
         YdfVa3KbpFP2PXjGROWmlCNU8ebMSAJLhCU0Eq3cnoHoD9usC6d06l3VPfqGDq5FnugO
         xqarXVz6QgQzUSVH4Nz5v8+s/GLjD8kzaq7BeQpOa2NNEilI88OAOzKruCbtpTdGpCQd
         2OZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jdA8rdbgjgagcqv9xj/rVbPr7arzqXD97cl/2fIMdB8=;
        b=Io86PXSCcQ88rke1JdoEU5In3ytLWQPcqLKmWVoy/bWja+6qCa8c5u9IdTYw73TMJO
         Thu+skCbZEMTCUP1qIaI3/EODj6gXRJFyQmEsLKfQYKTBZP1w9mjDC+tPVyhrPeJE1MQ
         Zf0tZNLFhTVOhjQ1lFqN2CG27V5sjB3qdEwxpHOg9hMf8bLLpV8/5PKNlNzxD2dGf8//
         9+ZVON8OiegS/b4NGXV0gtN3kr2YLlw5jIdr6fmvRfVdt7sWP+KAyuQMvoqHNGvYy+KQ
         O4wZyC8FnmaKPcr47OsCOAg4cikipRN2pY4wwU0D93JMf/qy4yZY4I3XhYjk78zHk+hF
         KcCQ==
X-Gm-Message-State: AOAM533hp8SLuEb8HdYI9+4Zr2/QjHcZ1ovcdaj0wxAre/rhTK0dDZk7
        JXBzHghyekp/X8VJxVMYa1633ZiumMlfutHxpXF0tQ==
X-Google-Smtp-Source: ABdhPJzIV4lrshDHGy5fwEKZK6TGf/saaUmUPosi2mDNh8ZNRvN99uxARFZnf8hP8TgF21iU/hor5Ww4CAklD6l1ni0=
X-Received: by 2002:a17:902:bc83:: with SMTP id bb3mr7299988plb.172.1643348617165;
 Thu, 27 Jan 2022 21:43:37 -0800 (PST)
MIME-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com> <20220106042708.2869332-24-reijiw@google.com>
 <CA+EHjTxYqPvyUz96hoJWe43raST1X7oKhdR7PeZDuwuuD9QcYQ@mail.gmail.com>
In-Reply-To: <CA+EHjTxYqPvyUz96hoJWe43raST1X7oKhdR7PeZDuwuuD9QcYQ@mail.gmail.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Thu, 27 Jan 2022 21:43:21 -0800
Message-ID: <CAAeT=FxKgH_a7vthT3ai_TiCu9UCj+PNJ6SarHDF+R5tcR--Dg@mail.gmail.com>
Subject: Re: [RFC PATCH v4 23/26] KVM: arm64: Trap disabled features of ID_AA64MMFR1_EL1
To:     Fuad Tabba <tabba@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Fuad,

On Mon, Jan 24, 2022 at 9:38 AM Fuad Tabba <tabba@google.com> wrote:
>
> Hi Reiji,
>
> The series might be missing an entry for ID_AA64MMFR0_EL1, Debug
> Communications Channel registers, ID_AA64MMFR0_FGT -> MDCR_EL2_TDCC.

I will add them in v5 series.
Thank you so much for all the review comments!

Thanks,
Reiji


>
> Cheers,
> /fuad
>
>
> On Thu, Jan 6, 2022 at 4:29 AM Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Add feature_config_ctrl for LORegions, which is indicated in
> > ID_AA64MMFR1_EL1, to program configuration register to trap
> > guest's using the feature when it is not exposed to the guest.
> >
> > Change trap_loregion() to use vcpu_feature_is_available()
> > to simplify checking of the feature's availability.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 26 ++++++++++++++++++++++++--
> >  1 file changed, 24 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 229671ec3abd..f8a5ee927ecf 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -365,6 +365,11 @@ static void feature_tracefilt_trap_activate(struct kvm_vcpu *vcpu)
> >         feature_trap_activate(vcpu, VCPU_MDCR_EL2, MDCR_EL2_TTRF, 0);
> >  }
> >
> > +static void feature_lor_trap_activate(struct kvm_vcpu *vcpu)
> > +{
> > +       feature_trap_activate(vcpu, VCPU_HCR_EL2, HCR_TLOR, 0);
> > +}
> > +
> >  /* For ID_AA64PFR0_EL1 */
> >  static struct feature_config_ctrl ftr_ctrl_ras = {
> >         .ftr_reg = SYS_ID_AA64PFR0_EL1,
> > @@ -416,6 +421,15 @@ static struct feature_config_ctrl ftr_ctrl_tracefilt = {
> >         .trap_activate = feature_tracefilt_trap_activate,
> >  };
> >
> > +/* For ID_AA64MMFR1_EL1 */
> > +static struct feature_config_ctrl ftr_ctrl_lor = {
> > +       .ftr_reg = SYS_ID_AA64MMFR1_EL1,
> > +       .ftr_shift = ID_AA64MMFR1_LOR_SHIFT,
> > +       .ftr_min = 1,
> > +       .ftr_signed = FTR_UNSIGNED,
> > +       .trap_activate = feature_lor_trap_activate,
> > +};
> > +
> >  struct id_reg_info {
> >         u32     sys_reg;        /* Register ID */
> >         u64     sys_val;        /* Sanitized system value */
> > @@ -947,6 +961,14 @@ static struct id_reg_info id_aa64dfr0_el1_info = {
> >         },
> >  };
> >
> > +static struct id_reg_info id_aa64mmfr1_el1_info = {
> > +       .sys_reg = SYS_ID_AA64MMFR1_EL1,
> > +       .trap_features = &(const struct feature_config_ctrl *[]) {
> > +               &ftr_ctrl_lor,
> > +               NULL,
> > +       },
> > +};
> > +
> >  static struct id_reg_info id_dfr0_el1_info = {
> >         .sys_reg = SYS_ID_DFR0_EL1,
> >         .init = init_id_dfr0_el1_info,
> > @@ -976,6 +998,7 @@ static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
> >         [IDREG_IDX(SYS_ID_AA64ISAR0_EL1)] = &id_aa64isar0_el1_info,
> >         [IDREG_IDX(SYS_ID_AA64ISAR1_EL1)] = &id_aa64isar1_el1_info,
> >         [IDREG_IDX(SYS_ID_AA64MMFR0_EL1)] = &id_aa64mmfr0_el1_info,
> > +       [IDREG_IDX(SYS_ID_AA64MMFR1_EL1)] = &id_aa64mmfr1_el1_info,
> >  };
> >
> >  static int validate_id_reg(struct kvm_vcpu *vcpu, u32 id, u64 val)
> > @@ -1050,10 +1073,9 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
> >                           struct sys_reg_params *p,
> >                           const struct sys_reg_desc *r)
> >  {
> > -       u64 val = __read_id_reg(vcpu, SYS_ID_AA64MMFR1_EL1);
> >         u32 sr = reg_to_encoding(r);
> >
> > -       if (!(val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))) {
> > +       if (!vcpu_feature_is_available(vcpu, &ftr_ctrl_lor)) {
> >                 kvm_inject_undefined(vcpu);
> >                 return false;
> >         }
> > --
> > 2.34.1.448.ga2b2bfdf31-goog
> >
> > _______________________________________________
> > kvmarm mailing list
> > kvmarm@lists.cs.columbia.edu
> > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
