Return-Path: <kvm+bounces-59532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65BE5BBEA58
	for <lists+kvm@lfdr.de>; Mon, 06 Oct 2025 18:29:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AFC163AD12A
	for <lists+kvm@lfdr.de>; Mon,  6 Oct 2025 16:29:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6404D2DCBF8;
	Mon,  6 Oct 2025 16:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="DoT1gPa4"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07812DC78A
	for <kvm@vger.kernel.org>; Mon,  6 Oct 2025 16:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759768158; cv=none; b=FY2OjdLSgMyciEiX7XsJfdch9t9Cs7sNF8BySNxRGb8rpGYtYKkZlQ2/rytYEUfeQACfnXntZdTHzeLKcgJS/U154kO7O0bBngMnm4obmusdWKQoh68pKhG1+z6Gf3zYXVCOGAPw3thlmscW6Z7B5c2d+beJOyGNcqROPf3Li8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759768158; c=relaxed/simple;
	bh=6FhL6gYhOdy9uGhuQxmPsy9C7wWmp5DKTGsZtAw9rWA=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s9JV10QVjJMlEdw/QmAucSbiz63rZYJpCB3/sbCEXejMTMmeKjPB3SBRdRfPG0x9IujVW/nIFUXDabSUTUAr9iKNB6Wm1bHrtbbeOHlsEXqrwUVEtmB69HU7iQhYo7twzh1pBlA3X8Y/7gwbeQiV2b4IMu4Sdsyc7CMlPpGq5Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=DoT1gPa4; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 596AFrTJ1876533
	for <kvm@vger.kernel.org>; Mon, 6 Oct 2025 09:29:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=s2048-2025-q2; bh=dFqZho45/8qZRjEXDmJ/
	HY4XGC7a+Wl0xoxT1vR6E4M=; b=DoT1gPa4IdhXNYOlTfiE0//cb/+RKVsHInXj
	4VG9hKPmIiyj+0+u/XE6zds4fW02tgkpQrJoj3s4Atrqb8XiAqeFjmN5IPDL+J6l
	kF+WTQcznRAZB8l1Mixjx+Bj4i2a5JJqG8KR6bLAKjk6imKA6eCKpPhSGsXVDVcP
	1Jjyk0AaGxZGqzQWw/8oko8nlVwRzH05mZSU5tgOn92ORj8+XwKiMg0C9eqOO9KP
	AP2tIXZjBE7ybkhLfyUCq5AhHaa4ex0nu1NzAaz3E4/YDfWXJqtkquYYpSUbwjRA
	T3okW91ZWF+ejB2y5OFe2JLv4ihgTZO42gKti29VMCCvjMqX9g==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 49mbv22p3d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Mon, 06 Oct 2025 09:29:14 -0700 (PDT)
Received: from twshared23637.05.prn5.facebook.com (2620:10d:c0a8:1c::1b) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Mon, 6 Oct 2025 16:29:12 +0000
Received: by devgpu015.cco6.facebook.com (Postfix, from userid 199522)
	id 66992C0A857; Mon,  6 Oct 2025 09:29:07 -0700 (PDT)
Date: Mon, 6 Oct 2025 09:29:07 -0700
From: Alex Mastro <amastro@fb.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: Alex Williamson <alex.williamson@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfio: fix VFIO_IOMMU_UNMAP_DMA when end of range would
 overflow u64
Message-ID: <aOPuU0O6PlOjd/Xs@devgpu015.cco6.facebook.com>
References: <20251005-fix-unmap-v1-1-6687732ed44e@fb.com>
 <20251006121618.GA3365647@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251006121618.GA3365647@ziepe.ca>
X-FB-Internal: Safe
X-Proofpoint-ORIG-GUID: 7yqjELqosISyax5YdcFBdVmos3qv1Fmh
X-Proofpoint-GUID: 7yqjELqosISyax5YdcFBdVmos3qv1Fmh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA2MDEzMCBTYWx0ZWRfX6UvFaVJ6sxjo
 G3LF7AQzG1wp3fTwqdB9JKywAJxhlVhoJIuQAGKMtApuQkZnvblHuV9WkMJv5GHnE4UZ/cjnnuf
 2Yicz3DNG8qQjRhVcSqJqNu8qTp0oKwruTQgtOQGnH+AAQECY8Ga2x+8WaDnMa/Cy4gbINPv4T8
 naS5ZUpIgH80FIQuFyBaAsNlySwRot1Z270CCI8SocQfH7z8FK83UAqu0b+gAb6+yNwZYemCjdU
 SK8cxfat5sqmNBblWp7WZakU6QY6zSq5WNkjhyE3KNCI3jh0AGpNEPpTNRzNubXaOj8XXQ4Bbcq
 YmFJX3ubBHWVN4JM9bK9hUDvL4Hx0LRMNHI3iMOqiUW4AA/WBC+WqDrgDnOoIkmtW4/HuYrExcv
 dSJogCgBWmcz5MmtE4b8211tWM3Dtg==
X-Authority-Analysis: v=2.4 cv=deqNHHXe c=1 sm=1 tr=0 ts=68e3ee5a cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=kj9zAlcOel0A:10 a=x6icFKpwvdMA:10 a=kkfiAL6mXfWBq56Im0MA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-06_05,2025-10-06_01,2025-03-28_01

On Mon, Oct 06, 2025 at 09:16:18AM -0300, Jason Gunthorpe wrote:
> This doesn't seem complete though, if the range ends at the ULONG_MAX
> then these are not working either:
> 
> 		if (start < dma->iova + dma->size) {
> 
> ?
> 
> And I see a few more instances like that eg in
> vfio_iova_dirty_bitmap(), vfio_dma_do_unmap(), vfio_iommu_replay()

You are right. There are several places which would need to be fixed to handle
mappings which lie against the end of the addressable range. At least these
would need to be vetted:

$ rg 'iova.*\+.*size' -n drivers/vfio/vfio_iommu_type1.c | rg -v '\- 1'
173:            else if (start >= dma->iova + dma->size)
192:            if (start < dma->iova + dma->size) {
216:            if (new->iova + new->size <= dma->iova)
1060:   dma_addr_t iova = dma->iova, end = dma->iova + dma->size;
1233:   if (dma && dma->iova + dma->size != iova + size)
1380:           if (dma && dma->iova + dma->size != iova + size)
1501:           ret = vfio_iommu_map(iommu, iova + dma->size, pfn, npage,
1504:                   vfio_unpin_pages_remote(dma, iova + dma->size, pfn,
1721:           while (iova < dma->iova + dma->size) {
1743:                           i = iova + size;
1744:                           while (i < dma->iova + dma->size &&
1754:                           size_t n = dma->iova + dma->size - iova;
1785:                   iova += size;
1810:           while (iova < dma->iova + dma->size) {
1823:                   i = iova + size;
1824:                   while (i < dma->iova + dma->size &&
2919:           if (range.iova + range.size < range.iova)

I could take a stab at improving this, but am not confident I could test all the
affected codepaths.

