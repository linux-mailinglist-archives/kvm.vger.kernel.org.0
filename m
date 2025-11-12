Return-Path: <kvm+bounces-62922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 01DD0C53FF2
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 19:51:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB08E3B1044
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 18:41:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F011834C140;
	Wed, 12 Nov 2025 18:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R2S15w9R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78FD34CFCC
	for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 18:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762972616; cv=none; b=J06E6U+h+VvX5hU7OPMdyjggeW4EzEArMJ6+lO1sg8hW6ZxQxOaFHeZVQkiDYCaiEcxIQqzVJ54m1G/RYR6CT1swVaGxIl9xVwbIMo82/YWChEH8QT99mi1GdACvPEmBhR2L1Rd+SrHpDdjIvl4yBPa0w2iLJPoqsTLnSBNpCzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762972616; c=relaxed/simple;
	bh=anYiTffJ9m/afti4TSeL27H7ZE//GYBvoRxBP0Aj56M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nGp72svQm/XUg3Afk9cO4vGT1YXCCu176Ke/JlczATuWrCp8pRO7m3RqhWD/Qg3bHYX5NZdl/TdClETRyYwWDHxs9nIa+7pTuecS2R1VCSH3+dVyI7SW4yJY74L21pk1+aTrUEcyr8MU+IcOuyD1FsIr1kwut8diW4Ebb1mF4Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R2S15w9R; arc=none smtp.client-ip=74.125.224.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-63f96d5038dso1183910d50.1
        for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 10:36:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762972613; x=1763577413; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZKQWigIGEVi0kLFXu6j/x0JtjaxFQvF5YS6wzVMmD9E=;
        b=R2S15w9R9Yjsvyp5auWxvUg2kOOWxRS1s81NU9V8UQbUVn5zk1LWPh2G82Nf4G5jri
         2y05p2YE1+tpkn241URtoQTL0et/R3uj//byArFYGoaxdDkt3cfW5ZvEjFNsaZ+onBDw
         H8/NyFLBa6SrR3fA5zIteZ6my6CeRDHssLbyk0Ui14VzF4p+4NPEEB22enA27BgyelMU
         qqdVeIFQeliJLEXQvJE5x9WfxrwtZ/NOYYy6jgjxYjlI1tfFhin01hX0n4BVtig0tQE1
         DSvzUTCAHSFtMn4j9yO18yd/b+hyck1pSQESkzokb7BNX3lpFV2gb+AQWlDNnFhBuMFX
         k6bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762972613; x=1763577413;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZKQWigIGEVi0kLFXu6j/x0JtjaxFQvF5YS6wzVMmD9E=;
        b=j8U7gmT6Ll4YQ+/mUsVdsWsFiz10G4KBVZXWLs2wZLODA3QLG26Y049lkg72/nul26
         SOev1kbnD+uxsJYSjOkxAteG8bKrBmV0GDOtg1Od3HZiibQDSNDLj10ZPVZQcT5Cd13W
         Hu8sfVoCWau9STbb3w+7rw4WXHPOmZrBr1rsCvpNdFSq371A1Vcp3pCkRZBPrzYm35px
         3ENySMsf1Vp6fzREywCD3rbZSKMvCGFsNPDuOdWmDfHQmPWNAh2joudA2yhMYrYJGfNi
         MZqNop4te1nhVnaNdTkSxELPjLcefacrRjg7irohmhu3d91B5Kx0CTXZMx5gCzF1NfLm
         OnkA==
X-Forwarded-Encrypted: i=1; AJvYcCXRczFKV7g2Nzk2EQ4x1D4cQo6eo49pRbtSczjbLy2zLP/lT5W5c8RQHD+AQ+jwiJMd1lA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyiXcsnE6C5qR8JSAQZ9NMrDhsiSPWuFPrU0x4yz0o+hPN8c7Z9
	q+qfn1i7CUxb+F/K/rJGVLKZ+jQeEFy+u8MYSDYabqYusEZYrLlLE229
