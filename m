Return-Path: <kvm+bounces-68771-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CDiFMPI3cWnKfQAAu9opvQ
	(envelope-from <kvm+bounces-68771-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 21:32:50 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 906AA5D4AC
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 21:32:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 2FF6C7457F4
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 19:28:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E08A33A7F6E;
	Wed, 21 Jan 2026 19:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JAH/+oSP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E2B3D300B
	for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 19:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769023712; cv=none; b=OY1s3vwkYki4PYFawkthTs537BfXN0LvsumOWS2wRFDpXwcN5ibhLhoeyKSj6ZcV20VKdP2JBrLzUmiPCctkVm100SPbQQqFIP2fa+ZPfnoxGdwLIJK97oSswfBaWz33KjQwKAUeMFgsPDWegV6OFBx7YCikk+NoOAkSPHQu3ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769023712; c=relaxed/simple;
	bh=Lu0kHih9UWQeJ+lp2O4spjT0NK81+eYFDqsV1ZmCcuk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f1ewmqiY4I78SWbC2+zEvXpwoyyPzFSSv6Qa322VZwvcsQ7X1Upt8EXWE0fWcB3tkIUqmbSehQE6o+d5HanSdEDXmH7nEs0XpOdKYsdxdklJOxqePQCmK70GOojFT7TyIWPn/pahRn34SBDYDTn0WuXIOJSk2vfUGpQosV+CN/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JAH/+oSP; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-5014b671367so1550941cf.3
        for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 11:28:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769023707; x=1769628507; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iOPRZD47F8f143cIEqQqsk0mY0SdG+TC6tAqQjFOOoM=;
        b=JAH/+oSPr8VA/VnW9uiTtdcL15n5+MBvXRhfWfS4D+kStid/DpzJpoBxjzNFJ8DZyO
         z+kOiAbTSnQ3PzwM52v8pEeFVzchDIZXkSDUX0B2ng4VQgY3G0zWrAD8qUGBdj0nvGw+
         zTpPLElBQ7MEPCpDYQ5jPoSU3POk6ksWqm/ktW6EaaZomI8afN/zroEs+fdu/c2gY/qp
         /EzrxajNAhuAPJ5Q4rAsUOwHfhlF7HqnHPejSLjbfeYCmk832bEMygqFYEyIpyJRfxuX
         YadVj64vtjSEdU8kjHoCWb9NXG2XAafk/BPNNCk4z5ADDB/jc/GCVNkkLKag8T+fYjYY
         fr2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769023707; x=1769628507;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iOPRZD47F8f143cIEqQqsk0mY0SdG+TC6tAqQjFOOoM=;
        b=umchx8s/vxxU7LW5XfA554DYvcna3sbFj+94nldFqN7qsMCxhntdWm+tD+6rXJ2Teh
         QCx6pYUb5ljsN2vKKEqCWa1jTNQb9SfnQZW0W9N5ZXKWU+vJYiDJU69TmMOpoyRy6fBH
         CNvhdKqGdP9cfHrALABu0CkI8HfPuahfXA9U/Zb5zsVAmijvythXx1Gx4VKwtJpvUax9
         LR68XG0Vp/p4zY2BuTQEXxet3iwRFO4wnwy3gXE7L2+l7aIhgmdCUofJVdjB6yTxZp/6
         aw0UnqLsDcxf1DJQsekbdlDBLbrnrBGTxXg6RLOQXlalLiMzkYe95bKkO+Vo1EECZ+yb
         jq9w==
X-Forwarded-Encrypted: i=1; AJvYcCVLRtMB1N5bbsT7muAQ6PdFkOrKAnx1g6Fr7LbCYIcWXnVi1ho+G7coqwyQ2vpoOuOSo34=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzoi1k3abWClYM7XOnR+f0SEpJK/Jgs+Fae7xbRN0h+nxsRNV7J
	EybPiv34ir9Vmmi7j5JLi17naUDBD7ytahrd5z7BOznBFBckuAyI4xFy
X-Gm-Gg: AZuq6aJKGZF3HRZqqCZ9KGx3IwPrHKgYiV/DqI3qmBJmV5GbIi71NGlILF1PWSowf5u
	vLuFcOwANUHbrXKyp6yH/4kVUc3ZaHt7eFKP/4VaoNcG6Y+1Trx6A7Wx0qEXRRBR6QyNSMqmrz1
	TWFAF/y3drZkuam6lRNwwZ0PKgzrNb2cG1Uomq9VLktJzkLOJdMgxfysxDP4unHtgD02pmh0Uy/
	dCtszFSEk14eGHVSGr3nV3TVYbOcjO3EYOKRsBZBG2rMh6Xl+spU0JpGF3bNKxRRawWWOens+Ll
	LSIzY4209LwxeoJc9rG9ZKq7Zx40cYeHTjkeuark4NVrbMCQYeaf8NB9GTy5MIk5Gq8eTnsjvsV
	ORDB9czO5oxNnukqO2Vr8tc8H1FutTvVWrxullMAwCeodG+jwUxh15fnLvJRlwZqdZaXVN5ca/3
	sRC3wWPtjd9mkaIiN66qPXO4svhG+znCH45Lzqymlbu6AQCA==
X-Received: by 2002:a05:690c:6089:b0:792:7113:a305 with SMTP id 00721157ae682-793c671a7f3mr146815807b3.29.1769017778141;
        Wed, 21 Jan 2026 09:49:38 -0800 (PST)
Received: from devvm11784.nha0.facebook.com ([2a03:2880:25ff:40::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-793c66f6f97sm68737717b3.16.2026.01.21.09.49.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 09:49:37 -0800 (PST)
Date: Wed, 21 Jan 2026 09:49:36 -0800
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Bryan Tan <bryan-bt.tan@broadcom.com>,
	Vishnu Dasa <vishnu.dasa@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Shuah Khan <shuah@kernel.org>, Long Li <longli@microsoft.com>,
	Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	kvm@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-kselftest@vger.kernel.org, berrange@redhat.com,
	Sargun Dhillon <sargun@sargun.me>, linux-doc@vger.kernel.org,
	Bobby Eshleman <bobbyeshleman@meta.com>
Subject: Re: [PATCH net-next v15 01/12] vsock: add netns to vsock core
Message-ID: <aXERsFJLz9b9Fzce@devvm11784.nha0.facebook.com>
References: <20260116-vsock-vmtest-v15-0-bbfd1a668548@meta.com>
 <20260116-vsock-vmtest-v15-1-bbfd1a668548@meta.com>
 <aXDYfYy3f1NQm5A0@sgarzare-redhat>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXDYfYy3f1NQm5A0@sgarzare-redhat>
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68771-lists,kvm=lfdr.de];
	DMARC_POLICY_ALLOW(0.00)[gmail.com,none];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[31];
	DKIM_TRACE(0.00)[gmail.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bobbyeshleman@gmail.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo,meta.com:email]
X-Rspamd-Queue-Id: 906AA5D4AC
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Jan 21, 2026 at 03:48:13PM +0100, Stefano Garzarella wrote:
> On Fri, Jan 16, 2026 at 01:28:41PM -0800, Bobby Eshleman wrote:
> > From: Bobby Eshleman <bobbyeshleman@meta.com>
> > 
> > Add netns logic to vsock core. Additionally, modify transport hook
> > prototypes to be used by later transport-specific patches (e.g.,
> > *_seqpacket_allow()).
> > 
> > Namespaces are supported primarily by changing socket lookup functions
> > (e.g., vsock_find_connected_socket()) to take into account the socket
> > namespace and the namespace mode before considering a candidate socket a
> > "match".
> > 
> > This patch also introduces the sysctl /proc/sys/net/vsock/ns_mode to
> > report the mode and /proc/sys/net/vsock/child_ns_mode to set the mode
> > for new namespaces.
> > 
> > Add netns functionality (initialization, passing to transports, procfs,
> > etc...) to the af_vsock socket layer. Later patches that add netns
> > support to transports depend on this patch.
> 
> nit: maybe we should mention here why we changed the random port allocation
> 
> (not a big deal, only if you need to resend)
> 
> > 
> > dgram_allow(), stream_allow(), and seqpacket_allow() callbacks are
> > modified to take a vsk in order to perform logic on namespace modes. In
> > future patches, the net will also be used for socket
> > lookups in these functions.
> > 
> > Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
> > ---
> > Changes in v15:
> > - make static port in __vsock_bind_connectible per-netns
> > - remove __net_initdata because we want the ops beyond just boot
> > - add vsock_init_ns_mode kernel cmdline parameter to set init ns mode
> > - use if (ret || !write) in __vsock_net_mode_string() (Stefano)
> > - add vsock_net_mode_global() (Stefano)
> > - hide !net == VSOCK_NET_MODE_GLOBAL inside vsock_net_mode() (Stefano)
> > - clarify af_vsock.c comments on ns_mode/child_ns_mode (Stefano)
> > 
> > Changes in v14:
> > - include linux/sysctl.h in af_vsock.c
> > - squash patch 'vsock: add per-net vsock NS mode state' into this patch
> >  (prior version can be found here):
> >  https://lore.kernel.org/all/20251223-vsock-vmtest-v13-1-9d6db8e7c80b@meta.com/)
> > 
> > Changes in v13:
> > - remove net_mode and replace with direct accesses to net->vsock.mode,
> >  since this is now immutable.
> > - update comments about mode behavior and mutability, and sysctl API
> > - only pass NULL for net when wanting global, instead of net_mode ==
> >  VSOCK_NET_MODE_GLOBAL. This reflects the new logic
> >  of vsock_net_check_mode() that only requires net pointers (not
> >  net_mode).
> > - refactor sysctl string code into a re-usable function, because
> >  child_ns_mode and ns_mode both handle the same strings.
> > - remove redundant vsock_net_init(&init_net) call in module init because
> >  pernet registration calls the callback on the init_net too
> > 
> > Changes in v12:
> > - return true in dgram_allow(), stream_allow(), and seqpacket_allow()
> >  only if net_mode == VSOCK_NET_MODE_GLOBAL (Stefano)
> > - document bind(VMADDR_CID_ANY) case in af_vsock.c (Stefano)
> > - change order of stream_allow() call in vmci so we can pass vsk
> >  to it
> > 
> > Changes in v10:
> > - add file-level comment about what happens to sockets/devices
> >  when the namespace mode changes (Stefano)
> > - change the 'if (write)' boolean in vsock_net_mode_string() to
> >  if (!write), this simplifies a later patch which adds "goto"
> >  for mutex unlocking on function exit.
> > 
> > Changes in v9:
> > - remove virtio_vsock_alloc_rx_skb() (Stefano)
> > - remove vsock_global_dummy_net, not needed as net=NULL +
> >  net_mode=VSOCK_NET_MODE_GLOBAL achieves identical result
> > 
> > Changes in v7:
> > - hv_sock: fix hyperv build error
> > - explain why vhost does not use the dummy
> > - explain usage of __vsock_global_dummy_net
> > - explain why VSOCK_NET_MODE_STR_MAX is 8 characters
> > - use switch-case in vsock_net_mode_string()
> > - avoid changing transports as much as possible
> > - add vsock_find_{bound,connected}_socket_net()
> > - rename `vsock_hdr` to `sysctl_hdr`
> > - add virtio_vsock_alloc_linear_skb() wrapper for setting dummy net and
> >  global mode for virtio-vsock, move skb->cb zero-ing into wrapper
> > - explain seqpacket_allow() change
> > - move net setting to __vsock_create() instead of vsock_create() so
> >  that child sockets also have their net assigned upon accept()
> > 
> > Changes in v6:
> > - unregister sysctl ops in vsock_exit()
> > - af_vsock: clarify description of CID behavior
> > - af_vsock: fix buf vs buffer naming, and length checking
> > - af_vsock: fix length checking w/ correct ctl_table->maxlen
> > 
> > Changes in v5:
> > - vsock_global_net() -> vsock_global_dummy_net()
> > - update comments for new uAPI
> > - use /proc/sys/net/vsock/ns_mode instead of /proc/net/vsock_ns_mode
> > - add prototype changes so patch remains c)mpilable
> > ---
> > Documentation/admin-guide/kernel-parameters.txt |  14 +
> > MAINTAINERS                                     |   1 +
> > drivers/vhost/vsock.c                           |   6 +-
> > include/linux/virtio_vsock.h                    |   4 +-
> > include/net/af_vsock.h                          |  61 ++++-
> > include/net/net_namespace.h                     |   4 +
> > include/net/netns/vsock.h                       |  21 ++
> > net/vmw_vsock/af_vsock.c                        | 328 ++++++++++++++++++++++--
> > net/vmw_vsock/hyperv_transport.c                |   7 +-
> > net/vmw_vsock/virtio_transport.c                |   9 +-
> > net/vmw_vsock/virtio_transport_common.c         |   6 +-
> > net/vmw_vsock/vmci_transport.c                  |  26 +-
> > net/vmw_vsock/vsock_loopback.c                  |   8 +-
> > 13 files changed, 444 insertions(+), 51 deletions(-)
> > 
> > diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> > index a8d0afde7f85..b6e3bfe365a1 100644
> > --- a/Documentation/admin-guide/kernel-parameters.txt
> > +++ b/Documentation/admin-guide/kernel-parameters.txt
> > @@ -8253,6 +8253,20 @@ Kernel parameters
> > 			            them quite hard to use for exploits but
> > 			            might break your system.
> > 
> > +	vsock_init_ns_mode=
> > +			[KNL,NET] Set the vsock namespace mode for the init
> > +			(root) network namespace.
> > +
> > +			global      [default] The init namespace operates in
> > +			            global mode where CIDs are system-wide and
> > +			            sockets can communicate across global
> > +			            namespaces.
> > +
> > +			local       The init namespace operates in local mode
> > +			            where CIDs are private to the namespace and
> > +			            sockets can only communicate within the same
> > +			            namespace.
> > +
> 
> My comment on v14 was more to start a discussion :-) sorry to not be clear.

