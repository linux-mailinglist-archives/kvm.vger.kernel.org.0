Return-Path: <kvm+bounces-58051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B1ABB872C7
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 23:45:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E858D1C873AA
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 21:46:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FB592FD7CE;
	Thu, 18 Sep 2025 21:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="zBQb7SCY"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F102BEC2A;
	Thu, 18 Sep 2025 21:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758231931; cv=none; b=iiN//OVtaPX0XB0znb0F5et61FJoxkSqtM1vNp+/aaOR7d7G9AYb3miRuQtQMloHC688UR5Z4BGaoqP/bIPWckB/+67SORT+AYSt36hZFW29KcBdkNOVCjpRGEWDd4gHEDAgTRyvMDuRCG4blKF68neLGyGFJfjdWEJdM004AWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758231931; c=relaxed/simple;
	bh=UdenWNTPD8z38LLdeVYNODy2qm2sB45jEaWygA5uVnk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TNRKinAMtg4GQDROyAyoXoFuD0MDpL7cOnqUIp6S6cryWxg49rJQOaALRSqtgIG7X+kOFmrY+kSIocewKbKe697PjgIW8XuwkaBRqlkn1eTWPgxsGQ3O0tyeSJOnmEhZpuJBn8nKZjrQ3zH0m0mBQtiVI/z2N3YxUZX+0Zvlcqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=zBQb7SCY; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 58ILEuwp407805;
	Thu, 18 Sep 2025 14:45:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=bMo3hezyytSvwDq2dx
	t0/0pQ5nUHXn3qBtN4ZaZSRXw=; b=zBQb7SCY+4tbpwPT0f5CqxY1yaSKQWfd/p
	MHbjnQY9szlTiCybfYxRBrJhTwBKhmtvIIDhvkZI+xD+QchOG3RCtflnkVdMGrTf
	ebwsq7JQzILNYmJby9oEuzGzv8Nu2L+soqdp1l4jinlWOu1U9cxFe0w65Kxs8sXq
	eduorASnpDBTJsoNkxah5xOAuC8R+Xqvy0iIHWMTX/E/xyYOcGzf//3HEmcKSKg/
	MdwUrUTI+lPV/cAkSrpSJcNlQmiJGibTUpVC0osIvyy6IzEn06STG91OAK/RHbE2
	4SAISObSiB6rXKJHNTQIWI7x5hM1GirYLAkW0DN1ulkdOeXCiBZQ==
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0001303.ppops.net (PPS) with ESMTPS id 498q90smej-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Thu, 18 Sep 2025 14:45:01 -0700 (PDT)
Received: from devgpu015.cco6.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Thu, 18 Sep 2025 21:44:59 +0000
From: Alex Mastro <amastro@fb.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe
	<jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, David Reiss <dreiss@meta.com>,
        "Joerg
 Roedel" <joro@8bytes.org>, Keith Busch <kbusch@kernel.org>,
        Leon Romanovsky
	<leon@kernel.org>, Li Zhe <lizhe.67@bytedance.com>,
        Mahmoud Adam
	<mngyadam@amazon.de>,
        Philipp Stanner <pstanner@redhat.com>,
        Robin Murphy
	<robin.murphy@arm.com>,
        Vivek Kasireddy <vivek.kasireddy@intel.com>,
        "Will
 Deacon" <will@kernel.org>, Yunxiang Li <Yunxiang.Li@amd.com>,
        <linux-kernel@vger.kernel.org>, <iommu@lists.linux.dev>,
        <kvm@vger.kernel.org>
Subject: [TECH TOPIC] vfio, iommufd: Enabling user space drivers to vend more granular access to client processes
Date: Thu, 18 Sep 2025 14:44:07 -0700
Message-ID: <20250918214425.2677057-1-amastro@fb.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE4MDE5NSBTYWx0ZWRfX6AAYxKQMwZLw
 aZViUqQxptfvd13AUHO0wDgCyvEEG4g3l09hqrAHyDxcQ+EU4slwZk5HPlBQ3+P9+Wm6uxqo3zs
 ipT/D/u8UDONUD/4MUiiJgarCqdu5Hbh/0yHvgo1BnrkJ68GK5hLHFzBOpf7PyTkVeYuEF0hMv7
 Iy5LjglKeQ2mFiHC9j3T7eRJG4ELOqNwGtCxyfVmTF8k+TTOAE+5XO4MgQmywQaI8CxLlXrpJ5p
 z+CyQUqpc+ensulQmQ3/Y70ur7i/1cpB6CQeZgY7TWeVkaImen/RYMaGaZL044/eZDUfFficXa/
 8j5vcthb3AamomjDsMT4ZS2X3iavkRjfFEpLcNyKSbuS1cONIEc1NvZGUcnh08=
X-Proofpoint-ORIG-GUID: xbXU6eezAkjiegZWUCOl0aCn3m571zgk
X-Proofpoint-GUID: xbXU6eezAkjiegZWUCOl0aCn3m571zgk
X-Authority-Analysis: v=2.4 cv=YZC95xRf c=1 sm=1 tr=0 ts=68cc7d5d cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=968KyxNXAAAA:8
 a=rDkzsZ3yvGrXTgFfqF4A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-18_03,2025-09-18_02,2025-03-28_01

Hello,

We've been running user space drivers (USD) in production built on top of VFIO,
and have come to value the operational and development benefits of being able to
deploy updates to device policy by simply shipping user space binaries.

In our architecture, a long-running USD process bootstraps and manages
background device operations related to supporting client process workloads.
Client processes communicate with the USD over Unix domain sockets to acquire
the device resources necessary to dispatch work to the device.

