Return-Path: <kvm+bounces-62412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 59487C43709
	for <lists+kvm@lfdr.de>; Sun, 09 Nov 2025 02:20:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F0CA2188B36F
	for <lists+kvm@lfdr.de>; Sun,  9 Nov 2025 01:21:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB10E1A3029;
	Sun,  9 Nov 2025 01:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="Q8UFLoT5"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ACCFDF59;
	Sun,  9 Nov 2025 01:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762651237; cv=none; b=jyfEbFFxYna6f1TFc8/Fg54Nh3qPtS+qq8jyjqZyYRxd7e9E87EIeW4MApwCwfqxc6YqJTcctnNNZcT4CBv5fbRs+bKmxFEWr0CfWvJ6mfEOPHkbz2DiFVg+CL23DymcD9r7xJyJKov3EOUD/8Ie0v0Pv++KZeSPNfFDhJMEbGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762651237; c=relaxed/simple;
	bh=yl709K2/EBaiSPbcl7V+o9B/u6yVKPr1BkggrDZSyhY=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iecCPPpaOXaAi9CDbodbT7n2CAAieTEzWfGulf1NKNu+Zk9wa/mDSK5AUePVi9zaNP9MDSn7fqfvJM1NG3xovl6/tBFskKyBgOBaMiVsoW1d6OKE9a0GHqkW/laLcON7HAt3DpgQsIj/fk1jlG0/sLQbqGSnxPgg04l4ZKyaPCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=Q8UFLoT5; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5A8MPlr54180894;
	Sat, 8 Nov 2025 17:20:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=s2048-2025-q2; bh=4WQMv/utZqIebRrgDmAQ
	C4G7cEEZTYQHPc1QJPVNWUc=; b=Q8UFLoT5eAk+tvwdXkdGapgJkuH9cSxHpyvl
	85Nz1p4gHbeJyM1BPDsXvdXs5fyIYmfnDszNWYTdPfkphzeLtrTJn/xT6Yjfm/gL
	wQIxLBpwPY4CWx/IVhCMHjs2annlFva4iDKJS38OWS+UW7xpYf1amjhPPtkSjKGd
	POaIEFCoc3J2ro6gkb26LEDaxr3rkJJTWpF0xwj0qK8NNy4S2GejmJylexWr5uJu
	+/jzhbsXni25CWDTOqmmxcausgscmxDoTA5DXxE/XMilJg+HMyq8SW8AZi/r+pQu
	XAMSdV1JZh3R4PeKi4PG1ZmzYvU074xvI+bqTzTQQyGRWOJ6iA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4aa2s34mq7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sat, 08 Nov 2025 17:20:28 -0800 (PST)
Received: from devgpu015.cco6.facebook.com (2620:10d:c0a8:1b::2d) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Sun, 9 Nov 2025 01:20:14 +0000
Date: Sat, 8 Nov 2025 17:20:10 -0800
From: Alex Mastro <amastro@fb.com>
To: Alex Williamson <alex@shazbot.org>
CC: David Matlack <dmatlack@google.com>,
        Alex Williamson
	<alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfio: selftests: Skip vfio_dma_map_limit_test if mapping
 returns -EINVAL
Message-ID: <aQ/sShi4MWr6+f5l@devgpu015.cco6.facebook.com>
References: <20251107222058.2009244-1-dmatlack@google.com>
 <aQ6MFM1NX8WsDIdX@devgpu015.cco6.facebook.com>
 <aQ+l5IRtFaE24v0g@devgpu015.cco6.facebook.com>
 <20251108143710.318702ec.alex@shazbot.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251108143710.318702ec.alex@shazbot.org>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA5MDAwOSBTYWx0ZWRfX52BcyYTlebrR
 dxM21h/hDXhD6D16mZo+NZ9GitbxB+GKabhAejP7JNHTs3p/sFye+k/+qC7VSzjKakLOD97idUw
 jirJopCuamR1ja7k3Gk8KMc+4vRjDWR53zKj0oME5lgWjbaOAm1gRrncGOfJroqvr7gD+04w5Hg
 h8te6Uej+RaOhpZOJeIIt5xv44rluPshqG3UCZLHlIy+gyxKmXkswZeRBYbAT6hfAgoObxbKLEY
 RBx/GUMG/hV++Rlr2ROShzifsgjW4O/XioF6NbAWv+J+y1qPzp+755TXf9brXDI026RH5YR4E/O
 jBuTJK7mhdpXkkZ2pDhYv3Fat6RfRHJQdjnlbOk0/PnNzO2lMhLmjdhxdZo+o0VyIQtGDQFZDUo
 lKui4E2yrguDQRj6Ha2nygy0KYyryw==
X-Authority-Analysis: v=2.4 cv=LoCfC3dc c=1 sm=1 tr=0 ts=690fec5c cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=kj9zAlcOel0A:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=r1p2_3pzAAAA:8 a=FOH2dFAWAAAA:8 a=KLQ7IMvFttoUVMJHvGgA:9
 a=CjuIK1q_8ugA:10 a=r_pkcD-q9-ctt7trBg_g:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: i3kzQWJ9M9xbcUPXOqI5FU_vG3PvuBZz
X-Proofpoint-GUID: i3kzQWJ9M9xbcUPXOqI5FU_vG3PvuBZz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-09_01,2025-11-06_01,2025-10-01_01

On Sat, Nov 08, 2025 at 02:37:10PM -0700, Alex Williamson wrote:
> On Sat, 8 Nov 2025 12:19:48 -0800
> Alex Mastro <amastro@fb.com> wrote:
> > Here's my attempt at adding some machinery to query iova ranges, with
> > normalization to iommufd's struct. I kept the vfio capability chain stuff
> > relatively generic so we can use it for other things in the future if needed.
> 
> Seems we were both hacking on this, I hadn't seen you posted this
> before sending:
> 
> https://lore.kernel.org/kvm/20251108212954.26477-1-alex@shazbot.org/T/#u
> 
> Maybe we can combine the best merits of each.  Thanks,

Yes! I have been thinking along the following lines
- Your idea to change the end of address space test to allocate at the end of
  the supported range is better and more general than my idea of skipping the
  test if ~(iova_t)0 is out of bounds. We should do that.
- Introducing the concept iova allocator makes sense.
- I think it's worthwhile to keep common test concepts like vfio_pci_device
  less opinionated/stateful so as not to close the door on certain categories of
  testing in the future. For example, if we ever wanted to test IOVA range
  contraction after binding additional devices to an IOAS or vfio container.
- What do you think about making the concept of an IOVA allocator something
  standalone for which tests that need it can create one? I think it would
  compose pretty cleanly on top of my vfio_pci_iova_ranges().

Alex

