Return-Path: <kvm+bounces-61306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 450CBC15C38
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 17:22:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6128C3A9919
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 16:17:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6FC02165EA;
	Tue, 28 Oct 2025 16:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="sIrNrtiZ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56E4346E4A
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 16:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761668117; cv=none; b=u+AsabpyegVLmZCE7URqFXM9ekUbPOAS8lBxSlnBYNsw9QEBlwKSlcmI7Lpn9D9krXsvE8j1gmfqadaqFi0b6UStlJ3lGTVwsMFE7uZrdi9roYOvHJBGIEtoOVUoTE3PChRgHEANTtygL15cE8Vn7Vb+wcLhUYiZZrwZQIJvV6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761668117; c=relaxed/simple;
	bh=ojLEAM98Dblq5Zf3WN778OA5xyt22izFWmj7GY66YJo=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type:To:CC; b=f00RVsF2HUM7lSAMY+ypnDXU+CRZIRUUomNps6AV31LP4pwTBl90vvefBQktoPxLiO0ba7ymWqsrmRajRc1WYzmAvezjSjWxlqTQTytF5eDfv51Qnrf4UMrHVUm4aFQ2dOrsAEsJMakSLg7lJt6Ib3P3se2gmSR0zUoy6oUd2no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=sIrNrtiZ; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59SFNowJ3079487
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 09:15:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=ICw8lIhzj+QccYYwck
	fkGR6fCCdwfkrfNDx2d73gaSY=; b=sIrNrtiZO8FqvtdNFiAWmO0sle6/dL1t30
	w1F+HaFleUF82g5xouI0zQbjstaEuN6GJbtwmEacgbDmCIbfuZIXr9uNHiRhkPGT
	rIXH6MyVUOSUJ4R5IHlAxSvs31zHTPYwMTD3H60a6hKSF0K8PvNpLAHh3AoQEHT1
	O+jC03M4/Pc7Atvhcd8Acea+3+o7iDa8adnH57fq1yg2DV6nHh/ILNSMWFjIk/F4
	A6CbKfaV6BytIL3I33pPzuBBumyLilgrnN7ldVn/DgyQLRLwaR5jNyakWnDEnKOm
	mx8WEM2bz5BnJCLySQhK2PSXSvcMUtx5bUoMU+Xvl/+dd2VwD6pA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4a30eggge2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 09:15:14 -0700 (PDT)
Received: from twshared31947.34.frc3.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Tue, 28 Oct 2025 16:15:13 +0000
Received: by devgpu012.nha5.facebook.com (Postfix, from userid 28580)
	id F2964512933; Tue, 28 Oct 2025 09:15:04 -0700 (PDT)
From: Alex Mastro <amastro@fb.com>
Subject: [PATCH v6 0/5] vfio: handle DMA map/unmap up to the addressable
 limit
Date: Tue, 28 Oct 2025 09:14:59 -0700
Message-ID: <20251028-fix-unmap-v6-0-2542b96bcc8e@fb.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAPsAGkC/23OPQ7CMAwF4KugzAQlzl/DxD0QQ5PYkIG2aqECo
 d6dwIBSifHZ/p78YhOOGSe237zYiHOect+VYLcbFi9td0aeU8kMBBgphOGUH/zeXduBR0UKG5f
 aQC0r98OIZfntOp5KvuTp1o/Pb/UsP9N/LbPkklvbOKcAk9Z4oLCL/ZV9KmaomasZcMGd8SFi8
 M7DmqmKSVEzVZgSNjrQyXrfrJiuGdRMF+YRKXqBSeq4YqZisHrSFKZJUKSGKLj0Y8uyvAHVRhU
 KewEAAA==
To: Alex Williamson <alex@shazbot.org>
CC: Jason Gunthorpe <jgg@ziepe.ca>,
        Alejandro Jimenez
	<alejandro.j.jimenez@oracle.com>,
        David Matlack <dmatlack@google.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Alex Mastro
	<amastro@fb.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
