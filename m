Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11CF54C654B
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 10:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234276AbiB1JDu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 04:03:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234212AbiB1JDr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 04:03:47 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2886B3632A;
        Mon, 28 Feb 2022 01:02:49 -0800 (PST)
Received: from fraeml735-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K6ZB9285vz67xNR;
        Mon, 28 Feb 2022 17:01:37 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml735-chm.china.huawei.com (10.206.15.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 28 Feb 2022 10:02:47 +0100
Received: from A2006125610.china.huawei.com (10.47.94.1) by
 lhreml710-chm.china.huawei.com (10.201.108.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 28 Feb 2022 09:02:39 +0000
From:   Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
CC:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <cohuck@redhat.com>, <mgurtovoy@nvidia.com>, <yishaih@nvidia.com>,
        <linuxarm@huawei.com>, <liulongfang@huawei.com>,
        <prime.zeng@hisilicon.com>, <jonathan.cameron@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: [PATCH v6 07/10] vfio: Extend the device migration protocol with PRE_COPY
Date:   Mon, 28 Feb 2022 09:01:18 +0000
Message-ID: <20220228090121.1903-8-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20220228090121.1903-1-shameerali.kolothum.thodi@huawei.com>
References: <20220228090121.1903-1-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.47.94.1]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

The optional PRE_COPY states open the saving data transfer FD before
reaching STOP_COPY and allows the device to dirty track internal state
changes with the general idea to reduce the volume of data transferred
in the STOP_COPY stage.

While in PRE_COPY the device remains RUNNING, but the saving FD is open.

Only if the device also supports RUNNING_P2P can it support PRE_COPY_P2P,
which halts P2P transfers while continuing the saving FD.

PRE_COPY, with P2P support, requires the driver to implement 7 new arcs
and exists as an optional FSM branch between RUNNING and STOP_COPY:
    RUNNING -> PRE_COPY -> PRE_COPY_P2P -> STOP_COPY

A new ioctl VFIO_DEVICE_MIG_PRECOPY is provided to allow userspace to
query the progress of the precopy operation in the driver with the idea it
will judge to move to STOP_COPY at least once the initial data set is
transferred, and possibly after the dirty size has shrunk appropriately.

We think there may also be merit in future extensions to the
VFIO_DEVICE_MIG_PRECOPY ioctl to also command the device to throttle the
rate it generates internal dirty state.

Compared to the v1 clarification, STOP_COPY -> PRE_COPY is made optional
and to be defined in future. While making the whole PRE_COPY feature
optional eliminates the concern from mlx5, this is still a complicated arc
to implement and seems prudent to leave it closed until a proper use case
is developed. We also split the pending_bytes report into the initial and
sustaining values, and define the protocol to get an event via poll() for
new dirty data during PRE_COPY.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 drivers/vfio/vfio.c       |  71 +++++++++++++++++++++++-
 include/uapi/linux/vfio.h | 110 ++++++++++++++++++++++++++++++++++++--
 2 files changed, 176 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index bdb5205bb358..a14b86913593 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1577,7 +1577,7 @@ int vfio_mig_get_next_state(struct vfio_device *device,
 			    enum vfio_device_mig_state new_fsm,
 			    enum vfio_device_mig_state *next_fsm)
 {
-	enum { VFIO_DEVICE_NUM_STATES = VFIO_DEVICE_STATE_RUNNING_P2P + 1 };
+	enum { VFIO_DEVICE_NUM_STATES = VFIO_DEVICE_STATE_PRE_COPY_P2P + 1 };
 	/*
 	 * The coding in this table requires the driver to implement
 	 * FSM arcs:
@@ -1596,25 +1596,59 @@ int vfio_mig_get_next_state(struct vfio_device *device,
 	 *         RUNNING -> STOP
 	 *         STOP -> RUNNING
 	 *
+	 * If precopy is supported then the driver must support these additional
+	 * FSM arcs:
+	 *         RUNNING -> PRE_COPY
+	 *         PRE_COPY -> RUNNING
+	 *         PRE_COPY -> STOP_COPY
+	 * However, if precopy and P2P are supported together then the driver
+	 * must support these additional arcs beyond the P2P arcs above:
+	 *         PRE_COPY -> RUNNING
+	 *         PRE_COPY -> PRE_COPY_P2P
+	 *         PRE_COPY_P2P -> PRE_COPY
+	 *         PRE_COPY_P2P -> RUNNING_P2P
+	 *         PRE_COPY_P2P -> STOP_COPY
+	 *         RUNNING -> PRE_COPY
+	 *         RUNNING_P2P -> PRE_COPY_P2P
+	 *
 	 * If all optional features are supported then the coding will step
 	 * through multiple states for these combination transitions:
+	 *         PRE_COPY -> PRE_COPY_P2P -> STOP_COPY
+	 *         PRE_COPY -> RUNNING -> RUNNING_P2P
+	 *         PRE_COPY -> RUNNING -> RUNNING_P2P -> STOP
+	 *         PRE_COPY -> RUNNING -> RUNNING_P2P -> STOP -> RESUMING
+	 *         PRE_COPY_P2P -> RUNNING_P2P -> RUNNING
+	 *         PRE_COPY_P2P -> RUNNING_P2P -> STOP
+	 *         PRE_COPY_P2P -> RUNNING_P2P -> STOP -> RESUMING
 	 *         RESUMING -> STOP -> RUNNING_P2P
+	 *         RESUMING -> STOP -> RUNNING_P2P -> PRE_COPY_P2P
 	 *         RESUMING -> STOP -> RUNNING_P2P -> RUNNING
+	 *         RESUMING -> STOP -> RUNNING_P2P -> RUNNING -> PRE_COPY
 	 *         RESUMING -> STOP -> STOP_COPY
+	 *         RUNNING -> RUNNING_P2P -> PRE_COPY_P2P
 	 *         RUNNING -> RUNNING_P2P -> STOP
 	 *         RUNNING -> RUNNING_P2P -> STOP -> RESUMING
 	 *         RUNNING -> RUNNING_P2P -> STOP -> STOP_COPY
+	 *         RUNNING_P2P -> RUNNING -> PRE_COPY
 	 *         RUNNING_P2P -> STOP -> RESUMING
 	 *         RUNNING_P2P -> STOP -> STOP_COPY
+	 *         STOP -> RUNNING_P2P -> PRE_COPY_P2P
 	 *         STOP -> RUNNING_P2P -> RUNNING
+	 *         STOP -> RUNNING_P2P -> RUNNING -> PRE_COPY
 	 *         STOP_COPY -> STOP -> RESUMING
 	 *         STOP_COPY -> STOP -> RUNNING_P2P
 	 *         STOP_COPY -> STOP -> RUNNING_P2P -> RUNNING
+	 *
+	 *  The following transitions are blocked:
+	 *         STOP_COPY -> PRE_COPY
+	 *         STOP_COPY -> PRE_COPY_P2P
 	 */
 	static const u8 vfio_from_fsm_table[VFIO_DEVICE_NUM_STATES][VFIO_DEVICE_NUM_STATES] = {
 		[VFIO_DEVICE_STATE_STOP] = {
 			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_STOP,
 			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_RUNNING_P2P,
+			[VFIO_DEVICE_STATE_PRE_COPY] = VFIO_DEVICE_STATE_RUNNING_P2P,
+			[VFIO_DEVICE_STATE_PRE_COPY_P2P] = VFIO_DEVICE_STATE_RUNNING_P2P,
 			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_STOP_COPY,
 			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_RESUMING,
 			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_RUNNING_P2P,
@@ -1623,14 +1657,38 @@ int vfio_mig_get_next_state(struct vfio_device *device,
 		[VFIO_DEVICE_STATE_RUNNING] = {
 			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_RUNNING_P2P,
 			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_RUNNING,
+			[VFIO_DEVICE_STATE_PRE_COPY] = VFIO_DEVICE_STATE_PRE_COPY,
+			[VFIO_DEVICE_STATE_PRE_COPY_P2P] = VFIO_DEVICE_STATE_RUNNING_P2P,
 			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_RUNNING_P2P,
 			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_RUNNING_P2P,
 			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_RUNNING_P2P,
 			[VFIO_DEVICE_STATE_ERROR] = VFIO_DEVICE_STATE_ERROR,
 		},
+		[VFIO_DEVICE_STATE_PRE_COPY] = {
+			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_RUNNING,
+			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_RUNNING,
+			[VFIO_DEVICE_STATE_PRE_COPY] = VFIO_DEVICE_STATE_PRE_COPY,
+			[VFIO_DEVICE_STATE_PRE_COPY_P2P] = VFIO_DEVICE_STATE_PRE_COPY_P2P,
+			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_PRE_COPY_P2P,
+			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_RUNNING,
+			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_RUNNING,
+			[VFIO_DEVICE_STATE_ERROR] = VFIO_DEVICE_STATE_ERROR,
+		},
+		[VFIO_DEVICE_STATE_PRE_COPY_P2P] = {
+			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_RUNNING_P2P,
+			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_RUNNING_P2P,
+			[VFIO_DEVICE_STATE_PRE_COPY] = VFIO_DEVICE_STATE_PRE_COPY,
+			[VFIO_DEVICE_STATE_PRE_COPY_P2P] = VFIO_DEVICE_STATE_PRE_COPY_P2P,
+			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_STOP_COPY,
+			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_RUNNING_P2P,
+			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_RUNNING_P2P,
+			[VFIO_DEVICE_STATE_ERROR] = VFIO_DEVICE_STATE_ERROR,
+		},
 		[VFIO_DEVICE_STATE_STOP_COPY] = {
 			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_STOP,
 			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_STOP,
+			[VFIO_DEVICE_STATE_PRE_COPY] = VFIO_DEVICE_STATE_ERROR,
+			[VFIO_DEVICE_STATE_PRE_COPY_P2P] = VFIO_DEVICE_STATE_ERROR,
 			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_STOP_COPY,
 			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_STOP,
 			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_STOP,
@@ -1639,6 +1697,8 @@ int vfio_mig_get_next_state(struct vfio_device *device,
 		[VFIO_DEVICE_STATE_RESUMING] = {
 			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_STOP,
 			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_STOP,
+			[VFIO_DEVICE_STATE_PRE_COPY] = VFIO_DEVICE_STATE_STOP,
+			[VFIO_DEVICE_STATE_PRE_COPY_P2P] = VFIO_DEVICE_STATE_STOP,
 			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_STOP,
 			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_RESUMING,
 			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_STOP,
@@ -1647,6 +1707,8 @@ int vfio_mig_get_next_state(struct vfio_device *device,
 		[VFIO_DEVICE_STATE_RUNNING_P2P] = {
 			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_STOP,
 			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_RUNNING,
+			[VFIO_DEVICE_STATE_PRE_COPY] = VFIO_DEVICE_STATE_RUNNING,
+			[VFIO_DEVICE_STATE_PRE_COPY_P2P] = VFIO_DEVICE_STATE_PRE_COPY_P2P,
 			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_STOP,
 			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_STOP,
 			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_RUNNING_P2P,
@@ -1655,6 +1717,8 @@ int vfio_mig_get_next_state(struct vfio_device *device,
 		[VFIO_DEVICE_STATE_ERROR] = {
 			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_ERROR,
 			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_ERROR,
+			[VFIO_DEVICE_STATE_PRE_COPY] = VFIO_DEVICE_STATE_ERROR,
+			[VFIO_DEVICE_STATE_PRE_COPY_P2P] = VFIO_DEVICE_STATE_ERROR,
 			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_ERROR,
 			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_ERROR,
 			[VFIO_DEVICE_STATE_RUNNING_P2P] = VFIO_DEVICE_STATE_ERROR,
@@ -1665,6 +1729,11 @@ int vfio_mig_get_next_state(struct vfio_device *device,
 	static const unsigned int state_flags_table[VFIO_DEVICE_NUM_STATES] = {
 		[VFIO_DEVICE_STATE_STOP] = VFIO_MIGRATION_STOP_COPY,
 		[VFIO_DEVICE_STATE_RUNNING] = VFIO_MIGRATION_STOP_COPY,
+		[VFIO_DEVICE_STATE_PRE_COPY] =
+			VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_PRE_COPY,
+		[VFIO_DEVICE_STATE_PRE_COPY_P2P] = VFIO_MIGRATION_STOP_COPY |
+						   VFIO_MIGRATION_P2P |
+						   VFIO_MIGRATION_PRE_COPY,
 		[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_MIGRATION_STOP_COPY,
 		[VFIO_DEVICE_STATE_RESUMING] = VFIO_MIGRATION_STOP_COPY,
 		[VFIO_DEVICE_STATE_RUNNING_P2P] =
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index fea86061b44e..7a8f777b72f2 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -819,12 +819,20 @@ struct vfio_device_feature {
  * VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_P2P means that RUNNING_P2P
  * is supported in addition to the STOP_COPY states.
  *
+ * VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_PRE_COPY means that
+ * PRE_COPY is supported in addition to the STOP_COPY states.
+ *
+ * VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_P2P | VFIO_MIGRATION_PRE_COPY
+ * means that RUNNING_P2P, PRE_COPY and PRE_COPY_P2P are supported
+ * in addition to the STOP_COPY states.
+ *
  * Other combinations of flags have behavior to be defined in the future.
  */
 struct vfio_device_feature_migration {
 	__aligned_u64 flags;
 #define VFIO_MIGRATION_STOP_COPY	(1 << 0)
 #define VFIO_MIGRATION_P2P		(1 << 1)
+#define VFIO_MIGRATION_PRE_COPY		(1 << 2)
 };
 #define VFIO_DEVICE_FEATURE_MIGRATION 1
 
@@ -875,8 +883,13 @@ struct vfio_device_feature_mig_state {
  *  RESUMING - The device is stopped and is loading a new internal state
  *  ERROR - The device has failed and must be reset
  *
- * And 1 optional state to support VFIO_MIGRATION_P2P:
+ * And optional states to support VFIO_MIGRATION_P2P:
  *  RUNNING_P2P - RUNNING, except the device cannot do peer to peer DMA
+ * And VFIO_MIGRATION_PRE_COPY:
+ *  PRE_COPY - The device is running normally but tracking internal state
+ *             changes
+ * And VFIO_MIGRATION_P2P | VFIO_MIGRATION_PRE_COPY:
+ *  PRE_COPY_P2P - PRE_COPY, except the device cannot do peer to peer DMA
  *
  * The FSM takes actions on the arcs between FSM states. The driver implements
  * the following behavior for the FSM arcs:
@@ -908,20 +921,48 @@ struct vfio_device_feature_mig_state {
  *
  *   To abort a RESUMING session the device must be reset.
  *
+ * PRE_COPY -> RUNNING
  * RUNNING_P2P -> RUNNING
  *   While in RUNNING the device is fully operational, the device may generate
  *   interrupts, DMA, respond to MMIO, all vfio device regions are functional,
  *   and the device may advance its internal state.
  *
+ *   The PRE_COPY arc will terminate a data transfer session.
+ *
+ * PRE_COPY_P2P -> RUNNING_P2P
  * RUNNING -> RUNNING_P2P
  * STOP -> RUNNING_P2P
  *   While in RUNNING_P2P the device is partially running in the P2P quiescent
  *   state defined below.
  *
+ *   The PRE_COPY arc will terminate a data transfer session.
+ *
+ * RUNNING -> PRE_COPY
+ * RUNNING_P2P -> PRE_COPY_P2P
  * STOP -> STOP_COPY
- *   This arc begin the process of saving the device state and will return a
- *   new data_fd.
+ *   PRE_COPY, PRE_COPY_P2P and STOP_COPY form the "saving group" of states
+ *   which share a data transfer session. Moving between these states alters
+ *   what is streamed in session, but does not terminate or otherwise effect
+ *   the associated fd.
+ *
+ *   These arcs begin the process of saving the device state and will return a
+ *   new data_fd. The migration driver may perform actions such as enabling
+ *   dirty logging of device state when entering PRE_COPY or PER_COPY_P2P.
  *
+ *   Each arc does not change the device operation, the device remains
+ *   RUNNING, P2P quiesced or in STOP. The STOP_COPY state is described below
+ *   in PRE_COPY_P2P -> STOP_COPY.
+ *
+ * PRE_COPY -> PRE_COPY_P2P
+ *   Entering PRE_COPY_P2P continues all the behaviors of PRE_COPY above.
+ *   However, while in the PRE_COPY_P2P state, the device is partially running
+ *   in the P2P quiescent state defined below, like RUNNING_P2P.
+ *
+ * PRE_COPY_P2P -> PRE_COPY
+ *   This arc allows returning the device to a full RUNNING behavior while
+ *   continuing all the behaviors of PRE_COPY.
+ *
+ * PRE_COPY_P2P -> STOP_COPY
  *   While in the STOP_COPY state the device has the same behavior as STOP
  *   with the addition that the data transfers session continues to stream the
  *   migration state. End of stream on the FD indicates the entire device
@@ -939,6 +980,13 @@ struct vfio_device_feature_mig_state {
  *   device state for this arc if required to prepare the device to receive the
  *   migration data.
  *
+ * STOP_COPY -> PRE_COPY
+ * STOP_COPY -> PRE_COPY_P2P
+ *   These arcs are not permitted and return error if requested. Future
+ *   revisions of this API may define behaviors for these arcs, in this case
+ *   support will be discoverable by a new flag in
+ *   VFIO_DEVICE_FEATURE_MIGRATION.
+ *
  * any -> ERROR
  *   ERROR cannot be specified as a device state, however any transition request
  *   can be failed with an errno return and may then move the device_state into
@@ -950,7 +998,7 @@ struct vfio_device_feature_mig_state {
  * The optional peer to peer (P2P) quiescent state is intended to be a quiescent
  * state for the device for the purposes of managing multiple devices within a
  * user context where peer-to-peer DMA between devices may be active. The
- * RUNNING_P2P states must prevent the device from initiating
+ * RUNNING_P2P and PRE_COPY_P2P states must prevent the device from initiating
  * any new P2P DMA transactions. If the device can identify P2P transactions
  * then it can stop only P2P DMA, otherwise it must stop all DMA. The migration
  * driver must complete any such outstanding operations prior to completing the
@@ -963,6 +1011,8 @@ struct vfio_device_feature_mig_state {
  * above FSM arcs. As there are multiple paths through the FSM arcs the path
  * should be selected based on the following rules:
  *   - Select the shortest path.
+ *   - The path cannot have saving group states as interior arcs, only
+ *     starting/end states.
  * Refer to vfio_mig_get_next_state() for the result of the algorithm.
  *
  * The automatic transit through the FSM arcs that make up the combination
@@ -976,6 +1026,9 @@ struct vfio_device_feature_mig_state {
  * support them. The user can discover if these states are supported by using
  * VFIO_DEVICE_FEATURE_MIGRATION. By using combination transitions the user can
  * avoid knowing about these optional states if the kernel driver supports them.
+ *
+ * Arcs touching PRE_COPY and PRE_COPY_P2P are removed if support for PRE_COPY
+ * is not present.
  */
 enum vfio_device_mig_state {
 	VFIO_DEVICE_STATE_ERROR = 0,
@@ -984,8 +1037,57 @@ enum vfio_device_mig_state {
 	VFIO_DEVICE_STATE_STOP_COPY = 3,
 	VFIO_DEVICE_STATE_RESUMING = 4,
 	VFIO_DEVICE_STATE_RUNNING_P2P = 5,
+	VFIO_DEVICE_STATE_PRE_COPY = 6,
+	VFIO_DEVICE_STATE_PRE_COPY_P2P = 7,
+};
+
+/**
+ * VFIO_DEVICE_MIG_PRECOPY - _IO(VFIO_TYPE, VFIO_BASE + 21)
+ *
+ * This ioctl is used on the migration data FD in the precopy phase of the
+ * migration data transfer. It returns an estimate of the current data sizes
+ * remaining to be transferred. It allows the user to judge when it is
+ * appropriate to leave PRE_COPY for STOP_COPY.
+ *
+ * initial_bytes reflects the estimated remaining size of any initial mandatory
+ * precopy data transfer. When initial_bytes returns as zero then the initial
+ * phase of the precopy data is completed. Generally initial_bytes should start
+ * out as approximately the entire device state.
+ *
+ * dirty_bytes reflects an estimate for how much more data needs to be
+ * transferred to complete the migration. Generally it should start as zero
+ * and increase as internal state is dirtied.
+ *
+ * Drivers should attempt to return estimates so that initial_bytes +
+ * dirty_bytes matches the amount of data an immediate transition to STOP_COPY
+ * will require to be streamed.
+ *
+ * Drivers have alot of flexibility in when and what they transfer during the
+ * PRE_COPY phase, and how they report this from VFIO_DEVICE_MIG_PRECOPY.
+ *
+ * During pre-copy the migration data FD has a temporary "end of stream" that is
+ * reached when both initial_bytes and dirty_byte are zero. For instance, this
+ * may indicate that the device is idle and not currently dirtying any internal
+ * state. When read() is done on this temporary end of stream the kernel driver
+ * should return ENOMSG from read(). Userspace can wait for more data (which may
+ * never come) by using poll.
+ *
+ * Once in STOP_COPY the migration data FD has a permanent end of stream
+ * signaled in the usual way by read() always returning 0 and poll always
+ * returning readable. ENOMSG may not be returned in STOP_COPY. Support
+ * for this ioctl is optional.
+ *
+ * Return: 0 on success, -1 and errno set on failure.
+ */
+struct vfio_device_mig_precopy {
+	__u32 argsz;
+	__u32 flags;
+	__aligned_u64 initial_bytes;
+	__aligned_u64 dirty_bytes;
 };
 
+#define VFIO_DEVICE_MIG_PRECOPY _IO(VFIO_TYPE, VFIO_BASE + 21)
+
 /* -------- API for Type1 VFIO IOMMU -------- */
 
 /**
-- 
2.25.1

