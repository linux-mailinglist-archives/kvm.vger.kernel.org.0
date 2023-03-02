Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8A486A83C0
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 14:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjCBNqm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 08:46:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjCBNqe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 08:46:34 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 399AC30B24
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 05:46:33 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id d10so9779596pgt.12
        for <kvm@vger.kernel.org>; Thu, 02 Mar 2023 05:46:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1677764792;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cM7TzUwUKWR4y9CA6zT0N19JDajlnCxNNv+rZjI3jU0=;
        b=RPEI9CIA+B2o7WiblhF5NPDc2nC/JJFNkzjuaz3rs4AI+lXgoTmWeAlxkCdEUYUyjI
         jWBbk7xN0lZmC5Ej5VVNA2Hjryx54P6FrHoxwrNdlC9Q9cUp4h3vNMnWFD5L4pYJCnOk
         1Ia4+NiRDIgNbk8jL+YvDSHYyTwlRHD7T1RAfus+nOSBKfMLz2lVJ0jrTRqxA5g9oyl+
         ut8ECenWFn6vyoDsxkJXlJp1M8EV//zzbSDIyVHIorDINBvKxPdNbAU2O3MTLF8FXgP7
         OoXsyFApu5N/JXBMEeBT45cSX9QaKD3TT3VlFvPVMYNyFgzd347hI6VGybHxMuRsVOXF
         ZzgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677764792;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cM7TzUwUKWR4y9CA6zT0N19JDajlnCxNNv+rZjI3jU0=;
        b=eqUj8sEtEdaFAQWgTJ8s4DoZuQDHjHylrqhYkmNjYN8eVoyO7+20i3+FUyvamTNauq
         gziAVL2OoUynbGMwlQhJevzi026zSPuYsP+W+PBS5k1MC/NSrjKu3El/wN+bSV0E2xzK
         SRuKgPtk0nGo/gT85RNI55yltIcME7f1f4I2cXyw1r3orobhvT83cL7nZ04RKdzfLAnW
         saMGYT6jdp11aJ4s/Amgy1god0GVEcmK6AQHqjfx0Kt7wDA3lTa4OmifywHSufYunN6n
         9z84sdAwbYPQpHjWyKaqoYZC2Cd7rZ8ajejLHUVsNypwdfFvnetcUZDLs0gXe8iJTSKZ
         8o0g==
X-Gm-Message-State: AO0yUKVydwUNu2B9s7Z4i7fROweM3823ChvBh9dcIItZ1fxtZf5hpTXe
        ynw2XtleteLioZM7MS7iyfdTdfwEfQQJVp9QTuEqDw==
X-Google-Smtp-Source: AK7set/dl7f2rYmWWps//hBcKx4f/seag4m+W/Six6d6T6rlDaPFhRWNnbSLt73/CG8RFHanRYThvzelzG8uc51/18E=
X-Received: by 2002:a63:385e:0:b0:503:77ce:a1ab with SMTP id
 h30-20020a63385e000000b0050377cea1abmr1958699pgn.9.1677764792634; Thu, 02 Mar
 2023 05:46:32 -0800 (PST)
MIME-Version: 1.0
References: <20230228150216.77912-1-cohuck@redhat.com> <20230228150216.77912-2-cohuck@redhat.com>
 <CABJz62OHjrq_V1QD4g4azzLm812EJapPEja81optr8o7jpnaHQ@mail.gmail.com>
 <874jr4dbcr.fsf@redhat.com> <CABJz62MQH2U1QM26PcC3F1cy7t=53_mxkgViLKjcUMVmi29w+Q@mail.gmail.com>
 <87sfeoblsa.fsf@redhat.com>
In-Reply-To: <87sfeoblsa.fsf@redhat.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Thu, 2 Mar 2023 13:46:21 +0000
Message-ID: <CAFEAcA8z9mS55oBySDYA6PHB=qcRQRH1Aa4WJidG8B=n+6CyEQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] arm/kvm: add support for MTE
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Andrea Bolognani <abologna@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, qemu-arm@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eric Auger <eauger@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 1 Mar 2023 at 14:15, Cornelia Huck <cohuck@redhat.com> wrote:
>
> On Wed, Mar 01 2023, Andrea Bolognani <abologna@redhat.com> wrote:
>
> > On Wed, Mar 01, 2023 at 11:17:40AM +0100, Cornelia Huck wrote:
> >> On Tue, Feb 28 2023, Andrea Bolognani <abologna@redhat.com> wrote:
> >> > On Tue, Feb 28, 2023 at 04:02:15PM +0100, Cornelia Huck wrote:
> >> >> +MTE CPU Property
> >> >> +================
> >> >> +
> >> >> +The ``mte`` property controls the Memory Tagging Extension. For TCG, it requires
> >> >> +presence of tag memory (which can be turned on for the ``virt`` machine via
> >> >> +``mte=on``). For KVM, it requires the ``KVM_CAP_ARM_MTE`` capability; until
> >> >> +proper migration support is implemented, enabling MTE will install a migration
> >> >> +blocker.
> >> >
> >> > Is it okay to use -machine virt,mte=on unconditionally for both KVM
> >> > and TCG guests when MTE support is requested, or will that not work
> >> > for the former?
> >>
> >> QEMU will error out if you try this with KVM (basically, same behaviour
> >> as before.) Is that a problem for libvirt, or merely a bit inconvinient?
> >
> > I'm actually a bit confused. The documentation for the mte property
> > of the virt machine type says
> >
> >   mte
> >     Set on/off to enable/disable emulating a guest CPU which implements
> >     the Arm Memory Tagging Extensions. The default is off.
> >
> > So why is there a need to have a CPU property in addition to the
> > existing machine type property?
>
> I think the state prior to my patches is actually a bit confusing: the
> user needs to set a machine type property (causing tag memory to be
> allocated), which in turn enables a cpu feature. Supporting the machine
> type property for KVM does not make much sense IMHO: we don't allocate
> tag memory for KVM (in fact, that would not work). We have to keep the
> previous behaviour, and explicitly instructing QEMU to create cpus with
> a certain feature via a cpu property makes the most sense to me.

This isn't really how the virt board does any other of these
properties, though: secure=on/off and virtualization=on/off also
both work by having a board property that sets up the board related
parts and also sets the CPU property appropriately.

I think having MTE in the specific case of KVM behave differently
to how we've done all these existing properties and how we've
done MTE for TCG would be confusing. The simplest thing is to just
follow the existing UI for TCG MTE.

The underlying reason for this is that MTE in general is not a feature
only of the CPU, but also of the whole system design. It happens
that KVM gives us tagged RAM "for free" but that's an oddity
of the KVM implementation -- in real hardware there needs to
be system level support for tagging.

thanks
-- PMM
