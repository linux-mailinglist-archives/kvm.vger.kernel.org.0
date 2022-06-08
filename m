Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A112854316E
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 15:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240261AbiFHNdR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 09:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240190AbiFHNdM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 09:33:12 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827071105E4;
        Wed,  8 Jun 2022 06:33:11 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 258DM8xA012024;
        Wed, 8 Jun 2022 13:33:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=iJU0IMYtRXpUt9NA3ZRPpxE5Kg9QWC8rk5Bf7StkcA0=;
 b=oZQli1/BCn2+t4BU7Fh70ZbxfR3AkOIcOVhqzojpM4g6UA0K+9Dk9SqmNQBe44WrX2w8
 Qk8SqmHQTM1GptBAmuip9ge9nDWosJQFX0Mgxqj6IPjzDej06Xl0AVaASOiSmvosm+nd
 +62CxxbmimSV4rZpquUQb+OkwbW5Lt6av8ydjGcYwzf0u1cfIIqEOJora4PdW5KVumYW
 rg1i8c/HYiXlSq22qmxS7VjURpDDL6vb+Xq+JaDvxmwxhU14H/BfYAiOM+ww1ypHN5Us
 8Hr9cgmOLPTiX+drpYEd9yvnJG0u4HPhX/17j7BwpuFIfR0vlq4dKdt5y9vCzKCFlwTk Xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gjvkf87mq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 13:33:10 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 258DMUHZ012914;
        Wed, 8 Jun 2022 13:33:10 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gjvkf87m3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 13:33:09 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 258DLBAk005731;
        Wed, 8 Jun 2022 13:33:08 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 3gfy18v5mb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 13:33:08 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 258DX5sW21627390
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Jun 2022 13:33:05 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E7CDD11C052;
        Wed,  8 Jun 2022 13:33:04 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC34911C058;
        Wed,  8 Jun 2022 13:33:04 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Jun 2022 13:33:04 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 0/3] s390x: Rework TEID decoding and usage
Date:   Wed,  8 Jun 2022 15:33:00 +0200
Message-Id: <20220608133303.1532166-1-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: U5KFwoqDy32_p8kPbHa6va_RBPSTYNwo
X-Proofpoint-GUID: RGB9SIWWVt3rDmWiLYCVyfx6xdZ-SegM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-08_04,2022-06-07_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 mlxlogscore=999 lowpriorityscore=0 spamscore=0 mlxscore=0 phishscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206080058
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
This series is based on  v3 of series s390x: Avoid gcc 12 warnings .
The sclp fix is taken from v2 More skey instr. emulation test,
and could be picked independently from the rest of the series.

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
 lib/s390x/asm/interrupt.h | 61 +++++++++++++++++++++++++++---------
 lib/s390x/fault.h         | 30 +++++-------------
 lib/s390x/sclp.h          | 18 ++++++-----
 lib/s390x/fault.c         | 65 ++++++++++++++++++++++++++-------------
 lib/s390x/interrupt.c     |  2 +-
 lib/s390x/sclp.c          |  2 ++
 s390x/edat.c              | 26 ++++++++++------
 8 files changed, 149 insertions(+), 76 deletions(-)

Range-diff against v1:
1:  abb9b37a = 1:  6427944a s390x: Fix sclp facility bit numbers
2:  5662f4bc ! 2:  a08fce3b s390x: lib: SOP facility query function
    @@ Commit message
         installed.
     
         Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
    +    Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
     
      ## lib/s390x/asm/facility.h ##
     @@
