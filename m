Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B048531459
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 18:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236144AbiEWNYY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 09:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236137AbiEWNYR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 09:24:17 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B7B3A702;
        Mon, 23 May 2022 06:24:14 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24NCw83I017656;
        Mon, 23 May 2022 13:24:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=tPWgy3gZWedzZ64+AzYc1rlVsol6U0cf0lsfL4LqGUM=;
 b=lhTwz1MCiUHpOroK+ETXYoxQSoHTJ7+3aMrNGQ7gvkixVyEHY/wcv74jP60XlsRD6hLx
 JQOSwM71eAQUBCAtYv5JUzjK8zVihqmEdfeU9ou5hOpzk0Zs/snRfvoBQhms8NCMS+Jt
 1A23kLPwL9zkGeDZVArUlv57QmXqebL6WnBLTVT5uO1WUaRi+SP3TvqWrBNByCYf0RK9
 yzG3V95u3c9wGDL2m7SolgJeKTBKVIOaloVpDqjR1idK2ipQWB/nGTbtjyuEaGpVk9bK
 Equt0X5HjS58Sm+nKzRDTOVSjoVdsIwcUqpowdMMiDsvBXjWFm0zQ6mziL5J+WgtGkVO dA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g8ar78kjh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 13:24:14 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24ND0XtZ030867;
        Mon, 23 May 2022 13:24:14 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g8ar78khu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 13:24:13 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24NDKJt3002502;
        Mon, 23 May 2022 13:24:11 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 3g6qq9add9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 13:24:11 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24NDO8qO40370658
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 May 2022 13:24:08 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47786A404D;
        Mon, 23 May 2022 13:24:08 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 078DAA4040;
        Mon, 23 May 2022 13:24:08 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 23 May 2022 13:24:07 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 0/4] More skey instr. emulation test
Date:   Mon, 23 May 2022 15:24:03 +0200
Message-Id: <20220523132406.1820550-1-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: sZP0NaF3jg1w_V67M4_nKTtbNFxeY7vj
X-Proofpoint-ORIG-GUID: JIBan5oi7E9v2Cbs-zI9H-xvKplPZdoX
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-23_06,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 adultscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0
 phishscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205230073
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

This series is based on s390x: Rework TEID decoding and usage .
https://lore.kernel.org/kvm/20220520190850.3445768-1-scgl@linux.ibm.com/

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

 s390x/skey.c        | 376 +++++++++++++++++++++++++++++++++++++++++++-
 s390x/unittests.cfg |   1 +
 2 files changed, 371 insertions(+), 6 deletions(-)

