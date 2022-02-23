Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F42174C19AD
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 18:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243315AbiBWRPH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 12:15:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbiBWRPG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 12:15:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 67FD433A
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 09:14:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645636477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rRO4MHe5Dmpeu5wHW26QySHaQNVY9l6AI+4qPBsGQkY=;
        b=J6BdfPDkDfFgUmJeNjGRJ5NAfYot5MMr9DFALKBKW4XUxmhaENexYYYE8I7K9Tp1murh+e
        5WDqf60L0mSMG35NjHHiAtrvAii4skIehn4WG4QsIhgl/c2shUGxdRIPgw5iALkqNqy1+T
        SZl9mR8r3l9Z5vFeJ2oT67L7ZrZfTt4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-116-QMiCaR_VOx2Rvz5c500L8Q-1; Wed, 23 Feb 2022 12:14:36 -0500
X-MC-Unique: QMiCaR_VOx2Rvz5c500L8Q-1
Received: by mail-ed1-f70.google.com with SMTP id s7-20020a508dc7000000b0040f29ccd65aso13957988edh.1
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 09:14:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rRO4MHe5Dmpeu5wHW26QySHaQNVY9l6AI+4qPBsGQkY=;
        b=jEbcc7/53SnDGzMZ+TRdXSYuAjhmvyCqNv7y1EauF9aA5SMdlZD5rUz6d4Og1vwnTX
         tyMiMlz/4ICWd+NZm+1fD/TWetqqjclbyK9ch0r6JnBgEJzRAdknRvyeD2/tZ8b79/kl
         aHfohTgwjLx6cnMMEiV/BpvajGuMRB7wShqggUYGv/8zoC4HOtMy9OIRuYOdxqiZX0Kc
         tExE5lYRYJKC5+IzuE+eDuvS38eMkTA/qi+LU4Z1MQTicAETGWZMY7cCh/PGzV5pf/2F
         ujUToZT1ADRw0vnQSdp2IY76iQfI2+VioGZXPz5xmBM3EbJvhJmQXBQjtLjO+WFZ8Yg3
         incQ==
X-Gm-Message-State: AOAM533HEsFKaeDYb/tiV4znkBVvtfW4rH3HScX0tarhXGE+8nMO/GGf
        +6sejcu+Pgwuqgt3bQmkqbjPUJEg+8mISmaqsI/T+77Ih5FQE+tXOR7dAs6LKPcqLYFOKqpPCGg
        Njs33YgL60kZD
X-Received: by 2002:a17:906:3c1a:b0:6ce:c404:9e3 with SMTP id h26-20020a1709063c1a00b006cec40409e3mr547084ejg.454.1645636474896;
        Wed, 23 Feb 2022 09:14:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyFbC2GbFDO/AufWV0HURAE2UGs+63XdWnFOFf8Y8ydxKIShtBILjWFthYbDKuUpTSONSh+Hw==
X-Received: by 2002:a17:906:3c1a:b0:6ce:c404:9e3 with SMTP id h26-20020a1709063c1a00b006cec40409e3mr547061ejg.454.1645636474553;
        Wed, 23 Feb 2022 09:14:34 -0800 (PST)
Received: from redhat.com ([2.55.145.157])
        by smtp.gmail.com with ESMTPSA id 9sm106442ejg.97.2022.02.23.09.14.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 09:14:33 -0800 (PST)
Date:   Wed, 23 Feb 2022 12:14:29 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Anirudh Rayabharam <mail@anirudhrb.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com,
        kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vhost: validate range size before adding to iotlb
