Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2CE841453B
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 11:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234376AbhIVJhK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 05:37:10 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:17580 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234274AbhIVJhK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 05:37:10 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M9M7Kj022231;
        Wed, 22 Sep 2021 05:35:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=2vpuS6qasgEDTZFxLoquGr4l2Oj2SS9ap6N41OrbVmM=;
 b=JHSqT4bfxBe5QYqDhF09gQuQ8hN4OiUCvnkjjGyA0fXh4yoFOvqG00WVT3COTbe+fgco
 Fmtwzi8nR/+dvyUgR57SmTyDJYzWhDX0eQniQ20s2sPqqgO9nzqcYAAsIZEqZjULW3SA
 BVGUDLvWd2DddtzQnyfnuXUESfGZsdw0khy4xAZiq4tvBtX7IRxN5n+d166YL3MrlmxH
 ttV0SVEoJ3/LmWNRGkWYoCLdsvOBB/SCsujTChJm59T5wuMJzSZAL4mrgIboITs4n0JT
 w9kwEl/vEbOanAhXbZZgFNN6zsNhyM027TeNuGQduJw7wsvMXPKgF0Ku0lIxHH+FNToo uQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b7yqjk5pm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 05:35:39 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18M8t0H5028503;
        Wed, 22 Sep 2021 05:35:39 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b7yqjk5np-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 05:35:39 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18M9YcsR005503;
        Wed, 22 Sep 2021 09:35:37 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 3b7q69vn2e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 09:35:37 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18M9ZX0X49807630
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 09:35:33 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CDEE0AE057;
        Wed, 22 Sep 2021 09:35:33 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8EF08AE059;
        Wed, 22 Sep 2021 09:35:33 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.3.24])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 22 Sep 2021 09:35:33 +0000 (GMT)
Date:   Wed, 22 Sep 2021 11:16:41 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        linux-s390@vger.kernel.org, seiden@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 2/9] s390x: pfmf: Fix 1MB handling
Message-ID: <20210922111641.23a957ac@p-imbrenda>
In-Reply-To: <20210922071811.1913-3-frankja@linux.ibm.com>
References: <20210922071811.1913-1-frankja@linux.ibm.com>
        <20210922071811.1913-3-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -ZUhIQ0KJ4eLqcS9EMicezfF2bXmQuUB
X-Proofpoint-ORIG-GUID: 0s_aCvWNhU0iaBKP3lawIoxOvcHIbqDz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-22_03,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 clxscore=1015
 adultscore=0 impostorscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109200000 definitions=main-2109220066
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 22 Sep 2021 07:18:04 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> On everything larger than 4k pfmf will update the address in GR2 when
> it's interrupted so we should loop on pfmf and not trust that it
> doesn't get interrupted.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/pfmf.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/s390x/pfmf.c b/s390x/pfmf.c
> index 2f3cb110..b0095bd7 100644
> --- a/s390x/pfmf.c
> +++ b/s390x/pfmf.c
> @@ -54,6 +54,7 @@ static void test_1m_key(void)
>  	bool rp = true;
>  	union pfmf_r1 r1;
>  	union skey skey;
> +	void *addr = pagebuf;
>  
>  	report_prefix_push("1M");
>  	if (test_facility(169)) {
> @@ -64,7 +65,9 @@ static void test_1m_key(void)
>  	r1.reg.sk = 1;
>  	r1.reg.fsc = PFMF_FSC_1M;
>  	r1.reg.key = 0x30;
> -	pfmf(r1.val, pagebuf);
> +	do {
> +		addr = pfmf(r1.val, addr);
> +	} while ((uintptr_t)addr != (uintptr_t)pagebuf + HPAGE_SIZE);
>  	for (i = 0; i < 256; i++) {
>  		skey.val = get_storage_key(pagebuf + i * PAGE_SIZE);
>  		skey.val &= SKEY_ACC | SKEY_FP;
> @@ -99,6 +102,7 @@ static void test_1m_clear(void)
>  	int i;
>  	union pfmf_r1 r1;
>  	unsigned long sum = 0;
> +	void *addr = pagebuf;
>  
>  	r1.val = 0;
>  	r1.reg.cf = 1;
> @@ -106,7 +110,9 @@ static void test_1m_clear(void)
>  
>  	report_prefix_push("1M");
>  	memset(pagebuf, 42, PAGE_SIZE * 256);
> -	pfmf(r1.val, pagebuf);
> +	do {
> +		addr = pfmf(r1.val, addr);
> +	} while ((uintptr_t)addr != (uintptr_t)pagebuf + HPAGE_SIZE);
>  	for (i = 0; i < PAGE_SIZE * 256; i++)
>  		sum |= pagebuf[i];
>  	report(!sum, "clear memory");

