Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B25C9154E18
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 22:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbgBFVim (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 16:38:42 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21206 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727443AbgBFVid (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Feb 2020 16:38:33 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 016LaTLM088644
        for <kvm@vger.kernel.org>; Thu, 6 Feb 2020 16:38:33 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y0n7gm14r-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2020 16:38:32 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Thu, 6 Feb 2020 21:38:30 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 6 Feb 2020 21:38:28 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 016LcQYv31523082
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Feb 2020 21:38:26 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 48501A4065;
        Thu,  6 Feb 2020 21:38:26 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3707EA4062;
        Thu,  6 Feb 2020 21:38:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  6 Feb 2020 21:38:26 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id A7A43E0264; Thu,  6 Feb 2020 22:38:25 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [RFC PATCH v2 1/9] vfio-ccw: Introduce new helper functions to free/destroy regions
Date:   Thu,  6 Feb 2020 22:38:17 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200206213825.11444-1-farman@linux.ibm.com>
References: <20200206213825.11444-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20020621-0008-0000-0000-000003506F12
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020621-0009-0000-0000-00004A710457
Message-Id: <20200206213825.11444-2-farman@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-06_04:2020-02-06,2020-02-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 adultscore=0 suspectscore=2 priorityscore=1501 malwarescore=0 phishscore=0
 mlxscore=0 clxscore=1015 spamscore=0 mlxlogscore=755 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002060157
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
index e401a3d0aa57..91989269faf1 100644
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
@@ -176,10 +184,7 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
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
@@ -195,8 +200,7 @@ static int vfio_ccw_sch_remove(struct subchannel *sch)
 
 	dev_set_drvdata(&sch->dev, NULL);
 
-	kmem_cache_free(vfio_ccw_cmd_region, private->cmd_region);
-	kmem_cache_free(vfio_ccw_io_region, private->io_region);
+	vfio_ccw_free_regions(private);
 	kfree(private->cp.guest_cp);
 	kfree(private);
 
@@ -299,6 +303,12 @@ static void vfio_ccw_debug_exit(void)
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
@@ -341,8 +351,7 @@ static int __init vfio_ccw_sch_init(void)
 	return ret;
 
 out_err:
-	kmem_cache_destroy(vfio_ccw_cmd_region);
-	kmem_cache_destroy(vfio_ccw_io_region);
+	vfio_ccw_destroy_regions();
 	destroy_workqueue(vfio_ccw_work_q);
 	vfio_ccw_debug_exit();
 	return ret;
@@ -352,8 +361,7 @@ static void __exit vfio_ccw_sch_exit(void)
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

