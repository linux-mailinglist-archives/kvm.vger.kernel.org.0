Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB0B7089C6
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 22:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbjERUry (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 16:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjERUrx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 16:47:53 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D606A110
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 13:47:50 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34IIxBqa015561;
        Thu, 18 May 2023 20:47:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2023-03-30; bh=+OzCozfnt3X+giJp7IXjzhO6CPbrWXdZLu4jElR1scg=;
 b=gMzdnlecBiwR+Va+HIek0IzNp4ixGBeFrJEC8ZG7QOfSsqDto/AjuiSajbncerYW6MB9
 hAoYzF+CaqFDJBCqSz3Ov/Y4ovz3332+oWlyPHtho4eeGF0Z0A8KGxEgMavEl4PXFqfT
 lPYlMawjuE5jd3rVaVHRm/Wvo5JHgd9oDuWPI/vJG+Jmy2s6z905LbUTnSIM5hngL1LD
 RrdyXMjSed11JEMx9SDS0pXdlddfEpjuVUm0VsGM6hZcoyNyF8K56X308ktOxReQheym
 RWyadrC9BDN6xATBUtwK1tmzIjk26FinImra2cU1vTpqjY2uTxFxOaur3OA35As/o/jg CA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qmx8j3n30-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 May 2023 20:47:16 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34IJkARk032121;
        Thu, 18 May 2023 20:47:15 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qj10dae5k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 May 2023 20:47:14 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34IKlE2l033533;
        Thu, 18 May 2023 20:47:14 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-172-172.vpn.oracle.com [10.175.172.172])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3qj10dae46-1;
        Thu, 18 May 2023 20:47:14 +0000
From:   Joao Martins <joao.m.martins@oracle.com>
To:     iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH RFCv2 00/24] IOMMUFD Dirty Tracking
Date:   Thu, 18 May 2023 21:46:26 +0100
Message-Id: <20230518204650.14541-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-18_15,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305180170
X-Proofpoint-GUID: L4LgFWhDunFENE7bzyymnmszbhPLIs9X
X-Proofpoint-ORIG-GUID: L4LgFWhDunFENE7bzyymnmszbhPLIs9X
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Presented herewith is a series that extends IOMMUFD to have IOMMU
hardware support for dirty bit in the IOPTEs.

Today, AMD Milan (or more recent) supports it while ARM SMMUv3.2
alongside VT-D rev3.x are expected to eventually come along.  One
intended use-case (but not restricted!) is to support Live Migration with
SR-IOV, specially useful for live migrateable PCI devices that can't
supply its own dirty tracking hardware blocks amongst others.

At a quick glance, IOMMUFD lets the userspace create the IOAS with a
set of a IOVA ranges mapped to some physical memory composing an IO
pagetable. This is then created via HWPT_ALLOC or attached to a
particular device/hwpt, consequently creating the IOMMU domain and share
a common IO page table representing the endporint DMA-addressable guest
address space. In IOMMUFD Dirty tracking (from v1 of the series) we will
be supporting the HWPT_ALLOC model only, as opposed to simpler
autodomains model.

The result is an hw_pagetable which represents the
iommu_domain which will be directly manipulated. The IOMMUFD UAPI,
and the iommu core kAPI are then extended to provide:

1) Enforce that only devices with dirty tracking support are attached
to an IOMMU domain, to cover the case where this isn't all homogenous in
the platform. The enforcing being enabled or not is tracked by the iommu
domain op *caller* not iommu driver implementaiton, to avoid redundantly
check this in IOMMU ops.

2) Toggling of Dirty Tracking on the iommu_domain. We model as the most
common case of changing hardware translation control structures dynamically
(x86) while making it easier to have an always-enabled mode. In the
RFCv1, the ARM specific case is suggested to be always enabled instead of
having to enable the per-PTE DBM control bit (what I previously called
"range tracking"). Here, setting/clearing tracking means just clearing the
dirty bits at start. IOMMUFD wise The 'real' tracking of whether dirty
tracking is enabled is stored in the IOMMU driver, hence no new
fields are added to iommufd pagetable structures, except for the
iommu_domain enforcement part.

