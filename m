Return-Path: <kvm+bounces-50429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 13BF8AE57C5
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 01:15:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 62C434465A2
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 23:14:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DD2B22B8D0;
	Mon, 23 Jun 2025 23:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="giJ15HuI"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0946722B8A9
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 23:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750720508; cv=none; b=oXCnLsDUAXw1G99F8D5aJ9G6gWt3xEp4zuwB2Jkwwnvg2/KEDmErTjP/MC6ktDvwFGpkqW5tvyMZZt3BrwkMiqGYP/X1MkNOhWqGfc7F3hMzjZXSvDTO1Q0eO3qMUx2O/LVXufHt1FBWUoQP5/BEG409XEgZRLO5xQOkun47woY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750720508; c=relaxed/simple;
	bh=nLbF7yQZl/o06wcIrZqIvhQsJtF3U4tJXhrfUtwcMHo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y6cFjLDIbOegx6nCVYU+lmp8k7KDHLw94C2NwFiBqpAku1LkJhs6qLq1cKvwBrrJF6f9wvxBI3zkpskoBU2DfRzrknR8Y0mCi9Bq3/oYQtz912UyuAXranAUw6KfU7QtpyNC4h55om/6/0MuRixbDQBvwfTEaGxHViTva1FYc5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b=giJ15HuI; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 55NM7IBC016928
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 16:15:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=facebook; bh=4
	9LAPUm1quHKTZyBFpiWIXjpujPBXo76XLo5wjg6XF4=; b=giJ15HuIb5xCux+0v
	LsYXt+PINlimWeuf73u+4a6rQlcvtKzdPVUUFOXp0W3/CHOdCyHBES+H1YuBL3MR
	Cf8h1BLSUKGyrqGWNfLHRCr6GuBYfL0X1sLy13mBmb5b0kCTZInPJKKCuXNC1t4+
	eyXMvcMIOMk62jnFHdvV2pIXCs=
Received: from maileast.thefacebook.com ([163.114.135.16])
	by m0089730.ppops.net (PPS) with ESMTPS id 47f0a1f7dw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 16:15:05 -0700 (PDT)
Received: from twshared21625.15.frc2.facebook.com (2620:10d:c0a8:1b::8e35) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1748.24; Mon, 23 Jun 2025 23:15:05 +0000
Received: by devgpu004.nha5.facebook.com (Postfix, from userid 199522)
	id 270981258C2; Mon, 23 Jun 2025 16:14:52 -0700 (PDT)
From: Alex Mastro <amastro@fb.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Alex Mastro <amastro@fb.com>, <peterx@redhat.com>, <kbusch@kernel.org>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe
	<jgg@ziepe.ca>
Subject: Re: [PATCH] vfio/pci: print vfio-device name to fdinfo
Date: Mon, 23 Jun 2025 16:14:48 -0700
Message-ID: <20250623231450.1326244-1-amastro@fb.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250623161831.12109402.alex.williamson@redhat.com>
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
X-Proofpoint-ORIG-GUID: xpe7g4EGpfCde8DpgETSko__xBZKvLf_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjIzMDE2MCBTYWx0ZWRfX1RCeXfngmUXC Dm2bpHzqpknMq30QP9dLI8+1oAEyYX6iMkfiLodUg3Soak1vwR2QIHXrCN5zeeY5y4HJCoTsPAZ s7Q9KSgg21NjMGImubLq4HRXbR96Woww6o/iRKqsBS0isbSZP2mLxxWRQDW4TG4TAVVMzVxTjlo
 5Q/LJQvBHDJLDpit0vHRiPpeUY9AFdJfoRT08/+P4CVJUMda7LSK8N3yp0Zb4r8LT4ZRfW0W24d j9GwfoeT+tREbXa3ELK6/mkk9LBvWtYrcfbMRPCGSTCPwDBsvfogI0kuQV1RHFv1uU5U8hX69x3 nm/6VknGoTfS9/wcM4hHeZPUzse5Y+jRp6llrus7pLwXBLmZwNnWd11GBbeDHgspr7mZX5LTk0Z
 uVVrBPxZDdMSV0h3uLr9YooNowRHKK5OJ7f8UQd4up+nZGLQ+YPaxmv0JMhH5MXkp7PREZD3
X-Authority-Analysis: v=2.4 cv=BuudwZX5 c=1 sm=1 tr=0 ts=6859dff9 cx=c_pps a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17 a=6IFa9wvqVegA:10 a=20KFwNOVAAAA:8 a=pQO_QLq9p-wijE2fh-sA:9
X-Proofpoint-GUID: xpe7g4EGpfCde8DpgETSko__xBZKvLf_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-23_07,2025-06-23_07,2025-03-28_01

Hi Alex, thanks for the prompt feedback.

On Mon, 23 Jun 2025 16:18:31 -0600 Alex Williamson <alex.williamson@redha=
t.com> wrote:
> TBH, I don't think we need a callback, just use dev_name() in
> vfio_main.  The group interface always requires the name, in some cases
> it can require further information, but we seem to have forgotten that
> in the cdev interface anyway :-\

Sounds good -- I'll follow up on this in v2.

> > +#include <linux/seq_file.h>
>=20
> Only where we're doing the seq_print do we need to include this.

Ah, I only added it due to the direct reference to `struct seq_file *` in=
 this
file, but will keep this in mind. I do see that it's transitively visible=
 via
vfio.h's include.

> I think you're missing an update to Documentation/filesystems/proc.rst
> as well.

TIL about this documentation (section 3.8), but it looks to be focused mo=
re on
common fs/* pieces like eventfd, signalfd, and such. I didn't see any dri=
vers/*
precedence, but would not be opposed to being the first. Do you think it =
still
makes sense to add there?

Thanks,
Alex

