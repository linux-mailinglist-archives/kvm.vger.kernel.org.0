Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E04455349A
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 16:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351433AbiFUOgT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 10:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242186AbiFUOgS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 10:36:18 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7DA61D0FB;
        Tue, 21 Jun 2022 07:36:17 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25LEEW9Z010278;
        Tue, 21 Jun 2022 14:36:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=zB8WfAckH3r7HEGpG7z+stiH/AnB45hRITZ6ksOs/UM=;
 b=HRwIBoOmCrMCDHEy3kYz7K4ZzgZWmsdB6wkKteSwVkt1Cz6kNVv8JJIVz84OD1khLl5G
 N1vzkpBEC/YxPBV8UuI4T6BRwBaPZBVEEJQOjDv97EKE0VYasewS5mTsJU9BJcx3RM6T
 RAhg7JY93r9FAXFZPbQeL8OkIoFK0cu6ySrdrqeRx1bOUR2gbusoViHsoFjSwLqvlWJW
 LUlcmqhFxNhHCglSY4X1SoYAh6APgMkA6E5u44IzKU5zznHvGy7N2qsWIw3zKxP9nBgx
 mDyRPczX1JZzgt2gg/T3sn7ZgD//qr6DjFBgTdApla2IqZYE6gfUfqc+nQAWJkVJM63h 1Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gufjxrqpw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 14:36:16 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25LEFAFX017878;
        Tue, 21 Jun 2022 14:36:16 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gufjxrqmq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 14:36:16 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25LEMn2m008875;
        Tue, 21 Jun 2022 14:36:14 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 3gs5yj39vv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 14:36:14 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25LEZQft21561828
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jun 2022 14:35:26 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 70287A4060;
        Tue, 21 Jun 2022 14:36:11 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C1D4A4054;
        Tue, 21 Jun 2022 14:36:11 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 21 Jun 2022 14:36:11 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v5 0/3] More skey instr. emulation test
Date:   Tue, 21 Jun 2022 16:36:06 +0200
Message-Id: <20220621143609.753452-1-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: AyKqADlyVMeaxyV8lcZcY9NIr-bEIdHK
X-Proofpoint-ORIG-GUID: SD-UMDI4qmK40CjN1uWccrNMvyqZiCKU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-21_07,2022-06-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 clxscore=1015 mlxlogscore=999 priorityscore=1501 bulkscore=0
 malwarescore=0 impostorscore=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206210063
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add test cases similar to those testing the effect of storage keys on
instructions emulated by KVM, but test instructions emulated by user
space/qemu instead.
Test that DIAG 308 is not subject to key protection.
Additionally, check the transaction exception identification on
protection exceptions.

This series is based on v3 of s390x: Rework TEID decoding and usage .

v4 -> v5
 * rebase onto v3 of TEID series
 * ignore ancient machines without at least ESOP-1

v3 -> v4
 * rebase on newest TEID decoding series
 * pick up r-b's (Thanks Claudio)
 * add check for protection code validity in case of basic SOP

v2 -> v3
 * move sclp patch and part of TEID test to series
       s390x: Rework TEID decoding and usage
 * make use of reworked TEID union in skey TEID test
 * get rid of pointer to array for diag 308 test
 * use lowcore symbol and mem_all
 * don't reset intparm when expecting exception in msch test

v1 -> v2
 * don't mixup sclp fix with new bits for the TEID patch
 * address feedback
       * cosmetic changes, i.e. shortening identifiers
       * remove unconditional report_info
 * add DIAG 308 test

Janis Schoetterl-Glausch (3):
  s390x: Test TEID values in storage key test
  s390x: Test effect of storage keys on some more instructions
  s390x: Test effect of storage keys on diag 308

 s390x/skey.c        | 379 +++++++++++++++++++++++++++++++++++++++++++-
 s390x/unittests.cfg |   1 +
 2 files changed, 374 insertions(+), 6 deletions(-)

Range-diff against v4:
1:  fbfd7e3b ! 1:  a30f2b45 s390x: Test TEID values in storage key test
    @@ s390x/skey.c: static void test_test_protection(void)
     +{
     +	union teid teid;
     +	int access_code;
    -+	bool dat;
     +
     +	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
     +	report_prefix_push("TEID");
     +	teid.val = lowcore.trans_exc_id;
     +	switch (get_supp_on_prot_facility()) {
     +	case SOP_NONE:
    -+		break;
     +	case SOP_BASIC:
    -+		dat = extract_psw_mask() & PSW_MASK_DAT;
    -+		report(!teid.sop_teid_predictable || !dat || !teid.sop_acc_list,
    -+		       "valid protection code");
    ++		/* let's ignore ancient/irrelevant machines */
     +		break;
     +	case SOP_ENHANCED_1:
     +		report(!teid.sop_teid_predictable, "valid protection code");
    ++		/* no access code in case of key protection */
     +		break;
     +	case SOP_ENHANCED_2:
     +		switch (teid_esop2_prot_code(teid)) {
     +		case PROT_KEY:
    -+			access_code = teid.acc_exc_f_s;
    ++			/* ESOP-2: no need to check facility */
    ++			access_code = teid.acc_exc_fetch_store;
     +
     +			switch (access_code) {
     +			case 0:
    @@ s390x/skey.c: static void test_test_protection(void)
     +				break;
     +			}
     +			/* fallthrough */
    -+		case PROT_KEY_LAP:
    ++		case PROT_KEY_OR_LAP:
     +			report_pass("valid protection code");
     +			break;
     +		default:
2:  868bb863 = 2:  b194f716 s390x: Test effect of storage keys on some more instructions
3:  d49934c0 = 3:  460d77ec s390x: Test effect of storage keys on diag 308

base-commit: 610c15284a537484682adfb4b6d6313991ab954f
prerequisite-patch-id: bebbc71ca3cc8d085e36a049466dba5a420c9c75
prerequisite-patch-id: d38a4fc7bc1fa6e352502f294cb9413f0b738b99
prerequisite-patch-id: 15d25aaab40e81ad60a13218eaba370585c4a87e
-- 
2.36.1