Range-diff against v2:
1:  3c03bfba ! 1:  073ffb3c s390x: Test TEID values in storage key test
    @@ Commit message
     
         Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
     
    - ## lib/s390x/asm/facility.h ##
    -@@
    - #include <asm/facility.h>
    - #include <asm/arch_def.h>
    - #include <bitops.h>
    -+#include <sclp.h>
    - 
    - #define NB_STFL_DOUBLEWORDS 32
    - extern uint64_t stfl_doublewords[];
    -@@ lib/s390x/asm/facility.h: static inline void setup_facilities(void)
    - 		stfle(stfl_doublewords, NB_STFL_DOUBLEWORDS);
    - }
    - 
    -+enum supp_on_prot_facility {
    -+	SOP_NONE,
    -+	SOP_BASIC,
    -+	SOP_ENHANCED_1,
    -+	SOP_ENHANCED_2,
    -+};
    -+
    -+static inline enum supp_on_prot_facility get_supp_on_prot_facility(void)
    -+{
    -+	if (sclp_facilities.has_esop) {
    -+		if (test_facility(131)) /* side-effect-access facility */
    -+			return SOP_ENHANCED_2;
    -+		else
    -+			return SOP_ENHANCED_1;
    -+	}
    -+	if (sclp_facilities.has_sop)
    -+		return SOP_BASIC;
    -+	return SOP_NONE;
    -+}
    -+
    - #endif
    -
    - ## lib/s390x/sclp.h ##
    -@@ lib/s390x/sclp.h: struct sclp_facilities {
    - 	uint64_t has_cei : 1;
    - 
    - 	uint64_t has_diag318 : 1;
    -+	uint64_t has_sop : 1;
    - 	uint64_t has_gsls : 1;
    -+	uint64_t has_esop : 1;
    - 	uint64_t has_cmma : 1;
    - 	uint64_t has_64bscao : 1;
    - 	uint64_t has_esca : 1;
    -@@ lib/s390x/sclp.h: struct sclp_facilities {
    - };
    - 
    - /* bit number within a certain byte */
    -+#define SCLP_FEAT_80_BIT_SOP		2
    - #define SCLP_FEAT_85_BIT_GSLS		0
    -+#define SCLP_FEAT_85_BIT_ESOP		6
    - #define SCLP_FEAT_98_BIT_KSS		7
    - #define SCLP_FEAT_116_BIT_64BSCAO	0
    - #define SCLP_FEAT_116_BIT_CMMA		1
    -
    - ## lib/s390x/sclp.c ##
    -@@ lib/s390x/sclp.c: void sclp_facilities_setup(void)
    - 	cpu = sclp_get_cpu_entries();
    - 	if (read_info->offset_cpu > 134)
    - 		sclp_facilities.has_diag318 = read_info->byte_134_diag318;
    -+	sclp_facilities.has_sop = sclp_feat_check(80, SCLP_FEAT_80_BIT_SOP);
    - 	sclp_facilities.has_gsls = sclp_feat_check(85, SCLP_FEAT_85_BIT_GSLS);
    -+	sclp_facilities.has_esop = sclp_feat_check(85, SCLP_FEAT_85_BIT_ESOP);
    - 	sclp_facilities.has_kss = sclp_feat_check(98, SCLP_FEAT_98_BIT_KSS);
    - 	sclp_facilities.has_cmma = sclp_feat_check(116, SCLP_FEAT_116_BIT_CMMA);
    - 	sclp_facilities.has_64bscao = sclp_feat_check(116, SCLP_FEAT_116_BIT_64BSCAO);
    -
      ## s390x/skey.c ##
     @@
       *  Janosch Frank <frankja@linux.vnet.ibm.com>
       */
      #include <libcflat.h>
    -+#include <bitops.h>
    ++#include <asm/arch_def.h>
      #include <asm/asm-offsets.h>
      #include <asm/interrupt.h>
      #include <vmalloc.h>
    @@ s390x/skey.c: static void test_test_protection(void)
     +
     +static void check_key_prot_exc(enum access access, enum protection prot)
     +{
    -+	struct lowcore *lc = 0;
     +	union teid teid;
    ++	int access_code;
     +
     +	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
     +	report_prefix_push("TEID");
    -+	teid.val = lc->trans_exc_id;
    ++	teid.val = lowcore.trans_exc_id;
     +	switch (get_supp_on_prot_facility()) {
     +	case SOP_NONE:
     +	case SOP_BASIC:
     +		break;
     +	case SOP_ENHANCED_1:
    -+		if ((teid.val & (BIT(63 - 61))) == 0)
    -+			report_pass("key-controlled protection");
    ++		report(!teid.esop1_acc_list_or_dat, "valid protection code");
     +		break;
     +	case SOP_ENHANCED_2:
    -+		if ((teid.val & (BIT(63 - 56) | BIT(63 - 61))) == 0) {
    -+			report_pass("key-controlled protection");
    -+			if (teid.val & BIT(63 - 60)) {
    -+				int access_code = teid.fetch << 1 | teid.store;
    ++		switch (teid_esop2_prot_code(teid)) {
    ++		case PROT_KEY:
    ++			access_code = teid.acc_exc_f_s;
     +
    -+				if (access_code == 2)
    -+					report((access & 2) && (prot & 2),
    -+					       "exception due to fetch");
    -+				if (access_code == 1)
    -+					report((access & 1) && (prot & 1),
    -+					       "exception due to store");
    -+				/* no relevant information if code is 0 or 3 */
    ++			switch (access_code) {
    ++			case 0:
    ++				report_pass("valid access code");
    ++				break;
    ++			case 1:
    ++			case 2:
    ++				report((access & access_code) && (prot & access_code),
    ++				       "valid access code");
    ++				break;
    ++			case 3:
    ++				/*
    ++				 * This is incorrect in that reserved values
    ++				 * should be ignored, but kvm should not return
    ++				 * a reserved value and having a test for that
    ++				 * is more valuable.
    ++				 */
    ++				report_fail("valid access code");
    ++				break;
     +			}
    ++			/* fallthrough */
    ++		case PROT_KEY_LAP:
    ++			report_pass("valid protection code");
    ++			break;
    ++		default:
    ++			report_fail("valid protection code");
     +		}
     +		break;
     +	}
    @@ s390x/skey.c: static void test_set_prefix(void)
      
     @@ s390x/skey.c: static void test_set_prefix(void)
      	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
    - 	set_prefix_key_1((uint32_t *)2048);
    + 	set_prefix_key_1((uint32_t *)&mem_all[2048]);
      	install_page(root, 0, 0);
     -	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
     +	check_key_prot_exc(ACC_FETCH, PROT_FETCH_STORE);
2:  0b7b0e57 ! 2:  9f300b87 s390x: Test effect of storage keys on some more instructions
    @@ s390x/skey.c: static void test_set_prefix(void)
     +{
     +	uint32_t program_mask;
     +
    -+/*
    -+ * gcc 12.0.1 warns if schib is < 4k.
    -+ * We need such addresses to test fetch protection override.
    -+ */
    -+#pragma GCC diagnostic push
    -+#pragma GCC diagnostic ignored "-Warray-bounds"
     +	asm volatile (
     +		"lr %%r1,%[sid]\n\t"
     +		"spka	0x10\n\t"
    @@ s390x/skey.c: static void test_set_prefix(void)
     +		  [schib] "Q" (*schib)
     +		: "%r1"
     +	);
    -+#pragma GCC diagnostic pop
     +	return program_mask >> 28;
     +}
     +
    @@ s390x/skey.c: static void test_set_prefix(void)
     +		expect_pgm_int();
     +		modify_subchannel_key_1(test_device_sid, schib);
     +		check_key_prot_exc(ACC_FETCH, PROT_FETCH_STORE);
    -+		WRITE_ONCE(schib->pmcw.intparm, 0);
     +		cc = stsch(test_device_sid, schib);
     +		report(!cc && schib->pmcw.intparm == 0, "did not modify subchannel");
     +		report_prefix_pop();
    @@ s390x/skey.c: static void test_set_prefix(void)
     +		modify_subchannel_key_1(test_device_sid, (struct schib *)0);
     +		install_page(root, 0, 0);
     +		check_key_prot_exc(ACC_FETCH, PROT_FETCH_STORE);
    -+		WRITE_ONCE(schib->pmcw.intparm, 0);
     +		cc = stsch(test_device_sid, schib);
     +		report(!cc && schib->pmcw.intparm == 0, "did not modify subchannel");
     +		report_prefix_pop();
    @@ s390x/skey.c: static void test_set_prefix(void)
     +		set_storage_key(pagebuf, 0x28, 0);
     +		expect_pgm_int();
     +		install_page(root, virt_to_pte_phys(root, pagebuf), 0);
    -+		modify_subchannel_key_1(test_device_sid, (struct schib *)2048);
    ++		modify_subchannel_key_1(test_device_sid, (struct schib *)&mem_all[2048]);
     +		install_page(root, 0, 0);
     +		check_key_prot_exc(ACC_FETCH, PROT_FETCH_STORE);
    -+		WRITE_ONCE(schib->pmcw.intparm, 0);
     +		cc = stsch(test_device_sid, schib);
     +		report(!cc && schib->pmcw.intparm == 0, "did not modify subchannel");
     +		report_prefix_pop();
3:  7fb70993 ! 3:  c4ca0619 s390x: Test effect of storage keys on diag 308
    @@ s390x/skey.c: static void test_store_cpu_address(void)
     +static void test_diag_308(void)
     +{
     +	uint16_t response;
    -+	uint32_t (*ipib)[1024] = (void *)pagebuf;
    ++	uint32_t *ipib = (uint32_t *)pagebuf;
     +
     +	report_prefix_push("DIAG 308");
    -+	(*ipib)[0] = 0; /* Invalid length */
    ++	WRITE_ONCE(ipib[0], 0); /* Invalid length */
     +	set_storage_key(ipib, 0x28, 0);
     +	/* key-controlled protection does not apply */
     +	asm volatile (

base-commit: 8719e8326101c1be8256617caf5835b57e819339
prerequisite-patch-id: aa682f50e4eba0e9b6cacd245d568f5bcca05e0f
prerequisite-patch-id: 55b90f625ada542f074cecb82cf63e2980205ce1
prerequisite-patch-id: bebbc71ca3cc8d085e36a049466dba5a420c9c75
prerequisite-patch-id: d38a4fc7bc1fa6e352502f294cb9413f0b738b99
prerequisite-patch-id: 16ccb9380be55e33fc96639bf69570a9f8327697
-- 
2.33.1

