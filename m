Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B83D4BF506
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 10:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbiBVJts (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 04:49:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbiBVJtq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 04:49:46 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26AADC0840;
        Tue, 22 Feb 2022 01:49:20 -0800 (PST)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21M7g8NT029183;
        Tue, 22 Feb 2022 09:49:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=6pTzlVvVyMJugO2nrgLY8VQksC8PkD85Lre5MSFr1/Y=;
 b=X1rm/yO836LuOeKYhVoQmLCgZljre+AS+cynETDVAOLpvuEPswWw4WtvGdYgDHRZhBMG
 LmorwpdEYxenaZSG9/CWuCatizFdu+PYyGesN7/Jo2LLyAzncPO8HldAVBT12RF0gFUu
 II1IgC3ptYAZGMRovgmtBkb6N2ASt9sw82gJwL05+RMQzOEmSN1uohsx1G55lcFlNs5D
 xaHKMqCdGoxefnzCm4djdzzcfoi0hmoeUg/UGpdTCUdjUnCyCx00PZEyUpI7h/sZAzG9
 +KQ9DjDOaygO9h6eMEmE1qgP8ZUJndw+ckHaeSOUNoIgS7e7OiRqRazrM8phAeCXrH7E Ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ecunwtnwu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 09:49:19 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21M9Aj6K010299;
        Tue, 22 Feb 2022 09:49:18 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ecunwtnwd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 09:49:18 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21M9msew008293;
        Tue, 22 Feb 2022 09:49:17 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3ear690dc2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Feb 2022 09:49:16 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21M9nDJB47186384
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Feb 2022 09:49:13 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F074DAE055;
        Tue, 22 Feb 2022 09:49:12 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D89C3AE051;
        Tue, 22 Feb 2022 09:49:12 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 22 Feb 2022 09:49:12 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 9DCCEE04EB; Tue, 22 Feb 2022 10:49:12 +0100 (CET)
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [GIT PULL 04/13] KVM: s390: handle_tprot: Honor storage keys
Date:   Tue, 22 Feb 2022 10:49:01 +0100
Message-Id: <20220222094910.18331-5-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220222094910.18331-1-borntraeger@linux.ibm.com>
References: <20220222094910.18331-1-borntraeger@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: CGHgApDM7CuHD83ufDM5FUlfm-D4Wa_j
X-Proofpoint-GUID: YZc-KB8_1O1ggClu1AP6i6GIFBCUWm_u
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-22_02,2022-02-21_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 mlxscore=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 suspectscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202220054
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

Use the access key operand to check for key protection when
translating guest addresses.
Since the translation code checks for accessing exceptions/error hvas,
we can remove the check here and simplify the control flow.
Keep checking if the memory is read-only even if such memslots are
currently not supported.

handle_tprot was the last user of guest_translate_address,
so remove it.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20220211182215.2730017-4-scgl@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 arch/s390/kvm/gaccess.c |  9 ------
 arch/s390/kvm/gaccess.h |  3 --
 arch/s390/kvm/priv.c    | 66 ++++++++++++++++++++++-------------------
 3 files changed, 35 insertions(+), 43 deletions(-)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 7fca0cff4c12..37838f637707 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -1118,15 +1118,6 @@ int guest_translate_address_with_key(struct kvm_vcpu *vcpu, unsigned long gva, u
 				   access_key);
 }
 
