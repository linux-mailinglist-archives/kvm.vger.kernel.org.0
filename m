Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32E0C78896C
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 15:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245430AbjHYN5w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 09:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245477AbjHYN5b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 09:57:31 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 794142733
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 06:57:05 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-4f14865fcc0so3436e87.0
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 06:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692971820; x=1693576620; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jLAArgC/yF3W0SuXxiDWrJ5rFowVV703rxy6infsYco=;
        b=Cc0u/u6YF8b3xyiO5XIf0cEkdejK9+V+aEVLGbdwp14Bua8ggH6umEzIVrGeUI8vzi
         s3eKdAaVBOBWk/SPVtef++qSdz6Ij0eyIEdICoFr18lN0hlh1tqYeuU4aUHjwAoU+mP1
         0x3Fans2Hth5nyJ4RgaXNN85ab9WyM69Wxzea7ANLJtIG0+Z/ZwQJHsD56XRrPnsRGAh
         E2dfGdu1vbPNV55t2rVf23mDndZg2iL43Icq6dsH709F09/GinbgQDCYVlTEsPn9sbMC
         gxR4iug77eyuVa9gIfV2etPm0ASW/tQu4dupj5fikPb/Xy48gjlZ/nhedQyBLgNBO+nz
         xAcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692971820; x=1693576620;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jLAArgC/yF3W0SuXxiDWrJ5rFowVV703rxy6infsYco=;
        b=NcZLTvGMEcgz2YDlvNAFwvEOd2G8+RccUZiWOjmziQ+CWi7+I9Ee21ERp0quGuSO26
         9d2dN/1QFilnBD911NaKFUmjkE5eU1zhZVQZ3zSidyiwP6Jwr21f0x6OnEzEtIRyddHO
         NUoLMZuJpNFZEnK1GgAplIRpHtdxOLNrEpUCBVwx5uCnKLQQKPcQXu/F2+6X8U5BNQCz
         auZK0f7PqYXrKJzV4moViqupHuKKl3MIjK7DNi6EOGQrGHITGv5TSS3d5afZLPBvQv2m
         SW9kIcgws29Z02P6e3u5GgwWV+IVBbLVu03PqOYl3QRTZiyt3Oq2C/QK49pYIa1J+B7+
         yDJA==
X-Gm-Message-State: AOJu0YztdrSpcYnBt9YblLEdg4NYwn4ID2/j7Z9u4r+TFrudMQAY5wBx
        rewG+oloJ0paWKDB6H6agEQGPHc1ImHDtR+CStvBdp0wo/roY/aJhFLZcw==
X-Google-Smtp-Source: AGHT+IFn1+VuwezvxFgSzmSGg/JvxCqii0iVQ9ViNHc0q2OTp/uuY0OsuE3Aqyx0UbR1QHrGfpybQEwMEKG3wF3U4TA=
X-Received: by 2002:ac2:558e:0:b0:500:8571:9d03 with SMTP id
 v14-20020ac2558e000000b0050085719d03mr116185lfg.7.1692971820314; Fri, 25 Aug
 2023 06:57:00 -0700 (PDT)
MIME-Version: 1.0
References: <20230825022357.2852133-1-seanjc@google.com> <20230825022357.2852133-3-seanjc@google.com>
 <eb0eab09-3625-d3f2-d1bf-ef6595fb04e1@amd.com>
In-Reply-To: <eb0eab09-3625-d3f2-d1bf-ef6595fb04e1@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Fri, 25 Aug 2023 07:56:48 -0600
Message-ID: <CAMkAt6rB9a5+qu5ES4L1BnL35esSCY92+CB0fG7m6uq0Aj6z_A@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: SVM: Skip VMSA init in sev_es_init_vmcb() if
 pointer is NULL
To:     "Gupta, Pankaj" <pankaj.gupta@amd.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 25, 2023 at 4:26=E2=80=AFAM Gupta, Pankaj <pankaj.gupta@amd.com=
> wrote:
>
> On 8/25/2023 4:23 AM, Sean Christopherson wrote:
> > Skip initializing the VMSA physical address in the VMCB if the VMSA is
> > NULL, which occurs during intrahost migration as KVM initializes the VM=
CB
> > before copying over state from the source to the destination (including
> > the VMSA and its physical address).
> >
> > In normal builds, __pa() is just math, so the bug isn't fatal, but with
> > CONFIG_DEBUG_VIRTUAL=3Dy, the validity of the virtual address is verifi=
ed
> > and passing in NULL will make the kernel unhappy.
> >
> > Fixes: 6defa24d3b12 ("KVM: SEV: Init target VMCBs in sev_migrate_from")
> > Cc: stable@vger.kernel.org
> > Cc: Peter Gonda <pgonda@google.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/x86/kvm/svm/sev.c | 7 +++++--
> >   1 file changed, 5 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index acc700bcb299..5585a3556179 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -2975,9 +2975,12 @@ static void sev_es_init_vmcb(struct vcpu_svm *sv=
m)
> >       /*
> >        * An SEV-ES guest requires a VMSA area that is a separate from t=
he
> >        * VMCB page. Do not include the encryption mask on the VMSA phys=
ical
> > -      * address since hardware will access it using the guest key.
> > +      * address since hardware will access it using the guest key.  No=
te,
> > +      * the VMSA will be NULL if this vCPU is the destination for intr=
ahost
> > +      * migration, and will be copied later.
> >        */
> > -     svm->vmcb->control.vmsa_pa =3D __pa(svm->sev_es.vmsa);
> > +     if (svm->sev_es.vmsa)
> > +             svm->vmcb->control.vmsa_pa =3D __pa(svm->sev_es.vmsa);
> >
> >       /* Can't intercept CR register access, HV can't modify CR registe=
rs */
> >       svm_clr_intercept(svm, INTERCEPT_CR0_READ);
>
> Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

Reviewed-by: Peter Gonda <pgonda@google.com>
