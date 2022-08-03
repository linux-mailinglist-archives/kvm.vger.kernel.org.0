Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 607AA588ABF
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 12:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233605AbiHCKqh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 06:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiHCKqf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 06:46:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 29584DBE
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 03:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659523592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MdnLN5PIt1FMlGFlixO3xRUWYIqpyA/qYv0kgPzaN/4=;
        b=gh1IOWhDRhQEZtdGYYJmDUSd3VwuOeI4Z2qtSzknxrOLuey4j1+GL3h7gJyH9WNZKPcMHo
        Fux9woyBNL8huyJzbqONtcBXl1DerbWzqJ4dPgqfE1llDQInGxOUCP6XxtPio3MnVEqYYK
        OcuNpwUV5U5aOu7jvJyVe4bhiNMMNZQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-102-qj-VmAJEOWStmarPZCgYDA-1; Wed, 03 Aug 2022 06:46:31 -0400
X-MC-Unique: qj-VmAJEOWStmarPZCgYDA-1
Received: by mail-wm1-f72.google.com with SMTP id p2-20020a05600c1d8200b003a3262d9c51so873229wms.6
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 03:46:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MdnLN5PIt1FMlGFlixO3xRUWYIqpyA/qYv0kgPzaN/4=;
        b=mye50JvAi/k3KWZKTyH6IzenqUkdncVs10judhp/JkRLfq6mJQNL7bQZU6DkhGebJF
         TlRq4yFdzLanCXrKMOMcLSe7GVepwv5pVwkq0xFHxO0VcRjH1BSJ0GTJmuAFnOFjw/Yl
         IRAkEP0NVRRRGT1RcAtsP453YE+Dk+dEbXwVJcZQp73X1yXFM3L8vS5WnMTdxOdrJcNe
         JdY0zdnfxYlZ360IpQHWlBeKJ7L+SPNYdsHmLudaU48inaGaPWtjFCMMkwuo0+InGwlI
         Don/STtPCQDVLO4VEsu0AJJ3a7zkykk05xtG/Cl8nQU6lYS9ZrmwAwnLfmQrQ/G3aggc
         8TQg==
X-Gm-Message-State: ACgBeo0+qj1p89HxzYtr519dos6MTlrfKmJvaXcUiE1oxvoTzZdgtrQc
        Wr4UeYGyOTTaBQFOKVOZ3ZGcc5wHpF3psAh6ZAaU8JYtEMp+5gF8a/UioWub5F4Ccmlijz751XW
        HRTJrDfYxVGyL
X-Received: by 2002:a05:600c:4b96:b0:3a4:e8c6:97fa with SMTP id e22-20020a05600c4b9600b003a4e8c697famr2388951wmp.102.1659523590290;
        Wed, 03 Aug 2022 03:46:30 -0700 (PDT)
X-Google-Smtp-Source: AA6agR469/a5z2MM262xtAy5hyusMtpj0BUZe7dtHcbtdxY+7tPKtrPBq6S4/4D+U15jJicJLhkp6A==
X-Received: by 2002:a05:600c:4b96:b0:3a4:e8c6:97fa with SMTP id e22-20020a05600c4b9600b003a4e8c697famr2388909wmp.102.1659523590082;
        Wed, 03 Aug 2022 03:46:30 -0700 (PDT)
Received: from work-vm (cpc109025-salf6-2-0-cust480.10-2.cable.virginm.net. [82.30.61.225])
        by smtp.gmail.com with ESMTPSA id m1-20020a7bcb81000000b003a3278d5cafsm1958553wmi.28.2022.08.03.03.46.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 03:46:29 -0700 (PDT)
Date:   Wed, 3 Aug 2022 11:46:26 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Alberto Faria <afaria@redhat.com>,
        Markus Armbruster <armbru@redhat.com>
Cc:     qemu-devel@nongnu.org,
        =?iso-8859-1?Q?Marc-Andr=E9?= Lureau 
        <marcandre.lureau@redhat.com>,
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
        Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>,
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
        Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        "Richard W.M. Jones" <rjones@redhat.com>,
        John Snow <jsnow@redhat.com>
Subject: Re: [RFC v2 02/10] Drop unused static function return values
Message-ID: <YupSAhFRK962i+nL@work-vm>
References: <20220729130040.1428779-1-afaria@redhat.com>
 <20220729130040.1428779-3-afaria@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220729130040.1428779-3-afaria@redhat.com>
User-Agent: Mutt/2.2.6 (2022-06-05)
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Alberto Faria (afaria@redhat.com) wrote:
> Make non-void static functions whose return values are ignored by
> all callers return void instead.
> 
> These functions were found by static-analyzer.py.
> 
> Not all occurrences of this problem were fixed.
> 
> Signed-off-by: Alberto Faria <afaria@redhat.com>

<snip>

> diff --git a/migration/migration.c b/migration/migration.c
> index e03f698a3c..4698080f96 100644
> --- a/migration/migration.c
> +++ b/migration/migration.c
> @@ -175,7 +175,7 @@ static MigrationIncomingState *current_incoming;
>  
>  static GSList *migration_blockers;
>  
> -static bool migration_object_check(MigrationState *ms, Error **errp);
> +static void migration_object_check(MigrationState *ms, Error **errp);
>  static int migration_maybe_pause(MigrationState *s,
>                                   int *current_active_state,
>                                   int new_state);
> @@ -4485,15 +4485,15 @@ static void migration_instance_init(Object *obj)
>   * Return true if check pass, false otherwise. Error will be put
>   * inside errp if provided.
>   */
> -static bool migration_object_check(MigrationState *ms, Error **errp)
> +static void migration_object_check(MigrationState *ms, Error **errp)
>  {

I'm not sure if this is a good change.
Where we have a function that returns an error via an Error ** it's
normal practice for us to return a bool to say whether it generated an
error.

Now, in our case we only call it with error_fatal:

    migration_object_check(current_migration, &error_fatal);

so the bool isn't used/checked.

So I'm a bit conflicted:

  a) Using error_fatal is the easiest way to handle this function
  b) Things taking Error ** normally do return a flag value
  c) But it's not used in this case.

Hmm.

Dave

>      MigrationCapabilityStatusList *head = NULL;
>      /* Assuming all off */
> -    bool cap_list[MIGRATION_CAPABILITY__MAX] = { 0 }, ret;
> +    bool cap_list[MIGRATION_CAPABILITY__MAX] = { 0 };
>      int i;
>  
>      if (!migrate_params_check(&ms->parameters, errp)) {
> -        return false;
> +        return;
>      }
>  
>      for (i = 0; i < MIGRATION_CAPABILITY__MAX; i++) {
> @@ -4502,12 +4502,10 @@ static bool migration_object_check(MigrationState *ms, Error **errp)
>          }
>      }
>  
> -    ret = migrate_caps_check(cap_list, head, errp);
> +    migrate_caps_check(cap_list, head, errp);
>  
>      /* It works with head == NULL */
>      qapi_free_MigrationCapabilityStatusList(head);
> -
> -    return ret;
>  }
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

