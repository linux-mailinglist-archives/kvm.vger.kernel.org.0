Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 364A9761882
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 14:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232663AbjGYMkK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 08:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbjGYMkI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 08:40:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9A79D
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 05:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690288765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C0L81qzAix0/zgzaASRrrWq5Ht6GiafQqJmF+ctDLSM=;
        b=LAOeFqNqAW/IrAclae8uratGgLMpkWxpctkKNC0Mj1XCXnN2sLkpWlwyXkfgOEN3aoeYG4
        t+aM0pvUhnaNOEbqVAhtBV77jdRtKSiioMsGJB0bcJ8Jz1VnsHNlj9yxqlMvyqmgC0ZTe/
        B8UlCE/kGqcx1X/6D+GS4Uk/CCYKGM8=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-258-2w0iofWRNbCwBPkyI5Hf4w-1; Tue, 25 Jul 2023 08:39:24 -0400
X-MC-Unique: 2w0iofWRNbCwBPkyI5Hf4w-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-5222d1b5b1cso2769631a12.1
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 05:39:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690288763; x=1690893563;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C0L81qzAix0/zgzaASRrrWq5Ht6GiafQqJmF+ctDLSM=;
        b=aUghTAqaSERWA/kG+tCJAeIIZME3fzfNmJTOLLY194dyGc2aXQKRoMEI5t+RkZ+dGS
         jE8u9hPmkZOmWtYDMu4HrMTHBsFY1CAAWoxR2jiQwHS7LU36kN0Wh1fI4OEDlQxo/FtH
         WHXUsQcD9ombXYrbsMoBuxp6+kOJLaMLuQNSrh3ekEKOAgDvExBky0PZ8G6oQqiobQ11
         5zRARbWpDTJDsE0iswB5Yf95uAxjxBAgjRRbgbEyWXBY2xAVGkYXLXV0zTilMHW61IWU
         KR36fLp7+fc2wCJbV7hTlhefY992nWMXjrTKjk23zSj1WwJ4vbiIKmtKPfF9ZnIdBsvM
         loKw==
X-Gm-Message-State: ABy/qLZYbNlEMKcCB/uT4KupoAo+FrS/6LZ1pr7/nDUT16qA1EH/Oyod
        HssLXLZCeZpdpUmJhoohZMfeEzWd1dh4U+J83brO82ksUk01PPk5mGP2NhQEexx7dIA5Y2Gr/b8
        aW517kfVRIDeh
X-Received: by 2002:a05:6402:7da:b0:521:d2ab:e4df with SMTP id u26-20020a05640207da00b00521d2abe4dfmr2242339edy.19.1690288763016;
        Tue, 25 Jul 2023 05:39:23 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEZbT/9sLf9SJUi2km6xKCfsN6lBnNmF8+myjdUi1f+mFGkC/VPgqG8v9x7Cn7VgrIjISJYxQ==
X-Received: by 2002:a05:6402:7da:b0:521:d2ab:e4df with SMTP id u26-20020a05640207da00b00521d2abe4dfmr2242326edy.19.1690288762712;
        Tue, 25 Jul 2023 05:39:22 -0700 (PDT)
Received: from redhat.com ([2.55.164.187])
        by smtp.gmail.com with ESMTPSA id kg13-20020a17090776ed00b009929ab17be0sm8168056ejc.162.2023.07.25.05.39.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jul 2023 05:39:22 -0700 (PDT)
Date:   Tue, 25 Jul 2023 08:39:17 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Arseniy Krasnov <avkrasnov@sberdevices.ru>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Subject: Re: [PATCH net-next v3 4/4] vsock/virtio: MSG_ZEROCOPY flag support
Message-ID: <20230725083823-mutt-send-email-mst@kernel.org>
References: <20230720214245.457298-1-AVKrasnov@sberdevices.ru>
 <20230720214245.457298-5-AVKrasnov@sberdevices.ru>
 <091c067b-43a0-da7f-265f-30c8c7e62977@sberdevices.ru>
 <2k3cbz762ua3fmlben5vcm7rs624sktaltbz3ldeevwiguwk2w@klggxj5e3ueu>
 <51022d5f-5b50-b943-ad92-b06f60bef433@sberdevices.ru>
 <3d1d76c9-2fdb-3dfe-222a-b2184cf17708@sberdevices.ru>
 <o6axh6mxd6mxai2zrpax6wa25slns7ysz5xsegntskvfxl53mt@wowjgb3jazt6>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <o6axh6mxd6mxai2zrpax6wa25slns7ysz5xsegntskvfxl53mt@wowjgb3jazt6>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 25, 2023 at 02:28:02PM +0200, Stefano Garzarella wrote:
