Return-Path: <kvm+bounces-58169-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 69919B8AB96
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 19:16:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 06DBF178B7C
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 17:16:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A59B2459C8;
	Fri, 19 Sep 2025 17:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="2hORes+x"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85651E5B73;
	Fri, 19 Sep 2025 17:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758302195; cv=none; b=Sq5IjRP+Id+sFlvrLFNKJWgwVXwAJjsbr54DVZKMTKjoZAmpQkJqFs8cJde7vncwSsdip1N5Si92BYsdn/ehQsMLo9NlFLLvEuawSSgSbWOfbTj2rtFmFnBQBlCyZUJdf1mfWNy9111WCHkUyQWQT4lhOFdFtz/4f2DGxUhx/Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758302195; c=relaxed/simple;
	bh=09SQDK20V1C70PE4gLmqu5oLvyjn+4wKeuW/qUpaodM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z6s73gTpZn2elWzzZ3PdkzO3X0FR1lqNR8Wi7GuNtSyynmR+all1FMjjR3XlaC+jJLaUp9aX7Zsb93NTC70omgwVDEBkbqCl2jKAjUr8rlDPNQY355PVv5T8KWOkVYcfbuapEIRmVSxo+56QqDZMIWuLiZz1/vOfb2aFgAse1YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=2hORes+x; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 58J8nA3T2208657;
	Fri, 19 Sep 2025 10:16:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=98smohVcnAIP7jrt86erbgK8/U94FHgkxTfBMnhSHuU=; b=2hORes+xJiTf
	rXlJtmsa1SU8dlbcrmdXyuN/G52phJmxqMSa3p1y+7A4ApOqb71X0o8kSE2n0Pn5
	PpDMy+WvzdH0zYQu0hASJMKI2IlRRxuur7859147RIiAJq6Mgcuy8HBryT7X3il/
	ApFsZSqbGWeIE7mv/0KA8WI8oy1eOkQiWliqZcdD4jGe6TmzZoO8/57Rn71K1ycz
	0kTnQyL0csYydu7Ysur0O/Q5e+gf8fgo4rppg04eLRYhlSJaXQWNlL5VE6+cU/8f
	hRcezk/dKbza+6Ff0aKN2oPRcuRR0BCp6oMsFQuwiETLpYTTo3h81jBY6guzOxny
	KBqm132VAQ==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 49940fb70q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Fri, 19 Sep 2025 10:16:07 -0700 (PDT)
Received: from devgpu015.cco6.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Fri, 19 Sep 2025 17:16:04 +0000
From: Alex Mastro <amastro@fb.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Alex Mastro <amastro@fb.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Kevin Tian
	<kevin.tian@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, David Reiss
	<dreiss@meta.com>,
        Joerg Roedel <joro@8bytes.org>, Keith Busch
	<kbusch@kernel.org>,
        Leon Romanovsky <leon@kernel.org>, Li Zhe
	<lizhe.67@bytedance.com>,
        Mahmoud Adam <mngyadam@amazon.de>,
        Philipp Stanner
	<pstanner@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Vivek Kasireddy
	<vivek.kasireddy@intel.com>,
        Will Deacon <will@kernel.org>, Yunxiang Li
	<Yunxiang.Li@amd.com>,
        <linux-kernel@vger.kernel.org>, <iommu@lists.linux.dev>,
        <kvm@vger.kernel.org>
Subject: Re: [TECH TOPIC] vfio, iommufd: Enabling user space drivers to vend more granular access to client processes
Date: Fri, 19 Sep 2025 10:14:58 -0700
Message-ID: <20250919171459.1352524-1-amastro@fb.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250919095743.482a00cd.alex.williamson@redhat.com>
References:
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE5MDE2MSBTYWx0ZWRfX47c8hkDswCkv
 hJo9GRRGfEWTIDGYnVEf4dOfCKGZ9iiEwwZsrULSRyWpZW7OszhV69mvaFJGvMoiaYcqtegm/G/
 CkUUqih5eEkLeRkLi5Sgn8uketZ+azlUPmebszjLvTwWGfnN2HpeA4QacwL+qRbWlWlkKOQudrB
 0eRDMp4/TxJsJhFK7Pspr/y/X2ESxONMdrycIHIbacE624hkBaH+265DzKRRe20rwPcwf6EEt/p
 sXn0QO5x5WJHuUobsjJ5vU8Bk8H/qq/eVGLQ3gFmNnjRu2qQ4uCQyA0H+xwH03FjEuvp2ezDOVi
 qODQBwilsXMz6W3qtmCGhW4UGbq9cC1g+mAnzOWu9XN7gq4rQR0hkntDd6epo4=
X-Authority-Analysis: v=2.4 cv=H9Dbw/Yi c=1 sm=1 tr=0 ts=68cd8fd7 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=yJojWOMRYYMA:10 a=NEAV23lmAAAA:8 a=DjjwJGvdkomo06jjSjQA:9 a=ZXulRonScM0A:10
 a=zZCYzV9kfG8A:10
X-Proofpoint-GUID: Ij1HEC-xmqLfelG2mU4rIyyIC9rQBd2m
X-Proofpoint-ORIG-GUID: Ij1HEC-xmqLfelG2mU4rIyyIC9rQBd2m
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-19_01,2025-09-19_01,2025-03-28_01

On Fri, Sep 19, 2025 at 09:57:43AM -0600, Alex Williamson wrote:
> Definitely.  Also, is this at all considering the work that's gone into
> vfio-user?  The long running USD sounds a lot like a vfio-user server,
> where if we're using vfio-user's socket interface we'd have a lot of
> opportunity to implement policy there and dma-bufs might be a means to
> expose direct, restricted access.  Thanks,

Possibly. Though I think the USD's responsibilities and the semantics for
how clients would negotiate various forms of device access would be very
application-dependent. In addition to just vending vfio and iommu-related fds,
our USD needs to do things like bootstrap the device by loading firmwares,
collect metrics, and other background functionality.

I'm not sure if I'm addressing your point though.

We actually do use libvfio-user [1] for user space simulation of PCI devices,
but it's not a part of our USD today.

[1] https://github.com/nutanix/libvfio-user

Alex

