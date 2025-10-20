Return-Path: <kvm+bounces-60482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C418BEF8FB
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 09:01:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A06673BA789
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 07:01:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 403E12D97A4;
	Mon, 20 Oct 2025 07:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nA+ShIrv"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9AC21F4CBF;
	Mon, 20 Oct 2025 07:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760943680; cv=none; b=Cu7quH6S1Z281HjuG20hsuZ6hfEGlwu+6/fjPzIBtms9pirJIJTb/J9ERAjIz1p6BODiiyUNbXNe03WeOTqQXd/rQWy3Bh5PW1N280QUoy/Te0CxxUaDx8MGqt0evHdA9MUPglT/I+KxE6SMzT3VAmnEqWZzYgtGbKElBgwDguY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760943680; c=relaxed/simple;
	bh=pZSLvaztOUWZ+ruchh8tjsDH0LZl7fPFT0mhzFgwvDk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UuVRulALlUXcYWWuf5fLexpBPP0oWOWY7sNVUrD7hz/jTO6UJKDgXeeVdgH4oSZKd77PP+H66CBzqbjI67QLMHQJyTLOk0FxxCI7jlRvHTq618bc98ryRI2l0naoilVC0W+ChxxLBMN2kVUMRdwFUht9+nY8JrFSMuTt+EOR1U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nA+ShIrv; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59JNb78N018780;
	Mon, 20 Oct 2025 07:00:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=kwfWDw
	UIMVAe4scHLJbjyWgTMOyfX6Qp1FmUT2omIyw=; b=nA+ShIrvsHw0Tt2WMhgF1r
	5wX1992zHaBRK3W+GYgrGV8AGoFzgMZLUUkI+qcxquafkJdq7hyucznLBi5KDnzA
	e9VaH2eLKpl5snAwXrMZtgX/sZ5DLmx58dQixgmn0We+PjddBeh8AQHq7kJpSb7d
	N5q9sBy2gv5NlDpoUA5RFi0zJ3kEtSSKnhfTD3QQ8Od8I4jtU4/qsKxDqoRaqIdD
	/lK9xCnMVTjxZLuaePCbZu0rM6hsJsHIUPYHp6F6OUehNlumlPd35PWf3suOkh7k
	TOhXRz7TB68QPv8E5lJQ1rgd79wwUGMW2Wjc/eg43Qhgk8uX7VL4QNuMLpTsbelQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v326g4dd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Oct 2025 07:00:17 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59K6wBNc032255;
	Mon, 20 Oct 2025 07:00:16 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v326g4cx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Oct 2025 07:00:16 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59K5qOHM017117;
	Mon, 20 Oct 2025 07:00:14 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49vnkxmm7a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Oct 2025 07:00:14 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59K70CWj21037536
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 07:00:13 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D092220063;
	Mon, 20 Oct 2025 07:00:12 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3788420040;
	Mon, 20 Oct 2025 07:00:12 +0000 (GMT)
Received: from [9.155.199.94] (unknown [9.155.199.94])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 20 Oct 2025 07:00:12 +0000 (GMT)
Message-ID: <f5debf87-0477-4d6a-8280-0cd95cd09412@linux.ibm.com>
Date: Mon, 20 Oct 2025 09:00:11 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: linux-next: KVM/s390x regression
To: Balbir Singh <balbirs@nvidia.com>, David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Liam.Howlett@oracle.com, airlied@gmail.com, akpm@linux-foundation.org,
        apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
        byungchul@sk.com, dakr@kernel.org, dev.jain@arm.com,
        dri-devel@lists.freedesktop.org, francois.dugast@intel.com,
        gourry@gourry.net, joshua.hahnjy@gmail.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        lorenzo.stoakes@oracle.com, lyude@redhat.com, matthew.brost@intel.com,
        mpenttil@redhat.com, npache@redhat.com, osalvador@suse.de,
        rakie.kim@sk.com, rcampbell@nvidia.com, ryan.roberts@arm.com,
        simona@ffwll.ch, ying.huang@linux.alibaba.com, ziy@nvidia.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-next@vger.kernel.org
References: <20251001065707.920170-4-balbirs@nvidia.com>
 <20251017144924.10034-1-borntraeger@linux.ibm.com>
 <9beff9d6-47c7-4a65-b320-43efd1e12687@redhat.com>
 <c67386be-5278-411d-97e7-43fc34bf7c98@linux.ibm.com>
 <8c778cd0-5608-4852-9840-4d98828d7b33@redhat.com>
 <74272098-cfb7-424b-a55e-55e94f04524e@linux.ibm.com>
 <84349344-b127-41f6-99f1-10f907c2bd07@redhat.com>
 <c9f28d0c-6b06-47a2-884d-7533f7b49c45@nvidia.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <c9f28d0c-6b06-47a2-884d-7533f7b49c45@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=EJELElZC c=1 sm=1 tr=0 ts=68f5de01 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=hRXosVVZac08vXWCpJUA:9 a=QEXdDO2ut3YA:10 a=nl4s5V0KI7Kw-pW0DWrs:22
 a=pHzHmUro8NiASowvMSCR:22 a=xoEH_sTeL_Rfw54TyV31:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfX98Cmyy2VIX+n
 dsuJUM5W4yhdubfkIxrTGiDf3eUSX6qAHVGDCj4nsCIHsAetsqanqBhooG+QFvAek1wt9EbD1Mq
 z805J4i24oMF+G5xVJyvQYVP7rgbzKYUNL5FX+QNIl0/Oyh2GIL9amX//9CWItIQhhckuUkLxnn
 CbizP2+lTQhHGC1J4/gyBrY0Ha9TEnnr+fxAzMRWtz8b+gooEk/TZcj2ulUgCoFx7f4r2v/Ds7y
 3gMXqFGf4EjVRFamhAh4KhXHJKQXyTYOlpt8qBSLCFLQ0GXQgrOoGFltEODuj8dyauywZ8nxXGK
 A99WW2zj5N0tq1biHrypl+CxqoDXW20gJ014TK25xW2sEKYeXAgfme8Kd/xZ0ETPmxmB/2zOpVC
 IOMn9QEe/oXzoaLvTkWh5E9MXnriHA==
X-Proofpoint-GUID: 21HjIMs8bZEwgOEHgip1sCXZekDNKoJ7
X-Proofpoint-ORIG-GUID: azkXi4-8U0MxbTXNtBgIwP4eYW3FjhRt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 suspectscore=0 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 adultscore=0 lowpriorityscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510180022

Am 17.10.25 um 23:56 schrieb Balbir Singh:

> In the meanwhile, does this fix/workaround work?
> 
> diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
> index 0c847cdf4fd3..31c1754d5bd4 100644
> --- a/mm/pgtable-generic.c
> +++ b/mm/pgtable-generic.c
> @@ -290,7 +290,7 @@ pte_t *___pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp)
>   
>   	if (pmdvalp)
>   		*pmdvalp = pmdval;
> -	if (unlikely(pmd_none(pmdval) || !pmd_present(pmdval)))
> +	if (unlikely(pmd_none(pmdval) || is_pmd_non_present_folio_entry(pmdval)))
>   		goto nomap;
>   	if (unlikely(pmd_trans_huge(pmdval)))
>   		goto nomap;
> 

Yes, this seems to work.

CC Claudio.

