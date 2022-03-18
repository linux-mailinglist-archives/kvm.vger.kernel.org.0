Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D82DD4DDC0F
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 15:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237525AbiCROsv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 10:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237716AbiCROsC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 10:48:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AEDDE2EAF5D
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 07:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647614791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TNP/cfaogRB9CjpdHZApi9zDHXNx0ATc+DZIQOXTyTo=;
        b=ifGez4FeWhvyab7uNMZtKmbUe13Y6C2gvAY/cYdlD9dcAjBRrF9AidGC3cSofGmvoMGBaB
        6eywCmlHCtoUuDcjmOHrUWUoGH4dmTMAbid0iz9eW0wLl9elBl9G0uWCsg2OBZNZ3yrcwG
        kp6IwOSL6tXd2EMMmhFyfvBy+D8vat0=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-323-2QiQaSrwMR-AUdi24bt8yQ-1; Fri, 18 Mar 2022 10:46:29 -0400
X-MC-Unique: 2QiQaSrwMR-AUdi24bt8yQ-1
Received: by mail-il1-f200.google.com with SMTP id v11-20020a92c80b000000b002c7e3b707caso2968623iln.15
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 07:46:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=TNP/cfaogRB9CjpdHZApi9zDHXNx0ATc+DZIQOXTyTo=;
        b=2VU6woDlkTe2bIrqzQzzDxACQIbqn+k8lf9K69tAthQoKgDBKiB2trEoF31vaP1R50
         62yNGZu6B1myWymUFZ01nqLjD/iaMoEzk0T6LUbtDX+mS09f+BMGxTFgoaaR4lF1DrjF
         4PwBHnCIgP3ZEvBnxBrjTufA6U04jSAP5eE6JHEW+PdJ5QntdSim876wbNMCB4Qr+E93
         gB7sW61E90u7Q3KhAIEQNIMiBsLaIo1BEHegFDqVEOwv4KjWMoQijHaysk7zl+oY3ljM
         Eqm/McvpQinH2uKMStbudoL/LBkIRqaBhU/OohhcsuLOTJwa+vxhTl9z27IulVbUuKqA
         cWew==
X-Gm-Message-State: AOAM530TmuXSxdRhNck4z7r1Z7bj/Aa+4R41ZNpguT2QJ1SxpzfFyaaL
        3ulDEdxGT86DGUZeEN1Jg00SLdMSZg3z35lWYuV8LVMxvt1tX9W4tEm3PdaQ1Gpry0uH+uOJn5z
        pfkVuPzwBjkBH
X-Received: by 2002:a05:6602:1414:b0:63d:d5fd:c16e with SMTP id t20-20020a056602141400b0063dd5fdc16emr4602194iov.39.1647614788626;
        Fri, 18 Mar 2022 07:46:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy2qPUaZR4EQmbFM5xc0105G4QoXfxLhmJxgudtGO9Haizky/1u+FIGD6yx423M2Oe8NioUxg==
X-Received: by 2002:a05:6602:1414:b0:63d:d5fd:c16e with SMTP id t20-20020a056602141400b0063dd5fdc16emr4602182iov.39.1647614788331;
        Fri, 18 Mar 2022 07:46:28 -0700 (PDT)
Received: from redhat.com ([98.55.18.59])
        by smtp.gmail.com with ESMTPSA id q7-20020a5d87c7000000b0064132d5bd73sm4433845ios.4.2022.03.18.07.46.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 07:46:27 -0700 (PDT)
Date:   Fri, 18 Mar 2022 08:46:25 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>,
        James Turner <linuxkernel.foss@dmarc-none.turner.link>,
        Xinhui Pan <Xinhui.Pan@amd.com>, regressions@lists.linux.dev,
        kvm@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        Lijo Lazar <lijo.lazar@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        amd-gfx@lists.freedesktop.org,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        Alex Deucher <alexdeucher@gmail.com>,
        Christian =?UTF-8?B?S8O2bmln?= <Christian.Koenig@amd.com>
Subject: Re: [REGRESSION] Too-low frequency limit for AMD GPU
 PCI-passed-through to Windows VM
