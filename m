Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D928A5913E0
	for <lists+kvm@lfdr.de>; Fri, 12 Aug 2022 18:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239327AbiHLQaC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Aug 2022 12:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236015AbiHLQaB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Aug 2022 12:30:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C6782AE9C0
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 09:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660321799;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nul/L14LVJGmSoKk9jRKbJpSiPNJPuolWbE5su9XgAY=;
        b=CY9G9Bqian6wcSrUIpzPRX/dkesenf1zS4VOdFSG3soeXylugGxGIIqFO467x955SCAHrm
        uINM1BIU5K7a0EeEJ5GaQkCxJ/LdXdlvTv0gsb5X1+nEg5T/zL61uOX0ZOpbT4d3G6poR/
        TT37Qgw16C1oZ+8UbmlNGRTGGEOcTqM=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-266-WAqjVyOxMSuhkP_rZN9soA-1; Fri, 12 Aug 2022 12:29:58 -0400
X-MC-Unique: WAqjVyOxMSuhkP_rZN9soA-1
Received: by mail-il1-f198.google.com with SMTP id i12-20020a056e021d0c00b002df2d676974so885847ila.5
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 09:29:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=nul/L14LVJGmSoKk9jRKbJpSiPNJPuolWbE5su9XgAY=;
        b=dQXZGdPo2Vwj4Hx18sZE3xkGGF75huBZN0rbhJebyVn6x1lkhIH9mf3vkas/ZscAeZ
         YE1bNgRjU1rlYoQQNk9UnOrX/53l86bdQ6EbfRlEDEwoJMP5F/JNVdBRcH2gU5pK8lCT
         knF7eVu8ncUTyzQP6OA305BntQ32ZZhwX0Nw5nZVcf9BCEppYceHB/INbzKO4iIoaXjk
         TlHnSTR7IgIoPsV2k2o5MuFU0ZtVsYu9/E18Jmx3rz3sudLqpMyc/Bw0tjPgcRbI8dds
         JswPRlJAgUtMjRnLePKqamzZlnqv+V7fV5unFIKkRVi8GKL3l2IXb56re4dAB7IggGcT
         JWUQ==
X-Gm-Message-State: ACgBeo14MIRZ0/F/LAzX2CZ8SEUQwRER250SFoTuc7KsUwxcVAhy24NL
        VOfMxbfp4kWWjnt55v8Dexbe5FaNMVLj14KdJU1l8BoyzmQkNHm7YuSSv/X7WfwcAbmYSsWweJM
        ZW5HkiAOEETYNC3aWUGuotK3l0T0+
X-Received: by 2002:a05:6602:1355:b0:669:40a5:9c26 with SMTP id i21-20020a056602135500b0066940a59c26mr2137533iov.105.1660321797959;
        Fri, 12 Aug 2022 09:29:57 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4hWTbeT1ytr7xbhX2e6Bc60xFonAWoAOKbYEg/4n/uXeT/dotMKPEVxy7fup0poHNOp+6b1VydDhsLwYBe7Pw=
X-Received: by 2002:a05:6602:1355:b0:669:40a5:9c26 with SMTP id
 i21-20020a056602135500b0066940a59c26mr2137505iov.105.1660321797700; Fri, 12
 Aug 2022 09:29:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220729130040.1428779-1-afaria@redhat.com> <20220729130040.1428779-3-afaria@redhat.com>
 <YupSAhFRK962i+nL@work-vm> <CAELaAXyh0MzuVzDCfhC8hJNAwb=niwFRsXqhc63JiWGxxitkqg@mail.gmail.com>
 <20220803111520.GO1127@redhat.com>
In-Reply-To: <20220803111520.GO1127@redhat.com>
From:   Alberto Faria <afaria@redhat.com>
Date:   Fri, 12 Aug 2022 17:29:21 +0100
Message-ID: <CAELaAXxm3whnSLeiMXqUsZPyp-n-aJcVfbkdiUxJyUthVSyO4w@mail.gmail.com>
Subject: Re: [RFC v2 02/10] Drop unused static function return values
To:     "Richard W.M. Jones" <rjones@redhat.com>
Cc:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Markus Armbruster <armbru@redhat.com>, qemu-devel@nongnu.org,
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
        John Snow <jsnow@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 3, 2022 at 12:15 PM Richard W.M. Jones <rjones@redhat.com> wrote:
> If it helps to think about this, Coverity checks for consistency.
> Across the whole code base, is the return value of a function used or
> ignored consistently.  You will see Coverity errors like:
>
>       Error: CHECKED_RETURN (CWE-252): [#def37]
>       libnbd-1.12.5/fuse/operations.c:180: check_return: Calling "nbd_poll" without checking return value (as is done elsewhere 5 out of 6 times).
>       libnbd-1.12.5/examples/aio-connect-read.c:96: example_checked: Example 1: "nbd_poll(nbd, -1)" has its value checked in "nbd_poll(nbd, -1) == -1".
>       libnbd-1.12.5/examples/aio-connect-read.c:128: example_checked: Example 2: "nbd_poll(nbd, -1)" has its value checked in "nbd_poll(nbd, -1) == -1".
>       libnbd-1.12.5/examples/strict-structured-reads.c:246: example_checked: Example 3: "nbd_poll(nbd, -1)" has its value checked in "nbd_poll(nbd, -1) == -1".
>       libnbd-1.12.5/ocaml/nbd-c.c:2599: example_assign: Example 4: Assigning: "r" = return value from "nbd_poll(h, timeout)".
>       libnbd-1.12.5/ocaml/nbd-c.c:2602: example_checked: Example 4 (cont.): "r" has its value checked in "r == -1".
>       libnbd-1.12.5/python/methods.c:2806: example_assign: Example 5: Assigning: "ret" = return value from "nbd_poll(h, timeout)".
>       libnbd-1.12.5/python/methods.c:2808: example_checked: Example 5 (cont.): "ret" has its value checked in "ret == -1".
>       #  178|       /* Dispatch work while there are commands in flight. */
>       #  179|       while (thread->in_flight > 0)
>       #  180|->       nbd_poll (h, -1);
>       #  181|     }
>       #  182|
>
> What it's saying is that in this code base, nbd_poll's return value
> was checked by the caller 5 out of 6 times, but ignored here.  (This
> turned out to be a real bug which we fixed).
>
> It seems like the check implemented in your patch is: If the return
> value is used 0 times anywhere in the code base, change the return
> value to 'void'.  Coverity would not flag this.
>
> Maybe a consistent use check is better?

Note that the analyzer is currently limited to analyzing a single
translation unit at a time, so we would only be able to implement a
consistent use check for static functions (this is why the current
"return-value-never-used" check only applies to static functions).

It may be worthwhile exploring cross-translation unit analysis,
although it may be difficult to accomplish while also avoiding
reanalyzing the entire tree every time a single translation unit is
modified.

Alberto

