Return-Path: <kvm+bounces-27462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 092729863AE
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 17:35:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F585288428
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 15:35:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 768741D5ABB;
	Wed, 25 Sep 2024 15:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="iriWs/sX"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D53A79C4;
	Wed, 25 Sep 2024 15:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727278504; cv=none; b=nrYm9bmXQ29l4W2y5JIfFJDb9b8IcTfwERZOs4vHyHh0SFrP3vtfSgpaMim/Ju2uLzDoaPTsXRRfyv3M06lpKXcUoLhTfKeSjyQ0evuSj+ha4rq/DtlxqKlWow9SsinnBM67z/v6YdK48MZV/zbdfhEBzigTNGU4Ljo+lJ6T2sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727278504; c=relaxed/simple;
	bh=z3q3GjFVywwq2ocN5TULCG0CsJuBNiZ6jZaDuxNjFXc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WSoiFeYwk/t7tVgu8td45iGz7LTQv4UNltwODfMqFp3HgDxflHBWRVfJUlHuBwYfPrDN3sDjtuKAiR1ih40GTkrrJ7ayqukv4SE9176Ysua7E0ricwmWh4Rb2G3Uxc910KQ/YaPhi77EFxL7wBr9iWpn/FKk051FhXKeOdKXjZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=iriWs/sX; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48PEuQPi020947;
	Wed, 25 Sep 2024 15:35:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=pp1; bh=
	JQNLR8XETTwARjCB7ac+l9z5NKznlVAK54UpeHtbTPw=; b=iriWs/sXrtrMUEtk
	5TiNZ2OltMxhvebNXozBbIh1HfT3CVHmja0v0b7kIOPOyUox9pHq9eMcKPl5oRZ2
	Rn+rhcwf5vWaUlFqsbebD3k30n/fWiph6oFnrOvDyHMp9eslCeG33e6orVukrGAr
	D3DHF36hcQqjeqPIBrJtJiBMhDpYSxlwgmluv7QZptSGE0mdQrHDCyjIBmRGrMWr
	lHyF/M/rwSokSuL2l0HAExQkPR3D0v++/+yvme4HeBkovrU+ulPKf1vLSGlEujh8
	ApV8PMTI3ot4/4DZisPs+lzGaOtctR1mXWDXDg/ldT9hjNG3a94hIJRMEXf0yUVN
	J4sH2A==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41snvb910m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Sep 2024 15:35:00 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 48PFYxrh004080;
	Wed, 25 Sep 2024 15:34:59 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41snvb910h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Sep 2024 15:34:59 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 48PCu9LF012541;
	Wed, 25 Sep 2024 15:34:58 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 41t9fq2cgx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Sep 2024 15:34:58 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 48PFYsD043450788
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Sep 2024 15:34:54 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 70A1320043;
	Wed, 25 Sep 2024 15:34:54 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4597C20040;
	Wed, 25 Sep 2024 15:34:54 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 25 Sep 2024 15:34:54 +0000 (GMT)
Date: Wed, 25 Sep 2024 17:34:52 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Nico Boehr <nrb@linux.ibm.com>
Cc: frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 1/2] s390x: add test for diag258
Message-ID: <20240925173452.5781864f@p-imbrenda.boeblingen.de.ibm.com>
In-Reply-To: <20240923062820.319308-2-nrb@linux.ibm.com>
References: <20240923062820.319308-1-nrb@linux.ibm.com>
	<20240923062820.319308-2-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: B0DBGuMphd6pnKPfQp58xaPgKjkSu73m
X-Proofpoint-GUID: hMOLP1tWvvURQdJaKe4fiiNvwLaLN1hm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-25_10,2024-09-25_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 spamscore=0 mlxscore=0
 adultscore=0 impostorscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2409250111

On Mon, 23 Sep 2024 08:26:03 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> This adds a test for diag258 (page ref service/async page fault).
> 
> There recently was a virtual-real address confusion bug, so we should
> test:
> - diag258 parameter Rx is a real adress
> - crossing the end of RAM with the parameter list yields an addressing
>   exception
> - invalid diagcode in the parameter block yields an specification
>   exception
> - diag258 correctly applies prefixing.
> 
> Note that we're just testing error cases as of now.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>  s390x/Makefile      |   1 +
>  s390x/diag258.c     | 258 ++++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg |   3 +
>  3 files changed, 262 insertions(+)
>  create mode 100644 s390x/diag258.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 23342bd64f44..66d71351caab 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -44,6 +44,7 @@ tests += $(TEST_DIR)/exittime.elf
>  tests += $(TEST_DIR)/ex.elf
>  tests += $(TEST_DIR)/topology.elf
>  tests += $(TEST_DIR)/sie-dat.elf
> +tests += $(TEST_DIR)/diag258.elf
>  
>  pv-tests += $(TEST_DIR)/pv-diags.elf
>  pv-tests += $(TEST_DIR)/pv-icptcode.elf
> diff --git a/s390x/diag258.c b/s390x/diag258.c
> new file mode 100644
> index 000000000000..5337534f60d1
> --- /dev/null
> +++ b/s390x/diag258.c
> @@ -0,0 +1,258 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Diag 258: Async Page Fault Handler
> + *
> + * Copyright (c) 2024 IBM Corp
> + *
> + * Authors:
> + *  Nico Boehr <nrb@linux.ibm.com>
> + */
> +
> +#include <libcflat.h>
> +#include <asm-generic/barrier.h>
> +#include <asm/asm-offsets.h>
> +#include <asm/interrupt.h>
> +#include <asm/mem.h>
> +#include <asm/pgtable.h>
> +#include <mmu.h>
> +#include <sclp.h>
> +#include <vmalloc.h>
> +
> +static uint8_t prefix_buf[LC_SIZE] __attribute__((aligned(LC_SIZE)));

