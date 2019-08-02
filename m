Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6437ED04
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 08:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389213AbfHBG7O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 02:59:14 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:39031 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389202AbfHBG7O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 02:59:14 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 2 Aug 2019 09:59:11 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x726x7pX004367;
        Fri, 2 Aug 2019 09:59:09 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     kvm@vger.kernel.org, wankhede@nvidia.com,
        linux-kernel@vger.kernel.org
Cc:     parav@mellanox.com, alex.williamson@redhat.com, cohuck@redhat.com,
        cjia@nvidia.com
Subject: [PATCH 1/2] vfio-mdev/mtty: Simplify interrupt generation
Date:   Fri,  2 Aug 2019 01:59:04 -0500
Message-Id: <20190802065905.45239-2-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190802065905.45239-1-parav@mellanox.com>
References: <20190802065905.45239-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While generating interrupt, mdev_state is already available for which
interrupt is generated.
Instead of doing indirect way from state->device->uuid-> to searching
state linearly in linked list on every interrupt generation,
directly use the available state.

Hence, simplify the code to use mdev_state and remove unused helper
function with that.

Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 samples/vfio-mdev/mtty.c | 39 ++++++++-------------------------------
 1 file changed, 8 insertions(+), 31 deletions(-)

diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
index 92e770a06ea2..ce84a300a4da 100644
--- a/samples/vfio-mdev/mtty.c
+++ b/samples/vfio-mdev/mtty.c
@@ -152,20 +152,9 @@ static const struct file_operations vd_fops = {
 
 /* function prototypes */
 
-static int mtty_trigger_interrupt(const guid_t *uuid);
+static int mtty_trigger_interrupt(struct mdev_state *mdev_state);
 
 /* Helper functions */
-static struct mdev_state *find_mdev_state_by_uuid(const guid_t *uuid)
-{
-	struct mdev_state *mds;
-
-	list_for_each_entry(mds, &mdev_devices_list, next) {
-		if (guid_equal(mdev_uuid(mds->mdev), uuid))
-			return mds;
-	}
-
-	return NULL;
-}
 
 static void dump_buffer(u8 *buf, uint32_t count)
 {
@@ -337,8 +326,7 @@ static void handle_bar_write(unsigned int index, struct mdev_state *mdev_state,
 				pr_err("Serial port %d: Fifo level trigger\n",
 					index);
 #endif
-				mtty_trigger_interrupt(
-						mdev_uuid(mdev_state->mdev));
+				mtty_trigger_interrupt(mdev_state);
 			}
 		} else {
 #if defined(DEBUG_INTR)
@@ -352,8 +340,7 @@ static void handle_bar_write(unsigned int index, struct mdev_state *mdev_state,
 			 */
 			if (mdev_state->s[index].uart_reg[UART_IER] &
 								UART_IER_RLSI)
-				mtty_trigger_interrupt(
-						mdev_uuid(mdev_state->mdev));
+				mtty_trigger_interrupt(mdev_state);
 		}
 		mutex_unlock(&mdev_state->rxtx_lock);
 		break;
@@ -372,8 +359,7 @@ static void handle_bar_write(unsigned int index, struct mdev_state *mdev_state,
 				pr_err("Serial port %d: IER_THRI write\n",
 					index);
 #endif
-				mtty_trigger_interrupt(
-						mdev_uuid(mdev_state->mdev));
+				mtty_trigger_interrupt(mdev_state);
 			}
 
 			mutex_unlock(&mdev_state->rxtx_lock);
@@ -444,7 +430,7 @@ static void handle_bar_write(unsigned int index, struct mdev_state *mdev_state,
 #if defined(DEBUG_INTR)
 			pr_err("Serial port %d: MCR_OUT2 write\n", index);
 #endif
-			mtty_trigger_interrupt(mdev_uuid(mdev_state->mdev));
+			mtty_trigger_interrupt(mdev_state);
 		}
 
 		if ((mdev_state->s[index].uart_reg[UART_IER] & UART_IER_MSI) &&
@@ -452,7 +438,7 @@ static void handle_bar_write(unsigned int index, struct mdev_state *mdev_state,
 #if defined(DEBUG_INTR)
 			pr_err("Serial port %d: MCR RTS/DTR write\n", index);
 #endif
-			mtty_trigger_interrupt(mdev_uuid(mdev_state->mdev));
+			mtty_trigger_interrupt(mdev_state);
 		}
 		break;
 
@@ -503,8 +489,7 @@ static void handle_bar_read(unsigned int index, struct mdev_state *mdev_state,
 #endif
 			if (mdev_state->s[index].uart_reg[UART_IER] &
 							 UART_IER_THRI)
-				mtty_trigger_interrupt(
-					mdev_uuid(mdev_state->mdev));
+				mtty_trigger_interrupt(mdev_state);
 		}
 		mutex_unlock(&mdev_state->rxtx_lock);
 
@@ -1028,17 +1013,9 @@ static int mtty_set_irqs(struct mdev_device *mdev, uint32_t flags,
 	return ret;
 }
 
-static int mtty_trigger_interrupt(const guid_t *uuid)
+static int mtty_trigger_interrupt(struct mdev_state *mdev_state)
 {
 	int ret = -1;
-	struct mdev_state *mdev_state;
-
-	mdev_state = find_mdev_state_by_uuid(uuid);
-
-	if (!mdev_state) {
-		pr_info("%s: mdev not found\n", __func__);
-		return -EINVAL;
-	}
 
 	if ((mdev_state->irq_index == VFIO_PCI_MSI_IRQ_INDEX) &&
 	    (!mdev_state->msi_evtfd))
-- 
2.21.0.777.g83232e3864

