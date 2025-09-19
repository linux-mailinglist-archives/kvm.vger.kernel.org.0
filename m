Return-Path: <kvm+bounces-58159-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D6336B8A86B
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 18:13:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A62F7E6B49
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 16:13:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E04CB31E8B4;
	Fri, 19 Sep 2025 16:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="Y+1gpdoS"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6571B246BD5;
	Fri, 19 Sep 2025 16:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758298429; cv=none; b=Tzn+KOcuinSqojKte5wWnBCumvxiblkuYrzJhMHDXBxE3IsIdXacVoBvjwXH8cTO6GjowjZD6bWpTnQXtRZ8HesjqdOA50Qdp4BXgUhvg7G9AHc2GOnrJj9bBtPbX5ItTcmR07CQ/HsOYaWoDnYaNg2O6iOurFf/7bZX6d+ahwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758298429; c=relaxed/simple;
	bh=a01/WuiqsmUPYQDo90c3KQ8E5JyseCbU2oqdf6tNpA0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mnpiFlz2s6R2OHbul9EC3mCpdJ+Lx1o2ydHqjxJ9J5dIrukXjlkyeYdjSjaguzfEDxhgHgecl26sRryOeT54mMC+rZNtIf/4wuQE/t8UobeLGLHIPyK8gS58f/15Y901GOuu5aZoJ8u2DOdKNSA8cbEVS+b/O4NTBXd/2la1zqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=Y+1gpdoS; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 58JFp6Gs3066589;
	Fri, 19 Sep 2025 09:13:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=aAllSrnqZisLS07gqezEwcAKect5ROM5XcljCmR6PwM=; b=Y+1gpdoS0kw2
	bt1+sUeZAxOm7z4J2tGSRluSJUIaq69IHAnismP48eujJhod5NpVp4U5IjpPxyLd
	/4URnKspPCzEQusjv7vxCtlIRRUnBbCQ+94qbmiLR+jCDELO6KEk+Tt/f8ZOXnSf
	TjiU6mMX/KAC0PAKqoH6y1GmVcuIcjKTGEi/1CeVfjrCq9SzNa4J0Z7jbXtJlWO8
	jTOKSfVx8lHnDrPPUkJHvSx0y1lkF3AQuYQ5XtzB5ugq4Voowhe5J62HRWK0mYaw
	9VIOjvl+fTh4VtvkQRD7lC0NSY2zpva20wvrt+NFfanCbqd+AAp58ji3BTwyNtPD
	apQeU0RcdA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by m0089730.ppops.net (PPS) with ESMTPS id 499a6905y7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Fri, 19 Sep 2025 09:13:19 -0700 (PDT)
Received: from devgpu015.cco6.facebook.com (2620:10d:c0a8:1b::8e35) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Fri, 19 Sep 2025 16:13:17 +0000
From: Alex Mastro <amastro@fb.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: Alex Mastro <amastro@fb.com>,
        Alex Williamson
	<alex.williamson@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Bjorn
 Helgaas" <bhelgaas@google.com>, David Reiss <dreiss@meta.com>,
        Joerg Roedel
	<joro@8bytes.org>, Keith Busch <kbusch@kernel.org>,
        Leon Romanovsky
	<leon@kernel.org>, Li Zhe <lizhe.67@bytedance.com>,
        Mahmoud Adam
	<mngyadam@amazon.de>,
        Philipp Stanner <pstanner@redhat.com>,
        Robin Murphy
	<robin.murphy@arm.com>,
        Vivek Kasireddy <vivek.kasireddy@intel.com>,
        "Will
 Deacon" <will@kernel.org>, Yunxiang Li <Yunxiang.Li@amd.com>,
        <linux-kernel@vger.kernel.org>, <iommu@lists.linux.dev>,
        <kvm@vger.kernel.org>
