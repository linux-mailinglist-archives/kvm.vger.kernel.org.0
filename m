Return-Path: <kvm+bounces-20671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A9B8891BFBF
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 15:40:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E4EB3B21386
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 13:40:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1714614B07B;
	Fri, 28 Jun 2024 13:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WbT3C0ed"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B15829B0;
	Fri, 28 Jun 2024 13:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719582022; cv=none; b=nGssZfSYrWbzp3rghA0az+PXPckcJJJHyfXRd9m43oablSULK0IC/sNrUAqLXULnJep+kAKYZHVKnkUNKoSF/6gTVspwGdVf2U1DLWdXraW1Otu18EK/PA8pwq/MDM6iJQ0Oxeo21kAWlg894Hks73yDDBT9PhtdhV71GGa8k+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719582022; c=relaxed/simple;
	bh=ItizkFuhge7KCxeQhCE9jR/+a/ULtccjXTBGhI9e4Wo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cr3RuFpeFxydDAcXtqeYBbNus58Wp/Yc5ICXJjfWlqtWYiEhmR7xXFh4FhM2UQP99rF541xIuTlKVsry3GIStCmUkaU4FMqEHJYTTaMXa7pyNoTePIlMcQZW9Y7PZRhD0KH+ptM2kB4nv55IivgBLxaWB/QE5QWUccOv+Uig51U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WbT3C0ed; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45SDRbqV005072;
	Fri, 28 Jun 2024 13:40:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-transfer-encoding:in-reply-to; s=pp1; bh=y
	4aU0lrHd0MOExWCECL/oRVrxjXuRIwYm4jyKeg7Ct0=; b=WbT3C0edb95uc0CEl
	nVWwd9v18UPo2B5xg5B2Nc7BB+9Lj4uvx2aG88ZMuig7Dg08sjdwXX9VWhiVwjNL
	iGhQSlL3hwlIXFaOb+cARX+YZ2SCkcGskkHW5Ac+j/qDovgIxHm4PgYbOUNCOtR8
	QumwFPVVv78c22O8m6H79RIvhDQUGDbfCKcEm0drj9ub0Z7A2/10F4RYagwLUrye
	RapH5ACcEWASrRZDFPOAfJLi/v43EJlxH59LREtu6zT1RjDp2eAgVzLWs7q601bu
	ki2+k5ONiO+pSYMo9W0GOpT6hHYb+IFeToGeOLGMtIuh9I00topjipqL+WaMb34J
	s3ung==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 401w7484vd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Jun 2024 13:40:17 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45SAjtV4019984;
	Fri, 28 Jun 2024 13:40:17 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3yxb5n0b3u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Jun 2024 13:40:17 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45SDeANL45285668
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Jun 2024 13:40:12 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 960B72004F;
	Fri, 28 Jun 2024 13:40:10 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1AE6120043;
	Fri, 28 Jun 2024 13:40:10 +0000 (GMT)
Received: from osiris (unknown [9.171.26.144])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 28 Jun 2024 13:40:10 +0000 (GMT)
Date: Fri, 28 Jun 2024 15:40:08 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Eric Farman <farman@linux.ibm.com>
Cc: Matthew Rosato <mjrosato@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] s390/vfio_ccw: Fix target addresses of TIC CCWs
Message-ID: <20240628134008.14360-G-hca@linux.ibm.com>
References: <20240627200740.373192-1-farman@linux.ibm.com>
 <20240628121709.14360-B-hca@linux.ibm.com>
 <0f7db180c7f3ece66685c50df7ef38ab81cac03b.camel@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0f7db180c7f3ece66685c50df7ef38ab81cac03b.camel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Q2i7APsVzxLkrd389A64imgttfp9jcEw
X-Proofpoint-ORIG-GUID: Q2i7APsVzxLkrd389A64imgttfp9jcEw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-28_09,2024-06-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=679
 adultscore=0 suspectscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 mlxscore=0 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2406140001
 definitions=main-2406280100

On Fri, Jun 28, 2024 at 09:31:56AM -0400, Eric Farman wrote:
> > > dma32_to_u32(ccw->cda) - ccw_head;
> > > -			ccw->cda = u32_to_dma32(cda);
> > > +			/* Calculate offset of TIC target */
> > > +			cda = dma32_to_u32(ccw->cda) - ccw_head;
> > > +			ccw->cda = virt_to_dma32(iter->ch_ccw) +
> > > cda;
> > 
> > I would suggest to rename cda to "offset", since that reflects what
> > it is
> > now. Also this code needs to take care of type checking, which will
> > fail now
> > due to dma32_t type (try "make C=1 drivers/s390/cio/vfio_ccw_cp.o).

...

> I was poking at that code yesterday because it seemed suspect, but as I
> wasn't getting an explicit failure (versus the CPC generated by hw), I
> opted to leave it for now. I agree they should both be fixed up.

...

> > I guess
> > you could add this hunk to your patch:
> > 
> > @@ -915,7 +915,7 @@ void cp_update_scsw(struct channel_program *cp,
> > union scsw *scsw)
> >  	 * in the ioctl directly. Path status changes etc.
> >  	 */
> >  	list_for_each_entry(chain, &cp->ccwchain_list, next) {
> > -		ccw_head = (u32)(u64)chain->ch_ccw;
> > +		ccw_head = (__force u32)virt_to_dma32(chain-
> > >ch_ccw);
> >  		/*
> >  		 * On successful execution, cpa points just beyond
> > the end
> >  		 * of the chain.

...

> > Furthermore it looks to me like the ch_iova member of struct ccwchain
> > should
> > get a dma32_t type instead of u64. The same applies to quite a few
> > variables
> > to the code. 
> 
> Agreed. I started this some time back after the IDAW code got reworked,
> but have been sidetracked. The problem with ch_iova is more apparent
> after the dma32 stuff.
> 
> > I could give this a try, but I think it would be better if
> > somebody who knows what he is doing would address this :)
> 
> I'll finish them up. But v2 will have to wait until after my holiday.
> Thanks for reminding me of the typechecking!

I hope you didn't get me wrong: from my point of view we want one or
two small patches (the above hunks), which fix the bugs, if you
agree.

And then address the type checking stuff at a later point in time.

(btw: your mailer adds lot's of extra line wraps)

