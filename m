Return-Path: <kvm+bounces-41492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BDD8A68EC7
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 15:18:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F24C88707B
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 14:16:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7E1B1AF0D7;
	Wed, 19 Mar 2025 14:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NdISDVJg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A371B70808
	for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 14:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742393757; cv=none; b=K/33IYapMuTVrMWK5PHYC+LYakZV1He21/Z/i4JAyg8IlpEiSK7YdgMFfuCnivhOs5PFVqLiwYv3XJlklMaKSkPVn1S86nyJ1FWJPvd41+fQesBgUytJUyUiLsGg5BJBOtDjeBn+nA0SVagRRd05MLD8L7AdwvS3Bjty/+IgTfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742393757; c=relaxed/simple;
	bh=LF4g0Wtkv1ExkRExiiE97fXt+Jm86S+wtbdNQLafb9Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QgzPFBIOYLuSmUbTQlFb566ugCmUJD05WZkDOeSpBgbvDsHghaGIp9lWPEBBZfDduI6Nbk+Si/Se+hI2RjpLiBNOs9q2slrzDfQ79MoP32dXAduNveFIFRd0osyxj7VQxzGCf3LXQIBOkayQMlqBeYCqMtkhbG9HUfSp8Lz/SSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NdISDVJg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742393754;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y2VAxhCwsLa17QjP+alkEDD6g534w8XyOy3g1eEgJXw=;
	b=NdISDVJgGUSBaQqr/HrohIDhLPdIKBrF1BnR+ZT0rFI76EM2tFSzHESkrRm/8DiwbtwEmh
	4YFcXhnjKl/4+awrVJFKrCisui+P1YtLv6Wglq2oX6DdvK27TkBOGmUYx/UpZyR3aJYq+z
	lHg6n0/3Cpg8JgB9p+C5H1NB4LzqXKY=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-695-MImtb5qVO5KychbA7vBqGA-1; Wed, 19 Mar 2025 10:15:53 -0400
X-MC-Unique: MImtb5qVO5KychbA7vBqGA-1
X-Mimecast-MFC-AGG-ID: MImtb5qVO5KychbA7vBqGA_1742393752
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-ac313093ed8so608400566b.0
        for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 07:15:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742393752; x=1742998552;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y2VAxhCwsLa17QjP+alkEDD6g534w8XyOy3g1eEgJXw=;
        b=JM0rgwwBxj08hpwHul5dYvUUP4ikAKw8o1R7q4rNDXD6Dg4A6bTVDnaBxsB6bBUBys
         CWlIo5IhwOPsdMt0pHejNpxbed2M+k7mVkwdr23GBMjXnwNCEmDQ0uREXwya8qzh3XTE
         mffbW3mCbc/Y/PTbDK+/zJxBGO8tG1mcg0t/M2+Jy9PmcAVAm3lqbC/hP+AamelLCiRB
         mylYGJHbpR57VVb97ufoLryxt74//JVuEuX7pYdGZRpjElTpTLJTmnS0+MPmWZ9hJaRO
         n9uBhqXcD/vbv9hkhcm5hZrYIttXrovvdA98IpltFmJTITXbu0YP9IQ8JlzHavwyZCGS
         +jtQ==
X-Forwarded-Encrypted: i=1; AJvYcCVJO/mA3917ceLg9O5oWUpU2OTbsoh4HU+1Nk9SSKlgKypgSWMEyRzOuhprtzVYnRvQ950=@vger.kernel.org
X-Gm-Message-State: AOJu0YwAtxTzOR0LwZVIcRYKlByQaba3nF16a/Ob94bosGISdcCVkr0r
	D35jZq7vLxw9wXT8zk1I2IUHkEYSy5HEsNSxZAoP4LJwTXU/7mZ3QL8wtQRPRPer/7CoQybuCH8
	Bp0fGO/o8TCqDHDPhSQ5ni0op2uK0KaCe3GewUZIG5ijJlSW6bg==
