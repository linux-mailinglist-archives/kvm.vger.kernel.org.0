Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBFA07BD905
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 12:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346112AbjJIKxb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 06:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346076AbjJIKx1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 06:53:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60FAADB
        for <kvm@vger.kernel.org>; Mon,  9 Oct 2023 03:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696848760;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HjiO4Hvw+fsOPZZWLwNP0lglpX+bcklExOuRO6AMksY=;
        b=Kk46TxtatWBM17maBUQKjJVqA7r+YNXUp2oosE5nwHOJ3iOH8oPN9zlI1+yZxLPHS7JFXL
        txfD9ko1qO+O585+G8EnN+hid0+X2D/wQQ6h8b4pNktRVDH3AurLAX6V8yIezM8mKEQLgY
        TdANhaWazQxOMrdHyjghpDcN7sTLQj0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-513-z9oI9xVIPS6aAjgmCNZBhg-1; Mon, 09 Oct 2023 06:52:39 -0400
X-MC-Unique: z9oI9xVIPS6aAjgmCNZBhg-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-40647c6f71dso33294825e9.2
        for <kvm@vger.kernel.org>; Mon, 09 Oct 2023 03:52:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696848758; x=1697453558;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HjiO4Hvw+fsOPZZWLwNP0lglpX+bcklExOuRO6AMksY=;
        b=sFoISXIiLxw1c99yrh/0BDZ+Wvd+cqtm/hDRd8iORJ9A6dv6pcjnDkXkP67OH1fGh8
         BHpvAdspkk5GgLbTn4OtTKxg0oDnyefOlC4gB2K9z72HTyCrCwYKwkSltlvI0KBiyIbw
         hvVff0IzEqclbyf2hmWp14zhvbRvuuB/lOI801YVv/jRPXyDBfmYI/bfGMu3CIJ64Nwy
         CIpRD9LV01hq3RjpEcS3wNGfETf/bzfHg78VJf1F2nh21EW8mFNHvalZ9gFzCz57dY+L
         FF1USvg1h0p+g4TOjd/Js3WNa7wpjJmtZPKygamKGLBshGnqnINNfiP1MDJAIf6AFP5a
         e+3w==
X-Gm-Message-State: AOJu0YyyLI96CWkvGaUZ4POB2AJq16tJtqw1zdhYbD9oBV0v0B3zqztV
        5NCTUirfkae8QaIIXymXFZIt6/rBr8sjpaUMLTjJ5MECEbV3Uwtm4h9kjnLQigQQ+dcSj0jYQYM
        y5a2x6lVoPEjW
X-Received: by 2002:a7b:cd8e:0:b0:405:3a3d:6f53 with SMTP id y14-20020a7bcd8e000000b004053a3d6f53mr12910441wmj.3.1696848758031;
        Mon, 09 Oct 2023 03:52:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEgWahkpsmLf/aOwZysFtiHkjovc5aRAyJtzXWyUzsNyUbJBrMocRm41ehhlwu8cg3xsXBpvA==
X-Received: by 2002:a7b:cd8e:0:b0:405:3a3d:6f53 with SMTP id y14-20020a7bcd8e000000b004053a3d6f53mr12910428wmj.3.1696848757617;
        Mon, 09 Oct 2023 03:52:37 -0700 (PDT)
Received: from redhat.com ([2a02:14f:16f:5caf:857a:f352:c1fc:cf50])
        by smtp.gmail.com with ESMTPSA id z3-20020a056000110300b0031c6581d55esm9224958wrw.91.2023.10.09.03.52.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Oct 2023 03:52:36 -0700 (PDT)
