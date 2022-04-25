Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA97350DEA1
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 13:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240703AbiDYLUH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 07:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241725AbiDYLUD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 07:20:03 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14FE6B3C5A;
        Mon, 25 Apr 2022 04:16:33 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23PAxVV3025665;
        Mon, 25 Apr 2022 11:16:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=10h5Kyt6LVfHSP1UtcwRvxbyUlmScF6TxjRgLPrC75I=;
 b=cDRRKivKh1Fzk891FHb7QkNd1nYCowmRi1wwPiX/hxjW+fSwb3wGn1Yp7iBWbCKuHRpx
 mDBnRfspIu7qFU9TU6oZGjsCbZ+mHQSDNgWIyzXo1ksy4FQxdnS5o+AWYm/M58fkdAn2
 RvASW+xLlYX0XDRkouXGt/vHFiHcmMeGOKMvtW1VSP9NU4MueHrndGtve0Jen8E9BemY
 mDJksb4p6NUsY7y0miuC37svCLIxD95ZvBuq7GL+/8c41M4YcJctDNzuIGyDLUAiF+it
 Spwx6NzxAvpXrD0eOKtQM7WZXRxy66TZ2kg0+COIqHT63SL9nODHlsfmEIFHuUP31P6o QA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fnq8k4ph4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Apr 2022 11:16:33 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 23PBGWlq000749;
        Mon, 25 Apr 2022 11:16:32 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fnq8k4pge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Apr 2022 11:16:32 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23PBDxVK009111;
        Mon, 25 Apr 2022 11:16:30 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3fm938svn5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Apr 2022 11:16:29 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23PB3R7o25166214
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Apr 2022 11:03:27 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9411D5204E;
        Mon, 25 Apr 2022 11:16:26 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.10.176])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 341AD5204F;
        Mon, 25 Apr 2022 11:16:26 +0000 (GMT)
Date:   Mon, 25 Apr 2022 13:16:23 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v4] s390x: Test effect of storage keys on
 some instructions
