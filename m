Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3B9C7ABCFE
	for <lists+kvm@lfdr.de>; Sat, 23 Sep 2023 03:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbjIWB2R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 21:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbjIWB2N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 21:28:13 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78DC619C
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 18:28:05 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38MNRxLJ026456;
        Sat, 23 Sep 2023 01:27:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2023-03-30; bh=90+HmLkMWtEPXn2ZVx7mpuG6nietvDWHWjcjD74ciR0=;
 b=eu2bi+nSECWvdMLCeJb3suDUx7VzeREEAmsPx5nZmaQD5au087OHQ8VKKOXbMY7J4Eno
 zHYz6fSeRfcLWwQYD5PAMv1B/LBrkoI61JjLpSS47rGOIzVAQo6O2hdse2z0l+iPEF5e
 pK66nkVxwF6Fm6FZ1G6sWV8cWpdIMPztKBgKcVWM2Rah2oILhp44yhqPWTjSzU9xrOGp
 sFlIWIw8xI54k5nFpx0C6d9JIiXvfNlXiQ1tRXOalAcKKSiR8VDgv2AdruPALbEuziXK
 qmE+BVchl3nNPVIA42UbbDA1ZjVkKmzN/hpAixshfsl551Xn2URyEUPf14RaquWypETh sA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t8tsv32u1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Sep 2023 01:27:05 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38N0U5s2007642;
        Sat, 23 Sep 2023 01:27:04 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t8uhdhq8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Sep 2023 01:27:04 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38N1R3gs040930;
        Sat, 23 Sep 2023 01:27:04 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-187-199.vpn.oracle.com [10.175.187.199])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3t8uhdhq78-1;
        Sat, 23 Sep 2023 01:27:03 +0000
From:   Joao Martins <joao.m.martins@oracle.com>
To:     iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH v3 00/19] IOMMUFD Dirty Tracking
Date:   Sat, 23 Sep 2023 02:24:52 +0100
Message-Id: <20230923012511.10379-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-22_21,2023-09-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309230011
X-Proofpoint-ORIG-GUID: eD6It8QIP2Z7BxDNZYi5-PuWcxcHQBeF
X-Proofpoint-GUID: eD6It8QIP2Z7BxDNZYi5-PuWcxcHQBeF
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Presented herewith is a series that extends IOMMUFD to have IOMMU
hardware support for dirty bit in the IOPTEs.

Today, AMD Milan (or more recent) supports it while ARM SMMUv3.2
alongside VT-D rev3.x also do support.  One intended use-case (but not
restricted!) is to support Live Migration with SR-IOV, specially useful
for live migrateable PCI devices that can't supply its own dirty
tracking hardware blocks amongst others.

At a quick glance, IOMMUFD lets the userspace create the IOAS with a
set of a IOVA ranges mapped to some physical memory composing an IO
pagetable. This is then created via HWPT_ALLOC or attached to a
particular device/hwpt, consequently creating the IOMMU domain and share
a common IO page table representing the endporint DMA-addressable guest
address space. In IOMMUFD Dirty tracking (since v2 of the series) it
will require via the HWPT_ALLOC model only, as opposed to simpler
autodomains model.

The result is an hw_pagetable which represents the
iommu_domain which will be directly manipulated. The IOMMUFD UAPI,
and the iommu/iommufd kAPI are then extended to provide:

1) Enforcement that only devices with dirty tracking support are attached
to an IOMMU domain, to cover the case where this isn't all homogenous in
the platform. While initially this is more aimed at possible heterogenous nature
of ARM while x86 gets future proofed, should any such ocasion occur.

[ Special Note: In this version I did it differently with the domain dirty
ops.  Given that dirty tracking ops are now supposed to be set or not
dynamically at domain allocation it means I can't rely on
default_domain_ops to be set. So I added a new set of ops just for
dirty tracking and is NULL by default. It looked simpler to me, and I
was concerned that dirty tracking would be the only one having 'dynamic'
ops, so chose the one with less churn. The alternatives are a) to either
replicate iommu_domain_ops with/without dirty tracking and have that set
in domain_alloc_user() but it sounded wrong to just replicate the same
.map and .unmap and other stuff that was unrelated or b) always allocate one
in the driver that gets copied from the default_domain_ops value each
driver passes change it accordingly. c) have a structure for dynamic ops
(this series). Open to alternatives or knowing the preference of folks. ]

The device dirty tracking enforcement on attach_dev is made whether the
dirty_ops are set or not. Given that attach always checks for dirty
ops and IOMMU_CAP_DIRTY, while writing this it almost wanted this to
move to upper layer but semantically iommu driver should do the
checking.

