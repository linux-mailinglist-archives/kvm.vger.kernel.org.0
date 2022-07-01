Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E71815637BC
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 18:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbiGAQVn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 12:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbiGAQVj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 12:21:39 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C5583F314;
        Fri,  1 Jul 2022 09:21:37 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 261FEwtA003971;
        Fri, 1 Jul 2022 16:21:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=YR6Yk7sJWpZLekUTmhs2XN9rXpmaPyA4t+JLSpNFtM4=;
 b=jlhuI4BxtC0LlxWBvgNnoSw14KcLcmg3Wz6nKNC6ddJA92d7G7RO9MG+te1w2GzqsCi9
 A9sYCbcTtsFTNnY37+ywn9JOK7YN23hrjch05JEORmcEgQ5qB2LEw/p6AnxqsAjEDKD9
 pMR8b6GwzUw2ERcj/Cm81b4p7c7WefqwL/F0p8uQLOagmIFEglC1E6qnriUKX3QZsqjG
 iBsVCG6y8/Z1mvkaJlGuxupzKa4TRk8fUGWlJ+/wV6NlW+K9gce3D6HUTECsXE78Fxck
 8HE3AWsctS6EjHH8ZNft63v6a2LBoFVe65ME0uBp5W11LDdmNUH7XOf4+AY1BjOrQGik uQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h23dc2bvx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Jul 2022 16:21:36 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 261FFC6E004903;
        Fri, 1 Jul 2022 16:21:36 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h23dc2bv5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Jul 2022 16:21:36 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 261G6iQ7032293;
        Fri, 1 Jul 2022 16:21:34 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3gwt08yeg7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Jul 2022 16:21:34 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 261GLVip11927892
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Jul 2022 16:21:31 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21A79A4054;
        Fri,  1 Jul 2022 16:21:31 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 60A47A405B;
        Fri,  1 Jul 2022 16:21:30 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.92.56])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 Jul 2022 16:21:30 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, pmorel@linux.ibm.com,
        wintera@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com
Subject: [PATCH v11 1/3] KVM: s390: Cleanup ipte lock access and SIIF facility checks
Date:   Fri,  1 Jul 2022 18:25:57 +0200
Message-Id: <20220701162559.158313-2-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220701162559.158313-1-pmorel@linux.ibm.com>
References: <20220701162559.158313-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NG8A6A2Qy1tcRHUfUcoD4IBjPIe4OHEe
X-Proofpoint-ORIG-GUID: 2Ju2gtqvLaWdtMM4OABJc5JmAQDEaNCX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-01_08,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 phishscore=0 spamscore=0 clxscore=1015 bulkscore=0 lowpriorityscore=0
 adultscore=0 impostorscore=0 suspectscore=0 malwarescore=0 mlxlogscore=902
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2207010064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We can check if SIIF is enabled by testing the sclp_info struct
instead of testing the sie control block eca variable as that
facility is always enabled if available.

Also let's cleanup all the ipte related struct member accesses
which currently happen by referencing the KVM struct via the
VCPU struct.
Making the KVM struct the parameter to the ipte_* functions
removes one level of indirection which makes the code more readable.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
---
 arch/s390/kvm/gaccess.c | 96 ++++++++++++++++++++---------------------
 arch/s390/kvm/gaccess.h |  6 +--
 arch/s390/kvm/priv.c    |  6 +--
 3 files changed, 54 insertions(+), 54 deletions(-)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 227ed0009354..082ec5f2c3a5 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -262,77 +262,77 @@ struct aste {
 	/* .. more fields there */
 };
 
