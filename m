Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00D1D638A64
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 13:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiKYMnH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 07:43:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiKYMnE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 07:43:04 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0532F1AD80;
        Fri, 25 Nov 2022 04:43:03 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2APCDxFj005911;
        Fri, 25 Nov 2022 12:43:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=di/NNh1Mya6UTtWvTYvZrsQDfSSgRdd2GnV5bR+gpzk=;
 b=EhBKRZGBSyyNIz+z3WrZlylDhAyWdGVYuOg81ydDe+QvFjGGNb6PWeTSpmJ2v/vdwhxN
 6xScp8PB5AnumBZodbKLNwyO5k3nFKAW97gxcQStPOtm7Vh1H1dMlBg8dElRnLJ/w5Iu
 ANJl9hQek3rNy9KoxiZk/edrSdKRqzRPSCyx4GUvEh9ZaWWAU2GDOKv3f/Q9aO3FceQQ
 bC7XvK8l30HYglMU2z4tHpHJSkU4Ce6Id/4JB1/KIpuXcZ6qmKpmtfyEtq1WUM8rERM4
 Gge6XqMDU0Cv0wu5ZKJPoTCbb+iEx9XczZnU1YLUoX79dZa52CWY3GTtZw5DIOZPCNUc nA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2whcghtv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 12:43:02 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2APCMtju007945;
        Fri, 25 Nov 2022 12:43:02 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2whcghth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 12:43:02 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2APCZleW030137;
        Fri, 25 Nov 2022 12:43:00 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3kxpdj1may-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 12:43:00 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2APCgvlk3343004
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Nov 2022 12:42:57 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 870C14C04E;
        Fri, 25 Nov 2022 12:42:57 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A41D4C046;
        Fri, 25 Nov 2022 12:42:57 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.63.115])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 25 Nov 2022 12:42:57 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [GIT PULL 03/15] KVM: s390: sort out physical vs virtual pointers usage
Date:   Fri, 25 Nov 2022 13:39:35 +0100
Message-Id: <20221125123947.31047-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221125123947.31047-1-frankja@linux.ibm.com>
References: <20221125123947.31047-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qKGTRwzVCx0H7NykeWOvzC7iDONCtrce
X-Proofpoint-GUID: gjIbhKDJrjmCmCGEBeRtxX9_19qvZftS
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-25_04,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 mlxscore=0 suspectscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 impostorscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211250098
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nico Boehr <nrb@linux.ibm.com>

