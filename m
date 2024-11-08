Return-Path: <kvm+bounces-31289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 324959C216B
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 17:01:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5B3F2856FB
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 16:01:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9F67192D6A;
	Fri,  8 Nov 2024 16:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JV9/wDSO"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A0F13B29F;
	Fri,  8 Nov 2024 16:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731081614; cv=none; b=rLZ2phyRRd7/dAE2NTMi6QbPZgMXl9XLtE0jBVPIG06vNbd5YXae72GRjWs7HVv8eG3JEuM3EfWIgAfS7cNAilOCRSY2Nz6jHyU/lA5O0cihxZYewhj4kn9+hGYXMcteawDU0R7MQaEx+mrWuQeTzxItml35y8WIYDS3em5EpXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731081614; c=relaxed/simple;
	bh=ZnbuJhE78g4pgPLlWqy7GQF22h6kZFNtrOiFfiUaQx4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XKOYFfFOGPcFJBZRLF57gN0isJExcWN6h3bbhXEOfcKs3L8hs3zTD0M8zZ8KsSaEN2+rV8J3ivtKhDULjxCK5xcKC6Wl4hQW1vWsOMg5wympvAUu+ZV+QiLQ5svfAgkXt2LbRRIyArx+siNd8T2WXiUOWiRMDFPCS3yx6niGMIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JV9/wDSO; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A8FeFe4008885;
	Fri, 8 Nov 2024 16:00:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=D3R5WA
	ALenkWxQuggY6fgV5bkeZns04ww8Kfo0gtCEY=; b=JV9/wDSOY3AG2dCqzB2qHr
	GbUwBbu84YH49HENodXjV4XElrUlPayBM2bwEG4daRneGxd1dDa3LDietGQuXLLh
	BAKsSacf3S1KY4jwbAxPz+tcbHkUs8fK486xJu550m9Dzbv+lodNOWWpxEOpd1O2
	hGXy94PuV5u6iPbowS7mHIHevm7ty4Cusx99TuSlTQgZesjUrJnYbw9KHcouH9fd
	4Y+T1dFwPcTEeatMdxfi0MGhSjxd4FO/BfqPYKck5nENs6iY0eBNgCZYpVfc1gJR
	y23uOESnUXpnxFw6h0hWA+XqRH8tHr8nA8skxnOn25AvhsX8MVCeW4TF+xa+T+tw
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42sng202s7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Nov 2024 16:00:08 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4A8F5j7S023983;
	Fri, 8 Nov 2024 16:00:07 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42nxt0bfyw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Nov 2024 16:00:07 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4A8G01c965864090
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 8 Nov 2024 16:00:01 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C9D3F20043;
	Fri,  8 Nov 2024 16:00:01 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2E8C32004B;
	Fri,  8 Nov 2024 16:00:01 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.75.121])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with SMTP;
	Fri,  8 Nov 2024 16:00:01 +0000 (GMT)
Date: Fri, 8 Nov 2024 16:59:57 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <kvm@vger.kernel.org>, <nrb@linux.ibm.com>, <frankja@linux.ibm.com>,
        <borntraeger@de.ibm.com>, <thuth@redhat.com>, <david@redhat.com>,
        <linux-s390@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH v1 1/1] s390x: pv: Add test for large
 host pages backing
Message-ID: <20241108165957.2a0051c5@p-imbrenda>
In-Reply-To: <D5GTXFFS12YE.LGRT3DOXFEUK@linux.ibm.com>
References: <20241105174523.51257-1-imbrenda@linux.ibm.com>
	<D5GTXFFS12YE.LGRT3DOXFEUK@linux.ibm.com>
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
X-Proofpoint-GUID: T8jZF3c2CpSt0M2sgv6rRfLtXQs-S0pw
X-Proofpoint-ORIG-GUID: T8jZF3c2CpSt0M2sgv6rRfLtXQs-S0pw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 bulkscore=0
 adultscore=0 impostorscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411080130

On Fri, 08 Nov 2024 14:25:33 +0100
"Christoph Schlameuss" <schlameuss@linux.ibm.com> wrote:

> On Tue Nov 5, 2024 at 6:45 PM CET, Claudio Imbrenda wrote:
> > Add a new test to check that the host can use 1M large pages to back
> > protected guests when the corresponding feature is present.
> >
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

[...]

