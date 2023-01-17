Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 576CC66E5C2
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 19:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbjAQSPJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 13:15:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232781AbjAQSNF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 13:13:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE5339CD9
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 09:54:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673978044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OjgstlamuylfDiM6J62Gz76c1zI/KKwYNW5GH181734=;
        b=C62oUPWPFqLUmY5HQfAMYhmGqWZIsv1DvmCxTLCPSVuAspYbPxK6X6I4CuNxSLsGjnomDO
        G/Q+KL739oNUFqpLZlbhiCWImQlLujUcm/j/yLVx+ztTboiJmYibokT3O3qIZCkmq8CQxE
        BYQngt4qcQgrCiUURuZ9py+SAJeOtJ8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-472-EuBaFXntNi2d79Fgv5kYaw-1; Tue, 17 Jan 2023 12:54:03 -0500
X-MC-Unique: EuBaFXntNi2d79Fgv5kYaw-1
Received: by mail-wr1-f71.google.com with SMTP id i28-20020adfa51c000000b002ba26dfcd08so6400451wrb.18
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 09:54:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OjgstlamuylfDiM6J62Gz76c1zI/KKwYNW5GH181734=;
        b=0Jj6HBILrz5Qatq7Jgp0i2JvACYBeMtbzCpiqwJr4YbanbJD88/OAqv8hH81a640wb
         r5ilTCKHpV93HKQfhCSTnqeJoNvfw3wSg8MmGToH5M1XFwlPceFEQj9i1AV1PLgIIZjR
         L6Ds0tokrRDDCvAGmDm6nhuGtCF2xrYUUBRv0gOh6goDv1btyJ+fj+19/O5Ck1MClH6o
         V2BpE/0QoOhZmsHjM4K8M/ruBMJWXFqYkqdMik2CIMgibxI6ota1Er+HQRByizqNOM44
         8nLyZk3V28ErnYJW1DnyVqvioaZf2KUEStw2PVoFL15s29EFMqZ2TveMZMys+YXaRKMU
         dkZA==
X-Gm-Message-State: AFqh2kr7eszOkgmO7DdCJOiz0fO6ReanAylpSPUcKdmVrRki/qoEh/gN
        ierdHTp3I8/M2wMAviZE1lMj3AqNHMfpp3ehp8bxfz9m72vev48+u8nkTS4XrZB9OXPJu+KjaxO
        l9jOecHnA/3hc
X-Received: by 2002:a05:600c:2281:b0:3da:c07:c5fe with SMTP id 1-20020a05600c228100b003da0c07c5femr12579110wmf.5.1673978042148;
        Tue, 17 Jan 2023 09:54:02 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtJD2UaA7k7LYWPG+ig9ym8aMzvrorUindhCPUVDaIuudtoRe/YEDVWBTedb8WJSzzH/rKfXQ==
X-Received: by 2002:a05:600c:2281:b0:3da:c07:c5fe with SMTP id 1-20020a05600c228100b003da0c07c5femr12579100wmf.5.1673978041977;
        Tue, 17 Jan 2023 09:54:01 -0800 (PST)
Received: from work-vm (ward-16-b2-v4wan-166627-cust863.vm18.cable.virginm.net. [81.97.203.96])
        by smtp.gmail.com with ESMTPSA id l6-20020a05600c4f0600b003db0b0cc2afsm2285976wmq.30.2023.01.17.09.54.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 09:54:01 -0800 (PST)
Date:   Tue, 17 Jan 2023 17:53:59 +0000
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     Cornelia Huck <cohuck@redhat.com>, Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, qemu-arm@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eric Auger <eauger@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v4 1/2] arm/kvm: add support for MTE
Message-ID: <Y8bgtwNjXn/icLX5@work-vm>
References: <20230111161317.52250-1-cohuck@redhat.com>
 <20230111161317.52250-2-cohuck@redhat.com>
 <CAFEAcA9BKX+fSEZZbziwTNq5wsshDajuxGZ_oByVZ=gDSYOn9g@mail.gmail.com>
 <Y8bR7xrsCMr5z6xI@work-vm>
 <CAFEAcA-rnb=fSW+ZiZkX7EAgTnmksr4Grow3P=UdQR1yhay4TQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFEAcA-rnb=fSW+ZiZkX7EAgTnmksr4Grow3P=UdQR1yhay4TQ@mail.gmail.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Peter Maydell (peter.maydell@linaro.org) wrote:
> On Tue, 17 Jan 2023 at 16:51, Dr. David Alan Gilbert
> <dgilbert@redhat.com> wrote:
> >
> > * Peter Maydell (peter.maydell@linaro.org) wrote:
> > > On Wed, 11 Jan 2023 at 16:13, Cornelia Huck <cohuck@redhat.com> wrote:
> > > > +MTE CPU Property
> > > > +================
> > > > +
> > > > +The ``mte`` property controls the Memory Tagging Extension. For TCG, it requires
> > > > +presence of tag memory (which can be turned on for the ``virt`` machine via
> > > > +``mte=on``). For KVM, it requires the ``KVM_CAP_ARM_MTE`` capability; until
> > > > +proper migration support is implemented, enabling MTE will install a migration
> > > > +blocker.
> > > > +
> > > > +If not specified explicitly via ``on`` or ``off``, MTE will be available
> > > > +according to the following rules:
> > > > +
> > > > +* When TCG is used, MTE will be available iff tag memory is available; i.e. it
> > > > +  preserves the behaviour prior to introduction of the feature.
> > > > +
> > > > +* When KVM is used, MTE will default to off, so that migration will not
> > > > +  unintentionally be blocked.
> > > > +
> > > > +* Other accelerators currently don't support MTE.
> > >
> > > Minor nits for the documentation:
> > > we should expand out "if and only if" -- not everybody recognizes
> > > "iff", especially if they're not native English speakers or not
> > > mathematicians.
> > >
> > > Should we write specifically that in a future QEMU version KVM
> > > might change to defaulting to "on if available" when migration
> > > support is implemented?
> >
> > Please make sure if you do something like that, that the failure
> > is obious; 'on if available' gets messy for things like libvirt
> > and higher level tools detecting features that are available and
> > machines they can migrate to.
> 
> If we have a plan for how this ought to work when we eventually
> implement migration support that's great and we should document
> it. My point is really "we should make sure we don't box ourselves
> into a set of defaults that we regret in the future, eg where
> TCG and KVM always have different defaults forever". If we don't
> have a plan for what the future is, then I'd rather we delayed
> adding MTE-without-migration-support until we've determined that
> plan.
> 
> Though the default for the CPU property is a bit moot, because
> at the machine level we only implement tag memory on the virt
> board, and there we disable it at the machine level (ie the
> machine property 'mte' defaults to 'false').

Oh, if you're disabling it at the machine level that's fine;
with versioned machine types the answer then is to turn it on
at the machine level when it all works, and that keeps the old
machine types with it off, and then VMs migrating with the old
machine type don't get confused.

(Having said that, there are always odd rules around CPU flags and
machine types and what libvirt thinks of them, but I'd ask a libvirt
person (jdenemar) for more details if needed).

Dave

> thanks
> -- PMM
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

