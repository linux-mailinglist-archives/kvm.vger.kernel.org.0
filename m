Return-Path: <kvm+bounces-29964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16CA09B4FF6
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 17:59:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB06C283253
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 16:59:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACEE61DA617;
	Tue, 29 Oct 2024 16:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SwzF4HOj"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84EA1D7989
	for <kvm@vger.kernel.org>; Tue, 29 Oct 2024 16:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730221154; cv=none; b=Cy0yaOTcrdBjyI9hwF3xbaT/n/aT8XZK3IlkDT/Gp0Ysms3EM+GlldxT0kohvunBbg8buJWDoMTFhZo2FNnFYybJu8hXhubraMMeVJuduUimukgtJle8TVjRpACtP9yiyqe+lVnADIUexYMcM9GQpwIX3qYDEVyhEp07TO3IAOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730221154; c=relaxed/simple;
	bh=qve4Uj21cHwTFynHyGZzk+eztrJ1eAD73FPERwjdao8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B2LnIJBv3aAPgffI3JJRYV2jvux9dBbIxPcqKr6C/STBxDKg/Qv9qpuvtOJPQ8cBpAuaBK1YfNe4P3x/V4in2rbBDimSWa5T1rfGp0QXsVWNoiYjUvByOj5K64/hkMiVqAvz+yNWSPo3FDtqyv1ng1O0uaZx8FwKUKU6QKSyTSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SwzF4HOj; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49TE9riu028493;
	Tue, 29 Oct 2024 16:59:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=3wNjCE
	i7HhyX8S1Zr5PH2k90gpq+kLoTJGaD3xBTcN0=; b=SwzF4HOjb1RPd+09qxcQ99
	+PSVAc3HwP7y6LMMrrVjntm+sXHe8i8J9EGRRXBgct3kAwGVf/VbpksvbTaMp/U+
	+D71IBJoGvj0UPJUlRqgVN8DG16KiJVlM0dvjz80XcZ/pcnvVlfLM+aH0LWWwTuC
	Ul+QAcR+oA1qSLP1dvyMMTzqG7i2zvvrXfBQKUjZQfSXv7gp91f/TNqQTRmjeT/o
	4J/3VWRd8Rtol9Y71DEvEIfAktjx92cFZmQeqwLwDQM6Ih5LX/hHvT1ACxo2aE/s
	OiVT5iruOdJg4U9A4xkzLg4CHHjiXdmPKC/EZ5kfyqrE/70ovKkVYiWuN4I9iveA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42j3nst0qq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 29 Oct 2024 16:59:07 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49TGx7Mq014190;
	Tue, 29 Oct 2024 16:59:07 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42j3nst0qm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 29 Oct 2024 16:59:07 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49TF1kdP018376;
	Tue, 29 Oct 2024 16:59:06 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42hc8k3w1j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 29 Oct 2024 16:59:06 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49TGx2Ct34669052
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Oct 2024 16:59:02 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5403620043;
	Tue, 29 Oct 2024 16:59:02 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BD4B82004B;
	Tue, 29 Oct 2024 16:59:01 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.81.218])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with SMTP;
	Tue, 29 Oct 2024 16:59:01 +0000 (GMT)
Date: Tue, 29 Oct 2024 17:58:58 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, thuth@redhat.com,
        lvivier@redhat.com, frankja@linux.ibm.com, nrb@linux.ibm.com,
        npiggin@gmail.com
Subject: Re: [RFC kvm-unit-tests PATCH] lib/report: Return pass/fail result
 from report
Message-ID: <20241029175858.670ffe1c@p-imbrenda>
In-Reply-To: <20241023165347.174745-2-andrew.jones@linux.dev>
References: <20241023165347.174745-2-andrew.jones@linux.dev>
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
X-Proofpoint-ORIG-GUID: tq6lUOPsDvbriUwdfES6o_6Odyq_VWEM
X-Proofpoint-GUID: 0mZ1PJLDjNjAeTttrkV2GhYs-7QXDcu8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 clxscore=1011 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 mlxscore=0 impostorscore=0
 malwarescore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410290128

On Wed, 23 Oct 2024 18:53:48 +0200
Andrew Jones <andrew.jones@linux.dev> wrote:

