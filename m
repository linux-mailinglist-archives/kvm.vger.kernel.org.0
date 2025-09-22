Return-Path: <kvm+bounces-58400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 19305B9278B
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 19:48:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C8629444850
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 17:48:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40E103168EB;
	Mon, 22 Sep 2025 17:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="UdeUtPI3"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E248634F;
	Mon, 22 Sep 2025 17:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758563285; cv=none; b=MsG648mnju9j4PbuhffVoU5VZVHYa0TJFbFj0ei46bKqF9P4h3AmvXWY2gTBq4UMRnxX630+Y2fg1hd+h3UYmIzVNP+sa58dHF9X82Y6VuWc3wDgh900ss6DEGeVrR9+HDDiQq6iGspVd2/tNrBMfd3ml9F3eKyqKViegd5eJtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758563285; c=relaxed/simple;
	bh=R7eGuMphMZdM9G9yDE66sOhkKsZHxPwK1/ibT7GQtoQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qmEuu7VsKDnFzSd7S058X7+dD9iLN+FnuVZhVz+KNvoqhbBqRGNybi7/rM7zCAXla4MzGenKKcgZCQFRxY3wUGNls8YDO2sSSvz0MT6J/vtDdk2FXdFkIu6ySRKV/klV8r5dLwjMJ/cblHhpK4xzBl1iuRopeONKgp/kggc3ae0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=UdeUtPI3; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 58MHlScH3536413;
	Mon, 22 Sep 2025 10:47:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=ytmqrYllnckBp3jLuSpyiNO6eg2YDuOo7gf0z7lcOCE=; b=UdeUtPI3UYfj
	mD86N/7xbdKqUWyl7K+e2X07mkThaGx3KFF7XSLfL4WzVr7soMvwyEfWXIjBn9go
	nfKq4EMCnhngXK9QjBh1Bd+YZ2b7yc3EnnKrN6ljgb1BS54DPQQIZIZXk3V+LILx
	POlWoObsWYixysUFEL0AGch6bHafdGjYxZL4SnGCN4yB9eMM/H0hbqVYnF+sE9Gq
	tcQpPtVbDbBPPjH6Vr6T6Gyxv8fSuUy5E4vnjAkqt7FXT7lykBEqUkp88ma/ITdj
	nVmxVdKWOeOHSrTko5LyB/4rFKzv7ECoPYSfL7fdm/sAqHFBSq7Dteg/2AHqX4uf
	CgQMg7Pzwg==
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0089730.ppops.net (PPS) with ESMTPS id 49bb5tg02m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 22 Sep 2025 10:47:39 -0700 (PDT)
Received: from devgpu025.eag6.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Mon, 22 Sep 2025 17:47:36 +0000
From: Alex Mastro <amastro@fb.com>
To: Mostafa Saleh <smostafa@google.com>
CC: Alex Mastro <amastro@fb.com>, "Tian, Kevin" <kevin.tian@intel.com>,
        "Keith
 Busch" <kbusch@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Alex Williamson
	<alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "David
 Reiss" <dreiss@meta.com>,
        Joerg Roedel <joro@8bytes.org>, Leon Romanovsky
	<leon@kernel.org>,
        Li Zhe <lizhe.67@bytedance.com>, Mahmoud Adam
	<mngyadam@amazon.de>,
        Philipp Stanner <pstanner@redhat.com>,
        Robin Murphy
	<robin.murphy@arm.com>,
        "Kasireddy, Vivek" <vivek.kasireddy@intel.com>,
        "Will
 Deacon" <will@kernel.org>, Yunxiang Li <Yunxiang.Li@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
