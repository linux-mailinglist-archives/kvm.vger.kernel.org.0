Return-Path: <kvm+bounces-72410-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kOvhOODppWlLHwAAu9opvQ
	(envelope-from <kvm+bounces-72410-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 20:49:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 873701DEF5C
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 20:49:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 73678302B1BB
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 19:49:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 339CD3148A3;
	Mon,  2 Mar 2026 19:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="TxORmDP8"
X-Original-To: kvm@vger.kernel.org
Received: from pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com [50.112.246.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0080383C62;
	Mon,  2 Mar 2026 19:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=50.112.246.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772480978; cv=none; b=JtP6mqv9IT8XYUgGwpTWBMSQTEbjRWIxEwEuHmOy9KAEhdLgo+r0iVQmZ7pG8RAbMaf5Xh5yk5QseoCYx6kG/W0I4SQ0oTdewg81kojyVMVTOS/V22NirFzCqAYgAdvsJTuH5nSfMYeOZQ+wLoY2OSyjVRsBkmng01Niz+xJTO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772480978; c=relaxed/simple;
	bh=WiSxv/TKMJU5DJahutbbNGS7VSVb7/CJDR9Kcst96Sk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=eNWTdbHkMLtPmwby2vul8LJ5DWS28iA4r25wdrFig6i88XLdP+drOtrPYqkxJvPDUUO+geNTjN3VXXLJD4GIxGNxBXgD2C0YBfS/gnWWFNV1r5rcB3bexkNrdfxvwCgGCRbqtEVitM1Wo6MY7e/hBPyO3vjdyETmQDJLNmFDAdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=TxORmDP8; arc=none smtp.client-ip=50.112.246.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1772480975; x=1804016975;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=2hIWN0XMNcMveKwVAeKjx3iKzKG8zDmeJiQxa0otfT8=;
  b=TxORmDP8lhD66socQ3YeMCn/Lqxnmnrvug7ArPvOFi90U/PNCKsN4cVP
   xdy06Gsc9r6mUwOywRSsUDNkIhXC4eUnEPC6ExYowjlKeMm4UTmoJyPme
   sg03ubkicGSojGQZpsUpIbZlLQL0rRbiqugLdxAUDyk/gRhx96dDKHRYg
   P84OS8ymke5ua7t8ZovTUueFz6sKQ6grs2DuKPqJlbnogrA6cBtI+MiQ7
   IoKJE3udVw9wSa27BdgPMy7QB1aPvHCNoR4EvaVsaihGMu79T7ksMAkNz
   rx/qpO691fb8NV7VEA/NCmceoRsC/MJDrfS1vXePKPc+ACGuQ5/wbNKIK
   A==;
X-CSE-ConnectionGUID: GwA4xchQSZWOh81XFpmjWQ==
X-CSE-MsgGUID: MTqTqpAfRN2ZuaUAtz3iag==
X-IronPort-AV: E=Sophos;i="6.21,320,1763424000"; 
   d="scan'208";a="13949663"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 19:49:31 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.48:5148]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.6.153:2525] with esmtp (Farcaster)
 id e8d4cbcd-eda0-47f0-9474-e04710febe93; Mon, 2 Mar 2026 19:49:31 +0000 (UTC)
X-Farcaster-Flow-ID: e8d4cbcd-eda0-47f0-9474-e04710febe93
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Mon, 2 Mar 2026 19:49:30 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D020UWC004.ant.amazon.com (10.13.138.149) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Mon, 2 Mar 2026 19:49:27 +0000
From: Alexander Graf <graf@amazon.com>
To: <virtualization@lists.linux.dev>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
	<kvm@vger.kernel.org>, <eperezma@redhat.com>, Jason Wang
	<jasowang@redhat.com>, <mst@redhat.com>, Stefano Garzarella
	<sgarzare@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
	<bcm-kernel-feedback-list@broadcom.com>, Arnd Bergmann <arnd@arndb.de>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, Jonathan Corbet
	<corbet@lwn.net>, Bryan Tan <bryan-bt.tan@broadcom.com>, Vishnu Dasa
	<vishnu.dasa@broadcom.com>, <nh-open-source@amazon.com>
