Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B34D644891
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 17:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234556AbiLFQBm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 11:01:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234701AbiLFQBN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 11:01:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D936248E1
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 08:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670342406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Zu0rAwAuE6QwDoYs10JsbnnPiKWtKFHCPDXVoorD0sE=;
        b=XdMVCyRDG1t/CodLhBFROKrnPYs//iaBhPNImMegIuwo32iFj09kOQBL3UBQL4xdLJqu0a
        ZLJeE09ihBw/i/tneA1REBror2cLrqM9DQGCUpUpBwdRUeSpdWARqWQx6tS2tux1MlkjxV
        zbH9jJ7GbklyERV2+5gUCxkkfZJA1Zs=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-364-UtKxYSUmM0yiy-bP5jTlMQ-1; Tue, 06 Dec 2022 11:00:05 -0500
X-MC-Unique: UtKxYSUmM0yiy-bP5jTlMQ-1
Received: by mail-qk1-f198.google.com with SMTP id ay43-20020a05620a17ab00b006fa30ed61fdso20916088qkb.5
        for <kvm@vger.kernel.org>; Tue, 06 Dec 2022 08:00:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zu0rAwAuE6QwDoYs10JsbnnPiKWtKFHCPDXVoorD0sE=;
        b=HvY7iJdY2HXwvuWEE3bcBWK3xx/yTrSoBXsNb6jlC4utXLUHFT6wOaBEe0CiPlvE3b
         NalmZx4KHuazBot+Twf9jfKHWI+r0Ulj5BHrPd0iAJhUqZfozHybz3zMJcCwzlPJWmcI
         UomgWaZNElIoqKuXpQWL2Hkr2bdR62fx2gJIIw0Yj0Wrxw5HqHfTcxIJbmAQhOwCZ0rn
         fNGwTrt299Forp67gsjslAxBCrV4t9YKgcssplr3aKOm6JQyYq0gRKntHcnK5Mvumpdu
         KEyoKY5SKmEO1CIRVYSYLarL80tZ/F8qQ4FlNb0Kv1Ky7fx2qFuwH27rDi6BQkXYN56W
         76Rg==
X-Gm-Message-State: ANoB5pl1XkPUR5a6k7jJ/nXSCPitrk7oe6UsHTg3Og9EdVRySiGsyDWf
        bfjzcZjm2PGhCXfiz5CRhCaoWu9snJV3fp9XH64bOCm08XPBJdmK+3gSg11lyPIzFW3gPEwoeX6
        fnXFR1PEdks9b
X-Received: by 2002:a0c:fe0e:0:b0:4c6:ecc4:a26b with SMTP id x14-20020a0cfe0e000000b004c6ecc4a26bmr44590971qvr.70.1670342404730;
        Tue, 06 Dec 2022 08:00:04 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5okReLYbxRC41ENfgYV0bzXFQGfRkuSuCQ3BpYUz22FyiP35MS9UZJs5kKmlkHj/2p40GNzQ==
X-Received: by 2002:a0c:fe0e:0:b0:4c6:ecc4:a26b with SMTP id x14-20020a0cfe0e000000b004c6ecc4a26bmr44590949qvr.70.1670342404404;
        Tue, 06 Dec 2022 08:00:04 -0800 (PST)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id cf16-20020a05622a401000b003996aa171b9sm11577161qtb.97.2022.12.06.08.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 08:00:03 -0800 (PST)
Date:   Tue, 6 Dec 2022 11:00:02 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Shivam Kumar <shivam.kumar1@nutanix.com>
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, david@redhat.com,
        quintela@redhat.com, dgilbert@redhat.com, kvm@vger.kernel.org,
        Yong Huang <huangy81@chinatelecom.cn>
Subject: Re: [RFC PATCH 0/1] QEMU: Dirty quota-based throttling of vcpus
Message-ID: <Y49nAjrD0uxUp+Ll@x1n>
References: <20221120225458.144802-1-shivam.kumar1@nutanix.com>
 <0cde1cb7-7fce-c443-760c-2bb244e813fe@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0cde1cb7-7fce-c443-760c-2bb244e813fe@nutanix.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Shivam,

On Tue, Dec 06, 2022 at 11:18:52AM +0530, Shivam Kumar wrote:

[...]

> > Note
> > ----------
> > ----------
> > 
> > We understand that there is a good scope of improvement in the current
> > implementation. Here is a list of things we are working on:
> > 1) Adding dirty quota as a migration capability so that it can be toggled
> > through QMP command.
> > 2) Adding support for throttling guest DMAs.
> > 3) Not enabling dirty quota for the first migration iteration.

Agreed.

> > 4) Falling back to current auto-converge based throttling in cases where dirty
> > quota throttling can overthrottle.

If overthrottle happens, would auto-converge always be better?

> > 
> > Please stay tuned for the next patchset.
> > 
> > Shivam Kumar (1):
> >    Dirty quota-based throttling of vcpus
> > 
> >   accel/kvm/kvm-all.c       | 91 +++++++++++++++++++++++++++++++++++++++
> >   include/exec/memory.h     |  3 ++
> >   include/hw/core/cpu.h     |  5 +++
> >   include/sysemu/kvm_int.h  |  1 +
> >   linux-headers/linux/kvm.h |  9 ++++
> >   migration/migration.c     | 22 ++++++++++
> >   migration/migration.h     | 31 +++++++++++++
> >   softmmu/memory.c          | 64 +++++++++++++++++++++++++++
> >   8 files changed, 226 insertions(+)
> > 
> 
> It'd be great if I could get some more feedback before I send v2. Thanks.

Sorry to respond late.

What's the status of the kernel patchset?

From high level the approach looks good at least to me.  It's just that (as
I used to mention) we have two similar approaches now on throttling the
guest for precopy.  I'm not sure what's the best way to move forward if
without doing a comparison of the two.

https://lore.kernel.org/all/cover.1669047366.git.huangy81@chinatelecom.cn/

Sorry to say so, and no intention to create a contention, but merging the
two without any thought will definitely confuse everybody.  We need to
figure out a way.

From what I can tell..

One way is we choose one of them which will be superior to the other and
all of us stick with it (for either higher possibility of migrate, less
interference to the workloads, and so on).

The other way is we take both, when each of them may be suitable for
different scenarios.  However in this latter case, we'd better at least be
aware of the differences (which suites what), then that'll be part of
documentation we need for each of the features when the user wants to use
them.

Add Yong into the loop.

Any thoughts?

-- 
Peter Xu