> On Tue, Jul 25, 2023 at 12:16:11PM +0300, Arseniy Krasnov wrote:
> > 
> > 
> > On 25.07.2023 11:46, Arseniy Krasnov wrote:
> > > 
> > > 
> > > On 25.07.2023 11:43, Stefano Garzarella wrote:
> > > > On Fri, Jul 21, 2023 at 08:09:03AM +0300, Arseniy Krasnov wrote:
> > > > > 
> > > > > 
> > > > > On 21.07.2023 00:42, Arseniy Krasnov wrote:
> > > > > > This adds handling of MSG_ZEROCOPY flag on transmission path: if this
> > > > > > flag is set and zerocopy transmission is possible (enabled in socket
> > > > > > options and transport allows zerocopy), then non-linear skb will be
> > > > > > created and filled with the pages of user's buffer. Pages of user's
> > > > > > buffer are locked in memory by 'get_user_pages()'. Second thing that
> > > > > > this patch does is replace type of skb owning: instead of calling
> > > > > > 'skb_set_owner_sk_safe()' it calls 'skb_set_owner_w()'. Reason of this
> > > > > > change is that '__zerocopy_sg_from_iter()' increments 'sk_wmem_alloc'
> > > > > > of socket, so to decrease this field correctly proper skb destructor is
> > > > > > needed: 'sock_wfree()'. This destructor is set by 'skb_set_owner_w()'.
> > > > > > 
> > > > > > Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
> > > > > > ---
> > > > > >  Changelog:
> > > > > >  v5(big patchset) -> v1:
> > > > > >   * Refactorings of 'if' conditions.
> > > > > >   * Remove extra blank line.
> > > > > >   * Remove 'frag_off' field unneeded init.
> > > > > >   * Add function 'virtio_transport_fill_skb()' which fills both linear
> > > > > >     and non-linear skb with provided data.
> > > > > >  v1 -> v2:
> > > > > >   * Use original order of last four arguments in 'virtio_transport_alloc_skb()'.
> > > > > >  v2 -> v3:
> > > > > >   * Add new transport callback: 'msgzerocopy_check_iov'. It checks that
> > > > > >     provided 'iov_iter' with data could be sent in a zerocopy mode.
> > > > > >     If this callback is not set in transport - transport allows to send
> > > > > >     any 'iov_iter' in zerocopy mode. Otherwise - if callback returns 'true'
> > > > > >     then zerocopy is allowed. Reason of this callback is that in case of
> > > > > >     G2H transmission we insert whole skb to the tx virtio queue and such
> > > > > >     skb must fit to the size of the virtio queue to be sent in a single
> > > > > >     iteration (may be tx logic in 'virtio_transport.c' could be reworked
> > > > > >     as in vhost to support partial send of current skb). This callback
> > > > > >     will be enabled only for G2H path. For details pls see comment
> > > > > >     'Check that tx queue...' below.
> > > > > > 
> > > > > >  include/net/af_vsock.h                  |   3 +
> > > > > >  net/vmw_vsock/virtio_transport.c        |  39 ++++
> > > > > >  net/vmw_vsock/virtio_transport_common.c | 257 ++++++++++++++++++------
> > > > > >  3 files changed, 241 insertions(+), 58 deletions(-)
> > > > > > 
> > > > > > diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
> > > > > > index 0e7504a42925..a6b346eeeb8e 100644
> > > > > > --- a/include/net/af_vsock.h
> > > > > > +++ b/include/net/af_vsock.h
> > > > > > @@ -177,6 +177,9 @@ struct vsock_transport {
> > > > > > 
> > > > > >      /* Read a single skb */
> > > > > >      int (*read_skb)(struct vsock_sock *, skb_read_actor_t);
> > > > > > +
> > > > > > +    /* Zero-copy. */
> > > > > > +    bool (*msgzerocopy_check_iov)(const struct iov_iter *);
> > > > > >  };
> > > > > > 
> > > > > >  /**** CORE ****/
> > > > > > diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> > > > > > index 7bbcc8093e51..23cb8ed638c4 100644
> > > > > > --- a/net/vmw_vsock/virtio_transport.c
> > > > > > +++ b/net/vmw_vsock/virtio_transport.c
> > > > > > @@ -442,6 +442,43 @@ static void virtio_vsock_rx_done(struct virtqueue *vq)
> > > > > >      queue_work(virtio_vsock_workqueue, &vsock->rx_work);
> > > > > >  }
> > > > > > 
> > > > > > +static bool
> > > > > > virtio_transport_msgzerocopy_check_iov(const struct
> > > > > > iov_iter *iov)
> > > > > > +{
> > > > > > +    struct virtio_vsock *vsock;
> > > > > > +    bool res = false;
> > > > > > +
> > > > > > +    rcu_read_lock();
> > > > > > +
> > > > > > +    vsock = rcu_dereference(the_virtio_vsock);
> > > > > > +    if (vsock) {
> 
> Just noted, what about the following to reduce the indentation?
> 
>         if (!vsock) {
>             goto out;
>         }

no {} pls

>             ...
>             ...
>     out:
>         rcu_read_unlock();
>         return res;

indentation is quite modest here. Not sure goto is worth it.