Subject: Re: [TECH TOPIC] vfio, iommufd: Enabling user space drivers to vend more granular access to client processes
Date: Mon, 22 Sep 2025 10:46:23 -0700
Message-ID: <20250922174630.3123741-1-amastro@fb.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <aNETcPELm72zlkwR@google.com>
References:
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: 8a9aRPhz3f31K-f9lCVtT0JhirN1HjE0
X-Authority-Analysis: v=2.4 cv=CIgqXQrD c=1 sm=1 tr=0 ts=68d18bbb cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=3TvhHRHpCP51MQbkfAYA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 8a9aRPhz3f31K-f9lCVtT0JhirN1HjE0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIyMDE3MyBTYWx0ZWRfX8hew7QE3jpTP
 h6vHpSu0gaPnSfqse1heR94sbIiXdZ++U25INk8f75gGE7d8jigoobHTzlYgGWvWr4BRhxVlboo
 hVKMh3Uolxx/zNeJLIyLbDDyz+aAF7Cblp5pMjcPnJSon9qiPFQOSAuvtiAFRwmoWP+mHaPfm22
 eao3Vtl8MxmZHxNi59773H3QJFoKXjiggR/e5hy2Sl4CG7i76R0qFXPFSTqBdvhPEuUBMYF6bs9
 mHuKpoi27yqeY3VigZzZfSxYeLaw+N1Eq9wOV1KlMWt+ufSYl5jrKKhql/IgDSMlt5sxOG47NaS
 ylVwbnkEgSLjj4FGuu9lCOQdV+X/dabCIaxmPQp1r1GGE64hY0ciGJzcoKr700=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-22_01,2025-09-22_01,2025-03-28_01

On Mon, Sep 22, 2025 at 09:14:24AM +0000, Mostafa Saleh wrote:
> On Fri, Sep 19, 2025 at 07:00:04AM +0000, Tian, Kevin wrote:
> > the proposal includes two parts: BAR access and IOMMU mapping. For
> > the latter looks the intention is more around releasing resource. But
> > the former sounds more like a security enhancement - instead of
> > granting the client full access to the entire device it aims to expose
> > only a region of BAR resource necessary into guest. Then as Jason
> > questioned what is the value of doing so when one client can program
> > arbitrary DMA address into the exposed BAR region to attack mapped
> > memory of other clients and the USD... there is no hw isolation 
> > within a partitioned IOAS unless the device supports PASID then 
> > each client can be associated to its own IOAS space.
> 
> That’s also my opinion, it seems that PASIDs are not supported in
> that case, that’s why the clients share the same IOVA address space,
> instead of each one having their own.

Yes, we do have cases where PASID is not supported by our hardware.

> In that case I think as all of this is cooperative and can’t be enforced,
> one process can corrupt another process memory that is mapped the IOMMU.

In systems lacking PASID, some degree of enforcement would still be possible via
USD and device policies. In a ~similar way to how an in-kernel driver wanting
to accomplish our same goals (enabling a client and device able to access each
other's memory directly) would presumably need to enforce this.

I have been thinking along the following lines:

Imagine that we want the client and device to communicate with each other
directly via queues in each other's memory, bypassing interaction with the
driver.

As part of granting access to a client process:
- The USD allocates some IOAS slice for the client.
- The USD prepares a restricted IOMMU fd to be shared with the client which
  only has mapping permissions to the IOAS slice.
- The USD configures the device: "DMA initiated across this region of
  client-accessible BAR is only allowed to target the client's IOAS slice."
- The USD vends the client a dma-buf exposing a view of only that client's queue
  space, along with the restricted IOMMU fd.

Given the above setup, barring bugs in the USD, or the device hardware/firmware,
it should be impossible for one client to corrupt another client's address
space, since the side-effects it is able to create by accessing its BAR slice
have been constrained by a combination of USD + device policy.

Next, we need to address revocation. The USD needs to be able revoke:
1) client access to BAR memory
2) device access to client memory

Issue (2) was touched on in the original tech topic email, but we haven't
covered (1) yet.

For (1) to be possible, I think we need to grant the VFIO user (USD in this
specific case) the ability to revoke a dma-buf in a way that prevents "peer"
access to the device -- whether the peer is some other device, or a user space
client process.

Following a dma_buf_ops.mmap, I suppose that revocation would mean:
- Poisoning the dma-buf fd to disallow the creation of additional mmaps.
- Zapping the PTEs backing existing mmaps. Subsequent access to the unmapped
  client address space should trigger page faults.

Thanks,
Alex


