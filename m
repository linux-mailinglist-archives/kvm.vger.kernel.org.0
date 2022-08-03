Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69880588AE3
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 13:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235889AbiHCLII (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 07:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbiHCLIF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 07:08:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 685011AD83
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 04:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659524877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OcEGkV3/zb941iwtTvPuEZEmPDY+7QrxrqNr180ZZIM=;
        b=EXnBTWgk7q4UR1FObTR1KXDcuaKuwLX50/tFmOEHCpAt6jUH95j3gJOdyInQ3gHt7/OXPP
        PHb6VMjYuE1iLmzmYdQB60urU5gNs6qzGvQYhj57d07DYFWFLo81I61ycSVFqsm5FSdGDH
        CGmVmBMEJGhYSUgIf3ii3QyafapZAqs=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-lSrXrvr0MwqyaDXHpvg1JA-1; Wed, 03 Aug 2022 07:07:56 -0400
X-MC-Unique: lSrXrvr0MwqyaDXHpvg1JA-1
Received: by mail-il1-f199.google.com with SMTP id m7-20020a056e021c2700b002ddc7d2d529so10222917ilh.9
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 04:07:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OcEGkV3/zb941iwtTvPuEZEmPDY+7QrxrqNr180ZZIM=;
        b=mB/Xr3KspGEodyQr/NVJ7BJgeD3BKZonyc66h0G57Nh3rhpgZOosBm6tCa5DLJPuV6
         /GMngUeo2cktmLUB0QjpGedUCL6vUWHmBPiCaa5UpoOEONFrmgbgPWfnXekZf9UY3rz0
         KjNMA2YBXCoFc7ENzj0dfr8MT1z8/Ie3XwXSSr6/DRr21uVSUDUp+Ft+YJ1G20fA27mC
         SN2BW9ljn7cIqJnPqwkrEuRXFK0QGvm4TUyJLrcb5grX1JS+yQ9rGHyKyvuS1U+Q+dna
         cudM+KiLq+/UNxEMl8yCD//rYTYa3k7TMCMHXlsAVLbYHtdMz31ZbM9FVlYNMHsDAYXA
         J01A==
X-Gm-Message-State: AJIora+WTrC/v4Im7ZSk899W9/8j5kTh3sMr3VsMiNbFgbPkqVlcFqlp
        ezcbZTtgzV5lNE84ZYeE9+gH8f2Pnqtpl37QTNG95WfDq4wWDCZcfJf0vLet4Ag7n9GS58aej4d
        aRkV/JGVF+lvFBRVm3eiOn8pABVgg
X-Received: by 2002:a05:6602:15c8:b0:67c:45c7:40c9 with SMTP id f8-20020a05660215c800b0067c45c740c9mr8972988iow.138.1659524875505;
        Wed, 03 Aug 2022 04:07:55 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sIC6UsjJFVZWXBncAJfjfkGBkh360OVyksDTVgRe9qvGO4zJpINBXeKgqj4Vm5Jwl/M2m4t3qQIO9kZjook7k=
X-Received: by 2002:a05:6602:15c8:b0:67c:45c7:40c9 with SMTP id
 f8-20020a05660215c800b0067c45c740c9mr8972980iow.138.1659524875284; Wed, 03
 Aug 2022 04:07:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220729130040.1428779-1-afaria@redhat.com> <20220729130040.1428779-3-afaria@redhat.com>
 <YupSAhFRK962i+nL@work-vm>
In-Reply-To: <YupSAhFRK962i+nL@work-vm>
From:   Alberto Faria <afaria@redhat.com>
Date:   Wed, 3 Aug 2022 12:07:19 +0100
Message-ID: <CAELaAXyh0MzuVzDCfhC8hJNAwb=niwFRsXqhc63JiWGxxitkqg@mail.gmail.com>
Subject: Re: [RFC v2 02/10] Drop unused static function return values
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     Markus Armbruster <armbru@redhat.com>, qemu-devel@nongnu.org,
        =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
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
        John Snow <jsnow@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 3, 2022 at 11:46 AM Dr. David Alan Gilbert
<dgilbert@redhat.com> wrote:
>
> * Alberto Faria (afaria@redhat.com) wrote:
> > Make non-void static functions whose return values are ignored by
> > all callers return void instead.
> >
> > These functions were found by static-analyzer.py.
> >
> > Not all occurrences of this problem were fixed.
> >
> > Signed-off-by: Alberto Faria <afaria@redhat.com>
>
> <snip>
>
> > diff --git a/migration/migration.c b/migration/migration.c
> > index e03f698a3c..4698080f96 100644
> > --- a/migration/migration.c
> > +++ b/migration/migration.c
> > @@ -175,7 +175,7 @@ static MigrationIncomingState *current_incoming;
> >
> >  static GSList *migration_blockers;
> >
> > -static bool migration_object_check(MigrationState *ms, Error **errp);
> > +static void migration_object_check(MigrationState *ms, Error **errp);
> >  static int migration_maybe_pause(MigrationState *s,
> >                                   int *current_active_state,
> >                                   int new_state);
> > @@ -4485,15 +4485,15 @@ static void migration_instance_init(Object *obj)
> >   * Return true if check pass, false otherwise. Error will be put
> >   * inside errp if provided.
> >   */
> > -static bool migration_object_check(MigrationState *ms, Error **errp)
> > +static void migration_object_check(MigrationState *ms, Error **errp)
> >  {
>
> I'm not sure if this is a good change.
> Where we have a function that returns an error via an Error ** it's
> normal practice for us to return a bool to say whether it generated an
> error.
>
> Now, in our case we only call it with error_fatal:
>
>     migration_object_check(current_migration, &error_fatal);
>
> so the bool isn't used/checked.
>
> So I'm a bit conflicted:
>
>   a) Using error_fatal is the easiest way to handle this function
>   b) Things taking Error ** normally do return a flag value
>   c) But it's not used in this case.
>
> Hmm.

I guess this generalizes to the bigger question of whether a global
"return-value-never-used" check makes sense and brings value. Maybe
there are too many cases where it would be preferable to keep the
return value for consistency? Maybe they're not that many and could be
tagged with __attribute__((unused))?

But in this particular case, perhaps we could drop the Error **errp
parameter and directly pass &error_fatal to migrate_params_check() and
migrate_caps_check().

Alberto

