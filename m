Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0CD6FDD8F
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 14:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236949AbjEJMSd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 08:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236086AbjEJMSb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 08:18:31 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA5A510C;
        Wed, 10 May 2023 05:18:30 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34ABg64u014648;
        Wed, 10 May 2023 12:18:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=3L7qnAz8G30cCWR+DN6YlluAJCDFcaB+9TpKo4Z9VTg=;
 b=NS8S0HCLCF/QJthzh4GwdvzA5gDKp7kRfuOg/xhY+RL9ahrwISjlpZKRWbnJ8+yKYBlR
 RNPYuDJUF3D/Cpf/EVbGvBryfkooU+pQruE5SqpoZxUUFtucpDpXb92tp3HKYsggoeml
 OWzoBF6OVM14yc1SMd4YQ9JtP6Thrafhg3yhfjpdwby/JkZRfRKmYEshcrqzgWoJ4zhp
 jaIP2n7svs1V/Pe6GJOu9Ar/Iccbw7pyHYOnuBjUJRiFbTwqynkEcuMuURZSysztHjFJ
 il3PKEcj0oRcWNzO7f/gNeQiy3JNObvmHkxhEXlpzcgSlz0FEUue87nIG7ZHeY1vJBiz 3A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qgameh53p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 May 2023 12:18:30 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34ACGxoE000846;
        Wed, 10 May 2023 12:18:29 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qgameh52b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 May 2023 12:18:29 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34A4idac003745;
        Wed, 10 May 2023 12:18:27 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3qf7e0ruhp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 May 2023 12:18:26 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34ACINJK25559702
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 May 2023 12:18:23 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73B5020040;
        Wed, 10 May 2023 12:18:23 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A2152004D;
        Wed, 10 May 2023 12:18:23 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 10 May 2023 12:18:23 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v2 1/2] KVM: s390: add stat counter for shadow gmap events
Date:   Wed, 10 May 2023 14:18:21 +0200
Message-Id: <20230510121822.546629-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230510121822.546629-1-nrb@linux.ibm.com>
References: <20230510121822.546629-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: K-GXTKQR0lwiWhELBTa9YLhxpF44Zenr
X-Proofpoint-GUID: Mxrwtf9d1uWWxh_gnA_Z_lV2SMF16BZ2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-10_04,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 bulkscore=0 priorityscore=1501 mlxlogscore=999 impostorscore=0
 phishscore=0 adultscore=0 suspectscore=0 spamscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305100095
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The shadow gmap tracks memory of nested guests (guest-3). In certain
scenarios, the shadow gmap needs to be rebuilt, which is a costly operation
since it involves a SIE exit into guest-1 for every entry in the respective
shadow level.

Add kvm stat counters when new shadow structures are created at various
levels. Also add a counter gmap_shadow_acquire when a completely fresh
shadow gmap is created.

Note that when several levels are shadowed at once, counters on all
affected levels will be increased.

Also note that not all page table levels need to be present and a ASCE
can directly point to e.g. a segment table. In this case, a new segment
table will always be equivalent to a new shadow gmap and hence will be
counted as gmap_shadow_acquire and not as gmap_shadow_segment.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h | 6 ++++++
 arch/s390/kvm/gaccess.c          | 7 +++++++
 arch/s390/kvm/kvm-s390.c         | 8 +++++++-
 arch/s390/kvm/vsie.c             | 1 +
 4 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 2bbc3d54959d..d35e03e82d3d 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -777,6 +777,12 @@ struct kvm_vm_stat {
 	u64 inject_service_signal;
 	u64 inject_virtio;
 	u64 aen_forward;
+	u64 gmap_shadow_acquire;
+	u64 gmap_shadow_r1_te;
+	u64 gmap_shadow_r2_te;
+	u64 gmap_shadow_r3_te;
+	u64 gmap_shadow_sg_te;
+	u64 gmap_shadow_pg_te;
 };
 
 struct kvm_arch_memory_slot {
diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 3eb85f254881..6f4292ad0e4a 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -1382,6 +1382,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
 				  unsigned long *pgt, int *dat_protection,
 				  int *fake)
 {
+	struct kvm *kvm;
 	struct gmap *parent;
 	union asce asce;
 	union vaddress vaddr;
@@ -1390,6 +1391,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
 
 	*fake = 0;
 	*dat_protection = 0;
+	kvm = sg->private;
 	parent = sg->parent;
 	vaddr.addr = saddr;
 	asce.val = sg->orig_asce;
@@ -1450,6 +1452,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
 		rc = gmap_shadow_r2t(sg, saddr, rfte.val, *fake);
 		if (rc)
 			return rc;
+		kvm->stat.gmap_shadow_r1_te++;
 	}
 		fallthrough;
 	case ASCE_TYPE_REGION2: {
@@ -1478,6 +1481,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
 		rc = gmap_shadow_r3t(sg, saddr, rste.val, *fake);
 		if (rc)
 			return rc;
+		kvm->stat.gmap_shadow_r2_te++;
 	}
 		fallthrough;
 	case ASCE_TYPE_REGION3: {
@@ -1515,6 +1519,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
 		rc = gmap_shadow_sgt(sg, saddr, rtte.val, *fake);
 		if (rc)
 			return rc;
+		kvm->stat.gmap_shadow_r3_te++;
 	}
 		fallthrough;
 	case ASCE_TYPE_SEGMENT: {
@@ -1548,6 +1553,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
 		rc = gmap_shadow_pgt(sg, saddr, ste.val, *fake);
 		if (rc)
 			return rc;
+		kvm->stat.gmap_shadow_sg_te++;
 	}
 	}
 	/* Return the parent address of the page table */
@@ -1618,6 +1624,7 @@ int kvm_s390_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *sg,
 	pte.p |= dat_protection;
 	if (!rc)
 		rc = gmap_shadow_page(sg, saddr, __pte(pte.val));
+	vcpu->kvm->stat.gmap_shadow_pg_te++;
 	ipte_unlock(vcpu->kvm);
 	mmap_read_unlock(sg->mm);
 	return rc;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 17b81659cdb2..ded4149e145b 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -66,7 +66,13 @@ const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	STATS_DESC_COUNTER(VM, inject_pfault_done),
 	STATS_DESC_COUNTER(VM, inject_service_signal),
 	STATS_DESC_COUNTER(VM, inject_virtio),
-	STATS_DESC_COUNTER(VM, aen_forward)
+	STATS_DESC_COUNTER(VM, aen_forward),
+	STATS_DESC_COUNTER(VM, gmap_shadow_acquire),
+	STATS_DESC_COUNTER(VM, gmap_shadow_r1_te),
+	STATS_DESC_COUNTER(VM, gmap_shadow_r2_te),
+	STATS_DESC_COUNTER(VM, gmap_shadow_r3_te),
+	STATS_DESC_COUNTER(VM, gmap_shadow_sg_te),
+	STATS_DESC_COUNTER(VM, gmap_shadow_pg_te),
 };
 
 const struct kvm_stats_header kvm_vm_stats_header = {
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 8d6b765abf29..beb3be037722 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -1221,6 +1221,7 @@ static int acquire_gmap_shadow(struct kvm_vcpu *vcpu,
 	if (IS_ERR(gmap))
 		return PTR_ERR(gmap);
 	gmap->private = vcpu->kvm;
+	vcpu->kvm->stat.gmap_shadow_acquire++;
 	WRITE_ONCE(vsie_page->gmap, gmap);
 	return 0;
 }
-- 
2.39.1

