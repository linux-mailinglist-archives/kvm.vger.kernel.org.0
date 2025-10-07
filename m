Return-Path: <kvm+bounces-59553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id D1DDEBBFDB8
	for <lists+kvm@lfdr.de>; Tue, 07 Oct 2025 02:39:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 89DB84E37E3
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 00:39:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D0A81D61BB;
	Tue,  7 Oct 2025 00:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="4mY+aOVE"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF64034BA50
	for <kvm@vger.kernel.org>; Tue,  7 Oct 2025 00:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759797572; cv=none; b=EKc6cQZ1vPQDfH0wPvS9TtDwrnv10MWLKkvqqGfxYUVbDD8nvLJMGfZ5gnMZWeD+MAa5pQzkcGhgu3UXakPzEgaoTp2e87LFPKmXKPQGzgAh3sYUeOwGXAGIoGXcfsjSR8w7LcKQZiUV04Txhmcm3fL3GX8siiZEBKUCMAe01Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759797572; c=relaxed/simple;
	bh=kO3ODXqs9k7pwqkR/guQ/caM0qB7jAeOF091Dd7wRU0=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nhseahavjV3Ao/grdD9YZQIo8is8pwkivzhMRRo/oWMI8GvIjM/XONzPIE1XN+RVVpIXtsXaBC5jXOBugdN8ZV0bxOIMhJNL3niMC7Q2BhrqH7nzJ+6OH3CEP81cmKYfnpzs2bROJbqm4S6RzKSnK7ps+5let53UhGMbPjuxXGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=4mY+aOVE; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 596NraQK3885881
	for <kvm@vger.kernel.org>; Mon, 6 Oct 2025 17:39:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=s2048-2025-q2; bh=kO3ODXqs9k7pwqkR/guQ
	/caM0qB7jAeOF091Dd7wRU0=; b=4mY+aOVEe29vUt114OipFP8JGFE5URGXBbpB
	cBAEjpOlVtLyJeu0Wn3NMoZUD5kykJulae3rDQQ69YT0HO480lMJt0k1AicQw9mq
	qrg4NLGx3SewBINxQKLClclARbRTy+chEYrumWLDjUh3STpX/hmt8xrhNP4143bD
	DEaqmNoGMkwvhpPMYiw8h5TrCwqxX7bOBE4KlzPx9maSZrWazrDjoA6rmFIAAWn7
	iF9aNrZZE9CqS/rkcE7IXs1Wm1pMynGUsXhl9qp0Z/9V5efHZyl5FmrfGnP9Ehsr
	kPuAxd+j87toHRzdio291pGeV0Zj9yMU/D5XZLqw7O/I68/7SQ==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 49mjnf2vc7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Mon, 06 Oct 2025 17:39:29 -0700 (PDT)
Received: from twshared18070.28.prn2.facebook.com (2620:10d:c085:108::150d) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Tue, 7 Oct 2025 00:39:28 +0000
Received: by devgpu015.cco6.facebook.com (Postfix, from userid 199522)
	id 5602EC4B352; Mon,  6 Oct 2025 17:39:12 -0700 (PDT)
Date: Mon, 6 Oct 2025 17:39:12 -0700
From: Alex Mastro <amastro@fb.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: Alex Williamson <alex.williamson@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfio: fix VFIO_IOMMU_UNMAP_DMA when end of range would
 overflow u64
Message-ID: <aORhMMOU5p3j69ld@devgpu015.cco6.facebook.com>
References: <20251005-fix-unmap-v1-1-6687732ed44e@fb.com>
 <20251006121618.GA3365647@ziepe.ca>
 <aOPuU0O6PlOjd/Xs@devgpu015.cco6.facebook.com>
 <20251006225039.GA3441843@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251006225039.GA3441843@ziepe.ca>
X-FB-Internal: Safe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA3MDAwMyBTYWx0ZWRfX84To8NjTGgLB
 tUoDioFgUH/y0PvAT/tuXDHGA6e9E7Z9PKsLQguPyOrmVzTjYjsAaAWogmfvrN/9lS2iyvgTJUy
 OVifm8bpbLUkjHo8BoH3c7H5nfp5E1LLchEOoBkGLGpTK+Os0HtyTyvvqnPWwy6Y9JH69fOS6QN
 4dJip9RLqtYC6+1Gx3MEeIiljWMYYCs+5M8BjZjsP5xWje1xAh5IK/mSUKOH+hhJ7obusp0KPYp
 +OguC8SPap7TditZVKaD0vy9h6KCcT7XE17w42ryU5m6iw2IN77w893yMBUIERe7W7lbd7pUvP3
 Gnn1wSJBXCzml/JQCBYFGCWhgH83EHwYgARQyYrEXm/ELjleLu4S/Sy4H4v1rtE4G/wM4ndBBVY
 LIKvrRXwGgvnjqH2KNuHt2LMhzAxyQ==
X-Proofpoint-GUID: UKW1rlppIFxtnGT9IrEjX9f4980nPyzk
X-Authority-Analysis: v=2.4 cv=Zo3g6t7G c=1 sm=1 tr=0 ts=68e46141 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=kj9zAlcOel0A:10 a=x6icFKpwvdMA:10 a=cnzby_Kikf3u7RrYEdwA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: UKW1rlppIFxtnGT9IrEjX9f4980nPyzk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-06_07,2025-10-06_01,2025-03-28_01

On Mon, Oct 06, 2025 at 07:50:39PM -0300, Jason Gunthorpe wrote:
> Could we block right at the ioctl inputs that end at ULONG_MAX? Maybe
> that is a good enough fix?

That would be a simpler, and perhaps less risky fix than surgically fixing every
affected place.

If we were to do that, I think VFIO_IOMMU_TYPE1_INFO_CAP_IOVA_RANGE should
report coherent limits -- i.e. it should "lie" and say the last page (or
whatever) of u64 addressable space is inaccessible so that the UAPI is coherent
with itself. It should be legal to map/unmap iova ranges up to the limits it
claims to support.

I have doubts that anyone actually relies on MAP_DMA-ing such
end-of-u64-mappings in practice, so perhaps it's OK?

