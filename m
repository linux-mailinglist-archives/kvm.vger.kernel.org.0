Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7170F73E279
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 16:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbjFZOvT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 10:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbjFZOvS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 10:51:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0120110D8
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 07:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687791035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S5+kCdPQqZvUN049y0wQiq4t+E5gwWas2OhKvBA5CYQ=;
        b=hLTkFjOzhDvrfWHZn+EgvDOHSs4RwkE7lUNjIApOqB3Ch04aAHTrsNlKaGCv+NImoHZvuK
        PaTVRtNYto8WcJEXLqmb43x9pCW88VuPhA3OPlsgNuJaD42a0KRbPIgvH8y/6fmcgipfTQ
        WEIIleB4LrKlAXklryXdVMSC/W6KYus=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622--Pmr89a3Ng-gba7Jxo2zJA-1; Mon, 26 Jun 2023 10:50:32 -0400
X-MC-Unique: -Pmr89a3Ng-gba7Jxo2zJA-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-62ff6a6b4f4so34780196d6.0
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 07:50:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687791032; x=1690383032;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S5+kCdPQqZvUN049y0wQiq4t+E5gwWas2OhKvBA5CYQ=;
        b=fSdBryWA2eeNXo92SFHznAolqOm8FxyXt54aJffJYYjHHicM+xE+pFudQRIFr+e1N5
         Y05bsXFVfVcfTOrfvuC4kVtRJdC6Cab7cGZm5EJ1c/bC74jxfsLpwmGdFMrawtkOFDga
         eregH5WsnNAeyiMAfv8ofIvJlrgCR3lCFnhcvhcvKdM4M8xpvpFA+xcGMO81fchjmHoI
         6ZILCCz7JHcIRokzOK5iwKgwAbHfjgIqPphDLD0c8/eDxeCKqHxrBBuItTNaficCpQpF
         wAHqX8U2naosKDdGmKaYcp9cTxSzKZ3iH2ve7Qnl0ySQAnSvaC6KlnySvf2NsLI0PybG
         ws2w==
X-Gm-Message-State: AC+VfDwkfNecYRApSDSgQpbPDaGQyOe1NcZ37MG7NGFf956veEKzErul
        K+v10pAL0LD+L4y/dTsJZUKpzViglk225Yayg72B1afjf9Czk9TMazFbTul7o3ZeXKmlJlImwK3
        XKiC3J+RUuDYa
X-Received: by 2002:a05:6214:29e4:b0:635:e696:b314 with SMTP id jv4-20020a05621429e400b00635e696b314mr1005725qvb.58.1687791032281;
        Mon, 26 Jun 2023 07:50:32 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6TmnUDHDdLDrYwlG8x2M9rK8Vc0auOUbahtUoqXs378EEmUDgmMHtci3th6fKJraKyUyH9eA==
X-Received: by 2002:a05:6214:29e4:b0:635:e696:b314 with SMTP id jv4-20020a05621429e400b00635e696b314mr1005704qvb.58.1687791031954;
        Mon, 26 Jun 2023 07:50:31 -0700 (PDT)
Received: from sgarzare-redhat (host-87-11-6-160.retail.telecomitalia.it. [87.11.6.160])
        by smtp.gmail.com with ESMTPSA id dp8-20020a05621409c800b0062ff179a538sm2315271qvb.123.2023.06.26.07.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jun 2023 07:50:31 -0700 (PDT)
Date:   Mon, 26 Jun 2023 16:50:24 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Bobby Eshleman <bobbyeshleman@gmail.com>
Cc:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
        linux-hyperv@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Simon Horman <simon.horman@corigine.com>,
        virtualization@lists.linux-foundation.org,
        Eric Dumazet <edumazet@google.com>,
        Dan Carpenter <dan.carpenter@linaro.org>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Vishnu Dasa <vdasa@vmware.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH RFC net-next v4 3/8] vsock: support multi-transport
 datagrams
Message-ID: <zp6jvoddzjquq2bngujpy5wnameuopou7jonqvm2vexebrbr5k@lh4imo4zyi4k>
References: <20230413-b4-vsock-dgram-v4-0-0cebbb2ae899@bytedance.com>
 <20230413-b4-vsock-dgram-v4-3-0cebbb2ae899@bytedance.com>
 <tngyeva5by3aldrhlixajjin2hqmcl6uruvuoed7hyrndlesfd@bbv7aphqye2q>
 <ZJUIWcgg13F7DNBm@bullseye>
 <ZJUKi+NtOajbplQg@bullseye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ZJUKi+NtOajbplQg@bullseye>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 23, 2023 at 02:59:23AM +0000, Bobby Eshleman wrote:
