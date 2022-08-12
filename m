Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37F03591349
	for <lists+kvm@lfdr.de>; Fri, 12 Aug 2022 17:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238860AbiHLPtH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Aug 2022 11:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238807AbiHLPtF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Aug 2022 11:49:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0A3C7AB197
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 08:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660319343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zgpdaGRKSfFf+4tNJPqkymrn0uY3U+jaiX4graWt41I=;
        b=E4dHJUntg1tFIOpClKhhsHtQHRCqjnyfYQa1WbGombELBOEYzNA3453qIWwBQlMQIb3b47
        9jTKFWKAEGwYeZrAQhEzP+5Qah+fvmgTKBGiu2ib+hxS4/OfIKKeQtv4XZq4bNpDTvAEUz
        cXA6FFgTuOAVsLFPqdLvWRVmghuTNoc=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-507-ujjhVpqWPeGYNkdfDpUFzQ-1; Fri, 12 Aug 2022 11:49:02 -0400
X-MC-Unique: ujjhVpqWPeGYNkdfDpUFzQ-1
Received: by mail-il1-f199.google.com with SMTP id i20-20020a056e020d9400b002e377b02d4cso805706ilj.7
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 08:49:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=zgpdaGRKSfFf+4tNJPqkymrn0uY3U+jaiX4graWt41I=;
        b=7b4q6aCpRvdJICAkPzkAP96LIqpPa1OPXG7yTqBsm/dX9Xfcy/70ePjndLZbW7ZmXD
         fgGNMn1lonQK+RrlG1Ccle5LddvCw9/Qyhsh96bQ6hPwnhBdO5IeqlCc+7CVUZKI+fuB
         zjASCT0DU+Eiwyu9ZClFvqFoPcQfDP/StXB4f8hPiw6Q1UJBLSaIejh/MGVN8ZmGLPPK
         9+ynS9lWMd+Kvy1OUaR189NZJb/T0SEJO5wvroDOu2I3aBb+WvhbjYdiRXFnuNUPKSF5
         +A/vg7Yox0fi+eH/g8lI5zuphsi9SYfcoVnLGbV8BredQb7k3026fvutxFjBM3OLOVfS
         cKvg==
X-Gm-Message-State: ACgBeo2NnbkZhvDD58pZhmUNLYZppicaB1S1f3IinM/lDz8fpwLYOweS
        c1faOHsO5+R+Li8C/KYheFT1ZvatOloMCuiO8KHImUSn1iaFHrKrUOD+dih4Jyw4SJfPfrHQJkj
        p2FAaQ9js+NU3SJeHrE6aSniEGwM1
X-Received: by 2002:a5d:8953:0:b0:67c:aa4c:2b79 with SMTP id b19-20020a5d8953000000b0067caa4c2b79mr2031904iot.172.1660319342052;
        Fri, 12 Aug 2022 08:49:02 -0700 (PDT)
X-Google-Smtp-Source: AA6agR62JLfasHZz8jVQ0EIIR0gp2DCnvJMNuBgUaXn/nE11wZ1VpJE8eHiws8Jx/HNrQ/sXpV7Ger4g4dmsbN4xgnA=
X-Received: by 2002:a5d:8953:0:b0:67c:aa4c:2b79 with SMTP id
 b19-20020a5d8953000000b0067caa4c2b79mr2031887iot.172.1660319341843; Fri, 12
 Aug 2022 08:49:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220729130040.1428779-1-afaria@redhat.com> <CAMxuvazGhtbPUSoM-NiAbTnRnOQ=MEnkMAVyVgOg4zc37HJ1-w@mail.gmail.com>
In-Reply-To: <CAMxuvazGhtbPUSoM-NiAbTnRnOQ=MEnkMAVyVgOg4zc37HJ1-w@mail.gmail.com>
From:   Alberto Faria <afaria@redhat.com>
Date:   Fri, 12 Aug 2022 16:48:26 +0100
Message-ID: <CAELaAXxeNOkmSkh6t9Q-eL=xJg8kEAY0O1x_PVFhUttSVH=urQ@mail.gmail.com>
Subject: Re: [RFC v2 00/10] Introduce an extensible static analyzer
To:     =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>
Cc:     qemu-devel@nongnu.org, Stefano Garzarella <sgarzare@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Peter Lieven <pl@kamp.de>, kvm@vger.kernel.org,
        Xie Yongji <xieyongji@bytedance.com>,
        Eric Auger <eric.auger@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Jeff Cody <codyprime@gmail.com>,
        Eric Blake <eblake@redhat.com>,
        "Denis V. Lunev" <den@openvz.org>,
        =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        Christian Schoenebeck <qemu_oss@crudebyte.com>,
        Stefan Weil <sw@weilnetz.de>, Klaus Jensen <its@irrelevant.dk>,
        Laurent Vivier <lvivier@redhat.com>,
        Alberto Garcia <berto@igalia.com>,
        Michael Roth <michael.roth@amd.com>,
        Juan Quintela <quintela@redhat.com>,
        David Hildenbrand <david@redhat.com>, qemu-block@nongnu.org,
        Konstantin Kostiuk <kkostiuk@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Greg Kurz <groug@kaod.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Amit Shah <amit@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Fam Zheng <fam@euphon.net>, Thomas Huth <thuth@redhat.com>,
        Keith Busch <kbusch@kernel.org>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        "Richard W.M. Jones" <rjones@redhat.com>,
        John Snow <jsnow@redhat.com>,
        Markus Armbruster <armbru@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 4, 2022 at 12:44 PM Marc-Andr=C3=A9 Lureau
<marcandre.lureau@redhat.com> wrote:
> Hi
>
> Great work so far! This seems easier to hack than my attempt to use
> clang-tidy to write some qemu checks
> (https://github.com/elmarco/clang-tools-extra)
>
> The code seems quite generic, I wonder if such a tool in python wasn't
> already developed (I couldn't find it easily searching on github).
>
> Why not make it standalone from qemu? Similar to
> https://gitlab.com/qemu-project/python-qemu-qmp, you could have your
> own release management, issue tracker, code formatting, license, CI
> etc. (you should add copyright header in each file, at least that's
> pretty much required in qemu nowadays). You could also have the
> qemu-specific checks there imho (clang-tidy has google & llvm specific
> checks too)

This is an interesting idea. Indeed, the analyzer is essentially a
more easily extensible, Python version of clang-tidy (without the big
built-in library of checks).

I think I'll continue working on it embedded in QEMU for now, mostly
because it depends on some aspects of the build system, and gradually
generalize it to a point where it could be made into a standalone
thing.

> It would be nice to write some docs, in docs/devel/testing.rst and
> some new meson/ninja/make targets to run the checks directly from a
> build tree.

Sounds good, I'll work on it.

> On fc36, I had several dependencies I needed to install manually (imho
> they should have been pulled by python3-clang), but more annoyingly I
> got:
> clang.cindex.LibclangError: libclang.so: cannot open shared object
> file: No such file or directory. To provide a path to libclang use
> Config.set_library_path() or Config.set_library_file().
>
> clang-libs doesn't install libclang.so, I wonder why. I made a link
> manually and it works, but it's probably incorrect. I'll try to open
> issues for the clang packaging.

That's strange. Thanks for looking into this.

Alberto

