Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30DAD5115EE
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 13:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbiD0LWM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 07:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232290AbiD0LWJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 07:22:09 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB3EE2E08A;
        Wed, 27 Apr 2022 04:18:58 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23R9nB7K005768;
        Wed, 27 Apr 2022 11:18:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=mIAq+0ztaf6V55tW4BUIv8GiVQQyPT3m+pqZg9iYxrM=;
 b=KLADzZ9+8HIs7aoVkwJsDv920tRcRJJA20RdjBfTzwK4Kqnbvve/jvTl+rHK7DtVXgn6
 X8hPgDOaE4feJQaUHGanUDqxqaBYKFOPacs8/spe+Ie3gJGwssdJZOmj7LqokeSAKWYs
 utH3Ts4s9erz9p3a5tIoWwmxc/snF/JLVP5a4tLM3eqEpZ2SkdOIplFpKddRHHidy71P
 4GwWAB39FYDfPyeAQbZUtKhq/de8Vov7j1u1VK5gFxsnsS/fv+fbz35chkHOQCJ2x21D
 D6rw5ugsi08YwWpMW524I6FVd4cjsl0Q6aL9xIk4sbJP9CbhPnCe4sONpj3/WnLWA3+t +A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fprrpmp2j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 11:18:57 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 23RBBcs1002870;
        Wed, 27 Apr 2022 11:18:57 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fprrpmp21-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 11:18:57 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23RB8wrg004088;
        Wed, 27 Apr 2022 11:18:54 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 3fpuyg8jay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 11:18:54 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23RBJ4SU4063918
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Apr 2022 11:19:04 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 546534C044;
        Wed, 27 Apr 2022 11:18:51 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E54A04C040;
        Wed, 27 Apr 2022 11:18:50 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.10.176])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 27 Apr 2022 11:18:50 +0000 (GMT)
Date:   Wed, 27 Apr 2022 13:18:46 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v6 2/3] s390x: Test effect of storage
 keys on some instructions
Message-ID: <20220427131846.4af79a65@p-imbrenda>
In-Reply-To: <20220427100611.2119860-3-scgl@linux.ibm.com>
References: <20220427100611.2119860-1-scgl@linux.ibm.com>
        <20220427100611.2119860-3-scgl@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 10vAjsZZgf1EajMYs_YHOuxGRXrdsq15
