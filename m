Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1245EEFAB
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 09:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235068AbiI2Htt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 03:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235400AbiI2Htf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 03:49:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8E013A94F
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 00:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664437768;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B5qI7b94+taNEfTbBkn8B22CaCzkL3JdPIVHISnwlAM=;
        b=Ipp3c6iWzFuTbUvuU10X7Xq0TlPoEJ0qsmHuz2bR8PEKCfYqVjalvvmP8aZmirUs+6XLBw
        SNp0f6XjMQZgoHmAkr/NdxVZp9fKmkhmNOMJ4TjO02z6gT/fd0U1Koj5bPs7EGA6pQ3DDL
        RVJLVRnaOOaQiAgFfdC9R+yCeRVdoYs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-608-6OwU9SprPiKxGktH_bTo-Q-1; Thu, 29 Sep 2022 03:49:24 -0400
X-MC-Unique: 6OwU9SprPiKxGktH_bTo-Q-1
Received: by mail-wm1-f71.google.com with SMTP id p36-20020a05600c1da400b003b4faefa2b9so321259wms.6
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 00:49:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=B5qI7b94+taNEfTbBkn8B22CaCzkL3JdPIVHISnwlAM=;
        b=aS1GF9sFpQNngiwFCVzlyJVQQJ1aS60rv2VhK1L0qF4abmMOjdazIQcQDfgHvMwKZ3
         /OXfya8ZTo5VtXvt2MrMAThsHejvTs3SlsWWsRFvDRNPe1lxBZcmV30uyvy0WeGyEQc/
         F2ozM8KYEYQQoZAuvYC1Ft+F2j1DG02n/xP7YrqBqh2QH9EPNZQX6jM671yfpw8Y4yAF
         RWvec/0H+9n8/B2q7CGSK39I5CXRhRjPygSJLl7ZHkGpbs9HvIHRSkedfS8tX2ngGEC2
         Fs/9Oqdx+sP6Dkk1QzK7FVAVlCI0atCPgOPeYAgICmo6KO8lOxX8hVqCP4eoDDSsN8yT
         eC5A==
X-Gm-Message-State: ACrzQf3loU4qPISqDsFhvtSG/CmVSTWbZKoGQBCC+XM+8rzuH1Ohsn0M
        zX1AXcjByZVpXjT452T/lXb6eiDLnjd+5fWkdzi2zxv+NTYN1Dtr5S7aiwp0PI1XSoLkvMazOZl
        AVRh3Qo4NehOh
X-Received: by 2002:a05:600c:4fd2:b0:3b4:cab9:44f0 with SMTP id o18-20020a05600c4fd200b003b4cab944f0mr9860804wmq.73.1664437762949;
        Thu, 29 Sep 2022 00:49:22 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4msH8Z/F3t4GcEn/O8enUvxnRZFEtbEHz6nKwdRFvfOH+ZEpp/nXVxoWlaKXFvrX79zD/DFA==
X-Received: by 2002:a05:600c:4fd2:b0:3b4:cab9:44f0 with SMTP id o18-20020a05600c4fd200b003b4cab944f0mr9860792wmq.73.1664437762720;
        Thu, 29 Sep 2022 00:49:22 -0700 (PDT)
Received: from redhat.com ([2.55.17.78])
        by smtp.gmail.com with ESMTPSA id bi16-20020a05600c3d9000b003b4de550e34sm3503540wmb.40.2022.09.29.00.49.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 00:49:22 -0700 (PDT)
Date:   Thu, 29 Sep 2022 03:49:18 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Junichi Uekawa =?utf-8?B?KOS4iuW3nee0lOS4gCk=?= 
        <uekawa@google.com>, Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Eric Dumazet <edumazet@google.com>, davem@davemloft.net,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Bobby Eshleman <bobby.eshleman@gmail.com>
