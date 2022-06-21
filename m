Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3C8A553487
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 16:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351663AbiFUOb0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 10:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351627AbiFUOa2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 10:30:28 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6BD924087;
        Tue, 21 Jun 2022 07:30:27 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25LEMPpY032758;
        Tue, 21 Jun 2022 14:30:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=G77G9Wa45vJ6VZ9nP/Ip4au3tZF51LaffZ9fqIDUtEU=;
 b=e9KY4HUzKWtJEsa2cMWPnKyhpmkT0P2cQ5UJgt+Vzaoz7T/4LRC4DZXqf3ZXxU7HsHae
 I1NwD0SC2QxKWO8VoGr9nQkICB1GUngaaNhdUY2T+sBx8VHFrVsncln2ROoTyn2KHDoz
 Qk8MNOkXqzhZHyvbxKrLxp7I8JxqIHE8vKqRqiTcS99ooeNELkicke8T+kKH8+XtW8oZ
 S/stcaT8QbDgvD+UaJ2dHZBDGBT/g81uNvy7erLB8KI1QpBfJRwlLgDw/OEypvzedhOO
 27+zSgCTAQRMlub1QQLODfHcYKgaMUQYBIw8kzZTO/W6JCUILoY48fKVHBhVnwaKQG7o 9w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gufpd864c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 14:30:26 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25LEMPuC032678;
        Tue, 21 Jun 2022 14:30:26 GMT
Received: from ppma01fra.de.ibm.com ([159.122.73.70])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gufpd85xh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 14:30:26 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25LELFaR006266;
        Tue, 21 Jun 2022 14:30:20 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3gs6b8kaa8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 14:30:20 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25LEUHm220971884
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jun 2022 14:30:17 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46A304C040;
        Tue, 21 Jun 2022 14:30:17 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91E5F4C044;
        Tue, 21 Jun 2022 14:30:16 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 21 Jun 2022 14:30:16 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 0/3] s390x: Rework TEID decoding and usage
Date:   Tue, 21 Jun 2022 16:30:12 +0200
Message-Id: <20220621143015.748290-1-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -it-OrZlpTHyFFdpmI2rQEwKba4A2ZAO
X-Proofpoint-ORIG-GUID: 4lDE_W78ghiKc3prjopzPIpXQI9zXSVv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-21_06,2022-06-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2204290000 definitions=main-2206210062
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The translation-exception identification (TEID) contains information to
identify the cause of certain program exceptions, including translation
exceptions occurring during dynamic address translation, as well as
protection exceptions.
The meaning of fields in the TEID is complex, depending on the exception
occurring and various potentially installed facilities.

Add function to query which suppression-on-protection facility is
installed.
Rework the type describing the TEID, in order to ease decoding.
Change the existing code interpreting the TEID and extend it to take the
installed suppression-on-protection facility into account.

Also fix the sclp bit order.

v2 -> v3
 * rename some identifiers
 * implement Claudio's feedback to assert that the array for printing
   has the correct number of elements. I kept the array inside the
   printing function, tho, because I consider its content an implementation
   detail
 * ignore ancient machines without at least ESOP-1

v1 -> v2
 * pick up r-b
 * get rid of esop1 alias of sop_teid_predictable
 * assert that the esop2 protection code is valid
 * use string literal array and indexing for protection code printing
 * fix protection exception check in edat.c

Janis Schoetterl-Glausch (3):
  s390x: Fix sclp facility bit numbers
  s390x: lib: SOP facility query function
  s390x: Rework TEID decoding and usage

 lib/s390x/asm/facility.h  | 21 +++++++++++++
 lib/s390x/asm/interrupt.h | 62 ++++++++++++++++++++++++++++++---------
 lib/s390x/fault.h         | 30 +++++--------------
 lib/s390x/sclp.h          | 18 +++++++-----
 lib/s390x/fault.c         | 58 +++++++++++++++++++++++-------------
 lib/s390x/interrupt.c     |  2 +-
 lib/s390x/sclp.c          |  2 ++
 s390x/edat.c              | 25 +++++++++-------
 8 files changed, 142 insertions(+), 76 deletions(-)

