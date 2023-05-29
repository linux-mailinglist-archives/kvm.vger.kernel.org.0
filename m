Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 026527147CB
	for <lists+kvm@lfdr.de>; Mon, 29 May 2023 12:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbjE2KQd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 06:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjE2KQc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 06:16:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA156B5
        for <kvm@vger.kernel.org>; Mon, 29 May 2023 03:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685355342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=I6zOTKZLVIZVs7nTvc3S6uGSG+ic4b7EvNT5sIrdP6c=;
        b=SefoOyMWPk3bZAqME4Mv9zn1BJPA0EKjh2xMNSCRYv3XPWpY7XjHbUSHZygg+376TD2BET
        z6VqagtrkXXx6tZcmZSysP9dEjrgM0U8FPMUHXKKjaKisfxoQiPVBZaxJ2u/bnSTws6lIg
        svasRfa8z7G2sbvM1faF6JhGWq8RV9I=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-481-ctsWbPgSMzucS7A16BRUSQ-1; Mon, 29 May 2023 06:15:40 -0400
X-MC-Unique: ctsWbPgSMzucS7A16BRUSQ-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2563afb0150so2796898a91.0
        for <kvm@vger.kernel.org>; Mon, 29 May 2023 03:15:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685355340; x=1687947340;
        h=cc:to:subject:message-id:date:in-reply-to:mime-version:references
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I6zOTKZLVIZVs7nTvc3S6uGSG+ic4b7EvNT5sIrdP6c=;
        b=QQ+a8nTgXc0xsHcpKlMnVF0ZajNyJQGraDQO4VoDGTSlWYdBM8qsxNbM+ScW3FVkMH
         BOOe+AmyOTeFrUORspaXpBvkBJBHJXJCYY/tZDIk0vigrL+uVNhrJybC1wqslMrU8hDJ
         FDjn9FidgkPjEvOch3n5ImHoLWLaDh0rfzxXyhOaxtiyA5WmtIpVzupzzv0JyIcSHSK6
         7S01XayQQHfj7f0OK3K2mmWTBge2Ne5hixzJeXIy6J5ujHp7HZ4IJQoL51sGYhdCfML6
         proFEhWEeyx7Z6zebnXYB6Ds/TWiACchwU73aIxs9AxviMMFsxFjjF+0scFOs9Tfev2h
         lw1w==
X-Gm-Message-State: AC+VfDyfZzBNFWthefqEOjaF+IW0mqz9RpITtbt7WcRQWhv0ewoZ17Mi
        Vg/CnjfA4W1D1dznr16gNOlSPjB5EBekuXEsnWR13f1c7Tw2Y5HllmaYXNOwrLrB6Wbl619Mpu4
        eKhiSOGDXs7egL//HzYCR/cmaB3Bq
X-Received: by 2002:a17:90b:164c:b0:256:78f9:3aa6 with SMTP id il12-20020a17090b164c00b0025678f93aa6mr2472967pjb.49.1685355339781;
        Mon, 29 May 2023 03:15:39 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7szqioCt+vW3aFEjHmrwH+HDuaunS1iBHf710eMgGIZCwGnJKoRb9R/+vPBVAVS6wGD99+8rT56uB7wuNc/n4=
X-Received: by 2002:a17:90b:164c:b0:256:78f9:3aa6 with SMTP id
 il12-20020a17090b164c00b0025678f93aa6mr2472946pjb.49.1685355339495; Mon, 29
 May 2023 03:15:39 -0700 (PDT)