X-Gm-Gg: ASbGncsR8iOdb0ve0iSwrPTaIV5FMD0eBXIi3Ife8BqeK4BC/hAAj0hftlSAlHukChA
	APidkYrmxKkOu37CmFEcyHDFEE02imCOTkjKRt2X6InixWa3YCAodaaS1gzsBcFp3oSxF7DiZqv
	vgC4DnHyfP6jBK0lLjNlSDrGrQDo/kSP/I+3koJP/aVqrYT7qmFOKeJ37pbv5792F/6xs2mDyEZ
	+WDQ7uKgGceNs9SrGWngj7PRpnm5JGYnm+U/KL3GVR+o/YKn0oFOB7PZBe22ZxcFrXn4eIP6Y3T
	N9c0J91Ie/h92KoGtxhtVgMxXRdcMgRMa+M5Nt9ai6Bc8rs621j+3sbprB6xBGZbDNgL4N8GShD
	tYejfserdlK495+vys/I4TKPdyr8wq5WUFpxJpaEcO/UAYINKbUHFe1Czp5nKWuYrSt87GPcEWj
	UnB6NfXOMPIAqP9LIi41dkuEdwbmUNn50BTW4SihEQNBHMw/o=
X-Google-Smtp-Source: AGHT+IEjgyAE0Hs+bT3W8DaSfFbFucKGUg6EhDw/PlXyHWRqH89/fss68vyII/g3bMSTQTHDXA7oUA==
X-Received: by 2002:a05:690e:c4d:b0:63e:1c4c:302b with SMTP id 956f58d0204a3-64101b89ee2mr3345793d50.47.1762972612652;
        Wed, 12 Nov 2025 10:36:52 -0800 (PST)
