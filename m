Return-Path: <kvm+bounces-29152-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AD3909A37F2
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 10:02:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE62C1C21110
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 08:02:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53FD018C902;
	Fri, 18 Oct 2024 08:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mtfGMww9"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCCB835894;
	Fri, 18 Oct 2024 08:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729238567; cv=none; b=Gh5gioO9p4ULTu6YQzHzY0r/mTdZNiy5dnthCxPRq50HPBcepK36UZ5T39ldXkvbYV66aRVY06eHb8npyCWLhF+zQabvYRMaQKslJ8pAChr0WP++0AjLTX/6e6vobNDPOCVIvdZSaRAwLerG6vR2W01rh8KPVR0ZmE1/982eY9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729238567; c=relaxed/simple;
	bh=bwYQn1esUpQ8heEWL2WKWeH7z+R0OEEUwvfi/rYm+k8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HEUvKaVeZJmeRibYJ5Kaf6mjA8oAwTwHrv4UXmLwte4kzu85uPeAJsV3WI3Rao5H0qIXreGT4Feuzsb/ZEkDTf3lSe7K8LwJHq0xwOjY7thVYtTd/y/JT5Ic0Bdqvinv4PUeFcSsngnB8n3SQfiDnjS88NBWQY9OzK7a3c1S8lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mtfGMww9; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49HJSCNO008224;
	Fri, 18 Oct 2024 08:02:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=2V2Dt1
	Dlf1IAS+LhapRN7NsWlv3c7niXz8tlhYY8Hk8=; b=mtfGMww9VmTE4jfuT18ifB
	ocZGqzUNdt5P4BRDfUC4Wj3gQgoR44Gk3f6xUXgJRfHYn8+DKKW4ZoDQ+il385r6
	la0T9C7yHsYnTz7dAHhNAVb6X+rfO2p2i2mYD4MKd0XHjua1l7ulnRZh/0c5uOb4
	StT7Hq4rnnLZ3jHVROXinbYVTsbfuoYHpHelUeX46xMDSj9JImnYRcdMwHjG3JfA
	cX21i7XrbUvegUOlQxAZ+nUMd6nX0ruEEAmB3xJ9buqqfmL6Qupy7LCqdIQ4egQR
	rTuC6jSnhJ/AifAusMuImO5AsEbiiDWhIWUYxWtYw67N0dVsci8flUyquB+tirlQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42as8a75st-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 18 Oct 2024 08:02:43 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49I82goL010512;
	Fri, 18 Oct 2024 08:02:42 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42as8a75ss-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 18 Oct 2024 08:02:42 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49I61T4G006338;
	Fri, 18 Oct 2024 08:02:42 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 428651awsr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 18 Oct 2024 08:02:41 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49I82cLY54788552
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 18 Oct 2024 08:02:38 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0A5FC20040;
	Fri, 18 Oct 2024 08:02:38 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 975B32004B;
	Fri, 18 Oct 2024 08:02:37 +0000 (GMT)
Received: from [9.171.57.243] (unknown [9.171.57.243])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 18 Oct 2024 08:02:37 +0000 (GMT)
Message-ID: <e649996c-559f-425e-833f-ca83bad59372@linux.ibm.com>
Date: Fri, 18 Oct 2024 10:02:37 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v4 4/6] s390x: Add library functions for
 exiting from snippet
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?Q?Nico_B=C3=B6hr?= <nrb@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>, linux-s390@vger.kernel.org
References: <20241016180320.686132-1-nsg@linux.ibm.com>
 <20241016180320.686132-5-nsg@linux.ibm.com>
Content-Language: en-US
From: Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; keydata=
 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
In-Reply-To: <20241016180320.686132-5-nsg@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2jCV0m0r3GiugI0AJCXqOvxwH3vo-kTo
X-Proofpoint-ORIG-GUID: 9F0s9TbjuA2v7CUcA6VhLBGg1LdQ8WJ2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=900 phishscore=0
 adultscore=0 impostorscore=0 priorityscore=1501 spamscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410180048

