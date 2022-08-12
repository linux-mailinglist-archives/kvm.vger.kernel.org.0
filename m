Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9CFB591365
	for <lists+kvm@lfdr.de>; Fri, 12 Aug 2022 18:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238998AbiHLQCh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Aug 2022 12:02:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231271AbiHLQCf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Aug 2022 12:02:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DA7D89F0F3
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 09:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660320154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tWCROq06/HbysbDX3N02GUQEfkGQcYaVh4ssHk7eqwc=;
        b=NOjPlr03Ugf7H9KFjmXbBhz6icwZJvLGbOMhKo21s0g72LbuVI8LL4PuVUczFGv6rhhl23
        TV/97fDBy1Os6E0S/4kGcCgiMX9ab/AHEBkVUGTJdaAUVEpETCAUp5DQeBNTlHIYDblPH3
        i/1oANbYQtgcv+e7I24ZuE9bkVY+9fc=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-614-Px3xalNbO9uQ9dIbr-FmJg-1; Fri, 12 Aug 2022 12:02:32 -0400
X-MC-Unique: Px3xalNbO9uQ9dIbr-FmJg-1
Received: by mail-il1-f199.google.com with SMTP id i12-20020a056e021d0c00b002df2d676974so835200ila.5
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 09:02:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=tWCROq06/HbysbDX3N02GUQEfkGQcYaVh4ssHk7eqwc=;
        b=7IB6j+Iqk2o62/UDpnM1iz14E88Df7NnMj/3HtzW4DjWp1596rxmwb9qGvoEsHNeAd
         6cr1XPZzEYeFCqGFb5kcHdvMBrW712DOnw+lV/RG9nVLMM7+3g4cCARpt2gq36Nixfke
         ogp7ezPsQNjyxCkAXfLhGpZ9i3aovExj8wOr0J5dVygNNGkRMHvxUMtc8rAZMjUggicj
         2jBO61lc247OsTtM1aKJOsRvkj38B+Hq+uL65N2Yz9WmuxJ27MJ48vL4x2libOkTQhmW
         8z8lrgoniCCllvU8KwLNN/pR1U3koEkcSsNbNF0m25g+h380ZyQOslAK0oHU1ItGegtq
         yLhA==
X-Gm-Message-State: ACgBeo2pX6ao6XygUoTWkMr7K4aXhvHbk/yfs88rLxfqEdoKSdYm+pkL
        +gQvLWOVfK+rBb2YeUa+hkT+JYuui3uVLzCmPK3JXvDXiTFJwOO3Ix97g5AFo55mCerZrBe94iC
        Kmnrzgnb+l4WQM5SE5Mpqv1ujsZIe
X-Received: by 2002:a5d:8ac9:0:b0:684:b389:b38b with SMTP id e9-20020a5d8ac9000000b00684b389b38bmr1903808iot.138.1660320151758;
        Fri, 12 Aug 2022 09:02:31 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5ORavVDasHXUlmXGF33Nqlj8ou/AQhGkBgDe0Q7YskxE6HVFcfqmm3ez7gEp7HfYTpkab+qAlTTFngcZdFmxc=
X-Received: by 2002:a5d:8ac9:0:b0:684:b389:b38b with SMTP id
 e9-20020a5d8ac9000000b00684b389b38bmr1903793iot.138.1660320151551; Fri, 12
 Aug 2022 09:02:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220729130040.1428779-1-afaria@redhat.com> <20220729130040.1428779-3-afaria@redhat.com>
 <CAFEAcA83Eaw59H7ha0hScvX1yF8LrJatWqD-hnX0eVy+Ne4EUQ@mail.gmail.com>
In-Reply-To: <CAFEAcA83Eaw59H7ha0hScvX1yF8LrJatWqD-hnX0eVy+Ne4EUQ@mail.gmail.com>
From:   Alberto Faria <afaria@redhat.com>
Date:   Fri, 12 Aug 2022 17:01:55 +0100
Message-ID: <CAELaAXxWE60rvj3TH8cR8g46JO+n+s8AOEqMpErcSjXS+GN=XA@mail.gmail.com>
Subject: Re: [RFC v2 02/10] Drop unused static function return values
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     qemu-devel@nongnu.org,
        =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
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
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 3, 2022 at 1:30 PM Peter Maydell <peter.maydell@linaro.org> wrote:
> The problem with a patch like this is that it rolls up into a
> single patch changes to the API of many functions in multiple
> subsystems across the whole codebase. Some of those changes
> might be right; some might be wrong. No single person is going
> to be in a position to review the whole lot, and a +248-403
> patch email makes it very unwieldy to try to discuss.
>
> If you want to propose some of these I think you need to:
>  * split it out so that you're only suggesting changes in
>    one subsystem at a time
>  * look at the places you are suggesting changes, to see if
>    the correct answer is actually "add the missing error
>    check in the caller(s)"
>  * not change places that are following standard API patterns
>    like "return bool and have an Error** argument"

Sounds good. For now, I'll limit the changes to a few representative
cases e.g. in the block layer, since this patch is mostly intended as
a demonstration of the type of issue that the check catches. Once
there is agreement on the semantics for the check, I'll probably send
a separate tree-wide series with per-subsystem patches.

Thanks,
Alberto

