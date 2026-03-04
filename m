Return-Path: <kvm+bounces-72739-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KHL7D8yDqGmYvAAAu9opvQ
	(envelope-from <kvm+bounces-72739-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 20:11:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D9CA206F19
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 20:11:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 1729830074FD
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 19:11:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FC1B3DBD57;
	Wed,  4 Mar 2026 19:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="LvnJ1DXX"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D313DBD4D;
	Wed,  4 Mar 2026 19:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772651455; cv=none; b=IQNLBnnJVFJkt8vMY7Tp4pLwmAzoKfAG/JWjY+JaYPshGSlcmA5bqvyBgKJD1Vnl0F8uQSUUi9w2rwaBOZZOUaflpwiy+ydGbAvsVVTxoJ5N9dMQ0WrNy8c+uTbVWpMGZN0fiwk9WnAb+tn8JlZQ2y73D7Cr9sWm3ALILprxEbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772651455; c=relaxed/simple;
	bh=DShci9XokdZ/NSZG3qSKubY4POB9Zt7DHcGtyJIHcyU=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U/lWY08JPcKKG0irSbPwSZbW5kQkG4fnRJiEBVHTrusjuWrTI45rEsqZmvC7VDXuCuEustAn9UCPtuvpKdb7nmNmswJfm0SDSqfLM5i7WCZJPGqPLmJZavjt+GXpUtSewulWuBMD5Y+/EE6ZH8IGtW5fJxvGRQYQ+PkKxiQAsnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=LvnJ1DXX; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 624IstYf4087897;
	Wed, 4 Mar 2026 11:10:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=s2048-2025-q2; bh=4VIoQUgKhaCGNe4dOfVc
	ABTgqAfP4dCv/z5W44lfqe0=; b=LvnJ1DXXPIQPBEK4aDif/Zf6xd9c6MzqZ+9t
	F4ciYZOnZ4PPACxtaaiRpI8zIJ6Wn6rPxgDVKZt8I/h2N8voaPrrMm374DfMSTcW
	PVUJ1/xHOxwl6M6Y8hgjiTDKS5AhNwLCWNB/+RED6+ytmp90yHLti3IjA9EDwscr
	hm0a961arDytLHD4ak+xyffhXZmYZ0dZ1FGFhjs+EffJRQHx52U+zZNokW3xJQRG
	mPMopPKPMU0VfRfNpP9ootyLz9qr/0BTZvzle+zQAWr+1ob5LPc31VwnSp6HRkxG
	iGmRF6xRN2d28kxbKhK+gsgeL+hloVnv9wHPqRXQxG9XYCYhiA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4cp9sktute-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 04 Mar 2026 11:10:39 -0800 (PST)
Received: from devgpu015.cco6.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.35; Wed, 4 Mar 2026 19:10:38 +0000
Date: Wed, 4 Mar 2026 11:10:34 -0800
From: Alex Mastro <amastro@fb.com>
To: Yao Yuan <yaoyuan@linux.alibaba.com>
CC: Alex Williamson <alex@shazbot.org>, David Matlack <dmatlack@google.com>,
        Shuah Khan <shuah@kernel.org>, <kvm@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfio: selftests: fix crash in vfio_dma_mapping_mmio_test
Message-ID: <aaiDqjTw4U/h4rPw@devgpu015.cco6.facebook.com>
References: <20260303-fix-mmio-test-v1-1-78b4a9e46a4e@fb.com>
 <vps7in2ph6yyb2vl3zuxie7sp2cyzh4endrvdsdjgtqhjxvoqp@po4m7zddafi5>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <vps7in2ph6yyb2vl3zuxie7sp2cyzh4endrvdsdjgtqhjxvoqp@po4m7zddafi5>
X-Authority-Analysis: v=2.4 cv=Bo2QAIX5 c=1 sm=1 tr=0 ts=69a883af cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=kj9zAlcOel0A:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=7x6HtfJdh03M6CCDgxCd:22 a=03ozwUkBphtHgyqjj1sw:22 a=FOH2dFAWAAAA:8
 a=SRrdq9N9AAAA:8 a=flx_U1IVvj_B2srRCewA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: -zRj14eHqtrATpXnV74I4WMEFMN3L4KN
X-Proofpoint-GUID: -zRj14eHqtrATpXnV74I4WMEFMN3L4KN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA0MDE1NiBTYWx0ZWRfXzL2pTzbTzcMI
 GCG4bbepWQCqMhaSMElVp46eMDB+Me+FZGvPOzvP/fslkvohdznqZAQvWt2hP/52uSgDf+u9eO5
 Z4QdpsxaZXnztKm+u6adn7IMohWGJ3aS/Lclmf8NWDtAAJwLwvekQScZzzaSjeMeezedJ8PP045
 0kNHX1Uh8UBLGSBo0mda16M38jDf2VUY2X5/owyIC6CrJVPDK7PCnAh+GsdsOdL+FgyM4qW0xqj
 6g/mfcR7tICUtsSeI/nRxFM3w3eggPFz3hzZLS1AZwiuj5LaP5PinaDiX9hdHnMkp/Oj0oKiK4X
 CO0ZDJbRx21nK0ev6wokncqeAzjYTdGQL4a/dbH7yeIh39sEs12L8mT6EE0haHSBGpPxXGvpQ+X
 bF40fdBVgIVIXsUYCrsM2a9OWRSnyXfV1b2QrsJzsG3RYnHZTwa0AkMpkNg8UU2fDhch+uY7/+T
 tOAX9EyBuU2zMvDA39A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-04_07,2026-03-04_01,2025-10-01_01
X-Rspamd-Queue-Id: 3D9CA206F19
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[fb.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[fb.com:s=s2048-2025-q2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[fb.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72739-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[amastro@fb.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,alibaba.com:email,fb.com:dkim,fb.com:email]
X-Rspamd-Action: no action

On Wed, Mar 04, 2026 at 08:47:15AM +0800, Yao Yuan wrote:
> On Tue, Mar 03, 2026 at 11:46:24AM +0800, Alex Mastro wrote:
> > Remove the __iommu_unmap() call on a region that was never mapped.
> > When __iommu_map() fails (expected for MMIO vaddrs in non-VFIO
> > modes), the region is not added to the dma_regions list, leaving its
> > list_head zero-initialized. If the unmap ioctl returns success,
> > __iommu_unmap() calls list_del_init() on this zeroed node and crashes.
> >
> > This fixes the iommufd_compat_type1 and iommufd_compat_type1v2
> > test variants.
> >
> > Fixes: 080723f4d4c3 ("vfio: selftests: Add vfio_dma_mapping_mmio_test")
> > Signed-off-by: Alex Mastro <amastro@fb.com>
> > ---
> > The bug was missed because the test was originally run against a kernel
> > without commit afb47765f923 ("iommufd: Make vfio_compat's unmap succeed
> > if the range is already empty"). Without that fix, the unmap ioctl
> > returned -ENOENT, taking the early return before list_del_init().
> > ---
> >  tools/testing/selftests/vfio/vfio_dma_mapping_mmio_test.c | 1 -
> >  1 file changed, 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/vfio/vfio_dma_mapping_mmio_test.c b/tools/testing/selftests/vfio/vfio_dma_mapping_mmio_test.c
> > index 957a89ce7b3a..d7f25ef77671 100644
> > --- a/tools/testing/selftests/vfio/vfio_dma_mapping_mmio_test.c
> > +++ b/tools/testing/selftests/vfio/vfio_dma_mapping_mmio_test.c
> > @@ -100,7 +100,6 @@ static void do_mmio_map_test(struct iommu *iommu,
> >  		iommu_unmap(iommu, &region);
> >  	} else {
> 
> Hi Alex,
> 
> >  		VFIO_ASSERT_NE(__iommu_map(iommu, &region), 0);
> > -		VFIO_ASSERT_NE(__iommu_unmap(iommu, &region, NULL), 0);
> 
> This is the more simply way to work w/ or w/o commit
> afb47765f923 ("iommufd: Make vfio_compat's unmap succeed if
> the range is already empty"), may worth to add this point
> into the commit message.

True, but afb47765f923 was already in the vfio tree at the time the new test
was added in 080723f4d4c3. It was just (my own) negligence that I didn't run
the selftests against <current kernel>. I wrongly assumed that running the
selftests against an older kernel that I happened to have installed on my box
was good enough.

> 
> For the changes:
> 
> Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>

Thank you!

> 
> >  	}
> >  }
> >
> >
> > ---
> > base-commit: 96ca4caf9066f5ebd35b561a521af588a8eb0215
> > change-id: 20260303-fix-mmio-test-d3bd688105f3
> >
> > Best regards,
> > --
> > Alex Mastro <amastro@fb.com>
> >

