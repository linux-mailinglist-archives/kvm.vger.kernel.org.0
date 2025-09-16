Return-Path: <kvm+bounces-57739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 95582B59D96
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 18:27:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6E20D7B436E
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 16:25:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5109E374279;
	Tue, 16 Sep 2025 16:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mgFQN0/W"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E392332857E;
	Tue, 16 Sep 2025 16:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758040030; cv=none; b=cPgGadRNb7ud9r/3d7eB6xwutv5LRQ+Cuqmrw69iafnzbxlZoxUc+qVQz/i3QzthcJ/pJc/uWIlibNe6GgdWB7jtiCoTV+k4i99KakVhHmWgcHC9soQ0nz0CHoOtGrROPWHDV08Ik/Vxk+BQw8U02QfLvBcwYwF9ApL6w09BWrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758040030; c=relaxed/simple;
	bh=+IHHJ85mV9n4ih3baS4Nlb34cpe1kvfb0oPy78kAAbc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CWpUfoPW3cKdYX4FulEzV3lmq1ZtcVagO/ITR2NaGgXRYZt7zmBqaBkCOpmRHCk7y4VTO595cLIgoQnx0GBTtVbu6+ft5da13ezCoY3fb5NUnLDVDMK1kJJHLfuUhXc5lmuEDiSJB7qz7XO2KJ1UZko7r17GHrqIy+BBz8X81lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mgFQN0/W; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58G9HP2u019518;
	Tue, 16 Sep 2025 16:27:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=r7jy0bwQkssbZt2/w8JUPytH4KiBGn
	5jehL374/xelI=; b=mgFQN0/W41a2qPOMt3zrODy57xO4762MwxIbcF1N3YQe3Q
	Y52OEmWSL7PLB0U6KlzlTXC8aE4HRuOvTF3kJzcyZeH99tgeHgwjqb5zWDG22EzG
	aFRaAbFPAK2U2IzLfRoLZWfRoIkL/7D4qWVcNbSg4F/4v8jnE1rjVV1l5yfkfO7O
	lWQn5NStAHHrzXi0AXHLUudz4S+hvQc9Vno5Bdndh2QlNsuDO1WqzUXe4g7IohMd
	a1aqJB0ouiMHNMbDLJ4xrb7xkn5OjA2SdE52Yn3FAoMwJnE7hFwmR3oxgbypMtFR
	tYlBj1Xy6opxXBHcTqX7PaSvGcJefXJvcvrBsCBQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49509yam5t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 16:27:00 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58GEX5YQ027308;
	Tue, 16 Sep 2025 16:26:59 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 495men4skf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 16:26:59 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58GGQtTx48693608
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 16:26:55 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 34A6720043;
	Tue, 16 Sep 2025 16:26:55 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9C45F20040;
	Tue, 16 Sep 2025 16:26:54 +0000 (GMT)
Received: from osiris (unknown [9.111.88.139])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 16 Sep 2025 16:26:54 +0000 (GMT)
Date: Tue, 16 Sep 2025 18:26:53 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com, schlameuss@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v2 08/20] KVM: s390: KVM page table management functions:
 allocation
Message-ID: <20250916162653.27229G04-hca@linux.ibm.com>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
 <20250910180746.125776-9-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910180746.125776-9-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAyMCBTYWx0ZWRfXwb5JXHcJWA+B
 TDa9q7yJ/A7M+huwP6j59ht3Nc0oItv5hMZey5X+aYaIUDM+xMqmn0oFKs3HpKEQDjEZFjiobMB
 XbRz1aOc2AyDgOHsDd1IPBMEKvtaoUkxm1yJedJkpuYnQgzBFNHU8Shm3vBGxyV90h+u/k0MDrB
 Zr30GYqHB0kPAMWEyEUt5h8oXmFeYf+4n3/ClkFija7EXDTvtSMWrZ3vKbSKFXhc5zye8c1XWeZ
 Yi2Fcl05yKqDV32brOf0cduDWyMZHEw7lq8FgXyZTrwU7bC7YZUkUNG5LmpYD9/YvLoDT5XuXVn
 RdAL9MpUV6Xiw43cRSHbxRztnPTGIC+siLt+bispGnfySa5TOYS4xorGueU6jSQq6pY4tSKL1zm
 zDX/m8Cn
X-Authority-Analysis: v=2.4 cv=OPYn3TaB c=1 sm=1 tr=0 ts=68c98fd4 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=7565BKuWIPA_-WLTj0wA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: IoNE6rkFtes35lBIAODcau2IStM6ujaM
X-Proofpoint-ORIG-GUID: IoNE6rkFtes35lBIAODcau2IStM6ujaM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1015 phishscore=0 suspectscore=0 spamscore=0
 bulkscore=0 malwarescore=0 impostorscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509130020

On Wed, Sep 10, 2025 at 08:07:34PM +0200, Claudio Imbrenda wrote:
> Add page table management functions to be used for KVM guest (gmap)
> page tables.
> 
> This patch adds the boilerplate and functions for the allocation and
> deallocation of DAT tables.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/kvm/Makefile     |  1 +
>  arch/s390/kvm/dat.c        | 91 ++++++++++++++++++++++++++++++++++++++
>  arch/s390/kvm/dat.h        |  4 ++
>  arch/s390/mm/page-states.c |  1 +
>  4 files changed, 97 insertions(+)
>  create mode 100644 arch/s390/kvm/dat.c

...

> +static inline struct page_table *dat_alloc_pt_noinit(void)
> +{
> +	struct page *page;
> +	void *virt;
> +
> +	page = alloc_pages(GFP_ATOMIC, 0);
> +	if (!page)
> +		return NULL;
> +
> +	virt = page_to_virt(page);
> +	__arch_set_page_dat(virt, 1);
> +	return virt;
> +}

Is GFP_ATOMIC a typo, and this should have been GFP_KERNEL?

Otherwise I would guess this will cause problems in the future when
under memory pressure allocating guest page tables fails easily,
while before this change such allocations never failed.

