Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED09B51DDF3
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 18:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443950AbiEFQ40 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 12:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351249AbiEFQ4Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 12:56:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C80B633B6;
        Fri,  6 May 2022 09:52:41 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 246G0cgf018741;
        Fri, 6 May 2022 16:52:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=tIcz72VwcVwTQMshZTWxNXukvIjQVB6ofXO17yHyJlE=;
 b=gltzcSiojh+TD3dejePE1C/yTsHg/Nnz8iPhLXVRUp76JpzgYL7oVY5/JGUwObZ04ku9
 triv/MP4Zqp/DPGddRAZZymb5LLVXT+sLG5vl5EW6P9qmC7YT8yQbbVcF2bSWpA00gsd
 0QbG6JKnPCnaC4+DEXJn1T0R8LvpvI5PxzYisYri+GMbWc9XbXonXwzEkpjOaWIzFi/0
 ESLX2SCCOk/BcqVDlqq6z6i+oTo7h9hwxINJSyVsXMbbrbNKzGXJzZACJ0ABlLP1nVez
 uCnBILEnCMKhJ1mJb7bgf03Jih9Qtdr6dwns0puP+4KVZSr8x7sfqvuRqv6bHYW1OpoH nQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fw6tr10jd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 16:52:40 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 246Gp6m3014399;
        Fri, 6 May 2022 16:52:40 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fw6tr10hy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 16:52:40 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 246Gnr4i019499;
        Fri, 6 May 2022 16:52:38 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3fvnaqh78h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 16:52:37 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 246GqYCL49348886
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 May 2022 16:52:34 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C55A3A405B;
        Fri,  6 May 2022 16:52:34 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5FE41A405C;
        Fri,  6 May 2022 16:52:34 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.15.58])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  6 May 2022 16:52:34 +0000 (GMT)
Date:   Fri, 6 May 2022 18:52:27 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 3/3] s390x: Test effect of storage keys
 on some more instructions
Message-ID: <20220506185227.165c7d86@p-imbrenda>
In-Reply-To: <20220505124656.1954092-4-scgl@linux.ibm.com>
References: <20220505124656.1954092-1-scgl@linux.ibm.com>
        <20220505124656.1954092-4-scgl@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dHKZw8RJlR4ni4xteMHiHGGWBsIPUGtG
X-Proofpoint-GUID: qU1-KbwskcMjfYhxqd4DoxFrSx4mHPpF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-06_05,2022-05-06_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 clxscore=1011 phishscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205060085
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  5 May 2022 14:46:56 +0200
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> Test correctness of some instructions handled by user space instead of
> KVM with regards to storage keys.
> Test success and error conditions, including coverage of storage and
> fetch protection override.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
>  s390x/skey.c        | 277 ++++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg |   1 +
>  2 files changed, 278 insertions(+)
> 
> diff --git a/s390x/skey.c b/s390x/skey.c
> index 56bf5f45..d50470a8 100644
> --- a/s390x/skey.c
> +++ b/s390x/skey.c
> @@ -12,6 +12,7 @@
>  #include <asm/asm-offsets.h>
>  #include <asm/interrupt.h>
>  #include <vmalloc.h>
> +#include <css.h>
>  #include <asm/page.h>
>  #include <asm/facility.h>
>  #include <asm/mem.h>
> @@ -284,6 +285,114 @@ static void test_store_cpu_address(void)
>  	report_prefix_pop();
>  }
>  
> +/*
> + * Perform CHANNEL SUBSYSTEM CALL (CHSC)  instruction while temporarily executing
> + * with access key 1.
> + */
> +static unsigned int channel_subsystem_call_key_1(void *communication_block)

this function name is very long (maybe chsc_with_key_1 instead?)

> +{
> +	uint32_t program_mask;
> +
> +	asm volatile (
> +		"spka	0x10\n\t"
> +		".insn	rre,0xb25f0000,%[communication_block],0\n\t"
> +		"spka	0\n\t"
> +		"ipm	%[program_mask]\n"
> +		: [program_mask] "=d" (program_mask)
> +		: [communication_block] "d" (communication_block)
> +		: "memory"
> +	);
> +	return program_mask >> 28;
> +}
> +
> +static void init_store_channel_subsystem_characteristics(uint16_t *communication_block)

