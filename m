Return-Path: <kvm+bounces-62255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 96D6CC3E31D
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 03:03:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 26FF034AECB
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 02:03:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E9982E6CCD;
	Fri,  7 Nov 2025 02:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VlzANfW7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2092C236B
	for <kvm@vger.kernel.org>; Fri,  7 Nov 2025 02:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762480995; cv=none; b=BDkOJtJto4ZBd9gD3yqnyYev8jYpqe5Nx5JP5emZLDHvci73/GlhkGl4MY1/VSwAfjnbwxLe+wH4+QskwjxsR1mCi1CL56rdLRJMPGg/q/PNeY7ZpRBRs34HIQZmPNlm7OavdpjjfSIlGD0QJbXog7e9c708pCdQs/wA5spWgI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762480995; c=relaxed/simple;
	bh=jbaFs7HXAknadzOd2v14FHZ+9swDgs8rBZ4/kMZGQ78=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I6yUF6KjYb0vXuvrbnSijSg9LOqlp/7pAdwf0m/YaOjS52a07pUN+I4lxlLaLqcQSu+ZXrxgpbtwPCFY7KDH4fMhg/et//U4b8jPxtBGPUmPg97qath5TFGkUjR8xltyPq4yPZUzgzBSptbF3Rlq0DG9iIosmsQXuq+dPV0I+II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VlzANfW7; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-7866375e943so2574077b3.0
        for <kvm@vger.kernel.org>; Thu, 06 Nov 2025 18:03:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762480992; x=1763085792; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LE8xXkDGsO1BtG0IzGZz5XUwYh68ZT9mGhz/ltaZxVk=;
        b=VlzANfW7yL7KEsVpYMe5LSaaysy7WpfEkxJlUHcDzBloibkmlvnUUd3BBIx49MlJJd
         fVnK5Sy1KAP222txc9rBFY/wDNuOoLcbJRTV5TAgGIOzkb/Ev8keDrtYp0C2ZvSL7ufk
         PHKlQm7LZ3ofj2WPun+SLeiXZSAAiQsS4zo64xhOhJCMKX6pDUjtcqDaOqs3onqd3G6j
         zqcoFkmhqRCYJeTlUkSpRqelp0PcPiX5CQTltX3ant6Zgs/uPxUAsL659gSD2lAm4BYV
         m79E/eTPL4rxpnZf8AuKj/Ts8hSX2lbw+IaKaiR5EEQMrSSGtGFR8ROctLj4sWZlVZkJ
         AvaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762480992; x=1763085792;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LE8xXkDGsO1BtG0IzGZz5XUwYh68ZT9mGhz/ltaZxVk=;
        b=g2Hrpvz0RW/TLxxhP3Lr20HZ/AJ63gE04HboKQwEulQSDhfN1jEwpXOsJOhNAu+wxJ
         W795/P43b11DnCSkbg0H2Ih127DReu+2l4Ua6ZGmAKJPQBV0kIYuxCvcFmROtCkFskFe
         plI/6dvsIf1MRo3ZudnZW7cjN5OFIq8lW3lcvt4Z1NrP8hCURJWptuAUopYQzZbVK0nh
         Tf22VlHdVsn7uabkzgFVMBA8H3ZwQX38mEaZVG0z0MSsvAJTKq5AMcoefdDZDrRrKzak
         89QEx+cyiHTHrpU7PUYfBjbFK67yH/oqhr7kGvLwF6VpR4Um6dBNHb5CxEOX956fp0m/
         HvNA==
X-Forwarded-Encrypted: i=1; AJvYcCUmrcbRX0e/zDt7aOEnsY0jSg4qEuqeF4fJfdHrO8ZFfLbK+S+ixW2uTvx8A+p9d28ImwU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpBEY4FFNRYBaNMw69zjfNIJaJqfF3KNT4Kwt1rLL0U/iq6Gxu
	geGdX71uGJ80kFNP3i3BS78rq+uWop3xjlmIwxtuRq6nTQOhvFEzrKhD