Subject: [PATCH v2] vsock: add G2H fallback for CIDs not owned by H2G transport
Date: Mon, 2 Mar 2026 19:49:26 +0000
Message-ID: <20260302194926.90378-1-graf@amazon.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D040UWB002.ant.amazon.com (10.13.138.89) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 873701DEF5C
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-8.16 / 15.00];
	WHITELIST_DMARC(-7.00)[amazon.com:D:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[amazon.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[amazon.com:s=amazoncorp2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72410-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[graf@amazon.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[amazon.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Action: no action

Vsock maintains a single CID number space which can be used to
communicate to the host (G2H) or to a child-VM (H2G). The current logic
assumes that G2H is only relevant for CID <= 2 because these target the
hypervisor. However, in environments like Nitro Enclaves, an instance
that hosts vhost_vsock powered VMs may still want to communicate to
Enclaves that are reachable at higher CIDs through virtio-vsock-pci.

Vsock introduced VMADDR_FLAG_TO_HOST to allow user space applications
to clearly express a desire to talk to the host instead of a guest via
the passed target CID. However, users may not actually know which one
they want to talk to and the application ecosystem has not picked up a
way for users to specify that desire.

Instead, make it easy for users and introduce a G2H fallback mechanism:
when user space attempts to connect to a CID and the H2G transport
(vhost-vsock / VMCI) does not own it, automatically route the connection
through the G2H transport. This provides a single unified CID address
space where vhost-registered CIDs go to nested VMs and all other CIDs
are routed to the hypervisor.

To give user space at least a hint that the kernel applied this logic,
automatically set the VMADDR_FLAG_TO_HOST on the remote address so it
can determine the path taken via getpeername().

To force the system back into old behavior, provide a sysctl
(net.vsock.g2h_fallback, defaults to 1).

Signed-off-by: Alexander Graf <graf@amazon.com>

---

v1 -> v2:

  - Rebase on 7.0, include namespace support
  - Add net.vsock.g2h_fallback sysctl
  - Rework description
  - Set VMADDR_FLAG_TO_HOST automatically
  - Add VMCI support
  - Update vsock_assign_transport() comment
---
 Documentation/admin-guide/sysctl/net.rst | 22 ++++++++++++++++++++++
 drivers/misc/vmw_vmci/vmci_context.c     |  1 +
 drivers/vhost/vsock.c                    | 13 +++++++++++++
 include/linux/vmw_vmci_api.h             |  1 +
 include/net/af_vsock.h                   |  3 +++
 net/vmw_vsock/af_vsock.c                 | 20 +++++++++++++++++++-
 net/vmw_vsock/vmci_transport.c           |  6 ++++++
 7 files changed, 65 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
index 3b2ad61995d4..cc364baa9021 100644
--- a/Documentation/admin-guide/sysctl/net.rst
+++ b/Documentation/admin-guide/sysctl/net.rst
@@ -602,3 +602,25 @@ it does not modify the current namespace or any existing children.
 
 A namespace with ``ns_mode`` set to ``local`` cannot change
 ``child_ns_mode`` to ``global`` (returns ``-EPERM``).
+
+g2h_fallback
+------------
+
+Controls whether connections to CIDs not owned by the host-to-guest (H2G)
+transport automatically fall back to the guest-to-host (G2H) transport.
+
+When enabled, if a connect targets a CID that the H2G transport (e.g.
+vhost-vsock) does not serve, the connection is routed via the G2H transport
+(e.g. virtio-vsock) instead. This allows a host running both nested VMs
+(via vhost-vsock) and sibling VMs reachable through the hypervisor (e.g.
+Nitro Enclaves) to address both using a single CID space, without requiring
+applications to set ``VMADDR_FLAG_TO_HOST``.
+
+When the fallback is taken, ``VMADDR_FLAG_TO_HOST`` is automatically set on
+the remote address so that userspace can determine the path via
+``getpeername()``.
+
+Values:
+
+	- 0 - Connections to CIDs < 3 get handled by G2H, others by H2G.
+	- 1 - Connections to CIDs not owned by H2G fall back to G2H. (default)
diff --git a/drivers/misc/vmw_vmci/vmci_context.c b/drivers/misc/vmw_vmci/vmci_context.c
index 19ca00feed6e..577296784df5 100644
--- a/drivers/misc/vmw_vmci/vmci_context.c
+++ b/drivers/misc/vmw_vmci/vmci_context.c
@@ -364,6 +364,7 @@ bool vmci_ctx_exists(u32 cid)
 	rcu_read_unlock();
 	return exists;
 }
+EXPORT_SYMBOL_GPL(vmci_ctx_exists);
 
 /*
  * Retrieves VMCI context corresponding to the given cid.
diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 054f7a718f50..319e3a690108 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -91,6 +91,18 @@ static struct vhost_vsock *vhost_vsock_get(u32 guest_cid, struct net *net)
 	return NULL;
 }
 
+static bool vhost_transport_has_remote_cid(struct vsock_sock *vsk, u32 cid)
+{
+	struct sock *sk = sk_vsock(vsk);
+	struct net *net = sock_net(sk);
+	bool found;
+
+	rcu_read_lock();
+	found = vhost_vsock_get(cid, net) != NULL;
+	rcu_read_unlock();
+	return found;
+}
+
 static void
 vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 			    struct vhost_virtqueue *vq)
@@ -424,6 +436,7 @@ static struct virtio_transport vhost_transport = {
 		.module                   = THIS_MODULE,
 
 		.get_local_cid            = vhost_transport_get_local_cid,
+		.has_remote_cid           = vhost_transport_has_remote_cid,
 
 		.init                     = virtio_transport_do_socket_init,
 		.destruct                 = virtio_transport_destruct,
diff --git a/include/linux/vmw_vmci_api.h b/include/linux/vmw_vmci_api.h
index 41764a684423..c412d17c572f 100644
--- a/include/linux/vmw_vmci_api.h
+++ b/include/linux/vmw_vmci_api.h
@@ -37,6 +37,7 @@ int vmci_doorbell_create(struct vmci_handle *handle, u32 flags,
 int vmci_doorbell_destroy(struct vmci_handle handle);
 u32 vmci_get_context_id(void);
 bool vmci_is_context_owner(u32 context_id, kuid_t uid);
+bool vmci_ctx_exists(u32 cid);
 int vmci_register_vsock_callback(vmci_vsock_cb callback);
 
 int vmci_event_subscribe(u32 event,
diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 533d8e75f7bb..0aeb25642827 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -179,6 +179,9 @@ struct vsock_transport {
 	/* Addressing. */
 	u32 (*get_local_cid)(void);
 
+	/* Check if this transport serves a specific remote CID. */
+	bool (*has_remote_cid)(struct vsock_sock *vsk, u32 remote_cid);
+
 	/* Read a single skb */
 	int (*read_skb)(struct vsock_sock *, skb_read_actor_t);
 
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 2f7d94d682cb..b41bc734d6c0 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -210,6 +210,8 @@ static const struct vsock_transport *transport_dgram;
 static const struct vsock_transport *transport_local;
 static DEFINE_MUTEX(vsock_register_mutex);
 
+static int vsock_g2h_fallback = 1;
+
 /**** UTILS ****/
 
 /* Each bound VSocket is stored in the bind hash table and each connected
@@ -547,7 +549,8 @@ static void vsock_deassign_transport(struct vsock_sock *vsk)
  *    g2h is not loaded, will use local transport;
  *  - remote CID <= VMADDR_CID_HOST or h2g is not loaded or remote flags field
  *    includes VMADDR_FLAG_TO_HOST flag value, will use guest->host transport;
- *  - remote CID > VMADDR_CID_HOST will use host->guest transport;
+ *  - remote CID > VMADDR_CID_HOST will use host->guest transport if h2g has
+ *    registered that CID, otherwise will use guest->host transport (overlay);
  */
 int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 {
@@ -584,6 +587,12 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 		else if (remote_cid <= VMADDR_CID_HOST || !transport_h2g ||
 			 (remote_flags & VMADDR_FLAG_TO_HOST))
 			new_transport = transport_g2h;
+		else if (vsock_g2h_fallback &&
+			 transport_h2g->has_remote_cid &&
+			 !transport_h2g->has_remote_cid(vsk, remote_cid)) {
+			vsk->remote_addr.svm_flags |= VMADDR_FLAG_TO_HOST;
+			new_transport = transport_g2h;
+		}
 		else
 			new_transport = transport_h2g;
 		break;
@@ -2879,6 +2888,15 @@ static struct ctl_table vsock_table[] = {
 		.mode		= 0644,
 		.proc_handler	= vsock_net_child_mode_string
 	},
+	{
+		.procname	= "g2h_fallback",
+		.data		= &vsock_g2h_fallback,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
 };
 
 static int __net_init vsock_sysctl_register(struct net *net)
diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index 4296ca1183f1..de3dff52c566 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -2045,6 +2045,11 @@ static u32 vmci_transport_get_local_cid(void)
 	return vmci_get_context_id();
 }
 
+static bool vmci_transport_has_remote_cid(struct vsock_sock *vsk, u32 cid)
+{
+	return vmci_ctx_exists(cid);
+}
+
 static struct vsock_transport vmci_transport = {
 	.module = THIS_MODULE,
 	.init = vmci_transport_socket_init,
@@ -2074,6 +2079,7 @@ static struct vsock_transport vmci_transport = {
 	.notify_send_post_enqueue = vmci_transport_notify_send_post_enqueue,
 	.shutdown = vmci_transport_shutdown,
 	.get_local_cid = vmci_transport_get_local_cid,
+	.has_remote_cid = vmci_transport_has_remote_cid,
 };
 
 static bool vmci_check_transport(struct vsock_sock *vsk)
-- 
2.47.1




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


