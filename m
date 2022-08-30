Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4BE85A6B2D
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 19:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbiH3Rsy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 13:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232186AbiH3Rsb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 13:48:31 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947BF1FCCE
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 10:45:19 -0700 (PDT)
Date:   Tue, 30 Aug 2022 12:45:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661881517;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bZ/O3vOFDUvoL+xwB7YJSEtUpOZ6W45CAPj5b/aG6hs=;
        b=FW0OqKpqy3RbUkz4twa7NjQFBZuUkJapstDnlrevW9OKV8lDkgX3u1cof3AprNcoA3nNWt
        /Fp68JTIJ+Z6ku+RFpjQhQm7dUZZP0XGeDT3CYETvIlZ88EI0VqEYaYCOUwmHGPtDLhr5+
        kv20p2660vzAYC5mu21QVsRSEqe8DtI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/6] KVM: arm64: Remove internal accessor helpers for id
 regs
Message-ID: <Yw5MqMvqwPXBPE0a@google.com>
References: <20220817214818.3243383-1-oliver.upton@linux.dev>
 <20220817214818.3243383-3-oliver.upton@linux.dev>
 <CAAeT=FwxN=UtVGO+85iZNRkGEoZ7GQ_WB4FAhHBRnCKoPNXHVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeT=FwxN=UtVGO+85iZNRkGEoZ7GQ_WB4FAhHBRnCKoPNXHVg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Reiji,

On Mon, Aug 29, 2022 at 10:45:09PM -0700, Reiji Watanabe wrote:
> Hi Oliver,
> 
> On Wed, Aug 17, 2022 at 2:48 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > The internal accessors are only ever called once. Dump out their
> > contents in the caller.
> >
> > No functional change intended.
> >
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 46 ++++++++++-----------------------------
> >  1 file changed, 12 insertions(+), 34 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index e18efb9211f0..26210f3a0b27 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -1153,25 +1153,17 @@ static unsigned int raz_visibility(const struct kvm_vcpu *vcpu,
> >
> >  /* cpufeature ID register access trap handlers */
> >
> > -static bool __access_id_reg(struct kvm_vcpu *vcpu,
> > -                           struct sys_reg_params *p,
> > -                           const struct sys_reg_desc *r,
> > -                           bool raz)
> > -{
> > -       if (p->is_write)
> > -               return write_to_read_only(vcpu, p, r);
> > -
> > -       p->regval = read_id_reg(vcpu, r, raz);
> > -       return true;
> > -}
> > -
> >  static bool access_id_reg(struct kvm_vcpu *vcpu,
> >                           struct sys_reg_params *p,
> >                           const struct sys_reg_desc *r)
> >  {
> >         bool raz = sysreg_visible_as_raz(vcpu, r);
> >
> > -       return __access_id_reg(vcpu, p, r, raz);
> > +       if (p->is_write)
> > +               return write_to_read_only(vcpu, p, r);
> > +
> > +       p->regval = read_id_reg(vcpu, r, raz);
> > +       return true;
> >  }
> >
> >  /* Visibility overrides for SVE-specific control registers */
> > @@ -1226,31 +1218,13 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> >   * are stored, and for set_id_reg() we don't allow the effective value
> >   * to be changed.
> >   */
> > -static int __get_id_reg(const struct kvm_vcpu *vcpu,
> > -                       const struct sys_reg_desc *rd, u64 *val,
> > -                       bool raz)
> > -{
> > -       *val = read_id_reg(vcpu, rd, raz);
> > -       return 0;
> > -}
> > -
> > -static int __set_id_reg(const struct kvm_vcpu *vcpu,
> > -                       const struct sys_reg_desc *rd, u64 val,
> > -                       bool raz)
> > -{
> > -       /* This is what we mean by invariant: you can't change it. */
> > -       if (val != read_id_reg(vcpu, rd, raz))
> > -               return -EINVAL;
> > -
> > -       return 0;
> > -}
> > -
> >  static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> >                       u64 *val)
> >  {
> >         bool raz = sysreg_visible_as_raz(vcpu, rd);
> >
> > -       return __get_id_reg(vcpu, rd, val, raz);
> > +       *val = read_id_reg(vcpu, rd, raz);
> > +       return 0;
> >  }
> >
> >  static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> > @@ -1258,7 +1232,11 @@ static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> >  {
> >         bool raz = sysreg_visible_as_raz(vcpu, rd);
> >
> > -       return __set_id_reg(vcpu, rd, val, raz);
> > +       /* This is what we mean by invariant: you can't change it. */
> > +       if (val != read_id_reg(vcpu, rd, raz))
> > +               return -EINVAL;
> > +
> > +       return 0;
> >  }
> 
> I see no reason for read_id_reg() to take raz as an argument.
> Perhaps having read_id_reg() call sysreg_visible_as_raz() instead
> might make those functions even simpler?

Good point, as this patch has done away with caller-specified RAZ. I'll
incorporate that into v2.

--
Best,
Oliver
