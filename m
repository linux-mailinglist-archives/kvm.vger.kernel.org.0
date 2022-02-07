Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 223FF4AC70D
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 18:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382791AbiBGROx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 12:14:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357819AbiBGRAL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 12:00:11 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8565CC0401DB;
        Mon,  7 Feb 2022 09:00:08 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 217GxTNm017305;
        Mon, 7 Feb 2022 17:00:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=YkaDjfN6fpTsxhXUZebdfTLf6Q+ECbzky4ml3wC9PFQ=;
 b=SQ1J6i0Gxr5Emj4gtIRmqPDQx/mMsTK8ueGg8iyTxYlvA1H2I6JGGb60z6FchGoDMzad
 bAX9mrjegy185RWCXGSjxG8IJgRIwT+AQtaHHXqNG0K27nOAUpl7EIlkmDXPsOWzvp3b
 U/B42Ylk8udTvc3PAbGe+vGxGF9OFU++ivBDop9QC3QtbchNF8ydnGkLZ6I7xKCGLCVY
 ksA8VOMnNK6/dbjLahG8HyizCMDhcGld/M5uJ6lQ4R7pkPnUrx6aKPbqvv2BHVPAjOdO
 vdFCzAwnyIHbWhSzzQkxSCbWERv6S8KQJxhUD+qoSYxxpfmFzDEbAIUzCxcg5DzoioTF uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e22vkt04u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 17:00:06 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 217GxaaM020266;
        Mon, 7 Feb 2022 17:00:06 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e22vkt03v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 17:00:05 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 217GqTR5010178;
        Mon, 7 Feb 2022 17:00:04 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3e1gv96tu5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 17:00:04 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 217H012o46924214
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Feb 2022 17:00:01 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 16CD5A405B;
        Mon,  7 Feb 2022 17:00:01 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9AF15A4040;
        Mon,  7 Feb 2022 17:00:00 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Feb 2022 17:00:00 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH v2 03/11] KVM: s390: handle_tprot: Honor storage keys
Date:   Mon,  7 Feb 2022 17:59:22 +0100
Message-Id: <20220207165930.1608621-4-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220207165930.1608621-1-scgl@linux.ibm.com>
References: <20220207165930.1608621-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: m5NNYntGTCQaGQsLewLM-0SJAHsxNHv5
X-Proofpoint-ORIG-GUID: YV6h6io7gdEm-IUqssa6a_KLqyPbWebZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_06,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 lowpriorityscore=0 mlxscore=0 impostorscore=0 phishscore=0 suspectscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202070103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
2.32.0