Received: from 744723338238 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 29 May 2023 05:15:38 -0500
From:   Andrea Bolognani <abologna@redhat.com>
References: <20230428095533.21747-1-cohuck@redhat.com> <87v8gkzi5v.fsf@redhat.com>
MIME-Version: 1.0
In-Reply-To: <87v8gkzi5v.fsf@redhat.com>
Date:   Mon, 29 May 2023 05:15:38 -0500
Message-ID: <CABJz62MGU-49Ucs-CYsd2hdH8mejWtjXXBNcbs92Kx+V=T2EwA@mail.gmail.com>
Subject: Re: [PATCH v7 0/1] arm: enable MTE for QEMU + kvm
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eric Auger <eauger@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 22, 2023 at 02:04:28PM +0200, Cornelia Huck wrote:
> On Fri, Apr 28 2023, Cornelia Huck <cohuck@redhat.com> wrote:
> > Another open problem is mte vs mte3: tcg emulates mte3, kvm gives the guest
> > whatever the host supports. Without migration support, this is not too much
> > of a problem yet, but for compatibility handling, we'll need a way to keep
> > QEMU from handing out mte3 for guests that might be migrated to a mte3-less
> > host. We could tack this unto the mte property (specifying the version or
> > max supported), or we could handle this via cpu properties if we go with
> > handling compatibility via cpu models (sorting this out for kvm is probably
> > going to be interesting in general.) In any case, I think we'll need a way
> > to inform kvm of it.
>
> Before I start to figure out the initialization breakage, I think it
> might be worth pointing to this open issue again. As Andrea mentioned in
> https://listman.redhat.com/archives/libvir-list/2023-May/239926.html,
> libvirt wants to provide a stable guest ABI, not only in the context of
> migration compatibility (which we can handwave away via the migration
> blocker.)

Yeah, in order to guarantee a stable guest ABI it's critical that
libvirt can ask for a *specific* version of MTE (MTE or MTE3) and
either get exactly that version, or an error on QEMU's side.

> The part I'm mostly missing right now is how to tell KVM to not present
> mte3 to a guest while running on a mte3 capable host (i.e. the KVM
> interface for that; it's more a case of "we don't have it right now",
> though.) I'd expect it to be on the cpu level, rather than on the vm
> level, but it's not there yet; we also probably want something that's
> not fighting whatever tcg (or other accels) end up doing.
>
> I see several options here:
> - Continue to ignore mte3 and its implications for now. The big risk is
>   that someone might end up implementing support for MTE in libvirt again,
>   with the same stable guest ABI issues as for this version.
> - Add a "version" qualifier to the mte machine prop (probably with
>   semantics similar to the gic stuff), with the default working with tcg
>   as it does right now (i.e. defaulting to mte3). KVM would only support
>   "no mte" or "same as host" (with no stable guest ABI guarantees) for
>   now. I'm not sure how hairy this might get if we end up with a per-cpu
>   configuration of mte (and other features) with kvm.
> - Add cpu properties for mte and mte3. I think we've been there before
>   :) It would likely match any KVM infrastructure well, but we gain
>   interactions with the machine property. Also, there's a lot in the
>   whole CPU model area that need proper figuring out first... if we go
>   that route, we won't be able to add MTE support with KVM anytime soon,
>   I fear.
>
> The second option might be the most promising, except for potential
> future headaches; but a lot depends on where we want to be going with
> cpu models for KVM in general.

What are the arguments for/against making MTE a machine type option
or CPU feature flag? IIUC on real hardware you get "mte" or "mte3"
listed in /proc/cpuinfo, so a CPU feature would seem a pretty natural
fit to me, but I seem to recall that Peter was pushing for keeping it
a machine property instead.

Working off the assumption that Peter knows what he's doing :) can we
do something like this?

  * introduce a new machine type property mte-version, which accepts
    either a specific version (2 for MTE and 3 for MTE3), an abstract
    setting (max and host) or a way to disable MTE entirely (none);

  * turn the existing mte machine type option into an alias with the
    mapping

      mte=off -> mte-version=none
      mte=on  -> mte-version=max  for TCG
      mte=on  -> mte-version=host for KVM

    and deprecate it;

  * optionally introduce a new QMP command query-mte-capabilities
    that can be used by libvirt to figure out ahead of time which MTE
    versions are available for use on the current hardware.

Yes, this is basically a shameless rip-off of how GIC is handled :)
I'm pretty satisfied with how that works and see no reason to
reinvent the wheel.

Note that it's perfectly fine if the lack of KVM-level APIs results
in mte-version=2 being rejected on MTE3-capable hardware for now!
What's important is that you don't get a different MTE version than
what you asked for. I assume that the existing KVM API for enabling
MTE have good enough granularity to make this work? If not, that's
going to be a problem :)

-- 
Andrea Bolognani / Red Hat / Virtualization