Message-ID: <20220318084625.27d42a51.alex.williamson@redhat.com>
In-Reply-To: <bc714e87-d1dc-cdda-5a29-25820faaff40@leemhuis.info>
References: <87ee57c8fu.fsf@turner.link>
        <CADnq5_Nr5-FR2zP1ViVsD_ZMiW=UHC1wO8_HEGm26K_EG2KDoA@mail.gmail.com>
        <87czkk1pmt.fsf@dmarc-none.turner.link>
        <BYAPR12MB46140BE09E37244AE129C01A975C9@BYAPR12MB4614.namprd12.prod.outlook.com>
        <87sftfqwlx.fsf@dmarc-none.turner.link>
        <BYAPR12MB4614E2CFEDDDEAABBAB986A0975E9@BYAPR12MB4614.namprd12.prod.outlook.com>
        <87ee4wprsx.fsf@turner.link>
        <4b3ed7f6-d2b6-443c-970e-d963066ebfe3@amd.com>
        <87pmo8r6ob.fsf@turner.link>
        <5a68afe4-1e9e-c683-e06d-30afc2156f14@leemhuis.info>
        <CADnq5_MCKTLOfWKWvi94Q9-d5CGdWBoWVxEYL3YXOpMiPnLOyg@mail.gmail.com>
        <87pmnnpmh5.fsf@dmarc-none.turner.link>
        <CADnq5_NG_dQCYwqHM0umjTMg5Uud6zC4=MiscH91Y9v7mW9bJA@mail.gmail.com>
        <092b825a-10ff-e197-18a1-d3e3a097b0e3@leemhuis.info>
        <877d96to55.fsf@dmarc-none.turner.link>
        <87lexdw8gd.fsf@turner.link>
        <d541b534-8b83-b566-56eb-ea8baa7c998e@leemhuis.info>
        <40b3084a-11b8-0962-4b33-34b56d3a87a3@molgen.mpg.de>
        <bc714e87-d1dc-cdda-5a29-25820faaff40@leemhuis.info>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 18 Mar 2022 08:01:31 +0100
Thorsten Leemhuis <regressions@leemhuis.info> wrote:

> On 18.03.22 06:43, Paul Menzel wrote:
> >
> > Am 17.03.22 um 13:54 schrieb Thorsten Leemhuis:  
> >> On 13.03.22 19:33, James Turner wrote:  
> >>>  
> >>>> My understanding at this point is that the root problem is probably
> >>>> not in the Linux kernel but rather something else (e.g. the machine
> >>>> firmware or AMD Windows driver) and that the change in f9b7f3703ff9
> >>>> ("drm/amdgpu/acpi: make ATPX/ATCS structures global (v2)") simply
> >>>> exposed the underlying problem.  
> >>
> >> FWIW: that in the end is irrelevant when it comes to the Linux kernel's
> >> 'no regressions' rule. For details see:
> >>
> >> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/Documentation/admin-guide/reporting-regressions.rst
> >>
> >> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/Documentation/process/handling-regressions.rst
> >>
> >>
> >> That being said: sometimes for the greater good it's better to not
> >> insist on that. And I guess that might be the case here.  
> > 
> > But who decides that?  
> 
> In the end afaics: Linus. But he can't watch each and every discussion,
> so it partly falls down to people discussing a regression, as they can
> always decide to get him involved in case they are unhappy with how a
> regression is handled. That obviously includes me in this case. I simply
> use my best judgement in such situations. I'm still undecided if that
> path is appropriate here, that's why I wrote above to see what James
> would say, as he afaics was the only one that reported this regression.
> 
> > Running stuff in a virtual machine is not that uncommon.  
> 
> No, it's about passing through a GPU to a VM, which is a lot less common
> -- and afaics an area where blacklisting GPUs on the host to pass them
> through is not uncommon (a quick internet search confirmed that, but I
> might be wrong there).

Right, interference from host drivers and pre-boot environments is
always a concern with GPU assignment in particular.  AMD GPUs have a
long history of poor behavior relative to things like PCI secondary bus
resets which we use to try to get devices to clean, reusable states for
assignment.  Here a device is being bound to a host driver that
initiates some sort of power control, unbound from that driver and
exposed to new drivers far beyond the scope of the kernel's regression
policy.  Perhaps it's possible to undo such power control when
unbinding the device, but it's not necessarily a given that such a
thing is possible for this device without a cold reset.

IMO, it's not fair to restrict the kernel from such advancements.  If
the use case is within a VM, don't bind host drivers.  It's difficult
to make promises when dynamically switching between host and userspace
drivers for devices that don't have functional reset mechanisms.
Thanks,

Alex