Subject: Re: [TECH TOPIC] vfio, iommufd: Enabling user space drivers to vend more granular access to client processes
Date: Fri, 19 Sep 2025 09:13:04 -0700
Message-ID: <20250919161305.417717-1-amastro@fb.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250918225739.GS1326709@ziepe.ca>
References:
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=eNkTjGp1 c=1 sm=1 tr=0 ts=68cd811f cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=5m1aJF6OL82OVurx2oYA:9 a=WdnvUy4J-PgA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE5MDE1MiBTYWx0ZWRfX0GSHjZFbKmAN
 eNF9ptCC/VJ9e3VBN59GV6nmr+AvUkEcZ+nX/D7K1DM6YWHswhnhY5ytzvSANnBsxt0XIEWvABL
 SPytR91wZ30CZSpI0CmlZP0FMFPz0yEjh198wAuLx1ewJxlCg0M1HBzIHaxcZoUlBdcJqeEHNn2
 /8g1RanowXjKK/DeAclxwLzye/ffwG42V5xl7c9BsldcqWydvNq1iy3/Qh+hXLixJkIgVj7BGno
 SW3oucumns4a72SRqmaHvWAsZlhMWjRJ4tm569+7D2A44QglY62nXMZ+Dl2qdf10jNBlBqJiBk9
 mz3+ZYXWEsnT+AwLbEzM3qljNPZXTLD6GnodOrL6zto3cZB8bavh/pgsLeLhJM=
X-Proofpoint-GUID: Wp5Bc7YAGUILxFveuucvAxklipT02cPE
X-Proofpoint-ORIG-GUID: Wp5Bc7YAGUILxFveuucvAxklipT02cPE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-19_01,2025-09-19_01,2025-03-28_01

On Thu, Sep 18, 2025 at 07:57:39PM -0300, Jason Gunthorpe wrote:
> I'm having a somewhat hard time wrapping my head around the security
> model that says your trust your related processes not use DMA in a way
> that is hostile their peers, but you don't trust them not to issue
> hostile ioctls..

Ah, yea. In my original message, I should have emphasized that vending the
entire vfio device fd confers access to inappropriate ioctls *in addition to*
inappropriate BAR regions that the client should be restricted from accessing.

Assuming we make headway on dma_buf_ops.mmap, granting a client process access
to a dma-buf's worth of BAR space does not feel spiritually different than
granting it to a peer device. The onus is on the combination of driver + device
policy to constrain the side-effects of foreign access to the exposed BAR
sub-regions.

Please let me know if I misunderstood your meaning.

> IIRC VFIO should allow partial BAR mappings, so the client process can
> robustly have a subset mapped if you trust it to perform the unix
> SCM_RIGHTS/mapping ioctl/close() sequence.

Yes -- we already do this today actually. The USD just tells the client "these
are the specific set of (offset, length) within the vfio device fd you should
mmap". Those intervals are slices within BARs.

> > > Instead of vending the VFIO device fd to the client process, the USD could bind
> > the necessary BAR regions to a dma-buf fd and share that with the client. If
> > VFIO supported dma_buf_ops.mmap, the client could mmap those into its address
> > space.
> 
> I wouldn't object to this, I think it is not too complicated at all.

That's encouraging to hear! Thank you.

> What I've been thinking is if the vending process could "dup" the FD
> and permanently attach a BPF program to the new FD that sits right
> after ioctl. The BPF program would inspect each ioctl when it is
> issued and enforce whatever policy the vending process wants.

This seems totally reasonable to me.

> What would give me alot of pause is your proposal where we effectively
> have the kernel enforce some arbitary policy, and I know from
> experience there will be endless asks for more and more policy
> options.

Agreed. If we can engineer BPF to be able to interact with those ioctls to hoist
these kinds of policy decisions up into user space, I can't argue with that.

> I don't think viommu is really related to this, viommu is more about
> multiple physical devices.

Ack. I wasn't sure how much to read into the "representing a slice of the
physical IOMMU instance" comment [1].

[1] https://docs.kernel.org/userspace-api/iommufd.html

Thanks,
Alex

