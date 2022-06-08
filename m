Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC0154317E
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 15:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240370AbiFHNef (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 09:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240264AbiFHNed (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 09:34:33 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4DF969CC4;
        Wed,  8 Jun 2022 06:34:31 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 258DDbgo014589;
        Wed, 8 Jun 2022 13:34:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Yn4J3M7xvaA9ZEJLVH7tgO4AJA+jrXTFm3TO4f9i79c=;
 b=HMmSJ2aR16EdsIANUYiV/jZR7txlSnBIm4eG4ZO2X0TT4dD6JkRGHEQY9cmidKKb/t9w
 7/B4TiEMH19uWPOcGOKSrFYXz/hpDMua2uRp9uRpSuOYZa7WotqR1XhbZZZ6FDHCn19r
 qLNV8x1IWbnidhTNSYg72Z9kVCpbWCMLvleugxiN79WF2Hz3xxVskeYpHrwpaJbLGj+c
 dlTGIQyYkvNjS+IBhmVLgSeBMsYH0AQoehyMBHTdBvg0wxsKhmI0w2YVFb0EqT01qs/t
 OoyHcmsqwOra/lNaRL6x52ECB9LSv5sVxNyzx4vZlIRFYQxipXsMSC/hHNcvp4Nd8NZO 3g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gjvf68ggx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 13:34:31 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 258DDXDN014462;
        Wed, 8 Jun 2022 13:34:30 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gjvf68gfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 13:34:30 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 258DK89T015467;
        Wed, 8 Jun 2022 13:34:28 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3gfy19dakm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 13:34:28 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 258DYP9017170698
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Jun 2022 13:34:25 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21DDC4C044;
        Wed,  8 Jun 2022 13:34:25 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D80CB4C040;
        Wed,  8 Jun 2022 13:34:24 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.40])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Jun 2022 13:34:24 +0000 (GMT)
Date:   Wed, 8 Jun 2022 15:34:23 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 0/2] s390x: Avoid gcc 12 warnings
Message-ID: <20220608153423.71ff2a8f@p-imbrenda>
In-Reply-To: <20220608122953.1051952-1-scgl@linux.ibm.com>
References: <20220608122953.1051952-1-scgl@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7IbE_mvPGv7PruQre8RV9Cfbnr1utX9o
X-Proofpoint-ORIG-GUID: rlNTSqzfS8RyFWkKBx8YH5ydrfSvm3o8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-08_04,2022-06-07_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 adultscore=0 priorityscore=1501 impostorscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 lowpriorityscore=0
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

On Wed,  8 Jun 2022 14:29:51 +0200
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> gcc 12 warns if a memory operand to inline asm points to memory in the
> first 4k bytes. However, in our case, these operands are fine, either
> because we actually want to use that memory, or expect and handle the
> resulting exception.

thanks, queued