Note: I haven't included a GET_DIRTY ioctl but I do have it implemented.
But I am not sure this is exactly needed. I find it good to have a getter
supplied with setter in general, but looking at how other parts were
developed in the past, the getter doesn't have a usage...

3) Add a capability probing for dirty tracking, leveraging the per-device
iommu_capable() and adding a IOMMU_CAP_DIRTY. IOMMUFD we add a
DEVICE_GET_CAPS ioctl which takes a device ID and returns some
capabilities. Similarly to 1) it might make sense to move it the drivers
.attach_device validation to the caller; for now I have this in iommu
drivers;

4) Read the I/O PTEs and marshal its dirtyiness into a bitmap. The bitmap
indexes on a page_size basis the IOVAs that got written by the device.
While performing the marshalling also drivers need to clear the dirty bits
from IOPTE and allow the kAPI caller to batch the much needed IOTLB flush.
There's no copy of bitmaps to userspace backed memory, all is zerocopy
based to not add more cost to the iommu driver IOPT walker. This shares
functionality with VFIO device dirty tracking via the IOVA bitmap APIs. So
far this is a test-and-clear kind of interface given that the IOPT walk is
going to be expensive. In addition this also adds the ability to read dirty
bit info without clearing the PTE info. This is meant to cover the
unmap-and-read-dirty use-case, and avoid the second IOTLB flush.

Note: I've kept the name read_and_clear_dirty() in v2 but this might not
make sense given the name of the flags; open to suggestions.

5) I've pulled Baolu Lu's patches[0] that make the pagetables page free
path RCU-protected, which will fix both the use-after-free scenario
mentioned there, but also let us a RCU-based page table walker for
read_and_clear_dirty() iommu op, as opposed to taking the same locks on
map/unmap. These are taken exactly as they were posted.

The additional dependency are:
* HWPT_ALLOC which allows creating/manipulating iommu_domain creation[4]

While needing this to make it useful with VFIO (and consequently to VMMs):
* VFIO cdev support and to use iommufd with VFIO [3]
* VFIO PCI hot reset

Hence, I have these two dependencies applied first on top of this series.
This whole thing as posted is also here[6].

The series is organized as follows:

* Patches 1-4: Takes care of the iommu domain operations to be added.
The idea is to abstract iommu drivers from any idea of how bitmaps are
stored or propagated back to the caller, as well as allowing
control/batching over IOTLB flush. So there's a data structure and an
helper that only tells the upper layer that an IOVA range got dirty.
This logic is shared with VFIO and it's meant to walking the bitmap
user memory, and kmap-ing plus setting bits as needed. IOMMU driver
just has an idea of a 'dirty bitmap state' and recording an IOVA as
dirty. It also pulls Baolu Lu's patches for RCU-safe pagetable free.

* Patches 5-16: Adds the UAPIs for IOMMUFD, and selftests. The selftests
cover some corner cases on boundaries handling of the bitmap and various
bitmap sizes that exercise. I haven't included huge IOVA ranges to avoid
risking the selftests failing to execute due to OOM issues of mmaping bit
buffers.

I've implemented for the x86 IOMMUs that have/eventually-have IOMMU A/D
support. So the next half of the series presents said implementations
for IOMMUs:

* Patches 17-18: AMD IOMMU implementation, particularly on those having
HDSup support. Tested with a Qemu amd-iommu with HDSUp emulated[1].

* Patches 19: Intel IOMMU rev3.x+ implementation. Tested with a Qemu
based intel-iommu vIOMMU with SSADS emulation support[1].

* Patches 20-24: ARM SMMU v3 impleemntation. A lot simpler than the v1
posting. Most of the adjustments were because of the new UAPI while taking
the comments I got in v1 from everyone. *Only compile tested*. Shameerali
will be taking over the ARM SMMUv3 support;

To help testing/prototypization, I also wrote qemu iommu emulation bits
to increase coverage of this code and hopefully make this more broadly
available for fellow contributors/devs[1]; it is stored here[2] and
largelly based on Nicolin, Yi and Eric's IOMMUFD bringup work (thanks a
ton!). It also includes IOMMUFD dirty tracking supporting Qemu that got
posted in the past. I won't be exactly following up a v2 there given that
IOMMUFD support needs to be firstly supported by Qemu.

