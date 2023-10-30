Return-Path: <kvm+bounces-60-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 677F27DB60A
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 10:22:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C8D82814C8
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 09:22:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAAE8DDC7;
	Mon, 30 Oct 2023 09:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="LvHCitpR"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E43D52E
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 09:22:32 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ABADB6;
	Mon, 30 Oct 2023 02:22:30 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39U99jrk006679;
	Mon, 30 Oct 2023 09:22:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=x9pRTDCHnjVPzniI/MZeYNGA4N2C7SkuqMJ3H5UB94Y=;
 b=LvHCitpRKTcSF5FqaCQHLauPVu4ccDyl7vYTvoVEHw8oYwfYHkptvysLerEDxzG2cNNL
 UApLvIHZ/JqIpSgoh9Z+cJZCGaZW7nx//FSznPNj2uAV38gL5gxNbSk8geR+jO0n4Sg+
 1ROgEZHJMHzWOlk21/rPjOb/XoX8A83LW0Ym0IMPGKcs3micSaw3lNi4DCImt4oYMXUB
 J2ESThYKfyOBVUqIZE59bbpJ7oyN1IVikyPTacxsKOcEieNULp8qOhSKyg1RcW3uj6n2
 +o9Lf/h5RyWwcTMmSu6r4Mma2tekDonIAX9xOEn3IRJcoq6J9p0dM06d9JJbZBGBcv6W bQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u29m10eds-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Oct 2023 09:22:29 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39U99s5p007130;
	Mon, 30 Oct 2023 09:22:29 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u29m10edb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Oct 2023 09:22:29 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39U7m9rX000591;
	Mon, 30 Oct 2023 09:22:28 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u1cmsra8x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Oct 2023 09:22:28 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39U9MPCG8717004
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 30 Oct 2023 09:22:25 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9619B20043;
	Mon, 30 Oct 2023 09:22:25 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 15C8A20040;
	Mon, 30 Oct 2023 09:22:25 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.67.230])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 30 Oct 2023 09:22:25 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, nrb@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [GIT PULL 1/2] KVM: s390: add stat counter for shadow gmap events
Date: Mon, 30 Oct 2023 10:08:38 +0100
Message-ID: <20231030092101.66014-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231030092101.66014-1-frankja@linux.ibm.com>
References: <20231030092101.66014-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2Al09EWxWjQdUX8w1AVM0yWHZssRU0l_
X-Proofpoint-ORIG-GUID: 1qG2yJ8Ld5rOyiYhZ0X227iWObI-6A_b
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-30_08,2023-10-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 suspectscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 impostorscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2310300070

From: Nico Boehr <nrb@linux.ibm.com>

The shadow gmap tracks memory of nested guests (guest-3). In certain
scenarios, the shadow gmap needs to be rebuilt, which is a costly operation
since it involves a SIE exit into guest-1 for every entry in the respective
shadow level.

Add kvm stat counters when new shadow structures are created at various
levels. Also add a counter gmap_shadow_create when a completely fresh
shadow gmap is created as well as a counter gmap_shadow_reuse when an
existing gmap is being reused.

Note that when several levels are shadowed at once, counters on all
affected levels will be increased.

