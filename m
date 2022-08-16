Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A42EC5955D9
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 11:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbiHPJEj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 05:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232520AbiHPJD5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 05:03:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1ED615A893
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 00:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660634254;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9NlYQWc+6aBw1qwGE9zxDoYsLr+macgpG/AeCk641Rw=;
        b=FIT5Vl+9vsMIgQ+g2S5TQSA/XfL1h1ofsC49G5nCKJpIYTptsVzy+uBDs0dXLAPXoshqJJ
        dX07uOlqjz9VYqYofgfq39yN5Ncs0aLWsE5eTCKbxHdFgLsWjD7nvVB7T+UHrrDEjcA4SF
        JoLWCSrbd+M4Uu8NsMJh26BbDHFECNk=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-347-Uk81sBzhMWSo4cZbLTjNMw-1; Tue, 16 Aug 2022 03:17:30 -0400
X-MC-Unique: Uk81sBzhMWSo4cZbLTjNMw-1
Received: by mail-oo1-f72.google.com with SMTP id k4-20020a4a3104000000b0044607fa7d05so4801111ooa.21
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 00:17:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=9NlYQWc+6aBw1qwGE9zxDoYsLr+macgpG/AeCk641Rw=;
        b=1BoILpZ+zVdCV9Ssc8DwHsx0VaqR6eJIlHQPXh14i0TNZvVZOApRclyhXyyZWF2iHF
         mKY6I0MvW2hyn653gQWbh9CTKxgkeDYASTHf9ruK5s/OWkqmqPmGqi4GWPPaBGazqdgd
         jI65EN97c+rQE1p49mrzoJ/ARv5sHB3rqwkgRbP0qzvMTOScSdFPPYZYqa9LdP2/5eo5
         gepdynJH8s4UX7MkDSJ1XeoGlIPctCYGytpXvvBETRMzochlZYwzBjaRRGgokwXuL1Sn
         8ra8BAIizvBkVhs1EcPZ/xSzGSpN2rw0DeF23M3Bqq/CCT1T8LOhI52EJgYPd4S9o+79
         bM3Q==
X-Gm-Message-State: ACgBeo0JX/Z5pTVd2qlx3XD+nS4fg6mmWaSXVkB9kpGJyOlZNCwMjMLS
        p5P6ieK9c4OQoe8hpLkkqBS76cTHT0XbYIYOQUVfF/8Z+92CrESDwzY05M6Sod5Rozx9ts3Sfvg
        r5H4GZTgGS6QNqXZUrnEA21nu2M0W
X-Received: by 2002:a05:6830:2645:b0:638:99a4:e483 with SMTP id f5-20020a056830264500b0063899a4e483mr3722704otu.38.1660634250281;
        Tue, 16 Aug 2022 00:17:30 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7dSwjOmu6TOPXETS8+YQW7VuTxfhlUCtpD4IMoID4EXpwCKHWFhai1KGRFW9EAWX5yZpzZOhtiEDfa4kjtpMs=
X-Received: by 2002:a05:6830:2645:b0:638:99a4:e483 with SMTP id
 f5-20020a056830264500b0063899a4e483mr3722659otu.38.1660634250051; Tue, 16 Aug
 2022 00:17:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220729130040.1428779-1-afaria@redhat.com> <CAMxuvazGhtbPUSoM-NiAbTnRnOQ=MEnkMAVyVgOg4zc37HJ1-w@mail.gmail.com>
 <CAELaAXxeNOkmSkh6t9Q-eL=xJg8kEAY0O1x_PVFhUttSVH=urQ@mail.gmail.com>
In-Reply-To: <CAELaAXxeNOkmSkh6t9Q-eL=xJg8kEAY0O1x_PVFhUttSVH=urQ@mail.gmail.com>
From:   =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>
Date:   Tue, 16 Aug 2022 11:17:19 +0400
Message-ID: <CAMxuvayCrw4VrB4HZweAJNMzarBpbXe-dG+wsisjjhqLVeJXJw@mail.gmail.com>
Subject: Re: [RFC v2 00/10] Introduce an extensible static analyzer
To:     Alberto Faria <afaria@redhat.com>
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
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi

On Fri, Aug 12, 2022 at 7:49 PM Alberto Faria <afaria@redhat.com> wrote:
>
> On Thu, Aug 4, 2022 at 12:44 PM Marc-Andr=C3=A9 Lureau
> <marcandre.lureau@redhat.com> wrote:
> > On fc36, I had several dependencies I needed to install manually (imho
> > they should have been pulled by python3-clang), but more annoyingly I
> > got:
> > clang.cindex.LibclangError: libclang.so: cannot open shared object
> > file: No such file or directory. To provide a path to libclang use
> > Config.set_library_path() or Config.set_library_file().
> >
> > clang-libs doesn't install libclang.so, I wonder why. I made a link
> > manually and it works, but it's probably incorrect. I'll try to open
> > issues for the clang packaging.
>
> That's strange. Thanks for looking into this.

No that's normal, I just got confused. clang-devel provides it.

However, I opened https://bugzilla.redhat.com/show_bug.cgi?id=3D2115362
"python3-clang depends on libclang.so"

