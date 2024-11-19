Return-Path: <kvm+bounces-32080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2B149D2A23
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 16:51:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3C08282EA8
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 15:51:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE81C1CFED8;
	Tue, 19 Nov 2024 15:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="EIpQPVH3"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B911CDFD7;
	Tue, 19 Nov 2024 15:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732031334; cv=none; b=ArcPRzkKitdigJHMIJ9lcHVrMRe7yYFKWYpjgVyuyCpKJOGwLPgvNaPl3VkgmQUfvpYED7d2yXCFLVPbsMAALGR5LSz8z0e5rqGH5z0m/y/mBoc4mGUUnZ9Y1mO7JW3JKUtGa5MMu2YOyyiHlOxclcPGMqotOtRJCToQw85nAZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732031334; c=relaxed/simple;
	bh=x0iK28w2aU9XfhhtmB3Ch1Vxg0vp2qf+sjqosN65gcI=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:To:Subject:From:
	 References:In-Reply-To; b=ai2IQYOkAe90NtAIuChqtLsxjP9XjnyKe8MOJGf61aLFeQiRRq17ZxEv1xWtDXidZwnSAJpYJtQHV3Nk7yBcuAyiZR/v7BsPp0FVKQeF20v5DAH60Os3l02R8LzyMbB6+Vs73uYwe9GFmdWsN0cGhr2l/eu6kHSzk8YzghXL30w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=EIpQPVH3; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AJ7hwOY021942;
	Tue, 19 Nov 2024 15:48:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=js9ffY
	MPoQ8v0iw40azbiVlGBZMXLIGFZGWdTtksHzI=; b=EIpQPVH3/05fFGGIisdT5y
	6ZX3dxnWtpsKJ+r95ugvXrD0rgyxe8KldrTxTLR0760l8bQX40XN4FPC0VtgSuk/
	idOp/g4bZgxeNt+LA2gqF6cw3Rm+kKJVHxGiGQdV+QS5+Vx4V8WaW4r0JJMXnXsS
	UWiY4zQupspC1ms1hWKnFyZ0r0eEx2YA5d0Cjs3DejoENh/yNrV+XAlLmOMnRd10
	2jxRQV3MnD3x7ndFwl4ZCufpPqEmZbsZFA1Q/FbBY3b4Vih3SiX/PiGGRM39hyQL
	jCto2oBpYBt2HsX5m6dxLq5pq1ragpwGArJI9RYXcNdHednlEgEDEstqJAnG4foA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42xhtjr1de-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Nov 2024 15:48:49 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AJF2Fl9030962;
	Tue, 19 Nov 2024 15:48:48 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42y63yh68q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Nov 2024 15:48:48 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4AJFmgRo18547122
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Nov 2024 15:48:42 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A793720043;
	Tue, 19 Nov 2024 15:48:42 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7D9A220040;
	Tue, 19 Nov 2024 15:48:42 +0000 (GMT)
Received: from darkmoore (unknown [9.171.29.184])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 19 Nov 2024 15:48:42 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 19 Nov 2024 16:48:37 +0100
Message-Id: <D5Q9UYK621SX.3N31BCUZK3RBZ@linux.ibm.com>
Cc: <nrb@linux.ibm.com>, <frankja@linux.ibm.com>, <borntraeger@de.ibm.com>,
        <thuth@redhat.com>, <david@redhat.com>, <linux-s390@vger.kernel.org>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>, <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH v2 1/1] s390x: pv: Add test for large
 host pages backing
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
X-Mailer: aerc 0.18.2
References: <20241111121529.30153-1-imbrenda@linux.ibm.com>
In-Reply-To: <20241111121529.30153-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jKx8Z0WWXs-vcuyr8E27mP4_uWAsQKP9
X-Proofpoint-GUID: jKx8Z0WWXs-vcuyr8E27mP4_uWAsQKP9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 clxscore=1015 malwarescore=0 spamscore=0 bulkscore=0 priorityscore=1501
 impostorscore=0 mlxscore=0 adultscore=0 suspectscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2409260000
 definitions=main-2411190114

Sorry for not seeing this on the first review, but there still is something=
.

On Mon Nov 11, 2024 at 1:15 PM CET, Claudio Imbrenda wrote:
> Add a new test to check that the host can use 1M large pages to back
> protected guests when the corresponding feature is present.
>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  s390x/Makefile               |   2 +
>  lib/s390x/asm/arch_def.h     |   1 +
>  lib/s390x/asm/uv.h           |  18 ++
>  s390x/pv-edat1.c             | 463 +++++++++++++++++++++++++++++++++++
>  s390x/snippets/c/pv-memhog.c |  59 +++++
>  5 files changed, 543 insertions(+)
>  create mode 100644 s390x/pv-edat1.c
>  create mode 100644 s390x/snippets/c/pv-memhog.c

[...]

