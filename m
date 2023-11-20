Return-Path: <kvm+bounces-2030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4974C7F0AE9
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 04:21:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C5C1EB207AB
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 03:21:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACFD61FA4;
	Mon, 20 Nov 2023 03:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1D26194;
	Sun, 19 Nov 2023 19:21:10 -0800 (PST)
X-QQ-mid: bizesmtp78t1700450355t9vmqoeh
Received: from localhost.localdomain ( [183.211.219.254])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 20 Nov 2023 11:19:05 +0800 (CST)
X-QQ-SSF: 01400000000000807000000A0000000
X-QQ-FEAT: swyrzWPvyR3eYwFMS4ZuTZqaE5VECqJG2sDyi+/ZKc+iDJhV17Gi8UJfniNEZ
	UKdk5us6A2u9/FPZHzcekiTA7dZT9YvTWY400JmkgVE9ej+k5xjf0y56TfVl3Yh19KTDxgo
	D0WlmuHzsK2Hl/5+h1LAWYjPMuZm94QJiTGStCiWhjiQRWvLxyZn/OE+ByIM7bPEThbPbqh
	HfhgAeo/rmyxXUtrXdW0e9MwHr6hnSSDvxAyV4bUfNqK2gq+lfAUHGUBH8jbhdc3b8B52xG
	vqbpVuhUMhiK9vagf/K8hYbrt0uWvBKtUc+ncCB12dJZfKzg2sornVMjKYLAhi8D/Kr3VnZ
	l7ASSF8elCPHmROQ2Sm13rwkalUgzaBkbgrf/p4RqkPu47aBQKR9UC74Rag3Q2uy0K6sSrw
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 10945035250043291984
From: JianChunfu <chunfu.jian@shingroup.cn>
To: alex.williamson@redhat.com,
	cohuck@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	shenghui.qu@shingroup.cn,
	JianChunfu <chunfu.jian@shingroup.cn>
Subject: [PATCH] vfio/pci: Separate INTx-enabled vfio_pci_device from unenabled to make the code logic clearer.
Date: Mon, 20 Nov 2023 11:17:52 +0800
Message-Id: <20231120031752.522139-1-chunfu.jian@shingroup.cn>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:shingroup.cn:qybglogicsvrgz:qybglogicsvrgz5a-1

It seems a little unclear when dealing with vfio_intx_set_signal()
because of vfio_pci_device which is irq_none,
so separate the two situations.

Signed-off-by: JianChunfu <chunfu.jian@shingroup.cn>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 6069a11fb51a..b6d126c48393 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -468,6 +468,8 @@ static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
 				     unsigned index, unsigned start,
 				     unsigned count, uint32_t flags, void *data)
 {
+	int32_t fd = *(int32_t *)data;
+
 	if (is_intx(vdev) && !count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
 		vfio_intx_disable(vdev);
 		return 0;
@@ -476,28 +478,25 @@ static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
 	if (!(is_intx(vdev) || is_irq_none(vdev)) || start != 0 || count != 1)
 		return -EINVAL;
 
-	if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
-		int32_t fd = *(int32_t *)data;
+	if (!is_intx(vdev)) {
 		int ret;
+		if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
+			ret = vfio_intx_enable(vdev);
+			if (ret)
+				return ret;
 
-		if (is_intx(vdev))
-			return vfio_intx_set_signal(vdev, fd);
+			ret = vfio_intx_set_signal(vdev, fd);
+			if (ret)
+				vfio_intx_disable(vdev);
 
-		ret = vfio_intx_enable(vdev);
-		if (ret)
 			return ret;
-
-		ret = vfio_intx_set_signal(vdev, fd);
-		if (ret)
-			vfio_intx_disable(vdev);
-
-		return ret;
+		} else
+			return -EINVAL;
 	}
 
-	if (!is_intx(vdev))
-		return -EINVAL;
-
-	if (flags & VFIO_IRQ_SET_DATA_NONE) {
+	if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
+		return vfio_intx_set_signal(vdev, fd);
+	} else if (flags & VFIO_IRQ_SET_DATA_NONE) {
 		vfio_send_intx_eventfd(vdev, NULL);
 	} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
 		uint8_t trigger = *(uint8_t *)data;
-- 
2.27.0


