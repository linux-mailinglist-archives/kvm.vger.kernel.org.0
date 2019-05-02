Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AED1911878
	for <lists+kvm@lfdr.de>; Thu,  2 May 2019 13:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbfEBLtj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 May 2019 07:49:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58660 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726583AbfEBLtj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 May 2019 07:49:39 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 252C0C05E767;
        Thu,  2 May 2019 11:49:38 +0000 (UTC)
Received: from maximlenovopc.usersys.redhat.com (unknown [10.35.206.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E8E617DDF;
        Thu,  2 May 2019 11:49:31 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     linux-nvme@lists.infradead.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@fb.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Keith Busch <keith.busch@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "Paul E . McKenney " <paulmck@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liang Cunming <cunming.liang@intel.com>,
        Liu Changpeng <changpeng.liu@intel.com>,
        Fam Zheng <fam@euphon.net>, Amnon Ilan <ailan@redhat.com>,
        John Ferlan <jferlan@redhat.com>
Subject: [PATCH v2 09/10] nvme/mdev - Add inline performance measurments
Date:   Thu,  2 May 2019 14:48:00 +0300
Message-Id: <20190502114801.23116-10-mlevitsk@redhat.com>
In-Reply-To: <20190502114801.23116-1-mlevitsk@redhat.com>
References: <20190502114801.23116-1-mlevitsk@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Thu, 02 May 2019 11:49:38 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This code might not be needed to be merged in the final version

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 drivers/nvme/mdev/instance.c | 62 ++++++++++++++++++++++++++++++++++++
 drivers/nvme/mdev/io.c       | 21 ++++++++++++
 drivers/nvme/mdev/irq.c      |  6 ++++
 drivers/nvme/mdev/priv.h     | 13 ++++++++
 drivers/nvme/mdev/vctrl.c    |  3 ++
 5 files changed, 105 insertions(+)

diff --git a/drivers/nvme/mdev/instance.c b/drivers/nvme/mdev/instance.c
index 0e5ba5a9269f..d692b2bf2ef2 100644
--- a/drivers/nvme/mdev/instance.c
+++ b/drivers/nvme/mdev/instance.c
@@ -771,6 +771,62 @@ static struct attribute *nvme_mdev_dev_settings_atttributes[] = {
 	NULL
 };
 
+/* show perf stats */
+static ssize_t stats_show(struct device *dev,
+			  struct device_attribute *attr, char *buf)
+{
+	struct nvme_mdev_vctrl *vctrl = dev_to_vctrl(dev);
+	struct nvme_mdev_perf *perf;
+
+	if (!vctrl)
+		return -ENODEV;
+
+	perf = &vctrl->perf;
+
+	return sprintf(buf,
+		"%u %llu %llu %llu %llu %llu %llu\n",
+
+		tsc_khz,
+
+		perf->cmds_started,
+		perf->cycles_send_to_hw,
+
+		perf->cmds_complete,
+		perf->cycles_receive_from_hw,
+
+		perf->interrupts_sent,
+		perf->cycles_irq_delivery);
+}
+
+/* clear the perf stats */
+static ssize_t stats_store(struct device *dev,
+			   struct device_attribute *attr,
+			   const char *buf, size_t count)
+{
+	bool val;
+	int ret;
+	struct nvme_mdev_vctrl *vctrl = dev_to_vctrl(dev);
+
+	if (!vctrl)
+		return -ENODEV;
+	ret = kstrtobool(buf, &val);
+	if (ret)
+		return ret;
+
+	if (!val)
+		return -EINVAL;
+
+	memset(&vctrl->perf, 0, sizeof(vctrl->perf));
+	return count;
+}
+
+static DEVICE_ATTR_RW(stats);
+
+static struct attribute *nvme_mdev_dev_debug_attributes[] = {
+	&dev_attr_stats.attr,
+	NULL
+};
+
 static const struct attribute_group nvme_mdev_ns_attr_group = {
 	.name = "namespaces",
 	.attrs = nvme_mdev_dev_ns_atttributes,
@@ -781,9 +837,15 @@ static const struct attribute_group nvme_mdev_setting_attr_group = {
 	.attrs = nvme_mdev_dev_settings_atttributes,
 };
 
+static const struct attribute_group nvme_mdev_debug_attr_group = {
+	.name = "debug",
+	.attrs = nvme_mdev_dev_debug_attributes,
+};
+
 static const struct attribute_group *nvme_mdev_dev_attributte_groups[] = {
 	&nvme_mdev_ns_attr_group,
 	&nvme_mdev_setting_attr_group,
+	&nvme_mdev_debug_attr_group,
 	NULL,
 };
 
diff --git a/drivers/nvme/mdev/io.c b/drivers/nvme/mdev/io.c
index 59837540fec2..39550d0e3649 100644
--- a/drivers/nvme/mdev/io.c
+++ b/drivers/nvme/mdev/io.c
@@ -9,6 +9,7 @@
 #include <linux/nvme.h>
 #include <linux/timekeeping.h>
 #include <linux/ktime.h>
+#include <asm/msr.h>
 #include "priv.h"
 
 
@@ -251,6 +252,9 @@ static bool nvme_mdev_io_process_sq(struct io_ctx *ctx, u16 sqid)
 	struct nvme_vsq *vsq = &ctx->vctrl->vsqs[sqid];
 	u16 ucid;
 	int ret;
+	unsigned long long c1, c2;
+
+	c1 = rdtsc();
 
 	/* If host queue is full, we can't process a command
 	 * as a command will likely result in passthrough
@@ -289,6 +293,12 @@ static bool nvme_mdev_io_process_sq(struct io_ctx *ctx, u16 sqid)
 
 		nvme_mdev_vsq_cmd_done_io(ctx->vctrl, sqid, ucid, ret);
 	}
+
+	c2 = rdtsc();
+
+	ctx->vctrl->perf.cmds_started++;
+	ctx->vctrl->perf.cycles_send_to_hw += (c2 - c1);
+
 	return true;
 }
 
@@ -304,6 +314,10 @@ static int nvme_mdev_io_process_hwq(struct io_ctx *ctx, u16 hwq)
 	int n, i;
 	struct nvme_ext_cmd_result res[16];
 
+	unsigned long long c1, c2;
+
+	c1 = rdtsc();
+
 	/* process the completions from the hardware */
 	n = nvme_mdev_hctrl_hq_poll(ctx->hctrl, hwq, res, 16);
 	if (n == -1)
@@ -321,6 +335,13 @@ static int nvme_mdev_io_process_hwq(struct io_ctx *ctx, u16 hwq)
 
 		nvme_mdev_vsq_cmd_done_io(ctx->vctrl, qid, cid, status);
 	}
+
+	if (n > 0) {
+		c2 = rdtsc();
+		ctx->vctrl->perf.cmds_complete += n;
+		ctx->vctrl->perf.cycles_receive_from_hw += (c2 - c1);
+	}
+
 	return n;
 }
 
diff --git a/drivers/nvme/mdev/irq.c b/drivers/nvme/mdev/irq.c
index 5809cdb4d84c..b6010a69b584 100644
--- a/drivers/nvme/mdev/irq.c
+++ b/drivers/nvme/mdev/irq.c
@@ -9,6 +9,7 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include "priv.h"
+#include <asm/msr.h>
 
 /* Setup the interrupt subsystem */
 void nvme_mdev_irqs_setup(struct nvme_mdev_vctrl *vctrl)
@@ -253,12 +254,17 @@ void nvme_mdev_irq_cond_trigger(struct nvme_mdev_vctrl *vctrl,
 				unsigned int index)
 {
 	struct nvme_mdev_user_irq *irq = &vctrl->irqs.vecs[index];
+	unsigned long long c1, c2;
 
 	if (irq->irq_pending_cnt == 0)
 		return;
 
 	if (!nvme_mdev_irq_coalesce(vctrl, irq)) {
+		vctrl->perf.interrupts_sent++;
+		c1 = rdtsc();
 		nvme_mdev_irq_trigger(vctrl, index);
+		c2 = rdtsc();
 		nvme_mdev_irq_clear(vctrl, index);
+		vctrl->perf.cycles_irq_delivery += (c2 - c1);
 	}
 }
diff --git a/drivers/nvme/mdev/priv.h b/drivers/nvme/mdev/priv.h
index 9f65e46c1ab2..a11a1842957d 100644
--- a/drivers/nvme/mdev/priv.h
+++ b/drivers/nvme/mdev/priv.h
@@ -245,6 +245,17 @@ struct nvme_mdev_io_region {
 	unsigned int mmap_area_size;
 };
 
+struct nvme_mdev_perf {
+	/* number of IO commands received */
+	unsigned long long cmds_started;
+	unsigned long long cmds_complete;
+	unsigned long long interrupts_sent;
+
+	unsigned long long cycles_send_to_hw;
+	unsigned long long cycles_receive_from_hw;
+	unsigned long long cycles_irq_delivery;
+};
+
 /*Virtual NVME controller state */
 struct nvme_mdev_vctrl {
 	struct kref ref;
@@ -301,6 +312,8 @@ struct nvme_mdev_vctrl {
 	char serial[9];
 
 	bool vctrl_paused; /* true when the host device paused our IO */
+
+	struct nvme_mdev_perf perf;
 };
 
 /* mdev instance type*/
diff --git a/drivers/nvme/mdev/vctrl.c b/drivers/nvme/mdev/vctrl.c
index 87bc7c435c0c..d23b543dfd52 100644
--- a/drivers/nvme/mdev/vctrl.c
+++ b/drivers/nvme/mdev/vctrl.c
@@ -242,6 +242,9 @@ int nvme_mdev_vctrl_open(struct nvme_mdev_vctrl *vctrl)
 
 	nvme_mdev_mmio_open(vctrl);
 	vctrl->inuse = true;
+
+	memset(&vctrl->perf, 0, sizeof(vctrl->perf));
+
 out:
 	mutex_unlock(&vctrl->lock);
 	return ret;
-- 
2.17.2

