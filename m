Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D97668D403
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 11:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbjBGKZH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 05:25:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjBGKZG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 05:25:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F19FB199F8
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 02:24:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675765458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ep59omg7XPDvU5cqAhe2vkhiB3lKdlJefi1wdWZ76RI=;
        b=IRwFQclnTisz8XjjIC4rl7btMd0oIfznj6kqN0mnzpdBDwG2pl825aaOQccpwfV5ppHwlX
        qB50TpWhCkSH5F1VeA+PnT7btVYD0Jw/RtMGN+ktxFexcPQaYfxPe+LsoZ7KiGoj0QeFJw
        Mcj/ck76cOGYoQd6qlDKZA1QNcIkYI8=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-52-D6X0FPpmN5K57B7qJNx7Ew-1; Tue, 07 Feb 2023 05:24:17 -0500
X-MC-Unique: D6X0FPpmN5K57B7qJNx7Ew-1
Received: by mail-ej1-f72.google.com with SMTP id wu9-20020a170906eec900b0088e1bbefaeeso10914588ejb.12
        for <kvm@vger.kernel.org>; Tue, 07 Feb 2023 02:24:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ep59omg7XPDvU5cqAhe2vkhiB3lKdlJefi1wdWZ76RI=;
        b=oOeeGf7uVSob8Dn8d92Uhn5cfbCA1/wbgDbk9vmR6k5wPOdhW/0ng1WvzK2gpuIAOe
         XgGQEEuoJ3Ih4eQq5VPXxlPHyJ5qPGtD05ShyGs/Kr07STZu3zAKCO0moBLH8WNfrPL+
         eZP7/8WMD9ZVnoRn1AFkRDnRO5JmdSRYzDxFrKFyNokQ4XeOLrmEhzAJqI5CjeNP8gj8
         Tk5G1lxamPGIda7ckvXXNtm6Yd5i1oAKIq17ftcCLG0c6QjV6kcwGB6L60afY3z/EKKV
         jQ94/QVRUkeq07sX7pOhV7E503yfSm8WDp0wXsYcMGnY3YVeiHyHllJXXNi6FMsCT7CR
         Ge7g==
X-Gm-Message-State: AO0yUKXOvtFNdlyfEFYaPgModCDSADkJ4JyF3Tf8Rs6YYTgTSmDDEueD
        JK27EpXaBZrS9ydOdizxrmil0evXdQ/zon2Smd2Dm2KCJ6h/J2rS5i5R/nl3y70E0ztSqSGE3BU
        b6LL6V0BvWpErGBDVNhrK2EIENTzR
X-Received: by 2002:a50:c31e:0:b0:4aa:a4f4:1df with SMTP id a30-20020a50c31e000000b004aaa4f401dfmr690608edb.78.1675765455915;
        Tue, 07 Feb 2023 02:24:15 -0800 (PST)
X-Google-Smtp-Source: AK7set/9PribleoazHLYXrivRQOEzMkLB4yrN7FfYcSZZNFVXlwVoj7qT65td0QqRJXWhbFWFaV8JLdbeEtFpLIRAnI=
X-Received: by 2002:a50:c31e:0:b0:4aa:a4f4:1df with SMTP id
 a30-20020a50c31e000000b004aaa4f401dfmr690599edb.78.1675765455758; Tue, 07 Feb
 2023 02:24:15 -0800 (PST)
MIME-Version: 1.0
References: <CAJSP0QUuuZLC0DJNEfZ7amyd3XnRhRNr1k+1OgLfDeF77X1ZDQ@mail.gmail.com>
 <CAELaAXysa3M-TPbLMCVCwpt40iqhXpF7PCan_i6SzY_YMafXrg@mail.gmail.com> <CAJSP0QWLdbNqyrGnhRB3AqMpH0xYFK6+=TpWrrytQzn9MGD2zA@mail.gmail.com>
In-Reply-To: <CAJSP0QWLdbNqyrGnhRB3AqMpH0xYFK6+=TpWrrytQzn9MGD2zA@mail.gmail.com>
From:   Alberto Faria <afaria@redhat.com>
Date:   Tue, 7 Feb 2023 10:23:39 +0000
Message-ID: <CAELaAXwAF1QSyfFEzqBFJk69VZN9cEC=H=hHh6kvndFm9p0f6w@mail.gmail.com>
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

On Mon, Feb 6, 2023 at 9:22 PM Stefan Hajnoczi <stefanha@gmail.com> wrote:
> Great that you're interesting, Alberto! Both sound feasible. I would
> like to co-mentor the zoned storage project or can at least commit to
> being available to help because zoned storage is currently on my mind
> anyway :).

Perfect, I'll have time to co-mentor one project, but probably not
two, so let's leave the NVMe driver project aside for now. If anyone
wants to take that one over, though, go for it.

> Do you want to write up one or both of them using the project template
> below? You can use the other project ideas as a reference for how much
> detail to include: https://wiki.qemu.org/Google_Summer_of_Code_2023

I feel like this is closer to a 175 hour project than a 350 hour one,
but I'm not entirely sure.

  === Zoned device support for libblkio ===

   '''Summary:''' Add support for zoned block devices to the libblkio library.

   Zoned block devices are special kinds of disks that are split into several
   regions called zones, where each zone may only be written
sequentially and data
   can't be updated without resetting the entire zone.

   libblkio is a library that provides an API for efficiently accessing block
   devices using modern high-performance block I/O interfaces like
Linux io_uring.

   The goal is to extend libblkio so users can use it to access zoned devices
   properly. This will require adding support for more request types, expanding
   its API to expose additional metadata about the device, and making the
   appropriate changes to each libblkio "driver".

   This is important for QEMU since it will soon support zoned devices too and
   several of its BlockDrivers rely on libblkio. In particular, this
project would
   enable QEMU to access zoned vhost-user-blk and vhost-vdpa-blk devices.

   '''Links:'''
   * https://zonedstorage.io/
   * https://libblkio.gitlab.io/libblkio/
   * https://gitlab.com/libblkio/libblkio/-/issues/44

   '''Details:'''
   * Project size: 175 hours
   * Skill level: intermediate
   * Language: Rust, C
   * Mentor: Alberto Faria <afaria@redhat.com>, Stefan Hajnoczi
<stefanha@gmail.com>
   * Suggested by: Alberto Faria <afaria@redhat.com>

Alberto

