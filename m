Return-Path: <kvm+bounces-72356-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8GgEJaxqpWkaAQYAu9opvQ
	(envelope-from <kvm+bounces-72356-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 11:47:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 009A61D6C8E
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 11:47:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 19269305DECD
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 10:41:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A833E338593;
	Mon,  2 Mar 2026 10:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="hfCFGuyd"
X-Original-To: kvm@vger.kernel.org
Received: from pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.245.243.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDDB22E8B6B;
	Mon,  2 Mar 2026 10:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.245.243.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772448109; cv=none; b=HKFmgGKu5hNRCh07iOSKTahL1FHD0l07WQN4C2xkxLW1+MfTAgVNK6d6Ax77I8P8zoCURw9hyF0No+8bfyKKHdF7/hJwT5puY19Jpc1Fn1+/VwWlV3lPd6w/prxZVWsYA8A/8FtO0AXYC5oNJ3bTSR6j70f3sgJzM+XyMTaRO2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772448109; c=relaxed/simple;
	bh=tssolyZ/YJCfV3/umAHfzNxVcIF+e27Ql8ibnVvdcIQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=j7iU7Z8ebOfDWwTrlF8Ocd7kGxeq7yf75I178FFnosZ3I+Kppyw9ihCyo95V7SUnaZkaciAEHnqliZGAQkbLV2gbeIvgQO7wFU9g/5756YrfU369UaNZ8se2TyWoab9a1KrhLdUH5AIqiHRI+Rwn7NfJbyOt07YPTFhPbD1S7bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=hfCFGuyd; arc=none smtp.client-ip=44.245.243.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1772448107; x=1803984107;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TCNz9HmwgZYgQfhhE1VoK/ya6x9J13TYyDFYQ1fU77U=;
  b=hfCFGuydtwSydaRnlGcTEAEc9PjJ6ZF+AJzRhmfh5Q065/LntOcRXdXk
   ArJ7u+P1QjFmY5SydQarm5S+lkcZprbZQIH4u1e5Ov9jri5dT3lN1IBJ+
   exj5AyeBtumj3ktJeiTv2IASPkwK3qz6PGQJgAoeDVQQH2Bu3bQnvhpvT
   mHKtWhDnjyQSBAiQ2ARmnho3dGsWzbNs91dlaD6tNJ7WQvonF6z0SU1CI
   Ittz5XSpOzrvXcCWe6U/m19pjLKp/eqtmrgEt0MLDTT9UcRee6ypiS4O7
   LSQyqzxVhiMIzTaVVchdBrSUjHVuXqCnCARreDKewQgfABXstU4LHjC9x
   w==;
X-CSE-ConnectionGUID: ZM/7z7dpRBet+6eK5lCQmw==
X-CSE-MsgGUID: EFzeNHdLR3eeejuf50Cq2Q==
X-IronPort-AV: E=Sophos;i="6.21,319,1763424000"; 
   d="scan'208";a="13621734"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 10:41:45 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.48:14150]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.51.143:2525] with esmtp (Farcaster)
 id ea3ba174-8803-4d35-8e59-505ad1c706ad; Mon, 2 Mar 2026 10:41:45 +0000 (UTC)
X-Farcaster-Flow-ID: ea3ba174-8803-4d35-8e59-505ad1c706ad
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Mon, 2 Mar 2026 10:41:42 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D020UWC004.ant.amazon.com (10.13.138.149) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Mon, 2 Mar 2026 10:41:40 +0000
From: Alexander Graf <graf@amazon.com>
To: <virtualization@lists.linux.dev>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
	<kvm@vger.kernel.org>, <eperezma@redhat.com>, Jason Wang
	<jasowang@redhat.com>, <mst@redhat.com>, Stefano Garzarella
	<sgarzare@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
	<nh-open-source@amazon.com>
Subject: [PATCH] vsock: Enable H2G override
Date: Mon, 2 Mar 2026 10:41:38 +0000
Message-ID: <20260302104138.77555-1-graf@amazon.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D037UWB002.ant.amazon.com (10.13.138.121) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-8.16 / 15.00];
	WHITELIST_DMARC(-7.00)[amazon.com:D:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[amazon.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[amazon.com:s=amazoncorp2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[amazon.com:+];
	TAGGED_FROM(0.00)[bounces-72356-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[graf@amazon.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 009A61D6C8E
X-Rspamd-Action: no action

Vsock maintains a single CID number space which can be used to
communicate to the host (G2H) or to a child-VM (H2G). The current logic
trivially assumes that G2H is only relevant for CID <= 2 because these
target the hypervisor.  However, in environments like Nitro Enclaves, an
instance that hosts vhost_vsock powered VMs may still want to communicate
to Enclaves that are reachable at higher CIDs through virtio-vsock-pci.

That means that for CID > 2, we really want an overlay. By default, all
CIDs are owned by the hypervisor. But if vhost registers a CID, it takes
precedence.  Implement that logic. Vhost already knows which CIDs it
supports anyway.

With this logic, I can run a Nitro Enclave as well as a nested VM with
vhost-vsock support in parallel, with the parent instance able to
communicate to both simultaneously.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 drivers/vhost/vsock.c    | 11 +++++++++++
 include/net/af_vsock.h   |  3 +++
 net/vmw_vsock/af_vsock.c |  3 +++
 3 files changed, 17 insertions(+)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 054f7a718f50..223da817e305 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -91,6 +91,16 @@ static struct vhost_vsock *vhost_vsock_get(u32 guest_cid, struct net *net)
 	return NULL;
 }
 
+static bool vhost_transport_has_cid(u32 cid)
+{
+	bool found;
+
+	rcu_read_lock();
+	found = vhost_vsock_get(cid) != NULL;
+	rcu_read_unlock();
+	return found;
+}
+
 static void
 vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 			    struct vhost_virtqueue *vq)
@@ -424,6 +434,7 @@ static struct virtio_transport vhost_transport = {
 		.module                   = THIS_MODULE,
 
 		.get_local_cid            = vhost_transport_get_local_cid,
+		.has_cid                  = vhost_transport_has_cid,
 
 		.init                     = virtio_transport_do_socket_init,
 		.destruct                 = virtio_transport_destruct,
diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 533d8e75f7bb..4cdcb72f9765 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -179,6 +179,9 @@ struct vsock_transport {
 	/* Addressing. */
 	u32 (*get_local_cid)(void);
 
+	/* Check if this transport serves a specific remote CID. */
+	bool (*has_cid)(u32 cid);
+
 	/* Read a single skb */
 	int (*read_skb)(struct vsock_sock *, skb_read_actor_t);
 
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 2f7d94d682cb..8b34b264b246 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -584,6 +584,9 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 		else if (remote_cid <= VMADDR_CID_HOST || !transport_h2g ||
 			 (remote_flags & VMADDR_FLAG_TO_HOST))
 			new_transport = transport_g2h;
+		else if (transport_h2g->has_cid &&
+			 !transport_h2g->has_cid(remote_cid))
+			new_transport = transport_g2h;
 		else
 			new_transport = transport_h2g;
 		break;
-- 
2.47.1




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


