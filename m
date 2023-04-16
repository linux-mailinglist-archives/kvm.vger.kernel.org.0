Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32E256F5BDF
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 18:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjECQYn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 12:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjECQYm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 12:24:42 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97ACB4EEC;
        Wed,  3 May 2023 09:24:41 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id 6a1803df08f44-61b40562054so19244636d6.2;
        Wed, 03 May 2023 09:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683131081; x=1685723081;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sw9QqCYI3NfDvOAwxZqy+pqKQX9Q426U/egFDVzlEnc=;
        b=a6F0ZjqneASILTQjU+yYaEb2zgAt657phMGoGS1jlfL7NxSHtU/T0nhHD5ldWYWRkB
         +eKpfVp/f3fKbpgEP41mwlvO5EjpV7N3ItjNIT4G6ncJ2Zi7cd2i69VeskuawSzMBxGH
         9ziL1NO1ldYuaAnAx1zXfp26AB4NrQx2h07YsNSAKT24NsB1iKaN6Ohe6fJVXF8VnToQ
         tqpQWumOXANaE7VXY05YWncn1k6omBchN/c36NDxwvgmhJu9bTAqYecqA2d8a9jXuhS+
         VkgjMofbG7RRy8sY8uUHXqNteczB54YvOqj/uwL9rtE8vLQmvmYBsh2SIwlPrc1OF1CV
         ZcFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683131081; x=1685723081;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sw9QqCYI3NfDvOAwxZqy+pqKQX9Q426U/egFDVzlEnc=;
        b=XRkWMybg7vDDcr8tgVj0tNDZzy67Mo8p6atPmcZI+aFe4105FLbFmbOwWljHozOfTO
         Nkhyb9UuiMB9noHliqy6eNfaC2SvM+LsmVj9eG1LYNlO/vT00d8AsgHf+L8zgPyJzjeC
         tESs90xeCkwWHam0tVnK04+Xzs0x0J+pm25RDtWIYsR9qOqDyAlg7dVK+Utc/s4PSi0x
         5Q+viFkSeigvrIy7zkvjrHe4VihZG6SV3kDGUF3s2No7k3UdkedQsrZyAPL6L5C7Do88
         2hA/aU0J8zfH5mQ/9EVj9A+/bl9hTeEANTcRAzgS7h9Wz70042HIT4Wws26GvmYfARFu
         KtVA==
X-Gm-Message-State: AC+VfDyQGtl8vyKjKT6khhGfKAmW/eyEAopbAlPRuKqtHIsqfrYRLuPx
        fGCRYvTNr5bqrNJXyxgAxKo=
X-Google-Smtp-Source: ACHHUZ7CdwuUrntbRy2s1KtwQRV0sVFazawz9jR5lZThhcrKI49S0z/ULMhK4JuQOEHozW/yrh0x0Q==
X-Received: by 2002:a05:6214:27e8:b0:5ef:6b6a:e612 with SMTP id jt8-20020a05621427e800b005ef6b6ae612mr9361375qvb.36.1683131080641;
        Wed, 03 May 2023 09:24:40 -0700 (PDT)
Received: from localhost (151.240.142.34.bc.googleusercontent.com. [34.142.240.151])
        by smtp.gmail.com with ESMTPSA id u17-20020a0ca711000000b0061a4a93eeadsm2100577qva.127.2023.05.03.09.24.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 09:24:40 -0700 (PDT)
