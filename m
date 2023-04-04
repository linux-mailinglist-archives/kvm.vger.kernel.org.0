Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 461F66D5F2E
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 13:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234887AbjDDLhS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 07:37:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234583AbjDDLhG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 07:37:06 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE49030D2
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 04:37:00 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3349p13h015647;
        Tue, 4 Apr 2023 11:36:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=3AMcCdIrjohLjHCBBSvqMu35AOG2/1a/6RSDFdhoE2s=;
 b=rFhS5hv0vJo3YWmVWsAMgfqFKtny4E1Msh3EBG9X7P/pds24wV7TfeQiagSNjdGWmEEj
 xtH/DzPEjx8VvVKoUjx6JLNungcocrqiD4dFB4PiWr40VKeFuvsrTOXDqPztP79iP2OF
 ToAEsbzTygAY9YlTBtSCw+xnzgMBLy9AF7cIM8Wo7iuba9ZdEqFcM7V9phOAEXVhVIOD
 G3fyd0/Lv/9DQDbyLF5C44ZNrltB0i3O1R0DdZ+KvYgKjtku/ORfPW0ZuLBKxpd3QoLX
 DlRN/n2xGIpGghreTi83sLG8N1DNNkbfdDZwpEWXK0Az0GEx4TIHGjxs3f1lPVEY8Sp2 EQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3prhmg2eyc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:36:58 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 334AaIpS013365;
        Tue, 4 Apr 2023 11:36:58 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3prhmg2exq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:36:57 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 334AeW4b009324;
        Tue, 4 Apr 2023 11:36:56 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3ppc872fh1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Apr 2023 11:36:55 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 334BaqNo19923586
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Apr 2023 11:36:52 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6CAD320040;
        Tue,  4 Apr 2023 11:36:52 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F008120043;
        Tue,  4 Apr 2023 11:36:51 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.171.55.238])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  4 Apr 2023 11:36:51 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL v2 14/14] s390x: sie: Test whether the epoch extension field is working as expected
Date:   Tue,  4 Apr 2023 13:36:39 +0200
Message-Id: <20230404113639.37544-15-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230404113639.37544-1-nrb@linux.ibm.com>
References: <20230404113639.37544-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: d5OzGrhZWbwK4yXiOXCnijr7S8Itl1jf
X-Proofpoint-GUID: pC9o07CNxJw9Jx7jOb2bSmEnGwTh88fM
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_04,2023-04-04_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 priorityscore=1501 clxscore=1015 suspectscore=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 adultscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304040107
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

