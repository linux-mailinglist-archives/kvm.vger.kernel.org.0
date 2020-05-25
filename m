Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2FAB1E077E
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 09:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388961AbgEYHJY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 03:09:24 -0400
Received: from mga03.intel.com ([134.134.136.65]:64294 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388904AbgEYHJY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 03:09:24 -0400
IronPort-SDR: 7jNqmsmbAEYTlZCrgKC1V5LK5PxQRnugwkyWSPBNHbEyKbxDKBKlhKVJS+EFIYdRG0auex3/tF
 CRTYwqVDhjoA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2020 00:09:23 -0700
IronPort-SDR: GTy/UgBSgNKAfK/Tie1LHQ85jj5tejRIkftRgh2WdVz7izBcCGWlnMKgGnNHVAAx3c9NP3mR+F
 JbT1DM0Am4Mw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,432,1583222400"; 
   d="scan'208";a="413427539"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by orsmga004.jf.intel.com with ESMTP; 25 May 2020 00:09:18 -0700
Date:   Mon, 25 May 2020 02:59:26 -0400
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>, cjia@nvidia.com,
        kevin.tian@intel.com, ziye.yang@intel.com, changpeng.liu@intel.com,
        yi.l.liu@intel.com, mlevitsk@redhat.com, eskultet@redhat.com,
        cohuck@redhat.com, dgilbert@redhat.com,
        jonathan.davies@nutanix.com, eauger@redhat.com, aik@ozlabs.ru,
        pasic@linux.ibm.com, felipe@nutanix.com,
        Zhengxiao.zx@Alibaba-inc.com, shuangtai.tst@alibaba-inc.com,
        Ken.Xue@amd.com, zhi.a.wang@intel.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH Kernel v22 0/8] Add UAPIs to support migration for VFIO
 devices
Message-ID: <20200525065925.GA698@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <1589781397-28368-1-git-send-email-kwankhede@nvidia.com>
 <20200519105804.02f3cae8@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200519105804.02f3cae8@x1.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 19, 2020 at 10:58:04AM -0600, Alex Williamson wrote:
> Hi folks,
> 
> My impression is that we're getting pretty close to a workable
> implementation here with v22 plus respins of patches 5, 6, and 8.  We
> also have a matching QEMU series and a proposal for a new i40e
> consumer, as well as I assume GVT-g updates happening internally at
> Intel.  I expect all of the latter needs further review and discussion,
> but we should be at the point where we can validate these proposed
> kernel interfaces.  Therefore I'd like to make a call for reviews so
> that we can get this wrapped up for the v5.8 merge window.  I know
> Connie has some outstanding documentation comments and I'd like to make
> sure everyone has an opportunity to check that their comments have been
> addressed and we don't discover any new blocking issues.  Please send
> your Acked-by/Reviewed-by/Tested-by tags if you're satisfied with this
> interface and implementation.  Thanks!
>
hi Alex
after porting gvt/i40e vf migration code to kernel/qemu v23, we spoted
two bugs.
1. "Failed to get dirty bitmap for iova: 0xfe011000 size: 0x3fb0 err: 22"
   This is a qemu bug that the dirty bitmap query range is not the same
   as the dma map range. It can be fixed in qemu. and I just have a little
   concern for kernel to have this restriction.

2. migration abortion, reporting
"qemu-system-x86_64-lm: vfio_load_state: Error allocating buffer
qemu-system-x86_64-lm: error while loading state section id 49(vfio)
qemu-system-x86_64-lm: load of migration failed: Cannot allocate memory"

It's still a qemu bug and we can fixed it by
"
if (migration->pending_bytes == 0) {
+            qemu_put_be64(f, 0);
+            qemu_put_be64(f, VFIO_MIG_FLAG_END_OF_STATE);
"
and actually there are some extra concerns about this part, as reported in
[1][2].

[1] data_size should be read ahead of data_offset
https://lists.gnu.org/archive/html/qemu-devel/2020-05/msg02795.html.
[2] should not repeatedly update pending_bytes in vfio_save_iterate()
https://lists.gnu.org/archive/html/qemu-devel/2020-05/msg02796.html.

but as those errors are all in qemu, and we have finished basic tests in
both gvt & i40e, we're fine with the kernel part interface in general now.
(except for my concern [1], which needs to update kernel patch 1)

so I wonder which way in your mind is better, to give our reviewed-by to
the kernel part now, or hold until next qemu fixes?
and as performance data from gvt is requested from your previous mail, is
that still required before the code is accepted?

BTW, we have also conducted some basic tests when viommu is on, and found out
errors like 
"qemu-system-x86_64-dt: vtd_iova_to_slpte: detected slpte permission error (iova=0x0, level=0x3, slpte=0x0, write=1)
qemu-system-x86_64-dt: vtd_iommu_translate: detected translation failure (dev=00:03:00, iova=0x0)
qemu-system-x86_64-dt: New fault is not recorded due to compression of faults".

Thanks
Yan




