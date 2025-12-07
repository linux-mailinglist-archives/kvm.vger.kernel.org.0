Return-Path: <kvm+bounces-65472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A27BCAB302
	for <lists+kvm@lfdr.de>; Sun, 07 Dec 2025 10:13:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 348CB307A9F3
	for <lists+kvm@lfdr.de>; Sun,  7 Dec 2025 09:13:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C7052EB87F;
	Sun,  7 Dec 2025 09:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="h3vFmyyz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F9D2AF00;
	Sun,  7 Dec 2025 09:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765098805; cv=none; b=t9o2qDo6RRDjU71EeZR/OlV4yR5wuRgA9L38ZKWnK05ZHCKX1/3RXfxRcMW8Zw1ZNd9NNH+5GbN2wEopkGjrfzrMA5rqV34CRxW67mrxI46tIXs7udfI7XV6Xd/OlK2+aoAGKf/soBRID7e1z7RMTZ1z9K85+sN8yUkuli+wwxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765098805; c=relaxed/simple;
	bh=5QradnOQJTlwsjy23xFPIZlFfkaRQgoartrQNAGccso=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QhdPZj3xSqKGGMlqKNQV323jzJM7jesLVUUdKdDY07t1K9IF4BW2IH3kHabYIjAi2oEc0Kw1hFOMg3ofuDfom+LlriQwKdq+N1z8+ud4huX4dqnLyg5GWiUc6EI/BOkOkDOkbJBAbvllehnPq7Fa2NvYokIOVEFTjbn9TPoXEs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=h3vFmyyz; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B79BpKM1056663;
	Sun, 7 Dec 2025 01:13:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=s2048-2025-q2; bh=MDlVOO4f4jLAtS9IkeS/
	9IQLKfCdvmm9Ok7QfBI5TfU=; b=h3vFmyyzFQZlcvxDC4RX+Io337UfOupkB3ps
	lbBnEwkFb6xeEPelHp6gWcQtCSbyszT/wKXehF/DkQGXR4I4mVmRFArNSdeeSm6t
	KNN0cQCAfHT3TjtuXJvqentwhO8cqzVCq0Ft4rE6bPji6kjnPompCXlgBIYGXeAo
	zMIsDx6paoCV9jzYv7SqDCQd8kOp2A4ijlpcnz4I/4R03HAy7o9r17osRq7R0Nft
	66//SDNWtFMkOOss8Zp6vK70IZ4J24LJ9X/CPsHsNTP0qP5iHtoyqHsA9rmJg9I2
	XEBtmSaBiUzQIb1801oBUiMsXFt8SAgxMwAtOTtJ5Sh/bvCseQ==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4avk3h3s6b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sun, 07 Dec 2025 01:13:11 -0800 (PST)
Received: from devgpu015.cco6.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.29; Sun, 7 Dec 2025 09:13:10 +0000
Date: Sun, 7 Dec 2025 01:13:05 -0800
From: Alex Mastro <amastro@fb.com>
To: Peter Xu <peterx@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
        Nico Pache
	<npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
        David Hildenbrand
	<david@redhat.com>,
        Alex Williamson <alex@shazbot.org>, Zhi Wang
	<zhiw@nvidia.com>,
        David Laight <david.laight.linux@gmail.com>,
        Yi Liu
	<yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
        Kevin Tian
	<kevin.tian@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 0/4] mm/vfio: huge pfnmaps with !MAP_FIXED mappings
Message-ID: <aTVFIdUJcCQjlrdn@devgpu015.cco6.facebook.com>
References: <20251204151003.171039-1-peterx@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251204151003.171039-1-peterx@redhat.com>
X-Proofpoint-ORIG-GUID: rYM6VHrLaiGfh2WtIn0VoaPTRfmLm5To
X-Proofpoint-GUID: rYM6VHrLaiGfh2WtIn0VoaPTRfmLm5To
X-Authority-Analysis: v=2.4 cv=eunSD4pX c=1 sm=1 tr=0 ts=69354528 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=kj9zAlcOel0A:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=FOH2dFAWAAAA:8 a=m7gy3HII4n3VcIQTDVgA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA3MDA4MSBTYWx0ZWRfX0TmA0tB2xvRP
 HsbJlb4gLpCkEB3XVUB7P8A2XzW7+l82bAsnRz4S692hRozxpbJLVJni4Z0uf4IPoBXkUgPoP4H
 OxcwpZROFi6sVjPORqKT1jeOsaUaM3fLiPBGVDHx0+ilM6E6c3zBmBc8MSsazlHQGb60xp0y/CX
 mChKP0Q2d1cmFAbGaVr8e3wSJ+E60i1Ysfk6kAIaHXT1efJoEo7YhfTDZjpUXmOqsLQjCdGX15Z
 PU3D2TlQjaKBjQfDmulUgW3Q43TAIr9fDPnmAxCzohOmn768lizyX84jYUj0a1xwOdEfD7ctXot
 l/8d99thZGtCSTcSftN7RPUq5TrQiWkxeOY24cBNF+tXYyD9k7ApDKM2niwel8CYERYZG+jaxUx
 NE8gnNj34kdprJW/W61kLdQMwvbCKg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-06_02,2025-12-04_04,2025-10-01_01

On Thu, Dec 04, 2025 at 10:09:59AM -0500, Peter Xu wrote:
> Alex Mastro: thanks for the testing offered in v1, but since this series
> was rewritten, a re-test will be needed.  I hence didn't collect the T-b.
 
Thank Peter, LGTM.

Tested-by: Alex Mastro <amastro@fb.com>

