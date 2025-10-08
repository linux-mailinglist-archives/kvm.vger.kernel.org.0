Return-Path: <kvm+bounces-59645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id DC87FBC5DA9
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 17:49:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1E1754FB62F
	for <lists+kvm@lfdr.de>; Wed,  8 Oct 2025 15:44:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95AD82F90D4;
	Wed,  8 Oct 2025 15:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="d3rIbryL"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF86E283FCD
	for <kvm@vger.kernel.org>; Wed,  8 Oct 2025 15:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759937979; cv=none; b=LDFKuRKMMsU5t4cIkQIDld4OJXtia5Fs8Kr6saI46bherBunw/mn5WP3HaaegsowEHIcOSSpL6uvDsRgbiR+HvgPXjfsTcWXsICwufzuyqb65HjtR/SL3dGtfD9owZmkLYaR68V1TeEK3r5Fp8Jf3VL8kyQRhbn1PCv5zpzc+S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759937979; c=relaxed/simple;
	bh=prwSvqu9MGiHjwNKVOTAp54pKuVdWoI9wNc12CjnUiY=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HOtaRqGkIEQf82cEc/zkXIH6EhvqzEH9/YFdm58R9ESd2XNh5pLv9hPRT0dSGUSxtuMUhHJcB0D2gnE65i2CwwCbBOwHeBsW7SeLt6RIeZ8lxKBGklq52sZpacgN87tRGuwWlwJvmNZ7Ha28Hrya3LoA/JDMmxbIy9gzgZK8XpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=d3rIbryL; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 598EZSd43817531
	for <kvm@vger.kernel.org>; Wed, 8 Oct 2025 08:39:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=s2048-2025-q2; bh=Y6rX75GCY18R2EPN4PkQ
	EedkSYgIhsGgAaXv2mMV+ko=; b=d3rIbryLBO69TrQZISYTb/kuP/3DTMD/bANR
	I20PkNCsVx3ziLSO9CePtsiqQXh9TT8Yjo8Ih3C689fnOLMyqFWcDe31j8bS7urM
	s1uzgRC7NQK/eRjV3cqhcQeLC1IOrVfskP113f3fFTl4jW0Ej6rJsKA3j+FuO3Le
	JwaknbgkMyqiqUFbCTmq7PoYAoKdF2rVC6ZzbzrsDHzAhuJ+/VP8aWt22n7MpiRd
	OLW7S9J0ViRQav5fOhEJNZ6FFuWrQN/gTj+Q8ZrdGpsyZ8ZpFj8lhKAwWXfz513C
	T7aQIHWs8mEs7qkBigxrMMMcT9a9D5k9px+iwl/MGhMoCbA7Bg==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 49nsut8hwj-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Wed, 08 Oct 2025 08:39:37 -0700 (PDT)
Received: from twshared63906.02.prn5.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Wed, 8 Oct 2025 15:39:35 +0000
Received: by devgpu015.cco6.facebook.com (Postfix, from userid 199522)
	id 67471D6B67F; Wed,  8 Oct 2025 08:39:21 -0700 (PDT)
Date: Wed, 8 Oct 2025 08:39:21 -0700
From: Alex Mastro <amastro@fb.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: Alex Williamson <alex.williamson@redhat.com>,
        Alejandro Jimenez
	<alejandro.j.jimenez@oracle.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] vfio/type1: sanitize for overflow using
 check_*_overflow
Message-ID: <aOaFqZ5cPgeRyoNS@devgpu015.cco6.facebook.com>
References: <20251007-fix-unmap-v2-0-759bceb9792e@fb.com>
 <20251007-fix-unmap-v2-1-759bceb9792e@fb.com>
 <20251008121930.GA3734646@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251008121930.GA3734646@ziepe.ca>
X-FB-Internal: Safe
X-Proofpoint-GUID: UnwEriscznuLspT2mjcmwOhkW534b5s5
X-Authority-Analysis: v=2.4 cv=UadciaSN c=1 sm=1 tr=0 ts=68e685b9 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=kj9zAlcOel0A:10 a=x6icFKpwvdMA:10 a=M8q2Z_HFV9kjbA1Vx5EA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: UnwEriscznuLspT2mjcmwOhkW534b5s5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDExMCBTYWx0ZWRfX6QYrrNWE4sRi
 gOr5TRruaj/fYhOWmfEwdj8okoRORPMYzjnt6y/gPOEUqvYrIHMO57T7O1JJ/PR5FAeXIextoHf
 sWMqlBifcYGXzxY7lwDUX0xbcVNSg3tNRIab10EYgHMbnFDqsAi7jvf4T5P2sddFgbNI7L9j2I0
 XnaQ63gNttC0UGSOqdeStsbem6BzBjAM2q3Mdo4Ie47Zp/xpF8dVNVdbtDdlKCKRkFQ72tX4QTL
 mnh87BWRLdX2Ea5W8S4c4R9vipVu1aWKcv5HfPHPK/+gnEmRzdyl7J0vO0LpreCuxajslz0UXiU
 zJRB+Xu7k1wCZtCVvt9HxQszV5DSmKJ6mNRF1CMDB5u1GANhZ+MhGbRfAwcaqDVAKxOb5lFGMmX
 arZhIW0+WkCgTRleXaivT50c+uf/BQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-08_05,2025-10-06_01,2025-03-28_01

On Wed, Oct 08, 2025 at 09:19:30AM -0300, Jason Gunthorpe wrote:
> On Tue, Oct 07, 2025 at 09:08:46PM -0700, Alex Mastro wrote:
> > +	if (check_mul_overflow(npage, PAGE_SIZE, &iova_size))
> > +		return -EINVAL;
> 
> -EOVERFLOW and everywhere else
> 
> > +
> > +	if (check_add_overflow(user_iova, iova_size - 1, &iova_end))
> > +		return -EINVAL;
> 
> Let's be consistent with iommufd/etc, 'end' is start+size 'last' is start+size-1
> 
> Otherwise it is super confusing :(


Both suggestions SGTM.

