Return-Path: <kvm+bounces-59762-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F83FBCBF1A
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 09:38:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4C0B11A63659
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 07:39:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBA151531C1;
	Fri, 10 Oct 2025 07:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="DhGL7wAa"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 032CE274B35
	for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 07:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760081925; cv=none; b=nRZybpm6le7oOfoGi5YsXDjEnvr83ZG0xZl6ZSRDaPtS60USGfOJjqSElXp7AdVqEdqQC7DNb22UcvZtQOcuL2a+0uao3JVobFXsmbuKJx7MTMS3YXr1NzMQR0UImMbwn2Jl9cIXzYhWAIe58GDL04Ks8tvSyYIXUyOIzdRy15k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760081925; c=relaxed/simple;
	bh=xyS9JbSC0u78/73IlLr8gNEgrAztD4Uuw49dzv84lhk=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type:To:CC; b=s9qpZjfWELdHiSnEzf+Xnt28FXZdX62rFgtDFxwzZnmp/Jx5wlMuuDdOriAQDmgfpsCmnrSIrLwsymH/2+ltafuCQqprzstxDtipgzHIMuhBocqS9TUjjgxE6n6/yKGvrtakqrbAykAU2rz3eigcmMRy6aqpBPBrLOytjt3GXQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=DhGL7wAa; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 599KUNpl1851787
	for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 00:38:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=k/a87C/zECj1bL15bu
	JhR/ZmqgimgaZmoMYAJqi/Lww=; b=DhGL7wAa8U6ThvIKUo3nwWvKChggitZDmo
	zfM4mXxA+rtL9R4sADvE15ecIBYCE4qToD1ShBBmEbSEh66aQcoL5lwTyPM8ScKY
	CLHbL8IbJgJnBR+pRB/i4FOBqYa3jcVEJqWeZYxFiVhv2nsDLcYaTiGz+VXE1ML8
	PfTjAoQclOcjcIUzvm7N90ZZ75v107B+yIT5UVmrKI3orx7pBL0FcSNLQdA6/nZt
	OSfP4JjrVDM1tdaGR3I5Gd/wrB1QPBrtqw0l24eazyNkK8Rhmsu5R4hBea/vHWo+
	i/6VcgGd46wSWXmClGrAybt1ayF4gDc9LnV0RIXibXJN+P5sHpCA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 49pkcqwfnp-8
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 00:38:42 -0700 (PDT)
Received: from twshared23637.05.prn5.facebook.com (2620:10d:c085:108::150d) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Fri, 10 Oct 2025 07:38:41 +0000
Received: by devgpu015.cco6.facebook.com (Postfix, from userid 199522)
	id 40DE1E937D2; Fri, 10 Oct 2025 00:38:40 -0700 (PDT)
From: Alex Mastro <amastro@fb.com>
Subject: [PATCH v3 0/3] vfio: handle DMA map/unmap up to the addressable
 limit
Date: Fri, 10 Oct 2025 00:38:38 -0700
Message-ID: <20251010-fix-unmap-v3-0-306c724d6998@fb.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAP+36GgC/22MuxKCMBBFf4XZ2nXyAAJW/odjkYSNpOAxiWZ0G
 P7dQCOF5dm95ywQKXiKcCkWCJR89NOYQZ4KsL0eH4S+ywyCiYozVqHzb3yNg57RSiepUZ02TkP
 ez4Hyc2/d7pl7H59T+OzpxLfrv0riyLGuG6WkoK4s6erM2U4DbIkkjpo6agIZqqo1lkyrWvHT1
 nX9AgKRVNDWAAAA
To: Alex Williamson <alex.williamson@redhat.com>
CC: Jason Gunthorpe <jgg@ziepe.ca>,
        Alejandro Jimenez
	<alejandro.j.jimenez@oracle.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Alex Mastro <amastro@fb.com>
X-Mailer: b4 0.13.0
X-FB-Internal: Safe
X-Authority-Analysis: v=2.4 cv=KNBXzVFo c=1 sm=1 tr=0 ts=68e8b802 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=FOH2dFAWAAAA:8 a=LN3npHLcb8nXURrLiNkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: VOrPADanaEn-tg9cBVG7CjNVJJLeJsf-
X-Proofpoint-ORIG-GUID: VOrPADanaEn-tg9cBVG7CjNVJJLeJsf-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDEwMDA0MyBTYWx0ZWRfX6TsjwgmQF2zs
 lMTU649Q21uBsNzCbVO7/vvhQFIEKaFp2+juRdjNDS0RkaGY6JMK7xDYY9iw8MtJuPMXrA5Zpfm
 pIzT0YqHgKJv0n7iXdt/zwTgkafNR5NXb8Cw2s8T78EV6tNFPU7wu5Cm7K2ePdNzEsf2zzAF9BX
 xNcMlv4KhyWY9HOnwugcGCJleO/Pds+qTTS847qONKO+u+hoSIpreQ2vH1JW7IMkMRz9WFIK3Zj
 /0vmrKU78tHNsJPJ/tpUp959jrRBiKSBZCdBTazOvF0qu2cFYX9oCr5TkkHK7mtZ//8eTziZnVj
 6t27ZfMM//v9JkL/2zvr2RwQZo6DLEnh75Vkh1KZn8jjkLHrTIIfF4U4Ks/0ONWvfFt94Vj+RlH
 u5p3UkuMQNBVMDQyo/04jTlD3MqHqw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-10_01,2025-10-06_01,2025-03-28_01

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

This bug was also reported by Alejandro Jimenez in [1][2].

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

[1] https://lore.kernel.org/qemu-devel/20250919213515.917111-1-alejandro.j.jimenez@oracle.com/
[2] https://lore.kernel.org/all/68e18f2c-79ad-45ec-99b9-99ff68ba5438@oracle.com/

Signed-off-by: Alex Mastro <amastro@fb.com>
---
Changes in v3:
- Fix handling of unmap_all in vfio_dma_do_unmap
- Fix !range.size to return -EINVAL for VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP
  - Dedup !range.size checking
- Return -EOVERFLOW on check_*_overflow
- Link to v2: https://lore.kernel.org/r/20251007-fix-unmap-v2-0-759bceb9792e@fb.com

Changes in v2:
- Change to patch series rather than single commit
- Expand scope to fix more than just the unmap discovery path
- Link to v1: https://lore.kernel.org/r/20251005-fix-unmap-v1-1-6687732ed44e@fb.com

---
Alex Mastro (3):
      vfio/type1: sanitize for overflow using check_*_overflow
      vfio/type1: move iova increment to unmap_unpin_* caller
      vfio/type1: handle DMA map/unmap up to the addressable limit

 drivers/vfio/vfio_iommu_type1.c | 162 ++++++++++++++++++++++++++--------------
 1 file changed, 104 insertions(+), 58 deletions(-)
---
base-commit: 407aa63018d15c35a34938633868e61174d2ef6e
change-id: 20251005-fix-unmap-c3f3e87dabfa

Best regards,
-- 
Alex Mastro <amastro@fb.com>