Date:   Sun, 16 Apr 2023 06:57:53 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Cong Wang <cong.wang@bytedance.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [Patch net] vsock: improve tap delivery accuracy
Message-ID: <ZDuccSro8cLvhqJ7@bullseye>
References: <20230502174404.668749-1-xiyou.wangcong@gmail.com>
 <20230502201418.GG535070@fedora>
 <ZDt+PDtKlxrwUPnc@bullseye>
 <occeblxotmpsq4gqjjued62ar5ngqxehmmrj7jg3ynzsz2vfcy@4jzl7slmqkft>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <occeblxotmpsq4gqjjued62ar5ngqxehmmrj7jg3ynzsz2vfcy@4jzl7slmqkft>
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_96_XX,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 03, 2023 at 09:38:50AM +0200, Stefano Garzarella wrote:
> On Sun, Apr 16, 2023 at 04:49:00AM +0000, Bobby Eshleman wrote:
> > On Tue, May 02, 2023 at 04:14:18PM -0400, Stefan Hajnoczi wrote:
> > > On Tue, May 02, 2023 at 10:44:04AM -0700, Cong Wang wrote:
> > > > From: Cong Wang <cong.wang@bytedance.com>
> > > >
> > > > When virtqueue_add_sgs() fails, the skb is put back to send queue,
> > > > we should not deliver the copy to tap device in this case. So we
> > > > need to move virtio_transport_deliver_tap_pkt() down after all
> > > > possible failures.
> > > >
> > > > Fixes: 82dfb540aeb2 ("VSOCK: Add virtio vsock vsockmon hooks")
> > > > Cc: Stefan Hajnoczi <stefanha@redhat.com>
> > > > Cc: Stefano Garzarella <sgarzare@redhat.com>
> > > > Cc: Bobby Eshleman <bobby.eshleman@bytedance.com>
> > > > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > > > ---
> > > >  net/vmw_vsock/virtio_transport.c | 5 ++---
> > > >  1 file changed, 2 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> > > > index e95df847176b..055678628c07 100644
> > > > --- a/net/vmw_vsock/virtio_transport.c
> > > > +++ b/net/vmw_vsock/virtio_transport.c
> > > > @@ -109,9 +109,6 @@ virtio_transport_send_pkt_work(struct work_struct *work)
> > > >  		if (!skb)
> > > >  			break;
> > > >
> > > > -		virtio_transport_deliver_tap_pkt(skb);
> > > > -		reply = virtio_vsock_skb_reply(skb);
> > > > -
> > > >  		sg_init_one(&hdr, virtio_vsock_hdr(skb), sizeof(*virtio_vsock_hdr(skb)));
> > > >  		sgs[out_sg++] = &hdr;
> > > >  		if (skb->len > 0) {
> > > > @@ -128,6 +125,8 @@ virtio_transport_send_pkt_work(struct work_struct *work)
> > > >  			break;
> > > >  		}
> > > >
> > > > +		virtio_transport_deliver_tap_pkt(skb);
> 
> I would move only the virtio_transport_deliver_tap_pkt(),
> virtio_vsock_skb_reply() is not related.
> 
> > > > +		reply = virtio_vsock_skb_reply(skb);
> > > 
> > > I don't remember the reason for the ordering, but I'm pretty sure it was
> > > deliberate. Probably because the payload buffers could be freed as soon
> > > as virtqueue_add_sgs() is called.
> > > 
> > > If that's no longer true with Bobby's skbuff code, then maybe it's safe
> > > to monitor packets after they have been sent.
> > > 
> > > Stefan
> > 
> > Hey Stefan,
> > 
> > Unfortunately, skbuff doesn't change that behavior.
> > 
> > If I understand correctly, the problem flow you are describing
> > would be something like this:
> > 
> > Thread 0 			Thread 1
> > guest:virtqueue_add_sgs()[@send_pkt_work]
> > 
> > 				host:vhost_vq_get_desc()[@handle_tx_kick]
> > 				host:vhost_add_used()
> > 				host:vhost_signal()
> > 				guest:virtqueue_get_buf()[@tx_work]
> > 				guest:consume_skb()
> > 
> > guest:deliver_tap_pkt()[@send_pkt_work]
> > ^ use-after-free
> > 
> > Which I guess is possible because the receiver can consume the new
> > scatterlist during the processing kicked off for a previous batch?
> > (doesn't have to wait for the subsequent kick)
> 
> This is true, but both `send_pkt_work` and `tx_work` hold `tx_lock`, so can
> they really go in parallel?
> 

Oh good point, the tx_lock synchronizes it:

Thread 0 			Thread 1
guest:virtqueue_add_sgs()[@send_pkt_work]

				host:vhost_vq_get_desc()[@handle_tx_kick]
				host:vhost_add_used()
				host:vhost_signal()
				guest:mutex_lock()[@tx_work]
guest:deliver_tap_pkt()[@send_pkt_work]
guest:mutex_unlock()
				guest:virtqueue_get_buf()[@tx_work]
				guest:consume_skb()


I'm pretty sure this should be safe.

Best,
Bobby
