Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA374D8CFB
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 20:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244467AbiCNTt0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 15:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244521AbiCNTtV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 15:49:21 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58AD36278;
        Mon, 14 Mar 2022 12:47:50 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22EJlZ1Z003111;
        Mon, 14 Mar 2022 19:47:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Ksdd7DxxFNWLmGfhTqCE0VD/MuNwQK40IksBUvYPClc=;
 b=FsSSWuPyJKfa3pS0YrJs70nLtpBAklNZOOyRR5XVoHn63lsHKLozgqBd4EbvFlEJ/ehr
 TQs6lldnw5UD5stp2sUMusgYL7+0gDNxelY0UHVlcsuNTYr3WU/i7QzVCq65ihpxuZbi
 xSQNcKDEBpxvD4Y333dmQqeuyiQvNIQPSeiiFbKyTbG/mnMPy2+S06Lf8kFApjc0sTWI
 dgiHxMIv5/WuFUH4OBKAwBx3iuENP2TKjAhTFN13z59sBcXKXQnhnGWc8yOo9eIJo4DB
 uP+McpFWJBMkOBV4m4QrBl0CWVzyKWMOPgS0/ctW/lSp5quDRoWAJQOVZuXkzLA+DaGD vQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3et6ah91a4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:47:42 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22EJlVqK002755;
        Mon, 14 Mar 2022 19:47:42 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3et6ah919m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:47:42 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22EJO3lJ028424;
        Mon, 14 Mar 2022 19:47:40 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma03wdc.us.ibm.com with ESMTP id 3erk58r8y1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:47:40 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22EJld8V13500796
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Mar 2022 19:47:39 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3238D112062;
        Mon, 14 Mar 2022 19:47:39 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29328112061;
        Mon, 14 Mar 2022 19:47:28 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.32.184])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 14 Mar 2022 19:47:27 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, joro@8bytes.org, will@kernel.org,
        pbonzini@redhat.com, corbet@lwn.net, jgg@nvidia.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-doc@vger.kernel.org
Subject: [PATCH v4 15/32] vfio: introduce KVM-owned IOMMU type
Date:   Mon, 14 Mar 2022 15:44:34 -0400
Message-Id: <20220314194451.58266-16-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220314194451.58266-1-mjrosato@linux.ibm.com>
References: <20220314194451.58266-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5awA5dt3n-nXJaPMJqYw98jQ7rszlsYh
X-Proofpoint-ORIG-GUID: Fz_6isyi-Wa9_NcqlAPSCxnLH21O5kC2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-14_13,2022-03-14_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=748 phishscore=0 spamscore=0
 malwarescore=0 impostorscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203140116
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

s390x will introduce a new IOMMU domain type where the mappings are
managed by KVM rather than in response to userspace mapping ioctls.  Allow
for specifying this type on the VFIO_SET_IOMMU ioctl and triggering the
appropriate iommu interface for overriding the default domain.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 drivers/vfio/vfio_iommu_type1.c | 12 +++++++++++-
 include/uapi/linux/vfio.h       |  6 ++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 9394aa9444c1..0bec97077d61 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -77,6 +77,7 @@ struct vfio_iommu {
 	bool			nesting;
 	bool			dirty_page_tracking;
 	bool			container_open;
+	bool			kvm;
 	struct list_head	emulated_iommu_groups;
 };
 
@@ -2203,7 +2204,12 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 		goto out_free_group;
 
 	ret = -EIO;
-	domain->domain = iommu_domain_alloc(bus);
+
+	if (iommu->kvm)
+		domain->domain = iommu_domain_alloc_type(bus, IOMMU_DOMAIN_KVM);
+	else
+		domain->domain = iommu_domain_alloc(bus);
+
 	if (!domain->domain)
 		goto out_free_domain;
 
@@ -2552,6 +2558,9 @@ static void *vfio_iommu_type1_open(unsigned long arg)
 	case VFIO_TYPE1v2_IOMMU:
 		iommu->v2 = true;
 		break;
+	case VFIO_KVM_IOMMU:
+		iommu->kvm = true;
+		break;
 	default:
 		kfree(iommu);
 		return ERR_PTR(-EINVAL);
@@ -2637,6 +2646,7 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
 	case VFIO_TYPE1_NESTING_IOMMU:
 	case VFIO_UNMAP_ALL:
 	case VFIO_UPDATE_VADDR:
+	case VFIO_KVM_IOMMU:
 		return 1;
 	case VFIO_DMA_CC_IOMMU:
 		if (!iommu)
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index ef33ea002b0b..666edb6957ac 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -52,6 +52,12 @@
 /* Supports the vaddr flag for DMA map and unmap */
 #define VFIO_UPDATE_VADDR		10
 
+/*
+ * The KVM_IOMMU type implies that the hypervisor will control the mappings
+ * rather than userspace
+ */
+#define VFIO_KVM_IOMMU			11
+
 /*
  * The IOCTL interface is designed for extensibility by embedding the
  * structure length (argsz) and flags into structures passed between
-- 
2.27.0