same here (init_comm_block?)

> +{
> +	memset(communication_block, 0, PAGE_SIZE);
> +	communication_block[0] = 0x10;
> +	communication_block[1] = 0x10;
> +	communication_block[9] = 0;
> +}
> +
> +static void test_channel_subsystem_call(void)
> +{
> +	static const char request_name[] = "Store channel-subsystem-characteristics";

so this "request_name" is for when CHSC succeeds? why not just
"Success" then?

> +	uint16_t *communication_block = (uint16_t *)&pagebuf;

long name (consider comm_block, or even cb)

> +	unsigned int cc;
> +
> +	report_prefix_push("CHANNEL SUBSYSTEM CALL");
> +
> +	report_prefix_push("zero key");
> +	init_store_channel_subsystem_characteristics(communication_block);

see what I mean when I say that the names are too long? ^

> +	set_storage_key(communication_block, 0x10, 0);
> +	asm volatile (
> +		".insn	rre,0xb25f0000,%[communication_block],0\n\t"
> +		"ipm	%[cc]\n"
> +		: [cc] "=d" (cc)
> +		: [communication_block] "d" (communication_block)
> +		: "memory"
> +	);
> +	cc = cc >> 28;
> +	report(cc == 0 && communication_block[9], request_name);
> +	report_prefix_pop();
> +
> +	report_prefix_push("matching key");
> +	init_store_channel_subsystem_characteristics(communication_block);
> +	set_storage_key(communication_block, 0x10, 0);

you just set the storage key in the previous test, and you did not set
it back to 0, why do you need to set it again?

> +	cc = channel_subsystem_call_key_1(communication_block);
> +	report(cc == 0 && communication_block[9], request_name);
> +	report_prefix_pop();
> +
> +	report_prefix_push("mismatching key");
> +
> +	report_prefix_push("no fetch protection");
> +	init_store_channel_subsystem_characteristics(communication_block);
> +	set_storage_key(communication_block, 0x20, 0);
> +	expect_pgm_int();
> +	channel_subsystem_call_key_1(communication_block);
> +	check_key_prot_exc(ACC_UPDATE, PROT_STORE);
> +	report_prefix_pop();
> +
> +	report_prefix_push("fetch protection");
> +	init_store_channel_subsystem_characteristics(communication_block);
> +	set_storage_key(communication_block, 0x28, 0);
> +	expect_pgm_int();
> +	channel_subsystem_call_key_1(communication_block);
> +	check_key_prot_exc(ACC_UPDATE, PROT_FETCH_STORE);
> +	report_prefix_pop();
> +
> +	ctl_set_bit(0, CTL0_STORAGE_PROTECTION_OVERRIDE);
> +
> +	report_prefix_push("storage-protection override, invalid key");
> +	set_storage_key(communication_block, 0x20, 0);
> +	init_store_channel_subsystem_characteristics(communication_block);
> +	expect_pgm_int();
> +	channel_subsystem_call_key_1(communication_block);
> +	check_key_prot_exc(ACC_UPDATE, PROT_STORE);
> +	report_prefix_pop();
> +
> +	report_prefix_push("storage-protection override, override key");
> +	init_store_channel_subsystem_characteristics(communication_block);
> +	set_storage_key(communication_block, 0x90, 0);
> +	cc = channel_subsystem_call_key_1(communication_block);
> +	report(cc == 0 && communication_block[9], request_name);
> +	report_prefix_pop();
> +
> +	ctl_clear_bit(0, CTL0_STORAGE_PROTECTION_OVERRIDE);
> +
> +	report_prefix_push("storage-protection override disabled, override key");
> +	init_store_channel_subsystem_characteristics(communication_block);
> +	set_storage_key(communication_block, 0x90, 0);
> +	expect_pgm_int();
> +	channel_subsystem_call_key_1(communication_block);
> +	check_key_prot_exc(ACC_UPDATE, PROT_STORE);
> +	report_prefix_pop();
> +
> +	report_prefix_pop();
> +
> +	set_storage_key(communication_block, 0x00, 0);
> +	report_prefix_pop();
> +}
> +
>  /*
>   * Perform SET PREFIX (SPX) instruction while temporarily executing
>   * with access key 1.
> @@ -410,6 +519,172 @@ static void test_set_prefix(void)
>  	report_prefix_pop();
>  }
>  
> +/*
> + * Perform MODIFY SUBCHANNEL (MSCH) instruction while temporarily executing
> + * with access key 1.
> + */
> +static uint32_t modify_subchannel_key_1(uint32_t sid, struct schib *schib)
> +{
> +	uint32_t program_mask;
> +
> +	asm volatile (
> +		"lr %%r1,%[sid]\n\t"
> +		"spka	0x10\n\t"
> +		"msch	%[schib]\n\t"
> +		"spka	0\n\t"
> +		"ipm	%[program_mask]\n"
> +		: [program_mask] "=d" (program_mask)
> +		: [sid] "d" (sid),
> +		  [schib] "Q" (*schib)
> +		: "%r1"
> +	);
> +	return program_mask >> 28;
> +}
> +
> +static void test_msch(void)
> +{
> +	struct schib *schib = (struct schib *)pagebuf;
> +	struct schib *no_override_schib;
> +	int test_device_sid;
> +	pgd_t *root;
> +	int cc;
> +
> +	report_prefix_push("MSCH");
> +	root = (pgd_t *)(stctg(1) & PAGE_MASK);
> +	test_device_sid = css_enumerate();
> +
> +	if (!(test_device_sid & SCHID_ONE)) {
> +		report_fail("no I/O device found");
> +		return;
> +	}
> +
> +	cc = stsch(test_device_sid, schib);
> +	if (cc) {
> +		report_fail("could not store SCHIB");
> +		return;
> +	}
> +
> +	report_prefix_push("zero key");
> +	schib->pmcw.intparm = 100;
> +	set_storage_key(schib, 0x28, 0);
> +	cc = msch(test_device_sid, schib);
> +	if (!cc) {
> +		WRITE_ONCE(schib->pmcw.intparm, 0);

why are you using WRITE_ONCE here?

> +		cc = stsch(test_device_sid, schib);
> +		report(!cc && schib->pmcw.intparm == 100, "fetched from SCHIB");
> +	} else {
> +		report_fail("MSCH cc != 0");
> +	}
> +	report_prefix_pop();
> +
> +	report_prefix_push("matching key");
> +	schib->pmcw.intparm = 200;
> +	set_storage_key(schib, 0x18, 0);
> +	cc = modify_subchannel_key_1(test_device_sid, schib);
> +	if (!cc) {
> +		WRITE_ONCE(schib->pmcw.intparm, 0);
> +		cc = stsch(test_device_sid, schib);
> +		report(!cc && schib->pmcw.intparm == 200, "fetched from SCHIB");
> +	} else {
> +		report_fail("MSCH cc != 0");
> +	}
> +	report_prefix_pop();
> +
> +	report_prefix_push("mismatching key");
> +
> +	report_prefix_push("no fetch protection");
> +	schib->pmcw.intparm = 300;
> +	set_storage_key(schib, 0x20, 0);
> +	cc = modify_subchannel_key_1(test_device_sid, schib);
> +	if (!cc) {
> +		WRITE_ONCE(schib->pmcw.intparm, 0);
> +		cc = stsch(test_device_sid, schib);
> +		report(!cc && schib->pmcw.intparm == 300, "fetched from SCHIB");
> +	} else {
> +		report_fail("MSCH cc != 0");
> +	}
> +	report_prefix_pop();
> +
> +	schib->pmcw.intparm = 0;
> +	if (!msch(test_device_sid, schib)) {
> +		report_prefix_push("fetch protection");
> +		schib->pmcw.intparm = 400;
> +		set_storage_key(schib, 0x28, 0);
> +		expect_pgm_int();
> +		modify_subchannel_key_1(test_device_sid, schib);
> +		check_key_prot_exc(ACC_FETCH, PROT_FETCH_STORE);
> +		WRITE_ONCE(schib->pmcw.intparm, 0);
> +		cc = stsch(test_device_sid, schib);
> +		report(!cc && schib->pmcw.intparm == 0, "did not modify subchannel");
> +		report_prefix_pop();
> +	} else {
> +		report_fail("could not reset SCHIB");
> +	}
> +
> +	register_pgm_cleanup_func(dat_fixup_pgm_int);
> +
> +	schib->pmcw.intparm = 0;
> +	if (!msch(test_device_sid, schib)) {
> +		report_prefix_push("remapped page, fetch protection");
> +		schib->pmcw.intparm = 500;
> +		set_storage_key(pagebuf, 0x28, 0);
> +		expect_pgm_int();
> +		install_page(root, virt_to_pte_phys(root, pagebuf), 0);
> +		modify_subchannel_key_1(test_device_sid, (struct schib *)0);
> +		install_page(root, 0, 0);
> +		check_key_prot_exc(ACC_FETCH, PROT_FETCH_STORE);
> +		WRITE_ONCE(schib->pmcw.intparm, 0);
> +		cc = stsch(test_device_sid, schib);
> +		report(!cc && schib->pmcw.intparm == 0, "did not modify subchannel");
> +		report_prefix_pop();
> +	} else {
> +		report_fail("could not reset SCHIB");
> +	}
> +
> +	ctl_set_bit(0, CTL0_FETCH_PROTECTION_OVERRIDE);
> +
> +	report_prefix_push("fetch-protection override applies");
> +	schib->pmcw.intparm = 600;
> +	set_storage_key(pagebuf, 0x28, 0);
> +	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
> +	cc = modify_subchannel_key_1(test_device_sid, (struct schib *)0);
> +	install_page(root, 0, 0);
> +	if (!cc) {
> +		WRITE_ONCE(schib->pmcw.intparm, 0);
> +		cc = stsch(test_device_sid, schib);
> +		report(!cc && schib->pmcw.intparm == 600, "fetched from SCHIB");
> +	} else {
> +		report_fail("MSCH cc != 0");
> +	}
> +	report_prefix_pop();
> +
> +	schib->pmcw.intparm = 0;
> +	if (!msch(test_device_sid, schib)) {
> +		report_prefix_push("fetch-protection override does not apply");
> +		schib->pmcw.intparm = 700;
> +		no_override_schib = (struct schib *)(pagebuf + 2048);
> +		memcpy(no_override_schib, schib, sizeof(struct schib));
> +		set_storage_key(pagebuf, 0x28, 0);
> +		expect_pgm_int();
> +		install_page(root, virt_to_pte_phys(root, pagebuf), 0);
> +		modify_subchannel_key_1(test_device_sid, (struct schib *)2048);
> +		install_page(root, 0, 0);
> +		check_key_prot_exc(ACC_FETCH, PROT_FETCH_STORE);
> +		WRITE_ONCE(schib->pmcw.intparm, 0);
> +		cc = stsch(test_device_sid, schib);
> +		report(!cc && schib->pmcw.intparm == 0, "did not modify subchannel");
> +		report_prefix_pop();
> +	} else {
> +		report_fail("could not reset SCHIB");
> +	}
> +
> +	ctl_clear_bit(0, CTL0_FETCH_PROTECTION_OVERRIDE);
> +	register_pgm_cleanup_func(NULL);
> +	report_prefix_pop();
> +	set_storage_key(schib, 0x00, 0);
> +	report_prefix_pop();
> +}
> +
>  int main(void)
>  {
>  	report_prefix_push("skey");
> @@ -424,9 +699,11 @@ int main(void)
>  	test_chg();
>  	test_test_protection();
>  	test_store_cpu_address();
> +	test_channel_subsystem_call();
>  
>  	setup_vm();
>  	test_set_prefix();
> +	test_msch();
>  done:
>  	report_prefix_pop();
>  	return report_summary();
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index 743013b2..069c41a7 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -41,6 +41,7 @@ file = sthyi.elf
>  
>  [skey]
>  file = skey.elf
> +extra_params = -device virtio-net-ccw
>  
>  [diag10]
>  file = diag10.elf

