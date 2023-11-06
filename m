Return-Path: <kvm+bounces-805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 435767E2A7D
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 17:56:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BFF2FB210E1
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 16:56:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01F6E29CE8;
	Mon,  6 Nov 2023 16:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kv2CUlIz"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF961D69B
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 16:56:33 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA19D4C;
	Mon,  6 Nov 2023 08:56:32 -0800 (PST)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6Gp6o6012105;
	Mon, 6 Nov 2023 16:56:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=CNT+Vr9K0YfgFEh/YXcW2me0ooG6vaHyWBsn8gl/sl4=;
 b=kv2CUlIzrB3B6/QjeJt9Dsv+JDB4nDXzrHx/HnYBZACIH+fvfuSINSRPgKePWsuJbCIO
 hwWI4fmu4HdoyNuk3A7q7fRnohUOapmPV9hcGbZrd1h0R7nDDyw+uumj0PJ61qSf+fJg
 5Tz3YoUmDWZZRttZM+ANkQqt/2qwsQYHGB3XUPeMPbYnlJL6utX205wk9ORr95cojWN3
 rgQj0K7RUAmnAj3ww9YALDKfTmocanwVEU+fTsVoBjQn+zXwb3zrW01BQ9Mt5IqGxbVT
 1d3DX8V0orQuHNRUIDM4P1Hr3ZLv+vPPSAZSCIh2jg9fUTrLOx/0puTQ5E1gohww/kJo kw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u722pm6hh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 16:56:29 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A6GtUBK028564;
	Mon, 6 Nov 2023 16:56:29 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u722pm6gv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 16:56:29 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6Go3Lg008058;
	Mon, 6 Nov 2023 16:56:27 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u61skak74-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 16:56:27 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A6GuOdf41943722
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Nov 2023 16:56:24 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6137120043;
	Mon,  6 Nov 2023 16:56:24 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2558920040;
	Mon,  6 Nov 2023 16:56:24 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 Nov 2023 16:56:24 +0000 (GMT)
Date: Mon, 6 Nov 2023 17:53:16 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Nico Boehr <nrb@linux.ibm.com>
Cc: frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        pbonzini@redhat.com, andrew.jones@linux.dev, lvivier@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1 02/10] powerpc: properly format
 non-kernel-doc comments
Message-ID: <20231106175316.1f05d090@p-imbrenda>
In-Reply-To: <20231106125352.859992-3-nrb@linux.ibm.com>
References: <20231106125352.859992-1-nrb@linux.ibm.com>
	<20231106125352.859992-3-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xB7rccrWArDvCmLCM4SF68cMbrNLUY8r
X-Proofpoint-GUID: lq0M-EJWt8Vt9F98glTArm70olJOCsbY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_12,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 priorityscore=1501 bulkscore=0
 mlxscore=0 impostorscore=0 clxscore=1011 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311060137

On Mon,  6 Nov 2023 13:50:58 +0100
Nico Boehr <nrb@linux.ibm.com> wrote:

> These comments do not follow the kernel-doc style, hence they should not
> start with /**.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>  powerpc/emulator.c    | 2 +-
>  powerpc/spapr_hcall.c | 6 +++---
>  powerpc/spapr_vpa.c   | 4 ++--
>  3 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/powerpc/emulator.c b/powerpc/emulator.c
> index 65ae4b65e655..39dd59645368 100644
> --- a/powerpc/emulator.c
> +++ b/powerpc/emulator.c
> @@ -71,7 +71,7 @@ static void test_64bit(void)
>  	report_prefix_pop();
>  }
>  
> -/**
> +/*
>   * Test 'Load String Word Immediate' instruction
>   */

this should have the name of the function first: 
 * test_lswi() - Test 'Load String ... 

(same for all the other functions here)

>  static void test_lswi(void)
> diff --git a/powerpc/spapr_hcall.c b/powerpc/spapr_hcall.c
> index 0d0f25afe9f6..e9b5300a3912 100644
> --- a/powerpc/spapr_hcall.c
> +++ b/powerpc/spapr_hcall.c
> @@ -16,7 +16,7 @@
>  #define H_ZERO_PAGE	(1UL << (63-48))
>  #define H_COPY_PAGE	(1UL << (63-49))
>  
> -/**
> +/*
>   * Test the H_SET_SPRG0 h-call by setting some values and checking whether
>   * the SPRG0 register contains the correct values afterwards
>   */
> @@ -46,7 +46,7 @@ static void test_h_set_sprg0(int argc, char **argv)
>  	       sprg0_orig);
>  }
>  
> -/**
> +/*
>   * Test the H_PAGE_INIT h-call by using it to clear and to copy a page, and
>   * by checking for the correct values in the destination page afterwards
>   */
> @@ -97,7 +97,7 @@ static int h_random(uint64_t *val)
>  	return r3;
>  }
>  
> -/**
> +/*
>   * Test H_RANDOM by calling it a couple of times to check whether all bit
>   * positions really toggle (there should be no "stuck" bits in the output)
>   */
> diff --git a/powerpc/spapr_vpa.c b/powerpc/spapr_vpa.c
> index 5586eb8d3341..6a3fe5e3f974 100644
> --- a/powerpc/spapr_vpa.c
> +++ b/powerpc/spapr_vpa.c
> @@ -53,7 +53,7 @@ static void print_vpa(struct vpa *vpa)
>  #define SUBFUNC_REGISTER	(1ULL << 45)
>  #define SUBFUNC_DEREGISTER	(5ULL << 45)
>  
> -/**
> +/*
>   * Test the H_REGISTER_VPA h-call register/deregister calls.
>   */
>  static void test_register_vpa(void)
> @@ -111,7 +111,7 @@ static void test_register_vpa(void)
>  	report_prefix_pop();
>  }
>  
> -/**
> +/*
>   * Test some VPA fields.
>   */
>  static void test_vpa(void)


