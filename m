Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 772732DCD3
	for <lists+kvm@lfdr.de>; Wed, 29 May 2019 14:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbfE2M1J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 May 2019 08:27:09 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35558 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727231AbfE2M1I (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 May 2019 08:27:08 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4TCOOoB094717
        for <kvm@vger.kernel.org>; Wed, 29 May 2019 08:27:08 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ssre1cbuc-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 29 May 2019 08:27:07 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <mimu@linux.ibm.com>;
        Wed, 29 May 2019 13:27:05 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 29 May 2019 13:27:02 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4TCR0i254722756
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 May 2019 12:27:00 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4EDD44C050;
        Wed, 29 May 2019 12:27:00 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C26894C044;
        Wed, 29 May 2019 12:26:59 +0000 (GMT)
Received: from s38lp84.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 29 May 2019 12:26:59 +0000 (GMT)
From:   Michael Mueller <mimu@linux.ibm.com>
To:     KVM Mailing List <kvm@vger.kernel.org>,
        Linux-S390 Mailing List <linux-s390@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Sebastian Ott <sebott@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>
Subject: [PATCH v3 2/8] s390/cio: introduce DMA pools to cio
Date:   Wed, 29 May 2019 14:26:51 +0200
X-Mailer: git-send-email 2.13.4
In-Reply-To: <20190529122657.166148-1-mimu@linux.ibm.com>
References: <20190529122657.166148-1-mimu@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19052912-0008-0000-0000-000002EB93ED
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19052912-0009-0000-0000-0000225864BE
Message-Id: <20190529122657.166148-3-mimu@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-29_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905290082
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Halil Pasic <pasic@linux.ibm.com>

To support protected virtualization cio will need to make sure the
memory used for communication with the hypervisor is DMA memory.

Let us introduce one global pool for cio.

Our DMA pools are implemented as a gen_pool backed with DMA pages. The
idea is to avoid each allocation effectively wasting a page, as we
typically allocate much less than PAGE_SIZE.

Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Reviewed-by: Sebastian Ott <sebott@linux.ibm.com>
Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
---
 arch/s390/Kconfig           |   1 +
 arch/s390/include/asm/cio.h |  11 ++++
 drivers/s390/cio/css.c      | 120 ++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 128 insertions(+), 4 deletions(-)

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
index 1727180e8ca1..43c007d2775a 100644
--- a/arch/s390/include/asm/cio.h
+++ b/arch/s390/include/asm/cio.h
@@ -328,6 +328,17 @@ static inline u8 pathmask_to_pos(u8 mask)
 void channel_subsystem_reinit(void);
 extern void css_schedule_reprobe(void);
 
+extern void *cio_dma_zalloc(size_t size);
+extern void cio_dma_free(void *cpu_addr, size_t size);
+extern struct device *cio_get_dma_css_dev(void);
+
+struct gen_pool;
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
index aea502922646..b97618497848 100644
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
 
@@ -224,6 +226,8 @@ struct subchannel *css_alloc_subchannel(struct subchannel_id schid,
 	INIT_WORK(&sch->todo_work, css_sch_todo);
 	sch->dev.release = &css_subchannel_release;
 	device_initialize(&sch->dev);
+	sch->dev.coherent_dma_mask = DMA_BIT_MASK(31);
+	sch->dev.dma_mask = &sch->dev.coherent_dma_mask;
 	return sch;
 
 err:
@@ -899,6 +903,8 @@ static int __init setup_css(int nr)
 	dev_set_name(&css->device, "css%x", nr);
 	css->device.groups = cssdev_attr_groups;
 	css->device.release = channel_subsystem_release;
+	css->device.coherent_dma_mask = DMA_BIT_MASK(64);
+	css->device.dma_mask = &css->device.coherent_dma_mask;
 
 	mutex_init(&css->mutex);
 	css->cssid = chsc_get_cssid(nr);
@@ -1018,6 +1024,109 @@ static struct notifier_block css_power_notifier = {
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
+	/* this is qite ugly but no better idea */
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
@@ -1059,16 +1168,19 @@ static int __init css_bus_init(void)
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
+		goto out_unregister_rn;
 	css_init_done = 1;
 
 	/* Enable default isc for I/O subchannels. */
 	isc_register(IO_SCH_ISC);
 
 	return 0;
+out_unregister_rn:
+	unregister_reboot_notifier(&css_reboot_notifier);
 out_unregister:
 	while (i-- > 0) {
 		struct channel_subsystem *css = channel_subsystems[i];
-- 
2.13.4

