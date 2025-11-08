Return-Path: <kvm+bounces-62408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id E4C1EC43489
	for <lists+kvm@lfdr.de>; Sat, 08 Nov 2025 21:20:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7CCC44E1242
	for <lists+kvm@lfdr.de>; Sat,  8 Nov 2025 20:20:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18EA4281341;
	Sat,  8 Nov 2025 20:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="CVnTj1PR"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3621EDA03;
	Sat,  8 Nov 2025 20:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762633210; cv=none; b=uDl5/sLEFRFP+ah5kLIsCaohPAGjGrkyE7Xhk7HTTVl9pcFl/3/4nEaKUC41vUuZ4EuqNk++tGhMjREkdQ+oWA9637dgWOlETntWYW8RY+/OQHbxVj6pE51B4JD0F1BdvOP1bsoO3eG7xJ8GpUh8p1Y0BoLGo8912Yt7GbRAWoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762633210; c=relaxed/simple;
	bh=uWd+8LaOb64zw1gCR2Ogy/YKa0ncigzkQ8bdHe2O7ds=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I0+9AeR1N6GzD4oPVDjD7CyYWf0u0T+Fu6/p0xqrEWNMNpkiHyv/py2QkuRaCXMrnWtzG9RYhIqEHYug4HLQLHma2GBeeKGB6hWBvUbS8nM8MvWh56wbuHkfCo+BtHnjfMJBppDdMPbEqedvwxUIQT8TAYSmqfcVxTzxMxBdp2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=CVnTj1PR; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 5A88TvHO3962529;
	Sat, 8 Nov 2025 12:20:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=s2048-2025-q2; bh=Wvm03hY5MySQ4qPJDErK
	e1pJJzKY/gZ7bL/aQEbSLkY=; b=CVnTj1PRO8Ls/1rkGYGZr5ofWnHYBTrhUo9D
	ZHLPxltToA+dlTVqw01tt9aqTNCpTppmn56ZGgOcI7QdO/uCDMC8Xwi72wq/mugH
	DzqBi1cDQ2HX/E+XgvF90+5D6xi61j3qsjPhWaQISUbFEZicWLAiN+Maa6wLkiRR
	Vuna2HK1cQwT46fT0nrdCKe/BUwFEJKBcoy1qle4oCylmvz3T404nZJCSYnW8/mU
	l9N23V1el7P+eOd3UeaNdFEP2esQWb1cyX/tImw9CVqPTNQ0e/5zsjE46h3E+nie
	KEQwsTYkQUIbpL5CoI/PbYsVgnCPa8ss4aY381tW0YDleQdmHw==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by m0001303.ppops.net (PPS) with ESMTPS id 4aa2dc3mc9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sat, 08 Nov 2025 12:19:59 -0800 (PST)
Received: from devgpu015.cco6.facebook.com (2620:10d:c0a8:fe::f072) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Sat, 8 Nov 2025 20:19:58 +0000
Date: Sat, 8 Nov 2025 12:19:48 -0800
From: Alex Mastro <amastro@fb.com>
To: David Matlack <dmatlack@google.com>
CC: Alex Williamson <alex.williamson@redhat.com>,
        Alex Williamson
	<alex@shazbot.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfio: selftests: Skip vfio_dma_map_limit_test if mapping
 returns -EINVAL
Message-ID: <aQ+l5IRtFaE24v0g@devgpu015.cco6.facebook.com>
References: <20251107222058.2009244-1-dmatlack@google.com>
 <aQ6MFM1NX8WsDIdX@devgpu015.cco6.facebook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aQ6MFM1NX8WsDIdX@devgpu015.cco6.facebook.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDE2NSBTYWx0ZWRfX3TYqxhH2rkV/
 sYPRzyEcdFajLgc8QiHD0ziGyPmcXb+1NOur6vBxOVG38lr6utdMiTbWB12NBKhcep8HMzQ0JzD
 P9S5JCtewEsnRvph+WLNlDp+N4K8V0glBpCvo31Mco/7eEJKEUWjmFTUOIV4wj8cx9jvu/4gCbi
 Fb9n/Vxa5fx1PIGtstTODNGCEdi+JXz2I3KEaM6YRPKdO6DdGIdO9f1qnoJYP9TtBuFRvoW7VLM
 svfMG1UveNU6+9XWb4BA0Y0UNs33INLRcHgPu0al4YUENXvhuXEz2xD/kUgKarmMV20lIThhkhp
 ayA8IXdAl3HfdLNMjV9R/LelbU3LT585GrFKhsRPJEKeA4mUZL16HSDRCFZpxrJcMHL8Izjq6Pg
 RNRNYAYhoONyNC76TfZea38BSt0Ucw==