On 10/16/24 8:03 PM, Nina Schoetterl-Glausch wrote:
> It is useful to be able to force an exit to the host from the snippet,
> as well as do so while returning a value.
> Add this functionality, also add helper functions for the host to check
> for an exit and get or check the value.
> Use diag 0x44 and 0x9c for this.
> Add a guest specific snippet header file and rename snippet.h to reflect
> that it is host specific.
> 
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> ---
>   s390x/Makefile                    |  4 ++-
>   lib/s390x/asm/arch_def.h          | 13 +++++++++
>   lib/s390x/snippet-exit.h          | 47 +++++++++++++++++++++++++++++++
>   s390x/snippets/lib/snippet-exit.h | 28 ++++++++++++++++++
>   4 files changed, 91 insertions(+), 1 deletion(-)
>   create mode 100644 lib/s390x/snippet-exit.h
>   create mode 100644 s390x/snippets/lib/snippet-exit.h
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 0ad8d021..1caf221d 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -70,7 +70,8 @@ test_cases: $(tests)
>   test_cases_binary: $(tests_binary)
>   test_cases_pv: $(tests_pv_binary)
>   
> -INCLUDE_PATHS = $(SRCDIR)/lib $(SRCDIR)/lib/s390x $(SRCDIR)/s390x
> +SNIPPET_INCLUDE :=
> +INCLUDE_PATHS = $(SNIPPET_INCLUDE) $(SRCDIR)/lib $(SRCDIR)/lib/s390x $(SRCDIR)/s390x
>   # Include generated header files (e.g. in case of out-of-source builds)
>   INCLUDE_PATHS += lib
>   CPPFLAGS = $(addprefix -I,$(INCLUDE_PATHS))
> @@ -151,6 +152,7 @@ endif
>   $(SNIPPET_DIR)/asm/%.o: $(SNIPPET_DIR)/asm/%.S $(asm-offsets)
>   	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
>   
> +$(SNIPPET_DIR)/c/%.o: SNIPPET_INCLUDE := $(SNIPPET_DIR)/lib
>   $(SNIPPET_DIR)/c/%.o: $(SNIPPET_DIR)/c/%.c $(asm-offsets)
>   	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
>   
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 745a3387..db04deca 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -504,4 +504,17 @@ static inline uint32_t get_prefix(void)
>   	return current_prefix;
>   }
>   
> +static inline void diag44(void)
> +{
> +	asm volatile("diag	0,0,0x44\n");
> +}
> +
> +static inline void diag9c(uint64_t val)
> +{
> +	asm volatile("diag	%[val],0,0x9c\n"
> +		:
> +		: [val] "d"(val)
> +	);
> +}
> +
>   #endif
> diff --git a/lib/s390x/snippet-exit.h b/lib/s390x/snippet-exit.h
> new file mode 100644
> index 00000000..f62f0068
> --- /dev/null
> +++ b/lib/s390x/snippet-exit.h
> @@ -0,0 +1,47 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Functionality handling snippet exits
> + *
> + * Copyright IBM Corp. 2024
> + */
> +
> +#ifndef _S390X_SNIPPET_EXIT_H_
> +#define _S390X_SNIPPET_EXIT_H_
> +
> +#include <libcflat.h>
> +#include <sie.h>
> +#include <sie-icpt.h>
> +
> +static inline bool snippet_is_force_exit(struct vm *vm)
> +{
> +	return sie_is_diag_icpt(vm, 0x44);
> +}
> +
> +static inline bool snippet_is_force_exit_value(struct vm *vm)
> +{
> +	return sie_is_diag_icpt(vm, 0x9c);
> +}
> +
> +static inline uint64_t snippet_get_force_exit_value(struct vm *vm)
> +{
> +	struct kvm_s390_sie_block *sblk = vm->sblk;
> +
> +	assert(snippet_is_force_exit_value(vm));
> +
> +	return vm->save_area.guest.grs[sblk_ip_as_diag(sblk).r_1];
> +}

The cpu address parameter for 9C is 16 bit.
While we could make it 64 bit for snippets I don't see a reason to do 
so. The 16 bits are enough to indicate something to the host which can 
then go and fetch memory for more data.

