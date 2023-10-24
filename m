Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D75217D5343
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 15:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343569AbjJXNzL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 09:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234895AbjJXNzB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 09:55:01 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4CB5FDB
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 06:51:53 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39OCKP44004498;
        Tue, 24 Oct 2023 13:51:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2023-03-30; bh=UNWnPxmt6uzxK9kc+uZSvDFvyQXeON9svWO2PpRgLTU=;
 b=HEKqFfhdOOxIpXHOLmfB6O+WH6DtEX9vhiPkqtEwRDuEGMNUMZryeqRQ9G16nGRyOi3o
 nTnXSiHAAY6rvLGDcAW2GsnlzAn0r45gv5WdcP29bDB1U+wynqPLznZS+KCsoHcFAOom
 132LJrSIqU8g5KYu5vY0S+zFKUNu2tYJeGj8QAu/5UN4U/BjOcWIRV2MxYrsnPYh7Tjr
 K8o1UqQ+h2S+fgVc7y7X4PVa2R7JYFbXExyjwevfEyRGCtCqvW2BIWZKxq92LvZ7GOrm
 6lXxZtJ8vEC6OYWolzftpKz9mrNhADVrgA725+c6y4aNWgehRQmQ92AVtM03WgMvbqKE bQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tv76u5fvt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Oct 2023 13:51:22 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39OC2oSi034526;
        Tue, 24 Oct 2023 13:51:22 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tv53591u7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Oct 2023 13:51:22 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39ODpL8o030007;
        Tue, 24 Oct 2023 13:51:21 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-194-36.vpn.oracle.com [10.175.194.36])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3tv53591rr-1;
        Tue, 24 Oct 2023 13:51:21 +0000
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
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH v6 00/18] IOMMUFD Dirty Tracking
Date:   Tue, 24 Oct 2023 14:50:51 +0100
Message-Id: <20231024135109.73787-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-24_14,2023-10-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310240118
X-Proofpoint-GUID: ab7Pkgrm9Acx2yGYxKel8uF_K4P_0wAT
X-Proofpoint-ORIG-GUID: ab7Pkgrm9Acx2yGYxKel8uF_K4P_0wAT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v6 is a replacement of what's in iommufd next:
https://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git/log/?h=for-next

base-commit: b5f9e63278d6f32789478acf1ed41d21d92b36cf

(from the iommufd tree)

=========>8=========

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

The only dependency is:
* Have domain_alloc_user() API with flags [2] already queued (iommufd/for-next).

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

* Patches 5-9, 13-18: Adds the UAPIs for IOMMUFD, and selftests. The
selftests cover some corner cases on boundaries handling of the bitmap
and various bitmap sizes that exercise. I haven't included huge IOVA
ranges to avoid risking the selftests failing to execute due to OOM
issues of mmaping big buffers.

* Patches 10-11: AMD IOMMU implementation, particularly on those having
HDSup support. Tested with a Qemu amd-iommu with HDSUp emulated[0]. And
tested with live migration with VFs (but with IOMMU dirty tracking).

* Patches 12: Intel IOMMU rev3.x+ implementation. Tested with a Qemu
based intel-iommu vIOMMU with SSADS emulation support[0].

On AMD/Intel I have tested this with emulation and then live migration in
AMD hardware;

The qemu iommu emulation bits are to increase coverage of this code and
hopefully make this more broadly available for fellow contributors/devs,
old version[1]; it uses Yi's 2 commits to have hw_info() supported (still
needs a bit of cleanup) on top of a recent Zhenzhong series of IOMMUFD
QEMU bringup work: see here[0]. It includes IOMMUFD dirty tracking for
Live migration and with live migration tested. I won't be exactly
following up a v2 of QEMU patches until IOMMUFD tracking lands.

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
[7] https://lore.kernel.org/linux-iommu/20230923012511.10379-1-joao.m.martins@oracle.com/
[8] https://lore.kernel.org/linux-iommu/20231018202715.69734-1-joao.m.martins@oracle.com/
[9] https://lore.kernel.org/linux-iommu/20231020222804.21850-1-joao.m.martins@oracle.com/

Changes since v5[9]:
* Fixes various linux-next/krobot build warnings and failures namely:
- Move IOMMUFD_DRIVER kconfig definition changes into drivers/iommu/Kconfig
  to address a arm32 issue (with !IOMMU_SUPPORT) module dependency warning
  https://lore.kernel.org/kvm/20231023115520.3530120-1-arnd@kernel.org/
- Implement the !IOMMU_API prototypes for patch 4, fixing a sparc64
  randconfig build warning when !IOMMU_API is done while having ARM32 IO_PGTABLE
  builtin
  https://lore.kernel.org/linux-mm/202310232131.TOhkKzZa-lkp@intel.com/
- Fix htmldocs warnings in the individual patches:
  https://lore.kernel.org/linux-next/20231023164721.1cb43dd6@canb.auug.org.au/
