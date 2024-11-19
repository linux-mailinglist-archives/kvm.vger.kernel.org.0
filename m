Return-Path: <kvm+bounces-32087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 749D79D2D79
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 19:03:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 08F891F2662C
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 18:03:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 919171D27B3;
	Tue, 19 Nov 2024 18:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JFgq9lP2"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD0213B780;
	Tue, 19 Nov 2024 18:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732039279; cv=none; b=eA7O6dde0r12w2CG8z9gE+uVQpMuwAk1h3ZAbq0h3aHGU7eoO8rMPJdAZD1XqMctto/yQA2TmYBAURNkwBv9BualnOOTZQVkC8VUQwCZnuFanEI7ZMOZzuqWOoEENTyuLFp+XdCmbYGdrH/+94z5aquRAG+JLpPuWovV34BqreI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732039279; c=relaxed/simple;
	bh=jaS++F2xsrYM/FY+QIngLzh3/Zr6ROQc1dgT4Ot/vi0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tonh9iGgtWPz/pYiX+xvLBUSAW8Rw3eA2ArdqgNOsymXn9Sc2nxIpTOyFONG8ltlEzUxrrqSsQ0V+vj2xiLLp1NG5VtAu2rBMdym0ile6a2hhEvc8Utcz8wQDo245plnkiuJUppRHI9sBWaczDbC8TmWY3W1NiDY1IICRK+MjYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JFgq9lP2; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AJG8Mon022084;
	Tue, 19 Nov 2024 18:01:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=IKGoqi
	EuUfCjlGEYsOTA5LPUwOxMpi+cljnvwNMNLFQ=; b=JFgq9lP2lYD8aF1SF24nxk
	nd9gfBX7T2HsXuuo10YB5Gsq+LA/iHWQgsVuJWqPeIl99ggxIhUNoiM5dT4k0yBU
	9OmwYB11K9ztDhOha503MuiaTdcuuj1HTr6m/u7rDVBFC/RSC0qMpILNEEYMw6ZS
	mxktEq8qhYscKmGYKRhz3WU5Q+KIvSSJfRmEjMTep9teypiK8wsSwh987mYNwzPU
	diAouypOdDuCLtX0kwj2uqjtZZFsCnTMVHrisOsxjrlfv5zoBiJrwRKin4VJcxXr
	KBUO6cB2y61blyT3/K6LzcUZiOFmiDMvQeyJDhavkHyZl50zefU3SHqsiGU6oyOw
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42xk2w1nuu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Nov 2024 18:01:14 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AJAeGZ5030582;
	Tue, 19 Nov 2024 18:01:13 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 42y5qsd42u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Nov 2024 18:01:13 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4AJI17kS57672106
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Nov 2024 18:01:07 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 660982004D;
	Tue, 19 Nov 2024 18:01:07 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1FA032004B;
	Tue, 19 Nov 2024 18:01:07 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 19 Nov 2024 18:01:07 +0000 (GMT)
Date: Tue, 19 Nov 2024 19:01:05 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <kvm@vger.kernel.org>, <nrb@linux.ibm.com>, <frankja@linux.ibm.com>,
        <borntraeger@de.ibm.com>, <thuth@redhat.com>, <david@redhat.com>,
        <linux-s390@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH v2 1/1] s390x: pv: Add test for large
 host pages backing
Message-ID: <20241119190105.02804b2a@p-imbrenda>
In-Reply-To: <D5Q9UYK621SX.3N31BCUZK3RBZ@linux.ibm.com>
References: <20241111121529.30153-1-imbrenda@linux.ibm.com>
	<D5Q9UYK621SX.3N31BCUZK3RBZ@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: UctvG-TKvOuMsx9FGp3PpU55nYE58MFP
X-Proofpoint-GUID: UctvG-TKvOuMsx9FGp3PpU55nYE58MFP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 phishscore=0 clxscore=1015 suspectscore=0 spamscore=0
 impostorscore=0 bulkscore=0 mlxscore=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411190134

On Tue, 19 Nov 2024 16:48:37 +0100
"Christoph Schlameuss" <schlameuss@linux.ibm.com> wrote:

> Sorry for not seeing this on the first review, but there still is something.
> 
> On Mon Nov 11, 2024 at 1:15 PM CET, Claudio Imbrenda wrote:
> > Add a new test to check that the host can use 1M large pages to back
> > protected guests when the corresponding feature is present.
> >
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >  s390x/Makefile               |   2 +
> >  lib/s390x/asm/arch_def.h     |   1 +
> >  lib/s390x/asm/uv.h           |  18 ++
> >  s390x/pv-edat1.c             | 463 +++++++++++++++++++++++++++++++++++
> >  s390x/snippets/c/pv-memhog.c |  59 +++++
> >  5 files changed, 543 insertions(+)
> >  create mode 100644 s390x/pv-edat1.c
> >  create mode 100644 s390x/snippets/c/pv-memhog.c  
> 
> [...]
> 
> > +static void timings(void)
> > +{
> > +	const uint64_t seqs[] = { 0, 1, 3, 7, 17, 27, 63, 127};  
> 
> Missing space in the end

will fix

> [...]
> 
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
> 
> The tree checks here "pre1m == 1" and "pre1m != 1" do not quite add up. pre1m
> is only ever called with pre1m = -1 and pre1m = 0.
> With this the first of the three map_identity_all calls here will always map
> normal pages and the next two calls will never happen.

yeah, because the loop used to go to 1, and I don't remember why I
changed it... maybe it should actually go all the way to 1 again...

> 
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
> 
> s/and/or/

will fix differently

> 
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
> 
> [...]
> 


