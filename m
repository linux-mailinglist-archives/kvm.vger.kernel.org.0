Return-Path: <kvm+bounces-62368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 25AE4C421D8
	for <lists+kvm@lfdr.de>; Sat, 08 Nov 2025 01:17:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 813574E7BF0
	for <lists+kvm@lfdr.de>; Sat,  8 Nov 2025 00:17:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9FF81F12E9;
	Sat,  8 Nov 2025 00:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="Yj/AoLrZ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3FB1F0E39;
	Sat,  8 Nov 2025 00:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762561061; cv=none; b=qOgz94Bx2l2PpJY2DNPYfqmKjMrDQCe2SZIfiGQXCk7ayUz5LAXDJ+OxxdTDiozpBE8PX8Vr5Vv/bGOirC4AO924GkCsEl8dMLT+Z+gBOt9Gk2ZEpGza6xkxWOK2ci7Bv/5gD5zQ16RVo2WP+k1K/5OKx8cXpuV5kloWtHUgf50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762561061; c=relaxed/simple;
	bh=cOFnQpzbmnlNKwCD027Hqdl4TX4TDOH2KAi09s5PQOA=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hFfMxv9rwzS08RgUC3pVLPakzKc9BLQcgvYBIAmoS9iEt2jWtCzec1gk3DQFpX+MoIMjt7DW6u/WDs1P5w6VD3kHQfe1DQIXNXqeZyhQ2uTRwqGMUbIJFcZ3MdT+VougRzIhju++aEsY0BnnncLB6HtV0IKkt+p3+TmvZrZB2Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=Yj/AoLrZ; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5A7JWw1x3328834;
	Fri, 7 Nov 2025 16:17:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=s2048-2025-q2; bh=04lQ66OQSTW7KPrTxeDr
	YLPIC17xLpY60aD3jRkw9W0=; b=Yj/AoLrZFpQFf/YlyR9YOg0AUOAICmvFNIPR
	/qo3mZeExlvtVDXYJSr637lSEJa5cLdAT7mtnsIpa6eHdvR1hljTZfxC1Ftb2RM3
	LD5IEfcvVO76HUfsGoX5XsmmUbmayZLjeBM41K1MI0Pg2hH76rBon7iuvkUy2GFA
	/gaVts0GgcJVCIuP+rNrT/Gig6unkfcOuKEG5Md8x2+X1EEQKsgdmew5kl+z2RbJ
	6mdoHwriPErODNTCLqUuYXDUjV93XLwDxnaiVdCzJy8j035QnzT37vLMnw8IXE8t
	JdWfiHlcMvz5meg3sfKGL4z6hEsUAs3h8v+cdNLfdwggFqK96A==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4a9q19a297-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Fri, 07 Nov 2025 16:17:30 -0800 (PST)
Received: from devgpu015.cco6.facebook.com (2620:10d:c0a8:1c::1b) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Sat, 8 Nov 2025 00:17:29 +0000
Date: Fri, 7 Nov 2025 16:17:24 -0800
From: Alex Mastro <amastro@fb.com>
To: David Matlack <dmatlack@google.com>
CC: Alex Williamson <alex.williamson@redhat.com>,
        Alex Williamson
	<alex@shazbot.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfio: selftests: Skip vfio_dma_map_limit_test if mapping
 returns -EINVAL
Message-ID: <aQ6MFM1NX8WsDIdX@devgpu015.cco6.facebook.com>
References: <20251107222058.2009244-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251107222058.2009244-1-dmatlack@google.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDAwMCBTYWx0ZWRfX0R3eTkDsbf8E
 Hh1rDatP+bMw26lwDAaX0wSWzDZMOerXWJk1COKXDIumL6zonRVB7/fQtSGkW/lvb8+pL/epVZY
 9d2L5rq0JbEL6/WBrc7R0K4wV8N7fR6GvuyOY+GbuHIqTRCAzynpVBC2kGIEZQQFiaK3LCJKJkK
 sPRD85w0xHSO97iVw/E6BPnndgOjQ+JLgO0lV4UYeqE66XFqyMkGn/nC+WUFcyG4L0ixB93hmMm
 kko7nlDd84OrocTr6QSECyX82Epw3XlENeF08+csgv+zasQg29YZbJpxseUPk82bnA1for0t1Iy
 iE64UBoj0C3Z7HHWrCTfGwZs7LMP1S9kUd5f7OTiElUT38XSJQWNHNuG57ynIJWExVh4+PbgKR7
 iPAnuNi+V8dqXvVJTF0X2Dmln7HvtQ==
X-Proofpoint-ORIG-GUID: 8OcJDP2JTcaQV6mpcfWh6m8O0BnEjvOR
X-Proofpoint-GUID: 8OcJDP2JTcaQV6mpcfWh6m8O0BnEjvOR
X-Authority-Analysis: v=2.4 cv=PsqergM3 c=1 sm=1 tr=0 ts=690e8c1a cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=kj9zAlcOel0A:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=FOH2dFAWAAAA:8 a=iNw_I6W4xmaHXfvtA-cA:9 a=CjuIK1q_8ugA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-07_07,2025-11-06_01,2025-10-01_01

On Fri, Nov 07, 2025 at 10:20:58PM +0000, David Matlack wrote:
> Skip vfio_dma_map_limit_test.{unmap_range,unmap_all} (instead of
> failing) on systems that do not support mapping in the page-sized region
> at the top of the u64 address space. Use -EINVAL as the signal for
> detecting systems with this limitation, as that is what both VFIO Type1
> and iommufd return.
> 
> A more robust solution that could be considered in the future would be
> to explicitly check the range of supported IOVA regions and key off
> that, instead of inferring from -EINVAL.
> 
> Fixes: de8d1f2fd5a5 ("vfio: selftests: add end of address space DMA map/unmap tests")
> Signed-off-by: David Matlack <dmatlack@google.com>

Makes sense -- thanks David. Agree about keying this off
VFIO_IOMMU_TYPE1_INFO_CAP_IOVA_RANGE longer term.

Reviewed-by: Alex Mastro <amastro@fb.com>

