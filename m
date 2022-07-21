Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A93F57D11F
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 18:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233766AbiGUQO3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 12:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233802AbiGUQOL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 12:14:11 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E16D38876A;
        Thu, 21 Jul 2022 09:14:02 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LFFRPl020346;
        Thu, 21 Jul 2022 16:13:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=oRbd7geZVmc7wA9OoWfIpq7SRgFFPcRlzOcq7VUowL8=;
 b=XSZlvOM8GwmxCMSUrEs4JtZksJ9NXv6az9CNfjtSbu7UzSvvyAWEolrPBLDUyQxZY4Bp
 onSqog2tcD8j6BGfdlLw2kC5BLTepnzouUN+bGQdHZmgq+E5po0EzCIElQ3CSvHjMOPw
 slt8rgXd60L8akR4sLBLd+dcXOZTc8k/GJAL9eO+D4MGijnU558QOAyfCN4yysb16t0g
 femjqT9u7iKyPlaVMeOMTE9SdEva0LZBMDrn0FiSDKzIcUEsQ34fdCsmYhbHHozOKYzL
 DykDdH/hRp55WHl+IbYEXP9zqSEqo7NNso+4MleAQYCCwD21ErOUfUrZzoLgljvRAd0C SQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf8f2m3ps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:34 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LFFixJ023097;
        Thu, 21 Jul 2022 16:13:34 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf8f2m3nj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:34 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LG7MJ3017937;
        Thu, 21 Jul 2022 16:13:31 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3hbmy8y570-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:31 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LGDSaa23724484
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 16:13:28 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD0A4A4062;
        Thu, 21 Jul 2022 16:13:28 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 42BD4A405B;
        Thu, 21 Jul 2022 16:13:28 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.4.232])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 16:13:28 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        thuth@redhat.com, david@redhat.com,
        Pierre Morel <pmorel@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [GIT PULL 40/42] KVM: s390: Cleanup ipte lock access and SIIF facility checks
Date:   Thu, 21 Jul 2022 18:13:00 +0200
Message-Id: <20220721161302.156182-41-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721161302.156182-1-imbrenda@linux.ibm.com>
References: <20220721161302.156182-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: s6bbLOtWVTYKSpN8dEXkXNObKurMjdKw
X-Proofpoint-GUID: 2KQuue1rBJUrtxRusf_LiEfr1_GV1bEm
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_22,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 clxscore=1015 suspectscore=0 adultscore=0 spamscore=0
 mlxlogscore=909 impostorscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207210064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Pierre Morel <pmorel@linux.ibm.com>

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
Link: https://lore.kernel.org/all/20220711084148.25017-2-pmorel@linux.ibm.com/
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
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
2.36.1

