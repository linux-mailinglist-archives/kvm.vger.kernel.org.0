Return-Path: <kvm+bounces-19674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E47C908CC7
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 15:56:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE9422844DB
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 13:56:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E2CBC8D1;
	Fri, 14 Jun 2024 13:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="QZVf25RY"
X-Original-To: kvm@vger.kernel.org
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03olkn2057.outbound.protection.outlook.com [40.92.59.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4ADD79E1;
	Fri, 14 Jun 2024 13:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.59.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718373358; cv=fail; b=F1y9/lVVSwHe89A2Ff0uN2m7uKkDKIP3nwqOu36vK9cJ+NxvVLL/cCnElAub1qIAHUZhKNRCD07JpFOm5pWvyESK2kT41GkUNNsYpfSSw4IOhnxOGKWiptGOatFcB1eRx/uiU0/SeePOG/T0/PFgbms0vCunjei8NKcv9Jp1TPM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718373358; c=relaxed/simple;
	bh=3Rm3T5SsfVmBTQpujaAghFy9uNS5aqFg+iT0kp0eA3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NiSnG1rrcut6ut3XpIKw+GrBj4ZOfXie/Xhu/wmjD5WPKD6n8nB4QC/fUex35K7gtK0EHoYP/OvCU0wgP+5ivnIkVtQD98Xinb3BRW/BLxRDae/Er0x0LPku7P9JDn5xbi2TQr69qSkmI29eU4TnbET6R836HDTaNZQN2QsnwO8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=QZVf25RY; arc=fail smtp.client-ip=40.92.59.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=luN9FMda+Tf1GEapjHhJX5Db+Z6NqFuQkalIS847Dr3O1kA65Om4Qf9uMnCBodiY0sIzqYsMqF5fvrqneYY6ZcIsni3ncGzzsP1LpIz7+GyFDn3dJN6eIxAyh+PxoYsq8l+rWH+OvLnAtmfCwBD13O9CKD1zqZHbh9EeAl8ZSQ9+Hhc9uJ4T8JzdOJHAqbL7NVVduqQ3FwiTUsjG83StZxle9DHpCzmHecPgZ3vFtnnid47p9g3owWFIZIQvbOSop2B4zM1Rwji8fsNPfmZPJT63okxpZUr9zBMh1X3qOmtFkg3a84nlbgADnsd1NxHVkaKELDh0KVuVUXC9n3fnQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1EHNKKz1qX7AszV1M/va7aczipvP8ulNoEi2BKcm4xk=;
 b=dc/GWq0myc5ELXuajWf7X5KeuM+dVjkOAmCbUBatWLqXmTS1pAHpP5m9VnJzj378qtxA6GwAKCfwk7j5FJUEyUP+JxPmGgSvwVxjHztAVcaNK4ghMNkbJZKXWV974zz9IunmyI25vwHolwjvVHf7WAloblpxLnhuil31sm8dzqpdI6KUSwMPIrNJnMrbyYLcfSIlLgMpBFxeP+SUDz4bAEqfgU0d0m+yZ6Vxo1X/ADea4KLSuMIGkikAcs8sXU7dTSuUv1F8iMAbzUw0qgYojr1t27H8x0AMOam7BzPX0nmJPs1O0rTznlDbrVMkBAvUeyieBvT4rCURbslhsKqbww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1EHNKKz1qX7AszV1M/va7aczipvP8ulNoEi2BKcm4xk=;
 b=QZVf25RY9Iu8HHq5Uu2LWFysVKZbIqiTlHfBS8NUE3UalTgJlfgpE+GJuzV8kGkm8arVjRXwUl0f9yhIB8tKREw+/ndfVHr2+fZ+oPqdOjR983ENIB9JHj6kJsQ/AdRnnC3Vs4NM3gqhDxO1Q/DW0gnXe4B5sj4sNEK0eArs9eO6y0vnlI2+sh4HbVUaWOBE3ZpDHUur1hjgFSln/Id4c2aldJISfQUNZtVwCgPqbJbIDnQkrJLrtrdRzIIRkkBcQfYExiBGetro4UV6+hUuBNzVE3vEdj1u8izONhU8P5CeV8hawpDMOvPhhIEujbVypth5lTmXvTAgsPESlitkdg==
Received: from AS2P194MB2170.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:642::8)
 by PAXP194MB1469.EURP194.PROD.OUTLOOK.COM (2603:10a6:102:1a8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.24; Fri, 14 Jun
 2024 13:55:50 +0000
Received: from AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 ([fe80::3d63:e123:2c2f:c930]) by AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 ([fe80::3d63:e123:2c2f:c930%3]) with mapi id 15.20.7677.024; Fri, 14 Jun 2024
 13:55:50 +0000
From: Luigi Leonardi <luigi.leonardi@outlook.com>
To: sgarzare@redhat.com,
	edumazet@google.com,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	kvm@vger.kernel.org,
	stefanha@redhat.com,
	pabeni@redhat.com,
	davem@davemloft.net
Cc: Marco Pinna <marco.pinn95@gmail.com>,
	Luigi Leonardi <luigi.leonardi@outlook.com>
Subject: [PATCH net-next 1/2] vsock/virtio: refactor virtio_transport_send_pkt_work
Date: Fri, 14 Jun 2024 15:55:42 +0200
Message-ID:
 <AS2P194MB21702C53FEFDC2F8283B5A789AC22@AS2P194MB2170.EURP194.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240614135543.31515-1-luigi.leonardi@outlook.com>
References: <20240614135543.31515-1-luigi.leonardi@outlook.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN: [cNCghYFMJvywD3gy6YkNRs4FzLxH2tBp]
X-ClientProxiedBy: MI0P293CA0015.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:44::8) To AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:20b:642::8)
X-Microsoft-Original-Message-ID:
 <20240614135543.31515-2-luigi.leonardi@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS2P194MB2170:EE_|PAXP194MB1469:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fa704b6-34e9-4a06-4c8f-08dc8c79b356
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|461199025|3412199022|440099025|1710799023;
X-Microsoft-Antispam-Message-Info:
	EiLleIyiDG3SbbW9ozssg7t9Dzbe3pryXXHsFP9g4j75kttud71blyxad0/QEZJdveh81rorF52tQ7iPysExscxKW/pWhmzpR6M1taYfAkBBGF3RaWIhtjnKYSFRKdh/+Uxnlebrcx1JJNwEt13Zu5uTArkS5ihaWKK+QE30cx0gxfrWTCZEv3xONh3CkIaUiUQr+bMYpua4jrGG7473s7+tL+oU1u1ku1EDiOuYcaRJpDWkThwgrxK78qwmDThUJKh7I+c66odQI58xZEh+flZGISRzrFfyV9LpcAM128xz8GcUZRb+3row5TJ0FZpHLp4TmOgqNhRkKLsmt+aUVqR1cY2RqqtdywdHlIDfkR8bSMsTrDaDL4io572ZzE58sLT+YUzhVLFqFyA+HklIpc+LvJwZHV9TK8PSoCph2vwkGgTqxKLTG940NMnSK246aSmssVStyDQPCjSSOc7365ZuB9AbzRign/nBF88EkRMwVsuaTfu+7zJe1yJQEpT1+brjuPDn+bFsACjMiFL7WGxxqklJQFaBWmOqX4DEezi2+2Nq9EvGRCLys37wuKLxVPO7BoB7fOfZtfmkCHKeJBZ/87hTHeuWXI3BE7A7rahH2BZ2NLMtm7ak1myv0RCT
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AXAtbnErXm4uGldTx2r28D4t5yU2MXNbH0rA1tx+EXrJckbi70alhdFDW5QS?=
 =?us-ascii?Q?HhqVhq7I69lC/gbwj/xBjTNWL0qjOPJgmxZ+AShHZCnT5KStcM77U46EKfIO?=
 =?us-ascii?Q?dW0wC7lsCGnKsV8vJKINJBCsgkzdzhSP5Vd1pi3UQo5qBElnK7TpEOuNWJIO?=
 =?us-ascii?Q?gcPPG6HuKj7FU/vJv8ou8meIYpQHbhuc3BviS/7m3kxzuQiNAID6R9l9LwHv?=
 =?us-ascii?Q?aNQwU2+AfNTHKo3u5I1ArmlWM+x+FnYmKBhJnS9KbvwUbbXeDxwEan7AtMj7?=
 =?us-ascii?Q?+uabPMD28XyCCXWAIZnpZiLoohfi4SdWcvb/PuZjWjASZHMRRKTK0vV+c75r?=
 =?us-ascii?Q?EDhcimC7qHfvtwH8V7BsrrPLSRwNccoFaPj5wKbSvyA2DpgD/gGZU7q0RKvn?=
 =?us-ascii?Q?eU+QuDIk87Qms2MaL7eDhss/tCQWjxpxL6rndzaxfrhTbpp7O+zFemkLQiH5?=
 =?us-ascii?Q?Az9xL34mkIWbvrqLVIso8B3LGFXbh0N97+A1EaSZpObiQ3lZQS4L5l+xkDfd?=
 =?us-ascii?Q?YzOJ8WnMvsC9IRZbRM8ZP1OU56tpoIxnQU/pzFY5M5kJlfkDxX8IPEKtA+BQ?=
 =?us-ascii?Q?gwsiaOeIKBiS5RfLw8/IddZbEhl3xTl5/zgFF4lHxT6E0EnJsR+Lu2ai2xJf?=
 =?us-ascii?Q?LHa31rXC5gmXvMD3moaPvZR7/tDfce0bCqN3qGhzZUmM52V7pkyidPT6Cg9o?=
 =?us-ascii?Q?g0sFACMGRMxpma6mjTw7pFjxKCuxJgE73mdFNXFhcm8aL2VMqfhIoK45mYrV?=
 =?us-ascii?Q?sJ2x0SegjzA+kQtjATmfSir3b3b4xrOuqinhOntZqFE8OMINxSm7qcahI2De?=
 =?us-ascii?Q?Q5HxMSjCTzBEu0/alZYTTQe1rPLXPhP/TeugqwGOM3oT0bTu0+j8+Aay5IjL?=
 =?us-ascii?Q?kahBN2I5qLkweU9HG+LuTF77Rpj3IwMn6gruDD96BMPW/OgrZY1YtmaczF9A?=
 =?us-ascii?Q?csbEv41wi0xvqKwwyeLDiMBJTPTiX2Py+px+U8XpMQF8b6C1Fy2mRE3Rym3S?=
 =?us-ascii?Q?UuaNtkjz2a+lqnObWxuJ7Fbx9X67Y0SJIyOhip2e8EnwNw+ZSQAeeCLm14a8?=
 =?us-ascii?Q?Q0zTCtgB3PcX2rNZIjvEkXzlDX0Ad7z0E5N8JRHdpDI2qgWHXHeMwNDQroaI?=
 =?us-ascii?Q?3wyGTPj/bKg3VGKkYDRhgjrUivuJZt3iVxECx+Q8rLtfq27QAUHWmySLmnsm?=
 =?us-ascii?Q?v2duOSKBSyv1wcMtvGbXwgugnpsE1BCtItdl8pBPyb/t1NctdYUfb5HUKP73?=
 =?us-ascii?Q?8hxM/hsu4jaeeTjp+44X?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fa704b6-34e9-4a06-4c8f-08dc8c79b356