Message-ID: <20220223121404-mutt-send-email-mst@kernel.org>
References: <20220221195303.13560-1-mail@anirudhrb.com>
 <CACGkMEvLE=kV4PxJLRjdSyKArU+MRx6b_mbLGZHSUgoAAZ+-Fg@mail.gmail.com>
 <YhRtQEWBF0kqWMsI@anirudhrb.com>
 <CACGkMEvd7ETC_ANyrOSAVz_i64xqpYYazmm=+39E51=DMRFXdw@mail.gmail.com>
 <20220222090511-mutt-send-email-mst@kernel.org>
 <YhUdDUSxuXTLltpZ@anirudhrb.com>
 <20220222181927-mutt-send-email-mst@kernel.org>
 <YhZCKii8KwkcU8fM@anirudhrb.com>
 <20220223101303-mutt-send-email-mst@kernel.org>
 <YhZlk5iiOexnBouX@anirudhrb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YhZlk5iiOexnBouX@anirudhrb.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 23, 2022 at 10:19:23PM +0530, Anirudh Rayabharam wrote:
> On Wed, Feb 23, 2022 at 10:15:01AM -0500, Michael S. Tsirkin wrote:
> > On Wed, Feb 23, 2022 at 07:48:18PM +0530, Anirudh Rayabharam wrote:
> > > On Tue, Feb 22, 2022 at 06:21:50PM -0500, Michael S. Tsirkin wrote:
> > > > On Tue, Feb 22, 2022 at 10:57:41PM +0530, Anirudh Rayabharam wrote:
> > > > > On Tue, Feb 22, 2022 at 10:02:29AM -0500, Michael S. Tsirkin wrote:
> > > > > > On Tue, Feb 22, 2022 at 03:11:07PM +0800, Jason Wang wrote:
> > > > > > > On Tue, Feb 22, 2022 at 12:57 PM Anirudh Rayabharam <mail@anirudhrb.com> wrote:
> > > > > > > >
> > > > > > > > On Tue, Feb 22, 2022 at 10:50:20AM +0800, Jason Wang wrote:
> > > > > > > > > On Tue, Feb 22, 2022 at 3:53 AM Anirudh Rayabharam <mail@anirudhrb.com> wrote:
> > > > > > > > > >
> > > > > > > > > > In vhost_iotlb_add_range_ctx(), validate the range size is non-zero
> > > > > > > > > > before proceeding with adding it to the iotlb.
> > > > > > > > > >
> > > > > > > > > > Range size can overflow to 0 when start is 0 and last is (2^64 - 1).
> > > > > > > > > > One instance where it can happen is when userspace sends an IOTLB
> > > > > > > > > > message with iova=size=uaddr=0 (vhost_process_iotlb_msg). So, an
> > > > > > > > > > entry with size = 0, start = 0, last = (2^64 - 1) ends up in the
> > > > > > > > > > iotlb. Next time a packet is sent, iotlb_access_ok() loops
> > > > > > > > > > indefinitely due to that erroneous entry:
> > > > > > > > > >
> > > > > > > > > >         Call Trace:
> > > > > > > > > >          <TASK>
> > > > > > > > > >          iotlb_access_ok+0x21b/0x3e0 drivers/vhost/vhost.c:1340
> > > > > > > > > >          vq_meta_prefetch+0xbc/0x280 drivers/vhost/vhost.c:1366
> > > > > > > > > >          vhost_transport_do_send_pkt+0xe0/0xfd0 drivers/vhost/vsock.c:104
> > > > > > > > > >          vhost_worker+0x23d/0x3d0 drivers/vhost/vhost.c:372
> > > > > > > > > >          kthread+0x2e9/0x3a0 kernel/kthread.c:377
> > > > > > > > > >          ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> > > > > > > > > >          </TASK>
> > > > > > > > > >
> > > > > > > > > > Reported by syzbot at:
> > > > > > > > > >         https://syzkaller.appspot.com/bug?extid=0abd373e2e50d704db87
> > > > > > > > > >
> > > > > > > > > > Reported-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com
> > > > > > > > > > Tested-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com
> > > > > > > > > > Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
> > > > > > > > > > ---
> > > > > > > > > >  drivers/vhost/iotlb.c | 6 ++++--
> > > > > > > > > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > > > > > > > > >
> > > > > > > > > > diff --git a/drivers/vhost/iotlb.c b/drivers/vhost/iotlb.c
> > > > > > > > > > index 670d56c879e5..b9de74bd2f9c 100644
> > > > > > > > > > --- a/drivers/vhost/iotlb.c
> > > > > > > > > > +++ b/drivers/vhost/iotlb.c
> > > > > > > > > > @@ -53,8 +53,10 @@ int vhost_iotlb_add_range_ctx(struct vhost_iotlb *iotlb,
> > > > > > > > > >                               void *opaque)
> > > > > > > > > >  {
> > > > > > > > > >         struct vhost_iotlb_map *map;
> > > > > > > > > > +       u64 size = last - start + 1;
> > > > > > > > > >
> > > > > > > > > > -       if (last < start)
> > > > > > > > > > +       // size can overflow to 0 when start is 0 and last is (2^64 - 1).
> > > > > > > > > > +       if (last < start || size == 0)
> > > > > > > > > >                 return -EFAULT;
> > > > > > > > >
> > > > > > > > > I'd move this check to vhost_chr_iter_write(), then for the device who
> > > > > > > > > has its own msg handler (e.g vDPA) can benefit from it as well.
> > > > > > > >
> > > > > > > > Thanks for reviewing!
> > > > > > > >
> > > > > > > > I kept the check here thinking that all devices would benefit from it
> > > > > > > > because they would need to call vhost_iotlb_add_range() to add an entry
> > > > > > > > to the iotlb. Isn't that correct?
> > > > > > > 
> > > > > > > Correct for now but not for the future, it's not guaranteed that the
> > > > > > > per device iotlb message handler will use vhost iotlb.
> > > > > > > 
> > > > > > > But I agree that we probably don't need to care about it too much now.
> > > > > > > 
> > > > > > > > Do you see any other benefit in moving
> > > > > > > > it to vhost_chr_iter_write()?
> > > > > > > >
> > > > > > > > One concern I have is that if we move it out some future caller to
> > > > > > > > vhost_iotlb_add_range() might forget to handle this case.
> > > > > > > 
> > > > > > > Yes.
> > > > > > > 
> > > > > > > Rethink the whole fix, we're basically rejecting [0, ULONG_MAX] range
> > > > > > > which seems a little bit odd.
> > > > > > 
> > > > > > Well, I guess ideally we'd split this up as two entries - this kind of
> > > > > > thing is after all one of the reasons we initially used first,last as
> > > > > > the API - as opposed to first,size.
> > > > > 
> > > > > IIUC, the APIs exposed to userspace accept first,size.
> > > > 
> > > > Some of them.
> > > > 
> > > > 
> > > > /* vhost vdpa IOVA range
> > > >  * @first: First address that can be mapped by vhost-vDPA
> > > >  * @last: Last address that can be mapped by vhost-vDPA
> > > >  */
> > > > struct vhost_vdpa_iova_range {
> > > >         __u64 first;
> > > >         __u64 last;
> > > > };
> > > 
> > > Alright, I will split it into two entries. That doesn't fully address
> > > the bug though. I would also need to validate size in vhost_chr_iter_write().
> > 
> > Do you mean vhost_chr_write_iter?
> 
> Yes, my bad.
> 
> > 
> > > 
> > > Should I do both in one patch or as a two patch series?
> > 
> > I'm not sure why we need to do validation in vhost_chr_iter_write,
> > hard to say without seeing the patch.
> 
> Well, if userspace sends iova = 0 and size = 0 in vhost_iotlb_msg, we will end
> up mapping the range [0, ULONG_MAX] in iotlb which doesn't make sense. We
> should probably reject when size = 0.
> 
> As Jason pointed out [1], having the check in vhost_chr_write_iter() will
> also benefit devices that have their own message handler.
> 
> [1]: https://lore.kernel.org/kvm/CACGkMEvLE=kV4PxJLRjdSyKArU+MRx6b_mbLGZHSUgoAAZ+-Fg@mail.gmail.com/

Oh. Makes sense.

I think one patch is enough.

> > 
> > > > 
> > > > but
> > > > 
> > > > struct vhost_iotlb_msg {
> > > >         __u64 iova;
> > > >         __u64 size;
> > > >         __u64 uaddr;
> > > > #define VHOST_ACCESS_RO      0x1
> > > > #define VHOST_ACCESS_WO      0x2
> > > > #define VHOST_ACCESS_RW      0x3
> > > >         __u8 perm;
> > > > #define VHOST_IOTLB_MISS           1
> > > > #define VHOST_IOTLB_UPDATE         2
> > > > #define VHOST_IOTLB_INVALIDATE     3
> > > > #define VHOST_IOTLB_ACCESS_FAIL    4
> > > > /*
> > > >  * VHOST_IOTLB_BATCH_BEGIN and VHOST_IOTLB_BATCH_END allow modifying
> > > >  * multiple mappings in one go: beginning with
> > > >  * VHOST_IOTLB_BATCH_BEGIN, followed by any number of
> > > >  * VHOST_IOTLB_UPDATE messages, and ending with VHOST_IOTLB_BATCH_END.
> > > >  * When one of these two values is used as the message type, the rest
> > > >  * of the fields in the message are ignored. There's no guarantee that
> > > >  * these changes take place automatically in the device.
> > > >  */
> > > > #define VHOST_IOTLB_BATCH_BEGIN    5
> > > > #define VHOST_IOTLB_BATCH_END      6
> > > >         __u8 type;
> > > > };
> > > > 
> > > > 
> > > > 
> > > > > Which means that
> > > > > right now there is now way for userspace to map this range. So, is there
> > > > > any value in not simply rejecting this range?
> > > > > 
> > > > > > 
> > > > > > Anirudh, could you do it like this instead of rejecting?
> > > > > > 
> > > > > > 
> > > > > > > I wonder if it's better to just remove
> > > > > > > the map->size. Having a quick glance at the the user, I don't see any
> > > > > > > blocker for this.
> > > > > > > 
> > > > > > > Thanks
> > > > > > 
> > > > > > I think it's possible but won't solve the bug by itself, and we'd need
> > > > > > to review and fix all users - a high chance of introducing
> > > > > > another regression. 
> > > > > 
> > > > > Agreed, I did a quick review of the usages and getting rid of size
> > > > > didn't seem trivial.
> > > > > 
> > > > > Thanks,
> > > > > 
> > > > > 	- Anirudh.
> > > > > 
> > > > > > And I think there's value of fitting under the
> > > > > > stable rule of 100 lines with context.
> > > > > > So sure, but let's fix the bug first.
> > > > > > 
> > > > > > 
> > > > > > 
> > > > > > > >
> > > > > > > > Thanks!
> > > > > > > >
> > > > > > > >         - Anirudh.
> > > > > > > >
> > > > > > > > >
> > > > > > > > > Thanks
> > > > > > > > >
> > > > > > > > > >
> > > > > > > > > >         if (iotlb->limit &&
> > > > > > > > > > @@ -69,7 +71,7 @@ int vhost_iotlb_add_range_ctx(struct vhost_iotlb *iotlb,
> > > > > > > > > >                 return -ENOMEM;
> > > > > > > > > >
> > > > > > > > > >         map->start = start;
> > > > > > > > > > -       map->size = last - start + 1;
> > > > > > > > > > +       map->size = size;
> > > > > > > > > >         map->last = last;
> > > > > > > > > >         map->addr = addr;
> > > > > > > > > >         map->perm = perm;
> > > > > > > > > > --
> > > > > > > > > > 2.35.1
> > > > > > > > > >
> > > > > > > > >
> > > > > > > >
> > > > > > 
> > > > 
> > 