>On Fri, Jun 23, 2023 at 02:50:01AM +0000, Bobby Eshleman wrote:
>> On Thu, Jun 22, 2023 at 05:19:08PM +0200, Stefano Garzarella wrote:
>> > On Sat, Jun 10, 2023 at 12:58:30AM +0000, Bobby Eshleman wrote:
>> > > This patch adds support for multi-transport datagrams.
>> > >
>> > > This includes:
>> > > - Per-packet lookup of transports when using sendto(sockaddr_vm)
>> > > - Selecting H2G or G2H transport using VMADDR_FLAG_TO_HOST and CID in
>> > >  sockaddr_vm
>> > >
>> > > To preserve backwards compatibility with VMCI, some important changes
>> > > were made. The "transport_dgram" / VSOCK_TRANSPORT_F_DGRAM is changed to
>> > > be used for dgrams iff there is not yet a g2h or h2g transport that has
>> >
>> > s/iff/if
>> >
>> > > been registered that can transmit the packet. If there is a g2h/h2g
>> > > transport for that remote address, then that transport will be used and
>> > > not "transport_dgram". This essentially makes "transport_dgram" a
>> > > fallback transport for when h2g/g2h has not yet gone online, which
>> > > appears to be the exact use case for VMCI.
>> > >
>> > > This design makes sense, because there is no reason that the
>> > > transport_{g2h,h2g} cannot also service datagrams, which makes the role
>> > > of transport_dgram difficult to understand outside of the VMCI context.
>> > >
>> > > The logic around "transport_dgram" had to be retained to prevent
>> > > breaking VMCI:
>> > >
>> > > 1) VMCI datagrams appear to function outside of the h2g/g2h
>> > >   paradigm. When the vmci transport becomes online, it registers itself
>> > >   with the DGRAM feature, but not H2G/G2H. Only later when the
>> > >   transport has more information about its environment does it register
>> > >   H2G or G2H. In the case that a datagram socket becomes active
>> > >   after DGRAM registration but before G2H/H2G registration, the
>> > >   "transport_dgram" transport needs to be used.
>> >
>> > IIRC we did this, because at that time only VMCI supported DGRAM. Now that
>> > there are more transports, maybe DGRAM can follow the h2g/g2h paradigm.
>> >
>>
>> Totally makes sense. I'll add the detail above that the prior design was
>> a result of chronology.
>>
>> > >
>> > > 2) VMCI seems to require special message be sent by the transport when a
>> > >   datagram socket calls bind(). Under the h2g/g2h model, the transport
>> > >   is selected using the remote_addr which is set by connect(). At
>> > >   bind time there is no remote_addr because often no connect() has been
>> > >   called yet: the transport is null. Therefore, with a null transport
>> > >   there doesn't seem to be any good way for a datagram socket a tell the
>> > >   VMCI transport that it has just had bind() called upon it.
>> >
>> > @Vishnu, @Bryan do you think we can avoid this in some way?
>> >
>> > >
>> > > Only transports with a special datagram fallback use-case such as VMCI
>> > > need to register VSOCK_TRANSPORT_F_DGRAM.
>> >
>> > Maybe we should rename it in VSOCK_TRANSPORT_F_DGRAM_FALLBACK or
>> > something like that.
>> >
>> > In any case, we definitely need to update the comment in
>> > include/net/af_vsock.h on top of VSOCK_TRANSPORT_F_DGRAM mentioning
>> > this.
>> >
>>
>> Agreed. I'll rename to VSOCK_TRANSPORT_F_DGRAM_FALLBACK, unless we find
>> there is a better way altogether.
>>
>> > >
>> > > Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
>> > > ---
>> > > drivers/vhost/vsock.c                   |  1 -
>> > > include/linux/virtio_vsock.h            |  2 -
>> > > net/vmw_vsock/af_vsock.c                | 78 +++++++++++++++++++++++++--------
>> > > net/vmw_vsock/hyperv_transport.c        |  6 ---
>> > > net/vmw_vsock/virtio_transport.c        |  1 -
>> > > net/vmw_vsock/virtio_transport_common.c |  7 ---
>> > > net/vmw_vsock/vsock_loopback.c          |  1 -
>> > > 7 files changed, 60 insertions(+), 36 deletions(-)
>> > >
>> > > diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>> > > index c8201c070b4b..8f0082da5e70 100644
>> > > --- a/drivers/vhost/vsock.c
>> > > +++ b/drivers/vhost/vsock.c
>> > > @@ -410,7 +410,6 @@ static struct virtio_transport vhost_transport = {
>> > > 		.cancel_pkt               = vhost_transport_cancel_pkt,
>> > >
>> > > 		.dgram_enqueue            = virtio_transport_dgram_enqueue,
>> > > -		.dgram_bind               = virtio_transport_dgram_bind,
>> > > 		.dgram_allow              = virtio_transport_dgram_allow,
>> > > 		.dgram_get_cid		  = virtio_transport_dgram_get_cid,
>> > > 		.dgram_get_port		  = virtio_transport_dgram_get_port,
>> > > diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>> > > index 23521a318cf0..73afa09f4585 100644
>> > > --- a/include/linux/virtio_vsock.h
>> > > +++ b/include/linux/virtio_vsock.h
>> > > @@ -216,8 +216,6 @@ void virtio_transport_notify_buffer_size(struct vsock_sock *vsk, u64 *val);
>> > > u64 virtio_transport_stream_rcvhiwat(struct vsock_sock *vsk);
>> > > bool virtio_transport_stream_is_active(struct vsock_sock *vsk);
>> > > bool virtio_transport_stream_allow(u32 cid, u32 port);
>> > > -int virtio_transport_dgram_bind(struct vsock_sock *vsk,
>> > > -				struct sockaddr_vm *addr);
>> > > bool virtio_transport_dgram_allow(u32 cid, u32 port);
>> > > int virtio_transport_dgram_get_cid(struct sk_buff *skb, unsigned int *cid);
>> > > int virtio_transport_dgram_get_port(struct sk_buff *skb, unsigned int *port);
>> > > diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>> > > index 74358f0b47fa..ef86765f3765 100644
>> > > --- a/net/vmw_vsock/af_vsock.c
>> > > +++ b/net/vmw_vsock/af_vsock.c
>> > > @@ -438,6 +438,18 @@ vsock_connectible_lookup_transport(unsigned int cid, __u8 flags)
>> > > 	return transport;
>> > > }
>> > >
>> > > +static const struct vsock_transport *
>> > > +vsock_dgram_lookup_transport(unsigned int cid, __u8 flags)
>> > > +{
>> > > +	const struct vsock_transport *transport;
>> > > +
>> > > +	transport = vsock_connectible_lookup_transport(cid, flags);
>> > > +	if (transport)
>> > > +		return transport;
>> > > +
>> > > +	return transport_dgram;
>> > > +}
>> > > +
>> > > /* Assign a transport to a socket and call the .init transport callback.
>> > >  *
>> > >  * Note: for connection oriented socket this must be called when vsk->remote_addr
>> > > @@ -474,7 +486,8 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
>> > >
>> > > 	switch (sk->sk_type) {
>> > > 	case SOCK_DGRAM:
>> > > -		new_transport = transport_dgram;
>> > > +		new_transport = vsock_dgram_lookup_transport(remote_cid,
>> > > +							     remote_flags);
>> > > 		break;
>> > > 	case SOCK_STREAM:
>> > > 	case SOCK_SEQPACKET:
>> > > @@ -691,6 +704,9 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
>> > > static int __vsock_bind_dgram(struct vsock_sock *vsk,
>> > > 			      struct sockaddr_vm *addr)
>> > > {
>> > > +	if (!vsk->transport || !vsk->transport->dgram_bind)
>> > > +		return -EINVAL;
>> > > +
>> > > 	return vsk->transport->dgram_bind(vsk, addr);
>> > > }
>> > >
>> > > @@ -1172,19 +1188,24 @@ static int vsock_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
>> > >
>> > > 	lock_sock(sk);
>> > >
>> > > -	transport = vsk->transport;
>> > > -
>> > > -	err = vsock_auto_bind(vsk);
>> > > -	if (err)
>> > > -		goto out;
>> > > -
>> > > -
>> > > 	/* If the provided message contains an address, use that.  Otherwise
>> > > 	 * fall back on the socket's remote handle (if it has been connected).
>> > > 	 */
>> > > 	if (msg->msg_name &&
>> > > 	    vsock_addr_cast(msg->msg_name, msg->msg_namelen,
>> > > 			    &remote_addr) == 0) {
>> > > +		transport = vsock_dgram_lookup_transport(remote_addr->svm_cid,
>> > > +							 remote_addr->svm_flags);
>> > > +		if (!transport) {
>> > > +			err = -EINVAL;
>> > > +			goto out;
>> > > +		}
>> > > +
>> > > +		if (!try_module_get(transport->module)) {
>> > > +			err = -ENODEV;
>> > > +			goto out;
>> > > +		}
>> > > +
>> > > 		/* Ensure this address is of the right type and is a valid
>> > > 		 * destination.
>> > > 		 */
>> > > @@ -1193,11 +1214,27 @@ static int vsock_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
>> > > 			remote_addr->svm_cid = transport->get_local_cid();
>> > >
>> >
>> > From here ...
>> >
>> > > 		if (!vsock_addr_bound(remote_addr)) {
>> > > +			module_put(transport->module);
>> > > +			err = -EINVAL;
>> > > +			goto out;
>> > > +		}
>> > > +
>> > > +		if (!transport->dgram_allow(remote_addr->svm_cid,
>> > > +					    remote_addr->svm_port)) {
>> > > +			module_put(transport->module);
>> > > 			err = -EINVAL;
>> > > 			goto out;
>> > > 		}
>> > > +
>> > > +		err = transport->dgram_enqueue(vsk, remote_addr, msg, len);
>> >
>> > ... to here, looks like duplicate code, can we get it out of the if block?
>> >
>>
>> Yes, I think using something like this:
>>
>> [...]
>> 	bool module_got = false;
>>
>> [...]
>> 		if (!try_module_get(transport->module)) {
>> 			err = -ENODEV;
>> 			goto out;
>> 		}
>> 		module_got = true;
>>
>> [...]
>>
>> out:
>> 	if (likely(transport && !err && module_got))
>
>Actually, just...
>
>	if (module_got)
>

Yep, I think it should work ;-)

Thanks,
Stefano