We have live migrateable VFs in VMMs these days (e.g. Qemu 8.0) so we can
now test everything in tandem, but I haven't have my hardware setup *yet*
organized in such manner that allows me to test everything, hence why I am
still marking this as an RFC with intent to drop in v3. But most
importantly, this version is for making sure that iommu/iommufd kAPIs/UAPI
are solid; I'll focus more on iommu implementations next iteration;

Sorry for such a late posting since v1; hopefully this are in a better
direction.

Feedback or any comments are very much appreciated

Thanks!
        Joao

TODOs for v3:
- Testing with a live migrateable VF;
- Improve the dirty PTE walking in Intel/AMD iommu drivers, and anything
that I may have miss

Changes since RFCv1[5]:
Too many changes but the major items were:
* Majorirty of the changes from Jason/Kevin/Baolu/Suravee:
- Improve structure and rework most commit messages
- Drop all of the VFIO-compat series
- Drop the unmap-get-dirty API
- Tie this to HWPT only, no more autodomains handling;
- Rework the UAPI widely by:
  - Having a IOMMU_DEVICE_GET_CAPS which allows to fetching capabilities
    of devices, specifically test dirty tracking support for an individual
    device
  - Add a enforce-dirty flag to the IOMMU domain via HWPT_ALLOC
  - SET_DIRTY now clears dirty tracking before asking iommu driver to do so;
  - New GET_DIRTY_IOVA flag that does not clear dirty bits
  - Add coverage for all added APIs
  - Expand GET_DIRTY_IOVA tests to cover IOVA bitmap corner cases tests
  that I had in separate; I only excluded the Terabyte IOVA range
  usecases (which test bitmaps 2M+) because those will most likely fail
  to be run as selftests (not sure yet how I can include those). I am
  not exactly sure how I can cover those, unless I do 'fake IOVA maps'
  *somehow* which do not necessarily require real buffers.
- Handle most comments in intel-iommu. Only remaining one for v3 is the
  PTE walker which will be done better.
- Handle all comments in amd-iommu, most of which regarding locking.
  Only one remaining is v3 same as Intel;
- Reflect the UAPI changes into iommu driver implementations, including
persisting dirty tracking enabling in new attach_dev calls, as well as
enforcing attach_dev enforces the requested domain flags; As well as
future devices setting Dirty activated if they get attached to a iommu
domain with dirty tracking enabled.
* Comments from Yi Sun in making sure that dirty tracking isn't
restricted into SS only, so relax the check for FL support because it's
always enabled. (Yi Sun)
* Most of code that was in v1 for dirty bitmaps got rewritten and
repurpose to also cover VFIO case; so reuse this infra here too for both.
(Jason)
* Take Robin's suggestion of always enabling dirty tracking and set_dirty
just clearing bits on 'activation', and make that a generic property to
ensure we always get accurate results between starting and stopping
tracking. (Robin Murphy)
* Address all comments from SMMUv3 into how we enable/test the DBM, or the
bits in the context descriptor with io-pgtable::quirks, etc
(Robin, Shameerali)

[0] https://lore.kernel.org/linux-iommu/20220609070811.902868-1-baolu.lu@linux.intel.com/
[1] https://lore.kernel.org/qemu-devel/20220428211351.3897-1-joao.m.martins@oracle.com/
[2] https://github.com/jpemartins/qemu/commits/iommufd-v2
[3] https://lore.kernel.org/kvm/20230426150321.454465-1-yi.l.liu@intel.com/
[4] https://lore.kernel.org/kvm/0-v7-6c0fd698eda2+5e3-iommufd_alloc_jgg@nvidia.com/
[5] https://lore.kernel.org/kvm/20220428210933.3583-1-joao.m.martins@oracle.com/
[6] https://github.com/jpemartins/linux/commits/iommufd-v2


Jean-Philippe Brucker (1):
  iommu/arm-smmu-v3: Add feature detection for HTTU