3:  b716e5ef ! 3:  eb268af1 s390x: Rework TEID decoding and usage
    @@ lib/s390x/asm/interrupt.h
     +			uint64_t addr			: 52 -  0;
     +			uint64_t acc_exc_f_s		: 54 - 52;
     +			uint64_t side_effect_acc	: 55 - 54;
    -+			uint64_t /* reserved */		: 55 - 54;
    ++			uint64_t /* reserved */		: 62 - 55;
     +			uint64_t asce_id		: 64 - 62;
     +		};
     +		/* DAT exc */
    @@ lib/s390x/asm/interrupt.h
     +			uint64_t sop_acc_list		: 61 - 60;
     +			uint64_t sop_teid_predictable	: 62 - 61;
     +		};
    -+		/* enhanced suppression on protection 1 */
    -+		struct {
    -+			uint64_t /* pad */		: 61 -  0;
    -+			uint64_t esop1_acc_list_or_dat	: 62 - 61;
    -+		};
     +		/* enhanced suppression on protection 2 */
     +		struct {
     +			uint64_t /* pad */		: 56 -  0;
    @@ lib/s390x/asm/interrupt.h
     +
     +static inline enum prot_code teid_esop2_prot_code(union teid teid)
     +{
    -+	int code = 0;
    ++	int code = (teid.esop2_prot_code_0 << 2 |
    ++		    teid.esop2_prot_code_1 << 1 |
    ++		    teid.esop2_prot_code_2);
     +
    -+	code = code << 1 | teid.esop2_prot_code_0;
    -+	code = code << 1 | teid.esop2_prot_code_1;
    -+	code = code << 1 | teid.esop2_prot_code_2;
    ++	assert(code < 6);
     +	return (enum prot_code)code;
     +}
     +
    @@ lib/s390x/fault.c
     -		printf("Type: LAP\n");
     -		return;
     -	}
    --
    + 
     -	if (prot_is_iep(teid)) {
     -		printf("Type: IEP\n");
     -		return;
     -	}
    - 
    --	if (prot_is_datp(teid)) {
    --		printf("Type: DAT\n");
    --		return;
     +static void print_decode_pgm_prot(union teid teid, bool dat)
     +{
     +	switch (get_supp_on_prot_facility()) {
    @@ lib/s390x/fault.c
     +			printf("Type: ?\n");
     +		break;
     +	case SOP_ENHANCED_1:
    -+		if (teid.esop1_acc_list_or_dat) {
    ++		if (teid.sop_teid_predictable) {/* implies access list or DAT */
     +			if (teid.sop_acc_list)
     +				printf("Type: ACC\n");
     +			else
    @@ lib/s390x/fault.c
     +			printf("Type: KEY or LAP\n");
     +		}
     +		break;
    -+	case SOP_ENHANCED_2:
    -+		switch (teid_esop2_prot_code(teid)) {
    -+		case PROT_KEY_LAP:
    -+			printf("Type: KEY or LAP\n");
    -+			break;
    -+		case PROT_DAT:
    -+			printf("Type: DAT\n");
    -+			break;
    -+		case PROT_KEY:
    -+			printf("Type: KEY\n");
    -+			break;
    -+		case PROT_ACC_LIST:
    -+			printf("Type: ACC\n");
    -+			break;
    -+		case PROT_LAP:
    -+			printf("Type: LAP\n");
    -+			break;
    -+		case PROT_IEP:
    -+			printf("Type: IEP\n");
    -+			break;
    ++	case SOP_ENHANCED_2: {
    ++		static const char * const prot_str[] = {
    ++			"KEY or LAP",
    ++			"DAT",
    ++			"KEY",
    ++			"ACC",
    ++			"LAP",
    ++			"IEP",
    ++		};
    ++		int prot_code = teid_esop2_prot_code(teid);
    + 
    +-	if (prot_is_datp(teid)) {
    +-		printf("Type: DAT\n");
    +-		return;
    ++		assert(0 <= prot_code && prot_code < ARRAY_SIZE(prot_str));
    ++		printf("Type: %s\n", prot_str[prot_code]);
     +		}
      	}
      }
    @@ lib/s390x/interrupt.c: static void fixup_pgm_int(struct stack_frame_int *stack)
      			 * the exception so we can use the return
     
      ## s390x/edat.c ##
    +@@ s390x/edat.c: static void *root, *mem, *m;
    + volatile unsigned int *p;
    + 
    + /*
    +- * Check if a non-access-list protection exception happened for the given
    +- * address, in the primary address space.
    ++ * Check if the exception is consistent with DAT protection and has the correct
    ++ * address and primary address space.
    +  */
    + static bool check_pgm_prot(void *ptr)
    + {
     @@ s390x/edat.c: static bool check_pgm_prot(void *ptr)
      		return false;
      
    @@ s390x/edat.c: static bool check_pgm_prot(void *ptr)
     +	case SOP_BASIC:
     +		if (!teid.sop_teid_predictable)
     +			return true;
    ++		break;
     +	case SOP_ENHANCED_1:
    -+		if (!teid.esop1_acc_list_or_dat)
    ++		if (!teid.sop_teid_predictable) /* implies key or low addr */
     +			return false;
    ++		break;
     +	case SOP_ENHANCED_2:
    -+		if (teid_esop2_prot_code(teid) != 1)
    ++		if (teid_esop2_prot_code(teid) != PROT_DAT)
     +			return false;
     +	}
     +	return (!teid.sop_acc_list && !teid.asce_id &&

base-commit: 2eed0bf1096077144cc3a0dd9974689487f9511a
prerequisite-patch-id: aa682f50e4eba0e9b6cacd245d568f5bcca05e0f
prerequisite-patch-id: 79a88ac3faff3ae2ef214bf4a90de7463e2fdc8a
-- 
2.33.1

