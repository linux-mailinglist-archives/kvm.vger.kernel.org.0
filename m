Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABAB61AD47C
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 04:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729336AbgDQCaL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 22:30:11 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25400 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729306AbgDQCaJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Apr 2020 22:30:09 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03H23LTp129679
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 22:30:09 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30f37agprb-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 16 Apr 2020 22:30:08 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Fri, 17 Apr 2020 03:30:01 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 17 Apr 2020 03:29:59 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03H2U2vZ48562372
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 02:30:02 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3300D5204E;
        Fri, 17 Apr 2020 02:30:02 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 209C652050;
        Fri, 17 Apr 2020 02:30:02 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id B0F7DE0271; Fri, 17 Apr 2020 04:30:01 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     linux-s390@vger.kernel.org, kvm@vger.kernel.org
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v3 1/8] vfio-ccw: Introduce new helper functions to free/destroy regions
Date:   Fri, 17 Apr 2020 04:29:54 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200417023001.65006-1-farman@linux.ibm.com>
References: <20200417023001.65006-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20041702-0028-0000-0000-000003F9A44D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20041702-0029-0000-0000-000024BF5C8F
Message-Id: <20200417023001.65006-2-farman@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-16_10:2020-04-14,2020-04-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 impostorscore=0 adultscore=0 priorityscore=1501 mlxlogscore=741
 suspectscore=2 malwarescore=0 lowpriorityscore=0 phishscore=0 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004170014
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Farhan Ali <alifm@linux.ibm.com>

Consolidate some of the cleanup code for the regions, so that
as more are added we reduce code duplication.

Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---

Notes:
    v1->v2:
     - Add Conny's r-b
    
    v0->v1: [EF]
     - Commit message

 drivers/s390/cio/vfio_ccw_drv.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 339a6bc0339b..8715c1c2f1e1 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -116,6 +116,14 @@ static void vfio_ccw_sch_irq(struct subchannel *sch)
 	vfio_ccw_fsm_event(private, VFIO_CCW_EVENT_INTERRUPT);
 }
 
+static void vfio_ccw_free_regions(struct vfio_ccw_private *private)
+{
+	if (private->cmd_region)
+		kmem_cache_free(vfio_ccw_cmd_region, private->cmd_region);
+	if (private->io_region)
+		kmem_cache_free(vfio_ccw_io_region, private->io_region);
+}
+
 static int vfio_ccw_sch_probe(struct subchannel *sch)
 {
 	struct pmcw *pmcw = &sch->schib.pmcw;
@@ -181,10 +189,7 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
 	cio_disable_subchannel(sch);
 out_free:
 	dev_set_drvdata(&sch->dev, NULL);
-	if (private->cmd_region)
-		kmem_cache_free(vfio_ccw_cmd_region, private->cmd_region);
-	if (private->io_region)
-		kmem_cache_free(vfio_ccw_io_region, private->io_region);
+	vfio_ccw_free_regions(private);
 	kfree(private->cp.guest_cp);
 	kfree(private);
 	return ret;
@@ -200,8 +205,7 @@ static int vfio_ccw_sch_remove(struct subchannel *sch)
 
 	dev_set_drvdata(&sch->dev, NULL);
 
-	kmem_cache_free(vfio_ccw_cmd_region, private->cmd_region);
-	kmem_cache_free(vfio_ccw_io_region, private->io_region);
+	vfio_ccw_free_regions(private);
 	kfree(private->cp.guest_cp);
 	kfree(private);
 
@@ -304,6 +308,12 @@ static void vfio_ccw_debug_exit(void)
 	debug_unregister(vfio_ccw_debug_trace_id);
 }
 
+static void vfio_ccw_destroy_regions(void)
+{
+	kmem_cache_destroy(vfio_ccw_cmd_region);
+	kmem_cache_destroy(vfio_ccw_io_region);
+}
+
 static int __init vfio_ccw_sch_init(void)
 {
 	int ret;
@@ -346,8 +356,7 @@ static int __init vfio_ccw_sch_init(void)
 	return ret;
 
 out_err:
-	kmem_cache_destroy(vfio_ccw_cmd_region);
-	kmem_cache_destroy(vfio_ccw_io_region);
+	vfio_ccw_destroy_regions();
 	destroy_workqueue(vfio_ccw_work_q);
 	vfio_ccw_debug_exit();
 	return ret;
@@ -357,8 +366,7 @@ static void __exit vfio_ccw_sch_exit(void)
 {
 	css_driver_unregister(&vfio_ccw_sch_driver);
 	isc_unregister(VFIO_CCW_ISC);
-	kmem_cache_destroy(vfio_ccw_io_region);
-	kmem_cache_destroy(vfio_ccw_cmd_region);
+	vfio_ccw_destroy_regions();
 	destroy_workqueue(vfio_ccw_work_q);
 	vfio_ccw_debug_exit();
 }
-- 
2.17.1