Also note that not all page table levels need to be present and a ASCE
can directly point to e.g. a segment table. In this case, a new segment
table will always be equivalent to a new shadow gmap and hence will be
counted as gmap_shadow_create and not as gmap_shadow_segment.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20231009093304.2555344-2-nrb@linux.ibm.com
Message-Id: <20231009093304.2555344-2-nrb@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h | 7 +++++++
 arch/s390/kvm/gaccess.c          | 7 +++++++
 arch/s390/kvm/kvm-s390.c         | 9 ++++++++-
 arch/s390/kvm/vsie.c             | 5 ++++-
 4 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 427f9528a7b6..67a298b6cf6e 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -777,6 +777,13 @@ struct kvm_vm_stat {
 	u64 inject_service_signal;
 	u64 inject_virtio;
 	u64 aen_forward;
+	u64 gmap_shadow_create;
+	u64 gmap_shadow_reuse;
+	u64 gmap_shadow_r1_entry;
+	u64 gmap_shadow_r2_entry;
+	u64 gmap_shadow_r3_entry;
+	u64 gmap_shadow_sg_entry;
+	u64 gmap_shadow_pg_entry;
 };
 
 struct kvm_arch_memory_slot {
diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 6d6bc19b37dc..ff8349d17b33 100644
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
+		kvm->stat.gmap_shadow_r1_entry++;
 	}
 		fallthrough;
 	case ASCE_TYPE_REGION2: {
@@ -1478,6 +1481,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
 		rc = gmap_shadow_r3t(sg, saddr, rste.val, *fake);
 		if (rc)
 			return rc;
+		kvm->stat.gmap_shadow_r2_entry++;
 	}
 		fallthrough;
 	case ASCE_TYPE_REGION3: {
@@ -1515,6 +1519,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
 		rc = gmap_shadow_sgt(sg, saddr, rtte.val, *fake);
 		if (rc)
 			return rc;
+		kvm->stat.gmap_shadow_r3_entry++;
 	}
 		fallthrough;
 	case ASCE_TYPE_SEGMENT: {
@@ -1548,6 +1553,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
 		rc = gmap_shadow_pgt(sg, saddr, ste.val, *fake);
 		if (rc)
 			return rc;
+		kvm->stat.gmap_shadow_sg_entry++;
 	}
 	}
 	/* Return the parent address of the page table */
@@ -1618,6 +1624,7 @@ int kvm_s390_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *sg,
 	pte.p |= dat_protection;
 	if (!rc)
 		rc = gmap_shadow_page(sg, saddr, __pte(pte.val));
+	vcpu->kvm->stat.gmap_shadow_pg_entry++;
 	ipte_unlock(vcpu->kvm);
 	mmap_read_unlock(sg->mm);
 	return rc;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index b3f17e014cab..b42493110d76 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -66,7 +66,14 @@ const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	STATS_DESC_COUNTER(VM, inject_pfault_done),
 	STATS_DESC_COUNTER(VM, inject_service_signal),
 	STATS_DESC_COUNTER(VM, inject_virtio),
-	STATS_DESC_COUNTER(VM, aen_forward)
+	STATS_DESC_COUNTER(VM, aen_forward),
+	STATS_DESC_COUNTER(VM, gmap_shadow_reuse),
+	STATS_DESC_COUNTER(VM, gmap_shadow_create),
+	STATS_DESC_COUNTER(VM, gmap_shadow_r1_entry),
+	STATS_DESC_COUNTER(VM, gmap_shadow_r2_entry),
+	STATS_DESC_COUNTER(VM, gmap_shadow_r3_entry),
+	STATS_DESC_COUNTER(VM, gmap_shadow_sg_entry),
+	STATS_DESC_COUNTER(VM, gmap_shadow_pg_entry),
 };
 
 const struct kvm_stats_header kvm_vm_stats_header = {
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 61499293c2ac..02dcbe82a8e5 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -1214,8 +1214,10 @@ static int acquire_gmap_shadow(struct kvm_vcpu *vcpu,
 	 * we're holding has been unshadowed. If the gmap is still valid,
 	 * we can safely reuse it.
 	 */
-	if (vsie_page->gmap && gmap_shadow_valid(vsie_page->gmap, asce, edat))
+	if (vsie_page->gmap && gmap_shadow_valid(vsie_page->gmap, asce, edat)) {
+		vcpu->kvm->stat.gmap_shadow_reuse++;
 		return 0;
+	}
 
 	/* release the old shadow - if any, and mark the prefix as unmapped */
 	release_gmap_shadow(vsie_page);
@@ -1223,6 +1225,7 @@ static int acquire_gmap_shadow(struct kvm_vcpu *vcpu,
 	if (IS_ERR(gmap))
 		return PTR_ERR(gmap);
 	gmap->private = vcpu->kvm;
+	vcpu->kvm->stat.gmap_shadow_create++;
 	WRITE_ONCE(vsie_page->gmap, gmap);
 	return 0;
 }
-- 
2.41.0