$ cc -Og -Wall -Wextra test_vfio_map_dma.c -o test_vfio_map_dma
$ ./test_vfio_map_dma 0000:05:00.0 4 0x600000 0x800000000 0x100000000
opening 0000:05:00.0 via /dev/vfio/39
BAR 4: size=0x2000000000, offset=0x40000000000, flags=0x7
mmap'd BAR 4: offset=0x600000, size=0x800000000 -> vaddr=0x7fdac0600000
VFIO_IOMMU_MAP_DMA: vaddr=0x7fdac0600000, iova=0x100000000, size=0x800000000

$ sudo bpftrace -q -e 'fexit:vfio_pci_mmap_huge_fault { printf("order=%d, ret=0x%x\n", args.order, retval); }' 2>&1 > ~/dump
$ cat ~/dump | sort | uniq -c | sort -nr
    512 order=9, ret=0x100
     31 order=18, ret=0x100
      2
      1 order=18, ret=0x800

test_vfio_map_dma.c
---
#include <errno.h>
#include <fcntl.h>
#include <libgen.h>
#include <linux/limits.h>
#include <linux/types.h>
#include <linux/vfio.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <unistd.h>

#define ensure(cond)                                                             \
	do {                                                                     \
		if (!(cond)) {                                                   \
			fprintf(stderr,                                          \
				"%s:%d Condition failed: '%s' (errno=%d: %s)\n", \
				__FILE__, __LINE__, #cond, errno,                \
				strerror(errno));                                \
			exit(EXIT_FAILURE);                                      \
		}                                                                \
	} while (0)

static uint32_t group_for_bdf(const char *bdf)
{
	char path[PATH_MAX];
	char link[PATH_MAX];
	int ret;

	snprintf(path, sizeof(path), "/sys/bus/pci/devices/%s/iommu_group",
		 bdf);
	ret = readlink(path, link, sizeof(link));
	ensure(ret > 0);

	const char *filename = basename(link);
	ensure(filename);

	return strtoul(filename, NULL, 0);
}

int main(int argc, char **argv)
{
	int ret;

	if (argc != 6) {
		printf("usage: %s <vfio_bdf> <bar_idx> <bar_offset> <size> <iova>\n",
		       argv[0]);
		printf("example: %s 0000:05:00.0 2 0x20000 0x1000 0x100000\n",
		       argv[0]);
		return 1;
	}

	const char *bdf = argv[1];
	uint32_t bar_idx = strtoul(argv[2], NULL, 0);
	uint64_t bar_offs = strtoull(argv[3], NULL, 0);
	uint64_t size = strtoull(argv[4], NULL, 0);
	uint64_t iova = strtoull(argv[5], NULL, 0);

	uint32_t group_num = group_for_bdf(bdf);
	char group_path[PATH_MAX];
	snprintf(group_path, sizeof(group_path), "/dev/vfio/%u", group_num);

	int container_fd = open("/dev/vfio/vfio", O_RDWR);
	ensure(container_fd >= 0);

	printf("opening %s via %s\n", bdf, group_path);
	int group_fd = open(group_path, O_RDWR);
	ensure(group_fd >= 0);

	ret = ioctl(group_fd, VFIO_GROUP_SET_CONTAINER, &container_fd);
	ensure(!ret);

	ret = ioctl(container_fd, VFIO_SET_IOMMU, VFIO_TYPE1v2_IOMMU);
	ensure(!ret);

	int device_fd = ioctl(group_fd, VFIO_GROUP_GET_DEVICE_FD, bdf);
	ensure(device_fd >= 0);

	/* Get region info for the BAR */
	struct vfio_region_info region_info = {
		.argsz = sizeof(region_info),
		.index = bar_idx,
	};
	ret = ioctl(device_fd, VFIO_DEVICE_GET_REGION_INFO, &region_info);
	ensure(!ret);

	printf("BAR %u: size=0x%llx, offset=0x%llx, flags=0x%x\n", bar_idx,
	       region_info.size, region_info.offset, region_info.flags);

	ensure(region_info.flags & VFIO_REGION_INFO_FLAG_MMAP);
	ensure(bar_offs + size <= region_info.size);

	/* mmap the BAR at the specified offset */
	void *bar_mmap = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED,
			      device_fd, region_info.offset + bar_offs);
	ensure(bar_mmap != MAP_FAILED);

	ret = madvise(bar_mmap, size, MADV_HUGEPAGE);
	ensure(!ret);

	printf("mmap'd BAR %u: offset=0x%lx, size=0x%lx -> vaddr=%p\n", bar_idx,
	       bar_offs, size, bar_mmap);

	/* Map the mmap'd address into IOMMU using VFIO_IOMMU_MAP_DMA */
	struct vfio_iommu_type1_dma_map dma_map = {
		.argsz = sizeof(dma_map),
		.flags = VFIO_DMA_MAP_FLAG_READ | VFIO_DMA_MAP_FLAG_WRITE,
		.vaddr = (uint64_t)bar_mmap,
		.iova = iova,
		.size = size,
	};

	printf("VFIO_IOMMU_MAP_DMA: vaddr=%p, iova=0x%llx, size=0x%lx\n",
	       bar_mmap, (unsigned long long)dma_map.iova, size);

	ret = ioctl(container_fd, VFIO_IOMMU_MAP_DMA, &dma_map);
	ensure(!ret);

	/* Cleanup */
	struct vfio_iommu_type1_dma_unmap dma_unmap = {
		.argsz = sizeof(dma_unmap),
		.iova = dma_map.iova,
		.size = size,
	};
	ret = ioctl(container_fd, VFIO_IOMMU_UNMAP_DMA, &dma_unmap);
	ensure(!ret);

	ret = munmap(bar_mmap, size);
	ensure(!ret);

	close(device_fd);
	close(group_fd);
	close(container_fd);

	return 0;
}

