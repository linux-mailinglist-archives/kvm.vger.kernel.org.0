Return-Path: <kvm+bounces-20143-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DDF7910E6A
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 19:26:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 62E111C20A92
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 17:26:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42EEA1B3F27;
	Thu, 20 Jun 2024 17:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eu4AcGEO"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C201B3F0E;
	Thu, 20 Jun 2024 17:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718904351; cv=none; b=EYwerQ0JZ/YAiJYeAPQGMbaU1dvvLBWe6DEwCOJY+qe+t9KMYOYhMTLkhbgeH4WWTKEVINQjlgMqyPfxushpo2T8YFh7UNmsI4+z2swlSeP9vet4ZX83pwgATcabv5fHn/JXfBzjGPJDZc7tkTZlu7zPYXvEnW0opvHz0UDaH6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718904351; c=relaxed/simple;
	bh=hN0b2LLleoqmubUmL+bixuOJiLy8lbFdd1/rCEeFfM0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RT+l351hH8yP6vAMolXY0OB1Ohu2p+rd1mk8G3YLJ6Ck3OHtTejVLq1vUs+Injz5XAgPxmsjm4djAOaj5Q8cP8lrbrgT9fNhGHX55ue3MZdmFwaMUmwyFiUYK5zZuYRKaOQkGrRtUe3L7LAmwblBsaEiYvltQusFKUqwB0YXf/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=eu4AcGEO; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45KHOVAq015178;
	Thu, 20 Jun 2024 17:25:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=pp1; bh=
	L7scgMpUtlIWCluM4kq6eJBaPh5vpGZ89gfkkNlYfc4=; b=eu4AcGEODp+lAxkl
	uu4iBrN7Qh4Gr7r4yb/6E6m2IdtTa6iNpHv8NBx0TAlNR8reC0Ah8qB/bR+KTAq8
	0CzPQWbGY4jfMhznQBCRGnoJMeuL2khTqkJcEN++jfZHQ13gXqB7YURel6bDku8U
	BjRvgmi++9JlSIL1Y3vp0nC7LehquF5CxZQvknxKcM1TOno14yErBrCrFwkHwpzs
	5NU4yRqu4CTfM9tJcrsOHy23Q4MawcJytMzrjy0IDNtBp3FpVBeJSbBFAVgZGxI0
	RYFIadqm2yXGcLHFo6jFBIQFFSYUbp53lbnBORvNHx2ffClTGr5e8HxfOHBjUMi3
	fpwGXQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yvrsu0043-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 17:25:44 +0000 (GMT)
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45KHPi2q016493;
	Thu, 20 Jun 2024 17:25:44 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yvrsu0040-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 17:25:43 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45KHNhdS007669;
	Thu, 20 Jun 2024 17:25:43 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3yvrsp80fg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 17:25:42 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45KHPbph51249602
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 17:25:39 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 453C82004B;
	Thu, 20 Jun 2024 17:25:37 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B6F242004E;
	Thu, 20 Jun 2024 17:25:36 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.47.175])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 20 Jun 2024 17:25:36 +0000 (GMT)
Date: Thu, 20 Jun 2024 19:25:34 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>,
        Nico =?UTF-8?B?QsO2aHI=?=
 <nrb@linux.ibm.com>,
        Andrew Jones <andrew.jones@linux.dev>, Thomas Huth
 <thuth@redhat.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        David Hildenbrand
 <david@redhat.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 7/7] s390x: Add test for STFLE
 interpretive execution (format-0)
Message-ID: <20240620192534.292e51cb@p-imbrenda>
In-Reply-To: <20240620141700.4124157-8-nsg@linux.ibm.com>
References: <20240620141700.4124157-1-nsg@linux.ibm.com>
	<20240620141700.4124157-8-nsg@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: AfXI3Lns1Yn9TBKoenBcpMlbP6xPDU0E
X-Proofpoint-ORIG-GUID: oLkK704AtkViL2Tv2L8k-eiygT7Pdw5b
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-20_07,2024-06-20_04,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0
 phishscore=0 impostorscore=0 priorityscore=1501 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2406140001
 definitions=main-2406200126

On Thu, 20 Jun 2024 16:17:00 +0200
Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:

> The STFLE instruction indicates installed facilities.
> SIE can interpretively execute STFLE.
> Use a snippet guest executing STFLE to get the result of
> interpretive execution and check the result.
> 
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>


[...]


> +struct guest_stfle_res {
> +	uint16_t len;
> +	uint64_t reg;

you don't really use reg, do you?

> +	unsigned char *mem;
> +};
> +
> +static struct guest_stfle_res run_guest(void)
> +{
> +	struct guest_stfle_res res;
> +	uint64_t guest_stfle_addr;

uint64_t tmp;

> +
> +	sie(&vm);
> +	assert(snippet_is_force_exit_value(&vm));
> +	guest_stfle_addr = snippet_get_force_exit_value(&vm);
> +	res.mem = &vm.guest_mem[guest_stfle_addr];
> +	memcpy(&res.reg, res.mem, sizeof(res.reg));

memcpy(&tmp, res.mem, etc);

> +	res.len = (res.reg & 0xff) + 1;

(tmp & 0xff) + 1

etc 

> +	res.mem += sizeof(res.reg);

(you could just do res.mem++ if you had declared it as uint64_t *
instead of unsigned char *)

> +	return res;
> +}
> +


[...]


> +int main(int argc, char **argv)
> +{
> +	struct args args = parse_args(argc, argv);
> +
> +	if (!sclp_facilities.has_sief2) {
> +		report_skip("SIEF2 facility unavailable");
> +		goto out;
> +	}
> +
> +	report_info("PRNG seed: 0x%lx", args.seed);
> +	prng_s = prng_init(args.seed);
> +	setup_guest();
> +	if (test_facility(7))
> +		test_stfle_format_0();

since STFLE is literally the feature you are testing, maybe you can
just skip, like you did for SIEF2?

> +out:
> +	return report_summary();
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index 3a9decc9..f2203069 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -392,3 +392,6 @@ file = sie-dat.elf
>  
>  [pv-attest]
>  file = pv-attest.elf
> +
> +[stfle-sie]
> +file = stfle-sie.elf


