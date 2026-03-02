Return-Path: <kvm+bounces-72411-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uA9ZKPLqpWlSIAAAu9opvQ
	(envelope-from <kvm+bounces-72411-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 20:54:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E9D491DEFDB
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 20:54:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C537A304C491
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 19:52:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B189320A37;
	Mon,  2 Mar 2026 19:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iFJ2BDTY";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xpcdn46J"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1E621770B
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 19:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772481157; cv=none; b=uSx7LpKLidBRxX+im4i4VionrLApwgWIB3AqgAIZflrfFx3RFU1vWp5xC9Oj+deWtSIztL7CDsBTYkryy0v2a+UDg7sjbteb2IYD9ZM0RNHuGUqFeBLaVqxlVloUYU554Ni9Ha7wc6QDMNAYRxVr6Ol5rOlVwxQsfNRpLqfGn94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772481157; c=relaxed/simple;
	bh=5s4Eh05ziMMWq72814hetK2sQYeQqsihE2/3kPLb7uU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q/wzXL2EpL+qyvTu7R2qVUsbyM2+TKCR5QbEjDI/J0dT6kPkg6jVi96GdADcXogrxB1EuoVNQInxymJ+3u5VLGd+sOEnBqAyTLpAS4G/S8rrhTmTtm6aSfoeYwyTmR1kFEtjx5oYfyVJLq8f2h1hPinpTuyVU8NusCCmKEfkT94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iFJ2BDTY; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xpcdn46J; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772481155;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RaGhSybAE4JXA1WjpWM9oOlkMHCgTkwYOUSZuMrCDp0=;
	b=iFJ2BDTYMim+vTS8ACMFBkFSq460CaWEm1IU1UrhQl63hnu0SJUfjK8K8DHCJtRCqrKWDk
	KlrtafCXWjaAVy9MiTTibmemruiKbWD/LE1FzvZj8yKRFB1tg+1MMFMl7EZk7Xm9NuExQA
	5CmAKJEciqOIdBuikIzQnwnWPFDypeo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-523-FACuSgWmP2SvRYR0RpjdNQ-1; Mon, 02 Mar 2026 14:52:34 -0500
X-MC-Unique: FACuSgWmP2SvRYR0RpjdNQ-1
X-Mimecast-MFC-AGG-ID: FACuSgWmP2SvRYR0RpjdNQ_1772481153
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-439af95a718so1729235f8f.2
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 11:52:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772481153; x=1773085953; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RaGhSybAE4JXA1WjpWM9oOlkMHCgTkwYOUSZuMrCDp0=;
        b=Xpcdn46J3KDODL85pfC98BaoJrsiZ4wr2vUDFxauCcuCM1LrYEF0XqXVVCvJIM0Pk7
         LqNyZT7mEZCZTSlxZhaYbob3dbfmINPYGPOpIsUOBd3lK1zJsbfALi2nTklEMumD04kX
         Nhg6EkTIwsXsZUpjAs+WbMFik2/Mb8/AnHOs+tDSkKyQest0vCN54+yiylxI6sojBSeW
         vXbrRFDg2hr8TEuXc0DaLN9ftbAPrYoQUTozyhYOlijC/c66Fo2p1UHAUz4275VVZtta
         y4P/A0wZi8GoDgZtuU49FLI25aZ83lmhNaBVntMhWVtp+MiOMaDIJCRGvKa+hIY6xCON
         C/sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772481153; x=1773085953;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RaGhSybAE4JXA1WjpWM9oOlkMHCgTkwYOUSZuMrCDp0=;
        b=apcSd4pW6TBmpOyVb/2PlTbJTtIInfI64z4FlOqmjgEIIcwvRUXjeyrulKXJmczJhx
         ySXeYv/+LYQaXIgAD3p/DfKTCuK79C5SV6hfyzrl9E2en+WaRGYzsu2KWEQKD8CNfb4+
         R5IZeuysR5sYoq0W1BkNYupCe+SJWL0kgJhZJgAtX68nzs7MYLKXSc2JF3htuaVShP53
         47V/VxJeaJrUGH5TlKjxUEwMQj3t4COs2zbl0Nu12SroS2yOIALrL7dfCOM6Vz89IZDQ
         SFQguUZE3MokzftydZ8sW1gpdtsuRHkGZp5m1DVScXtStoHTckJSEA8wOD0EjkAyfX96
         hwvg==
X-Forwarded-Encrypted: i=1; AJvYcCVYeq4I+OzAuvRvYkEk3x/71tavtuBQuKSKKReYapaHpyjs4n02UslyVRFO0jzRkq8ncco=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCawLc/vhQ2GvDuL1rJDcPoucuQxsagJDm7wTQdCKAMaByp1Iu
	CVMo4r9sCCzmLbfGej6C/K34/+SWF2+VH2HalnrezLbgHOa1Qmk+x/h70DfFoqjSMMskR4Mc7tK
	TinawQbY9UpgL0A8fb3CDcCKg0N6UqUzx/lSXe66Cn7j9j3WKtivE3w==
X-Gm-Gg: ATEYQzy//Tn2g9Rw2nj4FJNYSaV+0V9eKqSVOPCepCvrhRxQqPW6daNrOeoT92x613l
	aqEf7JzjQVkTtKwORVVVGYFchhV1cgYQ9KsX+Dw898xYtWZtpmhcwpqyeq0q4fR+zRsHkOh5oxB
	44erMbPpCKKFjYh2qRXa1Gi/WsO3Us5mUqUMbZ1hN7b3U5A5HUJfJ/h27mluTC7TeLggAYD6KfJ
	FS0qF049CfLy7qvuW8IkpA9FAaWIt9OA+fHyLW7hOYijvcSsuqBBQhcEZPbxYEtqoZoE+3hprMM
	0daImid/J4rC9ipIuF2SBM0knbn6gj1xVyGTI949nAdRdJgG2jyBkzsdLcNZ6P8KJd61mAAoMhF
	xGcT6mvkkzWqZY+xWCV6auhLoN611eMvcIll8v33DKXeOCQ==
X-Received: by 2002:a05:6000:26c5:b0:439:ba69:101d with SMTP id ffacd0b85a97d-439ba6912e2mr6085917f8f.1.1772481152604;
        Mon, 02 Mar 2026 11:52:32 -0800 (PST)
X-Received: by 2002:a05:6000:26c5:b0:439:ba69:101d with SMTP id ffacd0b85a97d-439ba6912e2mr6085851f8f.1.1772481152050;
        Mon, 02 Mar 2026 11:52:32 -0800 (PST)
Received: from redhat.com (IGLD-80-230-79-166.inter.net.il. [80.230.79.166])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4399c70ed47sm32278553f8f.11.2026.03.02.11.52.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 11:52:31 -0800 (PST)
Date: Mon, 2 Mar 2026 14:52:28 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alexander Graf <graf@amazon.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>,
	Bryan Tan <bryan-bt.tan@broadcom.com>,
	Vishnu Dasa <vishnu.dasa@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, kvm@vger.kernel.org, eperezma@redhat.com,
	Jason Wang <jasowang@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>, nh-open-source@amazon.com
Subject: Re: [PATCH] vsock: Enable H2G override
Message-ID: <20260302145121-mutt-send-email-mst@kernel.org>
References: <20260302104138.77555-1-graf@amazon.com>
 <aaVrsXMmULivV4Se@sgarzare-redhat>
 <aaV80wWlpjEtYCQJ@sgarzare-redhat>
 <17d63837-6028-475a-90df-6966329a0fc2@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <17d63837-6028-475a-90df-6966329a0fc2@amazon.com>
X-Rspamd-Queue-Id: E9D491DEFDB
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72411-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mst@redhat.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, Mar 02, 2026 at 04:48:33PM +0100, Alexander Graf wrote:
> 
> On 02.03.26 13:06, Stefano Garzarella wrote:
> > CCing Bryan, Vishnu, and Broadcom list.
> > 
> > On Mon, Mar 02, 2026 at 12:47:05PM +0100, Stefano Garzarella wrote:
> > > 
> > > Please target net-next tree for this new feature.
> > > 
> > > On Mon, Mar 02, 2026 at 10:41:38AM +0000, Alexander Graf wrote:
> > > > Vsock maintains a single CID number space which can be used to
> > > > communicate to the host (G2H) or to a child-VM (H2G). The current logic
> > > > trivially assumes that G2H is only relevant for CID <= 2 because these
> > > > target the hypervisor.  However, in environments like Nitro
> > > > Enclaves, an
> > > > instance that hosts vhost_vsock powered VMs may still want to
> > > > communicate
> > > > to Enclaves that are reachable at higher CIDs through virtio-vsock-pci.
> > > > 
> > > > That means that for CID > 2, we really want an overlay. By default, all
> > > > CIDs are owned by the hypervisor. But if vhost registers a CID,
> > > > it takes
> > > > precedence.  Implement that logic. Vhost already knows which CIDs it
> > > > supports anyway.
> > > > 
> > > > With this logic, I can run a Nitro Enclave as well as a nested VM with
> > > > vhost-vsock support in parallel, with the parent instance able to
> > > > communicate to both simultaneously.
> > > 
> > > I honestly don't understand why VMADDR_FLAG_TO_HOST (added
> > > specifically for Nitro IIRC) isn't enough for this scenario and we
> > > have to add this change.  Can you elaborate a bit more about the
> > > relationship between this change and VMADDR_FLAG_TO_HOST we added?
> 
> 
> The main problem I have with VMADDR_FLAG_TO_HOST for connect() is that it
> punts the complexity to the user. Instead of a single CID address space, you
> now effectively create 2 spaces: One for TO_HOST (needs a flag) and one for
> TO_GUEST (no flag). But every user space tool needs to learn about this
> flag. That may work for super special-case applications. But propagating
> that all the way into socat, iperf, etc etc? It's just creating friction.
> 
> IMHO the most natural experience is to have a single CID space, potentially
> manually segmented by launching VMs of one kind within a certain range.
> 
> At the end of the day, the host vs guest problem is super similar to a
> routing table.

