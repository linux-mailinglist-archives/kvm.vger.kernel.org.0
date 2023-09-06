Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E447794489
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 22:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244416AbjIFU3Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 16:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbjIFU3X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 16:29:23 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D8C31BC5
        for <kvm@vger.kernel.org>; Wed,  6 Sep 2023 13:29:12 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id 2adb3069b0e04-4f14865fcc0so958e87.0
        for <kvm@vger.kernel.org>; Wed, 06 Sep 2023 13:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694032150; x=1694636950; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u1tlMNe6P+SoHizV0ZMopCCCIGPz74BBXUDpqPFOlrQ=;
        b=VoEN6Bc8eI0939Jklr1N/q0v5gwO9Wz+/e8NPfntJQUyuEmPl4GTRvi4UdnF6BtNc1
         K08ix9yDnZjhPbQcnKZazmZ7MwqO3xXpuyc4HVSKtohBI8HevMJXX/K9mhJo3OmEgbEB
         UlRBzoRgFQlEzHl0Xkv8SDhj3QH7MOrFHdlXDZcwqjLFQEuZ2QE5fUeuKTCbfBUA61TB
         gIBC+uigHUforaM7nWVbGh1LvEmdQzcNqG60M/rPAP5xW2Q1dVfFbcZBrTugLnGK4bdN
         vJSt68peJi7H2bu3ZAh4xGhIdNQDR0Peu1rqhNieYdYxvlA/jZrKTI0dFwnzTWhtzV/N
         AWiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694032150; x=1694636950;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u1tlMNe6P+SoHizV0ZMopCCCIGPz74BBXUDpqPFOlrQ=;
        b=UmiJ2R0pwZwMArtOkWTV8KiI0wtmsTXZV4iQl20yKBn/i5xyKq8XRSloKyChQ7jAum
         MEfNY1aZYF9tO5Qq1BiEGK9ke/mB1QuokTIz6SddFVev9h0+XXDAemVpqN3CCsEOToq4
         LabpQ1TX1dkstx7GvfRXTMYaabbYOnycV7H6WFjGecIiBwkGTdrcNkP1GR1PDvG2i//a
         LWIT3dsCFvrSBqqetm4Lo/s1NBlhP6Az+oylYj011ctYvoPB9ORkBahobNskiAcTHgqT
         5/3OHqXSIpAsW5Rn+G2W8MBMS7b2p5n8cvWHZFldp7qRAn/2kNFFcVzuU+HbRH7jbLLH
         YLmA==
X-Gm-Message-State: AOJu0YzrLavdQrxr6y5G7jzDkEwX08sLMrzsBngGN465cOnaHoTroYAz
        jhcMTiHqUqMWaQjZ9eZQJ3IAyH5HtT5thE/Nrmc1LA==
X-Google-Smtp-Source: AGHT+IF0qwICN0OULzMVz0QSiGIgwDuU3npgPxlcvk2yZ90NesAAG+1ogY0DdXCdOuaMGZyz9pBGwIvQY4ENlmiNW8M=
X-Received: by 2002:a19:c20c:0:b0:501:90dd:be8e with SMTP id
 l12-20020a19c20c000000b0050190ddbe8emr18060lfc.5.1694032150482; Wed, 06 Sep
 2023 13:29:10 -0700 (PDT)
MIME-Version: 1.0
References: <20230906151449.18312-1-pgonda@google.com> <68a44c6d-21c9-30c2-b0cf-66f02f9d2f4e@amd.com>
 <ZPjc/PoBLPNNLukt@google.com> <249694b0-2afd-f653-a443-124e510f4a4c@amd.com> <ZPjgaKoF9jVS/ATx@google.com>
In-Reply-To: <ZPjgaKoF9jVS/ATx@google.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Wed, 6 Sep 2023 14:28:58 -0600
Message-ID: <CAMkAt6p2T8OfnUcqcw8Kvq195VnxQoaAwdetuouMdE1NvjO5Uw@mail.gmail.com>
Subject: Re: [PATCH V2] KVM: SEV: Update SEV-ES shutdown intercepts with more metadata
To:     Sean Christopherson <seanjc@google.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 6, 2023 at 2:26=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Wed, Sep 06, 2023, Tom Lendacky wrote:
> > On 9/6/23 15:11, Sean Christopherson wrote:
> > > On Wed, Sep 06, 2023, Tom Lendacky wrote:
> > > > On 9/6/23 10:14, Peter Gonda wrote:
> > > > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > > > index 956726d867aa..cecf6a528c9b 100644
> > > > > --- a/arch/x86/kvm/svm/svm.c
> > > > > +++ b/arch/x86/kvm/svm/svm.c
> > > > > @@ -2131,12 +2131,14 @@ static int shutdown_interception(struct k=
vm_vcpu *vcpu)
> > > > >          * The VM save area has already been encrypted so it
> > > > >          * cannot be reinitialized - just terminate.
> > > > >          */
> > > > > -       if (sev_es_guest(vcpu->kvm))
> > > > > -               return -EINVAL;
> > > > > +       if (sev_es_guest(vcpu->kvm)) {
> > > > > +               kvm_run->exit_reason =3D KVM_EXIT_SHUTDOWN;
> > > > > +               return 0;
> > > > > +       }
> > > >
> > > > Just a nit... feel free to ignore, but, since KVM_EXIT_SHUTDOWN is =
also set
> > > > at the end of the function and I don't think kvm_vcpu_reset() clear=
s the
> > > > value from kvm_run, you could just set kvm_run->exit_reason on entr=
y and
> > > > just return 0 early for an SEV-ES guest.
> > >
> > > kvm_run is writable by userspace though, so KVM can't rely on kvm_run=
->exit_reason
> > > for correctness.
> > >
> > > And IIUC, the VMSA is also toast, i.e. doing anything other than mark=
ing the VM
> > > dead is futile, no?
> >
> > I was just saying that "kvm_run->exit_reason =3D KVM_EXIT_SHUTDOWN;" is=
 in the
> > shutdown_interception() function twice now (at both exit points of the
> > function) and can probably just be moved to the top of the function and=
 be
> > common for both exit points, now, right?
> >
> > I'm not saying to get rid of it, just set it sooner.
>
> Ah, I thought you were saying bail early from kvm_vcpu_reset().  I agree =
that not
> having completely split logic would be ideal.  What about this?
>
>         /*
>          * VMCB is undefined after a SHUTDOWN intercept.  INIT the vCPU t=
o put
>          * the VMCB in a known good state.  Unfortuately, KVM doesn't hav=
e
>          * KVM_MP_STATE_SHUTDOWN and can't add it without potentially bre=
aking
>          * userspace.  At a platform view, INIT is acceptable behavior as
>          * there exist bare metal platforms that automatically INIT the C=
PU
>          * in response to shutdown.
>          *
>          * The VM save area for SEV-ES guests has already been encrypted =
so it
>          * cannot be reinitialized, i.e. synthesizing INIT is futile.
>          */
>         if (!sev_es_guest(vcpu->kvm)) {
>                 clear_page(svm->vmcb);
>                 kvm_vcpu_reset(vcpu, true);
>         }
>
>         kvm_run->exit_reason =3D KVM_EXIT_SHUTDOWN;
>         return 0;

Looks better to me. Thanks!
