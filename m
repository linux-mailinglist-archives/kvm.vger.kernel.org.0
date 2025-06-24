Return-Path: <kvm+bounces-50534-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D1C7AE6EF5
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 20:55:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18B113BBCF6
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 18:54:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33EA02E975B;
	Tue, 24 Jun 2025 18:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="EGIvJZMB"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF2E2E7623
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 18:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750791282; cv=none; b=cFRfJJihwQ7JOL2z/w1LMUC+nGcWTCOIHpYRnBTPFQs+36Dkvj9CoI/Kgfa66g4fXX8PIkDogJY7LaG9IbNUa5tzwMGkKzGk0Vpod5pqDGHRb+aGJcrU4iCaP4NJoQ+tndyGvi0VEXUSTxWOgamozSY3uHZkc/HNM6j2oex0feM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750791282; c=relaxed/simple;
	bh=c/y3xXMbDdtlBwDY0/y4GK/bkN2xFaQdAi2da5gKUyQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jKZh2a9ruf+/HSOY+mbvpNuiLjfIZaRPPhdjt1ndCL/u+ZLFlVQy/KisZCKDcYdFSTVb7+LNdCP1fuKLzncGtYaOuZ44tRLaxTZnDlnE3N8vO+BckUmY4p5UG/w+FZDf4uHshI9DUHhR98GuV8EfgItGsBDBoUzv25ir/Omq5nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b=EGIvJZMB; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55OICG0G031915
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 11:54:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=facebook; bh=c
	/y3xXMbDdtlBwDY0/y4GK/bkN2xFaQdAi2da5gKUyQ=; b=EGIvJZMBV8GTDF/lP
	H85JjHyaFPqpyh5GNV1W06BKyo1f0m8tNt5R1A0BTsWjkZ7dmBXsNMSpDKVCYxC/
	2JVK3+vieOlwD18/6CopplOeJugElWAqqwd0il9KT1xt2RdPE6aWI6RaquOqUDZB
	TlNOhRVLA85/SQuWuN7qA/yufc=
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 47fxnp9vtx-9
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 11:54:39 -0700 (PDT)
Received: from twshared21625.15.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1748.24; Tue, 24 Jun 2025 18:54:36 +0000
Received: by devgpu004.nha5.facebook.com (Postfix, from userid 199522)
	id 8DE441AD75B; Tue, 24 Jun 2025 11:54:26 -0700 (PDT)
From: Alex Mastro <amastro@fb.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: Alex Mastro <amastro@fb.com>,
        Alex Williamson
	<alex.williamson@redhat.com>, <peterx@redhat.com>,
        <kbusch@kernel.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfio/pci: print vfio-device name to fdinfo
Date: Tue, 24 Jun 2025 11:53:25 -0700
Message-ID: <20250624185327.1250843-1-amastro@fb.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250624181616.GE72557@ziepe.ca>
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
X-Proofpoint-ORIG-GUID: YNphcLuuQAxdQ6nVh2crShZDYH0mOgvu
X-Authority-Analysis: v=2.4 cv=evDfzppX c=1 sm=1 tr=0 ts=685af46f cx=c_pps a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17 a=6IFa9wvqVegA:10 a=9jRdOu3wAAAA:8 a=y_P49Qpdh_UukDKHNdIA:9 a=ZE6KLimJVUuLrTuGpvhn:22
X-Proofpoint-GUID: YNphcLuuQAxdQ6nVh2crShZDYH0mOgvu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI0MDE1NSBTYWx0ZWRfXyg7igDSE4kOH qCcEC5PO1LqMoOIXOwDqsYM0EiNtCCt2h9iqq+Gtzt3tp+Zakhh4DbHQ/eCb/5mdhbJF5fhGkqZ uVfo2ywAp/d4jOdqi/gt+9GSFrxpOcl7oxR8b3Wf43miEoC4W9eRZfMdzWgMWjSfZQbYW2Zy2VX
 PrD2gEzt0AQATxrgDVNLQub0OGJWeWJr0Y7eIPHwfiGQRnGwe0BzXoBaI4D0NljAFCf3AFW0yVz fnjn+8RkcmpE/oSBAPp0hIA6q0ueIBLj4dt+y6RHUaQ21+xICtJ/uKDKrG+E8oKHvWFPKW9uvqS 9uycm8waRNu0JMJRRaog0lL7Mxjs/mZH9iX3+8mHktAw4/F9ljQ5AeoJXOh4mOpS/fqJpLPQ+gf
 tMygt0uVR+AgZbH51aviVk05T7LKlWrm0eZ7/Q44uV+hDBk12RdDdjH76wbUpggWOTKFEe0T
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-24_06,2025-06-23_07,2025-03-28_01

On Tue, 24 Jun 2025 15:16:16 -0300 Jason Gunthorpe <jgg@ziepe.ca> wrote:
> There will be a symlink under /sys/class/vfio-xx/XX pointing to the
> <pci sysfs path>/vfio-dev/X directory
>=20
> And another symlink under /sys/dev/char/XX:XX doing the same.

Got it, thanks. The issue does seem solved for the vfio cdev case, then.

Alex


