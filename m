Return-Path: <kvm+bounces-4363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A06CF811A45
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 18:00:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E8981F21C34
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 17:00:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98C0E3A8DF;
	Wed, 13 Dec 2023 17:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SvLU7m6R"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 872D0D0;
	Wed, 13 Dec 2023 09:00:46 -0800 (PST)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BDF0kfW007437;
	Wed, 13 Dec 2023 17:00:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=sID6Zen2aLoeGx9IP5NpRxYcUv+fyWUvPj+bK1tGY04=;
 b=SvLU7m6RMip5C+U5W8qztHVGDYsnQSABf0orKjsd+6KoGhT5/vIObB96SWvRDjuRjEG4
 wkIPcyv9WPphrQHoim8q+nJqz0uDBWG4J3t04j/he26hczWd7X2IIOEPbDdUPz3enHC1
 i4Q8HWherQLq5SiXOiBi5wlJzB+A58BwM4O7tdBxXEF+leGTYfNzixLkQT2WMuvh5tDq
 TWOu9uBZyQkRDXI4qApHdFZRSqlA3WvRTBajjchSMHCH0qynZlLbJV4RsWbfLKrkQf9S
 p79rQZbMiV8/3XcuIXt3kfVNlI+AWWlwPeHRRfBZ2F+qIIw2aPz19N7Y1tFKmTw+n7/s 8w== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uybw4s3dt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 17:00:43 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BDGtAfC029377;
	Wed, 13 Dec 2023 17:00:42 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uybw4s3da-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 17:00:42 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3BDGKg0Z008455;
	Wed, 13 Dec 2023 17:00:41 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3uw2jtjhu5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 17:00:41 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3BDH0d5j30736858
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Dec 2023 17:00:39 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 00ADB20043;
	Wed, 13 Dec 2023 17:00:39 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CABFD20040;
	Wed, 13 Dec 2023 17:00:38 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 13 Dec 2023 17:00:38 +0000 (GMT)
Date: Wed, 13 Dec 2023 17:45:00 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: Nico =?UTF-8?B?QsO2aHI=?= <nrb@linux.ibm.com>,
        Thomas Huth
 <thuth@redhat.com>, Janosch Frank <frankja@linux.ibm.com>,
        linux-s390@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
        David
 Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 4/5] s390x: Use library functions for
 snippet exit
Message-ID: <20231213174500.77f3d26f@p-imbrenda>
In-Reply-To: <20231213124942.604109-5-nsg@linux.ibm.com>
References: <20231213124942.604109-1-nsg@linux.ibm.com>
	<20231213124942.604109-5-nsg@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YLvs-k7-e9KKL_nedE6r4ge-k_0kJQ9B
X-Proofpoint-ORIG-GUID: BYqt4KpTMvo0UdLJNlPIfN-XX-6tY7UE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-13_10,2023-12-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 phishscore=0 spamscore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0
 impostorscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2312130121

On Wed, 13 Dec 2023 13:49:41 +0100
Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:

> Replace the existing code for exiting from snippets with the newly
> introduced library functionality.
> This causes additional report()s, otherwise no change in functionality
> intended.
> 
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> ---
>  s390x/sie-dat.c            | 10 ++--------
>  s390x/snippets/c/sie-dat.c | 19 +------------------
>  2 files changed, 3 insertions(+), 26 deletions(-)
> 
> diff --git a/s390x/sie-dat.c b/s390x/sie-dat.c
> index 9e60f26e..6b6e6868 100644
> --- a/s390x/sie-dat.c
> +++ b/s390x/sie-dat.c
> @@ -27,23 +27,17 @@ static void test_sie_dat(void)
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
> +	assert(snippet_get_force_exit_value(&vm, &test_page_gpa));

but the function inside the assert will already report a failure, right?
then why the assert? (the point I'm trying to make is that the function
should not report stuff, see my comments in the previous patch)

>  	test_page_hpa = virt_to_pte_phys(guest_root, (void*)test_page_gpa);
>  	test_page_hva = __va(test_page_hpa);
>  	report_info("test buffer gpa=0x%lx hva=%p", test_page_gpa, test_page_hva);
>  
>  	/* guest will now write to the test buffer and we verify the contents */
>  	sie(&vm);
> -	assert(vm.sblk->icptcode == ICPT_INST &&
> -	       vm.sblk->ipa == 0x8300 && vm.sblk->ipb == 0x440000);
> +	assert(snippet_check_force_exit(&vm));
>  
>  	contents_match = true;
>  	for (unsigned int i = 0; i < GUEST_TEST_PAGE_COUNT; i++) {
> diff --git a/s390x/snippets/c/sie-dat.c b/s390x/snippets/c/sie-dat.c
> index ecfcb60e..414afd42 100644
> --- a/s390x/snippets/c/sie-dat.c
> +++ b/s390x/snippets/c/sie-dat.c
> @@ -9,28 +9,11 @@
>   */
>  #include <libcflat.h>
>  #include <asm-generic/page.h>
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