Joao Martins (19):
  vfio: Move iova_bitmap into iommu core
  iommu: Add iommu_domain ops for dirty tracking
  iommufd: Add a flag to enforce dirty tracking on attach
  iommufd/selftest: Add a flags to _test_cmd_{hwpt_alloc,mock_domain}
  iommufd/selftest: Test IOMMU_HWPT_ALLOC_ENFORCE_DIRTY
  iommufd: Dirty tracking data support
  iommufd: Add IOMMU_HWPT_SET_DIRTY
  iommufd/selftest: Test IOMMU_HWPT_SET_DIRTY
  iommufd: Add IOMMU_HWPT_GET_DIRTY_IOVA
  iommufd/selftest: Test IOMMU_HWPT_GET_DIRTY_IOVA
  iommufd: Add IOMMU_DEVICE_GET_CAPS
  iommufd/selftest: Test IOMMU_DEVICE_GET_CAPS
  iommufd: Add a flag to skip clearing of IOPTE dirty
  iommufd/selftest: Test IOMMU_GET_DIRTY_IOVA_NO_CLEAR flag
  iommu/amd: Access/Dirty bit support in IOPTEs
  iommu/amd: Print access/dirty bits if supported
  iommu/intel: Access/Dirty bit support for SL domains
  iommu/arm-smmu-v3: Add set_dirty_tracking() support
  iommu/arm-smmu-v3: Advertise IOMMU_DOMAIN_F_ENFORCE_DIRTY

Keqian Zhu (1):
  iommu/arm-smmu-v3: Add read_and_clear_dirty() support

Kunkun Jiang (1):
  iommu/arm-smmu-v3: Enable HTTU for stage1 with io-pgtable mapping

Lu Baolu (2):
  iommu: Add RCU-protected page free support
  iommu: Replace put_pages_list() with iommu_free_pgtbl_pages()

 drivers/iommu/Makefile                        |   1 +
 drivers/iommu/amd/amd_iommu.h                 |   1 +
 drivers/iommu/amd/amd_iommu_types.h           |  12 +
 drivers/iommu/amd/init.c                      |   9 +
 drivers/iommu/amd/io_pgtable.c                |  89 +++++++-
 drivers/iommu/amd/iommu.c                     |  81 +++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  95 ++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   8 +
 drivers/iommu/dma-iommu.c                     |   6 +-
 drivers/iommu/intel/iommu.c                   |  92 +++++++-
 drivers/iommu/intel/iommu.h                   |  15 ++
 drivers/iommu/intel/pasid.c                   | 103 +++++++++
 drivers/iommu/intel/pasid.h                   |   4 +
 drivers/iommu/io-pgtable-arm.c                | 115 +++++++++-
 drivers/iommu/iommu.c                         |  34 +++
 drivers/iommu/iommufd/device.c                |  28 ++-
 drivers/iommu/iommufd/hw_pagetable.c          | 112 +++++++++-
 drivers/iommu/iommufd/io_pagetable.c          | 111 ++++++++++
 drivers/iommu/iommufd/iommufd_private.h       |  27 ++-
 drivers/iommu/iommufd/iommufd_test.h          |  14 ++
 drivers/iommu/iommufd/main.c                  |   9 +
 drivers/iommu/iommufd/selftest.c              | 147 ++++++++++++-
 drivers/{vfio => iommu}/iova_bitmap.c         |   0
 drivers/vfio/Makefile                         |   3 +-
 include/linux/io-pgtable.h                    |   8 +
 include/linux/iommu.h                         |  77 +++++++
 include/uapi/linux/iommufd.h                  | 107 +++++++++
 tools/testing/selftests/iommu/Makefile        |   3 +
 tools/testing/selftests/iommu/iommufd.c       | 206 +++++++++++++++++-
 .../selftests/iommu/iommufd_fail_nth.c        |  24 +-
 tools/testing/selftests/iommu/iommufd_utils.h | 181 ++++++++++++++-
 31 files changed, 1680 insertions(+), 42 deletions(-)
 rename drivers/{vfio => iommu}/iova_bitmap.c (100%)

-- 
2.17.2