Date:   Mon, 9 Oct 2023 06:52:32 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Liming Wu <liming.wu@jaguarmicro.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "398776277@qq.com" <398776277@qq.com>
Subject: Re: [PATCH 2/2] tools/virtio: Add hints when module is not installed
Message-ID: <20231009063735-mutt-send-email-mst@kernel.org>
References: <20230926050021.717-1-liming.wu@jaguarmicro.com>
 <20230926050021.717-2-liming.wu@jaguarmicro.com>
 <CACGkMEujvBtAx=1eTqSrzyjBde=0xpC9D0sRVC7wHHf_aqfqwg@mail.gmail.com>
 <PSAPR06MB3942238B1D7218934A2BB8B4E1CEA@PSAPR06MB3942.apcprd06.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <PSAPR06MB3942238B1D7218934A2BB8B4E1CEA@PSAPR06MB3942.apcprd06.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 09, 2023 at 02:44:55AM +0000, Liming Wu wrote:
> 
> 
> > -----Original Message-----
> > From: Jason Wang <jasowang@redhat.com>
> > Sent: Sunday, October 8, 2023 12:36 PM
> > To: Liming Wu <liming.wu@jaguarmicro.com>
> > Cc: Michael S . Tsirkin <mst@redhat.com>; kvm@vger.kernel.org;
> > virtualization@lists.linux-foundation.org; netdev@vger.kernel.org; linux-
> > kernel@vger.kernel.org; 398776277@qq.com
> > Subject: Re: [PATCH 2/2] tools/virtio: Add hints when module is not installed
> > 
> > On Tue, Sep 26, 2023 at 1:00 PM <liming.wu@jaguarmicro.com> wrote:
> > >
> > > From: Liming Wu <liming.wu@jaguarmicro.com>
> > >
> > > Need to insmod vhost_test.ko before run virtio_test.
> > > Give some hints to users.
> > >
> > > Signed-off-by: Liming Wu <liming.wu@jaguarmicro.com>
> > > ---
> > >  tools/virtio/virtio_test.c | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > >
> > > diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
> > > index 028f54e6854a..ce2c4d93d735 100644
> > > --- a/tools/virtio/virtio_test.c
> > > +++ b/tools/virtio/virtio_test.c
> > > @@ -135,6 +135,10 @@ static void vdev_info_init(struct vdev_info* dev,
> > unsigned long long features)
> > >         dev->buf = malloc(dev->buf_size);
> > >         assert(dev->buf);
> > >         dev->control = open("/dev/vhost-test", O_RDWR);
> > > +
> > > +       if (dev->control < 0)
> > > +               fprintf(stderr, "Install vhost_test module" \
> > > +               "(./vhost_test/vhost_test.ko) firstly\n");
> > 
> > There should be many other reasons to fail for open().
> > 
> > Let's use strerror()?
> Yes,  Thanks for the review. 
> Please rechecked the code as follow:
> --- a/tools/virtio/virtio_test.c
> +++ b/tools/virtio/virtio_test.c
> @@ -135,6 +135,11 @@ static void vdev_info_init(struct vdev_info* dev, unsigned long long features)
>         dev->buf = malloc(dev->buf_size);
>         assert(dev->buf);
>         dev->control = open("/dev/vhost-test", O_RDWR);
> +
> +       if (dev->control == NULL)


???
Why are you comparing a file descriptor to NULL?

> +               fprintf(stderr,
> +                       "%s: Check whether vhost_test.ko is installed.\n",
> +                       strerror(errno));


No, do not suggest checking unconditionally this is just wasting user's
time.  You would have to check the exact errno value. You will either
get ENOENT or ENODEV if module is not loaded. Other errors indicate
other problems.  And what matters is whether it's loaded, not installed
- vhost_test.ko will not get auto-loaded even if installed.


>         assert(dev->control >= 0);
>         r = ioctl(dev->control, VHOST_SET_OWNER, NULL);
>         assert(r >= 0);
>  
> Thanks
> 

In short, I am not applying this patch. If you really want to make
things a bit easier in case of errors, replace all assert r >= 0 with
a macro that prints out strerror(errno), that should be enough.
Maybe print file/line number too while we are at it.

-- 
MST