X-MS-Exchange-CrossTenant-AuthSource: AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2024 13:55:50.9054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXP194MB1469

From: Marco Pinna <marco.pinn95@gmail.com>

This is a preliminary patch to introduce an optimization to
the enqueue system.

All the code used to enqueue a packet into the virtqueue
is removed from virtio_transport_send_pkt_work()
and moved to the new virtio_transport_send_skb() function.

Co-developed-by: Luigi Leonardi <luigi.leonardi@outlook.com>
Signed-off-by: Luigi Leonardi <luigi.leonardi@outlook.com>
Signed-off-by: Marco Pinna <marco.pinn95@gmail.com>
---
 net/vmw_vsock/virtio_transport.c | 134 +++++++++++++++++--------------
 1 file changed, 74 insertions(+), 60 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 43d405298857..c930235ecaec 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -94,6 +94,78 @@ static u32 virtio_transport_get_local_cid(void)
 	return ret;
 }
 
+/* Caller need to hold vsock->tx_lock on vq */
+static int virtio_transport_send_skb(struct sk_buff *skb, struct virtqueue *vq,
+				     struct virtio_vsock *vsock, bool *restart_rx)
+{
+	int ret, in_sg = 0, out_sg = 0;
+	struct scatterlist **sgs;
+	bool reply;
+
+	reply = virtio_vsock_skb_reply(skb);
+	sgs = vsock->out_sgs;
+	sg_init_one(sgs[out_sg], virtio_vsock_hdr(skb),
+		    sizeof(*virtio_vsock_hdr(skb)));
+	out_sg++;
+
+	if (!skb_is_nonlinear(skb)) {
+		if (skb->len > 0) {
+			sg_init_one(sgs[out_sg], skb->data, skb->len);
+			out_sg++;
+		}
+	} else {
+		struct skb_shared_info *si;
+		int i;
+
+		/* If skb is nonlinear, then its buffer must contain
+		 * only header and nothing more. Data is stored in
+		 * the fragged part.
+		 */
+		WARN_ON_ONCE(skb_headroom(skb) != sizeof(*virtio_vsock_hdr(skb)));
+
+		si = skb_shinfo(skb);
+
+		for (i = 0; i < si->nr_frags; i++) {
+			skb_frag_t *skb_frag = &si->frags[i];
+			void *va;
+
+			/* We will use 'page_to_virt()' for the userspace page
+			 * here, because virtio or dma-mapping layers will call
+			 * 'virt_to_phys()' later to fill the buffer descriptor.
+			 * We don't touch memory at "virtual" address of this page.
+			 */
+			va = page_to_virt(skb_frag_page(skb_frag));
+			sg_init_one(sgs[out_sg],
+				    va + skb_frag_off(skb_frag),
+				    skb_frag_size(skb_frag));
+			out_sg++;
+		}
+	}
+
+	ret = virtqueue_add_sgs(vq, sgs, out_sg, in_sg, skb, GFP_KERNEL);
+	/* Usually this means that there is no more space available in
+	 * the vq
+	 */
+	if (ret < 0)
+		goto out;
+
+	virtio_transport_deliver_tap_pkt(skb);
+
+	if (reply) {
+		struct virtqueue *rx_vq = vsock->vqs[VSOCK_VQ_RX];
+		int val;
+
+		val = atomic_dec_return(&vsock->queued_replies);
+
+		/* Do we now have resources to resume rx processing? */
+		if (val + 1 == virtqueue_get_vring_size(rx_vq))
+			*restart_rx = true;
+	}
+
+out:
+	return ret;
+}
+
 static void
 virtio_transport_send_pkt_work(struct work_struct *work)
 {
@@ -111,77 +183,19 @@ virtio_transport_send_pkt_work(struct work_struct *work)
 	vq = vsock->vqs[VSOCK_VQ_TX];
 
 	for (;;) {
-		int ret, in_sg = 0, out_sg = 0;
-		struct scatterlist **sgs;
 		struct sk_buff *skb;
-		bool reply;
+		int ret;
 
 		skb = virtio_vsock_skb_dequeue(&vsock->send_pkt_queue);
 		if (!skb)
 			break;
 
-		reply = virtio_vsock_skb_reply(skb);
-		sgs = vsock->out_sgs;
-		sg_init_one(sgs[out_sg], virtio_vsock_hdr(skb),
-			    sizeof(*virtio_vsock_hdr(skb)));
-		out_sg++;
-
-		if (!skb_is_nonlinear(skb)) {
-			if (skb->len > 0) {
-				sg_init_one(sgs[out_sg], skb->data, skb->len);
-				out_sg++;
-			}
-		} else {
-			struct skb_shared_info *si;
-			int i;
+		ret = virtio_transport_send_skb(skb, vq, vsock, &restart_rx);
 
-			/* If skb is nonlinear, then its buffer must contain
-			 * only header and nothing more. Data is stored in
-			 * the fragged part.
-			 */
-			WARN_ON_ONCE(skb_headroom(skb) != sizeof(*virtio_vsock_hdr(skb)));
-
-			si = skb_shinfo(skb);
-
-			for (i = 0; i < si->nr_frags; i++) {
-				skb_frag_t *skb_frag = &si->frags[i];
-				void *va;
-
-				/* We will use 'page_to_virt()' for the userspace page
-				 * here, because virtio or dma-mapping layers will call
-				 * 'virt_to_phys()' later to fill the buffer descriptor.
-				 * We don't touch memory at "virtual" address of this page.
-				 */
-				va = page_to_virt(skb_frag_page(skb_frag));
-				sg_init_one(sgs[out_sg],
-					    va + skb_frag_off(skb_frag),
-					    skb_frag_size(skb_frag));
-				out_sg++;
-			}
-		}
-
-		ret = virtqueue_add_sgs(vq, sgs, out_sg, in_sg, skb, GFP_KERNEL);
-		/* Usually this means that there is no more space available in
-		 * the vq
-		 */
 		if (ret < 0) {
 			virtio_vsock_skb_queue_head(&vsock->send_pkt_queue, skb);
 			break;
 		}
-
-		virtio_transport_deliver_tap_pkt(skb);
-
-		if (reply) {
-			struct virtqueue *rx_vq = vsock->vqs[VSOCK_VQ_RX];
-			int val;
-
-			val = atomic_dec_return(&vsock->queued_replies);
-
-			/* Do we now have resources to resume rx processing? */
-			if (val + 1 == virtqueue_get_vring_size(rx_vq))
-				restart_rx = true;
-		}
-
 		added = true;
 	}
 
-- 
2.45.2


