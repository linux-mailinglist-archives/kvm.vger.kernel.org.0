Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABDBD6D773D
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 10:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237608AbjDEIqA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 04:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237590AbjDEIpt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 04:45:49 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365E24693
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 01:45:47 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3358QYtk015622;
        Wed, 5 Apr 2023 08:45:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=3AMcCdIrjohLjHCBBSvqMu35AOG2/1a/6RSDFdhoE2s=;
 b=ZLzVOpQTzCSOla4AD0iSKMQly0YWkaSwnTp9yBpp199ECMYUnr1NeBkqsVvqyOdUAJ3w
 ThzNjzFO8+w5LSuYdWNz+V4vCrKXd12WS5g1Qc9vBTVes1TspTwPKcRBPOlXuH6zUK4k
 10H0lYsfWJPESpqE/ipFlvrdA+FTnRrOg3EPY9P9l0w3QoGvgpixqIJ4rhnvvMvTYVby
 hkFyeeulSzkczZ0nU35sB/pJvVRfF7GPO1P1qGtgOqbETI0ZlP+V7BE7fkypIZLvKb0h
 mNZYvePSpZ8G/zpd9WDrxyfJnBZ37uvzn9e/z9cbAEJLddSrqnNvvx8fUp+j8OoRsPOk IA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ps5fwrdd2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Apr 2023 08:45:44 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3358Rh64018284;
        Wed, 5 Apr 2023 08:45:44 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ps5fwrdch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Apr 2023 08:45:44 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3345JbQm003662;
        Wed, 5 Apr 2023 08:45:42 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3ppc872cst-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Apr 2023 08:45:42 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3358jdBV31064516
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Apr 2023 08:45:39 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E866120043;
        Wed,  5 Apr 2023 08:45:38 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 86D4720040;
        Wed,  5 Apr 2023 08:45:38 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.171.30.226])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  5 Apr 2023 08:45:38 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL v3 14/14] s390x: sie: Test whether the epoch extension field is working as expected
Date:   Wed,  5 Apr 2023 10:45:28 +0200
Message-Id: <20230405084528.16027-15-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230405084528.16027-1-nrb@linux.ibm.com>
References: <20230405084528.16027-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: iL6mW8gkBuysM2guR_yXi3NngtnljC2r
X-Proofpoint-ORIG-GUID: e1o1fUU_FxnYMkrucfymtGwpyO04X4DT
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-05_04,2023-04-04_05,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 spamscore=0 lowpriorityscore=0 mlxscore=0 suspectscore=0 adultscore=0
 impostorscore=0 clxscore=1015 priorityscore=1501 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304050079
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Huth <thuth@redhat.com>

We recently discovered a bug with the time management in nested scenarios
which got fixed by kernel commit "KVM: s390: vsie: Fix the initialization
of the epoch extension (epdx) field". This adds a simple test for this
bug so that it is easier to determine whether the host kernel of a machine
has already been fixed or not.

Signed-off-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20221208170502.17984-1-thuth@redhat.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/sie.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/s390x/sie.c b/s390x/sie.c
index 87575b2..cd3cea1 100644
--- a/s390x/sie.c
+++ b/s390x/sie.c
@@ -58,6 +58,33 @@ static void test_diags(void)
 	}
 }
 
+static void test_epoch_ext(void)
+{
+	u32 instr[] = {
+		0xb2780000,	/* STCKE 0 */
+		0x83000044	/* DIAG 0x44 to intercept */
+	};
+
+	if (!test_facility(139)) {
+		report_skip("epdx: Multiple Epoch Facility is not available");
+		return;
+	}
+
+	guest[0] = 0x00;
+	memcpy(guest_instr, instr, sizeof(instr));
+
+	vm.sblk->gpsw.addr = PAGE_SIZE * 2;
+	vm.sblk->gpsw.mask = PSW_MASK_64;
+
+	vm.sblk->ecd |= ECD_MEF;
+	vm.sblk->epdx = 0x47;	/* Setting the epoch extension here ... */
+
+	sie(&vm);
+
+	/* ... should result in the same epoch extension here: */
+	report(guest[0] == 0x47, "epdx: different epoch is visible in the guest");
+}
+
 static void setup_guest(void)
 {
 	setup_vm();
@@ -80,6 +107,7 @@ int main(void)
 
 	setup_guest();
 	test_diags();
+	test_epoch_ext();
 	sie_guest_destroy(&vm);
 
 done:
-- 
2.39.2