X-Gm-Gg: ASbGncuVgi08ylpWwz8ea95zJ2Eka6fURsjNuxIHZNCjFkWhZL0ZHyVhxG5gcwdIaht
	OiOraUQhmqXKofiH40XNgBnORH0iNbn+EAM5fUfwoZ2/pr5BMVXr60ggV8g8dtS9hne61WvjwYe
	X0N8AmaFgsK99Mq1yfOlYFtuMALR4rTJOa1Cq8kzy3aYrxtQKP/VVDDXlIUL1PP1uFc+uatnfA0
	XcX2pUkD5SmmhYlOTQE04XHiRLq4L1lc5R3TKgwyQsnWeYmGQZvd3Jp9AN1mkPleW99Bdf8nIMf
	dOJ6Zaqh5V1f0OcebW566zxKbT+HrAPgE0mxA/2Dh9E7gDxq8ZyDI56K1SQ0rDq61pPVsshh5Sk
	qRbEq82V0uPGrCtO8GkLrlhK5z6J/QCT5o+sIONoPwmWD5JYdbPU/cc5diK1jHGexsGKOt/IFvm
	VaHMxKAtqn8axiYUrGHbecP4qRc4CTTNgABq4l
X-Google-Smtp-Source: AGHT+IEwbIfkx8e6UFcLnHpiFGfUFmQm2vnbwrnvOgF/SYfR8oHFoXDW1umiHrZRuUi/xmBkxmxybg==
X-Received: by 2002:a05:690c:a796:b0:786:6179:1a47 with SMTP id 00721157ae682-787c53cafb9mr11823947b3.44.1762480992273;
        Thu, 06 Nov 2025 18:03:12 -0800 (PST)