Subject: Re: [PATCH] vhost/vsock: Use kvmalloc/kvfree for larger packets.
Message-ID: <20220929034807-mutt-send-email-mst@kernel.org>
References: <20220928064538.667678-1-uekawa@chromium.org>
 <20220928082823.wyxplop5wtpuurwo@sgarzare-redhat>
 <20220928052738-mutt-send-email-mst@kernel.org>
 <20220928151135.pvrlsylg6j3hzh74@sgarzare-redhat>
 <CADgJSGHxPWXJjbakEeWnqF42A03yK7Dpw6U1SKNLhk+B248Ymg@mail.gmail.com>
 <20220929031419-mutt-send-email-mst@kernel.org>
 <20220929074606.yqzihpcc7cl442c5@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220929074606.yqzihpcc7cl442c5@sgarzare-redhat>
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 29, 2022 at 09:46:06AM +0200, Stefano Garzarella wrote:
> On Thu, Sep 29, 2022 at 03:19:14AM -0400, Michael S. Tsirkin wrote:
> > On Thu, Sep 29, 2022 at 08:14:24AM +0900, Junichi Uekawa (上川純一) wrote:
> > > 2022年9月29日(木) 0:11 Stefano Garzarella <sgarzare@redhat.com>:
> > > >
> > > > On Wed, Sep 28, 2022 at 05:31:58AM -0400, Michael S. Tsirkin wrote:
> > > > >On Wed, Sep 28, 2022 at 10:28:23AM +0200, Stefano Garzarella wrote:
> > > > >> On Wed, Sep 28, 2022 at 03:45:38PM +0900, Junichi Uekawa wrote:
> > > > >> > When copying a large file over sftp over vsock, data size is usually 32kB,
> > > > >> > and kmalloc seems to fail to try to allocate 32 32kB regions.
> > > > >> >
> > > > >> > Call Trace:
> > > > >> >  [<ffffffffb6a0df64>] dump_stack+0x97/0xdb
> > > > >> >  [<ffffffffb68d6aed>] warn_alloc_failed+0x10f/0x138
> > > > >> >  [<ffffffffb68d868a>] ? __alloc_pages_direct_compact+0x38/0xc8
> > > > >> >  [<ffffffffb664619f>] __alloc_pages_nodemask+0x84c/0x90d
> > > > >> >  [<ffffffffb6646e56>] alloc_kmem_pages+0x17/0x19
> > > > >> >  [<ffffffffb6653a26>] kmalloc_order_trace+0x2b/0xdb
> > > > >> >  [<ffffffffb66682f3>] __kmalloc+0x177/0x1f7
> > > > >> >  [<ffffffffb66e0d94>] ? copy_from_iter+0x8d/0x31d
> > > > >> >  [<ffffffffc0689ab7>] vhost_vsock_handle_tx_kick+0x1fa/0x301 [vhost_vsock]
> > > > >> >  [<ffffffffc06828d9>] vhost_worker+0xf7/0x157 [vhost]
> > > > >> >  [<ffffffffb683ddce>] kthread+0xfd/0x105
> > > > >> >  [<ffffffffc06827e2>] ? vhost_dev_set_owner+0x22e/0x22e [vhost]
> > > > >> >  [<ffffffffb683dcd1>] ? flush_kthread_worker+0xf3/0xf3
> > > > >> >  [<ffffffffb6eb332e>] ret_from_fork+0x4e/0x80
> > > > >> >  [<ffffffffb683dcd1>] ? flush_kthread_worker+0xf3/0xf3
> > > > >> >
> > > > >> > Work around by doing kvmalloc instead.
> > > > >> >
> > > > >> > Signed-off-by: Junichi Uekawa <uekawa@chromium.org>
> > > > >
> > > > >My worry here is that this in more of a work around.
> > > > >It would be better to not allocate memory so aggressively:
> > > > >if we are so short on memory we should probably process
> > > > >packets one at a time. Is that very hard to implement?
> > > >
> > > > Currently the "virtio_vsock_pkt" is allocated in the "handle_kick"
> > > > callback of TX virtqueue. Then the packet is multiplexed on the right
> > > > socket queue, then the user space can de-queue it whenever they want.
> > > >
> > > > So maybe we can stop processing the virtqueue if we are short on memory,
> > > > but when can we restart the TX virtqueue processing?
> > > >
> > > > I think as long as the guest used only 4K buffers we had no problem, but
> > > > now that it can create larger buffers the host may not be able to
> > > > allocate it contiguously. Since there is no need to have them contiguous
> > > > here, I think this patch is okay.
> > > >
> > > > However, if we switch to sk_buff (as Bobby is already doing), maybe we
> > > > don't have this problem because I think there is some kind of
> > > > pre-allocated pool.
> > > >
> > > 
> > > Thank you for the review! I was wondering if this is a reasonable workaround (as
> > > we found that this patch makes a reliably crashing system into a
> > > reliably surviving system.)
> > > 
> > > 
> > > ... Sounds like it is a reasonable patch to use backported to older kernels?
> > 
> > Hmm. Good point about stable. OK.
> 
> Right, so in this case I think is better to add a Fixes tag. Since we used
> kmalloc from the beginning we can use the following:
> 
> Fixes: 433fc58e6bf2 ("VSOCK: Introduce vhost_vsock.ko")
> 
> > 
> > Acked-by: Michael S. Tsirkin <mst@redhat.com>
> > 
> 
> @Michael are you queueing this, or should it go through net tree?
> 
> Thanks,
> Stefano

net tree would be preferable, my pull for this release is kind of ready ... kuba?

-- 
MST

