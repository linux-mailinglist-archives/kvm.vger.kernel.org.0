Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98D791506D5
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 14:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728240AbgBCNUE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 08:20:04 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27840 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727358AbgBCNUD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Feb 2020 08:20:03 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 013DFVkA059500
        for <kvm@vger.kernel.org>; Mon, 3 Feb 2020 08:20:02 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xxbx5ykaq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2020 08:20:01 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 013DGJZT063021
        for <kvm@vger.kernel.org>; Mon, 3 Feb 2020 08:20:01 -0500
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xxbx5yk9y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Feb 2020 08:20:01 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 013DFSwU006099;
        Mon, 3 Feb 2020 13:20:00 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma02wdc.us.ibm.com with ESMTP id 2xw0y6108q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Feb 2020 13:20:00 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 013DJwIB39452984
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Feb 2020 13:19:58 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 807DE28058;
        Mon,  3 Feb 2020 13:19:58 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7C82D2806D;
        Mon,  3 Feb 2020 13:19:58 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  3 Feb 2020 13:19:58 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [RFCv2 03/37] s390/protvirt: add ultravisor initialization
Date:   Mon,  3 Feb 2020 08:19:23 -0500
Message-Id: <20200203131957.383915-4-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200203131957.383915-1-borntraeger@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-03_04:2020-02-02,2020-02-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 adultscore=0 bulkscore=0 phishscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 spamscore=0 malwarescore=0 suspectscore=2
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2002030099
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

Before being able to host protected virtual machines, donate some of
the memory to the ultravisor. Besides that the ultravisor might impose
addressing limitations for memory used to back protected VM storage. Treat
that limit as protected virtualization host's virtual memory limit.

Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/include/asm/uv.h | 16 ++++++++++++
 arch/s390/kernel/setup.c   |  3 +++
 arch/s390/kernel/uv.c      | 53 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 72 insertions(+)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 32eac3ab2d3b..cdf2fd71d7ab 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -23,12 +23,14 @@
 #define UVC_RC_NO_RESUME	0x0007
 
 #define UVC_CMD_QUI			0x0001
+#define UVC_CMD_INIT_UV			0x000f
 #define UVC_CMD_SET_SHARED_ACCESS	0x1000
 #define UVC_CMD_REMOVE_SHARED_ACCESS	0x1001
 
 /* Bits in installed uv calls */
 enum uv_cmds_inst {
 	BIT_UVC_CMD_QUI = 0,
+	BIT_UVC_CMD_INIT_UV = 1,
 	BIT_UVC_CMD_SET_SHARED_ACCESS = 8,
 	BIT_UVC_CMD_REMOVE_SHARED_ACCESS = 9,
 };
@@ -59,6 +61,15 @@ struct uv_cb_qui {
 	u64 reserved98;
 } __packed __aligned(8);
 
+struct uv_cb_init {
+	struct uv_cb_header header;
+	u64 reserved08[2];
+	u64 stor_origin;
+	u64 stor_len;
+	u64 reserved28[4];
+
+} __packed __aligned(8);
+
 struct uv_cb_share {
 	struct uv_cb_header header;
 	u64 reserved08[3];
@@ -158,8 +169,13 @@ static inline int is_prot_virt_host(void)
 {
 	return prot_virt_host;
 }
+
+void setup_uv(void);
+void adjust_to_uv_max(unsigned long *vmax);
 #else
 #define is_prot_virt_host() 0
+static inline void setup_uv(void) {}
+static inline void adjust_to_uv_max(unsigned long *vmax) {}
 #endif
 
 #if defined(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) ||                          \
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index f2ab2528859f..5f178d557cc8 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -560,6 +560,8 @@ static void __init setup_memory_end(void)
 			vmax = _REGION1_SIZE; /* 4-level kernel page table */
 	}
 
+	adjust_to_uv_max(&vmax);
+
 	/* module area is at the end of the kernel address space. */
 	MODULES_END = vmax;
 	MODULES_VADDR = MODULES_END - MODULES_LEN;
@@ -1140,6 +1142,7 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	memblock_trim_memory(1UL << (MAX_ORDER - 1 + PAGE_SHIFT));
 
+	setup_uv();
 	setup_memory_end();
 	setup_memory();
 	dma_contiguous_reserve(memory_end);
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 35ce89695509..f7778493e829 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -45,4 +45,57 @@ static int __init prot_virt_setup(char *val)
 	return rc;
 }
 early_param("prot_virt", prot_virt_setup);
+
+static int __init uv_init(unsigned long stor_base, unsigned long stor_len)
+{
+	struct uv_cb_init uvcb = {
+		.header.cmd = UVC_CMD_INIT_UV,
+		.header.len = sizeof(uvcb),
+		.stor_origin = stor_base,
+		.stor_len = stor_len,
+	};
+	int cc;
+
+	cc = uv_call(0, (uint64_t)&uvcb);
+	if (cc || uvcb.header.rc != UVC_RC_EXECUTED) {
+		pr_err("Ultravisor init failed with cc: %d rc: 0x%hx\n", cc,
+		       uvcb.header.rc);
+		return -1;
+	}
+	return 0;
+}
+
+void __init setup_uv(void)
+{
+	unsigned long uv_stor_base;
+
+	if (!prot_virt_host)
+		return;
+
+	uv_stor_base = (unsigned long)memblock_alloc_try_nid(
+		uv_info.uv_base_stor_len, SZ_1M, SZ_2G,
+		MEMBLOCK_ALLOC_ACCESSIBLE, NUMA_NO_NODE);
+	if (!uv_stor_base) {
+		pr_info("Failed to reserve %lu bytes for ultravisor base storage\n",
+			uv_info.uv_base_stor_len);
+		goto fail;
+	}
+
+	if (uv_init(uv_stor_base, uv_info.uv_base_stor_len)) {
+		memblock_free(uv_stor_base, uv_info.uv_base_stor_len);
+		goto fail;
+	}
+
+	pr_info("Reserving %luMB as ultravisor base storage\n",
+		uv_info.uv_base_stor_len >> 20);
+	return;
+fail:
+	prot_virt_host = 0;
+}
+
+void adjust_to_uv_max(unsigned long *vmax)
+{
+	if (prot_virt_host && *vmax > uv_info.max_sec_stor_addr)
+		*vmax = uv_info.max_sec_stor_addr;
+}
 #endif
-- 
2.24.0

