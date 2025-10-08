Return-Path: <kvm+bounces-59624-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id F0D6CBC3466
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 06:09:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C78C84E8448
	for <lists+kvm@lfdr.de>; Wed,  8 Oct 2025 04:09:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D8312BEC53;
	Wed,  8 Oct 2025 04:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="rv8zne46"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672AB2BE646
	for <kvm@vger.kernel.org>; Wed,  8 Oct 2025 04:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759896576; cv=none; b=AXEtc7rsalS5890r5cmLpZKuTcVE5AMZSGiCEW5GzK4jiGw8GSk8T0UOq6D0M6QzprcGhQigKE3KsworRbsU2n+PB+kYABqPU0GhVF/V0+/0ZhcSWh2uv4W+YFi3scUeABihSHyHYxJPXkjZq9Wm9xKSqRRqVvFhg5bi6Rgdgag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759896576; c=relaxed/simple;
	bh=vreM01RNnRBagiCQNESo8oQCL0RKxS1yjVUSjXFssTI=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type:To:CC; b=GUoyrxxLs6CWGzm8FQvwBNviKKrVQmuCmTUk2gJV527SudbugbtkheE4SkvdWscu2UyY2GjFbMeJPZrtlOrUmeDKXSYz3F+0Uav1L9geW6leo86K1j8Bmh+dvbpPnKhcL9Hh+qtqfR+nbYYk+2RtgOmHZtx7juBnw9u00hwRf/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=rv8zne46; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5982rAJO2065805
	for <kvm@vger.kernel.org>; Tue, 7 Oct 2025 21:09:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=+VD+ADpO7lEOYRRArH
	lIcndnPTkYKdf5WG4Mp/THpEI=; b=rv8zne46ZUW0K+j8yRRHK6wRg2Dpx+o/mR
	OXkaHaL8GN1YHMDkMhiEHv3QPZAaFIuKagPpDOlC9uZhDyEZYoXCyrYZasmEE0De
	Qw4J8sT/L0wFOc/53d2xDuFQE2EYqVeHHjG/29/Jjh/Dw46hixJGRs82GFmb7cP8
	Hpzp4ZsZZlneWqfaSUP9hcsjesLj4Q/J8jwaU2cwTwMEaJJ/uihOtvyF0ey4Nuhf
	QscZU9yJPJzPpB2kYyp/voNb1C9CVtK69NUqpmlJzHLNXLJf5T446Cdde280HQnq
	98e7Md9QRmPDQq95se29F6g5ieHz94FQV9HVcvSf1Iq8t36rFYXA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 49n7jxuhyy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Tue, 07 Oct 2025 21:09:32 -0700 (PDT)
Received: from twshared23637.05.prn5.facebook.com (2620:10d:c0a8:fe::f072) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Wed, 8 Oct 2025 04:09:31 +0000
Received: by devgpu015.cco6.facebook.com (Postfix, from userid 199522)
	id B0615D26CCC; Tue,  7 Oct 2025 21:09:19 -0700 (PDT)
From: Alex Mastro <amastro@fb.com>
Subject: [PATCH v2 0/3] vfio: handle DMA map/unmap up to the addressable
 limit
Date: Tue, 7 Oct 2025 21:08:45 -0700
Message-ID: <20251007-fix-unmap-v2-0-759bceb9792e@fb.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAM3j5WgC/22Myw6DIBBFf8XMutPwUDFd+R+NC4ShshANtKSN4
 d9LXXd57j05BySKnhLcmgMiZZ/8FiqISwNm0eFB6G1lEEx0nLEOnX/jK6x6RyOdpEFZPTsN1d8
 j1fNs3afKi0/PLX7OdOa/9V8lc+TY94NSUpBtWxrdfDXbClMp5QtcagI+nwAAAA==
To: Alex Williamson <alex.williamson@redhat.com>
CC: Jason Gunthorpe <jgg@ziepe.ca>,
        Alejandro Jimenez
	<alejandro.j.jimenez@oracle.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Alex Mastro <amastro@fb.com>
