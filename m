Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50BA05704BE
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 15:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiGKNzV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 09:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiGKNzU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 09:55:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0D6C65FAE2
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 06:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657547719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i6aMyK5Ntv0hUxRexx3zBfDiHceMvVJG/f5gGbTdYak=;
        b=fWH0uEx+PdlwAHTS/lTplmYno3tWqoVgFNC0lBQ7gMo77V1juoFexqcnUWLky/OjREbRlw
        Y5DqcLMVaQByVYQJEFyrVoefPltfb63VRmRItHjIYy+PTktvMi4iCbdldRCwXwejoR08BS
        h6Cku7+z3dqR2+ZKRHUELmkF4tbmT2Q=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-453-jDekvvC-Pt20m1oMqXj7BA-1; Mon, 11 Jul 2022 09:55:17 -0400
X-MC-Unique: jDekvvC-Pt20m1oMqXj7BA-1
Received: by mail-wr1-f70.google.com with SMTP id g10-20020adfa58a000000b0021d419f7751so669363wrc.23
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 06:55:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=i6aMyK5Ntv0hUxRexx3zBfDiHceMvVJG/f5gGbTdYak=;
        b=n7nAgQhTS7a4Dnkwe59s1yHP0vxXji5sXOS7itXD8mdsaNwaN3hQ78/iWdToZ1YZhz
         Gz2MDWheLvUdHm5wxsG+N1ekHxSOAQgX9yV5FWqoZmWVL3taTNgC2pUzZa0teD2vHrJi
         gEiZYhPuMHZSTIs5f/jt/mwo919SSLY1d1NJSdZEF8HnsaPnoK4ZzUvlxivEq1bkVbEF
         XrFvEobLec9AB+9BKfAZ4INF+W1OCxJFyrPHRXm7JOvMRAy7/J43quftDY0VnAiM0cGd
         Jb9LUPx6pZ3PUuMo+pMTHQs8WDLfqxro5CpnDDQ/h005G1lk7Vh0G5MxmonAoMxdy1dJ
         vi+A==
X-Gm-Message-State: AJIora8atK0dambNKvc39DHyEnxC3G87atqY4ShqThNWH+oz+QM+FxmV
        +30+OgK9a1qvzAjOXzLWGG3Fhh/zoilLHMDv57UY3KTLJdUi2WrYWJv1oSuPGrmbMJ+hq7BodDW
        k1zUZI2TBJ7LK
X-Received: by 2002:a5d:440f:0:b0:21d:888b:a65b with SMTP id z15-20020a5d440f000000b0021d888ba65bmr17363556wrq.655.1657547716773;
        Mon, 11 Jul 2022 06:55:16 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sQcBSF1WN0t72ZglVSiQslVZ3Xs38A/mwVHxR3ubM07DEwj9YOlq0hBqmBeD5F2c6ONw5dYQ==
X-Received: by 2002:a5d:440f:0:b0:21d:888b:a65b with SMTP id z15-20020a5d440f000000b0021d888ba65bmr17363542wrq.655.1657547716581;
        Mon, 11 Jul 2022 06:55:16 -0700 (PDT)
Received: from work-vm (cpc109025-salf6-2-0-cust480.10-2.cable.virginm.net. [82.30.61.225])
        by smtp.gmail.com with ESMTPSA id f12-20020a05600c4e8c00b003a2cf17a894sm11047981wmq.41.2022.07.11.06.55.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 06:55:15 -0700 (PDT)
Date:   Mon, 11 Jul 2022 14:55:13 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Eric Auger <eauger@redhat.com>,
        Juan Quintela <quintela@redhat.com>, qemu-arm@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH RFC v2 0/2] arm: enable MTE for QEMU + kvm
Message-ID: <YswrwWVLlhoF2fN6@work-vm>
References: <20220707161656.41664-1-cohuck@redhat.com>
 <YswkdVeESqf5sknQ@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YswkdVeESqf5sknQ@work-vm>
User-Agent: Mutt/2.2.6 (2022-06-05)
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Dr. David Alan Gilbert (dgilbert@redhat.com) wrote:
> * Cornelia Huck (cohuck@redhat.com) wrote:
> > This series makes it possible to enable MTE for kvm guests, if the kernel
> > supports it. Again, tested on the simulator via patiently waiting for the
> > arm64/mte kselftests to finish successfully.
> > 
> > For tcg, turning on mte on the machine level (to get tag memory) stays a
> > requirement. If the new mte cpu feature is not explicitly specified, a tcg
> > vm will get mte depending on the presence of tag memory (just as today).
> > 
> > For kvm, mte stays off by default; this is because migration is not yet
> > supported (postcopy will need an extension of the kernel interface, possibly
> > an extension of the userfaultfd interface), and turning on mte will add a
> > migration blocker.
> 
> My assumption was that a normal migration would need something as well
> to retrieve and place the MTE flags; albeit not atomically.
> 
> > My biggest question going forward is actually concerning migration; I gather
> > that we should not bother adding something unless postcopy is working as well?
> 
> I don't think that restriction is fair on you; just make sure
> postcopy_ram_supported_by_host gains an arch call and fails cleanly;
> that way if anyone tries to enable postcopy they'll find out with a
> clean fail.
> 
> > If I'm not misunderstanding things, we need a way to fault in a page together
> > with the tag; doing that in one go is probably the only way that we can be
> > sure that this is race-free on the QEMU side. Comments welcome :)
> 
> I think it will.
> But, ignoring postcopy for a minute, with KVM how do different types of
> backing memory work - e.g. if I back a region of guest memory with
> /dev/shm/something or a hugepage equivalent, where does the MTE memory
> come from, and how do you set it?

Another case that just came to mind, are the data content optimisations;
we special case all-zero pages, which I guess you still need to transmit
tags for, and the xbzrle page-difference code wouldn't notice
differences in tags.

Dave

> Dave
> 
> > Changes v1->v2: [Thanks to Eric for the feedback!]
> > - add documentation
> > - switch the mte prop to OnOffAuto; this improves the interaction with the
> >   existing mte machine prop
> > - leave mte off for kvm by default
> > - improve tests; the poking in QDicts feels a bit ugly, but seems to work
> > 
> > Cornelia Huck (2):
> >   arm/kvm: add support for MTE
> >   qtests/arm: add some mte tests
> > 
> >  docs/system/arm/cpu-features.rst |  21 +++++
> >  target/arm/cpu.c                 |  18 ++---
> >  target/arm/cpu.h                 |   1 +
> >  target/arm/cpu64.c               | 132 +++++++++++++++++++++++++++++++
> >  target/arm/internals.h           |   1 +
> >  target/arm/kvm64.c               |   5 ++
> >  target/arm/kvm_arm.h             |  12 +++
> >  target/arm/monitor.c             |   1 +
> >  tests/qtest/arm-cpu-features.c   |  77 ++++++++++++++++++
> >  9 files changed, 256 insertions(+), 12 deletions(-)
> > 
> > -- 
> > 2.35.3
> > 
> -- 
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

