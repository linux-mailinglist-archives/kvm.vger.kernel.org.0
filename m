Return-Path: <kvm+bounces-20138-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 238A1910E14
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 19:07:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DD1D2B27C82
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 17:07:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81AE21B3F35;
	Thu, 20 Jun 2024 17:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BVkJ2TPU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94BFA1B3F15;
	Thu, 20 Jun 2024 17:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718903197; cv=none; b=sksZpgZLfxzH2ox4YcC00M7bUuNU+EXHcVo+C450sJ7zcV+LDmPKhMi+UXnI0+brRxU6z6sdqK3VZZkNH/ZV2J5EjYv7RyAXf5NyNepDtwmLoTVf76SXLDck3oyQXGT/WbnmK2OVzA2uX2Tf2PyIeYiGl+Fj1jeOjCg1FLzUJdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718903197; c=relaxed/simple;
	bh=Xf18Jv73Y28vcTs895ONA5mWB+QjOges/jpHMwKYY5c=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lPjxhJJCmu6KfmazWMAMcNCDZT9SoMEVsYH7Sq8oagVm9BTpvHaXoEaTkH4zqwPIcqdB1OeXEZMKdU9OrGQhhza4zjCqTki28RfHdBBIC9poHB+m0uuvxoX9uGJFvKplI1Fj/Xa1nY+sXTddgEjVcnrQuYiu0/ECt1uxhv6Db4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BVkJ2TPU; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45KG9g3F002419;
	Thu, 20 Jun 2024 17:06:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=pp1; bh=
	8RjvPvxVhIyhfOwlsHrkScS8CSZP0osjcbP3x9RN0Ew=; b=BVkJ2TPUlL52Ro0J
	iz1P5k8z5uM0unHBKY5mxvlctfwFOQrDc0VNCxnD5po6KUfJS8obgeJP/6558lcD
	H/GF2vVh0fQBbkG7Ip58fNNCD1wolun3GRyEsLpDH6KDqC31a/bGstMEOTKHZ+ud
	zUm5aHBPK6QsY2blLNZb9+Glp1dK7ZP0gPWcSKh0av1FJlPUNs6zL4WRkiVFemDL
	3ruZUEQv2Dfk0oyd47ZZmsn+gGlikmf34FTMXcRT11/lqDZpkL5vkE26+ocaVWb4
	K/4gdZKGfpn9aaYizibty8JLu3ZIoCUmhsYgAXVPYQrpkFtVizryT5QYzvtKEbO8
	+xI//A==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yvndu8jsh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 17:06:27 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45KH3meK026474;
	Thu, 20 Jun 2024 17:06:26 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yvndu8jse-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 17:06:26 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45KGLI5S009457;
	Thu, 20 Jun 2024 17:06:26 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3ysqgn7xf0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 17:06:25 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45KH6K4Q51642698
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 17:06:22 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5402420040;
	Thu, 20 Jun 2024 17:06:20 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AD31F2004D;
	Thu, 20 Jun 2024 17:06:19 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.47.175])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 20 Jun 2024 17:06:19 +0000 (GMT)
Date: Thu, 20 Jun 2024 18:56:55 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>,
        Nico =?UTF-8?B?QsO2aHI=?=
 <nrb@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, Andrew Jones
 <andrew.jones@linux.dev>,
        kvm@vger.kernel.org, Nicholas Piggin
 <npiggin@gmail.com>,
        linux-s390@vger.kernel.org, David Hildenbrand
 <david@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v3 6/7] s390x: Use library functions for
 snippet exit
Message-ID: <20240620185655.7f2a7fc8@p-imbrenda>
In-Reply-To: <20240620141700.4124157-7-nsg@linux.ibm.com>
References: <20240620141700.4124157-1-nsg@linux.ibm.com>
	<20240620141700.4124157-7-nsg@linux.ibm.com>
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
X-Proofpoint-GUID: RrTzf5E4fHcUr6PWbhVi83i-vSXlLjK8
X-Proofpoint-ORIG-GUID: U0TzYw8wuGSAzOekqsNzZ0gnSGr8yBB-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-20_08,2024-06-20_04,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 mlxscore=0 lowpriorityscore=0 mlxlogscore=999 clxscore=1011 bulkscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406200122

On Thu, 20 Jun 2024 16:16:59 +0200
Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:

> Replace the existing code for exiting from snippets with the newly
> introduced library functionality.
> 
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/sie-dat.c            | 11 +++--------
>  s390x/snippets/c/sie-dat.c | 19 +------------------
>  2 files changed, 4 insertions(+), 26 deletions(-)
> 
> diff --git a/s390x/sie-dat.c b/s390x/sie-dat.c
> index 9e60f26e..c8f38220 100644
> --- a/s390x/sie-dat.c
> +++ b/s390x/sie-dat.c
> @@ -27,23 +27,18 @@ static void test_sie_dat(void)
>  	uint64_t test_page_gpa, test_page_hpa;
>  	uint8_t *test_page_hva, expected_val;
>  	bool contents_match;
> -	uint8_t r1;
>  
>  	/* guest will tell us the guest physical address of the test buffer */
>  	sie(&vm);
> -	assert(vm.sblk->icptcode == ICPT_INST &&
> -	       (vm.sblk->ipa & 0xff00) == 0x8300 && vm.sblk->ipb == 0x9c0000);
> -
> -	r1 = (vm.sblk->ipa & 0xf0) >> 4;
> -	test_page_gpa = vm.save_area.guest.grs[r1];
> +	assert(snippet_is_force_exit_value(&vm));
> +	test_page_gpa = snippet_get_force_exit_value(&vm);
>  	test_page_hpa = virt_to_pte_phys(guest_root, (void*)test_page_gpa);
>  	test_page_hva = __va(test_page_hpa);
>  	report_info("test buffer gpa=0x%lx hva=%p", test_page_gpa, test_page_hva);
>  
>  	/* guest will now write to the test buffer and we verify the contents */
>  	sie(&vm);
> -	assert(vm.sblk->icptcode == ICPT_INST &&
> -	       vm.sblk->ipa == 0x8300 && vm.sblk->ipb == 0x440000);
> +	assert(snippet_is_force_exit(&vm));
>  
>  	contents_match = true;
>  	for (unsigned int i = 0; i < GUEST_TEST_PAGE_COUNT; i++) {
> diff --git a/s390x/snippets/c/sie-dat.c b/s390x/snippets/c/sie-dat.c
> index 9d89801d..26f045b1 100644
> --- a/s390x/snippets/c/sie-dat.c
> +++ b/s390x/snippets/c/sie-dat.c
> @@ -10,28 +10,11 @@
>  #include <libcflat.h>
>  #include <asm-generic/page.h>
>  #include <asm/mem.h>
> +#include <snippet-guest.h>
>  #include "sie-dat.h"
>  
>  static uint8_t test_pages[GUEST_TEST_PAGE_COUNT * PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
>  
> -static inline void force_exit(void)
> -{
> -	asm volatile("diag	0,0,0x44\n"
> -		     :
> -		     :
> -		     : "memory"
> -	);
> -}
> -
> -static inline void force_exit_value(uint64_t val)
> -{
> -	asm volatile("diag	%[val],0,0x9c\n"
> -		     :
> -		     : [val] "d"(val)
> -		     : "memory"
> -	);
> -}
> -
>  int main(void)
>  {
>  	uint8_t *invalid_ptr;


