Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04782543053
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 14:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239032AbiFHMaH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 08:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238751AbiFHMaD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 08:30:03 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA03410D5E8;
        Wed,  8 Jun 2022 05:30:02 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 258Br8E2017785;
        Wed, 8 Jun 2022 12:30:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=q0ToaJvSdgcgYy1Z//haNbvuiFuMxkZ5+y2ltatOdpA=;
 b=XfiJR6+4MzRUwCfYNFK9cooCSjPr8svN5KVz1EvIFX9w+gaUKRAJCNd1SAqg0qXkd+py
 KZoUUnOSkcAwRftj1N0ycJb5l2UCwKX9TraJUhtqV+EPYZIIZGgg0MeWrGqQng7Ju2gK
 krB+VScvj0a8Tqqf2r6M2Thg8ThpRpH27niD0x2A3y8zI+q/4lXhhcitbqlhn/SR7J4Z
 1lt4pLA13FSAiIZBRqUhbbztRHfDJb4weR/8l8YAl4qKt0Jk/V/y2364/U86IBYD3tj0
 vPuOkyN8dbbzaybkKS7XMYjqQGmb4R3ONYhXhmt0KhVEYC5VFhbEqhYK70EWXiFeze6z 8g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gjrj6m7t2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 12:30:01 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 258CEvtA009261;
        Wed, 8 Jun 2022 12:30:01 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gjrj6m7rr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 12:30:01 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 258CK0AN030470;
        Wed, 8 Jun 2022 12:29:59 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3gfy19c2rb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 12:29:59 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 258CTuEL19726814
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Jun 2022 12:29:56 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 155585204F;
        Wed,  8 Jun 2022 12:29:56 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id D10CA52051;
        Wed,  8 Jun 2022 12:29:55 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 0/2] s390x: Avoid gcc 12 warnings
Date:   Wed,  8 Jun 2022 14:29:51 +0200
Message-Id: <20220608122953.1051952-1-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: B_dEmeMr2YmX9zfUv4TSX52nviiBVIrC
X-Proofpoint-GUID: b_QIDeq50y_EterYOiluOyT4WJux1hKK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-08_04,2022-06-07_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 bulkscore=0 impostorscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 phishscore=0 priorityscore=1501 mlxscore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206080049
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

gcc 12 warns if a memory operand to inline asm points to memory in the
first 4k bytes. However, in our case, these operands are fine, either
because we actually want to use that memory, or expect and handle the
resulting exception.

v2 -> v3
 * extend commit msg
 * pick up r-b
 * use macro instead of pointer to address memory

v1 -> v2
 * replace mechanism, don't use pragmas, instead use an extern symbol so
   gcc cannot conclude that the pointer is <4k

   This new extern symbol refers to the lowcore. As a result, code
   generation for lowcore accesses becomes worse.

   Alternatives:
    * Don't use extern symbol for lowcore, just for problematic pointers
    * Hide value from gcc via inline asm
    * Disable the warning globally
    * Use memory clobber instead of memory output
      Use address in register input instead of memory input
          (may require WRITE_ONCE)
    * Don't use gcc 12.0, with newer versions --param=min-pagesize=0 might
      avoid the problem

Janis Schoetterl-Glausch (2):
  s390x: Introduce symbol for lowcore and use it
  s390x: Fix gcc 12 warning about array bounds

 lib/s390x/asm/arch_def.h   |  2 ++
 lib/s390x/asm/facility.h   |  4 +--
 lib/s390x/asm/mem.h        |  4 +++
 lib/s390x/css.h            |  2 --
 lib/s390x/css_lib.c        | 12 ++++----
 lib/s390x/fault.c          | 10 +++----
 lib/s390x/interrupt.c      | 61 +++++++++++++++++++-------------------
 lib/s390x/mmu.c            |  3 +-
 s390x/flat.lds             |  1 +
 s390x/snippets/c/flat.lds  |  1 +
 s390x/css.c                |  4 +--
 s390x/diag288.c            |  4 +--
 s390x/edat.c               |  5 ++--
 s390x/emulator.c           | 15 +++++-----
 s390x/mvpg.c               |  7 ++---
 s390x/sclp.c               |  3 +-
 s390x/skey.c               |  2 +-
 s390x/skrf.c               | 11 +++----
 s390x/smp.c                | 23 +++++++-------
 s390x/snippets/c/spec_ex.c |  5 ++--
 20 files changed, 83 insertions(+), 96 deletions(-)

Range-diff against v2:
1:  412a9962 ! 1:  44b10d41 s390x: Introduce symbol for lowcore and use it
    @@ Commit message
         The new symbol is not a pointer. While this will lead to worse code
         generation (cannot use register 0 for addressing), that should not
         matter too much for kvm unit tests.
    +    Since the lowcore is located per definition at address 0, the symbol is
    +    defined via the linker scripts.
         The symbol also will be used to create pointers that the compiler cannot
         warn about as being outside the bounds of an array.
     
         Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
    +    Reviewed-by: Thomas Huth <thuth@redhat.com>
     
      ## lib/s390x/asm/arch_def.h ##
     @@ lib/s390x/asm/arch_def.h: struct lowcore {
2:  9b2eeee3 ! 2:  e9e88996 s390x: Fix gcc 12 warning about array bounds
    @@ lib/s390x/asm/mem.h
      #define _ASMS390X_MEM_H_
     +#include <asm/arch_def.h>
     +
    -+/* pointer to 0 used to avoid compiler warnings */
    -+uint8_t *mem_all = (uint8_t *)&lowcore;
    ++/* create pointer while avoiding compiler warnings */
    ++#define OPAQUE_PTR(x) ((void *)(((uint64_t)&lowcore) + (x)))
      
      #define SKEY_ACC	0xf0
      #define SKEY_FP		0x08
    @@ s390x/emulator.c: static __always_inline void __test_cpacf_invalid_parm(unsigned
      	report_prefix_push("invalid parm address");
      	expect_pgm_int();
     -	__cpacf_query(opcode, (void *) -1);
    -+	__cpacf_query(opcode, (cpacf_mask_t *)&mem_all[-1]);
    ++	__cpacf_query(opcode, OPAQUE_PTR(-1));
      	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
      	report_prefix_pop();
      }
    @@ s390x/emulator.c: static __always_inline void __test_cpacf_protected_parm(unsign
      	expect_pgm_int();
      	low_prot_enable();
     -	__cpacf_query(opcode, (void *) 8);
    -+	__cpacf_query(opcode, (cpacf_mask_t *)&mem_all[8]);
    ++	__cpacf_query(opcode, OPAQUE_PTR(8));
      	low_prot_disable();
      	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
      	report_prefix_pop();
    @@ s390x/skey.c: static void test_set_prefix(void)
      	expect_pgm_int();
      	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
     -	set_prefix_key_1((uint32_t *)2048);
    -+	set_prefix_key_1((uint32_t *)&mem_all[2048]);
    ++	set_prefix_key_1(OPAQUE_PTR(2048));
      	install_page(root, 0, 0);
      	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
      	report(get_prefix() == old_prefix, "did not set prefix");

base-commit: 2eed0bf1096077144cc3a0dd9974689487f9511a
-- 
2.33.1

