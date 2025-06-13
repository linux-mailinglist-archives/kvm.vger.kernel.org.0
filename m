Return-Path: <kvm+bounces-49466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99511AD93F1
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 19:48:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E8D6117F775
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 17:48:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BABC226D1E;
	Fri, 13 Jun 2025 17:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="kpBk4Sg7"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819AF213220
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 17:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749836920; cv=none; b=TSnFUM42fzktGXHvfO2AHG8ciLYCRZU63n9d2lrAnOdrK5qbkll3WENH2UTIZ2dihGXmRNjBxIobgts+M7g8v55toxvNiZ//OcVsoOKaJJdZxiALMWTZ4j8oprEmgGGAzF+uGy6rh3IHz3skv0yYJ3il/Ks2LKueHcI8KSmM/OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749836920; c=relaxed/simple;
	bh=gpufNQqz8Z58hxB9A2XXLFZ7Mjs1USC1yS16JPkdTE8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ExUwWF9pW0XIqyQyHVdt9IEGXaZWD1VBppYknxfMp7CZEpfOXt9guHB9H4WimmC/Rp3ZOZ0FuzeQVQPtgNzhV41ekg8ocUEMniqbkbrJE2dW+wymHEfO9BJ2oOr8HoiasavNQ1tXpEb0tGeS2VO2qmz8Pj018Q8vQhTikcU+pXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b=kpBk4Sg7; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55DGBpNQ004108
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 10:48:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=facebook; bh=/
	u+aoBgzPCVoRGMt4BTTmEzoT0H40U+wuAoLeJzs7M4=; b=kpBk4Sg7CPto28VD+
	7+QC48Df1hESGLLuvGoW7Hx6Oyw9PKvhOtP+M+KBtZTSTDO3GCyFg1Q0zIvFVECw
	Du8FAXKxR89qgr0wjC6/0qfOSDMBk6JO5xpUSbYMT/07jguYd/2Hqq7/T4t2DHkS
	DAtC/Li4S0yAcxRee/2mAb3BcM=
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 478gfb41mn-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 10:48:37 -0700 (PDT)
Received: from twshared11388.16.prn3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1748.24; Fri, 13 Jun 2025 17:48:36 +0000
Received: by devgpu004.cco5.facebook.com (Postfix, from userid 199522)
	id 63433413CC1; Fri, 13 Jun 2025 10:46:11 -0700 (PDT)
From: Alex Mastro <amastro@fb.com>
To: <peterx@redhat.com>
CC: <akpm@linux-foundation.org>, <alex.williamson@redhat.com>,
        <david@redhat.com>, <jgg@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <npache@redhat.com>, <ziy@nvidia.com>, Alex Mastro <amastro@fb.com>
Subject: Re: [PATCH 5/5] vfio-pci: Best-effort huge pfnmaps with !MAP_FIXED mappings
Date: Fri, 13 Jun 2025 10:44:42 -0700
Message-ID: <20250613174442.1589882-1-amastro@fb.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250613134111.469884-6-peterx@redhat.com>
References: <20250613134111.469884-6-peterx@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: x4qOJwi8nnSmxzJm-2uahfYRzT0bnd88
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEzMDEyNyBTYWx0ZWRfXy0L/MzC66uz8 o84P4qkKO8bAf5uZNsPMcQr/UAy4yPczWW3tZvIqKtCgOOUQU8cnCrbnnTAYqkE18QpSwRiR9HH IKZpGyJbZmmS16nVGEAHcRHLirO9EgQuR6HmqD4NzM/Z3X/AM5WVNdqq4tquCUjRL7rc9RYwadh
 DEzRmWJwPyR28GU8fUQNnkB3oivvA+Cy+iLvTWHQL6vyUa7DjKUeVy3zHcKIznXs8QBOyVCmulj yM8Emxz0OZjPOVoB0n0W1mGT7D0pDlZOeS/6KYzKfcdY2ZlvvlDZZamSahxTqRtU198cJIT2k5h Mlx/W3wrejU1gC8DqESzN1pkBOorYjjRoUnWBFYEKjxmm+5tqhASsZ0hmMPZ4RX2x2OdbFbq/zm
 03mWChtHsK6tp7F8lyxqenwbPyj2f+LbjSJV9EIIeFTPvsbVfa7wljj5xw0qaoAebduwJyuo
X-Proofpoint-GUID: x4qOJwi8nnSmxzJm-2uahfYRzT0bnd88
X-Authority-Analysis: v=2.4 cv=WsMrMcfv c=1 sm=1 tr=0 ts=684c6475 cx=c_pps a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=FOH2dFAWAAAA:8 a=jZ9vbDvHQ2ocIyg0wPEA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-13_02,2025-06-13_01,2025-03-28_01

Thank you Peter!

I packported this series to our 6.13.2 tree and validated that it does in=
deed
provide equivalent, optimal faulting to our manual alignment approach whe=
n we
mmap with !MAP_FIXED. This addresses the issue we discovered in [1].

The test case is performing mmap with offset=3D0x40006000000, size=3D0xdf=
9e00000,
and we see that the head and tail (975) are faulted at 2M, and middle (54=
) at
1G. The vma returned by mmap looks nice: 0x7f8646000000.

$ sudo bpftrace -q -e 'fexit:vfio_pci_mmap_huge_fault { printf("order=3D%=
d, ret=3D0x%x\n", args.order, retval); }' 2>&1 > ~/dump
$ cat ~/dump | sort | uniq -c | sort -nr
    975 order=3D9, ret=3D0x100
     54 order=3D18, ret=3D0x100
      2 order=3D18, ret=3D0x800

[1] https://lore.kernel.org/linux-pci/20250529214414.1508155-1-amastro@fb=
.com/

Tested-by: Alex Mastro <amastro@fb.com>

