Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6FE3680246
	for <lists+kvm@lfdr.de>; Sun, 29 Jan 2023 23:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235423AbjA2WeW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Jan 2023 17:34:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234780AbjA2WeV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 Jan 2023 17:34:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D67113FF
        for <kvm@vger.kernel.org>; Sun, 29 Jan 2023 14:33:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675031612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/vCgiIjpi7lDX2G2pl/mU/xcfS28czOyjP9ouExjW/I=;
        b=L/X0No4BK5aY3XLDnbh6ahj7TAIi8SkDzkhdoaYuuAtntm9nlKP4o9hcfsVABToesEUqzW
        VE8x8TVxXyW68CoYHID680itcA9+HkaoDHdahWDzG/x03YMZzbHmEqPMyn2A941aIYEzRh
        Ax+pIKEfd5uCN9rLQo5izAV3P6GDY5s=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-472-fWmmh6nXNK6DHTLF1-NXRA-1; Sun, 29 Jan 2023 17:33:30 -0500
X-MC-Unique: fWmmh6nXNK6DHTLF1-NXRA-1
Received: by mail-wm1-f71.google.com with SMTP id o5-20020a05600c4fc500b003db0b3230efso8409495wmq.9
        for <kvm@vger.kernel.org>; Sun, 29 Jan 2023 14:33:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/vCgiIjpi7lDX2G2pl/mU/xcfS28czOyjP9ouExjW/I=;
        b=3dm29cgAGjFALWKEbl03VvYOKbFrR8P29VGGTS68YeMFNRnZgMZRm75DHXlX9ae/4t
         l0px20xDlg4z2lSnW0QdYyQHO6yDDkayqJTjnukaNfwS8LpgfgOpmnWEOmWMG4ZGCXrK
         dQRxaNppXw6ZnBUuRGql3ueve+woLsWR0OJUAZvwa11FSE+mTdqPRKxeuOllfaVEVsZ+
         fEzK9jwCl6Ub2+L9mzlVRYk1t4K70YYO5DMNwSBFMkJ86ofqlj1h3Rh2WINSy0rjhHLC
         syZO4mSYiYVC80zihoEoFSuWJD0yXQ4i4RHx+88W7dgL9Miu6XaL0SS0QWtLchdtkeu+
         IoqQ==
X-Gm-Message-State: AO0yUKUB8YKpyNmgyznUwVvB40rhORIiWbGCcNcsGlpPhxau5p3Lmd41
        GcNykJC8tNB99cJJyL4V0gBtkxL5hO0E8l8PLA5WWcYmWxdF6YuzL3GdZEnq8MdiNjRvG/NflxI
        NG/TIBkYRYfmH
X-Received: by 2002:adf:a504:0:b0:2bf:ae0e:23d8 with SMTP id i4-20020adfa504000000b002bfae0e23d8mr19938610wrb.32.1675031609459;
        Sun, 29 Jan 2023 14:33:29 -0800 (PST)
X-Google-Smtp-Source: AK7set8I7BUkRtGi/Rxw0hzJh9BWvW50ICv0ytFQopbAPGiDJ0T7eGj+CJs02SjD3RVR4wxiLoWToQ==
X-Received: by 2002:adf:a504:0:b0:2bf:ae0e:23d8 with SMTP id i4-20020adfa504000000b002bfae0e23d8mr19938603wrb.32.1675031609234;
        Sun, 29 Jan 2023 14:33:29 -0800 (PST)
Received: from redhat.com ([2.52.20.248])
        by smtp.gmail.com with ESMTPSA id f12-20020adfdb4c000000b002bfb1de74absm10168012wrj.114.2023.01.29.14.33.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Jan 2023 14:33:26 -0800 (PST)
Date:   Sun, 29 Jan 2023 17:33:23 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, jasowang@redhat.com, kvm@vger.kernel.org,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        peterx@redhat.com, lvivier@redhat.com
Subject: Re: [PATCH 0/2] vhost/net: Clear the pending messages when the
 backend is removed
Message-ID: <20230129173240-mutt-send-email-mst@kernel.org>
References: <20230117151518.44725-1-eric.auger@redhat.com>
 <3fe5971a-5991-488f-cef5-473c9faa1ba1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3fe5971a-5991-488f-cef5-473c9faa1ba1@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jan 29, 2023 at 06:58:09PM +0100, Eric Auger wrote:
> Hi,
> 
> On 1/17/23 16:15, Eric Auger wrote:
> > When the vhost iotlb is used along with a guest virtual iommu
> > and the guest gets rebooted, some MISS messages may have been
> > recorded just before the reboot and spuriously executed by
> > the virtual iommu after the reboot. This is due to the fact
> > the pending messages are not cleared.
> >
> > As vhost does not have any explicit reset user API,
> > VHOST_NET_SET_BACKEND looks a reasonable point where to clear
> > the pending messages, in case the backend is removed (fd = -1).
> >
> > This version is a follow-up on the discussions held in [1].
> >
> > The first patch removes an unused 'enabled' parameter in
> > vhost_init_device_iotlb().
> 
> Gentle Ping. Does it look a reasonable fix now?
> 
> Thanks
> 
> Eric

Yes I applied this - giving it a bit of time in next.

> >
> > Best Regards
> >
> > Eric
> >
> > History:
> > [1] RFC: [RFC] vhost: Clear the pending messages on vhost_init_device_iotlb()
> > https://lore.kernel.org/all/20221107203431.368306-1-eric.auger@redhat.com/
> >
> > Eric Auger (2):
> >   vhost: Remove the enabled parameter from vhost_init_device_iotlb
> >   vhost/net: Clear the pending messages when the backend is removed
> >
> >  drivers/vhost/net.c   | 5 ++++-
> >  drivers/vhost/vhost.c | 5 +++--
> >  drivers/vhost/vhost.h | 3 ++-
> >  3 files changed, 9 insertions(+), 4 deletions(-)
> >

