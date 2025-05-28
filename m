Return-Path: <kvm+bounces-47863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 98F61AC6627
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 11:41:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 54F1A4E3A7E
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 09:41:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 952AB27814C;
	Wed, 28 May 2025 09:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JwzVyahw"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3BA262A6;
	Wed, 28 May 2025 09:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748425275; cv=none; b=iyGWruP3V23v6Cxm2fXK3Yps4AiQjuuzEl/SgHfE+c+50Kek9ydRM/m/W0MzYsSUTkbK5F1kNaOheu4u81GHPJa31v+Q+T8+6DLlkroqmkR8vxyh8A/e9vYqDqes1fFWfWJnGipuMgICIJN+Op1GvzAc7tJdQZPSHh5xqd2lYYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748425275; c=relaxed/simple;
	bh=frU0VJnFQ1hQJ/e1YLj/0Mra1wH364PuW5+ms1OYF6U=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eAI132lM6koprAKA31W0VCgYXYhdSom9Viylla8ycpEYJ4lbq3BpofUWBmI9euip9JoiT/wFgFDoRJW/+nu6HjSWBll9yPiru57+r7aB0CKuC8EcCNU4k1YICXaPvtxZoUpvrqu5OJ0CDz2dba34j0zJFKble0q3qT/icC8LWtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JwzVyahw; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54S5aR47009525;
	Wed, 28 May 2025 09:41:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=YZGGnS
	RrnOwOPOod2UPYmn6VdOnOiBdjCYnxBygI+SA=; b=JwzVyahwwGj3+qgRpkyavS
	ST4wZe7C2oM9mW2Db6vQrrdqEb2ss8XD1axWcpTC45+JySvpn/gBcQNd/I3rljO5
	0JVUq7zofC5oJ1CoksNYag81akzqV7k/yPUC+WEfBzFLOf7stGyQGi83A81fwkjC
	tw3ArQBVFm2P0/YpKx13czh3YU4Yn1Zlr7eZQCs4cIVK3haxIJenRYdlV5dsyuSt
	6Gc0FUTtDce+4fZKnd7UB9E3Hvs8OwIuQ2v5SaJm+vAdLOA3gw+NRQg1naFXkzQx
	ESuv9G6yUSZwRoJ84Efc3FBPIccRnt1IncMl1YFScf7+h8QkO1yyKJ59e99OyWBg
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46wvfb127a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 May 2025 09:41:11 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54S6FGlp021349;
	Wed, 28 May 2025 09:41:10 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 46utnmppmv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 May 2025 09:41:10 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54S9f6nE55116166
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 May 2025 09:41:06 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 857FF20049;
	Wed, 28 May 2025 09:41:06 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D956520040;
	Wed, 28 May 2025 09:41:05 +0000 (GMT)
Received: from p-imbrenda (unknown [9.111.56.81])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed, 28 May 2025 09:41:05 +0000 (GMT)
Date: Wed, 28 May 2025 11:41:02 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, nrb@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 1/2] s390x: diag10: Fence tcg and pv
 environments
Message-ID: <20250528114102.569905dd@p-imbrenda>
In-Reply-To: <20250528091412.19483-2-frankja@linux.ibm.com>
References: <20250528091412.19483-1-frankja@linux.ibm.com>
	<20250528091412.19483-2-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTI4MDA4MiBTYWx0ZWRfXxlrUtHUn3OQE inHhAIxh8EeHKER4uiKIGmMB9VBWQsAwboAcqGHW59sWYGjecRMIL5y32rd7eBF5oFYNRrfgSxl pqe/dVeUpiwdltdPE7z85L43iDfpLisiQBif+ZVefTH8OKhNAF5CxJGzwRASY+qhhNoEYPRVOXR
 /cud2jE3CBjkgi7RN9/+pen9KPlbr0N8ZtDm8C3oRuZPKeuN5RziHqpwbCG1IwCPhPHJMIP3oSK 8B2xx0oNd513xS4GlaLTkJOK7LiZscqJLij+jyEvdz+CDVh8JAMh1k1DZh2i1/E5inXR7jkv2fQ THV3g1mV4VdeWryN0Yc8p6e98jpjdFR1cSEFtU6V94edLiK00KaZllzZBjow1naUJsg1bk6kUvl
 /tylQuDMJZ+KfNrk693jby5sYnBqu37HCX60UHZdE+oqB4WT7hedkC7y8UwBfHJnjD0Gv2kU
X-Proofpoint-ORIG-GUID: tAIb1CI3yxfx3LgYEB7AsKuDlYAFYyvQ
X-Authority-Analysis: v=2.4 cv=bt5MBFai c=1 sm=1 tr=0 ts=6836da37 cx=c_pps a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=3KsXPZ-zxchA8CwBTVIA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: tAIb1CI3yxfx3LgYEB7AsKuDlYAFYyvQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-28_05,2025-05-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 malwarescore=0 bulkscore=0 spamscore=0 lowpriorityscore=0
 suspectscore=0 adultscore=0 priorityscore=1501 phishscore=0 mlxscore=0
 clxscore=1015 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505280082

On Wed, 28 May 2025 09:13:49 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Diag10 isn't supported under either of these environments so let's
> make sure that the test bails out accordingly.

does KVM always implement diag10?

is there no other way to check whether diag10 is available?

we could, for example, try to run it "correctly" and see whether we get
a Specification exception, and then fence.

> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/diag10.c      | 15 +++++++++++++++
>  s390x/unittests.cfg |  1 +
>  2 files changed, 16 insertions(+)
> 
> diff --git a/s390x/diag10.c b/s390x/diag10.c
> index 579a7a5d..00725f58 100644
> --- a/s390x/diag10.c
> +++ b/s390x/diag10.c
> @@ -9,6 +9,8 @@
>   */
>  
>  #include <libcflat.h>
> +#include <uv.h>
> +#include <hardware.h>
>  #include <asm/asm-offsets.h>
>  #include <asm/interrupt.h>
>  #include <asm/page.h>
> @@ -95,8 +97,21 @@ static void test_priv(void)
>  int main(void)
>  {
>  	report_prefix_push("diag10");
> +
> +	if (host_is_tcg()) {
> +		report_skip("Test unsupported under TCG");
> +		goto out;
> +	}
> +	if (uv_os_is_guest()) {
> +		report_skip("Test unsupported under PV");
> +		goto out;
> +	}
> +
>  	test_prefix();
>  	test_params();
>  	test_priv();
> +
> +out:
> +	report_prefix_pop();
>  	return report_summary();
>  }
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index a9af6680..9c43ab2f 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -51,6 +51,7 @@ extra_params = -device virtio-net-ccw
>  
>  [diag10]
>  file = diag10.elf
> +accel = kvm
>  
>  [diag308]
>  file = diag308.elf


