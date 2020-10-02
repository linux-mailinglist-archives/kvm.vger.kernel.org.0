Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94C72281C8E
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 22:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725785AbgJBUGx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 16:06:53 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22858 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725786AbgJBUGw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Oct 2020 16:06:52 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 092K3LNe012048;
        Fri, 2 Oct 2020 16:06:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=e+SGbm7cj2gyvu7uJ/UfzF/L24O5PtO52HK/7KtT950=;
 b=Uph0el6icI4BrBDcEWOfuzAKeTeLA1vvfKkLdafGMOOf8BTT7aKi+nEdSx8jDeJL2UI1
 RZgItUnmWSIsRoKhUdvQN6uf0JrFBevAOBsJ56CtfgH7MCmhkPf0YJDMYFfP0R/Euf4G
 +w5iuAUR2URwhjZhoMhfvQA77/m7swaKvun8Esp7teivOSgR7t1YFvfSuy2ScbU+JzoZ
 DXixFOxnTNcK9Mg8ZWU2iRaNZsX3xgdiEF2wzM/7cUGohkzwvI+Ar6FPcjYRhU5mDgEz
 Q3MefJ9aAcCY67QAN09EyQymlzMV8CEffa/2NR9ACQ9T0sk7osgUG8wtXSpZwZOgOPgQ Ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33xasvr7uf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 16:06:44 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 092K3LAG012111;
        Fri, 2 Oct 2020 16:06:43 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33xasvr7u0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 16:06:43 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 092JlCpx011313;
        Fri, 2 Oct 2020 20:06:42 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma01dal.us.ibm.com with ESMTP id 33sw9aecax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 20:06:42 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 092K6bKR64684296
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Oct 2020 20:06:37 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 274FABE054;
        Fri,  2 Oct 2020 20:06:41 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB90BBE04F;
        Fri,  2 Oct 2020 20:06:39 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.4.25])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  2 Oct 2020 20:06:39 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     cohuck@redhat.com, thuth@redhat.com
Cc:     pmorel@linux.ibm.com, schnelle@linux.ibm.com, rth@twiddle.net,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@de.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, alex.williamson@redhat.com,
        qemu-s390x@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [PATCH v2 4/9] linux-headers: update against 5.9-rc7
Date:   Fri,  2 Oct 2020 16:06:26 -0400
Message-Id: <1601669191-6731-5-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1601669191-6731-1-git-send-email-mjrosato@linux.ibm.com>
References: <1601669191-6731-1-git-send-email-mjrosato@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-02_14:2020-10-02,2020-10-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 suspectscore=0 phishscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 mlxlogscore=999
 clxscore=1015 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020145
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PLACEHOLDER as the kernel patch driving the need for this ("vfio-pci/zdev:
define the vfio_zdev header") isn't merged yet.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 .../drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h         | 14 +++++++-------
 linux-headers/linux/kvm.h                                  |  6 ++++--
 linux-headers/linux/vfio.h                                 |  5 +++++
 3 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/include/standard-headers/drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h b/include/standard-headers/drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h
index 7b4062a..acd4c83 100644
--- a/include/standard-headers/drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h
+++ b/include/standard-headers/drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h
@@ -68,7 +68,7 @@ static inline int pvrdma_idx_valid(uint32_t idx, uint32_t max_elems)
 
 static inline int32_t pvrdma_idx(int *var, uint32_t max_elems)
 {
-	const unsigned int idx = qatomic_read(var);
+	const unsigned int idx = atomic_read(var);
 
 	if (pvrdma_idx_valid(idx, max_elems))
 		return idx & (max_elems - 1);
@@ -77,17 +77,17 @@ static inline int32_t pvrdma_idx(int *var, uint32_t max_elems)
 
 static inline void pvrdma_idx_ring_inc(int *var, uint32_t max_elems)
 {
-	uint32_t idx = qatomic_read(var) + 1;	/* Increment. */
+	uint32_t idx = atomic_read(var) + 1;	/* Increment. */
 
 	idx &= (max_elems << 1) - 1;		/* Modulo size, flip gen. */
-	qatomic_set(var, idx);
+	atomic_set(var, idx);
 }
 
 static inline int32_t pvrdma_idx_ring_has_space(const struct pvrdma_ring *r,
 					      uint32_t max_elems, uint32_t *out_tail)
 {
-	const uint32_t tail = qatomic_read(&r->prod_tail);
-	const uint32_t head = qatomic_read(&r->cons_head);
+	const uint32_t tail = atomic_read(&r->prod_tail);
+	const uint32_t head = atomic_read(&r->cons_head);
 
 	if (pvrdma_idx_valid(tail, max_elems) &&
 	    pvrdma_idx_valid(head, max_elems)) {
@@ -100,8 +100,8 @@ static inline int32_t pvrdma_idx_ring_has_space(const struct pvrdma_ring *r,
 static inline int32_t pvrdma_idx_ring_has_data(const struct pvrdma_ring *r,
 					     uint32_t max_elems, uint32_t *out_head)
 {
-	const uint32_t tail = qatomic_read(&r->prod_tail);
-	const uint32_t head = qatomic_read(&r->cons_head);
+	const uint32_t tail = atomic_read(&r->prod_tail);
+	const uint32_t head = atomic_read(&r->cons_head);
 
 	if (pvrdma_idx_valid(tail, max_elems) &&
 	    pvrdma_idx_valid(head, max_elems)) {
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 6683e2e..43580c7 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -790,9 +790,10 @@ struct kvm_ppc_resize_hpt {
 #define KVM_VM_PPC_HV 1
 #define KVM_VM_PPC_PR 2
 
-/* on MIPS, 0 forces trap & emulate, 1 forces VZ ASE */
-#define KVM_VM_MIPS_TE		0
+/* on MIPS, 0 indicates auto, 1 forces VZ ASE, 2 forces trap & emulate */
+#define KVM_VM_MIPS_AUTO	0
 #define KVM_VM_MIPS_VZ		1
+#define KVM_VM_MIPS_TE		2
 
 #define KVM_S390_SIE_PAGE_OFFSET 1
 
@@ -1035,6 +1036,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_LAST_CPU 184
 #define KVM_CAP_SMALLER_MAXPHYADDR 185
 #define KVM_CAP_S390_DIAG318 186
+#define KVM_CAP_STEAL_TIME 187
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/linux-headers/linux/vfio.h b/linux-headers/linux/vfio.h
index a906724..68fd67a 100644
--- a/linux-headers/linux/vfio.h
+++ b/linux-headers/linux/vfio.h
@@ -326,6 +326,11 @@ struct vfio_region_info_cap_type {
  * to do TLB invalidation on a GPU.
  */
 #define VFIO_REGION_SUBTYPE_IBM_NVLINK2_ATSD	(1)
+/*
+ * IBM zPCI specific hardware feature information for a devcie.  The contents
+ * of this region are mapped by struct vfio_region_zpci_info.
+ */
+#define VFIO_REGION_SUBTYPE_IBM_ZPCI_CLP	(2)
 
 /* sub-types for VFIO_REGION_TYPE_GFX */
 #define VFIO_REGION_SUBTYPE_GFX_EDID            (1)
-- 
1.8.3.1