> +static void timings(void)
> +{
> +	const uint64_t seqs[] =3D { 0, 1, 3, 7, 17, 27, 63, 127};

Missing space in the end

> +	unsigned int purge, map1m, seq;
> +
> +	report_prefix_push("timings");
> +
> +	report_info("Averages over %u iterations, in us (best/average/worst)", =
N_ITER);
> +	for (purge =3D 0; purge < 2; purge++) {
> +		report_prefix_pushf("ptlb %s", purge ? "always" : "  once");
> +		for (seq =3D 0; seq < ARRAY_SIZE(seqs); seq++) {
> +			if (seqs[seq])
> +				report_prefix_pushf("seq step %3lu", seqs[seq]);
> +			else
> +				report_prefix_push("pseudorandom");
> +			for (map1m =3D 0; map1m < 2; map1m++) {
> +				report_prefix_pushf("%s", STR(map1m));
> +				run_iterations(&vm, seqs[seq], purge, map1m);
> +				report_prefix_pop();
> +			}
> +			report_prefix_pop();
> +		}
> +		report_prefix_pop();
> +	}
> +
> +	report_pass("Timing tests successful");
> +	report_prefix_pop();
> +}

[...]

> +static void test_one_export(struct vm *vm, int pre1m, bool exportfirst, =
int page, bool post1m)
> +{
> +	uint64_t addr =3D SZ_1M + page * PAGE_SIZE;
> +	int expected =3D FIRST;
> +
> +	report_prefix_pushf("page %d", page);
> +
> +	map_identity_all(vm, pre1m =3D=3D 1);
> +	init_snippet(vm);
> +	import_all(vm);
> +	merge_all(vm);
> +
> +	if (pre1m !=3D -1) {
> +		sie(vm);
> +		assert_diag500_val(vm, expected);
> +		vm->save_area.guest.grs[2] =3D PARAM(4, 256 + 42);
> +		expected =3D SECOND;
> +	}
> +
> +	if (exportfirst) {
> +		export_range(vm, addr, addr + PAGE_SIZE);
> +		if (pre1m !=3D 1)
> +			map_identity_all(vm, true);
> +	} else {
> +		if (pre1m !=3D 1)
> +			map_identity_all(vm, true);
> +		export_range(vm, addr, addr + PAGE_SIZE);
> +	}

The tree checks here "pre1m =3D=3D 1" and "pre1m !=3D 1" do not quite add u=
p. pre1m
is only ever called with pre1m =3D -1 and pre1m =3D 0.
With this the first of the three map_identity_all calls here will always ma=
p
normal pages and the next two calls will never happen.

> +	expect_pgm_int();
> +	sie(vm);
> +	assert(pgm_3c_addr_is(vm, MAGIC_ADDRESS));
> +
> +	import_range(vm, addr, addr + PAGE_SIZE);
> +	if (post1m) {
> +		merge_range(vm, SZ_1M, 2 * SZ_1M);
> +	} else {
> +		map_identity_all(vm, false);
> +	}
> +	sie(vm);
> +	assert_diag500_val(vm, expected);
> +	report_pass("Successful");
> +
> +	uv_destroy_guest(vm);
> +	report_prefix_pop();
> +}
> +
> +static void test_export(void)
> +{
> +	int pre1m, post1m, exportfirst;
> +
> +	report_prefix_push("export");
> +
> +	for (pre1m =3D -1; pre1m < 1; pre1m++) {
> +		for (post1m =3D 0; post1m < 2; post1m++) {
> +			for (exportfirst =3D 0; exportfirst < 2; exportfirst++) {
> +				report_prefix_pushf("%s pre-run, %s post-run, export %s remap",
> +						    STR3(pre1m), STR(post1m), exportfirst ? "before" : "after");
> +
> +				test_one_export(&vm, pre1m, exportfirst, 0, post1m);
> +				test_one_export(&vm, pre1m, exportfirst, 1, post1m);
> +				test_one_export(&vm, pre1m, exportfirst, 42, post1m);
> +				test_one_export(&vm, pre1m, exportfirst, 128, post1m);
> +				test_one_export(&vm, pre1m, exportfirst, 254, post1m);
> +				test_one_export(&vm, pre1m, exportfirst, 255, post1m);
> +
> +				report_prefix_pop();
> +			}
> +		}
> +	}
> +
> +	report_prefix_pop();
> +}
> +
> +static bool check_facilities(void)
> +{
> +	if (!uv_host_requirement_checks())
> +		return false;
> +	if (!test_facility(8) || !test_facility(78)) {
> +		report_skip("EDAT1 and EDAT2 not available in the host.");

s/and/or/

> +		return false;
> +	}
> +	if (!uv_query_test_call(BIT_UVC_CMD_VERIFY_LARGE_FRAME)) {
> +		report_skip("Verify Large Frame UVC not supported.");
> +		return false;
> +	}
> +	if (!uv_query_test_feature(BIT_UV_1M_BACKING)) {
> +		report_skip("Large frames not supported for Secure Execution.");
> +		return false;
> +	}
> +	return true;
> +}

[...]


