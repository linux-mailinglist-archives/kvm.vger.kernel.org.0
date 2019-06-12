Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDEF4239B
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 13:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438164AbfFLLNL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 07:13:11 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37328 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437983AbfFLLNL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Jun 2019 07:13:11 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5CB9jwo036289
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2019 07:13:10 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t2yn2t3vu-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2019 07:13:10 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Wed, 12 Jun 2019 12:13:07 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 12 Jun 2019 12:13:03 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5CBD1AM42205360
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jun 2019 11:13:01 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA1E042047;
        Wed, 12 Jun 2019 11:13:01 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA1A842045;
        Wed, 12 Jun 2019 11:13:00 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 12 Jun 2019 11:13:00 +0000 (GMT)
From:   Halil Pasic <pasic@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        Sebastian Ott <sebott@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        "Jason J. Herne" <jjherne@linux.ibm.com>
Subject: [PATCH v5 2/8] s390/cio: introduce DMA pools to cio
Date:   Wed, 12 Jun 2019 13:12:30 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190612111236.99538-1-pasic@linux.ibm.com>
References: <20190612111236.99538-1-pasic@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19061211-0020-0000-0000-000003496FD5
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061211-0021-0000-0000-0000219C9FED
Message-Id: <20190612111236.99538-3-pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-12_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906120078
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To support protected virtualization cio will need to make sure the
memory used for communication with the hypervisor is DMA memory.

Let us introduce one global pool for cio.

Our DMA pools are implemented as a gen_pool backed with DMA pages. The
idea is to avoid each allocation effectively wasting a page, as we
typically allocate much less than PAGE_SIZE.

Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Reviewed-by: Sebastian Ott <sebott@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 arch/s390/Kconfig           |   1 +
 arch/s390/include/asm/cio.h |  11 +++
 drivers/s390/cio/css.c      | 133 ++++++++++++++++++++++++++++++++++--
 3 files changed, 141 insertions(+), 4 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 88d8355b7bf7..2a245b56db8b 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -191,6 +191,7 @@ config S390
 	select ARCH_HAS_SCALED_CPUTIME
 	select HAVE_NMI
 	select SWIOTLB
+	select GENERIC_ALLOCATOR
 
 
 config SCHED_OMIT_FRAME_POINTER
diff --git a/arch/s390/include/asm/cio.h b/arch/s390/include/asm/cio.h
index 1727180e8ca1..58e7db912c30 100644
--- a/arch/s390/include/asm/cio.h
+++ b/arch/s390/include/asm/cio.h
@@ -7,6 +7,7 @@
 
 #include <linux/spinlock.h>
 #include <linux/bitops.h>
+#include <linux/genalloc.h>
 #include <asm/types.h>
 
 #define LPM_ANYPATH 0xff
@@ -328,6 +329,16 @@ static inline u8 pathmask_to_pos(u8 mask)
 void channel_subsystem_reinit(void);
 extern void css_schedule_reprobe(void);
 
+extern void *cio_dma_zalloc(size_t size);
+extern void cio_dma_free(void *cpu_addr, size_t size);
+extern struct device *cio_get_dma_css_dev(void);
+
+void *cio_gp_dma_zalloc(struct gen_pool *gp_dma, struct device *dma_dev,
+			size_t size);
+void cio_gp_dma_free(struct gen_pool *gp_dma, void *cpu_addr, size_t size);
+void cio_gp_dma_destroy(struct gen_pool *gp_dma, struct device *dma_dev);
+struct gen_pool *cio_gp_dma_create(struct device *dma_dev, int nr_pages);
+
 /* Function from drivers/s390/cio/chsc.c */
 int chsc_sstpc(void *page, unsigned int op, u16 ctrl, u64 *clock_delta);
 int chsc_sstpi(void *page, void *result, size_t size);
diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index aea502922646..e0f19f1e82a0 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -20,6 +20,8 @@
 #include <linux/reboot.h>
 #include <linux/suspend.h>
 #include <linux/proc_fs.h>
+#include <linux/genalloc.h>
+#include <linux/dma-mapping.h>
 #include <asm/isc.h>
 #include <asm/crw.h>
 