X-Proofpoint-ORIG-GUID: N1MvXSfDnVAN17LbEHIZtUY07S2bk7Td
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-27_03,2022-04-27_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 impostorscore=0 priorityscore=1501 malwarescore=0 lowpriorityscore=0
 mlxscore=0 adultscore=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204270073
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 27 Apr 2022 12:06:10 +0200
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> Some instructions are emulated by KVM. Test that KVM correctly emulates
> storage key checking for two of those instructions (STORE CPU ADDRESS,
> SET PREFIX).
> Test success and error conditions, including coverage of storage and
> fetch protection override.
> Also add test for TEST PROTECTION, even if that instruction will not be
> emulated by KVM under normal conditions.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/asm/arch_def.h |  20 ++--
>  s390x/skey.c             | 236 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 247 insertions(+), 9 deletions(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 46c370e6..72553819 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -55,15 +55,17 @@ struct psw {
>  #define PSW_MASK_BA			0x0000000080000000UL
>  #define PSW_MASK_64			(PSW_MASK_BA | PSW_MASK_EA)
>  
> -#define CTL0_LOW_ADDR_PROT		(63 - 35)
> -#define CTL0_EDAT			(63 - 40)
> -#define CTL0_IEP			(63 - 43)
> -#define CTL0_AFP			(63 - 45)
> -#define CTL0_VECTOR			(63 - 46)
> -#define CTL0_EMERGENCY_SIGNAL		(63 - 49)
> -#define CTL0_EXTERNAL_CALL		(63 - 50)
> -#define CTL0_CLOCK_COMPARATOR		(63 - 52)
> -#define CTL0_SERVICE_SIGNAL		(63 - 54)
> +#define CTL0_LOW_ADDR_PROT			(63 - 35)
> +#define CTL0_EDAT				(63 - 40)
> +#define CTL0_FETCH_PROTECTION_OVERRIDE		(63 - 38)
> +#define CTL0_STORAGE_PROTECTION_OVERRIDE	(63 - 39)
> +#define CTL0_IEP				(63 - 43)
> +#define CTL0_AFP				(63 - 45)
> +#define CTL0_VECTOR				(63 - 46)
> +#define CTL0_EMERGENCY_SIGNAL			(63 - 49)
> +#define CTL0_EXTERNAL_CALL			(63 - 50)
> +#define CTL0_CLOCK_COMPARATOR			(63 - 52)
> +#define CTL0_SERVICE_SIGNAL			(63 - 54)
>  #define CR0_EXTM_MASK			0x0000000000006200UL /* Combined external masks */
>  
>  #define CTL2_GUARDED_STORAGE		(63 - 59)
> diff --git a/s390x/skey.c b/s390x/skey.c
> index edad53e9..46efe3f5 100644
> --- a/s390x/skey.c
> +++ b/s390x/skey.c
> @@ -10,6 +10,7 @@
>  #include <libcflat.h>
>  #include <asm/asm-offsets.h>
>  #include <asm/interrupt.h>
> +#include <vmalloc.h>
>  #include <asm/page.h>
>  #include <asm/facility.h>
>  #include <asm/mem.h>
> @@ -118,6 +119,236 @@ static void test_invalid_address(void)
>  	report_prefix_pop();
>  }
>  
> +static void test_test_protection(void)
> +{
> +	unsigned long addr = (unsigned long)pagebuf;
> +
> +	report_prefix_push("TPROT");
> +
> +	set_storage_key(pagebuf, 0x10, 0);
> +	report(tprot(addr, 0) == TPROT_READ_WRITE, "access key 0 -> no protection");
> +	report(tprot(addr, 1) == TPROT_READ_WRITE, "access key matches -> no protection");
> +	report(tprot(addr, 2) == TPROT_READ,
> +	       "access key mismatches, no fetch protection -> store protection");
> +
> +	set_storage_key(pagebuf, 0x18, 0);
> +	report(tprot(addr, 2) == TPROT_RW_PROTECTED,
> +	       "access key mismatches, fetch protection -> fetch & store protection");
> +
> +	ctl_set_bit(0, CTL0_STORAGE_PROTECTION_OVERRIDE);
> +	set_storage_key(pagebuf, 0x90, 0);
> +	report(tprot(addr, 2) == TPROT_READ_WRITE,
> +	       "access key mismatches, storage protection override -> no protection");
> +	ctl_clear_bit(0, CTL0_STORAGE_PROTECTION_OVERRIDE);
> +
> +	set_storage_key(pagebuf, 0x00, 0);
> +	report_prefix_pop();
> +}
> +
> +/*
> + * Perform STORE CPU ADDRESS (STAP) instruction while temporarily executing
> + * with access key 1.
> + */
> +static void store_cpu_address_key_1(uint16_t *out)
> +{
> +	asm volatile (
> +		"spka	0x10\n\t"
> +		"stap	%0\n\t"
> +		"spka	0\n"
> +	     : "+Q" (*out) /* exception: old value remains in out -> + constraint */
> +	);
> +}
> +
> +static void test_store_cpu_address(void)
> +{
> +	uint16_t *out = (uint16_t *)pagebuf;
> +	uint16_t cpu_addr;
> +
> +	report_prefix_push("STORE CPU ADDRESS");
> +	asm ("stap %0" : "=Q" (cpu_addr));
> +
> +	report_prefix_push("zero key");
> +	set_storage_key(pagebuf, 0x20, 0);
> +	WRITE_ONCE(*out, 0xbeef);
> +	asm ("stap %0" : "=Q" (*out));
> +	report(*out == cpu_addr, "store occurred");
> +	report_prefix_pop();
> +
> +	report_prefix_push("matching key");
> +	set_storage_key(pagebuf, 0x10, 0);
> +	*out = 0xbeef;
> +	store_cpu_address_key_1(out);
> +	report(*out == cpu_addr, "store occurred");
> +	report_prefix_pop();
> +
> +	report_prefix_push("mismatching key");
> +	set_storage_key(pagebuf, 0x20, 0);
> +	expect_pgm_int();
> +	*out = 0xbeef;
> +	store_cpu_address_key_1(out);
> +	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
> +	report(*out == 0xbeef, "no store occurred");
> +	report_prefix_pop();
> +
> +	ctl_set_bit(0, CTL0_STORAGE_PROTECTION_OVERRIDE);
> +
> +	report_prefix_push("storage-protection override, invalid key");
> +	set_storage_key(pagebuf, 0x20, 0);
> +	expect_pgm_int();
> +	*out = 0xbeef;
> +	store_cpu_address_key_1(out);
> +	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
> +	report(*out == 0xbeef, "no store occurred");
> +	report_prefix_pop();
> +
> +	report_prefix_push("storage-protection override, override key");
> +	set_storage_key(pagebuf, 0x90, 0);
> +	*out = 0xbeef;
> +	store_cpu_address_key_1(out);
> +	report(*out == cpu_addr, "override occurred");
> +	report_prefix_pop();
> +
> +	ctl_clear_bit(0, CTL0_STORAGE_PROTECTION_OVERRIDE);
> +
> +	report_prefix_push("storage-protection override disabled, override key");
> +	set_storage_key(pagebuf, 0x90, 0);
> +	expect_pgm_int();
> +	*out = 0xbeef;
> +	store_cpu_address_key_1(out);
> +	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
> +	report(*out == 0xbeef, "no store occurred");
> +	report_prefix_pop();
> +
> +	set_storage_key(pagebuf, 0x00, 0);
> +	report_prefix_pop();
> +}
> +
> +/*
> + * Perform SET PREFIX (SPX) instruction while temporarily executing
> + * with access key 1.
> + */
> +static void set_prefix_key_1(uint32_t *prefix_ptr)
> +{
> +	asm volatile (
> +		"spka	0x10\n\t"
> +		"spx	%0\n\t"
> +		"spka	0\n"
> +	     :: "Q" (*prefix_ptr)
> +	);
> +}
> +
> +/*
> + * We remapped page 0, making the lowcore inaccessible, which breaks the normal
> + * handler and breaks skipping the faulting instruction.
> + * Just disable dynamic address translation to make things work.
> + */
> +static void dat_fixup_pgm_int(void)
> +{
> +	uint64_t psw_mask = extract_psw_mask();
> +
> +	psw_mask &= ~PSW_MASK_DAT;
> +	load_psw_mask(psw_mask);
> +}
> +
> +#define PREFIX_AREA_SIZE (PAGE_SIZE * 2)
> +static char lowcore_tmp[PREFIX_AREA_SIZE] __attribute__((aligned(PREFIX_AREA_SIZE)));
> +
> +/*
> + * Test accessibility of the operand to SET PREFIX given different configurations
> + * with regards to storage keys. That is, check the accessibility of the location
> + * holding the new prefix, not that of the new prefix area. The new prefix area
> + * is a valid lowcore, so that the test does not crash on failure.
> + */
> +static void test_set_prefix(void)
> +{
> +	uint32_t *prefix_ptr = (uint32_t *)pagebuf;
> +	uint32_t *no_override_prefix_ptr;
> +	uint32_t old_prefix;
> +	pgd_t *root;
> +
> +	report_prefix_push("SET PREFIX");
> +	root = (pgd_t *)(stctg(1) & PAGE_MASK);
> +	old_prefix = get_prefix();
> +	memcpy(lowcore_tmp, 0, sizeof(lowcore_tmp));
> +	assert(((uint64_t)&lowcore_tmp >> 31) == 0);
> +	*prefix_ptr = (uint32_t)(uint64_t)&lowcore_tmp;
> +
> +	report_prefix_push("zero key");
> +	set_prefix(old_prefix);
> +	set_storage_key(prefix_ptr, 0x20, 0);
> +	set_prefix(*prefix_ptr);
> +	report(get_prefix() == *prefix_ptr, "set prefix");
> +	report_prefix_pop();
> +
> +	report_prefix_push("matching key");
> +	set_prefix(old_prefix);
> +	set_storage_key(pagebuf, 0x10, 0);
> +	set_prefix_key_1(prefix_ptr);
> +	report(get_prefix() == *prefix_ptr, "set prefix");
> +	report_prefix_pop();
> +
> +	report_prefix_push("mismatching key");
> +
> +	report_prefix_push("no fetch protection");
> +	set_prefix(old_prefix);
> +	set_storage_key(pagebuf, 0x20, 0);
> +	set_prefix_key_1(prefix_ptr);
> +	report(get_prefix() == *prefix_ptr, "set prefix");
> +	report_prefix_pop();
> +
> +	report_prefix_push("fetch protection");
> +	set_prefix(old_prefix);
> +	set_storage_key(pagebuf, 0x28, 0);
> +	expect_pgm_int();
> +	set_prefix_key_1(prefix_ptr);
> +	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
> +	report(get_prefix() == old_prefix, "did not set prefix");
> +	report_prefix_pop();
> +
> +	register_pgm_cleanup_func(dat_fixup_pgm_int);
> +
> +	report_prefix_push("remapped page, fetch protection");
> +	set_prefix(old_prefix);
> +	set_storage_key(pagebuf, 0x28, 0);
> +	expect_pgm_int();
> +	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
> +	set_prefix_key_1((uint32_t *)0);
> +	install_page(root, 0, 0);
> +	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
> +	report(get_prefix() == old_prefix, "did not set prefix");
> +	report_prefix_pop();
> +
> +	ctl_set_bit(0, CTL0_FETCH_PROTECTION_OVERRIDE);
> +
> +	report_prefix_push("fetch protection override applies");
> +	set_prefix(old_prefix);
> +	set_storage_key(pagebuf, 0x28, 0);
> +	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
> +	set_prefix_key_1((uint32_t *)0);
> +	install_page(root, 0, 0);
> +	report(get_prefix() == *prefix_ptr, "set prefix");
> +	report_prefix_pop();
> +
> +	no_override_prefix_ptr = (uint32_t *)(pagebuf + 2048);
> +	WRITE_ONCE(*no_override_prefix_ptr, (uint32_t)(uint64_t)&lowcore_tmp);
> +	report_prefix_push("fetch protection override does not apply");
> +	set_prefix(old_prefix);
> +	set_storage_key(pagebuf, 0x28, 0);
> +	expect_pgm_int();
> +	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
> +	set_prefix_key_1((uint32_t *)2048);
> +	install_page(root, 0, 0);
> +	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
> +	report(get_prefix() == old_prefix, "did not set prefix");
> +	report_prefix_pop();
> +
> +	ctl_clear_bit(0, CTL0_FETCH_PROTECTION_OVERRIDE);
> +	register_pgm_cleanup_func(NULL);
> +	report_prefix_pop();
> +	set_storage_key(pagebuf, 0x00, 0);
> +	report_prefix_pop();
> +}
> +
>  int main(void)
>  {
>  	report_prefix_push("skey");
> @@ -130,6 +361,11 @@ int main(void)
>  	test_set();
>  	test_set_mb();
>  	test_chg();
> +	test_test_protection();
> +	test_store_cpu_address();
> +
> +	setup_vm();
> +	test_set_prefix();
>  done:
>  	report_prefix_pop();
>  	return report_summary();

