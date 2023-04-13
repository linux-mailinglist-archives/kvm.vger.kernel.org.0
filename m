Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B380C6E08C5
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 10:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbjDMITR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 04:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbjDMITP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 04:19:15 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2071.outbound.protection.outlook.com [40.107.21.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3CEE7280;
        Thu, 13 Apr 2023 01:19:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UHBCKc/ir14PXfh8Py2Ox87vrx5GamNqHLfYUOpktlkB5D4jBcilKM/6uOvz7xv3+MxXJ2ChRl19kyshXQ3X8fzp/dBl7875i730OZdQuYBQ4Sly+GKRC9ykHa9RpWkIEntm6JKYfV1/5vFNzNpzgJoa1QRo3Zg1YjArLOXpN2VFXPB2A33RFuGQcBeP4DT0S2Th6RPth/YT/tXWgIIDtNyxWe68T5+pWKdzcoxgAK6hc79NqaJr65fALLiBCZjZpfHko9ZM0bKvQNXed4bfbEjKD6S3JcW85Vv3p//O9E4Xjsm5YiT0woI4V/BWd4/SbXNUackOJXW1g3yUabTvWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nVhA+aLyeR7D47AsiAwjmzAFFy5taKpvwm6WQopnOnI=;
 b=FXd1Gpda+azk6DX6tp4dgu11CDIg9ReY8bIO13nQfdn4DGOpWmduRVPh7MW8o+ZoFzUNWZcchB1ilJcIWm12lZXtY9SWaJcVcFmEzPnftUzLbNG6SlAbTA5QQJlCQO1B1czbY1rjQJJM8GR6Lp9b9lYr6TRGVge1cety0z2aWA61iTflkfOc2oKBIy01LhbRWXkEcbZam49+XFDH3Ehc/Vt+1Xy4wD4aBwpLwAA6YREma43PqyyYd+uxYTtpbQ/DdxA4fEBPUt8NqwMee36k81ZJQ+DjzNgoaOL0XKSwzt7st1pl369sloHYtqdaf9egKBEnVvhoF49TVqBKPeUVtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=solid-run.com; dmarc=pass action=none
 header.from=solid-run.com; dkim=pass header.d=solid-run.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=solidrn.onmicrosoft.com; s=selector1-solidrn-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nVhA+aLyeR7D47AsiAwjmzAFFy5taKpvwm6WQopnOnI=;
 b=p9KNXoGZD+4ZwGwjmetnrumALna2dqEGTUbzf/BW7sfkpWmdBdEtCsLazx7gSKTiJpU8D0mOnWVrmA1U2pWOhuYnDs+c2W20yqgqcVaTikV1XQAYMjpYk87ifVD5GkdCocx7hBM5BhKQOUiMpsKAnpcL2zmKR/yWDmxafCEOW6U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=solid-run.com;
Received: from AM0PR04MB4723.eurprd04.prod.outlook.com (2603:10a6:208:c0::20)
 by DBBPR04MB7721.eurprd04.prod.outlook.com (2603:10a6:10:1f6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Thu, 13 Apr
 2023 08:19:11 +0000
Received: from AM0PR04MB4723.eurprd04.prod.outlook.com
 ([fe80::54c9:6706:9dc6:d977]) by AM0PR04MB4723.eurprd04.prod.outlook.com
 ([fe80::54c9:6706:9dc6:d977%5]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 08:19:11 +0000
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     virtualization@lists.linux-foundation.org, cohuck@redhat.com,
        pasic@linux.ibm.com, farman@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, yan@daynix.com, viktor@daynix.com,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: [PATCH 1/2] virtio: add VIRTIO_F_NOTIFICATION_DATA feature support
Date:   Thu, 13 Apr 2023 11:18:54 +0300
Message-Id: <20230413081855.36643-2-alvaro.karsz@solid-run.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230413081855.36643-1-alvaro.karsz@solid-run.com>
References: <20230413081855.36643-1-alvaro.karsz@solid-run.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ZR0P278CA0054.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::23) To AM0PR04MB4723.eurprd04.prod.outlook.com
 (2603:10a6:208:c0::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB4723:EE_|DBBPR04MB7721:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e6f3c8c-da86-4879-ab01-08db3bf7c2e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wYORrxztA6yeedvxZwcH+D4Su0xET2tTYyxXIET+gVyhYy7nsZ3I5eEjar6RcCaYXubZW39wxcT4t9616XRB7+5hXzjkMEkdetDSSmVghrZhpCEhmKt5ZaYxCEH1D/nichjNewgJlz5e3uie068FnHn2kylTz79FePtDy3cRDkXT/b88mNM3dEh50URpU85uKotmrwQ0b5Gd9rQtDOUOvk0Zamywhqt+E2ttGsW+lmhuNUdS0h8m0ZOCBclae8i6bNoGmRc27dkMC/2OLZ+IK7j8LY1MhsKTQyg0Cvx077l29q1Y/2EQBY4gsZMNcywJ8FKPWh1Zi3WeovXSZy9OjvjzuuICWY6SsVs3G6kMTFuBg/Ab/VB/v9nWChQUVYgkfn6hUZ6yYi34a0stO/GENBEf7YY8/+cK9GToqx7u4hGAxpdx3fYvMCRBZd6pTtRljkEfG2Ied6FBP2xxyiuuRSD8dyz+XHF7NOMwaXDhIikupmOyqgo6nmo79LN2WN6U2+LBBuyRHuKj171zoKAHbRxUG0Vmk1hBu3/3yK+xO61Ov9SuAJdt8DTK0o2UBA8n6UM06ZS4G1AfysYQd0yAbbjBa0wsQzyJhi4Zo1/5sNWOFWESQM/n2LRgBazUK7n+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB4723.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(346002)(376002)(39840400004)(366004)(451199021)(6666004)(52116002)(6486002)(66476007)(66556008)(66946007)(4326008)(36756003)(2906002)(7416002)(44832011)(86362001)(41300700001)(5660300002)(8676002)(8936002)(316002)(38100700002)(38350700002)(478600001)(6512007)(6506007)(1076003)(26005)(2616005)(186003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oc916p8XdbckAQ7HwB6eUzD6l7rBn63v7NW1kY8e/2oSELGOB1iRvVps93Op?=
 =?us-ascii?Q?pAxyOOW8CbQa4SHOM7k3vztdd/eXs7kiruIGBWXObtJG+g6adsiuDsOKtFwl?=
 =?us-ascii?Q?hMbk73leUJ0G7FmCNksqdl6ORUGdgFD4BkMKR57GziPJUV123ldpfoU5Z6Ky?=
 =?us-ascii?Q?nX4gwlIr4LjWLJRhd81hXsPkvtkEuEVlr2IDHtcQoHF8PdHNiLIzIBqxemiy?=
 =?us-ascii?Q?EsMGn4OOo7DJTZFgv2NYY6eqaaxgs/0tRc7bMg2noiRwHNTU8M5cTet64jig?=
 =?us-ascii?Q?1zZ7ibgOVUzynPQirddOWym0VYJME/FP3m9cvZAb45FJX5QirGy/93kBzwFP?=
 =?us-ascii?Q?SsHAKgUe0jJ9GOgI7wu4XZA4Kc21jrmJaxUuEYX4r4hGv1+5DpVGKb8bTLpO?=
 =?us-ascii?Q?FcHnUgf2ZpVKO8WY3ZxFkIT9bcxAO2wVlCtlhWGd5XLHt0bYVODDAbqBhwXT?=
 =?us-ascii?Q?99Xam2XaSf7OyBeIHzwKbqDUZxSf4mRYNdVkwPnSBRRFns5io4SxBbmlfbpT?=
 =?us-ascii?Q?j1hJA0Nl01GKNQimZxq2sYlI9GkRqmveCdACZRxkJL9Zg6bl/COy+UxRgWEo?=
 =?us-ascii?Q?1g5kIozJpAGgZAOdIsvBQ+VeXC4i0J8zBuf5hQQIuyN5eRogfEYcWea2VRb6?=
 =?us-ascii?Q?/Pal1kgKCBxrotIX9lXmnfafXnG3SzGCHH/LvAUPhha6mUh3ztDUVTh1FIz/?=
 =?us-ascii?Q?mZzEVhqDStcr5A26r022IBkjig+bye+QMPaW1wSk875JRzize5t06YleixoJ?=
 =?us-ascii?Q?ZiCX5BLdQ1aTjJvoQSk9Ru0Zpoii3t0in41ivpmW+E8GVQ/TvSWaIcDEzmqn?=
 =?us-ascii?Q?OSeKZXFegtL9NEoiSSANc6V2dqd3swCmgiztwXGHpM/UIECO/A2cIMNdXDHS?=
 =?us-ascii?Q?x3IWus3+rQnpe12szEEn54VXk6JMr2OIrlD6l8Ms43HJxPs3Mi0rX5OmB4pq?=
 =?us-ascii?Q?DmdtcuTj45+GHeHndTKWdIydawReb7cu9+cXTFdshex4LRhW8IOzdal2AiNW?=
 =?us-ascii?Q?rV5iSHfNlxEzMa/vXXysRgkwnIWdfpay3Mpzr0m7VDOO9WhjjvnYDu1LOCXe?=
 =?us-ascii?Q?wH2PUN6AEh/eY5zdYF51xceMQxy0TqWaWLkHqmBNzt2ZEjPBSM1E0ZaPB1FX?=
 =?us-ascii?Q?lNLSQYU54vDGCieUg4MN/RbUanS9e0UqhFBXIQ/9vCcbRkKZLwFrqYi51hxW?=
 =?us-ascii?Q?coJbUwMaKFFFozSeH58Tok7JDV5PPFjNTOcrGVRueCVlxh+bCEnxAZufRxMt?=
 =?us-ascii?Q?ypjGfcgx6xI5LHKpL3u/bUE2ZGl5GP/A5TeNdEXF3loJ0xVVSQH1y032pIwv?=
 =?us-ascii?Q?2OSEbvJo6QPnKqiZS3lww4YIj7aV9urN1dFY2EwALcBbwTD0L9tMMnzkNO/p?=
 =?us-ascii?Q?0IvB6wfwqbPyj6x09fj3+sXGGEZcvGCeI8Hh3LNoO7wVURlgaMNT1EInC51g?=
 =?us-ascii?Q?1aQTdbHI/KUQJmzoXf4yjp4Tol9w20DhR+BoRaklJRvFLlKmy/yspMbHT+Fa?=
 =?us-ascii?Q?34bQBgqLCRpv5U/9TRsPlxlG8w6ZYLMjU1imBQj4tyYMv62MUes5iymCnqWx?=
 =?us-ascii?Q?QZY3waIZScKPYt5TeexjhUd4KAyhMk6EHEF5Vkuddhj3YCrKE9q4UGuXxt/b?=
 =?us-ascii?Q?lg=3D=3D?=
X-OriginatorOrg: solid-run.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e6f3c8c-da86-4879-ab01-08db3bf7c2e6
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB4723.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 08:19:11.8158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a4a8aaf3-fd27-4e27-add2-604707ce5b82
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VcDK/M3U4pYcPj1pibDBdXh4uIzeu43R6I3Lyr4o+qMbfesvmpM3VYq7eQAMTC9DnKfu6qSPYXF75e18caEVVTyS+lEcV/B36hzuJB9w7hM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7721
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Viktor Prutyanov <viktor@daynix.com>

According to VirtIO spec v1.2, VIRTIO_F_NOTIFICATION_DATA feature
indicates that the driver passes extra data along with the queue
notifications.

In a split queue case, the extra data is 16-bit available index. In a
packed queue case, the extra data is 1-bit wrap counter and 15-bit
available index.

Add support for this feature for MMIO, channel I/O and modern PCI
transports.

Signed-off-by: Viktor Prutyanov <viktor@daynix.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/s390/virtio/virtio_ccw.c   | 22 +++++++++++++++++++---
 drivers/virtio/virtio_mmio.c       | 18 +++++++++++++++++-
 drivers/virtio/virtio_pci_modern.c | 17 ++++++++++++++++-
 drivers/virtio/virtio_ring.c       | 19 +++++++++++++++++++
 include/linux/virtio_ring.h        |  2 ++
 include/uapi/linux/virtio_config.h |  6 ++++++
 6 files changed, 79 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index 954fc31b4bc..02922768b12 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -391,7 +391,7 @@ static void virtio_ccw_drop_indicator(struct virtio_ccw_device *vcdev,
 	ccw_device_dma_free(vcdev->cdev, thinint_area, sizeof(*thinint_area));
 }
 
-static bool virtio_ccw_kvm_notify(struct virtqueue *vq)
+static inline bool virtio_ccw_do_kvm_notify(struct virtqueue *vq, u32 data)
 {
 	struct virtio_ccw_vq_info *info = vq->priv;
 	struct virtio_ccw_device *vcdev;
@@ -402,12 +402,22 @@ static bool virtio_ccw_kvm_notify(struct virtqueue *vq)
 	BUILD_BUG_ON(sizeof(struct subchannel_id) != sizeof(unsigned int));
 	info->cookie = kvm_hypercall3(KVM_S390_VIRTIO_CCW_NOTIFY,
 				      *((unsigned int *)&schid),
-				      vq->index, info->cookie);
+				      data, info->cookie);
 	if (info->cookie < 0)
 		return false;
 	return true;
 }
 
+static bool virtio_ccw_kvm_notify(struct virtqueue *vq)
+{
+	return virtio_ccw_do_kvm_notify(vq, vq->index);
+}
+
+static bool virtio_ccw_kvm_notify_with_data(struct virtqueue *vq)
+{
+	return virtio_ccw_do_kvm_notify(vq, vring_notification_data(vq));
+}
+
 static int virtio_ccw_read_vq_conf(struct virtio_ccw_device *vcdev,
 				   struct ccw1 *ccw, int index)
 {
@@ -495,6 +505,7 @@ static struct virtqueue *virtio_ccw_setup_vq(struct virtio_device *vdev,
 					     struct ccw1 *ccw)
 {
 	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
+	bool (*notify)(struct virtqueue *vq);
 	int err;
 	struct virtqueue *vq = NULL;
 	struct virtio_ccw_vq_info *info;
@@ -502,6 +513,11 @@ static struct virtqueue *virtio_ccw_setup_vq(struct virtio_device *vdev,
 	unsigned long flags;
 	bool may_reduce;
 
+	if (__virtio_test_bit(vdev, VIRTIO_F_NOTIFICATION_DATA))
+		notify = virtio_ccw_kvm_notify_with_data;
+	else
+		notify = virtio_ccw_kvm_notify;
+
 	/* Allocate queue. */
 	info = kzalloc(sizeof(struct virtio_ccw_vq_info), GFP_KERNEL);
 	if (!info) {
@@ -524,7 +540,7 @@ static struct virtqueue *virtio_ccw_setup_vq(struct virtio_device *vdev,
 	may_reduce = vcdev->revision > 0;
 	vq = vring_create_virtqueue(i, info->num, KVM_VIRTIO_CCW_RING_ALIGN,
 				    vdev, true, may_reduce, ctx,
-				    virtio_ccw_kvm_notify, callback, name);
+				    notify, callback, name);
 
 	if (!vq) {
 		/* For now, we fail if we can't get the requested size. */
diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index 3ff746e3f24..dd4424c1423 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -285,6 +285,16 @@ static bool vm_notify(struct virtqueue *vq)
 	return true;
 }
 
+static bool vm_notify_with_data(struct virtqueue *vq)
+{
+	struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vq->vdev);
+	u32 data = vring_notification_data(vq);
+
+	writel(data, vm_dev->base + VIRTIO_MMIO_QUEUE_NOTIFY);
+
+	return true;
+}
+
 /* Notify all virtqueues on an interrupt. */
 static irqreturn_t vm_interrupt(int irq, void *opaque)
 {
@@ -363,12 +373,18 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned int in
 				  const char *name, bool ctx)
 {
 	struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vdev);
+	bool (*notify)(struct virtqueue *vq);
 	struct virtio_mmio_vq_info *info;
 	struct virtqueue *vq;
 	unsigned long flags;
 	unsigned int num;
 	int err;
 
+	if (__virtio_test_bit(vdev, VIRTIO_F_NOTIFICATION_DATA))
+		notify = vm_notify_with_data;
+	else
+		notify = vm_notify;
+
 	if (!name)
 		return NULL;
 
@@ -397,7 +413,7 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned int in
 
 	/* Create the vring */
 	vq = vring_create_virtqueue(index, num, VIRTIO_MMIO_VRING_ALIGN, vdev,
-				 true, true, ctx, vm_notify, callback, name);
+				 true, true, ctx, notify, callback, name);
 	if (!vq) {
 		err = -ENOMEM;
 		goto error_new_virtqueue;
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index 9e496e288cf..05deba5153b 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -288,6 +288,15 @@ static u16 vp_config_vector(struct virtio_pci_device *vp_dev, u16 vector)
 	return vp_modern_config_vector(&vp_dev->mdev, vector);
 }
 
+static bool vp_notify_with_data(struct virtqueue *vq)
+{
+	u32 data = vring_notification_data(vq);
+
+	iowrite32(data, (void __iomem *)vq->priv);
+
+	return true;
+}
+
 static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 				  struct virtio_pci_vq_info *info,
 				  unsigned int index,
@@ -298,10 +307,16 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 {
 
 	struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
+	bool (*notify)(struct virtqueue *vq);
 	struct virtqueue *vq;
 	u16 num;
 	int err;
 
+	if (__virtio_test_bit(&vp_dev->vdev, VIRTIO_F_NOTIFICATION_DATA))
+		notify = vp_notify_with_data;
+	else
+		notify = vp_notify;
+
 	if (index >= vp_modern_get_num_queues(mdev))
 		return ERR_PTR(-EINVAL);
 
@@ -321,7 +336,7 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 	vq = vring_create_virtqueue(index, num,
 				    SMP_CACHE_BYTES, &vp_dev->vdev,
 				    true, true, ctx,
-				    vp_notify, callback, name);
+				    notify, callback, name);
 	if (!vq)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 41144b5246a..7749bd5f99f 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -2752,6 +2752,23 @@ void vring_del_virtqueue(struct virtqueue *_vq)
 }
 EXPORT_SYMBOL_GPL(vring_del_virtqueue);
 
+u32 vring_notification_data(struct virtqueue *_vq)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+	u16 next;
+
+	if (vq->packed_ring)
+		next = (vq->packed.next_avail_idx &
+				~(-(1 << VRING_PACKED_EVENT_F_WRAP_CTR))) |
+			vq->packed.avail_wrap_counter <<
+				VRING_PACKED_EVENT_F_WRAP_CTR;
+	else
+		next = vq->split.avail_idx_shadow;
+
+	return next << 16 | _vq->index;
+}
+EXPORT_SYMBOL_GPL(vring_notification_data);
+
 /* Manipulates transport-specific feature bits. */
 void vring_transport_features(struct virtio_device *vdev)
 {
@@ -2771,6 +2788,8 @@ void vring_transport_features(struct virtio_device *vdev)
 			break;
 		case VIRTIO_F_ORDER_PLATFORM:
 			break;
+		case VIRTIO_F_NOTIFICATION_DATA:
+			break;
 		default:
 			/* We don't understand this bit. */
 			__virtio_clear_bit(vdev, i);
diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
index 8b95b69ef69..2550c9170f4 100644
--- a/include/linux/virtio_ring.h
+++ b/include/linux/virtio_ring.h
@@ -117,4 +117,6 @@ void vring_del_virtqueue(struct virtqueue *vq);
 void vring_transport_features(struct virtio_device *vdev);
 
 irqreturn_t vring_interrupt(int irq, void *_vq);
+
+u32 vring_notification_data(struct virtqueue *_vq);
 #endif /* _LINUX_VIRTIO_RING_H */
diff --git a/include/uapi/linux/virtio_config.h b/include/uapi/linux/virtio_config.h
index 3c05162bc98..2c712c65416 100644
--- a/include/uapi/linux/virtio_config.h
+++ b/include/uapi/linux/virtio_config.h
@@ -99,6 +99,12 @@
  */
 #define VIRTIO_F_SR_IOV			37
 
+/*
+ * This feature indicates that the driver passes extra data (besides
+ * identifying the virtqueue) in its device notifications.
+ */
+#define VIRTIO_F_NOTIFICATION_DATA	38
+
 /*
  * This feature indicates that the driver can reset a queue individually.
  */
-- 
2.34.1

