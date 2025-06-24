Return-Path: <kvm+bounces-50520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D268AE6C8D
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 18:37:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A77784A2C60
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 16:37:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7877821B9FD;
	Tue, 24 Jun 2025 16:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="TsKdgwUm"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F0B2E2EEF
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 16:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750783059; cv=none; b=atOIbLdAC9nxCHPoE2xzuGy9jMZ5RcceB4m4bA9hbx3/AHrPWZbP2SkqP2w04pU0TNtz2hWMCqMXGqHW/14u5ix1vEO0xhh32y7imowYhychXWh2gXiAST+fI1t5Z2yXraG/7x9tyyP+KKb0ddFJVW5WXi3VtRafDo8ubD2yUn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750783059; c=relaxed/simple;
	bh=BNWhmaavD5+X77lm7PY0bRLx040883qzUEvAvWvBb2U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CRo59MEcGJb5TRwSf/1tkt13bo1MAGZXHTPsEFg/OnS8SvNELzLOTlmaonilUmsl5wwyxsaQcJekIeT9whaMYgMuKoH3uxW4z5yBnIHy8ULJ7vN09Xmx4bjTlgDilLonVU2tHQKP6mdgqIhhG58/Q6tX7WA1/rXVH3iYstbbU7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b=TsKdgwUm; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 55OEC9nq021605
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 09:37:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=facebook; bh=H
	5lsDphYvNXaLxsu+qjlWiXiejojiHg4KrTrvEEeeGk=; b=TsKdgwUm2MlFBQBl6
	ZpkdvRJQQzMk/sXb5qXTJGsPDZJ2tzp89fH48zE5s+lVfgUcMjoYQKOa858J7xRK
	zbpMQmN/yYSrFC34Of9fhiStceQi4gnd355y/YA1L2rNh/7Ppnm++8+5t4+ZCYz6
	VNajYk8QurxevEYKFd/LEYmpXw=
Received: from maileast.thefacebook.com ([163.114.135.16])
	by m0001303.ppops.net (PPS) with ESMTPS id 47dre7d90c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 09:37:35 -0700 (PDT)
Received: from twshared7571.34.frc3.facebook.com (2620:10d:c0a8:1b::8e35) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1748.24; Tue, 24 Jun 2025 16:37:34 +0000
Received: by devgpu004.nha5.facebook.com (Postfix, from userid 199522)
	id 68A05197B1B; Tue, 24 Jun 2025 09:37:30 -0700 (PDT)
From: Alex Mastro <amastro@fb.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: Alex Mastro <amastro@fb.com>,
        Alex Williamson
	<alex.williamson@redhat.com>, <peterx@redhat.com>,
        <kbusch@kernel.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfio/pci: print vfio-device name to fdinfo
Date: Tue, 24 Jun 2025 09:35:58 -0700
Message-ID: <20250624163559.2984626-1-amastro@fb.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250624005605.GA72557@ziepe.ca>
References:
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: imFoL79VJrEkspPZq2e7uiGPc-_E_kwU
X-Authority-Analysis: v=2.4 cv=Vbv3PEp9 c=1 sm=1 tr=0 ts=685ad44f cx=c_pps a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17 a=6IFa9wvqVegA:10 a=9jRdOu3wAAAA:8 a=oIC1ugqSzqvTnn3gIawA:9 a=ZE6KLimJVUuLrTuGpvhn:22
X-Proofpoint-ORIG-GUID: imFoL79VJrEkspPZq2e7uiGPc-_E_kwU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI0MDEzOCBTYWx0ZWRfX2HQfsvi5I4fX /WTFIBwKNeoEmw3F1Xx/TwlwYn10fI0pWIUmZTPnICWk5wtqSAkK09cI2qlPJRvLt2BWj+lsm61 j/s7UL+bZKuYL3x02Cpo3V/8OSszK7CNYe/HRyLuYRH5dndnF/3I7+PGteuRJyteDvVij7qSLJG
 Ehi5LvseL7N75vLHJTf3uH1HK4RuKofG1hZJrEzr4eGD8pNBCnZMMPyxRYu0pk/EhjIi07n+m47 VMij6UAMrc7e/HIELljxdZ+S67k6QYhKxSlOFJO/l6qc9GATuqI4eJqHiXZGfn0wSoXrO6SzBQS RcNm9hyRSh8ypYQNNBjFqYE0CX3f86nXVaEP/cDxQs3TOGdSsQzxcrPjeozo8pdNrLfLw0q6oNY
 Dm3gp9zRhQwTf9AsDlPg8XY448b2e/RdzRAudFcL9LX1Ox2fVnHrS02/wZEDr2bEiw8zK0k9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-24_06,2025-06-23_07,2025-03-28_01

On Mon, 23 Jun 2025 21:56:05 -0300 Jason Gunthorpe <jgg@ziepe.ca> wrote:
> For the legacy route this effectively gives you the iommu group.

This is true, but
- There could be multiple devices per group, and I can't see a good way t=
o
  determine exactly which one is in use. (we happen to have one device pe=
r
  group, so this particular concern is somewhat moot for us)
- In our use case, we vend the vfio device fd via SCM_RIGHTS to other pro=
cesses
  which did not open the group fd. We keep track of this internally, but =
it's an
  imperfect solution, and we'd like a more fundamental way to query the k=
ernel
  for this.

> For the new route this will give you the struct device.
>=20
> The userspace can deduce more information, like the actual PCI BDF, by
> mapping the name through sysfs.

In the vfio cdev case, <pci sysfs path>/vfio-dev/X tells you the
/dev/vfio/devices/X mapping, but is there a straightforward way to map in=
 the
opposite direction?

I'm open to other approaches to solving the issue, but making an additive=
 change
to fdinfo seemed innocuous enough, and hopefully unlikely to be incompati=
ble
with future direction of this subsystem.

Thanks,
Alex