> > +#include <libcflat.h>
> > +#include <vmalloc.h>
> > +#include <sie.h>
> > +#include <sclp.h>
> > +#include <snippet.h>
> > +#include <pv_icptdata.h>
> > +#include <asm/interrupt.h>
> > +#include <asm/facility.h>
> > +#include <asm/uv.h>
> > +#include <asm/page.h>
> > +#include <asm/mem.h>
> > +#include <mmu.h>
> > +#include <asm/time.h>  
> 
> Maybe sort these for improved maintainability.

will do

> 
> > +
> > +#define GUEST_ORDER	REGION3_SHIFT
> > +#define GUEST_SIZE	BIT_ULL(REGION3_SHIFT)
> > +#define N_ITER 		32
> > +#define MAGIC_ADDRESS	0x12a000
> > +
> > +#define FIRST		42
> > +#define SECOND		23
> > +
> > +#define STR(x)		((x) ? "1m" : "4k")
> > +#define STR3(x)		((x) != -1 ? STR(x) : "no")
> > +#define PARAM(n, step)	(((unsigned long)(n) << 32) | (step))
> > +
> > +static struct vm vm;
> > +static void *root;
> > +
> > +extern const char SNIPPET_NAME_START(c, pv_memhog)[];
> > +extern const char SNIPPET_NAME_END(c, pv_memhog)[];
> > +extern const char SNIPPET_HDR_START(c, pv_memhog)[];
> > +extern const char SNIPPET_HDR_END(c, pv_memhog)[];
> > +
> > +static void init_snippet(struct vm *vm) {
> > +	const unsigned long size_hdr = SNIPPET_HDR_LEN(c, pv_memhog);
> > +	const unsigned long size_gbin = SNIPPET_LEN(c, pv_memhog);
> > +
> > +	snippet_pv_init(vm, SNIPPET_NAME_START(c, pv_memhog),
> > +			SNIPPET_HDR_START(c, pv_memhog),
> > +			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
> > +}
> > +
> > +static uint64_t tod_to_us(uint64_t tod)
> > +{
> > +	return tod >> STCK_SHIFT_US;
> > +}
> > +/*
> > +static uint64_t tod_to_ns(uint64_t tod)
> > +{
> > +	return tod_to_us(tod * 1000);
> > +}
> > +*/  
> 
> Do we really want to add commented code?

oops

> 
> > +
> > +static inline uint64_t guest_start(struct vm *vm)
> > +{
> > +	return vm->sblk->mso;
> > +}
> > +
> > +static inline uint64_t guest_end(struct vm *vm)
> > +{
> > +	return vm->sblk->msl + SZ_1M;
> > +}
> > +
> > +static inline uint64_t guest_size(struct vm *vm)
> > +{
> > +	return guest_end(vm) - guest_start(vm);
> > +}
> > +
> > +static uint16_t uvc_merge(struct vm *vm, uint64_t addr)
> > +{
> > +	struct uv_cb_cts uvcb = {
> > +		.header.cmd = UVC_CMD_VERIFY_LARGE_FRAME,
> > +		.header.len = sizeof(uvcb),
> > +		.guest_handle = vm->uv.vm_handle,
> > +		.gaddr = addr,
> > +	};
> > +	int cc;
> > +
> > +	cc = uv_call(0, (uint64_t)&uvcb);
> > +	assert(cc ? uvcb.header.rc != 1 : uvcb.header.rc == 1);
> > +	return uvcb.header.rc;
> > +}
> > +
> > +static void map_identity_range(struct vm *vm, uint64_t start, uint64_t end, bool map1m)
> > +{
> > +	uint64_t mem = guest_start(vm);
> > +
> > +	if (map1m) {
> > +		for (start &= HPAGE_MASK; start < end; start += HPAGE_SIZE)
> > +			install_large_page(root, mem + start, (void *)(mem + start));
> > +	} else {
> > +		for (start &= PAGE_SIZE; start < end; start += PAGE_SIZE)
> > +			install_page(root, mem + start, (void *)(mem + start));
> > +	}
> > +}
> > +
> > +static inline void map_identity_all(struct vm *vm, bool map1m)
> > +{
> > +	map_identity_range(vm, 0, guest_size(vm), map1m);
> > +}
> > +
> > +static void import_range(struct vm *vm, uint64_t start, uint64_t end)
> > +{
> > +	for (start &= PAGE_MASK; start < end; start += PAGE_SIZE)
> > +		assert(uv_import(vm->uv.vm_handle, guest_start(vm) + start) == 0);
> > +}
> > +
> > +static inline void import_all(struct vm *vm)
> > +{
> > +	import_range(vm, 0, guest_size(vm));
> > +}
> > +
> > +static void export_range(struct vm *vm, uint64_t start, uint64_t end)
> > +{
> > +	for (start &= PAGE_MASK; start < end; start += PAGE_SIZE)
> > +		assert(uv_export(guest_start(vm) + start) == 0);
> > +}
> > +
> > +static void merge_range(struct vm *vm, uint64_t start, uint64_t end)
> > +{
> > +	for (start &= HPAGE_MASK; start < end; start += HPAGE_SIZE)
> > +		assert(uvc_merge(vm, guest_start(vm) + start) == 1);
> > +}
> > +
> > +static inline void merge_all(struct vm *vm)
> > +{
> > +	merge_range(vm, 0, guest_size(vm));
> > +}
> > +
> > +static inline bool pgm_3c_addr_is(struct vm *vm, uint64_t gaddr)
> > +{
> > +	union teid teid = { .val = lowcore.trans_exc_id };
> > +	bool res;
> > +
> > +	res = (lowcore.pgm_int_code == PGM_INT_CODE_SECURE_PAGE_SIZE) &&
> > +		(teid.addr == (guest_start(vm) + gaddr) >> PAGE_SHIFT);
> > +	clear_pgm_int();
> > +	return res;
> > +}
> > +
> > +static inline void assert_diag500_val(struct vm *vm, uint64_t val)
> > +{
> > +	assert(pv_icptdata_check_diag(vm, 0x500));
> > +	assert(vm->save_area.guest.grs[2] == val);
> > +}
> > +
> > +static void run_iterations(struct vm *vm, uint64_t param, bool ptlb_always, bool merge)
> > +{
> > +	uint64_t total, elapsed, best, worst;
> > +	uint64_t before, after;
> > +	int i;
> > +
> > +	map_identity_all(vm, 0);
> > +	init_snippet(vm);
> > +	import_all(vm);
> > +	map_identity_all(vm, merge);
> > +	if (merge)
> > +		merge_all(vm);
> > +
> > +	sie(vm);
> > +	assert_diag500_val(vm, FIRST);
> > +	vm->save_area.guest.grs[2] = PARAM(0, param);  
> 
> This is just param, is it not?
> So we can directly set "= param;" for clarity.

I think it's important to highlight that we intentionally put a 0 there

> 
> > +
> > +	total  = worst = 0;  
> 
> s/  / /

oops

> 
> > +	best = -1;
> > +
> > +	ptlb();
> > +	for (i = 0; i < N_ITER; i++) {
> > +		if (ptlb_always)
> > +			ptlb();
> > +
> > +		stckf(&before);
> > +		sie(vm);
> > +		stckf(&after);
> > +
> > +		assert_diag500_val(vm, SECOND);
> > +		vm->save_area.guest.grs[2] = 42;
> > +
> > +		elapsed = tod_to_us(after - before);
> > +
> > +		total += elapsed;
> > +
> > +		best = best > elapsed ? elapsed : best;
> > +		worst = worst < elapsed ? elapsed : worst;
> > +	}
> > +	uv_destroy_guest(vm);
> > +
> > +	report_info("%5lu %5lu %5lu", best, total / N_ITER, worst);
> > +}
> > +
> > +static void timings(void)
> > +{
> > +	const uint64_t seqs[] = { 0, 1, 3, 7, 17, 27, 63, 127};
> > +	unsigned int purge, map1m, seq;
> > +
> > +	report_prefix_push("timings");
> > +
> > +	report_info("Averages over %u iterations, in us (best/average/worst)", N_ITER);
> > +	for (purge = 0; purge < 2; purge++) {
> > +		report_prefix_pushf("ptlb %s", purge ? "always" : "  once");
> > +		for (seq = 0; seq < ARRAY_SIZE(seqs); seq++) {
> > +			if (seqs[seq])
> > +				report_prefix_pushf("seq step %3lu", seqs[seq]);
> > +			else
> > +				report_prefix_push("pseudorandom");
> > +			for (map1m = 0; map1m < 2; map1m++) {
> > +				report_prefix_pushf("%s", STR(map1m));
> > +				run_iterations(&vm, seqs[seq], purge, map1m);
> > +				report_prefix_pop();
> > +			}
> > +			report_prefix_pop();
> > +		}
> > +		report_prefix_pop();
> > +	}
> > +
> > +	report_pass("Timing tests successful");
> > +	report_prefix_pop();
> > +}
> > +
> > +
> > +static void do_one_test(struct vm *vm, bool init1m, bool import1m, int merge, bool run1m)
> > +{
> > +	map_identity_all(vm, init1m);
> > +	init_snippet(vm);
> > +
> > +	map_identity_all(vm, import1m);
> > +	import_all(vm);
> > +
> > +	if (merge >= 0) {
> > +		map_identity_all(vm, merge);
> > +		merge_all(vm);
> > +	}
> > +
> > +	map_identity_all(vm, run1m);
> > +	if ((merge == -1) && run1m) {
> > +		sie(vm);
> > +		report(vm->sblk->icptcode == ICPT_PV_PREF, "ICPT 112");
> > +		merge_range(vm, 0, SZ_1M);
> > +		expect_pgm_int();
> > +		sie(vm);
> > +		report(pgm_3c_addr_is(vm, MAGIC_ADDRESS), "PGM 3C at address %#x", MAGIC_ADDRESS);
> > +		map_identity_all(vm, false);
> > +	}
> > +
> > +	sie(vm);
> > +	assert_diag500_val(vm, FIRST);
> > +	vm->save_area.guest.grs[2] = PARAM(4096, 1);  
> 
> s/4096/PAGE_SIZE/ ?

no, it's not a size, it's how many pages will be touched. I simply
chose a nice round number

> 
> > +	sie(vm);
> > +	assert_diag500_val(vm, 23);
> > +
> > +	uv_destroy_guest(vm);
> > +}
> > +
> > +
> > +static void test_run(void)
> > +{
> > +	int init1m, import1m, merge, run1m;
> > +
> > +	report_prefix_push("test run");
> > +
> > +	for (init1m = 0; init1m < 1; init1m++) {
> > +		for (import1m = 0; import1m < 2; import1m++) {
> > +			for (merge = -1; merge < 2; merge++) {
> > +				for (run1m = 0; run1m < 2; run1m++) {
> > +					report_prefix_pushf("init %s, import %s, merge %s, run %s",
> > +						STR(init1m), STR(import1m), STR3(merge), STR(run1m));
> > +
> > +					do_one_test(&vm, init1m, import1m, merge, run1m);
> > +					report_pass("Execution successful");
> > +
> > +					report_prefix_pop();
> > +				}
> > +			}
> > +		}
> > +	}
> > +
> > +	report_prefix_pop();
> > +}
> > +
> > +static void test_merge(void)
> > +{
> > +	uint64_t tmp, mem;
> > +	int cc;
> > +
> > +	report_prefix_push("merge");
> > +	init_snippet(&vm);
> > +
> > +	mem = guest_start(&vm);
> > +
> > +	map_identity_all(&vm, false);
> > +	install_page(root, mem + 0x101000, (void *)(mem + 0x102000));
> > +	install_page(root, mem + 0x102000, (void *)(mem + 0x101000));
> > +	install_page(root, mem + 0x205000, (void *)(mem + 0x305000));
> > +	install_page(root, mem + 0x305000, (void *)(mem + 0x205000));
> > +	import_range(&vm, 0, 0x400000);
> > +	import_range(&vm, 0x401000, 0x501000);
> > +	import_range(&vm, 0x600000, 0x700000);
> > +
> > +	/* Address lower than MSO */
> > +	report(uvc_merge(&vm, 0) == 0x103, "Address below MSO");
> > +	report(uvc_merge(&vm, mem - SZ_1M) == 0x103, "Address below MSO");
> > +
> > +	/* Address higher than MSL */
> > +	install_large_page(root, guest_end(&vm), (void *)guest_end(&vm));
> > +	report(uvc_merge(&vm, guest_end(&vm)) == 0x103, "Address above MSL");
> > +
> > +	/* Not all pages are imported */
> > +	report(uvc_merge(&vm, mem + 0x400000) == 0x106, "First page not imported");
> > +	report(uvc_merge(&vm, mem + 0x500000) == 0x106, "Only first page imported");
> > +
> > +	/* Large 2G page used */
> > +	tmp = mem & REGION3_ENTRY_RFAA;
> > +	install_huge_page(root, tmp, (void *)tmp);
> > +	report(uvc_merge(&vm, mem) == 0x109, "Large region-3 table entry (2G page)");
> > +	map_identity_range(&vm, 0, SZ_2G, false);
> > +
> > +	/* Not all pages are aligned correctly */
> > +	report(uvc_merge(&vm, mem + 0x100000) == 0x104, "Pages not consecutive");
> > +	report(uvc_merge(&vm, mem + 0x200000) == 0x104, "Pages not in the same 1M frame");
> > +
> > +	/* Invalid host virtual to host aboslute mapping */
> > +	install_large_page(root, get_ram_size(), (void *)(mem + 0x600000));
> > +	report(uvc_merge(&vm, mem + 0x600000) == 0x107, "Invalid mapping");
> > +	map_identity_range(&vm, 0x600000, 0x700000, false);
> > +
> > +	/* Success */
> > +	report(uvc_merge(&vm, mem) == 1, "Successful merge");
> > +
> > +	cc = uv_export(mem + 0xff000);
> > +	report(cc == 0, "Successful export of merged page");
> > +
> > +	uv_destroy_guest(&vm);
> > +	report_prefix_pop();
> > +}
> > +
> > +static void test_one_export(struct vm *vm, int pre1m, bool exportfirst, int page, bool post1m)
> > +{
> > +	uint64_t addr = SZ_1M + page * PAGE_SIZE;
> > +	int expected = FIRST;
> > +
> > +	report_prefix_pushf("page %d", page);
> > +
> > +	map_identity_all(vm, pre1m == 1);
> > +	init_snippet(vm);
> > +	import_all(vm);
> > +	merge_all(vm);
> > +
> > +	if (pre1m != -1) {
> > +		sie(vm);
> > +		assert_diag500_val(vm, expected);
> > +		vm->save_area.guest.grs[2] = PARAM(4, 256 + 42);
> > +		expected = SECOND;
> > +	}
> > +
> > +	if (exportfirst) {
> > +		export_range(vm, addr, addr + PAGE_SIZE);
> > +		if (pre1m != 1)
> > +			map_identity_all(vm, true);
> > +	} else {
> > +		if (pre1m != 1)
> > +			map_identity_all(vm, true);
> > +		export_range(vm, addr, addr + PAGE_SIZE);
> > +	}
> > +	expect_pgm_int();
> > +	sie(vm);
> > +	assert(pgm_3c_addr_is(vm, MAGIC_ADDRESS));
> > +
> > +	import_range(vm, addr, addr + PAGE_SIZE);
> > +	if (post1m) {
> > +		merge_range(vm, SZ_1M, 2 * SZ_1M);
> > +	} else {
> > +		map_identity_all(vm, false);
> > +	}
> > +	sie(vm);
> > +	assert_diag500_val(vm, expected);
> > +	report_pass("Successful");
> > +
> > +	uv_destroy_guest(vm);
> > +	report_prefix_pop();
> > +}
> > +
> > +static void test_export(void)
> > +{
> > +	int pre1m, post1m, exportfirst;
> > +
> > +	report_prefix_push("export");
> > +
> > +	for (pre1m = -1; pre1m < 1; pre1m++) {
> > +		for (post1m = 0; post1m < 2; post1m++) {
> > +			for (exportfirst = 0; exportfirst < 2; exportfirst++) {
> > +				report_prefix_pushf("%s pre-run, %s post-run, export %s remap",
> > +						    STR3(pre1m), STR(post1m), exportfirst ? "before" : "after");
> > +
> > +				test_one_export(&vm, pre1m, exportfirst, 0, post1m);
> > +				test_one_export(&vm, pre1m, exportfirst, 1, post1m);
> > +				test_one_export(&vm, pre1m, exportfirst, 42, post1m);
> > +				test_one_export(&vm, pre1m, exportfirst, 128, post1m);
> > +				test_one_export(&vm, pre1m, exportfirst, 254, post1m);
> > +				test_one_export(&vm, pre1m, exportfirst, 255, post1m);
> > +
> > +				report_prefix_pop();
> > +			}
> > +		}
> > +	}
> > +
> > +	report_prefix_pop();
> > +}
> > +
> > +static bool check_facilities(void)
> > +{
> > +	if (!uv_host_requirement_checks())
> > +		return false;
> > +	if (!test_facility(8) || !test_facility(78)) {
> > +		report_skip("EDAT1 and EDAT2 not available in the host.");
> > +		return false;
> > +	}
> > +	if (!uv_query_test_call(BIT_UVC_CMD_VERIFY_LARGE_FRAME)) {
> > +		report_skip("Verify Large Frame UVC not supported.");
> > +		return false;
> > +	}
> > +	if (!uv_query_test_feature(BIT_UV_1M_BACKING)) {
> > +		report_skip("Large frames not supported for Secure Execution.");
> > +		return false;
> > +	}
> > +	return true;
> > +}
> > +
> > +static void init(void)
> > +{
> > +	uint8_t *guest_memory;
> > +
> > +	setup_vm();
> > +
> > +	root = (void *)(stctg(1) & PAGE_MASK);
> > +	ctl_set_bit(0, CTL0_EDAT);
> > +
> > +	guest_memory = alloc_pages(GUEST_ORDER - PAGE_SHIFT);
> > +	sie_guest_create(&vm, (uint64_t)guest_memory, GUEST_SIZE);
> > +	sie_guest_sca_create(&vm);
> > +	uv_init();
> > +	uv_setup_asces();
> > +}
> > +
> > +int main(void)
> > +{
> > +	report_prefix_push("uv-edat1-host");
> > +
> > +	if (check_facilities()) {
> > +		init();
> > +
> > +		test_merge();
> > +		test_export();
> > +		test_run();
> > +
> > +		timings();
> > +
> > +		sie_guest_destroy(&vm);
> > +	}
> > +
> > +	report_prefix_pop();
> > +	return report_summary();
> > +}
> > diff --git a/s390x/snippets/c/pv-memhog.c b/s390x/snippets/c/pv-memhog.c
> > new file mode 100644
> > index 00000000..43f0c2b1
> > --- /dev/null
> > +++ b/s390x/snippets/c/pv-memhog.c
> > @@ -0,0 +1,59 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * Snippet used by the pv-edat1.c test.
> > + * This snippet expects to run with at least 2G or memory.
> > + *
> > + * Copyright (c) 2024 IBM Corp
> > + *
> > + * Authors:
> > + *  Claudio Imbrenda <imbrenda@linux.ibm.com>
> > + */
> > +#include <libcflat.h>
> > +#include <asm-generic/page.h>
> > +#include <asm/mem.h>
> > +
> > +#define N_PAGES		(SZ_2G / PAGE_SIZE)
> > +#define MID_OF_PAGE	(PAGE_SIZE / 2)
> > +#define MASK_2G		(SZ_2G - 1)
> > +#define MIDPAGE_PTR(x)	((uint64_t *)((x) + MID_OF_PAGE))
> > +
> > +static inline void sie_exit(void)
> > +{
> > +	asm volatile("diag	0,0,0x44\n" : : : "memory");
> > +}
> > +
> > +static inline uint64_t get_value(uint64_t res)
> > +{
> > +	asm volatile("lgr	%%r2, %[res]\n"
> > +		"	diag	0, 0, 0x500\n"
> > +		"	lgr	%[res], %%r2\n"
> > +		     : [res] "+d"(res)
> > +		     :
> > +		     : "2", "memory"
> > +	);
> > +	return res;
> > +}
> > +
> > +int main(void)
> > +{
> > +	uint64_t param, addr, i, n;
> > +
> > +	READ_ONCE(*MIDPAGE_PTR(SZ_1M + 42 * PAGE_SIZE));
> > +	param = get_value(42);
> > +
> > +	n = (param >> 32) & 0x1fffffff;
> > +	n = n ? n : N_PAGES;
> > +	param &= 0x7fffffff;  
> 
> This is ARCH_LOW_ADDRESS_LIMIT. Should we add that to the local arch_def.h or
> mem.h to enable reuse?

I think that would be a little overkill

> 
> > +
> > +	while (true) {
> > +		for (i = 0; i < n; i++) {
> > +			addr = ((param ? i * param : i * i * i) * PAGE_SIZE) & MASK_2G;
> > +			WRITE_ONCE(*MIDPAGE_PTR(addr), addr);
> > +		}
> > +
> > +		i = get_value(23);
> > +		if (i != 42)
> > +			sie_exit();
> > +	}
> > +	return 0;
> > +}  
> 


