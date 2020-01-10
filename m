Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACA5A13769D
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 20:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728898AbgAJTF6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 14:05:58 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:47810 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728853AbgAJTF5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jan 2020 14:05:57 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00AJ3xrK131913;
        Fri, 10 Jan 2020 19:05:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=KCRuAAvQAwl0rfqZGNTEjq3Xbk+5StxMV3R+zKC6+g8=;
 b=JrPCmplD9EMEh51IfNBg19dXdZpwX0YSrH0fuLXZbPtzBggR1OlVflWX3ojalVgEQ16k
 YfQESJzZDYlOWPMN2sTcqvz9ZXxYTDy32sFop2GrM41KDU3xYuc6wJ6yiPKXXPBApWZT
 xOsCwsJEfeWi1ChoY5o/CkkaxUK7gFzYpGvcUIkqT3p183iiqFmsrAFCTAYZ8Sd5r1IZ
 JgsiPMiCL0pQM/GeOjZQeEhh5n/rinDIpAy8EFAivHI1yoeAOjZ7M6YzFO0woSNnYz/A
 8qPEjY4km8oE0MYe0GaQeAF7E4a/XDEj3UHH1SX8Ln3csinf83vsCblTS8thQ1MHXt3c /w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2xaj4um8jn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jan 2020 19:05:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00AJ3tj7183577;
        Fri, 10 Jan 2020 19:05:31 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2xedhypv58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jan 2020 19:05:31 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00AJ5UBM014974;
        Fri, 10 Jan 2020 19:05:30 GMT
Received: from paddy.uk.oracle.com (/10.175.192.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 10 Jan 2020 11:05:29 -0800
From:   Joao Martins <joao.m.martins@oracle.com>
To:     linux-nvdimm@lists.01.org
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Liran Alon <liran.alon@oracle.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>,
        Barret Rhoden <brho@google.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH RFC 10/10] nvdimm/e820: add multiple namespaces support
Date:   Fri, 10 Jan 2020 19:03:13 +0000
Message-Id: <20200110190313.17144-11-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200110190313.17144-1-joao.m.martins@oracle.com>
References: <20200110190313.17144-1-joao.m.martins@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9496 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001100154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9496 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001100154
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

User can define regions with 'memmap=size!offset' which in turn
creates PMEM legacy devices. But because it is a label-less
NVDIMM device we only have one namespace for the whole device.

Add support for multiple namespaces by adding ndctl control
support, and exposing a minimal set of features:
(ND_CMD_GET_CONFIG_SIZE, ND_CMD_GET_CONFIG_DATA,
ND_CMD_SET_CONFIG_DATA) alongside NDD_ALIASING because we can
store labels.

Initialization is a little different: We allocate and register an
nvdimm bus with an @nvdimm_descriptor which we use to locate
where we are keeping our label storage area. The config data
get/set/size operations are then simply memcpying to this area.

Equivalent approach can also be found in the NFIT tests which
emulate the same thing.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/nvdimm/e820.c | 212 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 191 insertions(+), 21 deletions(-)

diff --git a/drivers/nvdimm/e820.c b/drivers/nvdimm/e820.c
index e02f60ad6c99..36fbff3d7110 100644
--- a/drivers/nvdimm/e820.c
+++ b/drivers/nvdimm/e820.c
@@ -7,14 +7,21 @@
 #include <linux/memory_hotplug.h>
 #include <linux/libnvdimm.h>
 #include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/ndctl.h>
+#include <linux/nd.h>
 
-static int e820_pmem_remove(struct platform_device *pdev)
-{
-	struct nvdimm_bus *nvdimm_bus = platform_get_drvdata(pdev);
+#define LABEL_SIZE SZ_128K
 
-	nvdimm_bus_unregister(nvdimm_bus);
-	return 0;
-}
+struct e820_descriptor {
+	struct nd_interleave_set nd_set;
+	struct nvdimm_bus_descriptor nd_desc;
+	void *label;
+	unsigned char cookie1[16];
+	unsigned char cookie2[16];
+	struct nvdimm_bus *nvdimm_bus;
+	struct nvdimm *nvdimm;
+};
 
 #ifdef CONFIG_MEMORY_HOTPLUG
 static int e820_range_to_nid(resource_size_t addr)
