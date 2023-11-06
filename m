Return-Path: <kvm+bounces-645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D67BF7E1E82
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:39:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6280B28143F
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 10:39:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8807216432;
	Mon,  6 Nov 2023 10:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ODc9xKNa"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D407AD309
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 10:39:20 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9730099;
	Mon,  6 Nov 2023 02:39:19 -0800 (PST)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6AcUpW006046;
	Mon, 6 Nov 2023 10:39:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=FyYhnCQX0/mkLRw4SvFMTHId7kp04ekG4wxKT096Q2E=;
 b=ODc9xKNaqHw+RJtEVKbz9PTlH58MtY8UcmOf/QMO5W7kN5A8RTNt4C1ClQumZfLCIwfw
 TvZnUdQCGFfxim1buA5/W362dNHSI+g7OIF29/WqkwmlQSofzSwyo48oIFhNJEBx0Cza
 boIv95jpD/qNHaNExobwEnk8QR8ulOiLAX9CS1bpiHCa+5oV0mCt1m3U7IxxVph2Ra7V
 jH9u4Q2+Y622MyhnnO6qzkjiOAwqQcylXIKlnNzIXmLaAKElSVzbBMFbd+W1bGN5VmSX
 X1D9Zn3Fy0gEY3xkMGVKRTU435sc5rQfFdREdxlYljNtZHy+oPazgYAoYQYlL1sCG3zo aA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u6vn5btpc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 10:39:19 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A6A892a021171;
	Mon, 6 Nov 2023 10:39:18 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u6vn5btnn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 10:39:18 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A67upoP007961;
	Mon, 6 Nov 2023 10:39:17 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u60ny8rjy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 10:39:17 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A6AdDod45482554
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Nov 2023 10:39:14 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C0FDC20049;
	Mon,  6 Nov 2023 10:39:13 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5FD4020040;
	Mon,  6 Nov 2023 10:39:13 +0000 (GMT)
Received: from osiris (unknown [9.171.27.3])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon,  6 Nov 2023 10:39:13 +0000 (GMT)
Date: Mon, 6 Nov 2023 11:39:11 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Nico Boehr <nrb@linux.ibm.com>
Cc: frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v7 7/8] s390x: add a test for SIE without
 MSO/MSL
Message-ID: <20231106103911.12197-A-hca@linux.ibm.com>
References: <20231103092954.238491-1-nrb@linux.ibm.com>
 <20231103092954.238491-8-nrb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231103092954.238491-8-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FjYw6_VcYgg_jh7nXij9e0_yJpTmHOsr
X-Proofpoint-ORIG-GUID: ReELNCscz8NeA84MZ5mdz2ZiwzfkeYMY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_09,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 adultscore=0 spamscore=0 phishscore=0 mlxlogscore=552
 malwarescore=0 suspectscore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311060088

On Fri, Nov 03, 2023 at 10:29:36AM +0100, Nico Boehr wrote:
> Since we now have the ability to run guests without MSO/MSL, add a test
> to make sure this doesn't break.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> ---
>  s390x/Makefile             |   2 +
>  s390x/sie-dat.c            | 110 +++++++++++++++++++++++++++++++++++++
>  s390x/snippets/c/sie-dat.c |  52 ++++++++++++++++++
>  s390x/snippets/c/sie-dat.h |   2 +
>  s390x/unittests.cfg        |   3 +
>  5 files changed, 169 insertions(+)
>  create mode 100644 s390x/sie-dat.c
>  create mode 100644 s390x/snippets/c/sie-dat.c
>  create mode 100644 s390x/snippets/c/sie-dat.h
...
> +static uint8_t test_page[GUEST_TEST_PAGE_COUNT * PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
> +
> +static inline void force_exit(void)
> +{
> +	asm volatile("diag	0,0,0x44\n");
> +}
> +
> +static inline void force_exit_value(uint64_t val)
> +{
> +	asm volatile(
> +		"diag	%[val],0,0x9c\n"
> +		: : [val] "d"(val)
> +	);
> +}
> +
> +int main(void)
> +{
> +	uint8_t *invalid_ptr;
> +
> +	memset(test_page, 0, sizeof(test_page));
> +	/* tell the host the page's physical address (we're running DAT off) */
> +	force_exit_value((uint64_t)test_page);
> +
> +	/* write some value to the page so the host can verify it */
> +	for (size_t i = 0; i < GUEST_TEST_PAGE_COUNT; i++)
> +		test_page[i * PAGE_SIZE] = 42 + i;
> +
> +	/* indicate we've written all pages */
> +	force_exit();
> +
> +	/* the first unmapped address */
> +	invalid_ptr = (uint8_t *)(GUEST_TOTAL_PAGE_COUNT * PAGE_SIZE);
> +	*invalid_ptr = 42;
> +
> +	/* indicate we've written the non-allowed page (should never get here) */
> +	force_exit();
> +
> +	return 0;
> +}

The compiler will not necessarily generate the expected code here, since
there is no data dependency between the used inline assemblies and the
memory locations that are changed. That is: the compiler may move the
inline assemblies and/or memory assignments around.

In order to prevent that you could simply add a compiler barrier to both
inline assemblies (add "memory" to the clobber list).