@@ -224,6 +226,12 @@ struct subchannel *css_alloc_subchannel(struct subchannel_id schid,
 	INIT_WORK(&sch->todo_work, css_sch_todo);
 	sch->dev.release = &css_subchannel_release;
 	device_initialize(&sch->dev);
+	/*
+	 * The physical addresses of some the dma structures that can
+	 * belong to a subchannel need to fit 31 bit width (e.g. ccw).
+	 */
+	sch->dev.coherent_dma_mask = DMA_BIT_MASK(31);
+	sch->dev.dma_mask = &sch->dev.coherent_dma_mask;
 	return sch;
 
 err:
@@ -899,6 +907,13 @@ static int __init setup_css(int nr)
 	dev_set_name(&css->device, "css%x", nr);
 	css->device.groups = cssdev_attr_groups;
 	css->device.release = channel_subsystem_release;
+	/*
+	 * We currently allocate notifier bits with this (using
+	 * css->device as the device argument with the DMA API)
+	 * and are fine with 64 bit addresses.
+	 */
+	css->device.coherent_dma_mask = DMA_BIT_MASK(64);
+	css->device.dma_mask = &css->device.coherent_dma_mask;
 
 	mutex_init(&css->mutex);
 	css->cssid = chsc_get_cssid(nr);
@@ -1018,6 +1033,111 @@ static struct notifier_block css_power_notifier = {
 	.notifier_call = css_power_event,
 };
 
+#define  CIO_DMA_GFP (GFP_KERNEL | __GFP_ZERO)
+static struct gen_pool *cio_dma_pool;
+
+/* Currently cio supports only a single css */
+struct device *cio_get_dma_css_dev(void)
+{
+	return &channel_subsystems[0]->device;
+}
+
+struct gen_pool *cio_gp_dma_create(struct device *dma_dev, int nr_pages)
+{
+	struct gen_pool *gp_dma;
+	void *cpu_addr;
+	dma_addr_t dma_addr;
+	int i;
+
+	gp_dma = gen_pool_create(3, -1);
+	if (!gp_dma)
+		return NULL;
+	for (i = 0; i < nr_pages; ++i) {
+		cpu_addr = dma_alloc_coherent(dma_dev, PAGE_SIZE, &dma_addr,
+					      CIO_DMA_GFP);
+		if (!cpu_addr)
+			return gp_dma;
+		gen_pool_add_virt(gp_dma, (unsigned long) cpu_addr,
+				  dma_addr, PAGE_SIZE, -1);
+	}
+	return gp_dma;
+}
+
+static void __gp_dma_free_dma(struct gen_pool *pool,
+			      struct gen_pool_chunk *chunk, void *data)
+{
+	size_t chunk_size = chunk->end_addr - chunk->start_addr + 1;
+
+	dma_free_coherent((struct device *) data, chunk_size,
+			 (void *) chunk->start_addr,
+			 (dma_addr_t) chunk->phys_addr);
+}
+
+void cio_gp_dma_destroy(struct gen_pool *gp_dma, struct device *dma_dev)
+{
+	if (!gp_dma)
+		return;
+	/* this is quite ugly but no better idea */
+	gen_pool_for_each_chunk(gp_dma, __gp_dma_free_dma, dma_dev);
+	gen_pool_destroy(gp_dma);
+}
+
+static int cio_dma_pool_init(void)
+{
+	/* No need to free up the resources: compiled in */
+	cio_dma_pool = cio_gp_dma_create(cio_get_dma_css_dev(), 1);
+	if (!cio_dma_pool)
+		return -ENOMEM;
+	return 0;
+}
+
+void *cio_gp_dma_zalloc(struct gen_pool *gp_dma, struct device *dma_dev,
+			size_t size)
+{
+	dma_addr_t dma_addr;
+	unsigned long addr;
+	size_t chunk_size;
+
+	if (!cio_dma_pool)
+		return NULL;
+	addr = gen_pool_alloc(gp_dma, size);
+	while (!addr) {
+		chunk_size = round_up(size, PAGE_SIZE);
+		addr = (unsigned long) dma_alloc_coherent(dma_dev,
+					 chunk_size, &dma_addr, CIO_DMA_GFP);
+		if (!addr)
+			return NULL;
+		gen_pool_add_virt(gp_dma, addr, dma_addr, chunk_size, -1);
+		addr = gen_pool_alloc(gp_dma, size);
+	}
+	return (void *) addr;
+}
+
+void cio_gp_dma_free(struct gen_pool *gp_dma, void *cpu_addr, size_t size)
+{
+	if (!cpu_addr)
+		return;
+	memset(cpu_addr, 0, size);
+	gen_pool_free(gp_dma, (unsigned long) cpu_addr, size);
+}
+
+/*
+ * Allocate dma memory from the css global pool. Intended for memory not
+ * specific to any single device within the css. The allocated memory
+ * is not guaranteed to be 31-bit addressable.
+ *
+ * Caution: Not suitable for early stuff like console.
+ */
+void *cio_dma_zalloc(size_t size)
+{
+	return cio_gp_dma_zalloc(cio_dma_pool, cio_get_dma_css_dev(), size);
+}
+
+void cio_dma_free(void *cpu_addr, size_t size)
+{
+	cio_gp_dma_free(cio_dma_pool, cpu_addr, size);
+}
+
 /*
  * Now that the driver core is running, we can setup our channel subsystem.
  * The struct subchannel's are created during probing.
@@ -1059,16 +1179,21 @@ static int __init css_bus_init(void)
 	if (ret)
 		goto out_unregister;
 	ret = register_pm_notifier(&css_power_notifier);
-	if (ret) {
-		unregister_reboot_notifier(&css_reboot_notifier);
-		goto out_unregister;
-	}
+	if (ret)
+		goto out_unregister_rn;
+	ret = cio_dma_pool_init();
+	if (ret)
+		goto out_unregister_pmn;
 	css_init_done = 1;
 
 	/* Enable default isc for I/O subchannels. */
 	isc_register(IO_SCH_ISC);
 
 	return 0;
+out_unregister_pmn:
+	unregister_pm_notifier(&css_power_notifier);
+out_unregister_rn:
+	unregister_reboot_notifier(&css_reboot_notifier);
 out_unregister:
 	while (i-- > 0) {
 		struct channel_subsystem *css = channel_subsystems[i];
-- 
2.17.1