> 
> v2 -> v3
>  * extend commit msg
>  * pick up r-b
>  * use macro instead of pointer to address memory
> 
> v1 -> v2
>  * replace mechanism, don't use pragmas, instead use an extern symbol so
>    gcc cannot conclude that the pointer is <4k
> 
>    This new extern symbol refers to the lowcore. As a result, code
>    generation for lowcore accesses becomes worse.
> 
>    Alternatives:
>     * Don't use extern symbol for lowcore, just for problematic pointers
>     * Hide value from gcc via inline asm
>     * Disable the warning globally
>     * Use memory clobber instead of memory output
>       Use address in register input instead of memory input
>           (may require WRITE_ONCE)
>     * Don't use gcc 12.0, with newer versions --param=min-pagesize=0 might
>       avoid the problem
> 
> Janis Schoetterl-Glausch (2):
>   s390x: Introduce symbol for lowcore and use it
>   s390x: Fix gcc 12 warning about array bounds
> 
>  lib/s390x/asm/arch_def.h   |  2 ++
>  lib/s390x/asm/facility.h   |  4 +--
>  lib/s390x/asm/mem.h        |  4 +++
>  lib/s390x/css.h            |  2 --
>  lib/s390x/css_lib.c        | 12 ++++----
>  lib/s390x/fault.c          | 10 +++----
>  lib/s390x/interrupt.c      | 61 +++++++++++++++++++-------------------
>  lib/s390x/mmu.c            |  3 +-
>  s390x/flat.lds             |  1 +
>  s390x/snippets/c/flat.lds  |  1 +
>  s390x/css.c                |  4 +--
>  s390x/diag288.c            |  4 +--
>  s390x/edat.c               |  5 ++--
>  s390x/emulator.c           | 15 +++++-----
>  s390x/mvpg.c               |  7 ++---
>  s390x/sclp.c               |  3 +-
>  s390x/skey.c               |  2 +-
>  s390x/skrf.c               | 11 +++----
>  s390x/smp.c                | 23 +++++++-------
>  s390x/snippets/c/spec_ex.c |  5 ++--
>  20 files changed, 83 insertions(+), 96 deletions(-)
> 
> Range-diff against v2:
> 1:  412a9962 ! 1:  44b10d41 s390x: Introduce symbol for lowcore and use it
>     @@ Commit message
>          The new symbol is not a pointer. While this will lead to worse code
>          generation (cannot use register 0 for addressing), that should not
>          matter too much for kvm unit tests.
>     +    Since the lowcore is located per definition at address 0, the symbol is
>     +    defined via the linker scripts.
>          The symbol also will be used to create pointers that the compiler cannot
>          warn about as being outside the bounds of an array.
>      
>          Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>     +    Reviewed-by: Thomas Huth <thuth@redhat.com>
>      
>       ## lib/s390x/asm/arch_def.h ##
>      @@ lib/s390x/asm/arch_def.h: struct lowcore {
> 2:  9b2eeee3 ! 2:  e9e88996 s390x: Fix gcc 12 warning about array bounds
>     @@ lib/s390x/asm/mem.h
>       #define _ASMS390X_MEM_H_
>      +#include <asm/arch_def.h>
>      +
>     -+/* pointer to 0 used to avoid compiler warnings */
>     -+uint8_t *mem_all = (uint8_t *)&lowcore;
>     ++/* create pointer while avoiding compiler warnings */
>     ++#define OPAQUE_PTR(x) ((void *)(((uint64_t)&lowcore) + (x)))
>       
>       #define SKEY_ACC	0xf0
>       #define SKEY_FP		0x08
>     @@ s390x/emulator.c: static __always_inline void __test_cpacf_invalid_parm(unsigned
>       	report_prefix_push("invalid parm address");
>       	expect_pgm_int();
>      -	__cpacf_query(opcode, (void *) -1);
>     -+	__cpacf_query(opcode, (cpacf_mask_t *)&mem_all[-1]);
>     ++	__cpacf_query(opcode, OPAQUE_PTR(-1));
>       	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
>       	report_prefix_pop();
>       }
>     @@ s390x/emulator.c: static __always_inline void __test_cpacf_protected_parm(unsign
>       	expect_pgm_int();
>       	low_prot_enable();
>      -	__cpacf_query(opcode, (void *) 8);
>     -+	__cpacf_query(opcode, (cpacf_mask_t *)&mem_all[8]);
>     ++	__cpacf_query(opcode, OPAQUE_PTR(8));
>       	low_prot_disable();
>       	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
>       	report_prefix_pop();
>     @@ s390x/skey.c: static void test_set_prefix(void)
>       	expect_pgm_int();
>       	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
>      -	set_prefix_key_1((uint32_t *)2048);
>     -+	set_prefix_key_1((uint32_t *)&mem_all[2048]);
>     ++	set_prefix_key_1(OPAQUE_PTR(2048));
>       	install_page(root, 0, 0);
>       	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
>       	report(get_prefix() == old_prefix, "did not set prefix");
> 
> base-commit: 2eed0bf1096077144cc3a0dd9974689487f9511a

