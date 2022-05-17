Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1466652A0DC
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 13:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345595AbiEQL4n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 07:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345706AbiEQL4R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 07:56:17 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EA8C63DE;
        Tue, 17 May 2022 04:56:16 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HBLuPl012176;
        Tue, 17 May 2022 11:56:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=hkaSxpqDyBypQ2lyVYVRObIKtvqovSvWiWVVakMj9D0=;
 b=ET53wpN7FXOwfhidSrrfmEFVnVPUW9jvcYP/zidouftH6i5YCR6t0M7U6J7bFEuI3GVj
 EI9zg/DqhajcjtGsA02zbFVYCXXzurfF2JKfQ4WQnE+AuBqSgqVy5jxhTe8nHmSM0nI0
 EX/ZGEaMYKNyqkL+pWP2I5NrZNTbqHpK3ZeKvXWvmvbKc+deLHI8qSbcQKenbdKn6+Dm
 lUpz8T2QTFDZ6LymEZ/+1t3kFsfuqsOCLBaf80+grlHxTuqxiXGpASE9z1lAaKg0wDGa
 rdsoDOKn4V616Qkfu2wbxO8Np47+beVnv7zjDuLBlgLMMEeN5GJzX7Qfpx6CgHMRDBFX Hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4artgn4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 11:56:15 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24HBgqQH026980;
        Tue, 17 May 2022 11:56:15 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4artgn3w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 11:56:15 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24HBqOWT003143;
        Tue, 17 May 2022 11:56:13 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3g2428kb2w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 11:56:12 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24HBu9Sp45679002
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 11:56:09 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 89A62A4051;
        Tue, 17 May 2022 11:56:09 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46954A404D;
        Tue, 17 May 2022 11:56:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 May 2022 11:56:09 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 0/4] More skey instr. emulation test
Date:   Tue, 17 May 2022 13:56:03 +0200
Message-Id: <20220517115607.3252157-1-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: AjDps0Rzh1l0GYX8oRNp0lZPxvdAETSv
X-Proofpoint-GUID: pL9AijttjOFNRnWS9OAN-OyC8DUrRp0-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_02,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 bulkscore=0 suspectscore=0 impostorscore=0
 clxscore=1015 priorityscore=1501 malwarescore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170069
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

v1 -> v2
 * don't mixup sclp fix with new bits for the TEID patch
 * address feedback
       * cosmetic changes, i.e. shortening identifiers
       * remove unconditional report_info
 * add DIAG 308 test

Janis Schoetterl-Glausch (4):
  s390x: Fix sclp facility bit numbers
  s390x: Test TEID values in storage key test
  s390x: Test effect of storage keys on some more instructions
  s390x: Test effect of storage keys on diag 308

 lib/s390x/asm/facility.h |  21 +++
 lib/s390x/sclp.h         |  18 +-
 lib/s390x/sclp.c         |   2 +
 s390x/skey.c             | 371 ++++++++++++++++++++++++++++++++++++++-
 s390x/unittests.cfg      |   1 +
 5 files changed, 400 insertions(+), 13 deletions(-)

