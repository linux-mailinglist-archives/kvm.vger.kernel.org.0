Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 365CF720B32
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 23:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236636AbjFBVt6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 17:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236585AbjFBVtu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 17:49:50 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10DD1B5
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 14:49:48 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5651d8acfe2so38903847b3.2
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 14:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685742588; x=1688334588;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nefBGxsNaEMoqb2mC8n3j2OvjLQc0K598TL3kgSXzFU=;
        b=aurBhqbKeOJz/AyMRAeO/7yWA5uxveScJZDdPbJybfzRJXg5iNEY5FZtEV7uSUvzCU
         PtiChI5pW/pP6OFoY63g3yXEQyjmcXN2hwcZpKKkWFZvcEXYFOkXFWlbLPW29jRLfKQb
         +u4blAhi4jofaqKLqN8X27ittdB8oe0nXaYmbQjzTXdwQSFkywSd5Otp5phYr6G78xao
         IYKc3WsSxqVyRJZqSylJOpBqoyF0QXpgXt0GZwK98gzhGpF1vKze4/wrmShW8+ZlueOz
         oeZZTRIS1SIRWW60Bdq5uVIv2M4e5yHlD8HQUTXXJAj9oMGDGTniLJfqvMbpRV+8l4yD
         opVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685742588; x=1688334588;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nefBGxsNaEMoqb2mC8n3j2OvjLQc0K598TL3kgSXzFU=;
        b=V4T3QqVuCl62qpHnWFPIWwhFA2iiPxnat5RhoMCASZ+byG6G+sq47z5/+EcT52+fIu
         XPNLwXwNuVm/ZTL451bJLJpPcfIm7SSBBj85jH6UtLVEMzlL1667QFrxBx9/yhjeY6fl
         RpctwKsTEESK7ZgFth+fCFJttgZVaRdGq02zInAtK5+rWnsEEHSSGK3wyfw/FZDKzVTd
         m0vxh7/jzyazc4komv4ZO8shXeR6jXwWdViFarDORIayq6JkkTVx6E3WKPKxKY7CMOow
         Yw0SNCehRE6HQjC4WUs3lCjXr14PDhTgm1ZZaqeQfRVn2VtBP2RWEmOE68QUcyswqOEu
         /sRA==
X-Gm-Message-State: AC+VfDxgVXQI0j+8E/ayaVBmoQea8RvonsdmRGKgsNgnnXjN9G7CVQEC
        DE0o/LrFO2T4J805KrONCRVFglOS2Y4=
X-Google-Smtp-Source: ACHHUZ5egV/UIPDs3RgIUBEXXI8beMvTpFWkwRh8/lCmke0ndg+wwSUO5jvBndae09dX3oizTe2mi7Dhp9M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:af64:0:b0:559:f161:f052 with SMTP id
 x36-20020a81af64000000b00559f161f052mr639983ywj.2.1685742588103; Fri, 02 Jun
 2023 14:49:48 -0700 (PDT)
Date:   Fri, 2 Jun 2023 14:49:46 -0700
In-Reply-To: <CALMp9eTtkBL3Fb7Dq60go6CL+zGODNn0TTavr436Q-+=mpVFMA@mail.gmail.com>
Mime-Version: 1.0
References: <20230602010550.785722-1-seanjc@google.com> <C8324338-FC07-454E-9A5A-1785141FEAB3@nutanix.com>
 <CALMp9eTtkBL3Fb7Dq60go6CL+zGODNn0TTavr436Q-+=mpVFMA@mail.gmail.com>
Message-ID: <ZHpj+j5Cs1vOXgyP@google.com>
Subject: Re: [PATCH] KVM: x86: Use cpu_feature_enabled() for PKU instead of #ifdef
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Jon Kohler <jon@nutanix.com>, Mingwei Zhang <mizhang@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 02, 2023, Jim Mattson wrote:
> On Fri, Jun 2, 2023 at 8:51=E2=80=AFAM Jon Kohler <jon@nutanix.com> wrote=
:
> > > On Jun 1, 2023, at 9:05 PM, Sean Christopherson <seanjc@google.com> w=
rote:
> > > @@ -1032,15 +1030,13 @@ void kvm_load_host_xsave_state(struct kvm_vcp=
u *vcpu)
> > >       if (vcpu->arch.guest_state_protected)
> > >               return;
> > >
> > > -#ifdef CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS
> > > -     if (static_cpu_has(X86_FEATURE_PKU) &&
> > > +     if (cpu_feature_enabled(X86_FEATURE_PKU) &&
> > >           ((vcpu->arch.xcr0 & XFEATURE_MASK_PKRU) ||
> > >            kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE))) {
> > >               vcpu->arch.pkru =3D rdpkru();
> > >               if (vcpu->arch.pkru !=3D vcpu->arch.host_pkru)
> > >                       write_pkru(vcpu->arch.host_pkru);
> > >       }
> > > -#endif /* CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS */
> > >
> > >       if (kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE)) {
> > >
> > >
> > > base-commit: a053a0e4a9f8c52f3acf8a9d2520c4bf39077a7e
> > > --
> > > 2.41.0.rc2.161.g9c6817b8e7-goog
> > >
> >
> > Thanks for the cleanup!
> >
> > Reviewed-by: Jon Kohler <jon@nutanix.com>
>=20
> +Mingwei Zhang
>=20
> As we move towards enabling PKRU on the host, due to some customer
> requests, I have to wonder if PKRU-disabled is the norm.
>=20
> In other words, is this a likely() or unlikely() optimization?

Neither?  I don't see any reason to speculate on guest state.  I'll bet dol=
lars
to donuts that adding (un)likely() is negligible in terms of performance.