X-Proofpoint-GUID: VYygzmEVFEN9QnTrk_WytIGnyfxn1n2l
X-Authority-Analysis: v=2.4 cv=P7w3RyAu c=1 sm=1 tr=0 ts=690fa5ef cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=kj9zAlcOel0A:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=FOH2dFAWAAAA:8 a=aRoULv6RtVEqcK-AljkA:9 a=CjuIK1q_8ugA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: VYygzmEVFEN9QnTrk_WytIGnyfxn1n2l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-08_06,2025-11-06_01,2025-10-01_01

On Fri, Nov 07, 2025 at 04:17:24PM -0800, Alex Mastro wrote:
> On Fri, Nov 07, 2025 at 10:20:58PM +0000, David Matlack wrote:
> > Skip vfio_dma_map_limit_test.{unmap_range,unmap_all} (instead of
> > failing) on systems that do not support mapping in the page-sized region
> > at the top of the u64 address space. Use -EINVAL as the signal for
> > detecting systems with this limitation, as that is what both VFIO Type1
> > and iommufd return.
> > 
> > A more robust solution that could be considered in the future would be
> > to explicitly check the range of supported IOVA regions and key off
> > that, instead of inferring from -EINVAL.
> > 
> > Fixes: de8d1f2fd5a5 ("vfio: selftests: add end of address space DMA map/unmap tests")
> > Signed-off-by: David Matlack <dmatlack@google.com>
> 
> Makes sense -- thanks David. Agree about keying this off
> VFIO_IOMMU_TYPE1_INFO_CAP_IOVA_RANGE longer term.
> 
> Reviewed-by: Alex Mastro <amastro@fb.com>

Here's my attempt at adding some machinery to query iova ranges, with
normalization to iommufd's struct. I kept the vfio capability chain stuff
relatively generic so we can use it for other things in the future if needed.

I can sequence this after your fix?

diff --git a/tools/testing/selftests/vfio/lib/include/vfio_util.h b/tools/testing/selftests/vfio/lib/include/vfio_util.h
index 240409bf5f8a..fb5efec52316 100644
--- a/tools/testing/selftests/vfio/lib/include/vfio_util.h
+++ b/tools/testing/selftests/vfio/lib/include/vfio_util.h
@@ -4,9 +4,12 @@
 
 #include <fcntl.h>
 #include <string.h>
-#include <linux/vfio.h>
+
+#include <uapi/linux/types.h>
+#include <linux/iommufd.h>
 #include <linux/list.h>
 #include <linux/pci_regs.h>
+#include <linux/vfio.h>
 
 #include "../../../kselftest.h"
 
