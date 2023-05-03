Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69C126F51E9
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 09:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjECHjt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 03:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbjECHjq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 03:39:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB481731
        for <kvm@vger.kernel.org>; Wed,  3 May 2023 00:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683099543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pAxcZhu4o2HVjJymB9Go0qnCuRBV6q3xEK19fZLvIig=;
        b=eLJt3cXz+wPbfogiEqnavlNRHefGXcRy2MynZE592tuUdjWdgGIrsCxGWW58Ry9X/WT46H
        i5Nyv7z+6YJSrxcUuCRxWDJ8VVvOwtbmo9hSzJH7gXjRy9sn9jCPBXOAR8pQjOKTypZST+
        xLgNg+jvEHP3itX9dmxSJPAZxQO/psw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-461-l5ugjqiTNQ22Rva9tmO7ng-1; Wed, 03 May 2023 03:38:56 -0400
X-MC-Unique: l5ugjqiTNQ22Rva9tmO7ng-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3062b468a36so1103800f8f.1
        for <kvm@vger.kernel.org>; Wed, 03 May 2023 00:38:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683099535; x=1685691535;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pAxcZhu4o2HVjJymB9Go0qnCuRBV6q3xEK19fZLvIig=;
        b=YNK79k+Y9POZvFck50I/+F88yOhTZSczIiRUQapy1JwQOQMmcJSZTUxzcZypT3YfoC
         i7lc5blaitwOgXxjwqbTMnedM0jWFcOcTR8LS5hM0BIaJvH/JVSzugYcMOCQH7QzfIZi
         SU3l0eHbS0XciPfmjFa5fMIK6XIa3FF6pr+3I1H77ajHkDcDCxArOE9rMylNaYIZOJF3
         94r3Rd1SZ01uaySWHpq7bapZExsQzI4v189Cs1Rk59V/8+Rpo04Z6wRaIhGzac1mA5D6
         OwRujC8pnu8uusWMY1sa2+TP6wZ8hMJB2x380pWLZO8KUvebEfnl+i6zSoqg6biVGUiP
         bWwQ==
X-Gm-Message-State: AC+VfDwabzw/7nazEDJh7thTa9Zi+0jK9FxQURdtvJun3dSPZ9A7FPdY
        UwJNFR17kMvwC5SdDVWdV6U0ngouOevyEc55ytpqBGRJqmHWTCWoVSZ5KRtABUmnBWtAUZUgdlB
        0F5j3oOjFJSy1m1PxEhYv
X-Received: by 2002:a5d:6446:0:b0:306:401d:8ce1 with SMTP id d6-20020a5d6446000000b00306401d8ce1mr1039279wrw.11.1683099535215;
        Wed, 03 May 2023 00:38:55 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4jS0rZK7zlXJSzh5byjzY89SiMYSDdqr7AlXInY7R+ycQXbuLMQVtQxwRIla52w9LsJ/EcZA==
X-Received: by 2002:a5d:6446:0:b0:306:401d:8ce1 with SMTP id d6-20020a5d6446000000b00306401d8ce1mr1039260wrw.11.1683099534906;
        Wed, 03 May 2023 00:38:54 -0700 (PDT)
Received: from sgarzare-redhat ([185.29.96.107])
        by smtp.gmail.com with ESMTPSA id r16-20020a5d4e50000000b002c7066a6f77sm32959330wrt.31.2023.05.03.00.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 00:38:53 -0700 (PDT)
Date:   Wed, 3 May 2023 09:38:50 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Bobby Eshleman <bobbyeshleman@gmail.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [Patch net] vsock: improve tap delivery accuracy
Message-ID: <occeblxotmpsq4gqjjued62ar5ngqxehmmrj7jg3ynzsz2vfcy@4jzl7slmqkft>
References: <20230502174404.668749-1-xiyou.wangcong@gmail.com>
 <20230502201418.GG535070@fedora>
 <ZDt+PDtKlxrwUPnc@bullseye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ZDt+PDtKlxrwUPnc@bullseye>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Apr 16, 2023 at 04:49:00AM +0000, Bobby Eshleman wrote:
>On Tue, May 02, 2023 at 04:14:18PM -0400, Stefan Hajnoczi wrote:
>> On Tue, May 02, 2023 at 10:44:04AM -0700, Cong Wang wrote:
>> > From: Cong Wang <cong.wang@bytedance.com>
>> >
>> > When virtqueue_add_sgs() fails, the skb is put back to send queue,
>> > we should not deliver the copy to tap device in this case. So we
>> > need to move virtio_transport_deliver_tap_pkt() down after all
>> > possible failures.
>> >
>> > Fixes: 82dfb540aeb2 ("VSOCK: Add virtio vsock vsockmon hooks")
>> > Cc: Stefan Hajnoczi <stefanha@redhat.com>
>> > Cc: Stefano Garzarella <sgarzare@redhat.com>
>> > Cc: Bobby Eshleman <bobby.eshleman@bytedance.com>
>> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
>> > ---
>> >  net/vmw_vsock/virtio_transport.c | 5 ++---
>> >  1 file changed, 2 insertions(+), 3 deletions(-)
>> >
>> > diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>> > index e95df847176b..055678628c07 100644
>> > --- a/net/vmw_vsock/virtio_transport.c
>> > +++ b/net/vmw_vsock/virtio_transport.c
>> > @@ -109,9 +109,6 @@ virtio_transport_send_pkt_work(struct work_struct *work)
>> >  		if (!skb)
>> >  			break;
>> >
>> > -		virtio_transport_deliver_tap_pkt(skb);
>> > -		reply = virtio_vsock_skb_reply(skb);
>> > -
>> >  		sg_init_one(&hdr, virtio_vsock_hdr(skb), sizeof(*virtio_vsock_hdr(skb)));
>> >  		sgs[out_sg++] = &hdr;
>> >  		if (skb->len > 0) {
>> > @@ -128,6 +125,8 @@ virtio_transport_send_pkt_work(struct work_struct *work)
>> >  			break;
>> >  		}
>> >
>> > +		virtio_transport_deliver_tap_pkt(skb);

I would move only the virtio_transport_deliver_tap_pkt(), 
virtio_vsock_skb_reply() is not related.

>> > +		reply = virtio_vsock_skb_reply(skb);
>>
>> I don't remember the reason for the ordering, but I'm pretty sure it was
>> deliberate. Probably because the payload buffers could be freed as soon
>> as virtqueue_add_sgs() is called.
>>
>> If that's no longer true with Bobby's skbuff code, then maybe it's safe
>> to monitor packets after they have been sent.
>>
>> Stefan
>
>Hey Stefan,
>
>Unfortunately, skbuff doesn't change that behavior.
>
>If I understand correctly, the problem flow you are describing
>would be something like this:
>
>Thread 0 			Thread 1
>guest:virtqueue_add_sgs()[@send_pkt_work]
>
>				host:vhost_vq_get_desc()[@handle_tx_kick]
>				host:vhost_add_used()
>				host:vhost_signal()
>				guest:virtqueue_get_buf()[@tx_work]
>				guest:consume_skb()
>
>guest:deliver_tap_pkt()[@send_pkt_work]
>^ use-after-free
>
>Which I guess is possible because the receiver can consume the new
>scatterlist during the processing kicked off for a previous batch?
>(doesn't have to wait for the subsequent kick)

This is true, but both `send_pkt_work` and `tx_work` hold `tx_lock`, so 
can they really go in parallel?

Thanks,
Stefano

