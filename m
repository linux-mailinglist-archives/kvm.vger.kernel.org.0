Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E61E86A6EDD
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 15:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbjCAOzW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 09:55:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbjCAOzM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 09:55:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ECF93B0D9
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 06:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677682453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hWNCgXdqBl1EHkw9a463OBU72rcKYVy1UAU7KZqXFjc=;
        b=MrNQ5AG3IzMyC017opmX4SWcnibFkviJwvwXjy0N6bXVsTf4bY7MSWMXP4FYnaPipeJF3W
        yFaDJl14cPRBYka2Dp0Hc8zEGKW23Vrm3FgWHwWtJDL1LzSbsdoD1uESrHJLuA3D8gh+53
        8VdnraV/o0IEcXXF+7Vy+uEWQav/FqM=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-515-Zm-zrxDpNsOU2PWNyqwcTA-1; Wed, 01 Mar 2023 09:54:12 -0500
X-MC-Unique: Zm-zrxDpNsOU2PWNyqwcTA-1
Received: by mail-pf1-f200.google.com with SMTP id bx9-20020a056a00428900b005f077bc6e5eso5820572pfb.16
        for <kvm@vger.kernel.org>; Wed, 01 Mar 2023 06:54:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:in-reply-to:mime-version:references
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hWNCgXdqBl1EHkw9a463OBU72rcKYVy1UAU7KZqXFjc=;
        b=bi49wOCfiPF73XgGazebchMk4AE1rL7RLoUFZTZx3iMA/MOUmdKm82a5gOe1n/sowj
         TuTq4nJSQL1iObr7nU7I+hdI1pfqQU0znu98KNueQeR2Ol/Xe6frIofCT79j+pKMc0Lf
         eI61abRH9FOsJCd5qTGrjBT0w56xWHDHjyu2hJszZFJfc6eAAGOs3GkkSF8OqH0PMb5m
         VeRRJk5dixJ4bsZPG9oWUNLc4e8o0FRijEfGLTrVH5SIl4jSNb2q4jY3U7tCZQUZOj7Z
         jkPC16UBqRF8Y4sCIN0YdWemuLlL+zdSMXMyVwPwVuuLRYyjipPY5mCanT4DuCP5yTof
         JFxA==
X-Gm-Message-State: AO0yUKWnovF69grXUrDEip34StiWa2Ko0UB0tIuxep8E7w//aRZjgMY+
        QTMzJ//Cf9t7cwU+ge8CDH/RPqti7x7MJy08D15Le9vykB7DRfGKsdU+9u1crIgmOZ4vNzgdD1o
        aHeKSW8PT2eN6I7KQ5D+C6RCeLQnS
X-Received: by 2002:a62:8281:0:b0:5df:9809:6220 with SMTP id w123-20020a628281000000b005df98096220mr2649485pfd.3.1677682451391;
        Wed, 01 Mar 2023 06:54:11 -0800 (PST)
X-Google-Smtp-Source: AK7set8AiQ0Z+/wGHQyI0AWyso+wjGffpjfQNHEZG705KAGNfYOG4iqXV+jKfxyo12DX/Lc2j49BdB27CacCsQgTowE=
X-Received: by 2002:a62:8281:0:b0:5df:9809:6220 with SMTP id
 w123-20020a628281000000b005df98096220mr2649478pfd.3.1677682451116; Wed, 01
 Mar 2023 06:54:11 -0800 (PST)
Received: from 744723338238 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 1 Mar 2023 06:54:10 -0800
From:   Andrea Bolognani <abologna@redhat.com>
References: <20230228150216.77912-1-cohuck@redhat.com> <20230228150216.77912-2-cohuck@redhat.com>
 <CABJz62OHjrq_V1QD4g4azzLm812EJapPEja81optr8o7jpnaHQ@mail.gmail.com>
 <874jr4dbcr.fsf@redhat.com> <CABJz62MQH2U1QM26PcC3F1cy7t=53_mxkgViLKjcUMVmi29w+Q@mail.gmail.com>
 <87sfeoblsa.fsf@redhat.com>
MIME-Version: 1.0
In-Reply-To: <87sfeoblsa.fsf@redhat.com>
Date:   Wed, 1 Mar 2023 06:54:10 -0800
Message-ID: <CABJz62PbzFMB3ifg7OvTXe34TS5b3xDHJk8XGs-inA5t5UEAtA@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] arm/kvm: add support for MTE
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Peter Maydell <peter.maydell@linaro.org>,
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 01, 2023 at 03:15:17PM +0100, Cornelia Huck wrote:
> On Wed, Mar 01 2023, Andrea Bolognani <abologna@redhat.com> wrote:
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

I agree that a CPU feature makes more sense.

> We might want to tweak the documentation for the machine property to
> indicate that it creates tag memory and only implicitly enables mte but
> is a pre-req for it -- thoughts?

I wonder if it would be possible to flip things around, so that the
machine property is retained with its existing behavior for backwards
compatibility, but both for KVM and for TCG the CPU property can be
used on its own?

Basically, keeping the default of machine.mte to off when cpu.mte is
not specified, but switching it to on when it is. This way, you'd be
able to simply use

  -machine virt -cpu xxx,mte=on

to enable MTE, regardless of whether you're using KVM or TCG, instead
of requiring the above for KVM and

  -machine virt,mte=on -cpu xxx

for TCG.

Note that, from libvirt's point of view, there's no advantage to
doing things that way instead of what you already have. Handling the
additional machine property is a complete non-issue. But it would
make things nicer for people running QEMU directly, I think.

-- 
Andrea Bolognani / Red Hat / Virtualization