Message-ID: <20220425131623.2c855fcd@p-imbrenda>
In-Reply-To: <20220425084128.809134-1-scgl@linux.ibm.com>
References: <20220425084128.809134-1-scgl@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: b-jxD_3WP9mIeBmeKOHeyumf4vB8TZg_
X-Proofpoint-GUID: XA4kBFOdI0SRZ9OezUt9tbLLMBz47NHB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-25_07,2022-04-25_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 priorityscore=1501 suspectscore=0 spamscore=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204250049
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 25 Apr 2022 10:41:28 +0200
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
> ---
> Range-diff against v3:
> 1:  dc4ae46f ! 1:  a9af3e08 s390x: Test effect of storage keys on some instructions
>     @@ s390x/skey.c: static void test_invalid_address(void)
>      +static void store_cpu_address_key_1(uint16_t *out)
>      +{
>      +	asm volatile (
>     -+		"spka 0x10(0)\n\t"
>     -+		"stap %0\n\t"
>     -+		"spka 0(0)\n"
>     ++		"spka	0x10\n\t"
>     ++		"stap	%0\n\t"
>     ++		"spka	0\n"
>      +	     : "+Q" (*out) /* exception: old value remains in out -> + constraint */
>      +	);
>      +}
>     @@ s390x/skey.c: static void test_invalid_address(void)
>      + * Perform SET PREFIX (SPX) instruction while temporarily executing
>      + * with access key 1.
>      + */
>     -+static void set_prefix_key_1(uint32_t *out)
>     ++static void set_prefix_key_1(uint32_t *prefix_ptr)
>      +{
>      +	asm volatile (
>     -+		"spka 0x10(0)\n\t"
>     ++		"spka	0x10\n\t"
>      +		"spx	%0\n\t"
>     -+		"spka 0(0)\n"
>     -+	     :: "Q" (*out)
>     ++		"spka	0\n"
>     ++	     :: "Q" (*prefix_ptr)
>      +	);
>      +}
>      +
>     @@ s390x/skey.c: static void test_invalid_address(void)
>      +
>      +static void test_set_prefix(void)
>      +{
>     -+	uint32_t *out = (uint32_t *)pagebuf;
>     ++	char lowcore_tmp[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE * 2)));
>     ++	uint32_t *prefix_ptr = (uint32_t *)pagebuf;
>     ++	uint32_t old_prefix;
>      +	pgd_t *root;
>      +
>      +	report_prefix_push("SET PREFIX");
>      +	root = (pgd_t *)(stctg(1) & PAGE_MASK);
>     -+
>     -+	asm volatile("stpx	%0" : "=Q"(*out));
>     ++	old_prefix = get_prefix();
>     ++	memcpy(lowcore_tmp, 0, PAGE_SIZE * 2);
>     ++	assert(((uint64_t)&lowcore_tmp >> 31) == 0);
>     ++	*prefix_ptr = (uint32_t)(uint64_t)&lowcore_tmp;
>      +
>      +	report_prefix_push("zero key");
>     -+	set_storage_key(pagebuf, 0x20, 0);
>     -+	asm volatile("spx	%0" :: "Q" (*out));
>     -+	report_pass("no exception");
>     ++	set_prefix(old_prefix);
>     ++	set_storage_key(prefix_ptr, 0x20, 0);
>     ++	set_prefix(*prefix_ptr);
>     ++	report(get_prefix() == *prefix_ptr, "set prefix");
>      +	report_prefix_pop();
>      +
>      +	report_prefix_push("matching key");
>     ++	set_prefix(old_prefix);
>      +	set_storage_key(pagebuf, 0x10, 0);
>     -+	set_prefix_key_1(out);
>     -+	report_pass("no exception");
>     ++	set_prefix_key_1(prefix_ptr);
>     ++	report(get_prefix() == *prefix_ptr, "set prefix");
>      +	report_prefix_pop();
>      +
>     -+	report_prefix_push("mismatching key, no fetch protection");
>     ++	report_prefix_push("mismatching key");
>     ++
>     ++	report_prefix_push("no fetch protection");
>     ++	set_prefix(old_prefix);
>      +	set_storage_key(pagebuf, 0x20, 0);
>     -+	set_prefix_key_1(out);
>     -+	report_pass("no exception");
>     ++	set_prefix_key_1(prefix_ptr);
>     ++	report(get_prefix() == *prefix_ptr, "set prefix");
>      +	report_prefix_pop();
>      +
>     -+	report_prefix_push("mismatching key, fetch protection");
>     ++	report_prefix_push("fetch protection");
>     ++	set_prefix(old_prefix);
>      +	set_storage_key(pagebuf, 0x28, 0);
>      +	expect_pgm_int();
>     -+	*out = 0xdeadbeef;
>     -+	set_prefix_key_1(out);
>     ++	set_prefix_key_1(prefix_ptr);
>      +	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
>     -+	asm volatile("stpx	%0" : "=Q"(*out));
>     -+	report(*out != 0xdeadbeef, "no fetch occurred");
>     ++	report(get_prefix() != *prefix_ptr, "did not set prefix");
>      +	report_prefix_pop();
>      +
>      +	register_pgm_cleanup_func(dat_fixup_pgm_int);
>      +
>     -+	report_prefix_push("mismatching key, remapped page, fetch protection");
>     ++	report_prefix_push("remapped page, fetch protection");
>     ++	set_prefix(old_prefix);
>      +	set_storage_key(pagebuf, 0x28, 0);
>      +	expect_pgm_int();
>     -+	WRITE_ONCE(*out, 0xdeadbeef);
>      +	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
>      +	set_prefix_key_1((uint32_t *)0);
>      +	install_page(root, 0, 0);
>      +	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
>     -+	asm volatile("stpx	%0" : "=Q"(*out));
>     -+	report(*out != 0xdeadbeef, "no fetch occurred");
>     ++	report(get_prefix() != *prefix_ptr, "did not set prefix");
>      +	report_prefix_pop();
>      +
>      +	ctl_set_bit(0, CTL0_FETCH_PROTECTION_OVERRIDE);
>      +
>     -+	report_prefix_push("mismatching key, fetch protection override applies");
>     ++	report_prefix_push("fetch protection override applies");
>     ++	set_prefix(old_prefix);
>      +	set_storage_key(pagebuf, 0x28, 0);
>      +	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
>      +	set_prefix_key_1((uint32_t *)0);
>      +	install_page(root, 0, 0);
>     -+	report_pass("no exception");
>     ++	report(get_prefix() == *prefix_ptr, "set prefix");
>      +	report_prefix_pop();
>      +
>     -+	report_prefix_push("mismatching key, fetch protection override does not apply");
>     -+	out = (uint32_t *)(pagebuf + 2048);
>     -+	set_storage_key(pagebuf, 0x28, 0);
>     -+	expect_pgm_int();
>     -+	WRITE_ONCE(*out, 0xdeadbeef);
>     -+	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
>     -+	set_prefix_key_1((uint32_t *)2048);
>     -+	install_page(root, 0, 0);
>     -+	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
>     -+	asm volatile("stpx	%0" : "=Q"(*out));
>     -+	report(*out != 0xdeadbeef, "no fetch occurred");
>     -+	report_prefix_pop();
>     ++	{
>     ++		uint32_t *prefix_ptr = (uint32_t *)(pagebuf + 2048);
>     ++
>     ++		WRITE_ONCE(*prefix_ptr, (uint32_t)(uint64_t)&lowcore_tmp);
>     ++		report_prefix_push("fetch protection override does not apply");
>     ++		set_prefix(old_prefix);
>     ++		set_storage_key(pagebuf, 0x28, 0);
>     ++		expect_pgm_int();
>     ++		install_page(root, virt_to_pte_phys(root, pagebuf), 0);
>     ++		set_prefix_key_1((uint32_t *)2048);
>     ++		install_page(root, 0, 0);
>     ++		check_pgm_int_code(PGM_INT_CODE_PROTECTION);
>     ++		report(get_prefix() != *prefix_ptr, "did not set prefix");
>     ++		report_prefix_pop();
>     ++	}
>      +
>      +	ctl_clear_bit(0, CTL0_FETCH_PROTECTION_OVERRIDE);
>     -+	set_storage_key(pagebuf, 0x00, 0);
>      +	register_pgm_cleanup_func(NULL);
>      +	report_prefix_pop();
>     ++	set_storage_key(pagebuf, 0x00, 0);
>     ++	report_prefix_pop();
>      +}
>      +
>       int main(void)
> 
>  lib/s390x/asm/arch_def.h |  20 ++--
>  s390x/skey.c             | 227 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 238 insertions(+), 9 deletions(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index bab3c374..676a2753 100644
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
> index edad53e9..aa2b845f 100644
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
> @@ -118,6 +119,227 @@ static void test_invalid_address(void)
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
> +	report(tprot(addr, 0) == 0, "access key 0 -> no protection");
> +	report(tprot(addr, 1) == 0, "access key matches -> no protection");
> +	report(tprot(addr, 2) == 1, "access key mismatches, no fetch protection -> store protection");
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
> +static void test_set_prefix(void)
> +{
> +	char lowcore_tmp[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE * 2)));