Fix virtual vs physical address confusion (which currently are the same).

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20221020143159.294605-4-nrb@linux.ibm.com
Message-Id: <20221020143159.294605-4-nrb@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  1 +
 arch/s390/kvm/intercept.c        |  2 +-
 arch/s390/kvm/kvm-s390.c         | 44 ++++++++++++++++++--------------
 arch/s390/kvm/kvm-s390.h         |  5 ++--
 4 files changed, 30 insertions(+), 22 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 9a31d00e99b3..931f97875899 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -276,6 +276,7 @@ struct kvm_s390_sie_block {
 #define ECB3_AES 0x04
 #define ECB3_RI  0x01
 	__u8    ecb3;			/* 0x0063 */
+#define ESCA_SCAOL_MASK ~0x3fU
 	__u32	scaol;			/* 0x0064 */
 	__u8	sdf;			/* 0x0068 */
 	__u8    epdx;			/* 0x0069 */
diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index 88112065d941..b703b5202f25 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -217,7 +217,7 @@ static int handle_itdb(struct kvm_vcpu *vcpu)
 		return 0;
 	if (current->thread.per_flags & PER_FLAG_NO_TE)
 		return 0;
-	itdb = (struct kvm_s390_itdb *)vcpu->arch.sie_block->itdba;
+	itdb = phys_to_virt(vcpu->arch.sie_block->itdba);
 	rc = write_guest_lc(vcpu, __LC_PGM_TDB, itdb, sizeof(*itdb));
 	if (rc)
 		return rc;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 45d4b8182b07..0f7ff0c9019f 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3329,28 +3329,30 @@ static void sca_del_vcpu(struct kvm_vcpu *vcpu)
 static void sca_add_vcpu(struct kvm_vcpu *vcpu)
 {
 	if (!kvm_s390_use_sca_entries()) {
-		struct bsca_block *sca = vcpu->kvm->arch.sca;
+		phys_addr_t sca_phys = virt_to_phys(vcpu->kvm->arch.sca);
 
 		/* we still need the basic sca for the ipte control */
-		vcpu->arch.sie_block->scaoh = (__u32)(((__u64)sca) >> 32);
-		vcpu->arch.sie_block->scaol = (__u32)(__u64)sca;
+		vcpu->arch.sie_block->scaoh = sca_phys >> 32;
+		vcpu->arch.sie_block->scaol = sca_phys;
 		return;
 	}
 	read_lock(&vcpu->kvm->arch.sca_lock);
 	if (vcpu->kvm->arch.use_esca) {
 		struct esca_block *sca = vcpu->kvm->arch.sca;
+		phys_addr_t sca_phys = virt_to_phys(sca);
 
-		sca->cpu[vcpu->vcpu_id].sda = (__u64) vcpu->arch.sie_block;
-		vcpu->arch.sie_block->scaoh = (__u32)(((__u64)sca) >> 32);
-		vcpu->arch.sie_block->scaol = (__u32)(__u64)sca & ~0x3fU;
+		sca->cpu[vcpu->vcpu_id].sda = virt_to_phys(vcpu->arch.sie_block);
+		vcpu->arch.sie_block->scaoh = sca_phys >> 32;
+		vcpu->arch.sie_block->scaol = sca_phys & ESCA_SCAOL_MASK;
 		vcpu->arch.sie_block->ecb2 |= ECB2_ESCA;
 		set_bit_inv(vcpu->vcpu_id, (unsigned long *) sca->mcn);
 	} else {
 		struct bsca_block *sca = vcpu->kvm->arch.sca;
+		phys_addr_t sca_phys = virt_to_phys(sca);
 
-		sca->cpu[vcpu->vcpu_id].sda = (__u64) vcpu->arch.sie_block;
-		vcpu->arch.sie_block->scaoh = (__u32)(((__u64)sca) >> 32);
-		vcpu->arch.sie_block->scaol = (__u32)(__u64)sca;
+		sca->cpu[vcpu->vcpu_id].sda = virt_to_phys(vcpu->arch.sie_block);
+		vcpu->arch.sie_block->scaoh = sca_phys >> 32;
+		vcpu->arch.sie_block->scaol = sca_phys;
 		set_bit_inv(vcpu->vcpu_id, (unsigned long *) &sca->mcn);
 	}
 	read_unlock(&vcpu->kvm->arch.sca_lock);
@@ -3381,6 +3383,7 @@ static int sca_switch_to_extended(struct kvm *kvm)
 	struct kvm_vcpu *vcpu;
 	unsigned long vcpu_idx;
 	u32 scaol, scaoh;
+	phys_addr_t new_sca_phys;
 
 	if (kvm->arch.use_esca)
 		return 0;
@@ -3389,8 +3392,9 @@ static int sca_switch_to_extended(struct kvm *kvm)
 	if (!new_sca)
 		return -ENOMEM;
 
-	scaoh = (u32)((u64)(new_sca) >> 32);
-	scaol = (u32)(u64)(new_sca) & ~0x3fU;
+	new_sca_phys = virt_to_phys(new_sca);
+	scaoh = new_sca_phys >> 32;
+	scaol = new_sca_phys & ESCA_SCAOL_MASK;
 
 	kvm_s390_vcpu_block_all(kvm);
 	write_lock(&kvm->arch.sca_lock);
@@ -3610,15 +3614,18 @@ static void kvm_s390_vcpu_crypto_setup(struct kvm_vcpu *vcpu)
 
 void kvm_s390_vcpu_unsetup_cmma(struct kvm_vcpu *vcpu)
 {
-	free_page(vcpu->arch.sie_block->cbrlo);
+	free_page((unsigned long)phys_to_virt(vcpu->arch.sie_block->cbrlo));
 	vcpu->arch.sie_block->cbrlo = 0;
 }
 
 int kvm_s390_vcpu_setup_cmma(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.sie_block->cbrlo = get_zeroed_page(GFP_KERNEL_ACCOUNT);
-	if (!vcpu->arch.sie_block->cbrlo)
+	void *cbrlo_page = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
+
+	if (!cbrlo_page)
 		return -ENOMEM;
+
+	vcpu->arch.sie_block->cbrlo = virt_to_phys(cbrlo_page);
 	return 0;
 }
 
@@ -3628,7 +3635,7 @@ static void kvm_s390_vcpu_setup_model(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.sie_block->ibc = model->ibc;
 	if (test_kvm_facility(vcpu->kvm, 7))
-		vcpu->arch.sie_block->fac = (u32)(u64) model->fac_list;
+		vcpu->arch.sie_block->fac = virt_to_phys(model->fac_list);
 }
 
 static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
@@ -3685,9 +3692,8 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
 		VCPU_EVENT(vcpu, 3, "AIV gisa format-%u enabled for cpu %03u",
 			   vcpu->arch.sie_block->gd & 0x3, vcpu->vcpu_id);
 	}
-	vcpu->arch.sie_block->sdnxo = ((unsigned long) &vcpu->run->s.regs.sdnx)
-					| SDNXC;
-	vcpu->arch.sie_block->riccbd = (unsigned long) &vcpu->run->s.regs.riccb;
+	vcpu->arch.sie_block->sdnxo = virt_to_phys(&vcpu->run->s.regs.sdnx) | SDNXC;
+	vcpu->arch.sie_block->riccbd = virt_to_phys(&vcpu->run->s.regs.riccb);
 
 	if (sclp.has_kss)
 		kvm_s390_set_cpuflags(vcpu, CPUSTAT_KSS);
@@ -3737,7 +3743,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 		return -ENOMEM;
 
 	vcpu->arch.sie_block = &sie_page->sie_block;
-	vcpu->arch.sie_block->itdba = (unsigned long) &sie_page->itdb;
+	vcpu->arch.sie_block->itdba = virt_to_phys(&sie_page->itdb);
 
 	/* the real guest size will always be smaller than msl */
 	vcpu->arch.sie_block->mso = 0;
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index f6fd668f887e..a60d1e5c44cd 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -23,7 +23,8 @@
 /* Transactional Memory Execution related macros */
 #define IS_TE_ENABLED(vcpu)	((vcpu->arch.sie_block->ecb & ECB_TE))
 #define TDB_FORMAT1		1
-#define IS_ITDB_VALID(vcpu)	((*(char *)vcpu->arch.sie_block->itdba == TDB_FORMAT1))
+#define IS_ITDB_VALID(vcpu) \
+	((*(char *)phys_to_virt((vcpu)->arch.sie_block->itdba) == TDB_FORMAT1))
 
 extern debug_info_t *kvm_s390_dbf;
 extern debug_info_t *kvm_s390_dbf_uv;
@@ -233,7 +234,7 @@ static inline unsigned long kvm_s390_get_gfn_end(struct kvm_memslots *slots)
 
 static inline u32 kvm_s390_get_gisa_desc(struct kvm *kvm)
 {
-	u32 gd = (u32)(u64)kvm->arch.gisa_int.origin;
+	u32 gd = virt_to_phys(kvm->arch.gisa_int.origin);
 
 	if (gd && sclp.has_gisaf)
 		gd |= GISA_FORMAT1;
-- 
2.38.1

