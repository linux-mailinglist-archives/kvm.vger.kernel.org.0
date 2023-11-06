Return-Path: <kvm+bounces-772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4559B7E2711
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 15:36:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 76E1F1C20C2F
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 14:36:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73B5729408;
	Mon,  6 Nov 2023 14:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5F728E27
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 14:36:16 +0000 (UTC)
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1781BB
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 06:36:14 -0800 (PST)
X-IronPort-AV: E=Sophos;i="6.03,281,1694736000"; 
   d="scan'208";a="366329806"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-b538c141.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2023 14:36:14 +0000
Received: from smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev (iad7-ws-svc-p70-lb3-vlan2.iad.amazon.com [10.32.235.34])
	by email-inbound-relay-iad-1e-m6i4x-b538c141.us-east-1.amazon.com (Postfix) with ESMTPS id AAC23A2579;
	Mon,  6 Nov 2023 14:36:05 +0000 (UTC)
Received: from EX19MTAUWB002.ant.amazon.com [10.0.21.151:16675]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.28.94:2525] with esmtp (Farcaster)
 id deb27e6d-8725-48a3-a146-4d3938248c61; Mon, 6 Nov 2023 14:36:05 +0000 (UTC)
X-Farcaster-Flow-ID: deb27e6d-8725-48a3-a146-4d3938248c61
Received: from EX19EXOUWC001.ant.amazon.com (10.250.64.135) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Mon, 6 Nov 2023 14:35:49 +0000
Received: from EX19MTAUWB001.ant.amazon.com (10.250.64.248) by
 EX19EXOUWC001.ant.amazon.com (10.250.64.135) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.27; Mon, 6 Nov 2023 14:35:48 +0000
Received: from u3832b3a9db3152.ant.amazon.com (10.106.83.6) by
 mail-relay.amazon.com (10.250.64.254) with Microsoft SMTP Server id
 15.2.1118.39 via Frontend Transport; Mon, 6 Nov 2023 14:35:45 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: <qemu-devel@nongnu.org>
CC: Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, "Peter
 Maydell" <peter.maydell@linaro.org>, Stefano Stabellini
	<sstabellini@kernel.org>, Anthony Perard <anthony.perard@citrix.com>, "Paul
 Durrant" <paul@xen.org>, =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?=
	<marcandre.lureau@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "Richard
 Henderson" <richard.henderson@linaro.org>, Eduardo Habkost
	<eduardo@habkost.net>, "Michael S. Tsirkin" <mst@redhat.com>, "Marcel
 Apfelbaum" <marcel.apfelbaum@gmail.com>, Jason Wang <jasowang@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, <qemu-block@nongnu.org>,
	<xen-devel@lists.xenproject.org>, <kvm@vger.kernel.org>
Subject: [PATCH v4 11/17] hw/xen: only remove peers of PCI NICs on unplug
Date: Mon, 6 Nov 2023 14:35:01 +0000
Message-ID: <20231106143507.1060610-12-dwmw2@infradead.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231106143507.1060610-1-dwmw2@infradead.org>
References: <20231106143507.1060610-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: Bulk

From: David Woodhouse <dwmw@amazon.co.uk>

When the Xen guest asks to unplug *emulated* NICs, it's kind of unhelpful
also to unplug the peer of the *Xen* PV NIC.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Paul Durrant <paul@xen.org>
---
 hw/i386/xen/xen_platform.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/hw/i386/xen/xen_platform.c b/hw/i386/xen/xen_platform.c
index 17457ff3de..e2dd1b536a 100644
--- a/hw/i386/xen/xen_platform.c
+++ b/hw/i386/xen/xen_platform.c
@@ -140,9 +140,14 @@ static void unplug_nic(PCIBus *b, PCIDevice *d, void *o)
 /* Remove the peer of the NIC device. Normally, this would be a tap device. */
 static void del_nic_peer(NICState *nic, void *opaque)
 {
-    NetClientState *nc;
+    NetClientState *nc = qemu_get_queue(nic);
+    ObjectClass *klass = module_object_class_by_name(nc->model);
+
+    /* Only delete peers of PCI NICs that we're about to delete */
+    if (!klass || !object_class_dynamic_cast(klass, TYPE_PCI_DEVICE)) {
+        return;
+    }
 
-    nc = qemu_get_queue(nic);
     if (nc->peer)
         qemu_del_net_client(nc->peer);
 }
-- 
2.34.1