perhaps it's cleaner to put this as a global (static) variable

also, please define LC_SIZE (2*PAGE_SIZE) and use that

> +	uint32_t *prefix_ptr = (uint32_t *)pagebuf;
> +	uint32_t old_prefix;
> +	pgd_t *root;
> +
> +	report_prefix_push("SET PREFIX");
> +	root = (pgd_t *)(stctg(1) & PAGE_MASK);
> +	old_prefix = get_prefix();
> +	memcpy(lowcore_tmp, 0, PAGE_SIZE * 2);
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
> +	report(get_prefix() != *prefix_ptr, "did not set prefix");

why don't you check == old_prefix instead? that way you know noting has
changed (also for all the other tests below where you do the same)

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
> +	report(get_prefix() != *prefix_ptr, "did not set prefix");
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
> +	{
> +		uint32_t *prefix_ptr = (uint32_t *)(pagebuf + 2048);

please don't alias variables

either reuse the existing one (and restore its value once you are
done), or add a new variable for this purpose

> +
> +		WRITE_ONCE(*prefix_ptr, (uint32_t)(uint64_t)&lowcore_tmp);
> +		report_prefix_push("fetch protection override does not apply");
> +		set_prefix(old_prefix);
> +		set_storage_key(pagebuf, 0x28, 0);
> +		expect_pgm_int();
> +		install_page(root, virt_to_pte_phys(root, pagebuf), 0);
> +		set_prefix_key_1((uint32_t *)2048);
> +		install_page(root, 0, 0);
> +		check_pgm_int_code(PGM_INT_CODE_PROTECTION);
> +		report(get_prefix() != *prefix_ptr, "did not set prefix");
> +		report_prefix_pop();
> +	}
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
> @@ -130,6 +352,11 @@ int main(void)
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
> 
> base-commit: 6a7a83ed106211fc0ee530a3a05f171f6a4c4e66

