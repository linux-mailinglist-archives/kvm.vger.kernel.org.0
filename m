Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 048A7525462
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 20:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357442AbiELSBk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 14:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357459AbiELSBj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 14:01:39 -0400
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75943153D
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 11:01:30 -0700 (PDT)
Received: by mail-ua1-x936.google.com with SMTP id z15so2298161uad.7
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 11:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R/vc0gLWw+QgOd5StRMMn5NtVGK0/gM8csrI6YuGF9c=;
        b=suPPRrSeDnKEbTZmA3DXeTbeCH1w1ZeZag8C+DhOxqPeOcakR1pAA3GxECqzQTgKsm
         AuwByKCt0SzaBgbntpOFkOzP89xs420qi7eTUW9u5FtFNy76IJDusiNVeujtEZUCCiMK
         8r0yr34jzxt5QohVI3xYXY+ZO4JaFoej7XMrFDG9oORIYrRxpflo12TROSVmOzVpEkP2
         neqd14+IgXbHBGj/7wI/CGb828y9kC3XNE2CHjej72QH8+PkJRe669EnxtF31ZSPr90D
         uu26hCoTUWVGEkoIXj0/x6MEdynzL4NfomjrHNr5nj1OnYtFY6cnvOpFONwDaEdWMzgu
         vYEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R/vc0gLWw+QgOd5StRMMn5NtVGK0/gM8csrI6YuGF9c=;
        b=aNDjmjSiproj6mmKjDgNc8ZeOw9fYmeNAESgWYLkmvG6GnPLc6ecr4JN697RzCMlgI
         NZoCGxa7MhP6JvD0G8yQhoNSYVG+hANp3oQNyyUVF2NzuTBcsOjbG/NHF102vFHbjVFE
         nD5SCy+UvXyCSTXXa3tc5twYGlaLaLFBRQNB0WeYGeuV4irwhVPFrw1olcI9WS2c99OJ
         dw4FpBoqnc/3fiAeDEFYR+8VXEPW3qUZn8D4OKjA4JqmSKho8VgrT5d9y1tzByzs5Cqq
         4qmNLQxEhc4VIpCGHyM24eg0U8a1Fypr/SxAvoMqCWr327Ta5cYCqB+7MdoDj/E8iAtn
         x3sw==
X-Gm-Message-State: AOAM5303M4hrUj8HsfnvpiHfo/kZW6bLGLoNooPkLangK3oxxA+mei/t
        4JeYfWBz1M2XVVNTsay6SGlIXZfXAAyNkMh74F1bPQ==
X-Google-Smtp-Source: ABdhPJzeVfRhP/tQ9YCOmX2PRw9aJgzV5+iiwDUgWafYOsuL7d2y8o6gGnBw3oBal5CwLRqXHuEVYYSGDByUuBlKK84=
X-Received: by 2002:ab0:7285:0:b0:365:f08d:a27a with SMTP id
 w5-20020ab07285000000b00365f08da27amr840597uao.93.1652378489636; Thu, 12 May
 2022 11:01:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220412223134.1736547-1-juew@google.com> <20220412223134.1736547-3-juew@google.com>
 <Ynv4hLFQMPaQ4yYs@google.com>
In-Reply-To: <Ynv4hLFQMPaQ4yYs@google.com>
From:   Jue Wang <juew@google.com>
Date:   Thu, 12 May 2022 11:01:18 -0700
Message-ID: <CAPcxDJ4eVu9w_iwyZ_q_XoqMYBML8ZK3Er4ituNUW6ptEtG+Kw@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] KVM: x86: Add LVTCMCI support.
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 11, 2022 at 10:55 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Apr 12, 2022, Jue Wang wrote:
> > This feature is only enabled when the vCPU has opted in to enable
> > MCG_CMCI_P.
>
> Again, waaaay too terse.  What is CMCI?  What does "support" mean since an astute
> reader will notice that it's impossible for MCG_CMCI_P to be set.  How/when will
> the vCPU (which is wrong no?  doesn't userspace do the write?) be able to opt-in?
I am rewriting the change log for every patch in this series and will
send an updated V3.
>
> > Signed-off-by: Jue Wang <juew@google.com>
> > ---
> >  arch/x86/kvm/lapic.c | 33 ++++++++++++++++++++++++++-------
> >  arch/x86/kvm/lapic.h |  7 ++++++-
> >  2 files changed, 32 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 2c770e4c0e6c..0b370ccd11a1 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -27,6 +27,7 @@
> >  #include <linux/math64.h>
> >  #include <linux/slab.h>
> >  #include <asm/processor.h>
> > +#include <asm/mce.h>
> >  #include <asm/msr.h>
> >  #include <asm/page.h>
> >  #include <asm/current.h>
> > @@ -364,9 +365,14 @@ static inline int apic_lvt_nmi_mode(u32 lvt_val)
> >       return (lvt_val & (APIC_MODE_MASK | APIC_LVT_MASKED)) == APIC_DM_NMI;
> >  }
> >
> > +static inline bool kvm_is_cmci_supported(struct kvm_vcpu *vcpu)
> > +{
> > +     return vcpu->arch.mcg_cap & MCG_CMCI_P;
> > +}
> > +
> >  static inline int kvm_apic_get_nr_lvt_entries(struct kvm_vcpu *vcpu)
>
> I think it makes sense to take @apic here, not @vcpu, since this is an APIC-specific
> helper.  kvm_apic_set_version() will need to be modified to not call
> kvm_apic_get_nr_lvt_entries() until after it has verified the local APIC is in-kernel,
> but IMO that's a good thing.
Ack.
>
> >  {
> > -     return KVM_APIC_MAX_NR_LVT_ENTRIES;
> > +     return KVM_APIC_MAX_NR_LVT_ENTRIES - !kvm_is_cmci_supported(vcpu);
> >  }
> >
> >  void kvm_apic_set_version(struct kvm_vcpu *vcpu)
