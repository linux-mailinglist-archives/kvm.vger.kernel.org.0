Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05E41349A26
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 20:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhCYT0I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 15:26:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23410 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229629AbhCYT0F (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Mar 2021 15:26:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616700364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VUCFhgt8H3pD4Jc06Dq2JQVvaymrLHwIOpHt+OwmdAw=;
        b=NEyp5FBBySCsifbz7H7ByKVzUDGXv5BsutMYIWl/iOzMSrHx51P0Nfx+FeheLzrfeBOy0x
        qDAP/EeHqlnleeRDZreXkK+eLTvqH58OdFBKAKdBXyByHr0m9ZzF1d9d1ppOHOtdJ2HN5A
        6/Wiqy0xEyOVyYvWvp0GWpxLb1pqkA8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-527-gRb8uOYuP9OvZPjY131i6A-1; Thu, 25 Mar 2021 15:25:54 -0400
X-MC-Unique: gRb8uOYuP9OvZPjY131i6A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 551B6107ACCD;
        Thu, 25 Mar 2021 19:25:53 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-120.phx2.redhat.com [10.3.112.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B3F8C5C3DF;
        Thu, 25 Mar 2021 19:25:52 +0000 (UTC)
Date:   Thu, 25 Mar 2021 13:25:51 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Steven Sistare <steven.sistare@oracle.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio/type1: Empty batch for pfnmap pages
Message-ID: <20210325132551.4c7ce805@omen.home.shazbot.org>
In-Reply-To: <20210325010552.185481-1-daniel.m.jordan@oracle.com>
References: <20210325010552.185481-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/0bR2E+FyYp1zvNwC+5IteY."
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--MP_/0bR2E+FyYp1zvNwC+5IteY.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, 24 Mar 2021 21:05:52 -0400
Daniel Jordan <daniel.m.jordan@oracle.com> wrote:

> When vfio_pin_pages_remote() returns with a partial batch consisting of
> a single VM_PFNMAP pfn, a subsequent call will unfortunately try
> restoring it from batch->pages, resulting in vfio mapping the wrong page
> and unbalancing the page refcount.
> 
> Prevent the function from returning with this kind of partial batch to
> avoid the issue.  There's no explicit check for a VM_PFNMAP pfn because
> it's awkward to do so, so infer it from characteristics of the batch
> instead.  This may result in occasional false positives but keeps the
> code simpler.
> 
> Fixes: 4d83de6da265 ("vfio/type1: Batch page pinning")
> Link: https://lkml.kernel.org/r/20210323133254.33ed9161@omen.home.shazbot.org/
> Reported-by: Alex Williamson <alex.williamson@redhat.com>
> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
> ---
> 
> Alex, I couldn't immediately find a way to trigger this bug, but I can
> run your test case if you like.
> 
> This is the minimal fix, but it should still protect all calls of
> vfio_batch_unpin() from this problem.

Thanks, applied to my for-linus branch for v5.12.  The attached unit
test triggers the issue, I don't have any real world examples and was
only just experimenting with this for another series earlier this week.
Thanks,

Alex

--MP_/0bR2E+FyYp1zvNwC+5IteY.
Content-Type: text/x-c++src
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=alternate-pfnmap.c

/*
 * Alternate pages of device memory and anonymous memory within a single DMA
 * mapping.
 *
 * Run with argv[1] as a fully specified PCI device already bound to vfio-pci.
 * ex. "alternate-pfnmap 0000:01:00.0"
 */
#include <errno.h>
#include <libgen.h>
#include <fcntl.h>
#include <signal.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/eventfd.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <sys/types.h>

#include <linux/ioctl.h>
#include <linux/vfio.h>
#include <linux/pci_regs.h>

void *vaddr = (void *)0x100000000;
size_t map_size = 0;

int get_container(void)
{
	int container = open("/dev/vfio/vfio", O_RDWR);

	if (container < 0)
		fprintf(stderr, "Failed to open /dev/vfio/vfio, %d (%s)\n",
		       container, strerror(errno));

	return container;
}

int get_group(char *name)
{
	int seg, bus, slot, func;
	int ret, group, groupid;
	char path[50], iommu_group_path[50], *group_name;
	struct stat st;
	ssize_t len;
	struct vfio_group_status group_status = {
		.argsz = sizeof(group_status)
	};

	ret = sscanf(name, "%04x:%02x:%02x.%d", &seg, &bus, &slot, &func);
	if (ret != 4) {
		fprintf(stderr, "Invalid device\n");
		return -EINVAL;
	}

	snprintf(path, sizeof(path),
		 "/sys/bus/pci/devices/%04x:%02x:%02x.%01x/",
		 seg, bus, slot, func);

	ret = stat(path, &st);
	if (ret < 0) {
		fprintf(stderr, "No such device\n");
		return ret;
	}

	strncat(path, "iommu_group", sizeof(path) - strlen(path) - 1);

	len = readlink(path, iommu_group_path, sizeof(iommu_group_path));
	if (len <= 0) {
		fprintf(stderr, "No iommu_group for device\n");
		return -EINVAL;
	}

	iommu_group_path[len] = 0;
	group_name = basename(iommu_group_path);

	if (sscanf(group_name, "%d", &groupid) != 1) {
		fprintf(stderr, "Unknown group\n");
		return -EINVAL;
	}

	snprintf(path, sizeof(path), "/dev/vfio/%d", groupid);
	group = open(path, O_RDWR);
	if (group < 0) {
		fprintf(stderr, "Failed to open %s, %d (%s)\n",
		       path, group, strerror(errno));
		return group;
	}

	ret = ioctl(group, VFIO_GROUP_GET_STATUS, &group_status);
	if (ret) {
		fprintf(stderr, "ioctl(VFIO_GROUP_GET_STATUS) failed\n");
		return ret;
	}

	if (!(group_status.flags & VFIO_GROUP_FLAGS_VIABLE)) {
		fprintf(stderr,
			"Group not viable, all devices attached to vfio?\n");
		return -1;
	}

	return group;
}

int group_set_container(int group, int container)
{
	int ret = ioctl(group, VFIO_GROUP_SET_CONTAINER, &container);

	if (ret)
		fprintf(stderr, "Failed to set group container\n");

	return ret;
}

int container_set_iommu(int container)
{
	int ret = ioctl(container, VFIO_SET_IOMMU, VFIO_TYPE1_IOMMU);

	if (ret)
		fprintf(stderr, "Failed to set IOMMU\n");

	return ret;
}

int group_get_device(int group, char *name)
{
	int device = ioctl(group, VFIO_GROUP_GET_DEVICE_FD, name);

	if (device < 0)
		fprintf(stderr, "Failed to get device\n");

	return device;
}

void *mmap_device_page(int device, int prot)
{
	struct vfio_region_info config_info = {
		.argsz = sizeof(config_info),
		.index = VFIO_PCI_CONFIG_REGION_INDEX
	};
	struct vfio_region_info region_info = {
		.argsz = sizeof(region_info)
	};
	void *map = MAP_FAILED;
	unsigned int bar;
	int i, ret;

	ret = ioctl(device, VFIO_DEVICE_GET_REGION_INFO, &config_info);
	if (ret) {
		fprintf(stderr, "Failed to get config space region info\n");
		return map;
	}

	for (i = 0; i < 6; i++) {
		if (pread(device, &bar, sizeof(bar), config_info.offset +
			  PCI_BASE_ADDRESS_0 + (4 * i)) != sizeof(bar)) {
			fprintf(stderr, "Error reading BAR%d\n", i);
			return map;
		}

		if (!(bar & PCI_BASE_ADDRESS_SPACE)) {
			break;
tryagain:
			if (bar & PCI_BASE_ADDRESS_MEM_TYPE_64)
				i++;
		}
	}

	if (i >= 6) {
		fprintf(stderr, "No memory BARs found\n");
		return map;
	}

	region_info.index = VFIO_PCI_BAR0_REGION_INDEX + i;
	ret = ioctl(device, VFIO_DEVICE_GET_REGION_INFO, &region_info);
	if (ret) {
		fprintf(stderr, "Failed to get BAR%d region info\n", i);
		return map;
	}
  
	if (!(region_info.flags & VFIO_REGION_INFO_FLAG_MMAP)) {
		printf("No mmap support, try next\n");
		goto tryagain;
	}

	if (region_info.size < getpagesize()) {
		printf("Too small for mmap, try next\n");
		goto tryagain;
	}

	map = mmap(vaddr + map_size, getpagesize(), prot, 
		   MAP_SHARED, device, region_info.offset);
	if (map == MAP_FAILED) {
		fprintf(stderr, "Error mmap'ing BAR: %m\n");
		goto tryagain;
	}

	fprintf(stderr, "\t\tmmap_device_page @0x%016lx\n",
						(unsigned long long)map);
	if (!vaddr) {
		vaddr = map;
	} else if (map != vaddr + map_size) {
		fprintf(stderr, "Did not get contiguous mmap\n");
		munmap(map, getpagesize());
		return MAP_FAILED;
	}

	map_size += getpagesize();

	return map;
}

void *mmap_mem_page(int prot)
{
	void *map = mmap(vaddr + map_size, getpagesize(), prot,
			 MAP_PRIVATE | MAP_ANONYMOUS, 0, 0);

	if (map == MAP_FAILED) {
		fprintf(stderr, "Map anonymous page failed: %m\n");
		return map;
	}

	fprintf(stderr, "\t\tmmap_mem_page @0x%016lx\n",
						(unsigned long long)map);
	if (!vaddr) {
		vaddr = map;
	} else if (map != vaddr + map_size) {
		fprintf(stderr, "Did not get contiguous mmap\n");
		munmap(map, getpagesize());
		return MAP_FAILED;
	}

	map_size += getpagesize();

	return map;
}

int dma_map(int container, void *map, int size, unsigned long iova)
{
	struct vfio_iommu_type1_dma_map dma_map = {
		.argsz = sizeof(dma_map),
		.size = size,
		.vaddr = (__u64)map,
		.iova = iova,
		.flags = VFIO_DMA_MAP_FLAG_READ | VFIO_DMA_MAP_FLAG_WRITE
	};
	int ret;

	ret = ioctl(container, VFIO_IOMMU_MAP_DMA, &dma_map);
	if (ret)
		fprintf(stderr, "Failed to DMA map: %m\n");

	return ret;
}

int dma_unmap(int container, int size, unsigned long iova)
{
	struct vfio_iommu_type1_dma_unmap dma_unmap = {
		.argsz = sizeof(dma_unmap),
		.iova = iova,
		.size = size,
	};
	int ret;

	ret = ioctl(container, VFIO_IOMMU_UNMAP_DMA, &dma_unmap);
	if (ret)
		fprintf(stderr, "Failed to DMA unmap: %m\n");

	return dma_unmap.size;
}

int main(int argc, char **argv)
{
	int container1;
	int group1;
	int device1;
	int ret;
	void *map, *map_base;

	group1 = get_group(argv[1]);
	if (group1 < 0) {
		fprintf(stderr, "Failed to get group for %s\n", argv[1]);
		return group1;
	}

	fprintf(stderr, "\tGot group for %s\n", argv[1]);

	container1 = get_container();

	if (container1 < 0) {
		fprintf(stderr, "Failed to get container\n");
		return -EFAULT;
	}

	fprintf(stderr, "\tGot container\n");

	if (group_set_container(group1, container1)) {
		fprintf(stderr, "Failed to set container\n");
		return -EFAULT;
	}

	fprintf(stderr, "\tAttached group to container\n");

	if (container_set_iommu(container1)) {
		fprintf(stderr, "Failed to set iommu\n");
		return -EFAULT;
	}

	fprintf(stderr, "\tSet IOMMU model for container\n");

	device1 = group_get_device(group1, argv[1]);

	if (device1 < 0) {
		fprintf(stderr, "Failed to get devices\n");
		return -EFAULT;
	}

	fprintf(stderr, "\tGot device file descriptors\n");

	map = mmap_device_page(device1, PROT_READ | PROT_WRITE);
	if (map == MAP_FAILED) {
		fprintf(stderr, "Failed to mmap device page\n");
		return -EFAULT;
	}

	fprintf(stderr, "\tGot mmap to device %s\n", argv[1]);

	map_base = map;
	
	map = mmap_mem_page(PROT_READ | PROT_WRITE);
	if (map == MAP_FAILED) {
		fprintf(stderr, "Failed to mmap memory page\n");
		return -EFAULT;
	}

	fprintf(stderr, "\tGot memory page\n");

	map = mmap_device_page(device1, PROT_READ | PROT_WRITE);
	if (map == MAP_FAILED) {
		fprintf(stderr, "Failed to mmap device page\n");
		return -EFAULT;
	}

	fprintf(stderr, "\tGot mmap to device %s\n", argv[1]);

	map = mmap_mem_page(PROT_READ | PROT_WRITE);
	if (map == MAP_FAILED) {
		fprintf(stderr, "Failed to mmap memory page\n");
		return -EFAULT;
	}

	fprintf(stderr, "\tGot memory page\n");

	if (dma_map(container1, map_base, getpagesize() * 4,
						1024 * 1024 * 1024)) {
		fprintf(stderr, "Failed to DMA map pages\n");
		return -EFAULT;
	}

	fprintf(stderr, "\tDMA mapped pages into container for device %s\n",
		argv[1]);

	return 0;
}

--MP_/0bR2E+FyYp1zvNwC+5IteY.--