2) Toggling of Dirty Tracking on the iommu_domain. We model as the most
common case of changing hardware translation control structures dynamically
(x86) while making it easier to have an always-enabled mode. In the
RFCv1, the ARM specific case is suggested to be always enabled instead of
having to enable the per-PTE DBM control bit (what I previously called
"range tracking"). Here, setting/clearing tracking means just clearing the
dirty bits at start. The 'real' tracking of whether dirty
tracking is enabled is stored in the IOMMU driver, hence no new
fields are added to iommufd pagetable structures, except for the
iommu_domain dirty ops part via adding a dirty_ops field to
iommu_domain. We use that too for IOMMUFD to know if dirty tracking
is supported and toggleable without having iommu drivers replicate said
checks.

3) Add a capability probing for dirty tracking, leveraging the
per-device iommu_capable() and adding a IOMMU_CAP_DIRTY. It extends
the GET_HW_INFO ioctl which takes a device ID to return some generic
capabilities *in addition*. Possible values enumarated by `enum
iommufd_hw_capabilities`.

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

Note: I've kept the name read_and_clear_dirty() as RFCv2 but this might not
make sense given the name of the flags; open to suggestions.

The only dependency is:
* Have domain_alloc_user() API with flags [2] which is also used
in the nesting work.

The series is organized as follows:

* Patches 1-4: Takes care of the iommu domain operations to be added.
The idea is to abstract iommu drivers from any idea of how bitmaps are
stored or propagated back to the caller, as well as allowing
control/batching over IOTLB flush. So there's a data structure and an
helper that only tells the upper layer that an IOVA range got dirty.
This logic is shared with VFIO and it's meant to walking the bitmap
user memory, and kmap-ing plus setting bits as needed. IOMMU driver
just has an idea of a 'dirty bitmap state' and recording an IOVA as
dirty.

* Patches 5-15: Adds the UAPIs for IOMMUFD, and selftests. The selftests
cover some corner cases on boundaries handling of the bitmap and various
bitmap sizes that exercise. I haven't included huge IOVA ranges to avoid
risking the selftests failing to execute due to OOM issues of mmaping big
buffers.

So the next half of the series presents x86 implementations for IOMMUs:

* Patches 16-18: AMD IOMMU implementation, particularly on those having
HDSup support. Tested with a Qemu amd-iommu with HDSUp emulated[0]. And
tested with live migration with VFs (but with IOMMU dirty tracking).

* Patches 19: Intel IOMMU rev3.x+ implementation. Tested with a Qemu
based intel-iommu vIOMMU with SSADS emulation support[0].

For ARM-SMMU-v3 I've made adjustments from the RFCv2 but staged this
into a branch[6] with all the changes but didn't include here as I can't
test this besides compilation. Shameer, if you can pick up as chatted
sometime ago it would be great as you have the hardware. Note that
it depends on some patches from Nicolin for hw_info() and
domain_alloc_user() base support coming from his nesting work.

On AMD I have tested this with emulation and then live migration; and
while I haven't tested on supported VTd hardware, so far emulation has
been proving a reliable indication that it is functional, thus I kept it
on v3 the VTD bits.

The qemu iommu emulation bits are to increase coverage of this code and
hopefully make this more broadly available for fellow
contributors/devs, old version[1]; it uses Yi's 2 commits to have
hw_info() supported (still needs a bit of cleanup) on top of Zhenzhong
latest IOMMUFD QEMU bringup work: see here[0]. It includes IOMMUFD dirty
tracking for Live migration and with live migration tested. I won't be
exactly following up a v2 of QEMU patches given that IOMMUFD support
needs to be firstly supported by Qemu.

Should be in a better direction of switching everything to be
domain_alloc_user() based. The only possible remaining wrinkle might be
the dynamic IOMMU dirty ops, if this proposal doesn't satisfy.

This series is also hosted here[3] and sits on top of the branch behind[2].

Feedback or any comments are very much appreciated.

Thanks!
        Joao

[0] https://github.com/jpemartins/qemu/commits/iommufd-v3
[1] https://lore.kernel.org/qemu-devel/20220428211351.3897-1-joao.m.martins@oracle.com/
[2] https://lore.kernel.org/linux-iommu/20230919092523.39286-1-yi.l.liu@intel.com/
[3] https://github.com/jpemartins/linux/commits/iommufd-v3
[4] https://lore.kernel.org/linux-iommu/20230518204650.14541-1-joao.m.martins@oracle.com/
[5] https://lore.kernel.org/kvm/20220428210933.3583-1-joao.m.martins@oracle.com/
[6] https://github.com/jpemartins/linux/commits/smmu-iommufd-v3

