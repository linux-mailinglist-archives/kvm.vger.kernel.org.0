Return-Path: <kvm+bounces-72233-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QLtPLScUomk0zAQAu9opvQ
	(envelope-from <kvm+bounces-72233-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 23:01:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 247011BE56C
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 23:01:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F06E43069679
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 22:01:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 654233A1A2A;
	Fri, 27 Feb 2026 22:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="Vt6Dfnbw"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449931D5151;
	Fri, 27 Feb 2026 22:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772229662; cv=none; b=MECLntBCNllZsswyFQHJv46bhpBEUc3LttAzmQv+Hh0HHRi/ZssYHKMhbPYCMryVy+ThE1w4R2RNbFEtKFFEF5XE1Y8ctHQOGzUtc3Te7dClgLRBkwr0WEsvJKRIgIggySOxpyM0YnQr60othRQygDRG/DxwbLxF/5/FseNXPqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772229662; c=relaxed/simple;
	bh=QnMmAnkNqwhzUh1goVF/03uL2RLz03jmT1quIHusbiU=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JjzYRs1GSlI2s5IGR0RfrfDexFp6P32GNFw2T4+keyVA0yT5h0YwWmYVg/Y1n+ZgaAQDgzlERGIoZLtq/0x5qdZYoZqh+zuKfnhOW1ffPPwzkUU4UEs4kaSB5xe2PSGFRwtMkjhS+PjUiEXDFtYvoAZ8B4ry90f+QQnS4ETsFX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=Vt6Dfnbw; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61RLFT4w330942;
	Fri, 27 Feb 2026 14:00:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=s2048-2025-q2; bh=HAR+YwHCQEx8FQPFwnPF
	8kbIEZCPvpG17d9RDjMoOD0=; b=Vt6Dfnbwa02wdLXXsDppEs3aB3zzTXE3fpnW
	siKptPO0oMgFOBjl8hkKLdG8P3W9E8m8w14qsnZynGnMklAliAxrBZCIQMtGB/QF
	uc5Z2zMoxF1gS7HQGHeIzF6Qw2etqxp0fT43WN1FIC0DsFGHFyzayOlzny4J/C22
	EjA3pSYTDPkANsqG2PTwCkt9HOT0MNI0NVhqVdag5xCmNx5WecdUArBntUrDCQIS
	H/iFwWtDXqjGnRbocne31okPRty8nHj8Py8iIVrykuOxHa5OIqSGTI8RoWzn4l6r
	iDFWyDFZYd8RLgE3Joy7ozAJ38+LIegSrIhML2O3IpU2WN3AiA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4ckfq4at00-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Fri, 27 Feb 2026 14:00:45 -0800 (PST)
Received: from devgpu015.cco6.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.35; Fri, 27 Feb 2026 22:00:43 +0000
Date: Fri, 27 Feb 2026 14:00:38 -0800
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
Message-ID: <aaIT9SmOAOF4Jjy1@devgpu015.cco6.facebook.com>
References: <20260226202211.929005-1-mattev@meta.com>
 <20260226202211.929005-4-mattev@meta.com>
 <90bd4185-1e87-4393-b9e1-1318a656a7d9@amd.com>
 <20260227125109.GH5933@nvidia.com>
 <c5a8f318-20af-4d80-a279-2393192108c3@meta.com>
 <20260227194807.GL5933@nvidia.com>
 <aaISD4mw1XzQl1S8@devgpu015.cco6.facebook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aaISD4mw1XzQl1S8@devgpu015.cco6.facebook.com>
X-Authority-Analysis: v=2.4 cv=RYqdyltv c=1 sm=1 tr=0 ts=69a2140d cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=9jRdOu3wAAAA:8 a=V06E79E7ZWWwZtoFcR4A:9 a=CjuIK1q_8ugA:10 a=zZCYzV9kfG8A:10
 a=ZE6KLimJVUuLrTuGpvhn:22
X-Proofpoint-GUID: 6QWGOPFSRTQAgV1H-lPBFelJW9RsIEhM
X-Proofpoint-ORIG-GUID: 6QWGOPFSRTQAgV1H-lPBFelJW9RsIEhM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI3MDE5NSBTYWx0ZWRfX8JJtLCQXqeDW
 AUzmo75nyZ+mC2q0y1ZkuWh6Vih1BgaEYz+KoOm9UZsBQwdkvBAwKkVjJ+WDFNxFZXPO8Lxvg0o
 d8mFLjSnq1W3fVfJKwe2IGfRFTivKq0D5OH3nnl2ZwknXpqbeYtg+C691OLckIfU++wZ7vpbngr
 PcFmeti+s/zACqPyqtPM8OEwhq2JdTEWQAz8SuxbCvHI234aNnysOHkFDS7cy9uLN7eE+McmyAK
 /B/oK6ZxZ0S4mmu6zsk6KCvjuaCjkABlrduoBn3OmQRFlOhrtVG4PNjDOQtos5ztGYThO/rhyVN
 wAnxk69WbRZOzVEU2T7lPCXGIrLZ+xgVEUki31v2dnkREcGJWBFmE50t/WruwkKkc7sWwG8sgfA
 Wa5bP4bo3iwfnrz9LKMGxXImpSN+niUT3jdVabBrAZz+RVnPrTivlzIgkHXwxKuHRkBQhibkTxU
 r5qZnRjlPV+36v677YA==
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
	TAGGED_FROM(0.00)[bounces-72233-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[fb.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,devgpu015.cco6.facebook.com:mid]
X-Rspamd-Queue-Id: 247011BE56C
X-Rspamd-Action: no action

On Fri, Feb 27, 2026 at 01:52:15PM -0800, Alex Mastro wrote:
> On Fri, Feb 27, 2026 at 03:48:07PM -0400, Jason Gunthorpe wrote:
> > > > I actually would like to go the other way and have VFIO always have a
> > > > DMABUF under the VMA's it mmaps because that will make it easy to
> > > > finish the type1 emulation which requires finding dmabufs for the
> > > > VMAs.
> > 
> > This is a still better idea since it avoid duplicating the VMA flow
> > into two parts..
> 
> I suppose this would also compose with your idea to use dma-buf for
> iommufd_compat support of VFIO_IOMMU_MAP_DMA of vfio device fd-backed mmap()s
> [1]? Instead of needing to materialize a new dma-buf, you could use the existing
> backing one?
> 
> [1] https://lore.kernel.org/all/20260108141044.GC545276@ziepe.ca/

Sorry, I can't read. That's literally what you said!

