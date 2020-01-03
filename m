Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A05B312F298
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2020 02:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgACBJa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jan 2020 20:09:30 -0500
Received: from mga03.intel.com ([134.134.136.65]:29111 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbgACBJa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jan 2020 20:09:30 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Jan 2020 17:09:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,388,1571727600"; 
   d="scan'208";a="252429485"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.9])
  by fmsmga002.fm.intel.com with ESMTP; 02 Jan 2020 17:09:28 -0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     alex.williamson@redhat.com, zhenyuw@linux.intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        intel-gvt@eclists.intel.com, pbonzini@redhat.com,
        kevin.tian@intel.com, Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 0/2] use vfio_iova_rw() to read/write IOVAs from CPU side
Date:   Thu,  2 Jan 2020 20:00:55 -0500
Message-Id: <20200103010055.4140-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When device models read/write memory pointed by a range of IOVAs, it is
better to use vfio interfaces. And because this read/write is from CPUs,
there's no need to call vfio_pin_pages() to pin those memory.

patch 1 introduces interface vfio_iova_rw() in vfio to read/write
userspace IOVAs without pinning userspace pages.

patch 2 let gvt switch from kvm side rw interface to vfio_iova_rw().


Yan Zhao (2):
  vfio: introduce vfio_iova_rw to read/write a range of IOVAs
  drm/i915/gvt: subsitute kvm_read/write_guest with vfio_iova_rw

 drivers/gpu/drm/i915/gvt/kvmgt.c | 26 +++-------
 drivers/vfio/vfio.c              | 45 ++++++++++++++++++
 drivers/vfio/vfio_iommu_type1.c  | 81 ++++++++++++++++++++++++++++++++
 include/linux/vfio.h             |  5 ++
 4 files changed, 138 insertions(+), 19 deletions(-)

-- 
2.17.1