> A nice pattern to use in order to try and maintain parsable reports,
> but also output unexpected values, is
> 
>     if (!report(value == expected_value, "my test")) {
>         report_info("failure due to unexpected value (received %d, expected %d)",
>                     value, expected_value);
>     }

it would be cool if we could somehow do this with just one function
call or macro, but I can't really think of a reasonable way to do it.

this patch is a good step in that direction, though

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>  lib/libcflat.h |  6 +++---
>  lib/report.c   | 28 +++++++++++++++++++++-------
>  2 files changed, 24 insertions(+), 10 deletions(-)
> 
> diff --git a/lib/libcflat.h b/lib/libcflat.h
> index eec34c3f2710..b4110b9ec91b 100644
> --- a/lib/libcflat.h
> +++ b/lib/libcflat.h
> @@ -97,11 +97,11 @@ void report_prefix_pushf(const char *prefix_fmt, ...)
>  extern void report_prefix_push(const char *prefix);
>  extern void report_prefix_pop(void);
>  extern void report_prefix_popn(int n);
> -extern void report(bool pass, const char *msg_fmt, ...)
> +extern bool report(bool pass, const char *msg_fmt, ...)
>  		__attribute__((format(printf, 2, 3), nonnull(2)));
> -extern void report_xfail(bool xfail, bool pass, const char *msg_fmt, ...)
> +extern bool report_xfail(bool xfail, bool pass, const char *msg_fmt, ...)
>  		__attribute__((format(printf, 3, 4), nonnull(3)));
> -extern void report_kfail(bool kfail, bool pass, const char *msg_fmt, ...)
> +extern bool report_kfail(bool kfail, bool pass, const char *msg_fmt, ...)
>  		__attribute__((format(printf, 3, 4), nonnull(3)));
>  extern void report_abort(const char *msg_fmt, ...)
>  					__attribute__((format(printf, 1, 2)))
> diff --git a/lib/report.c b/lib/report.c
> index 0756e64e6f10..43c0102c1b0e 100644
> --- a/lib/report.c
> +++ b/lib/report.c
> @@ -89,7 +89,7 @@ void report_prefix_popn(int n)
>  	spin_unlock(&lock);
>  }
>  
> -static void va_report(const char *msg_fmt,
> +static bool va_report(const char *msg_fmt,
>  		bool pass, bool xfail, bool kfail, bool skip, va_list va)
>  {
>  	const char *prefix = skip ? "SKIP"
> @@ -114,14 +114,20 @@ static void va_report(const char *msg_fmt,
>  		failures++;
>  
>  	spin_unlock(&lock);
> +
> +	return pass || xfail;
>  }
>  
> -void report(bool pass, const char *msg_fmt, ...)
> +bool report(bool pass, const char *msg_fmt, ...)
>  {
>  	va_list va;
> +	bool ret;
> +
>  	va_start(va, msg_fmt);
> -	va_report(msg_fmt, pass, false, false, false, va);
> +	ret = va_report(msg_fmt, pass, false, false, false, va);
>  	va_end(va);
> +
> +	return ret;
>  }
>  
>  void report_pass(const char *msg_fmt, ...)
> @@ -142,24 +148,32 @@ void report_fail(const char *msg_fmt, ...)
>  	va_end(va);
>  }
>  
> -void report_xfail(bool xfail, bool pass, const char *msg_fmt, ...)
> +bool report_xfail(bool xfail, bool pass, const char *msg_fmt, ...)
>  {
> +	bool ret;
> +
>  	va_list va;
>  	va_start(va, msg_fmt);
> -	va_report(msg_fmt, pass, xfail, false, false, va);
> +	ret = va_report(msg_fmt, pass, xfail, false, false, va);
>  	va_end(va);
> +
> +	return ret;
>  }
>  
>  /*
>   * kfail is known failure. If kfail is true then test will succeed
>   * regardless of pass.
>   */
> -void report_kfail(bool kfail, bool pass, const char *msg_fmt, ...)
> +bool report_kfail(bool kfail, bool pass, const char *msg_fmt, ...)
>  {
> +	bool ret;
> +
>  	va_list va;
>  	va_start(va, msg_fmt);
> -	va_report(msg_fmt, pass, false, kfail, false, va);
> +	ret = va_report(msg_fmt, pass, false, kfail, false, va);
>  	va_end(va);
> +
> +	return ret;
>  }
>  
>  void report_skip(const char *msg_fmt, ...)