-int guest_translate_address(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
-			    unsigned long *gpa, enum gacc_mode mode)
-{
-	u8 access_key = psw_bits(vcpu->arch.sie_block->gpsw).key;
-
-	return guest_translate_address_with_key(vcpu, gva, ar, gpa, mode,
-						access_key);
-}
-
 /**
  * check_gva_range - test a range of guest virtual addresses for accessibility
  * @vcpu: virtual cpu
diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
index e5b2f56e7962..c5f2e7311b17 100644
--- a/arch/s390/kvm/gaccess.h
+++ b/arch/s390/kvm/gaccess.h
@@ -190,9 +190,6 @@ int guest_translate_address_with_key(struct kvm_vcpu *vcpu, unsigned long gva, u
 				     unsigned long *gpa, enum gacc_mode mode,
 				     u8 access_key);
 
-int guest_translate_address(struct kvm_vcpu *vcpu, unsigned long gva,
-			    u8 ar, unsigned long *gpa, enum gacc_mode mode);
-
 int check_gva_range(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
 		    unsigned long length, enum gacc_mode mode, u8 access_key);
 
diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index 417154b314a6..30b24c42ef99 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -1443,10 +1443,11 @@ int kvm_s390_handle_eb(struct kvm_vcpu *vcpu)
 
 static int handle_tprot(struct kvm_vcpu *vcpu)
 {
-	u64 address1, address2;
-	unsigned long hva, gpa;
-	int ret = 0, cc = 0;
+	u64 address, operand2;
+	unsigned long gpa;
+	u8 access_key;
 	bool writable;
+	int ret, cc;
 	u8 ar;
 
 	vcpu->stat.instruction_tprot++;
@@ -1454,43 +1455,46 @@ static int handle_tprot(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
 
-	kvm_s390_get_base_disp_sse(vcpu, &address1, &address2, &ar, NULL);
+	kvm_s390_get_base_disp_sse(vcpu, &address, &operand2, &ar, NULL);
+	access_key = (operand2 & 0xf0) >> 4;
 
-	/* we only handle the Linux memory detection case:
-	 * access key == 0
-	 * everything else goes to userspace. */
-	if (address2 & 0xf0)
-		return -EOPNOTSUPP;
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_DAT)
 		ipte_lock(vcpu);
-	ret = guest_translate_address(vcpu, address1, ar, &gpa, GACC_STORE);
-	if (ret == PGM_PROTECTION) {
+
+	ret = guest_translate_address_with_key(vcpu, address, ar, &gpa,
+					       GACC_STORE, access_key);
+	if (ret == 0) {
+		gfn_to_hva_prot(vcpu->kvm, gpa_to_gfn(gpa), &writable);
+	} else if (ret == PGM_PROTECTION) {
+		writable = false;
 		/* Write protected? Try again with read-only... */
-		cc = 1;
-		ret = guest_translate_address(vcpu, address1, ar, &gpa,
-					      GACC_FETCH);
+		ret = guest_translate_address_with_key(vcpu, address, ar, &gpa,
+						       GACC_FETCH, access_key);
 	}
-	if (ret) {
-		if (ret == PGM_ADDRESSING || ret == PGM_TRANSLATION_SPEC) {
-			ret = kvm_s390_inject_program_int(vcpu, ret);
-		} else if (ret > 0) {
-			/* Translation not available */
-			kvm_s390_set_psw_cc(vcpu, 3);
+	if (ret >= 0) {
+		cc = -1;
+
+		/* Fetching permitted; storing permitted */
+		if (ret == 0 && writable)
+			cc = 0;
+		/* Fetching permitted; storing not permitted */
+		else if (ret == 0 && !writable)
+			cc = 1;
+		/* Fetching not permitted; storing not permitted */
+		else if (ret == PGM_PROTECTION)
+			cc = 2;
+		/* Translation not available */
+		else if (ret != PGM_ADDRESSING && ret != PGM_TRANSLATION_SPEC)
+			cc = 3;
+
+		if (cc != -1) {
+			kvm_s390_set_psw_cc(vcpu, cc);
 			ret = 0;
+		} else {
+			ret = kvm_s390_inject_program_int(vcpu, ret);
 		}
-		goto out_unlock;
 	}
 
-	hva = gfn_to_hva_prot(vcpu->kvm, gpa_to_gfn(gpa), &writable);
-	if (kvm_is_error_hva(hva)) {
-		ret = kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
-	} else {
-		if (!writable)
-			cc = 1;		/* Write not permitted ==> read-only */
-		kvm_s390_set_psw_cc(vcpu, cc);
-		/* Note: CC2 only occurs for storage keys (not supported yet) */
-	}
-out_unlock:
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_DAT)
 		ipte_unlock(vcpu);
 	return ret;
-- 
2.35.1

