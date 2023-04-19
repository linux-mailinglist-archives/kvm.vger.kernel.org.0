Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC7A66E826F
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 22:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbjDSUMd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 16:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbjDSUMc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 16:12:32 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33787E60
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 13:12:31 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33JJnOd5031006;
        Wed, 19 Apr 2023 20:12:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=XKIy0ZBTdMOaNjP7Zjq9MLxDS1roUT1I1gMca7iGeiQ=;
 b=abGylF+Fp4mIU17T7BP5Tm76cWXdRTzzLe+p0H0CgHYbIE+1f27toCnSkbPZfW/CbHyc
 u9pocbt8bSN6PyPLa4tS3Hb31W8oZjoZrNdyZMmvM8D0KZouRt0tv1VXchllT+8n+FdE
 yX3nbbX6c2b/K8H8+l+HcVsX3YI+sind2XnEBpESbt1F4AOLu5mXr6ayv6+Bhx2+40fu
 alFb/A7P8DqUEbnF3Onv5v+eIltnjLKHxglduMpkKHH7gCKWsPmAJNr/QIoucZJun61b
 VTOScYyeGhZ8cd18vYFvjtDiuHfLtKHIOA3h5uEAKmStCfl5bDPTcXEqNMnVcG43UOOr HA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pyjh1sach-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Apr 2023 20:12:15 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33JJOhfH011088;
        Wed, 19 Apr 2023 20:12:14 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pyjc6wx2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Apr 2023 20:12:14 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33JKC8Qk016607;
        Wed, 19 Apr 2023 20:12:14 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-164-99.vpn.oracle.com [10.175.164.99])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3pyjc6wwxu-3;
        Wed, 19 Apr 2023 20:12:13 +0000
From:   Joao Martins <joao.m.martins@oracle.com>
To:     iommu@lists.linux.dev
Cc:     Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Vasant Hegde <vasant.hegde@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        kvm@vger.kernel.org, Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH v3 2/2] iommu/amd: Handle GALog overflows
Date:   Wed, 19 Apr 2023 21:11:54 +0100
Message-Id: <20230419201154.83880-3-joao.m.martins@oracle.com>
In-Reply-To: <20230419201154.83880-1-joao.m.martins@oracle.com>
References: <20230419201154.83880-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-19_14,2023-04-18_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxlogscore=826 mlxscore=0 bulkscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304190174
X-Proofpoint-GUID: JnDwv9Twbubi9AlrymirBedpNvX60kWd
X-Proofpoint-ORIG-GUID: JnDwv9Twbubi9AlrymirBedpNvX60kWd
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
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
index fbe77ee2d26c..b6f52f5529eb 100644
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

