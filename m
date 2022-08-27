Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A251E5A38EA
	for <lists+kvm@lfdr.de>; Sat, 27 Aug 2022 18:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233655AbiH0QzB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Aug 2022 12:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbiH0Qy7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Aug 2022 12:54:59 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98EEF25294
        for <kvm@vger.kernel.org>; Sat, 27 Aug 2022 09:54:56 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id t140so5717035oie.8
        for <kvm@vger.kernel.org>; Sat, 27 Aug 2022 09:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=2PKxcqSiq+Wi8toMC3SKuzn+e1vjHoNl5VKdMZbjbyo=;
        b=Uw00xRqLOZi2ywzANeGmio6hEmsoNdyWeW8eHXkDL57oS7oatSpIfagMsyBCbvTV/y
         DC2zb+kL/+EOXM+1F9QuOlZpEzH3As+E7ndl2OXQK/eYyA/ouqdRX2VIC/hNzhMvNyH6
         4vZPSQBQ2zBjOi/EF+aohswcUqBQ+GqaPOAkPQXCksKiCR1QANUKy7SN5GhAWA3xes1b
         mTxwInUJ35KRN+bWSPEcUG/f+f8bV2Vw75Qa0DfAJrNlmG0FnsU+9BqKcDU7dgIUIakH
         ZtFj8jwssWOH446S0eqXQO77pxpx7MgIn99ZV98A9JqKUnVITepfVCnO4ehkTR0dJSA1
         ATbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=2PKxcqSiq+Wi8toMC3SKuzn+e1vjHoNl5VKdMZbjbyo=;
        b=qHs9LEZv4K2Ut2wjEGaFIS9KzUSRzo7RL5ZIQ7beVgPmqNaT8nUBZALi7i2XeLdhsg
         U0Gk1ZLlNPExA3M74Q/F+U/a6DHatHXYA7BPBtaJ86SapF66YbO3gacruga2j/ZoGdco
         ZrzvQksOWZ7l2V/EtEadFIM5Lyo7c+XdYzaXnSjmig1V93Y4a/U2u4wRgbh12c+4GFID
         Z1CJNCHPkPWtQAUUojbWJGBDAEjn6vPYjImAVPLuT1oXPaQYBHcfoPchbxcAsEWFQ2iw
         2lmACPPmdJOB9fayRuCDxRDG0VmhGLA//cAIQo7V+VjeisqSrhLq2MEy3ym+icFpe2Ou
         dm7Q==
X-Gm-Message-State: ACgBeo2yFfWJDvs7mN0DsD8rWdgRPODT0uQxISUr/Bsmqm/k4POy7pIk
        LKSZKVCMiIz2dJHkwQqVTWvtTUp2XqOMvZAi2YB1hg==
X-Google-Smtp-Source: AA6agR6N6ukgmk9PS/TpzgujUuK7TGVPgl9UU9jBUruia4ZEO0iXm6lK2mg4z4nqZNlgEkESWUeOgETwvf67xe1m50g=
X-Received: by 2002:aca:170f:0:b0:343:171f:3596 with SMTP id
 j15-20020aca170f000000b00343171f3596mr3738809oii.181.1661619295759; Sat, 27
 Aug 2022 09:54:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220826224755.1330512-1-jmattson@google.com> <CAHVum0ewJAF2W+x_ycrrcD2Lyttx8VSydbzPmY+TFeWer9OJmg@mail.gmail.com>
In-Reply-To: <CAHVum0ewJAF2W+x_ycrrcD2Lyttx8VSydbzPmY+TFeWer9OJmg@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Sat, 27 Aug 2022 09:54:45 -0700
Message-ID: <CALMp9eT7rdyw9mfKdfT_gz9z41RA5-FXQZ2vJgiMHDM=p-WBJQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Mask off unsupported and unknown bits of IA32_ARCH_CAPABILITIES
To:     Vipin Sharma <vipinsh@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
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

