Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC2B46B91DC
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 12:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbjCNLlu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 07:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231455AbjCNLls (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 07:41:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C3DA9BE1E
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 04:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678794051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nvUKdBCqtDsCDJokDequ8gIlKpdN3GQsgjjeCWrl9fk=;
        b=bUuruULo57o8+2WUi5O3vx5z7z1IHJtgbFujRFgpGWUpFtYtLu6bXjFV5uIJMXp2N1FJX6
        wnB/jUcMrnx7ccC7w6H2GxBjp3zYMPXIcdmdQxGmvVqHxny5JBdjyk5wXduMFY9RIAZEFA
        E+O3Na4mH5SYIKTQCQl5V+kcwj4geQw=
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com
 [209.85.217.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-396-yailZkd6PcK42olm1M4ARA-1; Tue, 14 Mar 2023 07:40:50 -0400
X-MC-Unique: yailZkd6PcK42olm1M4ARA-1
Received: by mail-vs1-f70.google.com with SMTP id i21-20020a05610221b500b004258d5ee8c4so1821110vsb.0
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 04:40:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678794050;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nvUKdBCqtDsCDJokDequ8gIlKpdN3GQsgjjeCWrl9fk=;
        b=rAm4clPIppSXi1nSXJghSrF9DMP+ROkt3eu0r2OiN7UH9T5YzZy08BRXSy4wMQ5lIg
         Q35I6PDln7jbfFdhzfUSZfcQduLGunlvL8WczUQhXrQd+c97Mu/GOf2dNbElWzpfzisS
         sq+obscsJb4BqCqyNcx/PSWXK2bsoxOxQgdL3l9vTcz8vyhL4iKrgPMxtYwC013B46lD
         4LTeuZ99fNVPZqZJERzO6qF2cFz9m3zdgsAaq0+tCjWob4iqVl8c4xwghIOXi+3Wkb+x
         3rIMruMZjLYLChkkXajD1K2v8fVyaic5YDuboV+1hkHbU9TgGZpjpnOrxj4G47IxLNal
         N52w==
X-Gm-Message-State: AO0yUKV1lPr+W0zU6PbFoGoDlQ+3WdjI2bfKbTlNgrb/5HckVabaYLYv
        VwetoCbF59963XF11Ei3t0H+I9q2wIzSSLgBNstCEqZrDdsblrMZ98dhV1ZQxtAMoIy9fNDXLDf
        3uf0zFOWAyyVQBbuRhhBAxiwOgL4r
X-Received: by 2002:a67:d08c:0:b0:425:a3a9:a6e8 with SMTP id s12-20020a67d08c000000b00425a3a9a6e8mr1680164vsi.1.1678794050023;
        Tue, 14 Mar 2023 04:40:50 -0700 (PDT)
X-Google-Smtp-Source: AK7set8m2YHyzZwKxEeDVZaI9vGT3421ek6caI5yO0ukBXyVOVG8nEWdZx1OXuEsVVYm6GXhA2bwA99fmZZJcza4we0=
X-Received: by 2002:a67:d08c:0:b0:425:a3a9:a6e8 with SMTP id
 s12-20020a67d08c000000b00425a3a9a6e8mr1680153vsi.1.1678794049787; Tue, 14 Mar
 2023 04:40:49 -0700 (PDT)
MIME-Version: 1.0
References: <20230310234304.2908714-1-pbonzini@redhat.com> <ZAvGjCqfKgsSEQhZ@google.com>
In-Reply-To: <ZAvGjCqfKgsSEQhZ@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Tue, 14 Mar 2023 12:40:38 +0100
Message-ID: <CABgObfbwAe3ut18bS2u05pAgDoUvix_N9LKMb1iBcx8xNd9dMQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: nVMX: add missing consistency checks for CR0 and CR4
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Reima ISHII <ishiir@g.ecc.u-tokyo.ac.jp>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Mar 11, 2023 at 1:17=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
> > @@ -3047,6 +3047,19 @@ static int nested_vmx_check_guest_state(struct k=
vm_vcpu *vcpu,
> >                                          vmcs12->guest_ia32_perf_global=
_ctrl)))
> >               return -EINVAL;
> >
> > +     if (CC((vmcs12->guest_cr0 & (X86_CR0_PG | X86_CR0_PE)) =3D=3D X86=
_CR0_PG))
> > +             return -EINVAL;
> > +
> > +#ifdef CONFIG_X86_64
>
> The #ifdef isn't necessary, attempting to set for a 32-bit host should be=
 rejected
> by nested_vmx_check_controls() since nested_vmx_setup_ctls_msrs() clears =
the bit.
> Ditto for the host logic related to VM_EXIT_HOST_ADDR_SPACE_SIZE, which l=
ooks
> suspiciously similar ;-)

Yeah, I noticed that too and decided that the idea could have been to
allow some dead code elimination on 32-bit kernels, so I copied what
the host state checks were doing. But if you prefer the more compact
way I am absolutely not going to complain.

> > +     if (CC(ia32e &&
> > +            (!(vmcs12->guest_cr4 & X86_CR4_PAE) ||
> > +             !(vmcs12->guest_cr0 & X86_CR0_PG))))
> > +             return -EINVAL;
>
> This is a lot easier to read IMO, and has the advantage of more precisely
> identifying the failure in the tracepoint.
>
>         if (CC(ia32e && !(vmcs12->guest_cr4 & X86_CR4_PAE)) ||
>             CC(ia32e && !(vmcs12->guest_cr4 & X86_CR0_PG)))
>                 return -EINVAL;

Looks good.  I squashed everything in.

Paolo