X-Mailer: b4 0.13.0
X-FB-Internal: Safe
X-Proofpoint-GUID: I4AS_X2wT9B9EWFDJO1J6GB-agvdntuo
X-Proofpoint-ORIG-GUID: I4AS_X2wT9B9EWFDJO1J6GB-agvdntuo
X-Authority-Analysis: v=2.4 cv=LJdrgZW9 c=1 sm=1 tr=0 ts=68e5e3fc cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VwQbUJbxAAAA:8 a=FOH2dFAWAAAA:8
 a=ka7W0CE-xre0FC5hE3AA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDAyNCBTYWx0ZWRfX24mEXny7k1av
 FnI55/6XaXQ3Q6Nv/TZSzuS7mFWgD7L0sHsiyAnd3uTFbPNB2p0d+0/iI/Mvvee8IM/gfqnCwcM
 fq2puhyCGSZkiDflibYlx1ENVDoX1tsqn8VcZ461zlZ39gwrQiTgPk2h8KrfKF3Hj4+wVvdgQXt
 8UPYfliiutkIFWvM5v3b/b96iMGiqHdeL+ZmPIuuVJy6y+PsSEMxF4UGifzKr1UCct+Yqlt/SMl
 QXmaytjGsk18tvVPi8o37Vw5f9y0+aNTJA0SBWdyuSFWIOGVr26jUxeZ/Za2ZmCNHy5AJWCUHMV
 DzbS2/q5YSBsKnwlM0xiCWlXuP+PKb93hxv5qdBaltCWkj4i1/BwGoJrKn+1OkBHUSNEe/+7cuA
 RLdHysEnd1yc4L4LJvz/bPRdct31Jg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-07_02,2025-10-06_01,2025-03-28_01

This patch series aims to fix vfio_iommu_type.c to support 
VFIO_IOMMU_MAP_DMA and VFIO_IOMMU_UNMAP_DMA operations targeting IOVA
ranges which lie against the addressable limit. i.e. ranges where
iova_start + iova_size would overflow to exactly zero.

Today, the VFIO UAPI has an inconsistency: The
VFIO_IOMMU_TYPE1_INFO_CAP_IOVA_RANGE capability of VFIO_IOMMU_GET_INFO
reports that ranges up to the end of the address space are available
for use, but are not really due to bugs in handling boundary conditions.

For example:

vfio_find_dma_first_node is called to find the first dma node to unmap
given an unmap range of [iova..iova+size). The check at the end of the
function intends to test if the dma result lies beyond the end of the
unmap range. The condition is incorrectly satisfied when iova+size
overflows to zero, causing the function to return NULL.

The same issue happens inside vfio_dma_do_unmap's while loop.

Of primary concern are locations in the current code which perform
comparisons against (iova + size) expressions, where overflow to zero
is possible.

The initial list of candidate locations to audit was taken from the
following:

$ rg 'iova.*\+.*size' -n drivers/vfio/vfio_iommu_type1.c | rg -v '\- 1'
173:            else if (start >= dma->iova + dma->size)
192:            if (start < dma->iova + dma->size) {
216:            if (new->iova + new->size <= dma->iova)
1060:   dma_addr_t iova = dma->iova, end = dma->iova + dma->size;
1233:   if (dma && dma->iova + dma->size != iova + size)
1380:           if (dma && dma->iova + dma->size != iova + size)
1501:           ret = vfio_iommu_map(iommu, iova + dma->size, pfn, npage,
1504:                   vfio_unpin_pages_remote(dma, iova + dma->size, pfn,
1721:           while (iova < dma->iova + dma->size) {
1743:                           i = iova + size;
1744:                           while (i < dma->iova + dma->size &&
1754:                           size_t n = dma->iova + dma->size - iova;
1785:                   iova += size;
1810:           while (iova < dma->iova + dma->size) {
1823:                   i = iova + size;
1824:                   while (i < dma->iova + dma->size &&
2919:           if (range.iova + range.size < range.iova)

This series spend the first couple commits making mechanical preparations
before the fix lands in the last commit.

Signed-off-by: Alex Mastro <amastro@fb.com>
---
Changes in v2:
- Change to patch series rather than single commit
- Expand scope to fix more than just the unmap discovery path
- Link to v1: https://lore.kernel.org/r/20251005-fix-unmap-v1-1-6687732ed44e@fb.com

---
Alex Mastro (3):
      vfio/type1: sanitize for overflow using check_*_overflow
      vfio/type1: move iova increment to unmap_unpin_* caller
      vfio/type1: handle DMA map/unmap up to the addressable limit

 drivers/vfio/vfio_iommu_type1.c | 145 +++++++++++++++++++++++++---------------
 1 file changed, 92 insertions(+), 53 deletions(-)
---
base-commit: 407aa63018d15c35a34938633868e61174d2ef6e
change-id: 20251005-fix-unmap-c3f3e87dabfa

Best regards,
-- 
Alex Mastro <amastro@fb.com>