If this is what's desired, some bits could be stolen from the CID
to specify the destination type. Would that address the issue?
Just a thought.



> 
> > > 
> > > > 
> > > > Signed-off-by: Alexander Graf <graf@amazon.com>
> > > > ---
> > > > drivers/vhost/vsock.c    | 11 +++++++++++
> > > > include/net/af_vsock.h   |  3 +++
> > > > net/vmw_vsock/af_vsock.c |  3 +++
> > > > 3 files changed, 17 insertions(+)
> > > > 
> > > > diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> > > > index 054f7a718f50..223da817e305 100644
> > > > --- a/drivers/vhost/vsock.c
> > > > +++ b/drivers/vhost/vsock.c
> > > > @@ -91,6 +91,16 @@ static struct vhost_vsock
> > > > *vhost_vsock_get(u32 guest_cid, struct net *net)
> > > >     return NULL;
> > > > }
> > > > 
> > > > +static bool vhost_transport_has_cid(u32 cid)
> > > > +{
> > > > +    bool found;
> > > > +
> > > > +    rcu_read_lock();
> > > > +    found = vhost_vsock_get(cid) != NULL;
> > > 
> > > We recently added namespaces support that changed vhost_vsock_get()
> > > params. This is also in net tree now and in Linus' tree, so not sure
> > > where this patch is based, but this needs to be rebased since it is
> > > not building:
> > > 
> > > ../drivers/vhost/vsock.c: In function ‘vhost_transport_has_cid’:
> > > ../drivers/vhost/vsock.c:99:17: error: too few arguments to function
> > > ‘vhost_vsock_get’; expected 2, have 1
> > >   99 |         found = vhost_vsock_get(cid) != NULL;
> > >      |                 ^~~~~~~~~~~~~~~
> > > ../drivers/vhost/vsock.c:74:28: note: declared here
> > >   74 | static struct vhost_vsock *vhost_vsock_get(u32 guest_cid,
> > > struct net *net)
> > >      |
> 
> 
> D'oh. Sorry, I built this on 6.19 and only realized after the send that
> namespace support got in. Will fix up for v2.
> 
> 
> > > 
> > > > +    rcu_read_unlock();
> > > > +    return found;
> > > > +}
> > > > +
> > > > static void
> > > > vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> > > >                 struct vhost_virtqueue *vq)
> > > > @@ -424,6 +434,7 @@ static struct virtio_transport vhost_transport = {
> > > >         .module                   = THIS_MODULE,
> > > > 
> > > >         .get_local_cid            = vhost_transport_get_local_cid,
> > > > +        .has_cid                  = vhost_transport_has_cid,
> > > > 
> > > >         .init                     = virtio_transport_do_socket_init,
> > > >         .destruct                 = virtio_transport_destruct,
> > > > diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
> > > > index 533d8e75f7bb..4cdcb72f9765 100644
> > > > --- a/include/net/af_vsock.h
> > > > +++ b/include/net/af_vsock.h
> > > > @@ -179,6 +179,9 @@ struct vsock_transport {
> > > >     /* Addressing. */
> > > >     u32 (*get_local_cid)(void);
> > > > 
> > > > +    /* Check if this transport serves a specific remote CID. */
> > > > +    bool (*has_cid)(u32 cid);
> > > 
> > > What about "has_remote_cid" ?
> > > 
> > > > +
> > > >     /* Read a single skb */
> > > >     int (*read_skb)(struct vsock_sock *, skb_read_actor_t);
> > > > 
> > > > diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> > > > index 2f7d94d682cb..8b34b264b246 100644
> > > > --- a/net/vmw_vsock/af_vsock.c
> > > > +++ b/net/vmw_vsock/af_vsock.c
> > > > @@ -584,6 +584,9 @@ int vsock_assign_transport(struct vsock_sock
> > > > *vsk, struct vsock_sock *psk)
> > > >         else if (remote_cid <= VMADDR_CID_HOST || !transport_h2g ||
> > > >              (remote_flags & VMADDR_FLAG_TO_HOST))
> > > >             new_transport = transport_g2h;
> > > > +        else if (transport_h2g->has_cid &&
> > > > +             !transport_h2g->has_cid(remote_cid))
> > > > +            new_transport = transport_g2h;
> > > 
> > > We should update the comment on top of this fuction, and maybe also
> > > try to support the other H2G transport (i.e. VMCI).
> > > 
> > > @Bryan @Vishnu can the new has_cid()/has_remote_cid() be supported
> > > by VMCI too?
> > 
> > Oops, I forgot to CC them, now they should be in copy.
> 
> 
> Ack. I can also take a quick look if it's trivial to add.
> 
> 
> Alex
> 
> 
> 
> 
> 
> Amazon Web Services Development Center Germany GmbH
> Tamara-Danz-Str. 13
> 10243 Berlin
> Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
> Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
> Sitz: Berlin
> Ust-ID: DE 365 538 597


