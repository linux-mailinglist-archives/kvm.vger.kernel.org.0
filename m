Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 865F250F32B
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 09:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344405AbiDZH5F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 03:57:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241672AbiDZH4x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 03:56:53 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C524135B0D;
        Tue, 26 Apr 2022 00:53:17 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23Q70MZa002042;
        Tue, 26 Apr 2022 07:53:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=IYNgV3kfSQ2S3+kMU8QUW6f64B/3L/esU654RfdKCxU=;
 b=ErbE4+sqLg3Q5/RFPuqNTPdZ+4jeVhQJI0fPQi+svb0uqilwNmGTjK1ex5ZJ7WVnBOBH
 dCoedhLAnIMBIHCp7G07Avg3I/JjNBhzFdWFAwUA5JGWU6lBWaRVzw/e2COfO2hDS0Pw
 RWhk2tPhXOLJwZNULB8U0B9QC9WXdTK/A4DJwm8PGS7kzuSq2+1Avjy58qUYIR65u1hd
 Z4f3iwqcRf4AeJc3On8wySqw1tbl3mhNLMT5j8SlnHly4aS9h7UdDz52BnTC+33gCGfs
 LYDe77S0p189JuFcwEVLkuUxMCW8MjNiC+XFHoqu3Jgh6MWorWeqk8WBo6TAcpUWD0jh /A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fpbyh0wrv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Apr 2022 07:53:16 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 23Q7Nvsp006968;
        Tue, 26 Apr 2022 07:53:15 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fpbyh0wrc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Apr 2022 07:53:15 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23Q7mQlA023015;
        Tue, 26 Apr 2022 07:53:14 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3fm938u298-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Apr 2022 07:53:13 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23Q7rNSB57803020
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 07:53:23 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BCBE6AE053;
        Tue, 26 Apr 2022 07:53:10 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5AA79AE04D;
        Tue, 26 Apr 2022 07:53:10 +0000 (GMT)
Received: from [9.145.2.160] (unknown [9.145.2.160])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 26 Apr 2022 07:53:10 +0000 (GMT)
Message-ID: <95769733-5a42-a61d-aee7-e78257fcd9ea@linux.ibm.com>
Date:   Tue, 26 Apr 2022 09:53:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220425161731.1575742-1-scgl@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v5] s390x: Test effect of storage keys on
 some instructions
In-Reply-To: <20220425161731.1575742-1-scgl@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: nGcDqp6cTj0Sn9UT_xBUh0CfNbmBGxiX
X-Proofpoint-GUID: fI_qKm_0mkLnhxEmE2mtmOvKLPKtRbUo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-26_02,2022-04-25_03,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 phishscore=0 mlxscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204260049
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/25/22 18:17, Janis Schoetterl-Glausch wrote:
> Some instructions are emulated by KVM. Test that KVM correctly emulates
> storage key checking for two of those instructions (STORE CPU ADDRESS,
> SET PREFIX).
> Test success and error conditions, including coverage of storage and
> fetch protection override.
> Also add test for TEST PROTECTION, even if that instruction will not be
> emulated by KVM under normal conditions.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
[...]
>   lib/s390x/asm/arch_def.h |  20 ++--
>   s390x/skey.c             | 227 +++++++++++++++++++++++++++++++++++++++
>   2 files changed, 238 insertions(+), 9 deletions(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index bab3c374..676a2753 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -55,15 +55,17 @@ struct psw {
>   #define PSW_MASK_BA			0x0000000080000000UL
>   #define PSW_MASK_64			(PSW_MASK_BA | PSW_MASK_EA)
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
>   #define CR0_EXTM_MASK			0x0000000000006200UL /* Combined external masks */
>   
>   #define CTL2_GUARDED_STORAGE		(63 - 59)
> diff --git a/s390x/skey.c b/s390x/skey.c
> index edad53e9..39429960 100644
> --- a/s390x/skey.c
> +++ b/s390x/skey.c
> @@ -10,6 +10,7 @@
>   #include <libcflat.h>
>   #include <asm/asm-offsets.h>
>   #include <asm/interrupt.h>
> +#include <vmalloc.h>
>   #include <asm/page.h>
>   #include <asm/facility.h>
>   #include <asm/mem.h>
> @@ -118,6 +119,227 @@ static void test_invalid_address(void)
>   	report_prefix_pop();
>   }
>   
> +static void test_test_protection(void)
> +{
> +	unsigned long addr = (unsigned long)pagebuf;
> +
> +	report_prefix_push("TPROT");
> +
> +	set_storage_key(pagebuf, 0x10, 0);
> +	report(tprot(addr, 0) == 0, "access key 0 -> no protection");
> +	report(tprot(addr, 1) == 0, "access key matches -> no protection");
> +	report(tprot(addr, 2) == 1, "access key mismatches, no fetch protection -> store protection");

I'd love to see these numerical constants replaced with named constants 
in the future so I don't have to look up the tprot CCs every time :)

> +
> +	set_storage_key(pagebuf, 0x18, 0);
> +	report(tprot(addr, 2) == 2, "access key mismatches, fetch protection -> fetch & store protection");
> +
> +	ctl_set_bit(0, CTL0_STORAGE_PROTECTION_OVERRIDE);
> +	set_storage_key(pagebuf, 0x90, 0);
> +	report(tprot(addr, 2) == 0, "access key mismatches, storage protection override -> no protection");
> +	ctl_clear_bit(0, CTL0_STORAGE_PROTECTION_OVERRIDE);
> +
> +	set_storage_key(pagebuf, 0x00, 0);
> +	report_prefix_pop();
> +}

[...]

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

Please add a comment that we're testing the fetch access of the operand 
since the prefix is only checked for addressing.

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
>   int main(void)
>   {
>   	report_prefix_push("skey");
> @@ -130,6 +352,11 @@ int main(void)
>   	test_set();
>   	test_set_mb();
>   	test_chg();
> +	test_test_protection();
> +	test_store_cpu_address();
> +
> +	setup_vm();
> +	test_set_prefix();
>   done:
>   	report_prefix_pop();
>   	return report_summary();
> 
> base-commit: 6a7a83ed106211fc0ee530a3a05f171f6a4c4e66