Range-diff against v2:
1:  6427944a = 1:  189e03ca s390x: Fix sclp facility bit numbers
2:  a08fce3b = 2:  0783c2a4 s390x: lib: SOP facility query function
3:  eb268af1 ! 3:  615ec8df s390x: Rework TEID decoding and usage
    @@ lib/s390x/asm/interrupt.h
     +		/* common fields DAT exc & protection exc */
     +		struct {
     +			uint64_t addr			: 52 -  0;
    -+			uint64_t acc_exc_f_s		: 54 - 52;
    ++			uint64_t acc_exc_fetch_store	: 54 - 52;
     +			uint64_t side_effect_acc	: 55 - 54;
     +			uint64_t /* reserved */		: 62 - 55;
     +			uint64_t asce_id		: 64 - 62;
    @@ lib/s390x/asm/interrupt.h
      };
      
     +enum prot_code {
    -+	PROT_KEY_LAP,
    ++	PROT_KEY_OR_LAP,
     +	PROT_DAT,
     +	PROT_KEY,
     +	PROT_ACC_LIST,
     +	PROT_LAP,
     +	PROT_IEP,
    ++	PROT_NUM_CODES /* Must always be last */
     +};
     +
     +static inline enum prot_code teid_esop2_prot_code(union teid teid)
    @@ lib/s390x/asm/interrupt.h
     +		    teid.esop2_prot_code_1 << 1 |
     +		    teid.esop2_prot_code_2);
     +
    -+	assert(code < 6);
    ++	assert(code < PROT_NUM_CODES);
     +	return (enum prot_code)code;
     +}
     +
    @@ lib/s390x/fault.c
     -		printf("Type: IEP\n");
     -		return;
     -	}
    -+static void print_decode_pgm_prot(union teid teid, bool dat)
    ++static void print_decode_pgm_prot(union teid teid)
     +{
     +	switch (get_supp_on_prot_facility()) {
     +	case SOP_NONE:
    -+		printf("Type: ?\n");
    -+		break;
     +	case SOP_BASIC:
    -+		if (teid.sop_teid_predictable && dat && teid.sop_acc_list)
    -+			printf("Type: ACC\n");
    -+		else
    -+			printf("Type: ?\n");
    ++		printf("Type: ?\n"); /* modern/relevant machines have ESOP */
     +		break;
     +	case SOP_ENHANCED_1:
     +		if (teid.sop_teid_predictable) {/* implies access list or DAT */
    @@ lib/s390x/fault.c
     +			"LAP",
     +			"IEP",
     +		};
    ++		_Static_assert(ARRAY_SIZE(prot_str) == PROT_NUM_CODES);
     +		int prot_code = teid_esop2_prot_code(teid);
      
     -	if (prot_is_datp(teid)) {
     -		printf("Type: DAT\n");
     -		return;
    -+		assert(0 <= prot_code && prot_code < ARRAY_SIZE(prot_str));
     +		printf("Type: %s\n", prot_str[prot_code]);
     +		}
      	}
    @@ lib/s390x/fault.c
      	case AS_PRIM:
      		printf("Primary\n");
      		break;
    -@@ lib/s390x/fault.c: void print_decode_teid(uint64_t teid)
    - 	}
    - 
    - 	if (lowcore.pgm_int_code == PGM_INT_CODE_PROTECTION)
    --		print_decode_pgm_prot(teid);
    -+		print_decode_pgm_prot(teid, dat);
    - 
    - 	/*
    - 	 * If teid bit 61 is off for these two exception the reported
     @@ lib/s390x/fault.c: void print_decode_teid(uint64_t teid)
      	 */
      	if ((lowcore.pgm_int_code == PGM_INT_CODE_SECURE_STOR_ACCESS ||
    @@ s390x/edat.c: static bool check_pgm_prot(void *ptr)
     -	 * field might or might not be meaningful when the m field is 0.
     -	 */
     -	if (!teid.m)
    +-		return true;
    +-	return (!teid.acc_list_prot && !teid.asce_id &&
     +	switch (get_supp_on_prot_facility()) {
     +	case SOP_NONE:
    - 		return true;
    --	return (!teid.acc_list_prot && !teid.asce_id &&
     +	case SOP_BASIC:
    -+		if (!teid.sop_teid_predictable)
    -+			return true;
    -+		break;
    ++		assert(false); /* let's ignore ancient/irrelevant machines */
     +	case SOP_ENHANCED_1:
     +		if (!teid.sop_teid_predictable) /* implies key or low addr */
     +			return false;

base-commit: 610c15284a537484682adfb4b6d6313991ab954f
-- 
2.36.1