We anticipate a growing need to provide more granular access to device resources
beyond what the kernel currently affords to user space drivers similar to our
model.

The purpose of this email is to:
- Gauge the extent to which ongoing work in VFIO and IOMMUFD can meet those
  needs.
- Seek guidance from VFIO and IOMMUFD maintainers about whether there is a path
  to supporting the remaining pieces across the VFIO and IOMMUFD UAPIs.
- Describe our current approach and get feedback on whether there are existing
  solutions that we've missed.
- Figure out the most useful places we can help contribute.

Inter-process communication latency (between client processes and USD) is
prohibitively slow to support hot-path communication between the client and
device, which targets round-trip times on the order of microseconds. To address
this, we need to allow client processes and the device to access each other's
memory directly, bypassing IPC with the USD and kernel syscalls.
a) For host-initiated access into device memory, this means mmap-ing BAR
   sub-regions into the client process.
b) For device-initiated access into host memory, it means establishing IOMMU
   mappings to memory underlying the client process address space.

Such things are more straightforward for in-kernel device drivers to accomplish:
they are free to define customized semantics for their associated fds and
syscall handlers. Today, user space driver processes have fewer tools at their
disposal for controlling these types of access.

----------
BAR Access
----------

To achieve (a), the USD sends the VFIO device fd to the client over Unix domain
sockets using SCM_RIGHTS, along with descriptions of which device regions are
for what. While this allows the client to mmap BARs into its address space,
it comes at the cost of exposing more access to device BAR regions than is
necessary or appropriate. In our use case, we don't need to contend with
adversarial client processes, so the current situation is tenable, but not
ideal.

Ongoing efforts to add dma-buf exporting to VFIO [1] seem relevant here. Though
its current intent is around enabling peer-to-peer access, the fact that only
a subset of device regions are bound to this fd could be useful for controlling
access granularity to device regions.

Instead of vending the VFIO device fd to the client process, the USD could bind
the necessary BAR regions to a dma-buf fd and share that with the client. If
VFIO supported dma_buf_ops.mmap, the client could mmap those into its address
space.

Adding such capability would mean that there would be two paths for mmap-ing
device regions: VFIO device fd and dma-buf fd. I imagine this could be
contentious; people may not like that there are two ways to achieve the same
thing. It also seems complicated by the fact that there are ongoing discussions
about how to extend the VFIO device fd UAPI to support features like write
combining [2]. It would feel incomplete for such features to be available
through one mmap-ing modality but not the other. This would have implications
for how the “special regions” should be communicated across the UAPI.

The VFIO dma-buf UAPI currently being proposed [3] takes a region_index and an
array of (offset, length) intervals within the region to assign to the dma-buf.
From what I can tell, that seems coherent with the latest direction from [2],
which will enable the creation of new region indices with special properties,
which are aliases to the default BAR regions. The USD could theoretically create
a dma-buf backed by "the region index corresponding to write-combined BAR 4" to
share with the client.

Given some of the considerations above, would there be line of sight for adding
support for dma_buf_ops.mmap to VFIO?

-------------
IOMMU Mapping
-------------

To achieve (b), we have been using the (now legacy) VFIO container interface
to manage access to the IOMMU. We understand that new feature development has
moved to IOMMUFD, and intend to migrate to using it when it's ready (we have
some use cases that require P2P). We are not expecting to add features to VFIO
containers. I will describe what we are doing today first.

In order to enable a device to access memory in multiple processes, we also
share the VFIO container fd using SCM_RIGHTS between the USD and client
processes. In this scheme, we partition the I/O address space (IOAS) for a
given device's container to be used cooperatively amongst each process. The
only enforcement of the partitioning convention is that each process only
VFIO_IOMMU_{MAP,UNMAP}_DMA's to the IOVA ranges which have been assigned to it.

When the USD detects that the client process has exited, it is able to unmap any
leftover dirty mappings with VFIO_IOMMU_UNMAP_DMA. This became possible after
[4], which allowed one process to free the mappings created by another process.
That patch's intent was to enable QEMU live update use cases, but benefited our
use case as well.

Again, we don't have to contend with adversarial client processes, so this has
been OK, but not ideal for now.

We are interested in the following incremental capabilities:
- We want the USD to be able to create and vend fds which provide restricted
  mapping access to the device's IOAS to the client, while preserving
  the ability of the USD to revoke device access to client memory via
  VFIO_IOMMU_UNMAP_DMA (or IOMMUFD_CMD_IOAS_UNMAP for IOMMUFD). Alternatively,
  to forcefully invalidate the entire restricted IOMMU fd, including mappings.
- It would be nice if mappings created with the restricted IOMMU fd were
  automatically freed when the underlying kernel object was freed (if the client
  process were to exit ungracefully without explicitly performing unmap cleanup
  after itself).

Some of those things sound very similar to the direction of vIOMMU, but it is
difficult to tell if that could meet our needs exactly. The kinds of features
I think we want should be achievable purely in software without any dedicated
hardware support.

This is an area we are less familiar with, since we haven't been living on the
IOMMUFD UAPI or following its development as closely yet. Perhaps we have missed
something more obvious?

Overall, I'm curious to hear feedback on this. Allowing user space drivers
to vend more granular device access would certainly benefit our use case, and
perhaps others as well.

[1] https://lore.kernel.org/all/cover.1754311439.git.leon@kernel.org/
[2] https://lore.kernel.org/all/20250804104012.87915-1-mngyadam@amazon.de/
[3] https://lore.kernel.org/all/5e043d8b95627441db6156e7f15e6e1658e9d537.1754311439.git.leon@kernel.org/
[4] https://lore.kernel.org/all/20220627035109.73745-1-lizhe.67@bytedance.com/

Thanks,
Alex

