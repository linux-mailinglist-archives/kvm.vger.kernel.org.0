Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3E81376A5
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 20:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729056AbgAJTGP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 14:06:15 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:47948 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728963AbgAJTGJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jan 2020 14:06:09 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00AJ3QXD131594;
        Fri, 10 Jan 2020 19:04:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2019-08-05;
 bh=K02kkFXDrMIX6YodXiO0Fgzhx0GR3LcBWdgkuRCLUG8=;
 b=axed6TwDxqR6ISlz7EM/dQfIM2IUtrTmNxzk4d/KRqjxctWY1PPr88tyDi//qdcLo+n1
 ZZFC1rXW0fk0F9HnCO9x5/4nhqQoQitlLIbckoeTLgXJ6NQjAwJSeng+CZ6V8W71bw1b
 cWV2SEttEYj3OnQqN4s6MvrMccKf/LgaAW+ePzHvEL53b3/nUUBI5YcEEtjcBL5rNAkX
 bFmsABeWtULk0tdyJ12ZZyOKkP7AFKxBU+XVlFbmUrl/EzYNiOwNvT3PMaezXhZmOtY8
 fBWAk6x5Z9lWu8a6sDyyFZxf1FbYN2gMToA5k26/g6ivw05wIacxFnrOtjCh8AzYUPnF Og== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2xaj4um8fc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jan 2020 19:04:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00AJ3tmo183684;
        Fri, 10 Jan 2020 19:04:40 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2xedhyptmq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jan 2020 19:04:40 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00AJ4bCN006586;
        Fri, 10 Jan 2020 19:04:37 GMT
Received: from paddy.uk.oracle.com (/10.175.192.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 10 Jan 2020 11:04:36 -0800
From:   Joao Martins <joao.m.martins@oracle.com>
To:     linux-nvdimm@lists.01.org
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Liran Alon <liran.alon@oracle.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>,
        Barret Rhoden <brho@google.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH RFC 00/10] device-dax: Support devices without PFN metadata
Date:   Fri, 10 Jan 2020 19:03:03 +0000
Message-Id: <20200110190313.17144-1-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9496 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001100154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9496 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001100154
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey,

Presented herewith a small series which allows device-dax to work without
struct page to be used to back KVM guests memory. It's an RFC, and there's
still some items we're looking at (see TODO below); but wondering if folks
would be OK carving some time out of their busy schedules to provide feedback
direction-wise on this work.

In virtualized environments (specially those with no kernel-backed PV
interfaces, and just SR-IOV), memory is largelly assigned to guests: either
persistent with NVDIMMs or volatile for regular RAM. The kernel
(hypervisor) tracks it with 'struct page' (64b) for each 4K page. Overall
we're spending 16GB for each 1Tb of host memory tracked that the kernel won't
need  which could instead be used to create other guests. One of motivations of
this series is to then get that memory used for 'struct page', when it is meant
to solely be used by userspace. This is also useful for the case of memory
backing guests virtual NVDIMMs. The other neat side effect is that the
hypervisor has no virtual mapping of the guest and hence code gadgets (if
found) are limited in their effectiveness.

It is expected that a smaller (instead of total) amount of host memory is
defined for the kernel (with mem=X or memmap=X!Y). For KVM userspace VMM (e.g.
QEMU), the main thing that is needed is a device which open + mmap + close with
a certain alignment (4K, 2M, 1G). That made us look at device-dax which does
just that and so the work comprised here was improving what's there and the
interfaces it uses.

The series is divided as follows:

 * Patch 1 , 3: Preparatory work for patch 7 for adding support for
	       vmf_insert_{pmd,pud} with dax pfn flags PFN_DEV|PFN_SPECIAL
	
 * Patch 2 , 4: Preparatory work for patch 7 for adding support for
	       follow_pfn() to work with 2M/1G huge pages, which is
	       what KVM uses for VM_PFNMAP.

 * Patch 5 - 7: One bugfix and device-dax support for PFN_DEV|PFN_SPECIAL,
	       which encompasses mainly dealing with the lack of devmap,
	       and creating a VM_PFNMAP vma.

 * Patch 8: PMEM support for no PFN metadata only for device-dax namespaces.
	   At the very end of the cover letter (after scissors mark),
	   there's a patch for ndctl to be able to create namespaces
	   with '--mode devdax --map none'.

 * Patch 9: Let VFIO handle VM_PFNMAP without relying on vm_pgoff being
 	    a PFN.

 * Patch 10: The actual end consumer example for RAM case. The patch just adds a
	     label storage area which consequently allows namespaces to be
	     created. We picked PMEM legacy for starters.

Thoughts, coments appreciated.

	Joao