No worries, resending with this included started a good discussion so
not for nil.

> 
> I briefly discussed it with Paolo in chat to better understand our policy
> between cmdline parameters and module parameters, and it seems that both are
> discouraged.
> 
> So he asked me if we have a use case for this, and thinking about it, I
> don't have one at the moment. Also, if a user decides to set all netns to
> local, whether init_net is local or global doesn't really matter, right?
> 
> So perhaps before adding this, we should have a real use case.
> Perhaps more than this feature, I would add a way to change the default of
> all netns (including init_net) from global to local. But we can do that
> later, since all netns have a way to understand what mode they are in, so we
> don't break anything and the user has to explicitly change it, knowing that
> they are breaking compatibility with pre-netns support.\
> 
> 
> That said, at this point, maybe we can remove this, documenting that
> init_net is always global, and if we have a use case in the future, we can
> add this (or something else) to set the init_net mode (or change the default
> for all netns).
> 
> Let's wait a bit before next version to wait a comment from Paolo or Jakub
> on this. But I'm almost fine with both ways, so:
> 
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> 
> > 	vt.color=	[VT] Default text color.
> > 			Format: 0xYX, X = foreground, Y = background.
> > 			Default: 0x07 = light gray on black.
> 
> [...]
> 
> > diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> > index a3505a4dcee0..3fc8160d51df 100644
> > --- a/net/vmw_vsock/af_vsock.c
> > +++ b/net/vmw_vsock/af_vsock.c
> 
> [...]
> 
> > @@ -235,33 +303,42 @@ static void __vsock_remove_connected(struct
> > vsock_sock *vsk)
> > 	sock_put(&vsk->sk);
> > }
> > 
> 
> In the v14 I suggested to add some documentation on top of the vsock_find*()
> vs vsock_find_*_net() to explain better which one should be used by
> transports.
> 
> Again is not a big deal, we can fix later if you don't need to resend.
> 
> Thanks,
> Stefano

Sorry about that slipping through the cracks, will add to v16.

I'll resend with:

1. revert init ns cmdline
2. update this message about why the port allocation changes
3. fix the vmtest missing ns arg bug that Kuba mentioned
4. update documentation on top of vsock_find* / vsock_find_*_net
5. update documentation on top of af_vsock.c w/ note about init_ns
having its mode fixed to global

Unless any prior feedback slipped, I think this captures everything
pending? 

Best,
Bobby

