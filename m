Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E05F5543ABF
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 19:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232893AbiFHRpv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 13:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232760AbiFHRpq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 13:45:46 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BBFC182BAC;
        Wed,  8 Jun 2022 10:45:45 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 258HCfDI027744;
        Wed, 8 Jun 2022 17:45:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=NWQi55GTIztdgzkO2fHsF15xzXrt9EmqDwq1OwLpZjs=;
 b=O/dPLjkY5aCgVt0OwtNpVAivwN24BaSwwrSs5J+FVimsoYswQAgAiPO0jzRVOWBMu0Nf
 qhFFWzymCIJUqdNbelUfGU7adqi1MHhbQo7JSfO1lN/L91W8AYKPIJ0DMKSjjAuXV7VV
 Ujznmq3K1YbiW5fM1RHyoymc+f7ZU4WBuKmR9uDxTQNDaG9V7Vy/jrTTfNzvbn+lUi8F
 3rHEtR2qTbU9JdElQNQpq73N0N2S8SdxlSJqoxborHeYXENXegcgaCRZWUEwN0X9pVqb
 P0IrIDB/qnC7tDrDIHr6Rg7slEkmD6ATW8hsOZTx4qsYpy+0kTpntRS0IpJ1E1SkCftp 8w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gjyy30p6y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 17:45:44 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 258HVct5025823;
        Wed, 8 Jun 2022 17:45:44 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gjyy30p6a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 17:45:44 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 258HKaan012898;
        Wed, 8 Jun 2022 17:45:41 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3gfy18vjsq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 17:45:41 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 258Hjc0K55247344
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Jun 2022 17:45:38 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2421D11C04C;
        Wed,  8 Jun 2022 17:45:38 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE1E611C04A;
        Wed,  8 Jun 2022 17:45:37 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Jun 2022 17:45:37 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 0/4] More skey instr. emulation test
Date:   Wed,  8 Jun 2022 19:45:33 +0200
Message-Id: <20220608174536.1700357-1-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Y8j3lSQVtAfK27ogWbBzA9zAg9HknbrB
X-Proofpoint-ORIG-GUID: Kht8gKcjhO0hpYLH6R75x0iqpII4UmM8
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-08_05,2022-06-07_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 impostorscore=0 clxscore=1015 bulkscore=0 priorityscore=1501
 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080070
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

This series is based on v2 of s390x: Rework TEID decoding and usage .
https://lore.kernel.org/kvm/20220608133303.1532166-1-scgl@linux.ibm.com/

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

 s390x/skey.c        | 381 +++++++++++++++++++++++++++++++++++++++++++-
 s390x/unittests.cfg |   1 +
 2 files changed, 376 insertions(+), 6 deletions(-)

Range-diff against v3:
1:  073ffb3c ! 1:  fbfd7e3b s390x: Test TEID values in storage key test
    @@ s390x/skey.c: static void test_test_protection(void)
     +{
     +	union teid teid;
     +	int access_code;
    ++	bool dat;
     +
     +	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
     +	report_prefix_push("TEID");
     +	teid.val = lowcore.trans_exc_id;
     +	switch (get_supp_on_prot_facility()) {
     +	case SOP_NONE:
    ++		break;
     +	case SOP_BASIC:
    ++		dat = extract_psw_mask() & PSW_MASK_DAT;
    ++		report(!teid.sop_teid_predictable || !dat || !teid.sop_acc_list,
    ++		       "valid protection code");
     +		break;
     +	case SOP_ENHANCED_1:
    -+		report(!teid.esop1_acc_list_or_dat, "valid protection code");
    ++		report(!teid.sop_teid_predictable, "valid protection code");
     +		break;
     +	case SOP_ENHANCED_2:
     +		switch (teid_esop2_prot_code(teid)) {
    @@ s390x/skey.c: static void test_set_prefix(void)
      
     @@ s390x/skey.c: static void test_set_prefix(void)
      	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
    - 	set_prefix_key_1((uint32_t *)&mem_all[2048]);
    + 	set_prefix_key_1(OPAQUE_PTR(2048));
      	install_page(root, 0, 0);
     -	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
     +	check_key_prot_exc(ACC_FETCH, PROT_FETCH_STORE);
2:  9f300b87 ! 2:  868bb863 s390x: Test effect of storage keys on some more instructions
    @@ Commit message
         fetch protection override.
     
         Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
    +    Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
     
      ## s390x/skey.c ##
     @@
    @@ s390x/skey.c: static void test_set_prefix(void)
     +		set_storage_key(pagebuf, 0x28, 0);
     +		expect_pgm_int();
     +		install_page(root, virt_to_pte_phys(root, pagebuf), 0);
    -+		modify_subchannel_key_1(test_device_sid, (struct schib *)&mem_all[2048]);
    ++		modify_subchannel_key_1(test_device_sid, OPAQUE_PTR(2048));
     +		install_page(root, 0, 0);
     +		check_key_prot_exc(ACC_FETCH, PROT_FETCH_STORE);
     +		cc = stsch(test_device_sid, schib);
3:  c4ca0619 ! 3:  d49934c0 s390x: Test effect of storage keys on diag 308
    @@ Commit message
         Test that key-controlled protection does not apply to diag 308.
     
         Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
    +    Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
     
      ## s390x/skey.c ##
     @@ s390x/skey.c: static void test_store_cpu_address(void)

base-commit: 2eed0bf1096077144cc3a0dd9974689487f9511a
prerequisite-patch-id: aa682f50e4eba0e9b6cacd245d568f5bcca05e0f
prerequisite-patch-id: 79a88ac3faff3ae2ef214bf4a90de7463e2fdc8a
prerequisite-patch-id: bebbc71ca3cc8d085e36a049466dba5a420c9c75
prerequisite-patch-id: d38a4fc7bc1fa6e352502f294cb9413f0b738b99
prerequisite-patch-id: 181e4127db838f3a98fd2b27ea4f23c53da908d7
-- 
2.33.1

