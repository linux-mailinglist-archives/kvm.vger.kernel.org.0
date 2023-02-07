Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3603968D445
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 11:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbjBGKbm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 05:31:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231329AbjBGKbd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 05:31:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A06037574
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 02:30:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675765834;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6ZkytdhJcOBA0AD8GOg1BTKawAI369KvLKCu28GDXOM=;
        b=Fi7kHVEvsKLNa2slSlcdabefaJ83lMIYAl0+CO1IL7e7yUd4LCqNoKyTRUOBl0y8VxYQdS
        gLGgFce9N7U/+MOzlKubsH+MOhuMhh02gO9PAA4qnfKCWXIbBsiIoia/8OACYn4h5PkYEO
        ydAM2jKiCE/ywGy7fiFJop8vOMSQQUU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-321-HqEkMK2LMamUqv6CyszIrw-1; Tue, 07 Feb 2023 05:30:33 -0500
X-MC-Unique: HqEkMK2LMamUqv6CyszIrw-1
Received: by mail-ed1-f70.google.com with SMTP id en20-20020a056402529400b004a26ef05c34so9687068edb.16
        for <kvm@vger.kernel.org>; Tue, 07 Feb 2023 02:30:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6ZkytdhJcOBA0AD8GOg1BTKawAI369KvLKCu28GDXOM=;
        b=hrp/BTF6S8eJPUzz82BqOp4vYPygsg6dbCCIxxk9/3eR0vaL8O+FfNTmu7REQMzUy8
         PFjxihJN/03hpFN84jCdNx959VSE1tn/lK4HkbN3aDQ4xxvDNMNU1+FqdmVK5ZURTIgV
         L1eGsinSZI1T+AjebOun1fH9siE9Hn1ha6DWlQqAB3H/8NMR4k4IqiAAr1V2x8WPRt1i
         ZT9qTqpeJEzJFlAw/leKGmSeKegbZSOPyFukJ2IpdLTtyBxWxhyGXOSbc4OVrChwA4Uz
         WJJyZgLtKNiLuZouLkedK5uG1JGfB2qn3LOHQU9fZYiLAEPv5RNEUTyPQMBqj5QS9Ru6
         r/rw==
X-Gm-Message-State: AO0yUKVfdgmIqhitgzayMkfmYZkSs5zduzi374u9duVqjAke6c/cL4nC
        IRXUskM2ySJZTvc/zivAtvmfCIOhZEK4g9bHlrYfMt4/RXH23aVoSIFmDOnHSCiPPtpp6Wfs3sD
        q447ZsuY7nx7E6ImUqMF96jGNqRL3
X-Received: by 2002:a50:c356:0:b0:490:7b7d:c66f with SMTP id q22-20020a50c356000000b004907b7dc66fmr435005edb.4.1675765831980;
        Tue, 07 Feb 2023 02:30:31 -0800 (PST)
X-Google-Smtp-Source: AK7set9jQK/l1rqBXNfv0wCfa+9ZS4Vyqll10qLgqHhHjwGH/w/ib7uBfVHhi1HChDvDsz8hYuJMdVMw6L2xUF73gVg=
X-Received: by 2002:a50:c356:0:b0:490:7b7d:c66f with SMTP id
 q22-20020a50c356000000b004907b7dc66fmr434982edb.4.1675765831807; Tue, 07 Feb
 2023 02:30:31 -0800 (PST)
MIME-Version: 1.0
References: <CAJSP0QUuuZLC0DJNEfZ7amyd3XnRhRNr1k+1OgLfDeF77X1ZDQ@mail.gmail.com>
 <CAELaAXysa3M-TPbLMCVCwpt40iqhXpF7PCan_i6SzY_YMafXrg@mail.gmail.com>
 <CAJSP0QWLdbNqyrGnhRB3AqMpH0xYFK6+=TpWrrytQzn9MGD2zA@mail.gmail.com> <CAELaAXwAF1QSyfFEzqBFJk69VZN9cEC=H=hHh6kvndFm9p0f6w@mail.gmail.com>
In-Reply-To: <CAELaAXwAF1QSyfFEzqBFJk69VZN9cEC=H=hHh6kvndFm9p0f6w@mail.gmail.com>
From:   Alberto Faria <afaria@redhat.com>
Date:   Tue, 7 Feb 2023 10:29:55 +0000
Message-ID: <CAELaAXx6cUhcs+Yi4Kev6BfcG0LO8H_hAKWrCBL77TbmguKO+w@mail.gmail.com>
Subject: Re: Call for GSoC and Outreachy project ideas for summer 2023
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        Rust-VMM Mailing List <rust-vmm@lists.opendev.org>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>,
        Thomas Huth <thuth@redhat.com>, John Snow <jsnow@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
        "Florescu, Andreea" <fandree@amazon.com>,
        Damien <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <dmitry.fomichev@wdc.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
        Bernhard Beschow <shentey@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, gmaglione@redhat.com
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

On Tue, Feb 7, 2023 at 10:23 AM Alberto Faria <afaria@redhat.com> wrote:
> On Mon, Feb 6, 2023 at 9:22 PM Stefan Hajnoczi <stefanha@gmail.com> wrote:
> > Great that you're interesting, Alberto! Both sound feasible. I would
> > like to co-mentor the zoned storage project or can at least commit to
> > being available to help because zoned storage is currently on my mind
> > anyway :).
>
> Perfect, I'll have time to co-mentor one project, but probably not
> two, so let's leave the NVMe driver project aside for now. If anyone
> wants to take that one over, though, go for it.
>
> > Do you want to write up one or both of them using the project template
> > below? You can use the other project ideas as a reference for how much
> > detail to include: https://wiki.qemu.org/Google_Summer_of_Code_2023
>
> I feel like this is closer to a 175 hour project than a 350 hour one,
> but I'm not entirely sure.
>
>   === Zoned device support for libblkio ===
>
>    '''Summary:''' Add support for zoned block devices to the libblkio library.
>
>    Zoned block devices are special kinds of disks that are split into several
>    regions called zones, where each zone may only be written
> sequentially and data
>    can't be updated without resetting the entire zone.
>
>    libblkio is a library that provides an API for efficiently accessing block
>    devices using modern high-performance block I/O interfaces like
> Linux io_uring.
>
>    The goal is to extend libblkio so users can use it to access zoned devices
>    properly. This will require adding support for more request types, expanding
>    its API to expose additional metadata about the device, and making the
>    appropriate changes to each libblkio "driver".
>
>    This is important for QEMU since it will soon support zoned devices too and
>    several of its BlockDrivers rely on libblkio. In particular, this
> project would
>    enable QEMU to access zoned vhost-user-blk and vhost-vdpa-blk devices.

Also, a stretch/bonus goal could be to make the necessary changes to
QEMU to actually make use of libblkio's zoned device support.

>    '''Links:'''
>    * https://zonedstorage.io/
>    * https://libblkio.gitlab.io/libblkio/
>    * https://gitlab.com/libblkio/libblkio/-/issues/44
>
>    '''Details:'''
>    * Project size: 175 hours
>    * Skill level: intermediate
>    * Language: Rust, C
>    * Mentor: Alberto Faria <afaria@redhat.com>, Stefan Hajnoczi
> <stefanha@gmail.com>
>    * Suggested by: Alberto Faria <afaria@redhat.com>
>
> Alberto

