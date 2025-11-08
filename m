Return-Path: <kvm+bounces-62369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D118C42220
	for <lists+kvm@lfdr.de>; Sat, 08 Nov 2025 01:37:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E816E4EB5DD
	for <lists+kvm@lfdr.de>; Sat,  8 Nov 2025 00:37:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46696246332;
	Sat,  8 Nov 2025 00:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="5pvNYkpL"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7B623A99F;
	Sat,  8 Nov 2025 00:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762562212; cv=none; b=fiJFHsUDpR7ZxjOpAMzunz+RAJxn1mgWmN5n7k+xVCQ3yMGBQ3LpsmrV7XbV7qRIJlq6GJcGYD4j8M0ngF3VnHsSbkgT+ZUMX625CKc/dxM+D0gDw6ND/fA2MxI+kDc7A7/awI5p4A0FsaRtj6jJdIubWZi85Z0Uhq8V9VEM+HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762562212; c=relaxed/simple;
	bh=eU4TAIZbs7C6gGLQnekCSFGis0qEoilzG6PALi+wMrY=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K3Bf0zcdqQiiCMZbTEDvzEqFGG9cZNBoN9br2uwfszr91dEn6OLNyJsC//V8fX38NqlX/KMxVvfg07zx+pgRDbTdgi10//pKGvljkxM9BJSaVu6uax0j9Nuzt2Ya0sgml3omR3qubuHqxLSbP26zNmVJikfpjxbSiqChH0qb/eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=5pvNYkpL; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5A7Lu8JX2926361;
	Fri, 7 Nov 2025 16:36:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=s2048-2025-q2; bh=Et2be86M8p24fu0+u8Pm
	0xt4QWqeKRsLhMWif8WRR/8=; b=5pvNYkpLD7pZSr8hskWlDZBZ7qHaMWTRu8LQ
	BTvSvvanAw2Ed2aTIF4jE+3vbqy9YHx3yhSro0R98S2jcx1RNzLgGyDxkKKNbNUk
	z7IcoL1tOKPCxZQnPNysD73oXuzQ7R/8p3WkqOSWn7GJIVfMesSJxxyMKlMxreuc
	dhIlfQlNWcm8dVGTwygbABVZswNMV8Ljq4ypwSj+E/rABc4Uumyqzkfop9jrP5Rc
	SGkDpvhuecaacZXcnNkZ7ZNIqzgyp1/eyk7/gPMp72xk3pZ+S1sW25+sQ2PP24lP
	pKrF6xufd4qj4TVaYIyAtBZ0B7mZAVwsXiYgt4xutNHYwQGqIw==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4a9kpvcc9x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Fri, 07 Nov 2025 16:36:44 -0800 (PST)
Received: from devgpu015.cco6.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Sat, 8 Nov 2025 00:36:43 +0000
Date: Fri, 7 Nov 2025 16:36:42 -0800
From: Alex Mastro <amastro@fb.com>
To: David Matlack <dmatlack@google.com>
CC: Alex Williamson <alex@shazbot.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 0/5] vfio: handle DMA map/unmap up to the addressable
 limit
Message-ID: <aQ6Qmrzf7X0EP9aJ@devgpu015.cco6.facebook.com>
References: <20251028-fix-unmap-v6-0-2542b96bcc8e@fb.com>
 <aQ1A_XQAyFqD5s77@google.com>
 <aQ5xmwPOAzG4b_vm@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aQ5xmwPOAzG4b_vm@google.com>
X-Authority-Analysis: v=2.4 cv=GopPO01C c=1 sm=1 tr=0 ts=690e909d cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=kj9zAlcOel0A:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=Xgbwr4nqScdIo8cszjEA:9 a=CjuIK1q_8ugA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: 1wYNdKE4l1eFVFDrwhJSmHOJkPN8yh2X
X-Proofpoint-GUID: 1wYNdKE4l1eFVFDrwhJSmHOJkPN8yh2X
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDAwMyBTYWx0ZWRfXwYqFehUMMp5i
 ZIov0xSL8XAHzN0EQgDI+fVUD7VHmBVKmtYeA2NdICsitVas+xf3TZpvUbq6dkAp9PH0ZvNDTPG
 3QseW/UHwU6Hr/FiYLRID+9mXA2CQGGBnyAF9LB0Z73v6+s5oKvP9B525CPCaMp1rjhUXjOw4dX
 87nniVHG609Ajl1QvdwKJN8tuA14MpCLKfC1RyLBFJ8PG6v6wTbTL+t6jE4dn3F+ky9Vm2UaSjY
 5nrU8SYcrfRc7wM8MSVo04jbV60AU9O6nMYa3I+pEyfvidj8DGDSfWFProlmTWsD3+nBKE6YqOa
 v9OR3JimthGRvPXYTZlYHZuiOsbsFKu6TxHLOX87qOL+cty0m3x7xFMhC8/uVNg1nZSujwyRDj1
 rb1aqeYKBSFrfFvCLTXv3nLVb14oKQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-07_07,2025-11-06_01,2025-10-01_01

On Fri, Nov 07, 2025 at 10:24:27PM +0000, David Matlack wrote:
> On 2025-11-07 12:44 AM, David Matlack wrote:
> > On 2025-10-28 09:14 AM, Alex Mastro wrote:
> For type1, I tracked down -EINVAL as coming from
> vfio_iommu_iova_dma_valid() returning false.
> 
> The system I tested on only supports IOVAs up through
> 0x00ffffffffffffff.
> 
> Do you know what systems supports up to 0xffffffffffffffff? I would like
> to try to make sure I am getting test coverage there when running these
> tests.

I observed this on an AMD EPYC 9654 server.

> In the meantime, I sent out a fix to skip this test instead of failing:
> 
>   https://lore.kernel.org/kvm/20251107222058.2009244-1-dmatlack@google.com/

Thanks for the fix -- acked. My tests were making too strong an assumption
about availability of those ranges.

Alex