- Fix lack of div_u64 build error in 32-bit builds (i386, arm32, xtensa,
  microblaze) by reworking all checks in iommufd_check_iova_ranges() and moving
  it into iopt_read_and_clear_data(). The checks being redone no longer
  implement a u64 division, while improving the range checks all together.
  My 32-bit kernel compilation failures are at least fixed after this
  and I haven't spotted any warnings from this series.
  https://lore.kernel.org/linux-iommu/b7834d1e-d198-45ee-b15d-12bd235bc57f@app.fastmail.com/
  https://lore.kernel.org/oe-kbuild-all/202310231933.c8k54ybn-lkp@intel.com/
  https://lore.kernel.org/oe-kbuild-all/202310240246.FyXNZrbZ-lkp@intel.com/
  https://lore.kernel.org/lkml/9e56e94d-536e-435a-afb0-4738e6eddedc@infradead.org/
* Comments in v5 not triggered by krobot (yet):
- Fix GET_DIRTY_BITMAP selftest to copy bitmap data (when we set in the
  mock-domain pagetables) instead of directly changing user memory. This was
  leading to selftests run failures as reported by Nicolin Chen
- Fix a build issue of selftests which included bitmap.h header headers,
  by importing the implementation from
  include/asm-generic/bitops/generic-non-atomic.h and avoid the non-UAPI headers
  all together. While doing so use set_bit() instead of __set_bit().
  Also reported by Nicolin Chen
- Fix GET_DIRTY_BITMAP struct declaration to have a u64 data instead of
  a pointer. Change the io_pagetable reflecting bitmap::data type change to have
  u64_to_user_ptr() as it should be done. (Arnd Bergmann)
- Run through clang-format and fix any issues where applicable (3 small
  formatting things only, but left others that were seemingly according to
  the style of the file).
- Rename intel iommu patch subject to have SS instead of SL as the
  latter is old VTd spec naming. And use 'iommu/vt-d' for component name
  instead of 'iommu/intel'. Rename slads_supported() into
  ssads_supported() to adhere to the new naming. (Yi Liu)

Changes since v4[8]:
* Rename HWPT_SET_DIRTY to HWPT_SET_DIRTY_TRACKING 
* Rename IOMMU_CAP_DIRTY to IOMMU_CAP_DIRTY_TRACKING
* Rename HWPT_GET_DIRTY_IOVA to HWPT_GET_DIRTY_BITMAP
* Rename IOMMU_HWPT_ALLOC_ENFORCE_DIRTY to IOMMU_HWPT_ALLOC_DIRTY_TRACKING
  including commit messages, code comments. Additionally change the
  variable in drivers from enforce_dirty to dirty_tracking.
* Reflect all the mass renaming in commit messages/structs/docs.
* Fix the enums prefix to be IOMMU_HWPT like everyone else
* UAPI docs fixes/spelling and minor consistency issues/adjustments
* Change function exit style in __iommu_read_and_clear_dirty to return
  right away instead of storing ret and returning at the end.
* Check 0 page_size and replace find-first-bit + left-shift with a
  simple divide in iommufd_check_iova_range()
* Handle empty iommu domains when setting dirty tracking in intel-iommu;
  Verified and amd-iommu was already the case.
* Remove unnecessary extra check for PGTT type
* Fix comment on function clearing the SLADE bit
* Fix wrong check that validates domain_alloc_user()
  accepted flags in amd-iommu driver
* Skip IOTLB domain flush if no devices exist on the iommu domain,
while setting dirty tracking in amd-iommu driver.
* Collect Reviewed-by tags by Jason, Lu Baolu, Brett, Kevin, Alex

Changes since v3[7]:
* Consolidate previous patch 9 and 10 into a single patch,
while removing iommufd_dirty_bitmap structure to instead use
the UAPI defined structure iommu_hwpt_get_dirty_iova and
pass around internally in iommufd.
* Iterate over areas from within the IOVA bitmap iterator
* Drop check for specific flags in hw_pagetable
* Drop assignment that calculates iopt_alignment, to instead
use iopt_alignment directly
* Move IOVA bitmap into iommufd and introduce IOMMUFD_DRIVER
bool kconfig which designates the usage of dirty tracking related
bitmaps (i.e. VFIO and IOMMU drivers right now).
* Update IOVA bitmap header files to account for IOMMUFD_DRIVER
being disabled
* Sort new IOMMUFD ioctls accordingly
* Move IOVA bitmap symbols to IOMMUFD namespace and update its
users by importing new namespace (new patch 3)
* Remove AMD IOMMU kernel log feature printing from series
* Remove struct amd_iommu from do_iommu_domain_alloc() function
and derive it from within do_iommu_domain_alloc().
* Consolidate pte_test_dirty() and pte_test_and_clear_dirty()
by passing flags and deciding whether to test or test_and_clear.
* Add a comment on top of the -EINVAL attach_device() failure when
dirty tracking is enforcement but IOMMU does not support dirty tracking
* Add Reviewed-by given by Suravee
* Select IOMMUFD_DRIVER if IOMMUFD is enabled on supported IOMMU drivers
* Remove spurious rcu_read_{,un}lock() from Intel/AMD iommus
* Fix unwinding in dirty tracking set failure case in intel-iommu
* Avoid unnecesary locking when checking dmar_domain::dirty_tracking
* Rename intel_iommu_slads_supported() to a slads_supported() macro
following intel-iommu style
* Change the XOR check into a == in set_dirty_tracking iommu op
* Consolidate PTE test or test-and-clear into single helper
* Improve intel_pasid_setup_dirty_tracking() to: use rate limited printk;
avoid unnecessary update if state is already the desired one;
do a clflush on non-coherent devices; remove the qi_flush_piotlb(); and
fail on unsupported pgtts.
* Remove the first_level support and always fail domain_alloc_user on those
cases with it being no use case ATM. Doing so lets us remove some code
for such handling in set_dirty_tracking
* Error out the pasid device attach when dirty tracking is enforced
as we don't support that either.
* Reorganize the series to have selftests at the end, and core/driver
enablement first.

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

