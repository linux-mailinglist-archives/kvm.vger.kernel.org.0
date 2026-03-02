Return-Path: <kvm+bounces-72360-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +ItABHN9pWm6CAYAu9opvQ
	(envelope-from <kvm+bounces-72360-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 13:07:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7926B1D8144
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 13:07:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 99CAD302E85A
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 12:07:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E4D63644D5;
	Mon,  2 Mar 2026 12:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VVK1wmv3";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="GrjthJuR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8599D363C66
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 12:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772453221; cv=none; b=JrLlsO5EC5tLl61F6iBOlcCB86jnMqcR2HD3xqDBpNgu23jX48LXh9vjCd0gaLHR6NUgsOZNK/Ib0+Dyzu72EdWAd0kOYg9nqlJg87zwpcSLJHiFffBIYsVZ4Bb9Ow6rD0thezqsoWlvmxAN8MNKEEx0d7OZ/YIYoBTlrr1lDCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772453221; c=relaxed/simple;
	bh=hWo99dcPxR938udacUcF8OjqE0Ne+a/dIWKnSWa/bFk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O5UIRNG1K4caHrH0iJtC3BV0VnmfNzjahW+cGf6CROh1iLKfoRDnTmp43IpwhaE01zDSo5pwnMgc41DFjZLF8z/RhvSZQb5dEjDRO+jhFFFk1HLcptsh4uvv2zKWm+2yb6D6RZ9EhwITccQ6uLhfmAnXlQxeAs+oJi6A6FSwCGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VVK1wmv3; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=GrjthJuR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772453219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wY6cGgZtSvQ1tBML++SvZaka9Xv+OGOyQzuRqjlOQ6U=;
	b=VVK1wmv3rEF5xO5gSUFsYU2+gmAE0DSEnPYibrgXepYU0STjrBd3uyByvg7g92GBmPWHc0
	rm+G+xV4UnlCw//SE4zL8hFWOpLUN0aWS5Q3ZosDTOfna0pSaHe2thZkVmg/XTz4OIVmKx
	xuanuqfqYPIwRKmEbCgKSuUa5/MFew4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-683-vut363-_MFu57eLOMInEEA-1; Mon, 02 Mar 2026 07:06:58 -0500
X-MC-Unique: vut363-_MFu57eLOMInEEA-1
X-Mimecast-MFC-AGG-ID: vut363-_MFu57eLOMInEEA_1772453217
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-483101623e9so41125515e9.3
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 04:06:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772453217; x=1773058017; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wY6cGgZtSvQ1tBML++SvZaka9Xv+OGOyQzuRqjlOQ6U=;
        b=GrjthJuR0Dt7nQATeVnjWK4ecJDZB6tKfMBreLcb1s3svxzNK8SRLr8ji46/rcCPLr
         1KLEbeS6T8cYMFOlRQb7j0M8FrDQTtCfIaNYFP3/WUeap5CBFsG5bHpfYz+NPSbAdZkC
         hIqHWX2HqQpEqYa9DzEnEu1Of8BIlJTJMVke3QzR+t/2S+jewS80/MkMCOd4ByjneaDV
         IR/hHK7biN023PXXwbuvDxlOifkqofB5aDJnuAab1JGmaIN61yBGk3bNTI49wH1fHCe/
         mxbqxKw8PFsB+db9XfjdivszKFkV675RB0+4CZ8Dwxu2B4ziQ03CeVVezQMXKy65V98c
         z3yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772453217; x=1773058017;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wY6cGgZtSvQ1tBML++SvZaka9Xv+OGOyQzuRqjlOQ6U=;
        b=GipvZ97dBuGaGj4NxSoUseZji+LBdb9cCpJUd1T2B/D4G44Svr3vAChkjqLbkpJ76T
         WxPhFZCWTQFqI46YWyoiGBQ2tuEZQlkJ3Cu7CqPe+RZYfUCjjHtDK2WT3xtNcC1NvXAX
         +q9qFzGTHPiMptD8R/t2j9y+AKrUAQO/riwjrbD5K71SHy82hwITUXSdT3n02ZjGCnu/
         aBxwzVv6M7py+x8wIduenMaxriV3Ar9dmCea/0/5/3C/88LchLoTV2eaZqFoEKeD2bRq
         gzQBowe0IwI0T8+4GxCY+r+LOoZiS2tzDrIkeMPnv3Lscr1Y+jfQKsqqY+PlJEHgPtC/
         iIqQ==
X-Forwarded-Encrypted: i=1; AJvYcCXD2Z4hp7pgeOpKCPmkAs0jV6YW6X53au8w8S7LS5UjjB4NUmxa1LXeB1sF62ieKmxLKVQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyhV+TlQd5hjKI9AkqftknJbaKFlO8mw4Fhg9hfM1d0RRplf4/k
	FzAJjk8k8GhLSZlYW/AdE+yLD8acn7hIBKEwIBNxd5VOtILxnykgx09KBWsql5lUBvwvc93C+KY
	hs5Zc9rvnBmqidZlvKJaIiWKcWvRQGGO9mpul1wErVkQrNkX0TNY0mg==
X-Gm-Gg: ATEYQzxaUv2FRNTgV2LyHil6KnSsr42EJ5zhMfiXp+ojX+1EaQFIcPu51WzCa4nE887
	1rMVNAwhF2BZ4X6ctmG2RVSpfsFNIu0aP1XgHRoDBYk1WaL30cJAd5meGBkX16uQz119dTSPJMt
	YfwxpGM6xjAtK4CNo2Dlhdr7ju5wKCGuX65rBlwiXrKrSWi5KNIHohfq5Pokvvmlqz/spys3ay1
	HG5t5LCqPqMQnNSwuRuboXeZ14BcwbIQeS75lVgMFsRp4FC9rHdWkBuArOF49jO34tB/NM7LexD
	sCUDOnYxKa4z5T8+99W3WMdL/ObfEuorMn6f2gQL4ncgW0Np45qZy7yxjtRzETHzZL7mrwQlGdl
	kAzx/mcv/9M9mjgFIpeOUQM1HDCcfmvWAzVVq89p2WBiCXso6+HGP6fEliJjB/DG3/DBvmeg=
X-Received: by 2002:a05:600c:5249:b0:477:7c7d:d9b2 with SMTP id 5b1f17b1804b1-483c9c29b56mr197779625e9.32.1772453217034;
        Mon, 02 Mar 2026 04:06:57 -0800 (PST)
X-Received: by 2002:a05:600c:5249:b0:477:7c7d:d9b2 with SMTP id 5b1f17b1804b1-483c9c29b56mr197778995e9.32.1772453216431;
        Mon, 02 Mar 2026 04:06:56 -0800 (PST)
Received: from sgarzare-redhat (host-82-53-134-58.retail.telecomitalia.it. [82.53.134.58])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bfb2c5a8sm194215805e9.0.2026.03.02.04.06.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 04:06:55 -0800 (PST)
Date: Mon, 2 Mar 2026 13:06:51 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Alexander Graf <graf@amazon.com>, 
	Bryan Tan <bryan-bt.tan@broadcom.com>, Vishnu Dasa <vishnu.dasa@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
Cc: virtualization@lists.linux.dev, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, kvm@vger.kernel.org, eperezma@redhat.com, 
	Jason Wang <jasowang@redhat.com>, mst@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>, 
	nh-open-source@amazon.com
Subject: Re: [PATCH] vsock: Enable H2G override
Message-ID: <aaV80wWlpjEtYCQJ@sgarzare-redhat>
References: <20260302104138.77555-1-graf@amazon.com>
 <aaVrsXMmULivV4Se@sgarzare-redhat>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aaVrsXMmULivV4Se@sgarzare-redhat>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72360-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sgarzare@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7926B1D8144
X-Rspamd-Action: no action

CCing Bryan, Vishnu, and Broadcom list.

On Mon, Mar 02, 2026 at 12:47:05PM +0100, Stefano Garzarella wrote:
>
>Please target net-next tree for this new feature.
>
>On Mon, Mar 02, 2026 at 10:41:38AM +0000, Alexander Graf wrote:
>>Vsock maintains a single CID number space which can be used to
>>communicate to the host (G2H) or to a child-VM (H2G). The current logic
>>trivially assumes that G2H is only relevant for CID <= 2 because these
>>target the hypervisor.  However, in environments like Nitro Enclaves, an
>>instance that hosts vhost_vsock powered VMs may still want to communicate
>>to Enclaves that are reachable at higher CIDs through virtio-vsock-pci.
>>
>>That means that for CID > 2, we really want an overlay. By default, all
>>CIDs are owned by the hypervisor. But if vhost registers a CID, it takes
>>precedence.  Implement that logic. Vhost already knows which CIDs it
>>supports anyway.
>>
>>With this logic, I can run a Nitro Enclave as well as a nested VM with
>>vhost-vsock support in parallel, with the parent instance able to
>>communicate to both simultaneously.
>
>I honestly don't understand why VMADDR_FLAG_TO_HOST (added 
>specifically for Nitro IIRC) isn't enough for this scenario and we 
>have to add this change.  Can you elaborate a bit more about the 
>relationship between this change and VMADDR_FLAG_TO_HOST we added?
>
>>
>>Signed-off-by: Alexander Graf <graf@amazon.com>
>>---
>>drivers/vhost/vsock.c    | 11 +++++++++++
>>include/net/af_vsock.h   |  3 +++
>>net/vmw_vsock/af_vsock.c |  3 +++
>>3 files changed, 17 insertions(+)
>>
>>diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>>index 054f7a718f50..223da817e305 100644
>>--- a/drivers/vhost/vsock.c
>>+++ b/drivers/vhost/vsock.c
>>@@ -91,6 +91,16 @@ static struct vhost_vsock *vhost_vsock_get(u32 guest_cid, struct net *net)
>>	return NULL;
>>}
>>
>>+static bool vhost_transport_has_cid(u32 cid)
>>+{
>>+	bool found;
>>+
>>+	rcu_read_lock();
>>+	found = vhost_vsock_get(cid) != NULL;
>
>We recently added namespaces support that changed vhost_vsock_get() 
>params. This is also in net tree now and in Linus' tree, so not sure 
>where this patch is based, but this needs to be rebased since it is 
>not building:
>
>../drivers/vhost/vsock.c: In function ‘vhost_transport_has_cid’:
>../drivers/vhost/vsock.c:99:17: error: too few arguments to function ‘vhost_vsock_get’; expected 2, have 1
>   99 |         found = vhost_vsock_get(cid) != NULL;
>      |                 ^~~~~~~~~~~~~~~
>../drivers/vhost/vsock.c:74:28: note: declared here
>   74 | static struct vhost_vsock *vhost_vsock_get(u32 guest_cid, struct net *net)
>      |
>
>>+	rcu_read_unlock();
>>+	return found;
>>+}
>>+
>>static void
>>vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
>>			    struct vhost_virtqueue *vq)
>>@@ -424,6 +434,7 @@ static struct virtio_transport vhost_transport = {
>>		.module                   = THIS_MODULE,
>>
>>		.get_local_cid            = vhost_transport_get_local_cid,
>>+		.has_cid                  = vhost_transport_has_cid,
>>
>>		.init                     = virtio_transport_do_socket_init,
>>		.destruct                 = virtio_transport_destruct,
>>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>>index 533d8e75f7bb..4cdcb72f9765 100644
>>--- a/include/net/af_vsock.h
>>+++ b/include/net/af_vsock.h
>>@@ -179,6 +179,9 @@ struct vsock_transport {
>>	/* Addressing. */
>>	u32 (*get_local_cid)(void);
>>
>>+	/* Check if this transport serves a specific remote CID. */
>>+	bool (*has_cid)(u32 cid);
>
>What about "has_remote_cid" ?
>
>>+
>>	/* Read a single skb */
>>	int (*read_skb)(struct vsock_sock *, skb_read_actor_t);
>>
>>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>>index 2f7d94d682cb..8b34b264b246 100644
>>--- a/net/vmw_vsock/af_vsock.c
>>+++ b/net/vmw_vsock/af_vsock.c
>>@@ -584,6 +584,9 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
>>		else if (remote_cid <= VMADDR_CID_HOST || !transport_h2g ||
>>			 (remote_flags & VMADDR_FLAG_TO_HOST))
>>			new_transport = transport_g2h;
>>+		else if (transport_h2g->has_cid &&
>>+			 !transport_h2g->has_cid(remote_cid))
>>+			new_transport = transport_g2h;
>
>We should update the comment on top of this fuction, and maybe also 
>try to support the other H2G transport (i.e. VMCI).
>
>@Bryan @Vishnu can the new has_cid()/has_remote_cid() be supported by 
>VMCI too?

Oops, I forgot to CC them, now they should be in copy.

Stefano


>
>
>
>I have a question: until now, transport assignment was based simply on 
>analyzing local socket information (vsk->remote_addr), but now we are 
>also adding the status of other components (e.g., VMs that have 
>started and registered the CID in vhost-vsock).
>
>Could this produce strange behavior?
>For example, two sockets with the same remote_addr communicate with 
>the host or with the guest depending on whether or not the VM existed 
>when they were created.
>
>Thanks,
>Stefano
>
>>		else
>>			new_transport = transport_h2g;
>>		break;
>>-- 
>>2.47.1
>>
>>
>>
>>
>>Amazon Web Services Development Center Germany GmbH
>>Tamara-Danz-Str. 13
>>10243 Berlin
>>Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
>>Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
>>Sitz: Berlin
>>Ust-ID: DE 365 538 597
>>
>>