P.S. As an example to try this out:

 1) add 'memmap=48G!16G' to the kernel command line, on a host with 64G,
 and kernel has 16G.

 2) create a devdax namespace with 1G hugepages: 

 $ ndctl create-namespace --verbose --mode devdax --map none --size 32G --align 1G -r 0
 {
  "dev":"namespace0.0",
  "mode":"devdax",
  "map":"none",
  "size":"32.00 GiB (34.36 GB)",
  "uuid":"dfdd05cd-2611-46ac-8bcd-10b6194f32d4",
  "daxregion":{
    "id":0,
    "size":"32.00 GiB (34.36 GB)",
    "align":1073741824,
    "devices":[
      {
        "chardev":"dax0.0",
        "size":"32.00 GiB (34.36 GB)",
        "target_node":0,
        "mode":"devdax"
      }
    ]
  },
  "align":1073741824
 }

 3) Add this to your qemu params:
  -m 32G 
  -object memory-backend-file,id=mem,size=32G,mem-path=/dev/dax0.0,share=on,align=1G
  -numa node,memdev=mem

TODO:

 * Discontiguous regions/namespaces: The work above is limited to max
contiguous extent, coming from nvdimm dpa allocation heuristics -- which I take
is because of what specs allow for persistent namespaces. But for volatile RAM
case we would need handling of discontiguous extents (hence a region would represent
more than a resource) to be less bound to how guests are placed on the system.
I played around with multi-resource for device-dax, but I'm wondering about
UABI: 1) whether nvdimm DPA allocation heuristics should be relaxed for RAM
case (under certain nvdimm region bits); or if 2) device-dax would have it's
own separate UABI to be used by daxctl (which would be also useful for hmem
devices?).

 * MCE handling: For contiguous regions vm_pgoff could be set to the pfn in
device-dax, which would allow collect_procs() to find the processes solely based
on the PFN. But for discontiguous namespaces, not sure if this would work; perhaps
looking at the dax-region pfn range for each DAX vma.

 * NUMA: For now excluded setting the target_node; while these two patches
 are being worked on[1][2].

 [1] https://lore.kernel.org/lkml/157401276776.43284.12396353118982684546.stgit@dwillia2-desk3.amr.corp.intel.com/
 [2] https://lore.kernel.org/lkml/157401277293.43284.3805106435228534675.stgit@dwillia2-desk3.amr.corp.intel.com/


Joao Martins (9):
  mm: Add pmd support for _PAGE_SPECIAL
  mm: Handle pmd entries in follow_pfn()
  mm: Add pud support for _PAGE_SPECIAL
  mm: Handle pud entries in follow_pfn()
  device-dax: Do not enforce MADV_DONTFORK on mmap()
  device-dax: Introduce pfn_flags helper
  device-dax: Add support for PFN_SPECIAL flags
  dax/pmem: Add device-dax support for PFN_MODE_NONE
  nvdimm/e820: add multiple namespaces support

Nikita Leshenko (1):
  vfio/type1: Use follow_pfn for VM_FPNMAP VMAs

 arch/x86/include/asm/pgtable.h  |  34 ++++-
 drivers/dax/bus.c               |   3 +-
 drivers/dax/device.c            |  78 ++++++++----
 drivers/dax/pmem/core.c         |  36 +++++-
 drivers/nvdimm/e820.c           | 212 ++++++++++++++++++++++++++++----
 drivers/vfio/vfio_iommu_type1.c |   6 +-
 mm/gup.c                        |   6 +
 mm/huge_memory.c                |  15 ++-
 mm/memory.c                     |  67 ++++++++--
 9 files changed, 382 insertions(+), 75 deletions(-)

8>----------------
Subject: [PATCH] ndctl: add 'devdax' support for NDCTL_PFN_LOC_NONE

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 7fb00078646b..2568943eb207 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -206,6 +206,8 @@ static int set_defaults(enum device_action mode)
 			/* pass */;
 		else if (strcmp(param.map, "dev") == 0)
 			/* pass */;
+		else if (strcmp(param.map, "none") == 0)
+			/* pass */;
 		else {
 			error("invalid map location '%s'\n", param.map);
 			rc = -EINVAL;
@@ -755,9 +757,17 @@ static int validate_namespace_options(struct ndctl_region *region,
 	if (param.map) {
 		if (!strcmp(param.map, "mem"))
 			p->loc = NDCTL_PFN_LOC_RAM;
+		else if (!strcmp(param.map, "none"))
+			p->loc = NDCTL_PFN_LOC_NONE;
 		else
 			p->loc = NDCTL_PFN_LOC_PMEM;
 
+		if (p->loc == NDCTL_PFN_LOC_NONE
+			&& p->mode != NDCTL_NS_MODE_DAX) {
+			debug("--map=none only valid for devdax mode namespace\n");
+			return -EINVAL;
+		}
+
 		if (ndns && p->mode != NDCTL_NS_MODE_MEMORY
 			&& p->mode != NDCTL_NS_MODE_DAX) {
 			debug("%s: --map= only valid for fsdax mode namespace\n",


-- 
2.17.1

