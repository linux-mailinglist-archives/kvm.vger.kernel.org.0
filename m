Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6EFF6BD9C6
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 21:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbjCPUDM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 16:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbjCPUDH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 16:03:07 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B0E837729
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 13:02:46 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32GJcsG8007167;
        Thu, 16 Mar 2023 20:02:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=dFtj/aRGKPao9dR6yCqnTW7Z0VF2q85l8yvy9JZgHLo=;
 b=QK36dW1K2KwGLlZvY4SFQU2IUyiyJIIc0+6gNGrtR2/oeIXvJQ6u4sf/h+h5QUqTKZFt
 /2In0XOqrW+0gKo8c2HYRxB+EZ9o1zPjadWjPoxfNEeJv0p5gqvz6JWiZ21Nt6z5hPUl
 aMbXBMEv4DGCFeVEyjShdhafAZmWFWIohRCiHx5GPLST/wxdyklKzSRJuvTnChW+ejwa
 oZrpTZYj7lW/vrfy0/wWj2c9LlzKAAEi9yeDI5iKT2fmecrBvfaOazVA9oR9lV4c7oFK
 eF7edD3XUrLQLlJScfwKpl9k2X/7zcxw6sj1NanvUiQlxKXkYSsKsIPlbPQKMojF68Ml iA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pbs29t4b3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 20:02:35 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32GJUWWB020752;
        Thu, 16 Mar 2023 20:02:35 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pbq46u627-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 20:02:34 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32GK2TMP028656;
        Thu, 16 Mar 2023 20:02:34 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-172-105.vpn.oracle.com [10.175.172.105])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3pbq46u5v8-3;
        Thu, 16 Mar 2023 20:02:34 +0000
From:   Joao Martins <joao.m.martins@oracle.com>
To:     iommu@lists.linux.dev
Cc:     Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Vasant Hegde <vasant.hegde@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        kvm@vger.kernel.org, Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH v2 2/2] iommu/amd: Handle GALog overflows
Date:   Thu, 16 Mar 2023 20:02:19 +0000
Message-Id: <20230316200219.42673-3-joao.m.martins@oracle.com>
In-Reply-To: <20230316200219.42673-1-joao.m.martins@oracle.com>
References: <20230316200219.42673-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-16_13,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 suspectscore=0 spamscore=0 malwarescore=0 mlxlogscore=862 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303160152
X-Proofpoint-GUID: 2y6Gi5_rS4Ij3E0lxnDdzlbjaihu9AKS
X-Proofpoint-ORIG-GUID: 2y6Gi5_rS4Ij3E0lxnDdzlbjaihu9AKS
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