X-Gm-Gg: ASbGnctgZjosyxixPs1iR9NvTrNODA/68H6Zp4KpbD2uKzA+xcEGrXwiInw2yIwDue5
	ZufCL+47+Xco0j4p2ij37VhQJoHBZU7kSm7xvzMq7xU6BzlF56yJs4PcxBfLGjZKH/JpIswtDL+
	yAwFkn7K4y2VIufe1DQVQmjFp+n0tmElNEp3UM5WQxUUCIL6Tv0706HCzctNix86/4YrRO083Wi
	fi13Ciu6EnTd7Y5GCewd8+e78wu1CBNnYZV0msTqD0CRpruN5JRM4muSO/+WO60IHVy/fdhAEzb
	hngPungkNkUisgfZ6qIG/vfG6kdJQ6gL+UVvrdO8sMTIsxSdNw74LgKfGLq8rw==
X-Received: by 2002:a17:907:7241:b0:abf:6a53:2cd5 with SMTP id a640c23a62f3a-ac3b7fb315emr289919766b.48.1742393751800;
        Wed, 19 Mar 2025 07:15:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHzHyqJnEz3CY6jBNtIK0RgcNxUtdkLBNsM82EOFlodJ8L8JElYp/3TPTJDna1t/gqpoRQaeg==
X-Received: by 2002:a17:907:7241:b0:abf:6a53:2cd5 with SMTP id a640c23a62f3a-ac3b7fb315emr289824566b.48.1742393741928;
        Wed, 19 Mar 2025 07:15:41 -0700 (PDT)
Received: from sgarzare-redhat (host-79-53-30-53.retail.telecomitalia.it. [79.53.30.53])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3146aec28sm1037401866b.12.2025.03.19.07.15.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Mar 2025 07:15:41 -0700 (PDT)
Date: Wed, 19 Mar 2025 15:15:36 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, 
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, Bryan Tan <bryan-bt.tan@broadcom.com>, 
	Vishnu Dasa <vishnu.dasa@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, "David S. Miller" <davem@davemloft.net>, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 3/3] vhost/vsock: use netns of process that opens the
 vhost-vsock-netns device
Message-ID: <wy7b2rszoahpx6k526ygepzyyygg5bdebkvlg2ed3eg7ceomsq@mpjcq6hjzmvj>
References: <20250312-vsock-netns-v2-0-84bffa1aa97a@gmail.com>
 <20250312-vsock-netns-v2-3-84bffa1aa97a@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250312-vsock-netns-v2-3-84bffa1aa97a@gmail.com>

On Wed, Mar 12, 2025 at 01:59:37PM -0700, Bobby Eshleman wrote:
>From: Stefano Garzarella <sgarzare@redhat.com>
>
>This patch assigns the network namespace of the process that opened
>vhost-vsock-netns device (e.g. VMM) to the packets coming from the
>guest, allowing only host sockets in the same network namespace to
>communicate with the guest.
>
>This patch also allows having different VMs, running in different
>network namespace, with the same CID/port.
>
>This patch brings namespace support only to vhost-vsock, but not
>to virtio-vsock, hyperv, or vmci.
>
>Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

Please describe the new behaviour you described in the cover letter
about CID connected, etc.