Joao Martins (18):
  vfio/iova_bitmap: Export more API symbols
  vfio: Move iova_bitmap into iommufd
  iommufd/iova_bitmap: Move symbols to IOMMUFD namespace
  iommu: Add iommu_domain ops for dirty tracking
  iommufd: Add a flag to enforce dirty tracking on attach
  iommufd: Add IOMMU_HWPT_SET_DIRTY_TRACKING
  iommufd: Add IOMMU_HWPT_GET_DIRTY_BITMAP
  iommufd: Add capabilities to IOMMU_GET_HW_INFO
  iommufd: Add a flag to skip clearing of IOPTE dirty
  iommu/amd: Add domain_alloc_user based domain allocation
  iommu/amd: Access/Dirty bit support in IOPTEs
  iommu/vt-d: Access/Dirty bit support for SS domains
  iommufd/selftest: Expand mock_domain with dev_flags
  iommufd/selftest: Test IOMMU_HWPT_ALLOC_DIRTY_TRACKING
  iommufd/selftest: Test IOMMU_HWPT_SET_DIRTY_TRACKING
  iommufd/selftest: Test IOMMU_HWPT_GET_DIRTY_BITMAP
  iommufd/selftest: Test out_capabilities in IOMMU_GET_HW_INFO
  iommufd/selftest: Test IOMMU_HWPT_GET_DIRTY_BITMAP_NO_CLEAR flag

 drivers/iommu/Kconfig                         |   4 +
 drivers/iommu/amd/Kconfig                     |   1 +
 drivers/iommu/amd/amd_iommu_types.h           |  12 +
 drivers/iommu/amd/io_pgtable.c                |  68 ++++++
 drivers/iommu/amd/iommu.c                     | 144 +++++++++++-
 drivers/iommu/intel/Kconfig                   |   1 +
 drivers/iommu/intel/iommu.c                   | 103 ++++++++-
 drivers/iommu/intel/iommu.h                   |  16 ++
 drivers/iommu/intel/pasid.c                   | 109 +++++++++
 drivers/iommu/intel/pasid.h                   |   4 +
 drivers/iommu/iommufd/Makefile                |   1 +
 drivers/iommu/iommufd/device.c                |   4 +
 drivers/iommu/iommufd/hw_pagetable.c          |  51 ++++-
 drivers/iommu/iommufd/io_pagetable.c          | 172 ++++++++++++++
 drivers/iommu/iommufd/iommufd_private.h       |  22 ++
 drivers/iommu/iommufd/iommufd_test.h          |  21 ++
 drivers/{vfio => iommu/iommufd}/iova_bitmap.c |   5 +-
 drivers/iommu/iommufd/main.c                  |   7 +
 drivers/iommu/iommufd/selftest.c              | 187 +++++++++++++++-
 drivers/vfio/Makefile                         |   3 +-
 drivers/vfio/pci/mlx5/Kconfig                 |   1 +
 drivers/vfio/pci/mlx5/main.c                  |   1 +
 drivers/vfio/pci/pds/Kconfig                  |   1 +
 drivers/vfio/pci/pds/pci_drv.c                |   1 +
 drivers/vfio/vfio_main.c                      |   1 +
 include/linux/io-pgtable.h                    |   4 +
 include/linux/iommu.h                         |  70 ++++++
 include/linux/iova_bitmap.h                   |  26 +++
 include/uapi/linux/iommufd.h                  |  96 ++++++++
 tools/testing/selftests/iommu/iommufd.c       | 211 ++++++++++++++++++
 .../selftests/iommu/iommufd_fail_nth.c        |   2 +-
 tools/testing/selftests/iommu/iommufd_utils.h | 206 ++++++++++++++++-
 32 files changed, 1528 insertions(+), 27 deletions(-)
 rename drivers/{vfio => iommu/iommufd}/iova_bitmap.c (98%)

-- 
2.17.2

