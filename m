Return-Path: <kvm+bounces-60829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 730FBBFCA1A
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 16:46:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 908D0627718
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 14:29:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DFE730217D;
	Wed, 22 Oct 2025 14:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="QJVVHnS5"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5097C345749
	for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 14:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761143106; cv=none; b=mOFzNDva6UpoHYpNiwIJL9rDhnC9hF7c8RLYHAmlzaFs1EOKI5eXVSSvjfapmLdaqzKxfyB/llw+DGKMF2NN0D74h+N2UITHRittVO3ODlJuF043D8ez89KraHnEpS02KRqJ5umnIk2TjCoKRVXeOn9evy9mOrdsdUgJ86HdWUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761143106; c=relaxed/simple;
	bh=MjgHzsGA+WKFYBJMcOubn2pYaMOqdZc+DCEBUL2CsWA=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sgZTNloTFdXgvPcfYs1kIOQOLkCT1NedNsvzt9hpfvQPOSWrKwpVNXGfaau9X8S5DxhygiPCAyFPb6uxRPrjcejnl5H3T3hXndK7vCIyXjzJTZJpUpDFr66tRJve+AfhHaHgJuXLfBTDLDG14oTgHwxUhgSzufhvJI74KqxQnfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=QJVVHnS5; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59M56XcA1667206
	for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 07:25:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=s2048-2025-q2; bh=yuwdSWCyrURvkAB0e1mP
	UZf2LmUqrOdvgVebOzznUKQ=; b=QJVVHnS5JkvHuYL8s83xtYm3IJWhE/Ftm12S
	tDDyev1O9nuNK8DP0ZH1n6HSSXuxwMqmbA5zr8IXSSfte6HOVB0QUhTO1fPuW4q6
	SPM8HgqyWH+zoQxabQZNCDv0J0WGC1O1FtXE/qL1qlvepxDHysNlKV+URnzeQ8V8
	0ZM0ge8R35vCnW8m79/811RDZQxVjqwUJ63TFvw0H+c+UFwNo/nx1c6uzeOFb6Mu
	FCupVh+26XDE3slQMlNZPcQBIvFi8N6dXR0cI5S9Nomifnv0M4yZCbW+SkSK93lE
	PIPu+1oXSdmMQU3XQ0iMazIYnakRcMEHy0ToVUaMkEisFmXihg==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 49xrtrbbcm-12
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 07:25:03 -0700 (PDT)
Received: from twshared71707.17.frc2.facebook.com (2620:10d:c0a8:1b::8e35) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Wed, 22 Oct 2025 14:24:56 +0000
Received: by devgpu012.nha5.facebook.com (Postfix, from userid 23751)
	id 49A9458E123; Wed, 22 Oct 2025 07:24:54 -0700 (PDT)
Date: Wed, 22 Oct 2025 07:24:54 -0700
From: Alex Mastro <amastro@fb.com>
To: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
CC: Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe
	<jgg@ziepe.ca>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3/3] vfio/type1: handle DMA map/unmap up to the
 addressable limit
Message-ID: <aPjpNh/f8n9yYk/U@devgpu012.nha5.facebook.com>
References: <20251012-fix-unmap-v4-0-9eefc90ed14c@fb.com>
 <20251012-fix-unmap-v4-3-9eefc90ed14c@fb.com>
 <87d60dcd-972c-4ab6-aa6c-0d912a792345@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87d60dcd-972c-4ab6-aa6c-0d912a792345@oracle.com>
X-FB-Internal: Safe
X-Proofpoint-GUID: 4Y-y2vK7MJjZLRkXJc73iMLqHoDA1v9z
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIyMDExOCBTYWx0ZWRfX3fPhuyzgbBgS
 rxXl3Ei+esg3D8mf29x0xFkhkHYVu1NWSf3O6KAtAcQpmRDcDjsqlUQC9GDgKjVTFOsUQrcAFC5
 GuoiWWw27r2vt5W9QF0tZ3ylz448Y4tLOpes4IWE4PzqjV8VDEWDmjujjz3h2a9+F/QvIAT73HT
 3x8K1oBbK6NO1kMBVfNMoo8AhMmCdSBCU524Agx85pbTAZJGdgEMXdq5j9xCHPuwUMOl3OcQCoB
 G9i7jOu1wd/p1zrfUrlcdom44BgSusWXrxZyYBxzy/zecwR+pcXSMF52MJxDH71PN4H7TdNa2GT
 w5hoSmzA9KBrT6m1hSqtwX79nOZPvjprW0kX43kMdBcZhSyQuDrWJATG5mx8Pc6wTrw77/b/bAF
 VRw+F6LbkhaG5qdy1mwsEkG95eeVpQ==
X-Authority-Analysis: v=2.4 cv=CZMFJbrl c=1 sm=1 tr=0 ts=68f8e93f cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=kj9zAlcOel0A:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=7wtgGtFo6pcdWUsKYVMA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: 4Y-y2vK7MJjZLRkXJc73iMLqHoDA1v9z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_06,2025-10-13_01,2025-03-28_01

On Tue, Oct 21, 2025 at 06:18:00PM -0400, Alejandro Jimenez wrote:
> @@ -210,11 +215,13 @@ static void vfio_link_dma(struct vfio_iommu *iommu, struct vfio_dma *new)
> >   	struct rb_node **link = &iommu->dma_list.rb_node, *parent = NULL;
> >   	struct vfio_dma *dma;
> > +	WARN_ON(new->size != 0);
> > +
> >   	while (*link) {
> >   		parent = *link;
> >   		dma = rb_entry(parent, struct vfio_dma, node);
> > -		if (new->iova + new->size <= dma->iova)
> > +		if (new->iova <= dma->iova)
> It is possible I missed a previous thread where this was already discussed,
> but why are we adding this new restriction that vfio_link_dma() will
> _always_ be called with dma->size = 0? I know it is the case now, but is
> there a reason why future code could not try to insert a non-zero sized
> node?

Perhaps the WARN_ON is too coddlesome, but given that this helper is used for
exactly one purpose today, the intent is to strongly hint to a future user to
consider what they're doing by deviating from the current usage.

iommu->dma_list's invariant is that all elems should have non-overlapping iova
ranges, which is currently enforced pre-insertion in vfio_dma_do_map by the
vfio_find_dma check. After vfio_pin_map_dma returns, either the vfio_dma has
been grown to its full size, or has been removed from iommu->dma_list on error
via vfio_remove_dma.

> I thought it would be more fitting to add overflow protection here too, as
> it is done for other code paths in the file? I know the WARN_ON() above will
> make us aware if there is ever another caller that attempts to use size !=0,
> so this is more of a nit about consistency than a concern about correctness.

The other code paths which check for overflow focus on sanitizing args at
the vfio_iommu_driver_ops boundary. Since this helper is downstream from those
existing checks, and given its specificity, I'm not sure additional checks here
would be helpful.

