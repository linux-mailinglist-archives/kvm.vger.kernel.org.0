Return-Path: <kvm+bounces-72232-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6Ld6OjYSomnQywQAu9opvQ
	(envelope-from <kvm+bounces-72232-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 22:52:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EB1F1BE4CF
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 22:52:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1F369306DFE6
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 21:52:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17C0C47A0C3;
	Fri, 27 Feb 2026 21:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="lOEJPYrF"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB8A2D73A7;
	Fri, 27 Feb 2026 21:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772229157; cv=none; b=iJsN1YQw+V6Qtk/3dsTXk0tnV9uaOcGDMfH4biSlBUTNaVeQm+mDWqVzc4JmAimHTV75+lnImPm6Woyf9M/IWy0WRT+Q/35vtjNUYglVtWuALYI52aIJ5v/mmxpvfJ9/vBd2IAeYRuUrskB2r3LK7zRGPT8LK7TuLAfwTtgL5PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772229157; c=relaxed/simple;
	bh=o0/c+M7R4sVUMrkOw52aHa7Z/zv7HP1nqlFhRyi2LyI=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mN1fPNltvLmpcbIVOd8o+6z4QRLxIv2d4qPAQE8oK/jBnSIcO3700pg58RvCTvv0qNnJBj3LSx+2Qh9yV8qSZHPVSh393PsL22L+Gd9dkjCpRjySm/TuZHMtIaOm5OYNgWu4TLjMcArix8EHdBb32nzY+MNFCzWT1vD57Kia+wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=lOEJPYrF; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61RLG1FX2026789;
	Fri, 27 Feb 2026 13:52:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=s2048-2025-q2; bh=5tvzMNgRyjYeXUbWEgOr
	QCHGvdINQmVReqV33VO1vYg=; b=lOEJPYrFJfKPOl8EdQ0RmD6bms+WDShmruWF
	VnyoOrNZQG/H2KdhWY4lAJmoOWuqGhB1UvaPydl1MA3rW1Ey26Zhjz2gMXeJGEjh
	XTm6vLYGCuypDkWiMH4pRyCvDhlFQFjB7sQXIACKMD9yWCH64p+8wLwrVMnFWiQF
	oK5VIYWONtSXjLGoiYAHSqGVqRSdsPNOetlncfMZxQnNcb1NlbTIptP9TKIk7ymV
	IYplEsA5GHv3hXDm5vTFbHhDoGSKRqKUobAEhhNuEthR7SnXKj5Bh5Us2pblegt2
	ZZXaLosgNZ1KrvaHQS3fL7Wwt4/mxDE/4t6uECFPW7gG2EiMjQ==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4ckfq3js3j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Fri, 27 Feb 2026 13:52:20 -0800 (PST)
Received: from devgpu015.cco6.facebook.com (2620:10d:c085:108::150d) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.35; Fri, 27 Feb 2026 21:52:19 +0000
Date: Fri, 27 Feb 2026 13:52:15 -0800
From: Alex Mastro <amastro@fb.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Matt Evans <mattev@meta.com>,
        Christian =?iso-8859-1?Q?K=F6nig?=
	<christian.koenig@amd.com>,
        Alex Williamson <alex@shazbot.org>,
        "Leon
 Romanovsky" <leon@kernel.org>,
        Mahmoud Adam <mngyadam@amazon.de>,
        "David
 Matlack" <dmatlack@google.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?=
	<bjorn@kernel.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Kevin Tian
	<kevin.tian@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
        "Pranjal
 Shrivastava" <praan@google.com>,
        Alistair Popple <apopple@nvidia.com>,
        "Vivek
 Kasireddy" <vivek.kasireddy@intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <linaro-mm-sig@lists.linaro.org>,
        <kvm@vger.kernel.org>
Subject: Re: [RFC PATCH 3/7] vfio/pci: Support mmap() of a DMABUF
Message-ID: <aaISD4mw1XzQl1S8@devgpu015.cco6.facebook.com>
References: <20260226202211.929005-1-mattev@meta.com>
 <20260226202211.929005-4-mattev@meta.com>
 <90bd4185-1e87-4393-b9e1-1318a656a7d9@amd.com>
 <20260227125109.GH5933@nvidia.com>
 <c5a8f318-20af-4d80-a279-2393192108c3@meta.com>
 <20260227194807.GL5933@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260227194807.GL5933@nvidia.com>
X-Proofpoint-ORIG-GUID: 9CjaaW2uuX_U6ybXFihlTHjBbB__gpks
X-Authority-Analysis: v=2.4 cv=OuJCCi/t c=1 sm=1 tr=0 ts=69a21214 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=9jRdOu3wAAAA:8 a=5gW12rAjPW6ZUhMuABQA:9 a=CjuIK1q_8ugA:10 a=zZCYzV9kfG8A:10
 a=ZE6KLimJVUuLrTuGpvhn:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI3MDE5NCBTYWx0ZWRfXyqdREz8O3V5t
 qlIto6yFmGf5tmYJHZjF+7puY4thZCaydDYsQ7U433LREt9hGqMLq59FcP1iNrkulf7fKNFdMnV
 d5i8vdC+Y+IJLjNm81qE+aLEo95cVryoQtPo/mWo4ojQ829BFivVpIkdr2DjIwQyH3uMyJlTtGZ
 VbeLzgzfi4Krv0i8QKNFq6up+wbHjX2MB+d/LeSG5ILKqghLDaSCQipBIxQ65Qx6IpU4IpnZjq+
 O/t0STrz7g/j7ZnyQlOEgPg4hBBVYK3JdymylpUYxjHNQKGbFL0AYiSI5LCGKPEQCv6LIyomPDH
 11vskgelQfR0TtO+Qh7At9I8sUzvpsnc6x7pegybIFwXHoH42mokfv/caUxaTeXS4sT2lkXpPBw
 kAatiNldR1FIY384IpHJa4mtnAJeat2dDsLEDI5jUgNGkbBKLVOjssIxQTSbuT4Ooxtmgn0I1Io
 kBoBqWltTCvjSUVlMFQ==
X-Proofpoint-GUID: 9CjaaW2uuX_U6ybXFihlTHjBbB__gpks
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-27_04,2026-02-27_03,2025-10-01_01
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[fb.com,reject];
	R_DKIM_ALLOW(-0.20)[fb.com:s=s2048-2025-q2];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72232-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[fb.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[amastro@fb.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[devgpu015.cco6.facebook.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6EB1F1BE4CF
X-Rspamd-Action: no action

On Fri, Feb 27, 2026 at 03:48:07PM -0400, Jason Gunthorpe wrote:
> > > I actually would like to go the other way and have VFIO always have a
> > > DMABUF under the VMA's it mmaps because that will make it easy to
> > > finish the type1 emulation which requires finding dmabufs for the
> > > VMAs.
> 
> This is a still better idea since it avoid duplicating the VMA flow
> into two parts..

I suppose this would also compose with your idea to use dma-buf for
iommufd_compat support of VFIO_IOMMU_MAP_DMA of vfio device fd-backed mmap()s
[1]? Instead of needing to materialize a new dma-buf, you could use the existing
backing one?

[1] https://lore.kernel.org/all/20260108141044.GC545276@ziepe.ca/