-int ipte_lock_held(struct kvm_vcpu *vcpu)
+int ipte_lock_held(struct kvm *kvm)
 {
-	if (vcpu->arch.sie_block->eca & ECA_SII) {
+	if (sclp.has_siif) {
 		int rc;
 
-		read_lock(&vcpu->kvm->arch.sca_lock);
-		rc = kvm_s390_get_ipte_control(vcpu->kvm)->kh != 0;
-		read_unlock(&vcpu->kvm->arch.sca_lock);
+		read_lock(&kvm->arch.sca_lock);
+		rc = kvm_s390_get_ipte_control(kvm)->kh != 0;
+		read_unlock(&kvm->arch.sca_lock);
 		return rc;
 	}
-	return vcpu->kvm->arch.ipte_lock_count != 0;
+	return kvm->arch.ipte_lock_count != 0;
 }
 
-static void ipte_lock_simple(struct kvm_vcpu *vcpu)
+static void ipte_lock_simple(struct kvm *kvm)
 {
 	union ipte_control old, new, *ic;
 
-	mutex_lock(&vcpu->kvm->arch.ipte_mutex);
-	vcpu->kvm->arch.ipte_lock_count++;
-	if (vcpu->kvm->arch.ipte_lock_count > 1)
+	mutex_lock(&kvm->arch.ipte_mutex);
+	kvm->arch.ipte_lock_count++;
+	if (kvm->arch.ipte_lock_count > 1)
 		goto out;
 retry:
-	read_lock(&vcpu->kvm->arch.sca_lock);
-	ic = kvm_s390_get_ipte_control(vcpu->kvm);
+	read_lock(&kvm->arch.sca_lock);
+	ic = kvm_s390_get_ipte_control(kvm);
 	do {
 		old = READ_ONCE(*ic);
 		if (old.k) {
-			read_unlock(&vcpu->kvm->arch.sca_lock);
+			read_unlock(&kvm->arch.sca_lock);
 			cond_resched();
 			goto retry;
 		}
 		new = old;
 		new.k = 1;
 	} while (cmpxchg(&ic->val, old.val, new.val) != old.val);
-	read_unlock(&vcpu->kvm->arch.sca_lock);
+	read_unlock(&kvm->arch.sca_lock);
 out:
-	mutex_unlock(&vcpu->kvm->arch.ipte_mutex);
+	mutex_unlock(&kvm->arch.ipte_mutex);
 }
 
-static void ipte_unlock_simple(struct kvm_vcpu *vcpu)
+static void ipte_unlock_simple(struct kvm *kvm)
 {
 	union ipte_control old, new, *ic;
 
-	mutex_lock(&vcpu->kvm->arch.ipte_mutex);
-	vcpu->kvm->arch.ipte_lock_count--;
-	if (vcpu->kvm->arch.ipte_lock_count)
+	mutex_lock(&kvm->arch.ipte_mutex);
+	kvm->arch.ipte_lock_count--;
+	if (kvm->arch.ipte_lock_count)
 		goto out;
-	read_lock(&vcpu->kvm->arch.sca_lock);
-	ic = kvm_s390_get_ipte_control(vcpu->kvm);
+	read_lock(&kvm->arch.sca_lock);
+	ic = kvm_s390_get_ipte_control(kvm);
 	do {
 		old = READ_ONCE(*ic);
 		new = old;
 		new.k = 0;
 	} while (cmpxchg(&ic->val, old.val, new.val) != old.val);
-	read_unlock(&vcpu->kvm->arch.sca_lock);
-	wake_up(&vcpu->kvm->arch.ipte_wq);
+	read_unlock(&kvm->arch.sca_lock);
+	wake_up(&kvm->arch.ipte_wq);
 out:
-	mutex_unlock(&vcpu->kvm->arch.ipte_mutex);
+	mutex_unlock(&kvm->arch.ipte_mutex);
 }
 
-static void ipte_lock_siif(struct kvm_vcpu *vcpu)
+static void ipte_lock_siif(struct kvm *kvm)
 {
 	union ipte_control old, new, *ic;
 
 retry:
-	read_lock(&vcpu->kvm->arch.sca_lock);
-	ic = kvm_s390_get_ipte_control(vcpu->kvm);
+	read_lock(&kvm->arch.sca_lock);
+	ic = kvm_s390_get_ipte_control(kvm);
 	do {
 		old = READ_ONCE(*ic);
 		if (old.kg) {
-			read_unlock(&vcpu->kvm->arch.sca_lock);
+			read_unlock(&kvm->arch.sca_lock);
 			cond_resched();
 			goto retry;
 		}
@@ -340,15 +340,15 @@ static void ipte_lock_siif(struct kvm_vcpu *vcpu)
 		new.k = 1;
 		new.kh++;
 	} while (cmpxchg(&ic->val, old.val, new.val) != old.val);
-	read_unlock(&vcpu->kvm->arch.sca_lock);
+	read_unlock(&kvm->arch.sca_lock);
 }
 
-static void ipte_unlock_siif(struct kvm_vcpu *vcpu)
+static void ipte_unlock_siif(struct kvm *kvm)
 {
 	union ipte_control old, new, *ic;
 
-	read_lock(&vcpu->kvm->arch.sca_lock);
-	ic = kvm_s390_get_ipte_control(vcpu->kvm);
+	read_lock(&kvm->arch.sca_lock);
+	ic = kvm_s390_get_ipte_control(kvm);
 	do {
 		old = READ_ONCE(*ic);
 		new = old;
@@ -356,25 +356,25 @@ static void ipte_unlock_siif(struct kvm_vcpu *vcpu)
 		if (!new.kh)
 			new.k = 0;
 	} while (cmpxchg(&ic->val, old.val, new.val) != old.val);
-	read_unlock(&vcpu->kvm->arch.sca_lock);
+	read_unlock(&kvm->arch.sca_lock);
 	if (!new.kh)
-		wake_up(&vcpu->kvm->arch.ipte_wq);
+		wake_up(&kvm->arch.ipte_wq);
 }
 
-void ipte_lock(struct kvm_vcpu *vcpu)
+void ipte_lock(struct kvm *kvm)
 {
-	if (vcpu->arch.sie_block->eca & ECA_SII)
-		ipte_lock_siif(vcpu);
+	if (sclp.has_siif)
+		ipte_lock_siif(kvm);
 	else
-		ipte_lock_simple(vcpu);
+		ipte_lock_simple(kvm);
 }
 
-void ipte_unlock(struct kvm_vcpu *vcpu)
+void ipte_unlock(struct kvm *kvm)
 {
-	if (vcpu->arch.sie_block->eca & ECA_SII)
-		ipte_unlock_siif(vcpu);
+	if (sclp.has_siif)
+		ipte_unlock_siif(kvm);
 	else
-		ipte_unlock_simple(vcpu);
+		ipte_unlock_simple(kvm);
 }
 
 static int ar_translation(struct kvm_vcpu *vcpu, union asce *asce, u8 ar,
@@ -1086,7 +1086,7 @@ int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
 	try_storage_prot_override = storage_prot_override_applicable(vcpu);
 	need_ipte_lock = psw_bits(*psw).dat && !asce.r;
 	if (need_ipte_lock)
-		ipte_lock(vcpu);
+		ipte_lock(vcpu->kvm);
 	/*
 	 * Since we do the access further down ultimately via a move instruction
 	 * that does key checking and returns an error in case of a protection
@@ -1127,7 +1127,7 @@ int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
 	}
 out_unlock:
 	if (need_ipte_lock)
-		ipte_unlock(vcpu);
+		ipte_unlock(vcpu->kvm);
 	if (nr_pages > ARRAY_SIZE(gpa_array))
 		vfree(gpas);
 	return rc;
@@ -1199,10 +1199,10 @@ int check_gva_range(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
 	rc = get_vcpu_asce(vcpu, &asce, gva, ar, mode);
 	if (rc)
 		return rc;
-	ipte_lock(vcpu);
+	ipte_lock(vcpu->kvm);
 	rc = guest_range_to_gpas(vcpu, gva, ar, NULL, length, asce, mode,
 				 access_key);
-	ipte_unlock(vcpu);
+	ipte_unlock(vcpu->kvm);
 
 	return rc;
 }
@@ -1465,7 +1465,7 @@ int kvm_s390_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *sg,
 	 * tables/pointers we read stay valid - unshadowing is however
 	 * always possible - only guest_table_lock protects us.
 	 */
-	ipte_lock(vcpu);
+	ipte_lock(vcpu->kvm);
 
 	rc = gmap_shadow_pgt_lookup(sg, saddr, &pgt, &dat_protection, &fake);
 	if (rc)
@@ -1499,7 +1499,7 @@ int kvm_s390_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *sg,
 	pte.p |= dat_protection;
 	if (!rc)
 		rc = gmap_shadow_page(sg, saddr, __pte(pte.val));
-	ipte_unlock(vcpu);
+	ipte_unlock(vcpu->kvm);
 	mmap_read_unlock(sg->mm);
 	return rc;
 }
diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
index 1124ff282012..9408d6cc8e2c 100644
--- a/arch/s390/kvm/gaccess.h
+++ b/arch/s390/kvm/gaccess.h
@@ -440,9 +440,9 @@ int read_guest_real(struct kvm_vcpu *vcpu, unsigned long gra, void *data,
 	return access_guest_real(vcpu, gra, data, len, 0);
 }
 
-void ipte_lock(struct kvm_vcpu *vcpu);
-void ipte_unlock(struct kvm_vcpu *vcpu);
-int ipte_lock_held(struct kvm_vcpu *vcpu);
+void ipte_lock(struct kvm *kvm);
+void ipte_unlock(struct kvm *kvm);
+int ipte_lock_held(struct kvm *kvm);
 int kvm_s390_check_low_addr_prot_real(struct kvm_vcpu *vcpu, unsigned long gra);
 
 /* MVPG PEI indication bits */
diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index 83bb5cf97282..12c464c7cddf 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -442,7 +442,7 @@ static int handle_ipte_interlock(struct kvm_vcpu *vcpu)
 	vcpu->stat.instruction_ipte_interlock++;
 	if (psw_bits(vcpu->arch.sie_block->gpsw).pstate)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
-	wait_event(vcpu->kvm->arch.ipte_wq, !ipte_lock_held(vcpu));
+	wait_event(vcpu->kvm->arch.ipte_wq, !ipte_lock_held(vcpu->kvm));
 	kvm_s390_retry_instr(vcpu);
 	VCPU_EVENT(vcpu, 4, "%s", "retrying ipte interlock operation");
 	return 0;
@@ -1471,7 +1471,7 @@ static int handle_tprot(struct kvm_vcpu *vcpu)
 	access_key = (operand2 & 0xf0) >> 4;
 
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_DAT)
-		ipte_lock(vcpu);
+		ipte_lock(vcpu->kvm);
 
 	ret = guest_translate_address_with_key(vcpu, address, ar, &gpa,
 					       GACC_STORE, access_key);
@@ -1508,7 +1508,7 @@ static int handle_tprot(struct kvm_vcpu *vcpu)
 	}
 
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_DAT)
-		ipte_unlock(vcpu);
+		ipte_unlock(vcpu->kvm);
 	return ret;
 }
 
-- 
2.31.1

