Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC9A1517305
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 17:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385918AbiEBPoo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 11:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237714AbiEBPon (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 11:44:43 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223F9D6;
        Mon,  2 May 2022 08:41:14 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 242FYc7g021553;
        Mon, 2 May 2022 15:41:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=O6DIFSoNk4s8Vqr2vfCTj3Ovj8TJFkMqm4fP4aYxYpY=;
 b=hc1jBNj1WyzVFqxVXOQelQOyoPh3U1PraDiXh1L0cd8SP6PC+BHQQkb0dY1SoBerhPNH
 WLoOkUedN8d0AV1nlXMdV60rAhnSyUgI8kG8uKbHoD54gifDwLlQ6KEn0MDMU+ETRJ+P
 V2BTb6fLLn4RRxmZ3+62IHkdfsQACc5cZdh/gBv/kKca6/hfo1YE3mfGjc0In7ZraQUj
 OLFgiFrD7YmGPNm+6JfE/av1Qlag5NqnKbpyyDpYqLbEews7n4oyQyccSyVlwAnF5WMk
 6rjBYY26sVcypDyFjGswVLfkk14C6X0+HwjBO0X9lbusXVxtcu2AHC0EyogLLamBugPJ kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ftj0qg8ww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 15:41:13 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 242FaTAp001051;
        Mon, 2 May 2022 15:41:13 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ftj0qg8w4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 15:41:13 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 242FXRsT024507;
        Mon, 2 May 2022 15:41:10 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3frvr8tvpj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 May 2022 15:41:10 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 242FRquJ45875660
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 May 2022 15:27:52 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9558142041;
        Mon,  2 May 2022 15:41:07 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 533D24203F;
        Mon,  2 May 2022 15:41:07 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  2 May 2022 15:41:07 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v7 0/3] s390x: Test effect of storage keys on some instructions
Date:   Mon,  2 May 2022 17:40:58 +0200
Message-Id: <20220502154101.3663941-1-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: A_0DISEuUIyk6-J0TUNi2GHC1C5laaPS
X-Proofpoint-ORIG-GUID: 0Q6Ema_eEjQ0hBxrrbZRZue8PiDkALKT
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-02_04,2022-05-02_03,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 phishscore=0
 spamscore=0 priorityscore=1501 mlxlogscore=999 suspectscore=0 bulkscore=0
 impostorscore=0 clxscore=1015 mlxscore=0 malwarescore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205020122
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

See range diff below for changes. Since I messed up the addressees
for the cover letter for the last version, the diff is against v5.

v6 -> v7:
 * Add fetch-protection override test case to TPROT test
 * Change reporting of TPROT test to be more in line with other tests

v5 -> v6:
 * Disable skey test in GitLab CI, needs kernel 5.18
 * Added comment to test_set_prefix
 * Introduce names for tprot return values

...

v2 -> v3:
 * fix asm for SET PREFIX zero key test: make input
 * implement Thomas' suggestions:
   https://lore.kernel.org/kvm/f050da01-4d50-5da5-7f08-6da30f5dbbbe@redhat.com/

v1 -> v2:
 * use install_page instead of manual page table entry manipulation
 * check that no store occurred if none is expected
 * try to check that no fetch occurred if not expected, although in
   practice a fetch would probably cause the test to crash
 * reset storage key to 0 after test


Janis Schoetterl-Glausch (3):
  s390x: Give name to return value of tprot()
  s390x: Test effect of storage keys on some instructions
  Disable s390x skey test in GitLab CI

 lib/s390x/asm/arch_def.h |  31 +++--
 lib/s390x/sclp.c         |   6 +-
 s390x/skey.c             | 250 +++++++++++++++++++++++++++++++++++++++
 s390x/tprot.c            |  24 ++--
 .gitlab-ci.yml           |   2 +-
 5 files changed, 286 insertions(+), 27 deletions(-)

Range-diff against v5:
-:  -------- > 1:  6b11f01d s390x: Give name to return value of tprot()
1:  89e59626 ! 2:  e3df88c6 s390x: Test effect of storage keys on some instructions
    @@ s390x/skey.c: static void test_invalid_address(void)
     +	report_prefix_push("TPROT");
     +
     +	set_storage_key(pagebuf, 0x10, 0);
    -+	report(tprot(addr, 0) == 0, "access key 0 -> no protection");
    -+	report(tprot(addr, 1) == 0, "access key matches -> no protection");
    -+	report(tprot(addr, 2) == 1, "access key mismatches, no fetch protection -> store protection");
    ++	report(tprot(addr, 0) == TPROT_READ_WRITE, "zero key: no protection");
    ++	report(tprot(addr, 1) == TPROT_READ_WRITE, "matching key: no protection");
    ++
    ++	report_prefix_push("mismatching key");
    ++
    ++	report(tprot(addr, 2) == TPROT_READ, "no fetch protection: store protection");
    ++
     +
     +	set_storage_key(pagebuf, 0x18, 0);
    -+	report(tprot(addr, 2) == 2, "access key mismatches, fetch protection -> fetch & store protection");
    ++	report(tprot(addr, 2) == TPROT_RW_PROTECTED,
    ++	       "fetch protection: fetch & store protection");
    ++
    ++	report_prefix_push("fetch-protection override");
    ++	set_storage_key(0, 0x18, 0);
    ++	report(tprot(0, 2) == TPROT_RW_PROTECTED, "disabled: fetch & store protection");
    ++	ctl_set_bit(0, CTL0_FETCH_PROTECTION_OVERRIDE);
    ++	report(tprot(0, 2) == TPROT_READ, "enabled: store protection");
    ++	report(tprot(2048, 2) == TPROT_RW_PROTECTED, "invalid: fetch & store protection");
    ++	ctl_clear_bit(0, CTL0_FETCH_PROTECTION_OVERRIDE);
    ++	set_storage_key(0, 0x00, 0);
    ++	report_prefix_pop();
     +
     +	ctl_set_bit(0, CTL0_STORAGE_PROTECTION_OVERRIDE);
     +	set_storage_key(pagebuf, 0x90, 0);
    -+	report(tprot(addr, 2) == 0, "access key mismatches, storage protection override -> no protection");
    ++	report(tprot(addr, 2) == TPROT_READ_WRITE,
    ++	       "storage-protection override: no protection");
     +	ctl_clear_bit(0, CTL0_STORAGE_PROTECTION_OVERRIDE);
     +
    ++	report_prefix_pop();
     +	set_storage_key(pagebuf, 0x00, 0);
     +	report_prefix_pop();
     +}
    @@ s390x/skey.c: static void test_invalid_address(void)
     +#define PREFIX_AREA_SIZE (PAGE_SIZE * 2)
     +static char lowcore_tmp[PREFIX_AREA_SIZE] __attribute__((aligned(PREFIX_AREA_SIZE)));
     +
    ++/*
    ++ * Test accessibility of the operand to SET PREFIX given different configurations
    ++ * with regards to storage keys. That is, check the accessibility of the location
    ++ * holding the new prefix, not that of the new prefix area. The new prefix area
    ++ * is a valid lowcore, so that the test does not crash on failure.
    ++ */
     +static void test_set_prefix(void)
     +{
     +	uint32_t *prefix_ptr = (uint32_t *)pagebuf;
-:  -------- > 3:  c3236718 Disable s390x skey test in GitLab CI

base-commit: 6a7a83ed106211fc0ee530a3a05f171f6a4c4e66
-- 
2.33.1