Received: from devvm11784.nha0.facebook.com ([2a03:2880:25ff:53::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-641015adefasm1191019d50.1.2025.11.12.10.36.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 10:36:51 -0800 (PST)
Date: Wed, 12 Nov 2025 10:36:50 -0800
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Bryan Tan <bryan-bt.tan@broadcom.com>,
	Vishnu Dasa <vishnu.dasa@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-hyperv@vger.kernel.org,
	Sargun Dhillon <sargun@sargun.me>, berrange@redhat.com,
	Bobby Eshleman <bobbyeshleman@meta.com>
Subject: Re: [PATCH net-next v9 08/14] vsock: reject bad VSOCK_NET_MODE_LOCAL
 configuration for G2H
Message-ID: <aRTTwuuXSz5CvNjt@devvm11784.nha0.facebook.com>
References: <20251111-vsock-vmtest-v9-0-852787a37bed@meta.com>
 <20251111-vsock-vmtest-v9-8-852787a37bed@meta.com>
 <ureyl5b2tneivmlce4fdtmuoxgayfxwgewoypb6oyxeh7ozt3i@chygpr2uvtcp>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ureyl5b2tneivmlce4fdtmuoxgayfxwgewoypb6oyxeh7ozt3i@chygpr2uvtcp>

On Wed, Nov 12, 2025 at 03:21:39PM +0100, Stefano Garzarella wrote:
> On Tue, Nov 11, 2025 at 10:54:50PM -0800, Bobby Eshleman wrote:
> > From: Bobby Eshleman <bobbyeshleman@meta.com>
> > 
> > Reject setting VSOCK_NET_MODE_LOCAL with -EOPNOTSUPP if a G2H transport
> > is operational. Additionally, reject G2H transport registration if there
> > already exists a namespace in local mode.
> > 
> > G2H sockets break in local mode because the G2H transports don't support
> > namespacing yet. The current approach is to coerce packets coming out of
> > G2H transports into VSOCK_NET_MODE_GLOBAL mode, but it is not possible
> > to coerce sockets in the same way because it cannot be deduced which
> > transport will be used by the socket. Specifically, when bound to
> > VMADDR_CID_ANY in a nested VM (both G2H and H2G available), it is not
> > until a packet is received and matched to the bound socket that we
> > assign the transport. This presents a chicken-and-egg problem, because
> > we need the namespace to lookup the socket and resolve the transport,
> > but we need the transport to know how to use the namespace during
> > lookup.
> > 
> > For that reason, this patch prevents VSOCK_NET_MODE_LOCAL from being
> > used on systems that support G2H, even nested systems that also have H2G
> > transports.
> > 
> > Local mode is blocked based on detecting the presence of G2H devices
> > (when possible, as hyperv is special). This means that a host kernel
> > with G2H support compiled in (or has the module loaded), will still
> > support local mode because there is no G2H (e.g., virtio-vsock) device
> > detected. This enables using the same kernel in the host and in the
> > guest, as we do in kselftest.
> > 
> > Systems with only namespace-aware transports (vhost-vsock, loopback) can
> > still use both VSOCK_NET_MODE_GLOBAL and VSOCK_NET_MODE_LOCAL modes as
> > intended.
> > 
> > The hyperv transport must be treated specially. Other G2H transports can
> > can report presence of a device using get_local_cid(). When a device is
> > present it returns a valid CID; otherwise, it returns VMADDR_CID_ANY.
> > THe hyperv transport's get_local_cid() always returns VMADDR_CID_ANY,
> > however, even when a device is present.
> > 
> > For that reason, this patch adds an always_block_local_mode flag to
> > struct vsock_transport. When set to true, VSOCK_NET_MODE_LOCAL is
> > blocked unconditionally whenever the transport is registered, regardless
> > of device presence. When false, LOCAL mode is only blocked when
> > get_local_cid() indicates a device is present (!= VMADDR_CID_ANY).
> > 
> > The hyperv transport sets this flag to true to unconditionally block
> > local mode. Other G2H transports (virtio-vsock, vmci-vsock) leave it
> > false and continue using device detection via get_local_cid() to block
> > local mode.
> > 
> > These restrictions can be lifted in a future patch series when G2H
> > transports gain namespace support.
> 
> IMO this commit should be before supporting namespaces in any device,
> so we are sure we don't have commits where this can happen.

sgtm!

> > 
> > Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
> > ---
> > include/net/af_vsock.h           |  8 +++++++
> > net/vmw_vsock/af_vsock.c         | 45 +++++++++++++++++++++++++++++++++++++---
> > net/vmw_vsock/hyperv_transport.c |  1 +
> > 3 files changed, 51 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
> > index cfd121bb5ab7..089c61105dda 100644
> > --- a/include/net/af_vsock.h
> > +++ b/include/net/af_vsock.h
> > @@ -108,6 +108,14 @@ struct vsock_transport_send_notify_data {
> > 
> > struct vsock_transport {
> > 	struct module *module;
> > +	/* If true, block VSOCK_NET_MODE_LOCAL unconditionally when this G2H
> > +	 * transport is registered. If false, only block LOCAL mode when
> > +	 * get_local_cid() indicates a device is present (!= VMADDR_CID_ANY).
> > +	 * Hyperv sets this true because it doesn't offer a callback that
> > +	 * detects device presence. This only applies to G2H transports; H2G
> > +	 * transports are unaffected.
> > +	 */
> > +	bool always_block_local_mode;
> > 
> > 	/* Initialize/tear-down socket. */
> > 	int (*init)(struct vsock_sock *, struct vsock_sock *);
> > diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> > index c0b5946bdc95..a2da1810b802 100644
> > --- a/net/vmw_vsock/af_vsock.c
> > +++ b/net/vmw_vsock/af_vsock.c
> > @@ -91,6 +91,11 @@
> >  *   and locked down by a namespace manager. The default is "global". The mode
> >  *   is set per-namespace.
> >  *
> > + *   Note: LOCAL mode is only supported when using namespace-aware transports
> > + *   (vhost-vsock, loopback). If a guest-to-host transport (virtio-vsock,
> > + *   hyperv-vsock, vmci-vsock) is loaded, attempts to set LOCAL mode will fail
> > + *   with EOPNOTSUPP, as these transports do not support per-namespace
> > isolation.
> > + *
> >  *   The modes affect the allocation and accessibility of CIDs as follows:
> >  *
> >  *   - global - access and allocation are all system-wide
> > @@ -2757,12 +2762,30 @@ static int vsock_net_mode_string(const struct ctl_table *table, int write,
> > 		if (*lenp >= sizeof(data))
> > 			return -EINVAL;
> > 
> > -		if (!strncmp(data, VSOCK_NET_MODE_STR_GLOBAL, sizeof(data)))
> > +		if (!strncmp(data, VSOCK_NET_MODE_STR_GLOBAL, sizeof(data))) {
> > 			mode = VSOCK_NET_MODE_GLOBAL;
> > -		else if (!strncmp(data, VSOCK_NET_MODE_STR_LOCAL, sizeof(data)))
> > +		} else if (!strncmp(data, VSOCK_NET_MODE_STR_LOCAL, sizeof(data))) {
> > +			/* LOCAL mode is not supported when G2H transports
> > +			 * (virtio-vsock, hyperv, vmci) are active, because
> > +			 * these transports don't support namespaces. We must
> > +			 * stay in GLOBAL mode to avoid bind/lookup mismatches.
> > +			 *
> > +			 * Check if G2H transport is present and either:
> > +			 * 1. Has always_block_local_mode set (hyperv), OR
> > +			 * 2. Has an actual device present (get_local_cid() != VMADDR_CID_ANY)
> > +			 */
> > +			mutex_lock(&vsock_register_mutex);
> > +			if (transport_g2h &&
> > +			    (transport_g2h->always_block_local_mode ||
> > +			     transport_g2h->get_local_cid() != VMADDR_CID_ANY)) {
> 
> This seems almost like a hack. What about adding a new function in the
> transports that tells us whether a device is present or not and implement it
> in all of them?
> 
> Or a more specific function to check if the transport can work with local
> mode (e.g.  netns_local_aware() or something like that - I'm not great with
> nameming xD)

That sounds good to me, I probably prefer option 2 because I think it'll
be simpler for the hyperv case.

> 
> > +				mutex_unlock(&vsock_register_mutex);
> > +				return -EOPNOTSUPP;
> > +			}
> > +			mutex_unlock(&vsock_register_mutex);
> 
> What happen if the G2H is loaded here, just after we release the mutex?
> 
> I suspect there could be a race that we may fix postponing the unlock after
> the vsock_net_write_mode() call.
> 
> WDYT?

Oh good eye, yeah I think you are right. Writing the net mode should
definitely be in the critical section.

> 
> > 			mode = VSOCK_NET_MODE_LOCAL;
> > -		else
> > +		} else {
> > 			return -EINVAL;
> > +		}
> > 
> > 		if (!vsock_net_write_mode(net, mode))
> > 			return -EPERM;
> > @@ -2909,6 +2932,7 @@ int vsock_core_register(const struct vsock_transport *t, int features)
> > {
> > 	const struct vsock_transport *t_h2g, *t_g2h, *t_dgram, *t_local;
> > 	int err = mutex_lock_interruptible(&vsock_register_mutex);
> > +	struct net *net;
> > 
> > 	if (err)
> > 		return err;
> > @@ -2931,6 +2955,21 @@ int vsock_core_register(const struct vsock_transport *t, int features)
> > 			err = -EBUSY;
> > 			goto err_busy;
> > 		}
> > +
> > +		/* G2H sockets break in LOCAL mode namespaces because G2H transports
> > +		 * don't support them yet. Block registering new G2H transports if we
> > +		 * already have local mode namespaces on the system.
> > +		 */
> > +		rcu_read_lock();
> > +		for_each_net_rcu(net) {
> > +			if (vsock_net_mode(net) == VSOCK_NET_MODE_LOCAL) {
> > +				rcu_read_unlock();
> > +				err = -EOPNOTSUPP;
> > +				goto err_busy;
> > +			}
> > +		}
> > +		rcu_read_unlock();
> > +
> > 		t_g2h = t;
> > 	}
> > 
> > diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
> > index 432fcbbd14d4..ed48dd1ff19b 100644
> > --- a/net/vmw_vsock/hyperv_transport.c
> > +++ b/net/vmw_vsock/hyperv_transport.c
> > @@ -835,6 +835,7 @@ int hvs_notify_set_rcvlowat(struct vsock_sock *vsk, int val)
> > 
> > static struct vsock_transport hvs_transport = {
> > 	.module                   = THIS_MODULE,
> > +	.always_block_local_mode  = true,
> > 
> > 	.get_local_cid            = hvs_get_local_cid,
> > 
> > 
> > -- 
> > 2.47.3
> > 
> 