Range-diff against v1:
1:  4c833d84 ! 1:  d6e6b532 s390x: Fix sclp facility bit numbers
    @@ Commit message
     
         Fixes: 4dd649c8 ("lib: s390x: sclp: Extend feature probing")
         Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
    +    Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
    +    Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
     
      ## lib/s390x/sclp.h ##
     @@ lib/s390x/sclp.h: struct sclp_facilities {
    @@ lib/s390x/sclp.h: struct sclp_facilities {
     -#define SCLP_FEAT_116_BIT_ESCA		3
     -#define SCLP_FEAT_117_BIT_PFMFI		6
     -#define SCLP_FEAT_117_BIT_IBS		5
    -+#define SCLP_FEAT_80_BIT_SOP		2
     +#define SCLP_FEAT_85_BIT_GSLS		0
    -+#define SCLP_FEAT_85_BIT_ESOP		6
     +#define SCLP_FEAT_98_BIT_KSS		7
     +#define SCLP_FEAT_116_BIT_64BSCAO	0
     +#define SCLP_FEAT_116_BIT_CMMA		1
2:  1defccd8 ! 2:  3c03bfba s390x: Test TEID values in storage key test
    @@ lib/s390x/sclp.h: struct sclp_facilities {
      	uint64_t has_cmma : 1;
      	uint64_t has_64bscao : 1;
      	uint64_t has_esca : 1;
    +@@ lib/s390x/sclp.h: struct sclp_facilities {
    + };
    + 
    + /* bit number within a certain byte */
    ++#define SCLP_FEAT_80_BIT_SOP		2
    + #define SCLP_FEAT_85_BIT_GSLS		0
    ++#define SCLP_FEAT_85_BIT_ESOP		6
    + #define SCLP_FEAT_98_BIT_KSS		7
    + #define SCLP_FEAT_116_BIT_64BSCAO	0
    + #define SCLP_FEAT_116_BIT_CMMA		1
     
      ## lib/s390x/sclp.c ##
     @@ lib/s390x/sclp.c: void sclp_facilities_setup(void)
    @@ s390x/skey.c: static void test_test_protection(void)
      }
      
     +enum access {
    -+	ACC_FETCH = 2,
     +	ACC_STORE = 1,
    ++	ACC_FETCH = 2,
     +	ACC_UPDATE = 3,
     +};
     +
    @@ s390x/skey.c: static void test_test_protection(void)
     +			if (teid.val & BIT(63 - 60)) {
     +				int access_code = teid.fetch << 1 | teid.store;
     +
    -+				report_info("access code: %d", access_code);
     +				if (access_code == 2)
     +					report((access & 2) && (prot & 2),
     +					       "exception due to fetch");
     +				if (access_code == 1)
     +					report((access & 1) && (prot & 1),
     +					       "exception due to store");
    ++				/* no relevant information if code is 0 or 3 */
     +			}
     +		}
     +		break;
3:  58893c9c ! 3:  0b7b0e57 s390x: Test effect of storage keys on some more instructions
    @@ s390x/skey.c: static void test_store_cpu_address(void)
     + * Perform CHANNEL SUBSYSTEM CALL (CHSC)  instruction while temporarily executing
     + * with access key 1.
     + */
    -+static unsigned int channel_subsystem_call_key_1(void *communication_block)
    ++static unsigned int chsc_key_1(void *comm_block)
     +{
     +	uint32_t program_mask;
     +
     +	asm volatile (
     +		"spka	0x10\n\t"
    -+		".insn	rre,0xb25f0000,%[communication_block],0\n\t"
    ++		".insn	rre,0xb25f0000,%[comm_block],0\n\t"
     +		"spka	0\n\t"
     +		"ipm	%[program_mask]\n"
     +		: [program_mask] "=d" (program_mask)
    -+		: [communication_block] "d" (communication_block)
    ++		: [comm_block] "d" (comm_block)
     +		: "memory"
     +	);
     +	return program_mask >> 28;
     +}
     +
    -+static void init_store_channel_subsystem_characteristics(uint16_t *communication_block)
    ++static const char chsc_msg[] = "Performed store-channel-subsystem-characteristics";
    ++static void init_comm_block(uint16_t *comm_block)
     +{
    -+	memset(communication_block, 0, PAGE_SIZE);
    -+	communication_block[0] = 0x10;
    -+	communication_block[1] = 0x10;
    -+	communication_block[9] = 0;
    ++	memset(comm_block, 0, PAGE_SIZE);
    ++	/* store-channel-subsystem-characteristics command */
    ++	comm_block[0] = 0x10;
    ++	comm_block[1] = 0x10;
    ++	comm_block[9] = 0;
     +}
     +
     +static void test_channel_subsystem_call(void)
     +{
    -+	static const char request_name[] = "Store channel-subsystem-characteristics";
    -+	uint16_t *communication_block = (uint16_t *)&pagebuf;
    ++	uint16_t *comm_block = (uint16_t *)&pagebuf;
     +	unsigned int cc;
     +
     +	report_prefix_push("CHANNEL SUBSYSTEM CALL");
     +
     +	report_prefix_push("zero key");
    -+	init_store_channel_subsystem_characteristics(communication_block);
    -+	set_storage_key(communication_block, 0x10, 0);
    ++	init_comm_block(comm_block);
    ++	set_storage_key(comm_block, 0x10, 0);
     +	asm volatile (
    -+		".insn	rre,0xb25f0000,%[communication_block],0\n\t"
    ++		".insn	rre,0xb25f0000,%[comm_block],0\n\t"
     +		"ipm	%[cc]\n"
     +		: [cc] "=d" (cc)
    -+		: [communication_block] "d" (communication_block)
    ++		: [comm_block] "d" (comm_block)
     +		: "memory"
     +	);
     +	cc = cc >> 28;
    -+	report(cc == 0 && communication_block[9], request_name);
    ++	report(cc == 0 && comm_block[9], chsc_msg);
     +	report_prefix_pop();
     +
     +	report_prefix_push("matching key");
    -+	init_store_channel_subsystem_characteristics(communication_block);
    -+	set_storage_key(communication_block, 0x10, 0);
    -+	cc = channel_subsystem_call_key_1(communication_block);
    -+	report(cc == 0 && communication_block[9], request_name);
    ++	init_comm_block(comm_block);
    ++	set_storage_key(comm_block, 0x10, 0);
    ++	cc = chsc_key_1(comm_block);
    ++	report(cc == 0 && comm_block[9], chsc_msg);
     +	report_prefix_pop();
     +
     +	report_prefix_push("mismatching key");
     +
     +	report_prefix_push("no fetch protection");
    -+	init_store_channel_subsystem_characteristics(communication_block);
    -+	set_storage_key(communication_block, 0x20, 0);
    ++	init_comm_block(comm_block);
    ++	set_storage_key(comm_block, 0x20, 0);
     +	expect_pgm_int();
    -+	channel_subsystem_call_key_1(communication_block);
    ++	chsc_key_1(comm_block);
     +	check_key_prot_exc(ACC_UPDATE, PROT_STORE);
     +	report_prefix_pop();
     +
     +	report_prefix_push("fetch protection");
    -+	init_store_channel_subsystem_characteristics(communication_block);
    -+	set_storage_key(communication_block, 0x28, 0);
    ++	init_comm_block(comm_block);
    ++	set_storage_key(comm_block, 0x28, 0);
     +	expect_pgm_int();
    -+	channel_subsystem_call_key_1(communication_block);
    ++	chsc_key_1(comm_block);
     +	check_key_prot_exc(ACC_UPDATE, PROT_FETCH_STORE);
     +	report_prefix_pop();
     +
     +	ctl_set_bit(0, CTL0_STORAGE_PROTECTION_OVERRIDE);
     +
     +	report_prefix_push("storage-protection override, invalid key");
    -+	set_storage_key(communication_block, 0x20, 0);
    -+	init_store_channel_subsystem_characteristics(communication_block);
    ++	set_storage_key(comm_block, 0x20, 0);
    ++	init_comm_block(comm_block);
     +	expect_pgm_int();
    -+	channel_subsystem_call_key_1(communication_block);
    ++	chsc_key_1(comm_block);
     +	check_key_prot_exc(ACC_UPDATE, PROT_STORE);
     +	report_prefix_pop();
     +
     +	report_prefix_push("storage-protection override, override key");
    -+	init_store_channel_subsystem_characteristics(communication_block);
    -+	set_storage_key(communication_block, 0x90, 0);
    -+	cc = channel_subsystem_call_key_1(communication_block);
    -+	report(cc == 0 && communication_block[9], request_name);
    ++	init_comm_block(comm_block);
    ++	set_storage_key(comm_block, 0x90, 0);
    ++	cc = chsc_key_1(comm_block);
    ++	report(cc == 0 && comm_block[9], chsc_msg);
     +	report_prefix_pop();
     +
     +	ctl_clear_bit(0, CTL0_STORAGE_PROTECTION_OVERRIDE);
     +
     +	report_prefix_push("storage-protection override disabled, override key");
    -+	init_store_channel_subsystem_characteristics(communication_block);
    -+	set_storage_key(communication_block, 0x90, 0);
    ++	init_comm_block(comm_block);
    ++	set_storage_key(comm_block, 0x90, 0);
     +	expect_pgm_int();
    -+	channel_subsystem_call_key_1(communication_block);
    ++	chsc_key_1(comm_block);
     +	check_key_prot_exc(ACC_UPDATE, PROT_STORE);
     +	report_prefix_pop();
     +
     +	report_prefix_pop();
     +
    -+	set_storage_key(communication_block, 0x00, 0);
    ++	set_storage_key(comm_block, 0x00, 0);
     +	report_prefix_pop();
     +}
     +
    @@ s390x/skey.c: static void test_set_prefix(void)
     +{
     +	uint32_t program_mask;
     +
    ++/*
    ++ * gcc 12.0.1 warns if schib is < 4k.
    ++ * We need such addresses to test fetch protection override.
    ++ */
    ++#pragma GCC diagnostic push
    ++#pragma GCC diagnostic ignored "-Warray-bounds"
     +	asm volatile (
     +		"lr %%r1,%[sid]\n\t"
     +		"spka	0x10\n\t"
    @@ s390x/skey.c: static void test_set_prefix(void)
     +		  [schib] "Q" (*schib)
     +		: "%r1"
     +	);
    ++#pragma GCC diagnostic pop
     +	return program_mask >> 28;
     +}
     +
-:  -------- > 4:  7fb70993 s390x: Test effect of storage keys on diag 308

base-commit: c315f52b88b967cfb4cd58f3b4e1987378c47f3b
prerequisite-patch-id: 1c147bf31109769a454ef133daacb0786ac69a2d
-- 
2.33.1