GALog exists to propagate interrupts into all vCPUs in the system when
interrupts are marked as non running (e.g. when vCPUs aren't running). A
GALog overflow happens when there's in no space in the log to record the
GATag of the interrupt. So when the GALOverflow condition happens, the
GALog queue is processed and the GALog is restarted, as the IOMMU
manual indicates in section "2.7.4 Guest Virtual APIC Log Restart
Procedure":

| * Wait until MMIO Offset 2020h[GALogRun]=0b so that all request
|   entries are completed as circumstances allow. GALogRun must be 0b to
|   modify the guest virtual APIC log registers safely.
| * Write MMIO Offset 0018h[GALogEn]=0b.
| * As necessary, change the following values (e.g., to relocate or
| resize the guest virtual APIC event log):
|   - the Guest Virtual APIC Log Base Address Register
|      [MMIO Offset 00E0h],
|   - the Guest Virtual APIC Log Head Pointer Register
|      [MMIO Offset 2040h][GALogHead], and
|   - the Guest Virtual APIC Log Tail Pointer Register
|      [MMIO Offset 2048h][GALogTail].
| * Write MMIO Offset 2020h[GALOverflow] = 1b to clear the bit (W1C).
| * Write MMIO Offset 0018h[GALogEn] = 1b, and either set
|   MMIO Offset 0018h[GAIntEn] to enable the GA log interrupt or clear
|   the bit to disable it.

Failing to handle the GALog overflow means that none of the VFs (in any
guest) will work with IOMMU AVIC forcing the user to power cycle the
host. When handling the event it resumes the GALog without resizing
much like how it is done in the event handler overflow. The
[MMIO Offset 2020h][GALOverflow] bit might be set in status register
without the [MMIO Offset 2020h][GAInt] bit, so when deciding to poll
for GA events (to clear space in the galog), also check the overflow
bit.

[suravee: Check for GAOverflow without GAInt, toggle CONTROL_GAINT_EN]
Co-developed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 drivers/iommu/amd/amd_iommu.h |  1 +
 drivers/iommu/amd/init.c      | 24 ++++++++++++++++++++++++
 drivers/iommu/amd/iommu.c     |  9 ++++++++-
 3 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index c160a332ce33..24c7e6c6c0de 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -15,6 +15,7 @@ extern irqreturn_t amd_iommu_int_thread(int irq, void *data);
 extern irqreturn_t amd_iommu_int_handler(int irq, void *data);
 extern void amd_iommu_apply_erratum_63(struct amd_iommu *iommu, u16 devid);
 extern void amd_iommu_restart_event_logging(struct amd_iommu *iommu);
+extern void amd_iommu_restart_ga_log(struct amd_iommu *iommu);
 extern int amd_iommu_init_devices(void);
 extern void amd_iommu_uninit_devices(void);
 extern void amd_iommu_init_notifier(void);
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 19a46b9f7357..fd487c33b28a 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -751,6 +751,30 @@ void amd_iommu_restart_event_logging(struct amd_iommu *iommu)
 	iommu_feature_enable(iommu, CONTROL_EVT_LOG_EN);
 }
 
+/*
+ * This function restarts event logging in case the IOMMU experienced
+ * an GA log overflow.
+ */
+void amd_iommu_restart_ga_log(struct amd_iommu *iommu)
+{
+	u32 status;
+
+	status = readl(iommu->mmio_base + MMIO_STATUS_OFFSET);
+	if (status & MMIO_STATUS_GALOG_RUN_MASK)
+		return;
+
+	pr_info_ratelimited("IOMMU GA Log restarting\n");
+
+	iommu_feature_disable(iommu, CONTROL_GALOG_EN);
+	iommu_feature_disable(iommu, CONTROL_GAINT_EN);
+
+	writel(MMIO_STATUS_GALOG_OVERFLOW_MASK,
+	       iommu->mmio_base + MMIO_STATUS_OFFSET);
+
+	iommu_feature_enable(iommu, CONTROL_GAINT_EN);
+	iommu_feature_enable(iommu, CONTROL_GALOG_EN);
+}
+
 /*
  * This function resets the command buffer if the IOMMU stopped fetching
  * commands from it.
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index bf3ebc9d6cde..ebb155bfef15 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -845,6 +845,7 @@ amd_iommu_set_pci_msi_domain(struct device *dev, struct amd_iommu *iommu) { }
 	(MMIO_STATUS_EVT_OVERFLOW_INT_MASK | \
 	 MMIO_STATUS_EVT_INT_MASK | \
 	 MMIO_STATUS_PPR_INT_MASK | \
+	 MMIO_STATUS_GALOG_OVERFLOW_MASK | \
 	 MMIO_STATUS_GALOG_INT_MASK)
 
 irqreturn_t amd_iommu_int_thread(int irq, void *data)
@@ -868,10 +869,16 @@ irqreturn_t amd_iommu_int_thread(int irq, void *data)
 		}
 
 #ifdef CONFIG_IRQ_REMAP
-		if (status & MMIO_STATUS_GALOG_INT_MASK) {
+		if (status & (MMIO_STATUS_GALOG_INT_MASK |
+			      MMIO_STATUS_GALOG_OVERFLOW_MASK)) {
 			pr_devel("Processing IOMMU GA Log\n");
 			iommu_poll_ga_log(iommu);
 		}
+
+		if (status & MMIO_STATUS_GALOG_OVERFLOW_MASK) {
+			pr_info_ratelimited("IOMMU GA Log overflow\n");
+			amd_iommu_restart_ga_log(iommu);
+		}
 #endif
 
 		if (status & MMIO_STATUS_EVT_OVERFLOW_INT_MASK) {
-- 
2.17.2