X-Mailer: b4 0.13.0
X-FB-Internal: Safe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI4MDEzNyBTYWx0ZWRfX5HUul8ZNLoxm
 dwCUj/NnWfh7HcDIi0zIGIKq2vwvDlP6PjMvUxzGouls6dQueEYUYpQLGUaRbvBSoGcfo3EaTkH
 NIOuAbkLtr/F5Fzn6OvoPXBpv8F38JRtvxyginNgBb+r8OszHH1TEWsuUxvsEjDbauh5nJDjxJ8
 LgiHaNNs6nOWQNG3sbg1eZRVnR6Y3/VWXymj/EsQcNN5SF5Gh7KqtO0skRnMJXfVOQrhfFJL3hc
 xf6rTaAmd020bVkZadOxfDNl0wNZjeZFizdHSvDDN32lpi99+eBOH8hxGao5RP0xMjOJW+tVsbn
 P6ML0GnArOzAt0Mcvhlk3amUcMl4nivqdU5LnxCzJxkRGPlWxQLfjFK2n8GnOBrEPvPvoBIy4kT
 G1EAkvaGizKp58Z18nPxbsDIQUOIig==
X-Proofpoint-GUID: XDYh1kiy_SukyLNKJw1r92x9gyJgTK1N
X-Authority-Analysis: v=2.4 cv=PNkCOPqC c=1 sm=1 tr=0 ts=6900ec12 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=FOH2dFAWAAAA:8 a=FQJeTYmMTeF94GSivE8A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: XDYh1kiy_SukyLNKJw1r92x9gyJgTK1N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-28_06,2025-10-22_01,2025-03-28_01

This patch series aims to fix vfio_iommu_type.c to support
VFIO_IOMMU_MAP_DMA and VFIO_IOMMU_UNMAP_DMA operations targeting IOVA
ranges which lie against the addressable limit. i.e. ranges where
iova_start + iova_size would overflow to exactly zero.

Today, the VFIO UAPI has an inconsistency: The
VFIO_IOMMU_TYPE1_INFO_CAP_IOVA_RANGE capability of VFIO_IOMMU_GET_INFO
reports that ranges up to the end of the address space are available
for use, but are not really due to bugs in handling boundary conditions.

For example:

vfio_find_dma_first_node() is called to find the first dma node to unmap
given an unmap range of [iova..iova+size). The check at the end of the
function intends to test if the dma result lies beyond the end of the
unmap range. The condition is incorrectly satisfied when iova+size
overflows to zero, causing the function to return NULL.

The same issue happens inside vfio_dma_do_unmap()'s while loop.

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

This series spends the first couple commits making mechanical
preparations before the fix lands in the third commit. Selftests are
added in the last two commits.

[1] https://lore.kernel.org/qemu-devel/20250919213515.917111-1-alejandro.j.jimenez@oracle.com/
[2] https://lore.kernel.org/all/68e18f2c-79ad-45ec-99b9-99ff68ba5438@oracle.com/

Signed-off-by: Alex Mastro <amastro@fb.com>

---
Changes in v6:
- Fix nits in selftests
- Clarify function calls with '()' in commit messages
- Link to v5: https://lore.kernel.org/r/20251027-fix-unmap-v5-0-4f0fcf8ffb7d@fb.com

Changes in v5:
- Add vfio selftests
- Clarify commit message
- Link to v4: https://lore.kernel.org/r/20251012-fix-unmap-v4-0-9eefc90ed14c@fb.com

Changes in v4:
- Fix type assigned to iova_end
- Clarify overflow checking, add checks to vfio_iommu_type1_dirty_pages
- Consider npage==0 an error for vfio_iommu_type1_pin_pages
- Link to v3: https://lore.kernel.org/r/20251010-fix-unmap-v3-0-306c724d6998@fb.com

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
Alex Mastro (5):
      vfio/type1: sanitize for overflow using check_*_overflow()
      vfio/type1: move iova increment to unmap_unpin_*() caller
      vfio/type1: handle DMA map/unmap up to the addressable limit
      vfio: selftests: update DMA map/unmap helpers to support more test kinds
      vfio: selftests: add end of address space DMA map/unmap tests

 drivers/vfio/vfio_iommu_type1.c                    | 173 +++++++++++++--------
 .../testing/selftests/vfio/lib/include/vfio_util.h |  27 +++-
 tools/testing/selftests/vfio/lib/vfio_pci_device.c | 104 ++++++++++---
 .../testing/selftests/vfio/vfio_dma_mapping_test.c |  95 ++++++++++-
 4 files changed, 308 insertions(+), 91 deletions(-)
---
base-commit: 451bb96328981808463405d436bd58de16dd967d
change-id: 20251005-fix-unmap-c3f3e87dabfa

Best regards,
-- 
Alex Mastro <amastro@fb.com>