Received: from devvm11784.nha0.facebook.com ([2a03:2880:25ff:49::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-787b1421493sm13364027b3.25.2025.11.06.18.03.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 18:03:11 -0800 (PST)
Date: Thu, 6 Nov 2025 18:03:10 -0800
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
	berrange@redhat.com, Bobby Eshleman <bobbyeshleman@meta.com>
Subject: Re: [PATCH net-next v8 04/14] vsock: add netns to vsock core
Message-ID: <aQ1TXjb8AWIzgAu4@devvm11784.nha0.facebook.com>
References: <20251023-vsock-vmtest-v8-0-dea984d02bb0@meta.com>
 <20251023-vsock-vmtest-v8-4-dea984d02bb0@meta.com>
 <zxy7e4xihxujtlcnqjdgfxaqckfurop77eukbose74nzaxyv64@7djyz3gv4eys>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <zxy7e4xihxujtlcnqjdgfxaqckfurop77eukbose74nzaxyv64@7djyz3gv4eys>

On Thu, Nov 06, 2025 at 05:18:00PM +0100, Stefano Garzarella wrote:
> On Thu, Oct 23, 2025 at 11:27:43AM -0700, Bobby Eshleman wrote:
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
> > Introduce a dummy namespace struct, __vsock_global_dummy_net, to be
> > used by transports that do not support namespacing. This dummy always
> > has mode "global" to preserve previous CID behavior.
> > 
> > This patch also introduces the sysctl /proc/sys/net/vsock/ns_mode that
> > accepts the "global" or "local" mode strings.
> > 
> > The transports (besides vhost) are modified to use the global dummy,
> > which makes them behave as if always in the global namespace. Vhost is
> > an exception because it inherits its namespace from the process that
> > opens the vhost device.
> > 
> > Add netns functionality (initialization, passing to transports, procfs,
> > etc...) to the af_vsock socket layer. Later patches that add netns
> > support to transports depend on this patch.
> > 
> > seqpacket_allow() callbacks are modified to take a vsk so that transport
> > implementations can inspect sock_net(sk) and vsk->net_mode when performing
> > lookups (e.g., vhost does this in its future netns patch). Because the
> > API change affects all transports, it seemed more appropriate to make
> > this internal API change in the "vsock core" patch then in the "vhost"
> > patch.
> > 
> > Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
> > ---
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
> > - add prototype changes so patch remains compilable
> > ---
> > drivers/vhost/vsock.c            |   4 +-
> > include/linux/virtio_vsock.h     |  21 ++++
> > include/net/af_vsock.h           |  14 ++-
> > net/vmw_vsock/af_vsock.c         | 264 ++++++++++++++++++++++++++++++++++++---
> > net/vmw_vsock/virtio_transport.c |   7 +-
> > net/vmw_vsock/vsock_loopback.c   |   4 +-
> > 6 files changed, 288 insertions(+), 26 deletions(-)
> > 
> > diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> > index ae01457ea2cd..34adf0cf9124 100644
> > --- a/drivers/vhost/vsock.c
> > +++ b/drivers/vhost/vsock.c
> > @@ -404,7 +404,7 @@ static bool vhost_transport_msgzerocopy_allow(void)
> > 	return true;
> > }
> > 
> > -static bool vhost_transport_seqpacket_allow(u32 remote_cid);
> > +static bool vhost_transport_seqpacket_allow(struct vsock_sock *vsk, u32 remote_cid);
> > 
> > static struct virtio_transport vhost_transport = {
> > 	.transport = {
> > @@ -460,7 +460,7 @@ static struct virtio_transport vhost_transport = {
> > 	.send_pkt = vhost_transport_send_pkt,
> > };
> > 
> > -static bool vhost_transport_seqpacket_allow(u32 remote_cid)
> > +static bool vhost_transport_seqpacket_allow(struct vsock_sock *vsk, u32 remote_cid)
> > {
> > 	struct vhost_vsock *vsock;
> > 	bool seqpacket_allow = false;
> > diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
> > index 7f334a32133c..29290395054c 100644
> > --- a/include/linux/virtio_vsock.h
> > +++ b/include/linux/virtio_vsock.h
> > @@ -153,6 +153,27 @@ static inline void virtio_vsock_skb_set_net_mode(struct sk_buff *skb,
> > 	VIRTIO_VSOCK_SKB_CB(skb)->net_mode = net_mode;
> > }
> > 
> > +static inline struct sk_buff *
> > +virtio_vsock_alloc_rx_skb(unsigned int size, gfp_t mask)
> > +{
> > +	struct sk_buff *skb;
> > +
> > +	skb = virtio_vsock_alloc_linear_skb(size, mask);
> > +	if (!skb)
> > +		return NULL;
> > +
> > +	memset(skb->head, 0, VIRTIO_VSOCK_SKB_HEADROOM);
> > +
> > +	/* virtio-vsock does not yet support namespaces, so on receive
> > +	 * we force legacy namespace behavior using the global dummy net
> > +	 * and global net mode.
> > +	 */
> > +	virtio_vsock_skb_set_net(skb, vsock_global_dummy_net());
> > +	virtio_vsock_skb_set_net_mode(skb, VSOCK_NET_MODE_GLOBAL);
> > +
> > +	return skb;
> > +}
> 
> Why we are introducing this change in this patch?
> 
> Where the net of the virtio's skb is read?
> 

Oh good point, this is a weird place for this. I'll move this to where
it is actually used.

[...]

> > 
> > +static int vsock_net_mode_string(const struct ctl_table *table, int write,
> > +				 void *buffer, size_t *lenp, loff_t *ppos)
> > +{
> > +	char data[VSOCK_NET_MODE_STR_MAX] = {0};
> > +	enum vsock_net_mode mode;
> > +	struct ctl_table tmp;
> > +	struct net *net;
> > +	int ret;
> > +
> > +	if (!table->data || !table->maxlen || !*lenp) {
> > +		*lenp = 0;
> > +		return 0;
> > +	}
> > +
> > +	net = current->nsproxy->net_ns;
> > +	tmp = *table;
> > +	tmp.data = data;
> > +
> > +	if (!write) {
> > +		const char *p;
> > +
> > +		mode = vsock_net_mode(net);
> > +
> > +		switch (mode) {
> > +		case VSOCK_NET_MODE_GLOBAL:
> > +			p = VSOCK_NET_MODE_STR_GLOBAL;
> > +			break;
> > +		case VSOCK_NET_MODE_LOCAL:
> > +			p = VSOCK_NET_MODE_STR_LOCAL;
> > +			break;
> > +		default:
> > +			WARN_ONCE(true, "netns has invalid vsock mode");
> > +			*lenp = 0;
> > +			return 0;
> > +		}
> > +
> > +		strscpy(data, p, sizeof(data));
> > +		tmp.maxlen = strlen(p);
> > +	}
> > +
> > +	ret = proc_dostring(&tmp, write, buffer, lenp, ppos);
> > +	if (ret)
> > +		return ret;
> > +
> > +	if (write) {
> 
> Do we need to check some capability, e.g. CAP_NET_ADMIN ?
> 

We get that for free via the sysctl_net registration, through this path
on open (CAP_NET_ADMIN is checked in net_ctl_permissions):

	net_ctl_permissions+1
	sysctl_perm+24
	proc_sys_permission+117
	inode_permission+217
	link_path_walk+162
	path_openat+152
	do_filp_open+171
	do_sys_openat2+98
	__x64_sys_openat+69
	do_syscall_64+93

Verified with:

cp /bin/echo /tmp/echo_netadmin
setcap cap_net_admin+ep /tmp/echo_netadmin

(non-root user fails with regular echo, succeeds with
/tmp/echo_netadmin)

Best regards,
Bobby

