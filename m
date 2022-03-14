Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC9E34D8CF0
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 20:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244458AbiCNTtG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 15:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244477AbiCNTtC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 15:49:02 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E5E3EA9F;
        Mon, 14 Mar 2022 12:47:42 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22EJlWCU009785;
        Mon, 14 Mar 2022 19:47:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=I0aFeQ+bOQQ3vSF+hKPDIWFA3lgu6qmCi0ERuCFsuc8=;
 b=f9wE74Avi6g9YvETJSE77/a3LlAIN/x8O0YZWa6WJgyy1S8G3r46gEoJtlfQWWohTYUg
 5qfk3iqR0d1O4KH/MBvnNfsyCZLURgvKpPKOW18+uBDjc3y4FZ3OTr8NvuH94h69W0gN
 pO1Tg7+KHjGxQ+ZfAJl/KOVfPzZSr6NTi7rL2GHdkMJyCrlk5BPecw+gVhlUFMb6TRPj
 7kE39nO0nYFlk64OTrLJt8sspNoCxmFk/7zgvyjtyMGVQAkYzqv+HR8y2wxRCHAbTpo+
 rp5D0MGKFobdfZdm3elMIr822OQuXxm210kTqpWCbg+Mlof7EW8kheTIq8+3F/bt9H/E Yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3et6cw8ngg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:47:34 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22EJlYCl010111;
        Mon, 14 Mar 2022 19:47:34 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3et6cw8nes-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:47:34 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22EJO3lB028424;
        Mon, 14 Mar 2022 19:47:28 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma03wdc.us.ibm.com with ESMTP id 3erk58r8vy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:47:28 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22EJlRFD46137750
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Mar 2022 19:47:27 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 81443112061;
        Mon, 14 Mar 2022 19:47:27 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B0EB4112064;
        Mon, 14 Mar 2022 19:47:16 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.32.184])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 14 Mar 2022 19:47:16 +0000 (GMT)
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
Subject: [PATCH v4 14/32] iommu: introduce iommu_domain_alloc_type and the KVM type
Date:   Mon, 14 Mar 2022 15:44:33 -0400
Message-Id: <20220314194451.58266-15-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220314194451.58266-1-mjrosato@linux.ibm.com>
References: <20220314194451.58266-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FqbgoB_dreqMwLEsGhivRnr6l1Gyrrt2
X-Proofpoint-GUID: kAKn5innbR7pNSbCzAeZTnM1Zcc8DNGG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-14_13,2022-03-14_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0 priorityscore=1501
 adultscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0
 mlxlogscore=893 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203140116
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

s390x will introduce an additional domain type that is used for
managing IOMMU owned by KVM.  Define the type here and add an
interface for allocating a specified type vs the default type.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 drivers/iommu/iommu.c |  7 +++++++
 include/linux/iommu.h | 12 ++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index f2c45b85b9fc..8bb57e0e3945 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1976,6 +1976,13 @@ void iommu_domain_free(struct iommu_domain *domain)
 }
 EXPORT_SYMBOL_GPL(iommu_domain_free);
 
+struct iommu_domain *iommu_domain_alloc_type(struct bus_type *bus,
+					     unsigned int t)
+{
+	return __iommu_domain_alloc(bus, t);
+}
+EXPORT_SYMBOL_GPL(iommu_domain_alloc_type);
+
 static int __iommu_attach_device(struct iommu_domain *domain,
 				 struct device *dev)
 {
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 9208eca4b0d1..b427bbb9f387 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -63,6 +63,7 @@ struct iommu_domain_geometry {
 					      implementation              */
 #define __IOMMU_DOMAIN_PT	(1U << 2)  /* Domain is identity mapped   */
 #define __IOMMU_DOMAIN_DMA_FQ	(1U << 3)  /* DMA-API uses flush queue    */
+#define __IOMMU_DOMAIN_KVM	(1U << 4)  /* Domain is controlled by KVM */
 
 /*
  * This are the possible domain-types
@@ -77,6 +78,7 @@ struct iommu_domain_geometry {
  *				  certain optimizations for these domains
  *	IOMMU_DOMAIN_DMA_FQ	- As above, but definitely using batched TLB
  *				  invalidation.
+ *	IOMMU_DOMAIN_KVM	- DMA mappings managed by KVM, used for VMs
  */
 #define IOMMU_DOMAIN_BLOCKED	(0U)
 #define IOMMU_DOMAIN_IDENTITY	(__IOMMU_DOMAIN_PT)
@@ -86,6 +88,8 @@ struct iommu_domain_geometry {
 #define IOMMU_DOMAIN_DMA_FQ	(__IOMMU_DOMAIN_PAGING |	\
 				 __IOMMU_DOMAIN_DMA_API |	\
 				 __IOMMU_DOMAIN_DMA_FQ)
+#define IOMMU_DOMAIN_KVM	(__IOMMU_DOMAIN_PAGING |	\
+				 __IOMMU_DOMAIN_KVM)
 
 struct iommu_domain {
 	unsigned type;
@@ -421,6 +425,8 @@ extern bool iommu_capable(struct bus_type *bus, enum iommu_cap cap);
 extern struct iommu_domain *iommu_domain_alloc(struct bus_type *bus);
 extern struct iommu_group *iommu_group_get_by_id(int id);
 extern void iommu_domain_free(struct iommu_domain *domain);
+extern struct iommu_domain *iommu_domain_alloc_type(struct bus_type *bus,
+						    unsigned int t);
 extern int iommu_attach_device(struct iommu_domain *domain,
 			       struct device *dev);
 extern void iommu_detach_device(struct iommu_domain *domain,
@@ -708,6 +714,12 @@ static inline void iommu_domain_free(struct iommu_domain *domain)
 {
 }
 
+static inline struct iommu_domain *iommu_domain_alloc_type(struct bus_type *bus,
+							   unsigned int t)
+{
+	return NULL;
+}
+
 static inline int iommu_attach_device(struct iommu_domain *domain,
 				      struct device *dev)
 {
-- 
2.27.0