wait, you are using LC_SIZE in this file... even though it's only
defined in the next patch.

I think you should swap patch 1 and 2

> +
> +#define __PF_RES_FIELD 0x8000000000000000UL
> +
> +/* copied from Linux arch/s390/mm/pfault.c */
> +struct pfault_refbk {
> +	u16 refdiagc;
> +	u16 reffcode;
> +	u16 refdwlen;
> +	u16 refversn;
> +	u64 refgaddr;
> +	u64 refselmk;
> +	u64 refcmpmk;
> +	u64 reserved;
> +};
> +
> +uint64_t pfault_token = 0x0123fadec0fe3210UL;
> +
> +static struct pfault_refbk pfault_init_refbk __attribute__((aligned(8))) = {
> +	.refdiagc = 0x258,
> +	.reffcode = 0, /* TOKEN */
> +	.refdwlen = sizeof(struct pfault_refbk) / sizeof(uint64_t),
> +	.refversn = 2,
> +	.refgaddr = (u64)&pfault_token,
> +	.refselmk = 1UL << 48,
> +	.refcmpmk = 1UL << 48,
> +	.reserved = __PF_RES_FIELD
> +};
> +
> +static struct pfault_refbk pfault_cancel_refbk __attribute((aligned(8))) = {
> +	.refdiagc = 0x258,
> +	.reffcode = 1, /* CANCEL */
> +	.refdwlen = sizeof(struct pfault_refbk) / sizeof(uint64_t),
> +	.refversn = 2,
> +	.refgaddr = 0,
> +	.refselmk = 0,
> +	.refcmpmk = 0,
> +	.reserved = 0
> +};
> +
> +static inline int diag258(struct pfault_refbk *refbk)
> +{
> +	int rc = -1;
> +
> +	asm volatile(
> +		"	diag	%[refbk],%[rc],0x258\n"
> +		: [rc] "+d" (rc)
> +		: [refbk] "a" (refbk), "m" (*(refbk))
> +		: "cc");
> +	return rc;
> +}
> +
> +static void test_priv(void)
> +{
> +	report_prefix_push("privileged");
> +	expect_pgm_int();
> +	enter_pstate();
> +	diag258(&pfault_init_refbk);
> +	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
> +	report_prefix_pop();
> +}
> +
> +static void* page_map_outside_real_space(phys_addr_t page_real)
> +{
> +	pgd_t *root = (pgd_t *)(stctg(1) & PAGE_MASK);
> +	void* vaddr = alloc_vpage();
> +
> +	install_page(root, page_real, vaddr);
> +
> +	return vaddr;
> +}
> +
> +/*
> + * Verify that the refbk pointer is a real address and not a virtual
> + * address. This is tested by enabling DAT and establishing a mapping
> + * for the refbk that is outside of the bounds of our (guest-)physical

s/physical/real/ (or absolute)

> + * address space.
> + */
> +static void test_refbk_real(void)
> +{
> +	pgd_t *root;
> +	struct pfault_refbk *refbk;
> +	void *refbk_page;

please reverse Christmas tree

> +
> +	report_prefix_push("refbk is real");
> +
> +	/* Set up virtual memory and allocate a physical page for storing the refbk */
> +	setup_vm();
> +	refbk_page = alloc_page();
> +
> +	/* Map refblk page outside of physical memory identity mapping */
> +	root = (pgd_t *)(stctg(1) & PAGE_MASK);
> +	refbk = page_map_outside_real_space(virt_to_pte_phys(root, refbk_page));
> +
> +	/* Assert the mapping really is outside identity mapping */
> +	report_info("refbk is at 0x%lx", (u64)refbk);
> +	report_info("ram size is 0x%lx", get_ram_size());
> +	assert((u64)refbk > get_ram_size());
> +
> +	/* Copy the init refbk to the page */
> +	memcpy(refbk, &pfault_init_refbk, sizeof(struct pfault_refbk));
> +
> +	/* Protect the virtual mapping to avoid diag258 actually doing something */
> +	protect_page(refbk, PAGE_ENTRY_I);
> +
> +	expect_pgm_int();
> +	diag258(refbk);
> +	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
> +	report_prefix_pop();
> +
> +	free_page(refbk_page);
> +	disable_dat();
> +	irq_set_dat_mode(false, 0);
> +}
> +
> +/*
> + * Verify diag258 correctly applies prefixing.
> + */
> +static void test_refbk_prefixing(void)
> +{
> +	uint64_t ry;
> +	uint32_t old_prefix;
> +	struct pfault_refbk *refbk_in_prefix, *refbk_in_reverse_prefix;
> +	const size_t lowcore_offset_for_refbk = offsetof(struct lowcore, pad_0x03a0);

reverse Christmas tree here too

> +
> +	report_prefix_push("refbk prefixing");
> +
> +	report_info("refbk at lowcore offset 0x%lx", lowcore_offset_for_refbk);
> +
> +	assert((unsigned long)&prefix_buf < SZ_2G);
> +
> +	memcpy(prefix_buf, 0, LC_SIZE);
> +
> +	/*
> +	 * After the call to set_prefix() below, this will refer to absolute
> +	 * address lowcore_offset_for_refbk (reverse prefixing).
> +	 */
> +	refbk_in_reverse_prefix = (struct pfault_refbk *)(&prefix_buf[0] + lowcore_offset_for_refbk);
> +
> +	/*
> +	 * After the call to set_prefix() below, this will refer to absolute
> +	 * address &prefix_buf[0] + lowcore_offset_for_refbk (forward prefixing).
> +	 */
> +	refbk_in_prefix = (struct pfault_refbk *)OPAQUE_PTR(lowcore_offset_for_refbk);
> +
> +	old_prefix = get_prefix();
> +	set_prefix((uint32_t)(uintptr_t)prefix_buf);
> +
> +	/*
> +	 * If diag258 would not be applying prefixing on access to
> +	 * refbk_in_reverse_prefix correctly, it would access absolute address
> +	 * refbk_in_reverse_prefix (which to us is accessible at real address
> +	 * refbk_in_prefix).
> +	 * Make sure it really fails by putting invalid function code
> +	 * at refbk_in_prefix.
> +	 */
> +	refbk_in_prefix->refdiagc = 0xc0fe;
> +
> +	/*
> +	 * Put a valid refbk at refbk_in_reverse_prefix.
> +	 */
> +	memcpy(refbk_in_reverse_prefix, &pfault_init_refbk, sizeof(pfault_init_refbk));
> +
> +	ry = diag258(refbk_in_reverse_prefix);
> +	report(!ry, "real address refbk accessed");
> +
> +	/*
> +	 * Activating should have worked. Cancel the activation and expect
> +	 * return 0. If activation would not have worked, this should return with
> +	 * 4 (pfault handshaking not active).
> +	 */
> +	ry = diag258(&pfault_cancel_refbk);
> +	report(!ry, "handshaking canceled");
> +
> +	set_prefix(old_prefix);
> +
> +	report_prefix_pop();
> +}