>Signed-off-by: Bobby Eshleman <bobbyeshleman@gmail.com>
>---
>v1 -> v2
> * removed 'netns' module param
> * renamed vsock_default_net() to vsock_global_net() to reflect new
>   semantics
> * reserved NULL net to indicate "global" vsock namespace
>
>RFC -> v1
>* added 'netns' module param
>* added 'vsock_net_eq()' to check the "net" assigned to a socket
>  only when 'netns' support is enabled
>---
> drivers/vhost/vsock.c            | 97 +++++++++++++++++++++++++++++++++-------
> include/linux/miscdevice.h       |  1 +
> include/net/af_vsock.h           |  3 +-
> net/vmw_vsock/af_vsock.c         | 30 ++++++++++++-
> net/vmw_vsock/virtio_transport.c |  4 +-
> net/vmw_vsock/vsock_loopback.c   |  4 +-
> 6 files changed, 117 insertions(+), 22 deletions(-)
>
>diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>index 02e2a3551205a4398a74a167a82802d950c962f6..8702beb8238aa290b6d901e53c36481637840017 100644
>--- a/drivers/vhost/vsock.c
>+++ b/drivers/vhost/vsock.c
>@@ -46,6 +46,7 @@ static DEFINE_READ_MOSTLY_HASHTABLE(vhost_vsock_hash, 8);
> struct vhost_vsock {
> 	struct vhost_dev dev;
> 	struct vhost_virtqueue vqs[2];
>+	struct net *net;
>
> 	/* Link to global vhost_vsock_hash, writes use vhost_vsock_mutex */
> 	struct hlist_node hash;
>@@ -67,8 +68,9 @@ static u32 vhost_transport_get_local_cid(void)
> /* Callers that dereference the return value must hold vhost_vsock_mutex or the
>  * RCU read lock.
>  */
>-static struct vhost_vsock *vhost_vsock_get(u32 guest_cid)
>+static struct vhost_vsock *vhost_vsock_get(u32 guest_cid, struct net *net, bool global_fallback)
> {
>+	struct vhost_vsock *fallback = NULL;
> 	struct vhost_vsock *vsock;
>
> 	hash_for_each_possible_rcu(vhost_vsock_hash, vsock, hash, guest_cid) {
>@@ -78,11 +80,18 @@ static struct vhost_vsock *vhost_vsock_get(u32 guest_cid)
> 		if (other_cid == 0)
> 			continue;
>
>-		if (other_cid == guest_cid)
>-			return vsock;
>+		if (other_cid == guest_cid) {
>+			if (net_eq(net, vsock->net))
>+				return vsock;
>
>+			if (net_eq(vsock->net, vsock_global_net()))
>+				fallback = vsock;

I'd like to reuse the same function that I suggested in patch 1, but I 
understand that we return different things here, so we either do a macro 
or using `void *`, but I would like this logic to be centralized 
somewhere and reusable in the core and transports if it's possible.

>+		}
> 	}
>
>+	if (global_fallback)
>+		return fallback;
>+
> 	return NULL;
> }
>
>@@ -272,13 +281,14 @@ static int
> vhost_transport_send_pkt(struct sk_buff *skb)
> {
> 	struct virtio_vsock_hdr *hdr = virtio_vsock_hdr(skb);
>+	struct net *net = VIRTIO_VSOCK_SKB_CB(skb)->net;
> 	struct vhost_vsock *vsock;
> 	int len = skb->len;
>
> 	rcu_read_lock();
>
> 	/* Find the vhost_vsock according to guest context id  */
>-	vsock = vhost_vsock_get(le64_to_cpu(hdr->dst_cid));
>+	vsock = vhost_vsock_get(le64_to_cpu(hdr->dst_cid), net, true);
> 	if (!vsock) {
> 		rcu_read_unlock();
> 		kfree_skb(skb);
>@@ -305,7 +315,8 @@ vhost_transport_cancel_pkt(struct vsock_sock *vsk)
> 	rcu_read_lock();
>
> 	/* Find the vhost_vsock according to guest context id  */
>-	vsock = vhost_vsock_get(vsk->remote_addr.svm_cid);
>+	vsock = vhost_vsock_get(vsk->remote_addr.svm_cid,)
>+				sock_net(sk_vsock(vsk)), true);
> 	if (!vsock)
> 		goto out;
>
>@@ -403,7 +414,7 @@ static bool vhost_transport_msgzerocopy_allow(void)
> 	return true;
> }
>
>-static bool vhost_transport_seqpacket_allow(u32 remote_cid);
>+static bool vhost_transport_seqpacket_allow(struct vsock_sock *vsk, u32 remote_cid);
>
> static struct virtio_transport vhost_transport = {
> 	.transport = {
>@@ -459,13 +470,14 @@ static struct virtio_transport vhost_transport = {
> 	.send_pkt = vhost_transport_send_pkt,
> };
>
>-static bool vhost_transport_seqpacket_allow(u32 remote_cid)
>+static bool vhost_transport_seqpacket_allow(struct vsock_sock *vsk, u32 remote_cid)
> {
>+	struct net *net = sock_net(sk_vsock(vsk));
> 	struct vhost_vsock *vsock;
> 	bool seqpacket_allow = false;
>
> 	rcu_read_lock();
>-	vsock = vhost_vsock_get(remote_cid);
>+	vsock = vhost_vsock_get(remote_cid, net, true);
>
> 	if (vsock)
> 		seqpacket_allow = vsock->seqpacket_allow;
>@@ -525,7 +537,7 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
> 			continue;
> 		}
>
>-		VIRTIO_VSOCK_SKB_CB(skb)->net = vsock_global_net();
>+		VIRTIO_VSOCK_SKB_CB(skb)->net = vsock->net;
> 		total_len += sizeof(*hdr) + skb->len;
>
> 		/* Deliver to monitoring devices all received packets */
>@@ -650,7 +662,7 @@ static void vhost_vsock_free(struct vhost_vsock *vsock)
> 	kvfree(vsock);
> }
>
>-static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
>+static int __vhost_vsock_dev_open(struct inode *inode, struct file *file, struct net *net)
> {
> 	struct vhost_virtqueue **vqs;
> 	struct vhost_vsock *vsock;
>@@ -669,6 +681,8 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
> 		goto out;
> 	}
>
>+	vsock->net = net;
>+
> 	vsock->guest_cid = 0; /* no CID assigned yet */
> 	vsock->seqpacket_allow = false;
>
>@@ -693,6 +707,22 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
> 	return ret;
> }
>
>+static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
>+{
>+	return __vhost_vsock_dev_open(inode, file, vsock_global_net());
>+}
>+
>+static int vhost_vsock_netns_dev_open(struct inode *inode, struct file *file)
>+{
>+	struct net *net;
>+
>+	net = get_net_ns_by_pid(current->pid);
>+	if (IS_ERR(net))
>+		return PTR_ERR(net);
>+
>+	return __vhost_vsock_dev_open(inode, file, net);
>+}
>+
> static void vhost_vsock_flush(struct vhost_vsock *vsock)
> {
> 	vhost_dev_flush(&vsock->dev);
>@@ -708,7 +738,7 @@ static void vhost_vsock_reset_orphans(struct sock *sk)
> 	 */
>
> 	/* If the peer is still valid, no need to reset connection */
>-	if (vhost_vsock_get(vsk->remote_addr.svm_cid))
>+	if (vhost_vsock_get(vsk->remote_addr.svm_cid, sock_net(sk), true))
> 		return;
>
> 	/* If the close timeout is pending, let it expire.  This avoids races
>@@ -753,6 +783,8 @@ static int vhost_vsock_dev_release(struct inode *inode, struct file *file)
> 	virtio_vsock_skb_queue_purge(&vsock->send_pkt_queue);
>
> 	vhost_dev_cleanup(&vsock->dev);
>+	if (vsock->net)
>+		put_net(vsock->net);
> 	kfree(vsock->dev.vqs);
> 	vhost_vsock_free(vsock);
> 	return 0;
>@@ -777,9 +809,15 @@ static int vhost_vsock_set_cid(struct vhost_vsock *vsock, u64 guest_cid)
> 	if (vsock_find_cid(guest_cid))
> 		return -EADDRINUSE;
>
>+	/* If this namespace has already connected to this CID, then report
>+	 * that this address is already in use.

Why? (I mean a comment should explain more the reason that what we do)

>+	 */
>+	if (vsock->net && vsock_net_has_connected(vsock->net, guest_cid))
>+		return -EADDRINUSE;

Why only if `vsock->net` is not null?

Also, if we have a function to assign NULL to `vsock->net` because for 
us it's a special meaning, I think we should also have a function to 
check it if it's a global netns. I mean or we add 2 functions to set it 
and to check it, or none.

>+
> 	/* Refuse if CID is already in use */
> 	mutex_lock(&vhost_vsock_mutex);
>-	other = vhost_vsock_get(guest_cid);
>+	other = vhost_vsock_get(guest_cid, vsock->net, false);
> 	if (other && other != vsock) {
> 		mutex_unlock(&vhost_vsock_mutex);
> 		return -EADDRINUSE;
>@@ -931,6 +969,24 @@ static struct miscdevice vhost_vsock_misc = {
> 	.fops = &vhost_vsock_fops,
> };
>
>+static const struct file_operations vhost_vsock_netns_fops = {
>+	.owner          = THIS_MODULE,
>+	.open           = vhost_vsock_netns_dev_open,
>+	.release        = vhost_vsock_dev_release,
>+	.llseek		= noop_llseek,
>+	.unlocked_ioctl = vhost_vsock_dev_ioctl,
>+	.compat_ioctl   = compat_ptr_ioctl,
>+	.read_iter      = vhost_vsock_chr_read_iter,
>+	.write_iter     = vhost_vsock_chr_write_iter,
>+	.poll           = vhost_vsock_chr_poll,
>+};
>+
>+static struct miscdevice vhost_vsock_netns_misc = {
>+	.minor = VHOST_VSOCK_NETNS_MINOR,
>+	.name = "vhost-vsock-netns",
>+	.fops = &vhost_vsock_netns_fops,
>+};
>+
> static int __init vhost_vsock_init(void)
> {
> 	int ret;
>@@ -941,17 +997,26 @@ static int __init vhost_vsock_init(void)
> 		return ret;
>
> 	ret = misc_register(&vhost_vsock_misc);
>-	if (ret) {
>-		vsock_core_unregister(&vhost_transport.transport);
>-		return ret;
>-	}
>+	if (ret)
>+		goto out_vt;
>+
>+	ret = misc_register(&vhost_vsock_netns_misc);
>+	if (ret)
>+		goto out_vvm;
>
> 	return 0;
>+
>+out_vvm:

out_misc:

>+	misc_deregister(&vhost_vsock_misc);
>+out_vt:

out_core:

>+	vsock_core_unregister(&vhost_transport.transport);
>+	return ret;
> };
>
> static void __exit vhost_vsock_exit(void)
> {
> 	misc_deregister(&vhost_vsock_misc);
>+	misc_deregister(&vhost_vsock_netns_misc);

nit: I'd do the reverse order of vhost_vsock_init(), so moving this
new line at the top.

> 	vsock_core_unregister(&vhost_transport.transport);
> };
>
>diff --git a/include/linux/miscdevice.h b/include/linux/miscdevice.h
>index 69e110c2b86a9b16c1637778a25e1eebb3fd0111..a7e11b70a5398a225c4d63d50ac460e6388e022c 100644
>--- a/include/linux/miscdevice.h
>+++ b/include/linux/miscdevice.h
>@@ -71,6 +71,7 @@
> #define USERIO_MINOR		240
> #define VHOST_VSOCK_MINOR	241
> #define RFKILL_MINOR		242
>+#define VHOST_VSOCK_NETNS_MINOR	243
> #define MISC_DYNAMIC_MINOR	255
>
> struct device;
>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>index 41afbc18648c953da27a93571d408de968aa7668..1e37737689a741d91e64b8c0ed0a931fc7376194 100644
>--- a/include/net/af_vsock.h
>+++ b/include/net/af_vsock.h
>@@ -143,7 +143,7 @@ struct vsock_transport {
> 				     int flags);
> 	int (*seqpacket_enqueue)(struct vsock_sock *vsk, struct msghdr *msg,
> 				 size_t len);
>-	bool (*seqpacket_allow)(u32 remote_cid);
>+	bool (*seqpacket_allow)(struct vsock_sock *vsk, u32 remote_cid);

I'd do this change + transports changes in a separate patch.

> 	u32 (*seqpacket_has_data)(struct vsock_sock *vsk);
>
> 	/* Notification. */
>@@ -258,4 +258,5 @@ static inline bool vsock_msgzerocopy_allow(const struct vsock_transport *t)
> }
>
> struct net *vsock_global_net(void);
>+bool vsock_net_has_connected(struct net *net, u64 guest_cid);
> #endif /* __AF_VSOCK_H__ */
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index d206489bf0a81cf989387c7c8063be91a7c21a7d..58fa415555d6aae5043b5ca2bfc4783af566cf28 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -391,6 +391,34 @@ void vsock_for_each_connected_socket(struct vsock_transport *transport,
> }
> EXPORT_SYMBOL_GPL(vsock_for_each_connected_socket);
>
>+bool vsock_net_has_connected(struct net *net, u64 guest_cid)
>+{
>+	bool ret = false;
>+	int i;
>+
>+	spin_lock_bh(&vsock_table_lock);
>+
>+	for (i = 0; i < ARRAY_SIZE(vsock_connected_table); i++) {
>+		struct vsock_sock *vsk;
>+
>+		list_for_each_entry(vsk, &vsock_connected_table[i],
>+				    connected_table) {
>+			if (sock_net(sk_vsock(vsk)) != net)
>+				continue;
>+
>+			if (vsk->remote_addr.svm_cid == guest_cid) {
>+				ret = true;
>+				goto out;
>+			}
>+		}
>+	}
>+
>+out:
>+	spin_unlock_bh(&vsock_table_lock);
>+	return ret;
>+}
>+EXPORT_SYMBOL_GPL(vsock_net_has_connected);
>+
> void vsock_add_pending(struct sock *listener, struct sock *pending)
> {
> 	struct vsock_sock *vlistener;
>@@ -537,7 +565,7 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
>
> 	if (sk->sk_type == SOCK_SEQPACKET) {
> 		if (!new_transport->seqpacket_allow ||
>-		    !new_transport->seqpacket_allow(remote_cid)) {
>+		    !new_transport->seqpacket_allow(vsk, remote_cid)) {
> 			module_put(new_transport->module);
> 			return -ESOCKTNOSUPPORT;
> 		}
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index 163ddfc0808529ad6dda7992f9ec48837dd7337c..60bf3f1f39c51d44768fd2f04df3abee9f966252 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -536,7 +536,7 @@ static bool virtio_transport_msgzerocopy_allow(void)
> 	return true;
> }
>
>-static bool virtio_transport_seqpacket_allow(u32 remote_cid);
>+static bool virtio_transport_seqpacket_allow(struct vsock_sock *vsk, u32 remote_cid);
>
> static struct virtio_transport virtio_transport = {
> 	.transport = {
>@@ -593,7 +593,7 @@ static struct virtio_transport virtio_transport = {
> 	.can_msgzerocopy = virtio_transport_can_msgzerocopy,
> };
>
>-static bool virtio_transport_seqpacket_allow(u32 remote_cid)
>+static bool virtio_transport_seqpacket_allow(struct vsock_sock *vsk, u32 remote_cid)
> {
> 	struct virtio_vsock *vsock;
> 	bool seqpacket_allow;
>diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
>index 6e78927a598e07cf77386a420b9d05d3f491dc7c..1b2fab73e0d0a6c63ed60d29fc837da58f6fb121 100644
>--- a/net/vmw_vsock/vsock_loopback.c
>+++ b/net/vmw_vsock/vsock_loopback.c
>@@ -46,7 +46,7 @@ static int vsock_loopback_cancel_pkt(struct vsock_sock *vsk)
> 	return 0;
> }
>
>-static bool vsock_loopback_seqpacket_allow(u32 remote_cid);
>+static bool vsock_loopback_seqpacket_allow(struct vsock_sock *vsk, u32 remote_cid);
> static bool vsock_loopback_msgzerocopy_allow(void)
> {
> 	return true;
>@@ -106,7 +106,7 @@ static struct virtio_transport loopback_transport = {
> 	.send_pkt = vsock_loopback_send_pkt,
> };
>
>-static bool vsock_loopback_seqpacket_allow(u32 remote_cid)
>+static bool vsock_loopback_seqpacket_allow(struct vsock_sock *vsk, u32 remote_cid)
> {
> 	return true;
> }
>
>-- 
>2.47.1
>