On Fri, Aug 26, 2022 at 4:12 PM Vipin Sharma <vipinsh@google.com> wrote:
>
> On Fri, Aug 26, 2022 at 3:48 PM Jim Mattson <jmattson@google.com> wrote:
> >
> > KVM should not claim to virtualize unknown IA32_ARCH_CAPABILITIES
> > bits. When kvm_get_arch_capabilities() was originally written, there
> > were only a few bits defined in this MSR, and KVM could virtualize all
> > of them. However, over the years, several bits have been defined that
> > KVM cannot just blindly pass through to the guest without additional
> > work (such as virtualizing an MSR promised by the
> > IA32_ARCH_CAPABILITES feature bit).
> >
> > Define a mask of supported IA32_ARCH_CAPABILITIES bits, and mask off
> > any other bits that are set in the hardware MSR.
> >
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Fixes: 5b76a3cff011 ("KVM: VMX: Tell the nested hypervisor to skip L1D flush on vmentry")
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > ---
> >  arch/x86/kvm/x86.c | 25 +++++++++++++++++++++----
> >  1 file changed, 21 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 205ebdc2b11b..ae6be8b2ecfe 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -1557,12 +1557,32 @@ static const u32 msr_based_features_all[] = {
> >  static u32 msr_based_features[ARRAY_SIZE(msr_based_features_all)];
> >  static unsigned int num_msr_based_features;
> >
> > +/*
> > + * IA32_ARCH_CAPABILITIES bits deliberately omitted are:
>
> Why are these deliberately omitted? Maybe a comment will help future
> readers and present ones like me who don't know.

All of these bits require KVM to virtualize an MSR not currently
virtualized. I'll add a comment to that effect.

Note that some trivially virtualizable bits are also omitted simply
because there are no macros defined for them in msr-index.h. I have
said nothing about those.

> > + *   10 - MISC_PACKAGE_CTRLS
> > + *   11 - ENERGY_FILTERING_CTL
> > + *   12 - DOITM
> > + *   18 - FB_CLEAR_CTRL
> > + *   21 - XAPIC_DISABLE_STATUS
> > + *   23 - OVERCLOCKING_STATUS
> > + */
> > +
> > +#define KVM_SUPPORTED_ARCH_CAP \
> > +       (ARCH_CAP_RDCL_NO | ARCH_CAP_IBRS_ALL | ARCH_CAP_RSBA | \
> > +        ARCH_CAP_SKIP_VMENTRY_L1DFLUSH | ARCH_CAP_SSB_NO | ARCH_CAP_MDS_NO | \
> > +        ARCH_CAP_PSCHANGE_MC_NO | ARCH_CAP_TSX_CTRL_MSR | ARCH_CAP_TAA_NO | \
> > +        ARCH_CAP_SBDR_SSDP_NO | ARCH_CAP_FBSDP_NO | ARCH_CAP_PSDP_NO | \
> > +        ARCH_CAP_FB_CLEAR | ARCH_CAP_RRSBA | ARCH_CAP_PBRSB_NO)
> > +
> > +
>
> Nit: Extra blank line.
>
> >  static u64 kvm_get_arch_capabilities(void)
> >  {
> >         u64 data = 0;
> >
> > -       if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))
> > +       if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES)) {
> >                 rdmsrl(MSR_IA32_ARCH_CAPABILITIES, data);
> > +               data &= KVM_SUPPORTED_ARCH_CAP;
> > +       }
> >
> >         /*
> >          * If nx_huge_pages is enabled, KVM's shadow paging will ensure that
> > @@ -1610,9 +1630,6 @@ static u64 kvm_get_arch_capabilities(void)
> >                  */
> >         }
> >
> > -       /* Guests don't need to know "Fill buffer clear control" exists */
> > -       data &= ~ARCH_CAP_FB_CLEAR_CTRL;
> > -
> >         return data;
> >  }
> >
> > --
> > 2.37.2.672.g94769d06f0-goog
> >
>
> Verified, at least all the capabilities in the
> kvm_get_arch_capabilities() are in the KVM_SUPPORTED_ARCH_CAP macro.
>
> Reviewed-By: Vipin Sharma <vipinsh@google.com>