it seems like you are only testing the first page of lowcore; can you
expand the test to also test the second page?

> +
> +/*
> + * Verify that a refbk exceeding physical memory is not accepted, even
> + * when crossing a frame boundary.
> + */
> +static void test_refbk_crossing(void)
> +{
> +	const size_t bytes_in_last_page = 8;

are there any alignment requirements for the buffer?
if so, that should also be tested (either that a fault is triggered or
that the lowest bytes are ignored, depending on how it is defined to
work)

> +	struct pfault_refbk *refbk = (struct pfault_refbk *)(get_ram_size() - bytes_in_last_page);
> +
> +	report_prefix_push("refbk crossing");
> +
> +	report_info("refbk is at 0x%lx", (u64)refbk);
> +	report_info("ram size is 0x%lx", get_ram_size());
> +	assert(sizeof(struct pfault_refbk) > bytes_in_last_page);
> +
> +	/* Copy bytes_in_last_page bytes of the init refbk to the page */
> +	memcpy(refbk, &pfault_init_refbk, bytes_in_last_page);
> +
> +	expect_pgm_int();
> +	diag258(refbk);
> +	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
> +	report_prefix_pop();
> +}
> +
> +/*
> + * Verify that a refbk with an invalid refdiagc is not accepted.
> + */
> +static void test_refbk_invalid_diagcode(void)
> +{
> +	struct pfault_refbk refbk = pfault_init_refbk;
> +
> +	report_prefix_push("invalid refdiagc");
> +	refbk.refdiagc = 0xc0fe;

other testcases in this file depend on invalid codes failing; maybe
move this test up?

> +
> +	expect_pgm_int();
> +	diag258(&refbk);
> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +	report_prefix_pop();
> +}
> +
> +int main(void)
> +{
> +	report_prefix_push("diag258");
> +
> +	expect_pgm_int();
> +	diag258(&pfault_init_refbk);
> +	if (clear_pgm_int() == PGM_INT_CODE_SPECIFICATION) {
> +		report_skip("diag258 not supported");
> +	} else {
> +		test_priv();
> +		test_refbk_real();

should probably go here....

> +		test_refbk_prefixing();
> +		test_refbk_crossing();
> +		test_refbk_invalid_diagcode();

.... this one ^

> +	}
> +
> +	report_prefix_pop();
> +	return report_summary();
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index 3a9decc932f2..8131ba105d3f 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -392,3 +392,6 @@ file = sie-dat.elf
>  
>  [pv-attest]
>  file = pv-attest.elf
> +
> +[diag258]
> +file = diag258.elf


