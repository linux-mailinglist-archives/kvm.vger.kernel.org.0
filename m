Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1B754B2CC8
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 19:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352542AbiBKSW2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 13:22:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347765AbiBKSW1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 13:22:27 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0AC0CFF;
        Fri, 11 Feb 2022 10:22:25 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21BGD8TH000393;
        Fri, 11 Feb 2022 18:22:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=YkaDjfN6fpTsxhXUZebdfTLf6Q+ECbzky4ml3wC9PFQ=;
 b=bSB1ayWGBeCgDybB97MtQTsm3ITL9ae7GSHR1kYJudYFVo0bEC8Sm8sCoE75GphlxSey
 P41McrjYrprPxTLwI+2qfbMb+fBBRuBjUp9Ho2+T1CppDYPmD0N5FCjTbK0JYZa0me0P
 RjUaR6Jdo7zL/mX/ls8rX2vCVYcpZclKHFaWdLXWAVGQsq1wzzOX2Dr7ryYVz/uNTcu4
 QdLUERDVIJ4gAgWLDepTZzvETjAK8ikzQdXRsDsRYk3GdtaONZPHbqZ3dv2yhVR5LHJZ
 VvW8M6jfu0NkSE86ecYeR1CYgvSfcXKU6WBd5/X5Vaiqbbq1NuPe4ZSeGhPKLRfiOsWZ 9w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e5rq56fy0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Feb 2022 18:22:24 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21BIL8jx003692;
        Fri, 11 Feb 2022 18:22:24 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e5rq56fxa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Feb 2022 18:22:24 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21BICAMe028899;
        Fri, 11 Feb 2022 18:22:22 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3e1ggkv5rw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Feb 2022 18:22:22 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21BIMI3M19726760
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Feb 2022 18:22:18 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C87AE5204F;
        Fri, 11 Feb 2022 18:22:18 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 5F61452050;
        Fri, 11 Feb 2022 18:22:18 +0000 (GMT)
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
Subject: [PATCH v4 03/10] KVM: s390: handle_tprot: Honor storage keys
Date:   Fri, 11 Feb 2022 19:22:08 +0100
Message-Id: <20220211182215.2730017-4-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220211182215.2730017-1-scgl@linux.ibm.com>
References: <20220211182215.2730017-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: IX4xPgTYb4S58olRHNcAkkwlLJzsRKHK
X-Proofpoint-GUID: OvZgHfuuJqS-j26Ss0niFWKjIjJKNHGP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-11_05,2022-02-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 adultscore=0 priorityscore=1501
 phishscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202110098
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

