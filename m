Return-Path: <kvm+bounces-20669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E09B191BE57
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 14:17:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E3921F2426F
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 12:17:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE32215689A;
	Fri, 28 Jun 2024 12:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Tkhlzdvv"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D178E1DFF7;
	Fri, 28 Jun 2024 12:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719577042; cv=none; b=ZKwTWo8yHLiy9AQaSr3rqtsozMKzvY7V10V9Tp98bza8u6jfJ1S0dvOlEE4opQW6RVZM4ccw6nRLB8NhSqnIugL5rryvI6OkT5JBDEN/VcxHSRCCP6dV9/2lEWSM0I+YzFrvdEBXBSM9Z+ZetiLA5kzeIdypQo70CX6EM/m+0Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719577042; c=relaxed/simple;
	bh=1SgN/tEnZZx6s1xUcHs1AhgAUQy2FdqJzbkjEkWOx6o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mUfbCm1ui5D/AN1mIcCsk/QRrrFpHd05mqOS0KlZScwilaqWEBzmj7/ZSA51t5E+9nca3xkEU9epucKXPTMndBO9XjBvVCBbqK5v5HBCRfxPbQiNsBv0ax5Zx5Radsv59625jXZrL6lPAgnJIDlHzOl0PWTK02TFkUpEA4I8+gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Tkhlzdvv; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45SBvgFp019107;
	Fri, 28 Jun 2024 12:17:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=pp1; bh=l/4YLNpmn43UtWF92gB2zQkTMb8
	jPxStygRmg3uldyE=; b=TkhlzdvvW7goC3Zune1d4w2vTlcgGJBigaodcurt5jG
	LHDGEG0v25cI+ElNrq2WdcvgdJb8dk+ksqLPZKfdAa57daBhZ5wp0O3UmNzo2kTA
	7t+gwgRfQXy7FU/jgRKAmvwJILSrQfJAA0LruS8PNNinH6sgEKUj4DAa9NLgiVbX
	/B3ccBHyOfaXx2Xxdkee2AXsdtRFYrSt8iajuZRUglfn2799/aHY32/uFSyyjZXb
	r/s9mrDXYJ+TtUajYmhZC5DetonPOWCV7o/AFlIscx2FWi8wocj+o3gdsbv2DaOc
	fzYgYdCC7/22mfT/4b+K0DjqEHNYPc9851WvmRD/mYg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 401qgbgtv0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Jun 2024 12:17:17 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45SBZIYH019949;
	Fri, 28 Jun 2024 12:17:16 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3yxb5n01fv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Jun 2024 12:17:16 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45SCHBnu45810128
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Jun 2024 12:17:13 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 425C220040;
	Fri, 28 Jun 2024 12:17:11 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C3E6F2005A;
	Fri, 28 Jun 2024 12:17:10 +0000 (GMT)
Received: from osiris (unknown [9.171.26.144])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 28 Jun 2024 12:17:10 +0000 (GMT)
Date: Fri, 28 Jun 2024 14:17:09 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Eric Farman <farman@linux.ibm.com>
Cc: Matthew Rosato <mjrosato@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] s390/vfio_ccw: Fix target addresses of TIC CCWs
Message-ID: <20240628121709.14360-B-hca@linux.ibm.com>
References: <20240627200740.373192-1-farman@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240627200740.373192-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: yvIygTKM3wfQ7o1pNICz94RTVaMHABJg
X-Proofpoint-GUID: yvIygTKM3wfQ7o1pNICz94RTVaMHABJg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-28_08,2024-06-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 suspectscore=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 mlxlogscore=813 impostorscore=0 lowpriorityscore=0
 clxscore=1015 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2406140001 definitions=main-2406280088

On Thu, Jun 27, 2024 at 10:07:40PM +0200, Eric Farman wrote:
> The processing of a Transfer-In-Channel (TIC) CCW requires locating
> the target of the CCW in the channel program, and updating the
> address to reflect what will actually be sent to hardware.
> 
> An error exists where the 64-bit virtual address is truncated to
> 32-bits (variable "cda") when performing this math. Since s390

...

> Fix the calculation of the TIC CCW's data address such that it points
> to a valid 31-bit address regardless of the input address.
> 
> Fixes: bd36cfbbb9e1 ("s390/vfio_ccw_cp: use new address translation helpers")
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_cp.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
> index 6e5c508b1e07..fd8cb052f096 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.c
> +++ b/drivers/s390/cio/vfio_ccw_cp.c
> @@ -495,8 +495,9 @@ static int ccwchain_fetch_tic(struct ccw1 *ccw,
>  	list_for_each_entry(iter, &cp->ccwchain_list, next) {
>  		ccw_head = iter->ch_iova;
>  		if (is_cpa_within_range(ccw->cda, ccw_head, iter->ch_len)) {
> -			cda = (u64)iter->ch_ccw + dma32_to_u32(ccw->cda) - ccw_head;
> -			ccw->cda = u32_to_dma32(cda);
> +			/* Calculate offset of TIC target */
> +			cda = dma32_to_u32(ccw->cda) - ccw_head;
> +			ccw->cda = virt_to_dma32(iter->ch_ccw) + cda;

I would suggest to rename cda to "offset", since that reflects what it is
now. Also this code needs to take care of type checking, which will fail now
due to dma32_t type (try "make C=1 drivers/s390/cio/vfio_ccw_cp.o).

You could write the above as:

			ccw->cda = virt_to_dma32((void *)iter->ch_ccw + cda);

Note that somebody :) introduced a similar bug in cp_update_scsw(). I guess
you could add this hunk to your patch:

@@ -915,7 +915,7 @@ void cp_update_scsw(struct channel_program *cp, union scsw *scsw)
 	 * in the ioctl directly. Path status changes etc.
 	 */
 	list_for_each_entry(chain, &cp->ccwchain_list, next) {
-		ccw_head = (u32)(u64)chain->ch_ccw;
+		ccw_head = (__force u32)virt_to_dma32(chain->ch_ccw);
 		/*
 		 * On successful execution, cpa points just beyond the end
 		 * of the chain.

Furthermore it looks to me like the ch_iova member of struct ccwchain should
get a dma32_t type instead of u64. The same applies to quite a few variables
to the code. I could give this a try, but I think it would be better if
somebody who knows what he is doing would address this :)