@@ -206,6 +209,9 @@ struct vfio_pci_device *vfio_pci_device_init(const char *bdf, const char *iommu_
 void vfio_pci_device_cleanup(struct vfio_pci_device *device);
 void vfio_pci_device_reset(struct vfio_pci_device *device);
 
+struct iommu_iova_range *vfio_pci_iova_ranges(struct vfio_pci_device *device,
+					      size_t *nranges);
+
 int __vfio_pci_dma_map(struct vfio_pci_device *device,
 		       struct vfio_dma_region *region);
 int __vfio_pci_dma_unmap(struct vfio_pci_device *device,
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index a381fd253aa7..3297a41fdc31 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -29,6 +29,145 @@
 	VFIO_ASSERT_EQ(__ret, 0, "ioctl(%s, %s, %s) returned %d\n", #_fd, #_op, #_arg, __ret); \
 } while (0)
 
+static struct vfio_info_cap_header *next_cap_hdr(void *buf, size_t bufsz,
+						 size_t *cap_offset)
+{
+	struct vfio_info_cap_header *hdr;
+
+	if (!*cap_offset)
+		return NULL;
+
+	/* Cap offset must be in bounds */
+	VFIO_ASSERT_LT(*cap_offset, bufsz);
+	/* There must be enough remaining space to contain the header */
+	VFIO_ASSERT_GE(bufsz - *cap_offset, sizeof(*hdr));
+	hdr = (struct vfio_info_cap_header *)((u8 *)buf + *cap_offset);
+	/* If there is a next, offset must monotonically increase */
+	if (hdr->next)
+		VFIO_ASSERT_GT(hdr->next, *cap_offset);
+	*cap_offset = hdr->next;
+
+	return hdr;
+}
+
+static struct vfio_info_cap_header *vfio_iommu_info_cap_hdr(struct vfio_iommu_type1_info *buf,
+							    u16 cap_id)
+{
+	struct vfio_info_cap_header *hdr;
+	size_t cap_offset = buf->cap_offset;
+
+	if (!(buf->flags & VFIO_IOMMU_INFO_CAPS))
+		return NULL;
+
+	if (cap_offset)
+		VFIO_ASSERT_GE(cap_offset, sizeof(struct vfio_iommu_type1_info));
+
+	while ((hdr = next_cap_hdr(buf, buf->argsz, &cap_offset))) {
+		if (hdr->id == cap_id)
+			return hdr;
+	}
+
+	return NULL;
+}
+
+/* Return buffer including capability chain, if present. Free with free() */
+static struct vfio_iommu_type1_info *vfio_iommu_info_buf(struct vfio_pci_device *device)
+{
+	struct vfio_iommu_type1_info *buf;
+
+	buf = malloc(sizeof(*buf));
+	VFIO_ASSERT_NOT_NULL(buf);
+
+	*buf = (struct vfio_iommu_type1_info) {
+		.argsz = sizeof(*buf),
+	};
+
+	ioctl_assert(device->container_fd, VFIO_IOMMU_GET_INFO, buf);
+
+	buf = realloc(buf, buf->argsz);
+	VFIO_ASSERT_NOT_NULL(buf);
+
+	ioctl_assert(device->container_fd, VFIO_IOMMU_GET_INFO, buf);
+
+	return buf;
+}
+
+/*
+ * Normalize vfio_iommu_type1 to report iommufd's iommu_iova_range. Free with
+ * free().
+ */
+static struct iommu_iova_range *vfio_iommu_iova_ranges(struct vfio_pci_device *device,
+						       size_t *nranges)
+{
+	struct vfio_iommu_type1_info_cap_iova_range *cap_range;
+	struct vfio_iommu_type1_info *buf;
+	struct vfio_info_cap_header *hdr;
+	struct iommu_iova_range *ranges = NULL;
+
+	buf = vfio_iommu_info_buf(device);
+	VFIO_ASSERT_NOT_NULL(buf);
+
+	hdr = vfio_iommu_info_cap_hdr(buf, VFIO_IOMMU_TYPE1_INFO_CAP_IOVA_RANGE);
+	if (!hdr)
+		goto free_buf;
+
+	cap_range = container_of(hdr, struct vfio_iommu_type1_info_cap_iova_range, header);
+	if (!cap_range->nr_iovas)
+		goto free_buf;
+
+	ranges = malloc(cap_range->nr_iovas * sizeof(*ranges));
+	VFIO_ASSERT_NOT_NULL(ranges);
+
+	for (u32 i = 0; i < cap_range->nr_iovas; i++) {
+		ranges[i] = (struct iommu_iova_range){
+			.start = cap_range->iova_ranges[i].start,
+			.last = cap_range->iova_ranges[i].end,
+		};
+	}
+
+	*nranges = cap_range->nr_iovas;
+
+free_buf:
+	free(buf);
+	return ranges;
+}
+
+struct iommu_iova_range *iommufd_iova_ranges(struct vfio_pci_device *device,
+					     size_t *nranges)
+{
+	struct iommu_iova_range *ranges;
+	int ret;
+
+	struct iommu_ioas_iova_ranges query = {
+		.size = sizeof(query),
+		.ioas_id = device->ioas_id,
+	};
+
+	ret = ioctl(device->iommufd, IOMMU_IOAS_IOVA_RANGES, &query);
+	VFIO_ASSERT_EQ(ret, -1);
+	VFIO_ASSERT_EQ(errno, EMSGSIZE);
+	VFIO_ASSERT_GT(query.num_iovas, 0);
+
+	ranges = malloc(query.num_iovas * sizeof(*ranges));
+	VFIO_ASSERT_NOT_NULL(ranges);
+
+	query.allowed_iovas = (uintptr_t)ranges;
+
+	ioctl_assert(device->iommufd, IOMMU_IOAS_IOVA_RANGES, &query);
+	*nranges = query.num_iovas;
+
+	return ranges;
+}
+
+struct iommu_iova_range *vfio_pci_iova_ranges(struct vfio_pci_device *device,
+					      size_t *nranges)
+{
+	if (device->iommufd)
+		return iommufd_iova_ranges(device, nranges);
+
+	return vfio_iommu_iova_ranges(device, nranges);
+}
+
 iova_t __to_iova(struct vfio_pci_device *device, void *vaddr)
 {
 	struct vfio_dma_region *region;
diff --git a/tools/testing/selftests/vfio/vfio_dma_mapping_test.c b/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
index 4f1ea79a200c..78983c4c293b 100644
--- a/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
+++ b/tools/testing/selftests/vfio/vfio_dma_mapping_test.c
@@ -3,6 +3,8 @@
 #include <sys/mman.h>
 #include <unistd.h>
 
+#include <uapi/linux/types.h>
+#include <linux/iommufd.h>
 #include <linux/limits.h>
 #include <linux/mman.h>
 #include <linux/sizes.h>
@@ -243,12 +245,31 @@ FIXTURE_TEARDOWN(vfio_dma_map_limit_test)
 	ASSERT_EQ(munmap(self->region.vaddr, self->mmap_size), 0);
 }
 
+static iova_t last_legal_iova(struct vfio_pci_device *device)
+{
+	struct iommu_iova_range *ranges;
+	size_t nranges;
+	iova_t ret;
+
+	ranges = vfio_pci_iova_ranges(device, &nranges);
+	VFIO_ASSERT_NOT_NULL(ranges);
+
+	ret = ranges[nranges - 1].last;
+	free(ranges);
+
+	return ret;
+}
+
 TEST_F(vfio_dma_map_limit_test, unmap_range)
 {
+	iova_t last_iova = last_legal_iova(self->device);
 	struct vfio_dma_region *region = &self->region;
 	u64 unmapped;
 	int rc;
 
+	if (last_iova != ~(iova_t)0)
+		SKIP(return, "last legal iova=0x%lx\n", last_iova);
+
 	vfio_pci_dma_map(self->device, region);
 	ASSERT_EQ(region->iova, to_iova(self->device, region->vaddr));
 
@@ -259,10 +280,14 @@ TEST_F(vfio_dma_map_limit_test, unmap_range)
 
 TEST_F(vfio_dma_map_limit_test, unmap_all)
 {
+	iova_t last_iova = last_legal_iova(self->device);
 	struct vfio_dma_region *region = &self->region;
 	u64 unmapped;
 	int rc;
 
+	if (last_iova != ~(iova_t)0)
+		SKIP(return, "last legal iova=0x%lx\n", last_iova);
+
 	vfio_pci_dma_map(self->device, region);
 	ASSERT_EQ(region->iova, to_iova(self->device, region->vaddr));
 