@@ -28,43 +35,206 @@ static int e820_range_to_nid(resource_size_t addr)
 }
 #endif
 
+static int e820_get_config_size(struct nd_cmd_get_config_size *nd_cmd,
+				unsigned int buf_len)
+{
+	if (buf_len < sizeof(*nd_cmd))
+		return -EINVAL;
+
+	nd_cmd->status = 0;
+	nd_cmd->config_size = LABEL_SIZE;
+	nd_cmd->max_xfer = SZ_4K;
+
+	return 0;
+}
+
+static int e820_get_config_data(struct nd_cmd_get_config_data_hdr
+		*nd_cmd, unsigned int buf_len, void *label)
+{
+	unsigned int len, offset = nd_cmd->in_offset;
+	int rc;
+
+	if (buf_len < sizeof(*nd_cmd))
+		return -EINVAL;
+	if (offset >= LABEL_SIZE)
+		return -EINVAL;
+	if (nd_cmd->in_length + sizeof(*nd_cmd) > buf_len)
+		return -EINVAL;
+
+	nd_cmd->status = 0;
+	len = min(nd_cmd->in_length, LABEL_SIZE - offset);
+	memcpy(nd_cmd->out_buf, label + offset, len);
+	rc = buf_len - sizeof(*nd_cmd) - len;
+
+	return rc;
+}
+
+static int e820_set_config_data(struct nd_cmd_set_config_hdr *nd_cmd,
+		unsigned int buf_len, void *label)
+{
+	unsigned int len, offset = nd_cmd->in_offset;
+	u32 *status;
+	int rc;
+
+	if (buf_len < sizeof(*nd_cmd))
+		return -EINVAL;
+	if (offset >= LABEL_SIZE)
+		return -EINVAL;
+	if (nd_cmd->in_length + sizeof(*nd_cmd) + 4 > buf_len)
+		return -EINVAL;
+
+	status = (void *)nd_cmd + nd_cmd->in_length + sizeof(*nd_cmd);
+	*status = 0;
+	len = min(nd_cmd->in_length, LABEL_SIZE - offset);
+	memcpy(label + offset, nd_cmd->in_buf, len);
+	rc = buf_len - sizeof(*nd_cmd) - (len + 4);
+
+	return rc;
+}
+
+static struct e820_descriptor *to_e820_desc(struct nvdimm_bus_descriptor *desc)
+{
+	return container_of(desc, struct e820_descriptor, nd_desc);
+}
+
+static int e820_ndctl(struct nvdimm_bus_descriptor *nd_desc,
+			 struct nvdimm *nvdimm, unsigned int cmd, void *buf,
+			 unsigned int buf_len, int *cmd_rc)
+{
+	struct e820_descriptor *t = to_e820_desc(nd_desc);
+	int rc = -EINVAL;
+
+	switch (cmd) {
+	case ND_CMD_GET_CONFIG_SIZE:
+		rc = e820_get_config_size(buf, buf_len);
+		break;
+	case ND_CMD_GET_CONFIG_DATA:
+		rc = e820_get_config_data(buf, buf_len, t->label);
+		break;
+	case ND_CMD_SET_CONFIG_DATA:
+		rc = e820_set_config_data(buf, buf_len, t->label);
+		break;
+	default:
+		return rc;
+	}
+
+	return rc;
+}
+
+static void e820_desc_free(struct e820_descriptor *desc)
+{
+	if (!desc)
+		return;
+
+	nvdimm_bus_unregister(desc->nvdimm_bus);
+	kfree(desc->label);
+	kfree(desc);
+}
+
+static struct e820_descriptor *e820_desc_alloc(struct platform_device *pdev)
+{
+	struct nvdimm_bus_descriptor *nd_desc;
+	unsigned int cmd_mask, dimm_flags;
+	struct device *dev = &pdev->dev;
+	struct nvdimm_bus *nvdimm_bus;
+	struct e820_descriptor *desc;
+	struct nvdimm *nvdimm;
+
+	desc = kzalloc(sizeof(*desc), GFP_KERNEL);
+	if (!desc)
+		goto err;
+
+	desc->label = kzalloc(LABEL_SIZE, GFP_KERNEL);
+	if (!desc->label)
+		goto err;
+
+	nd_desc = &desc->nd_desc;
+	nd_desc->provider_name = "e820";
+	nd_desc->module = THIS_MODULE;
+	nd_desc->ndctl = e820_ndctl;
+	nvdimm_bus = nvdimm_bus_register(&pdev->dev, nd_desc);
+	if (!nvdimm_bus) {
+		dev_err(dev, "nvdimm bus registration failure\n");
+		goto err;
+	}
+	desc->nvdimm_bus = nvdimm_bus;
+
+	cmd_mask = (1UL << ND_CMD_GET_CONFIG_SIZE |
+			1UL << ND_CMD_GET_CONFIG_DATA |
+			1UL << ND_CMD_SET_CONFIG_DATA);
+	dimm_flags = (1UL << NDD_ALIASING);
+	nvdimm = nvdimm_create(nvdimm_bus, pdev, NULL,
+				dimm_flags, cmd_mask, 0, NULL);
+	if (!nvdimm) {
+		dev_err(dev, "nvdimm creation failure\n");
+		goto err;
+	}
+	desc->nvdimm = nvdimm;
+	return desc;
+
+err:
+	e820_desc_free(desc);
+	return NULL;
+}
+
 static int e820_register_one(struct resource *res, void *data)
 {
+	struct platform_device *pdev = data;
 	struct nd_region_desc ndr_desc;
-	struct nvdimm_bus *nvdimm_bus = data;
+	struct nd_mapping_desc mapping;
+	struct e820_descriptor *desc;
+
+	desc = e820_desc_alloc(pdev);
+	if (!desc)
+		return -ENOMEM;
+
+	mapping.nvdimm = desc->nvdimm;
+	mapping.start = res->start;
+	mapping.size = resource_size(res);
+	mapping.position = 0;
+
+	generate_random_uuid(desc->cookie1);
+	desc->nd_set.cookie1 = (u64) desc->cookie1;
+	generate_random_uuid(desc->cookie2);
+	desc->nd_set.cookie2 = (u64) desc->cookie2;
 
 	memset(&ndr_desc, 0, sizeof(ndr_desc));
 	ndr_desc.res = res;
 	ndr_desc.numa_node = e820_range_to_nid(res->start);
 	ndr_desc.target_node = ndr_desc.numa_node;
+	ndr_desc.mapping = &mapping;
+	ndr_desc.num_mappings = 1;
+	ndr_desc.nd_set = &desc->nd_set;
 	set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
-	if (!nvdimm_pmem_region_create(nvdimm_bus, &ndr_desc))
+	if (!nvdimm_pmem_region_create(desc->nvdimm_bus, &ndr_desc)) {
+		e820_desc_free(desc);
+		dev_err(&pdev->dev, "nvdimm region creation failure\n");
 		return -ENXIO;
+	}
+
+	platform_set_drvdata(pdev, desc);
+	return 0;
+}
+
+static int e820_pmem_remove(struct platform_device *pdev)
+{
+	struct e820_descriptor *desc = platform_get_drvdata(pdev);
+
+	e820_desc_free(desc);
 	return 0;
 }
 
 static int e820_pmem_probe(struct platform_device *pdev)
 {
-	static struct nvdimm_bus_descriptor nd_desc;
-	struct device *dev = &pdev->dev;
-	struct nvdimm_bus *nvdimm_bus;
 	int rc = -ENXIO;
 
-	nd_desc.provider_name = "e820";
-	nd_desc.module = THIS_MODULE;
-	nvdimm_bus = nvdimm_bus_register(dev, &nd_desc);
-	if (!nvdimm_bus)
-		goto err;
-	platform_set_drvdata(pdev, nvdimm_bus);
-
 	rc = walk_iomem_res_desc(IORES_DESC_PERSISTENT_MEMORY_LEGACY,
-			IORESOURCE_MEM, 0, -1, nvdimm_bus, e820_register_one);
+			IORESOURCE_MEM, 0, -1, pdev, e820_register_one);
 	if (rc)
 		goto err;
 	return 0;
 err:
-	nvdimm_bus_unregister(nvdimm_bus);
-	dev_err(dev, "failed to register legacy persistent memory ranges\n");
+	dev_err(&pdev->dev, "failed to register legacy persistent memory ranges\n");
 	return rc;
 }
 
-- 
2.17.1