Changes since RFCv2[4]:
* Testing has always occured on the new code, but now it has seen
Live Migration coverage with extra QEMU work on AMD hardware.
* General commit message improvements
* Remove spurious headers in selftests
* Exported some symbols to actually allow things to build when IOMMUFD
is built as a module. (Alex Williamson)
* Switch the enforcing to be done on IOMMU domain allocation via
domain_alloc_user (Jason, Robin, Lu Baolu)
* Removed RCU series from Lu Baolu (Jason)
* Switch set_dirty/read_dirty/clear_dirty to down_read() (Jason)
* Make sure it check for area::pages (Jason)
* Move clearing dirties before set dirty a helper (Jason)
* Avoid breaking IOMMUFD selftests UAPI (Jason)
* General improvements to testing
* Add coverage to new out_capabilities support in HW_INFO.
* Address Shameer/Robin comments in smmu-v3 (code is on a branch[6])
  - Properly check for FEAT_HD together with COHERENCY
  - Remove the pgsize_bitmap check
  - Limit the quirk set to s1 pgtbl_cfg.
  - Fix commit message on dubious sentence on DBM usecase

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
enforcing attach_dev enforces the requested domain flags;
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

Joao Martins (19):
  vfio/iova_bitmap: Export more API symbols
  vfio: Move iova_bitmap into iommu core
  iommu: Add iommu_domain ops for dirty tracking
  iommufd: Add a flag to enforce dirty tracking on attach
  iommufd/selftest: Expand mock_domain with dev_flags
  iommufd/selftest: Test IOMMU_HWPT_ALLOC_ENFORCE_DIRTY
  iommufd: Dirty tracking data support
  iommufd: Add IOMMU_HWPT_SET_DIRTY
  iommufd/selftest: Test IOMMU_HWPT_SET_DIRTY
  iommufd: Add IOMMU_HWPT_GET_DIRTY_IOVA
  iommufd/selftest: Test IOMMU_HWPT_GET_DIRTY_IOVA
  iommufd: Add capabilities to IOMMU_GET_HW_INFO
  iommufd/selftest: Test out_capabilities in IOMMU_GET_HW_INFO
  iommufd: Add a flag to skip clearing of IOPTE dirty
  iommufd/selftest: Test IOMMU_GET_DIRTY_IOVA_NO_CLEAR flag
  iommu/amd: Add domain_alloc_user based domain allocation
  iommu/amd: Access/Dirty bit support in IOPTEs
  iommu/amd: Print access/dirty bits if supported
  iommu/intel: Access/Dirty bit support for SL domains

 drivers/iommu/Makefile                        |   1 +
 drivers/iommu/amd/amd_iommu_types.h           |  12 +
 drivers/iommu/amd/init.c                      |   4 +
 drivers/iommu/amd/io_pgtable.c                |  84 +++++++
 drivers/iommu/amd/iommu.c                     | 144 +++++++++++-
 drivers/iommu/intel/iommu.c                   |  94 ++++++++
 drivers/iommu/intel/iommu.h                   |  15 ++
 drivers/iommu/intel/pasid.c                   |  94 ++++++++
 drivers/iommu/intel/pasid.h                   |   4 +
 drivers/iommu/iommufd/device.c                |   4 +
 drivers/iommu/iommufd/hw_pagetable.c          |  85 ++++++-
 drivers/iommu/iommufd/io_pagetable.c          | 131 +++++++++++
 drivers/iommu/iommufd/iommufd_private.h       |  22 ++
 drivers/iommu/iommufd/iommufd_test.h          |  21 ++
 drivers/iommu/iommufd/main.c                  |   6 +
 drivers/iommu/iommufd/selftest.c              | 168 +++++++++++++-
 drivers/{vfio => iommu}/iova_bitmap.c         |   3 +
 drivers/vfio/Makefile                         |   3 +-
 include/linux/io-pgtable.h                    |   4 +
 include/linux/iommu.h                         |  56 +++++
 include/uapi/linux/iommufd.h                  |  89 ++++++++
 tools/testing/selftests/iommu/iommufd.c       | 216 ++++++++++++++++++
 .../selftests/iommu/iommufd_fail_nth.c        |   2 +-
 tools/testing/selftests/iommu/iommufd_utils.h | 187 ++++++++++++++-
 24 files changed, 1432 insertions(+), 17 deletions(-)
 rename drivers/{vfio => iommu}/iova_bitmap.c (99%)

-- 
2.17.2

