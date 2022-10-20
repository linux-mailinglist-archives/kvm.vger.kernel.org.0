Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A256460631B
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 16:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbiJTOcQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 10:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiJTOcJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 10:32:09 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B01514DF37;
        Thu, 20 Oct 2022 07:32:07 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29KE3gZt026078;
        Thu, 20 Oct 2022 14:32:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Uxv4bQDysXNnEvEFn01RbxbVnrcjZ+L3wBpHqRt841Y=;
 b=tftkazWAKHxgHhM2sYFaGQW1uxJx5112nU7GBPNJnkWMdep2jz2H9sMfsbYtgXUKyEUC
 IQhLRMSxR0763k3Y8Ved3K9lINSL77HA2mKc54IHwRZo0cX21tiGezUN5hACBSaac4ux
 N6ZwK5f/ppfO/oWhCR1Vy+NBxaq6Kj7e57lIYreFlDTM6FQBc2WrazrfjcwyvRnkfCsT
 WYoPpwURygrdO1zWYRCAN60IIVAIAa6Vz/F16Ikju4HK+X4ezY7K2QDNgylhjZ1EXAIX
 8Y0qguw7sFMmN1ZlguIp35+Jn6hSYLnN/Sjq4wsmsvvY7uvJ8Z6p9vMyFoG9fwKPgdCe Sg== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb7rrhfm4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 14:32:06 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29KELQs3021439;
        Thu, 20 Oct 2022 14:32:04 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3k7mg990q2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 14:32:04 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29KEW16k32309870
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 14:32:01 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 348C0AE045;
        Thu, 20 Oct 2022 14:32:01 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE5EBAE051;
        Thu, 20 Oct 2022 14:32:00 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Oct 2022 14:32:00 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com
Subject: [v1 3/5] KVM: s390: sort out physical vs virtual pointers usage
Date:   Thu, 20 Oct 2022 16:31:57 +0200
Message-Id: <20221020143159.294605-4-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221020143159.294605-1-nrb@linux.ibm.com>
References: <20221020143159.294605-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mWLvjv5rmk3SzxVHxlPP7DeGTS6QncCY
X-Proofpoint-ORIG-GUID: mWLvjv5rmk3SzxVHxlPP7DeGTS6QncCY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_05,2022-10-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 adultscore=0 priorityscore=1501 phishscore=0 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210200083
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix virtual vs physical address confusion (which currently are the same).

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
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
2.37.3

