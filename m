Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C36B01937F3
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 06:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbgCZFlj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 01:41:39 -0400
Received: from mga14.intel.com ([192.55.52.115]:26877 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725819AbgCZFlj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 01:41:39 -0400
IronPort-SDR: VkQ2H+db0R4LyOFfZ/soR/arVFijvxviNa7C1ODALIVzDycN8OaFSWC4Wdp2Y2RAu2rLyeX0jm
 rfS87PNPvUkA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2020 22:41:39 -0700
IronPort-SDR: wlkSnlxSudaj/8BAa5WVuoRT5YAw4yX+qM4Qc4Rki61dQfKy2m6Fp3S+2CCwZEt9nEh80jYizl
 ImBFeDDycoew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,307,1580803200"; 
   d="scan'208";a="393862301"
Received: from zhaji-mobl3.ccr.corp.intel.com (HELO dell-xps.ccr.corp.intel.com) ([10.249.174.174])
  by orsmga004.jf.intel.com with ESMTP; 25 Mar 2020 22:41:37 -0700
From:   Zhenyu Wang <zhenyuw@linux.intel.com>
To:     alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, kevin.tian@intel.com,
        intel-gvt-dev@lists.freedesktop.org
Subject: [PATCH v2 0/2] VFIO mdev aggregated resources handling
Date:   Thu, 26 Mar 2020 13:41:34 +0800
Message-Id: <20200326054136.2543-1-zhenyuw@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

This is a refresh on previous series: https://patchwork.kernel.org/cover/11208279/
and https://patchwork.freedesktop.org/series/70425/

Current mdev device create interface depends on fixed mdev type, which
get uuid from user to create instance of mdev device. If user wants to
use customized number of resource for mdev device, then only can
create new mdev type for that which may not be flexible. This
requirement comes not only from to be able to allocate flexible
resources for KVMGT, but also from Intel scalable IO virtualization
which would use vfio/mdev to be able to allocate arbitrary resources
on mdev instance. More info on [1] [2] [3].

As we agreed that for current opaque mdev device type, we'd still
explore management interface based on mdev sysfs definition. And this
one tries to follow Alex's previous suggestion to create generic
parameters under 'mdev' directory for each device, so vendor driver
could provide support like as other defined mdev sysfs entries.

For mdev type with aggregation support, files as "aggregated_instances"
and "max_aggregation" should be created under 'mdev' directory. E.g

/sys/devices/pci0000:00/0000:00:02.0/<UUID>/mdev/
   |-- aggregated_instances
   |-- max_aggregation

"aggregated_instances" is used to set or return current number of
instances for aggregation, which can not be larger than "max_aggregation".

The first patch is to update the document for new mdev parameter directory.
The second one is to add aggregation support in GVT driver.

References:
[1] https://software.intel.com/en-us/download/intel-virtualization-technology-for-directed-io-architecture-specification
[2] https://software.intel.com/en-us/download/intel-scalable-io-virtualization-technical-specification
[3] https://schd.ws/hosted_files/lc32018/00/LC3-SIOV-final.pdf

Zhenyu Wang (2):
  Documentation/driver-api/vfio-mediated-device.rst: update for
    aggregation support
  drm/i915/gvt: mdev aggregation type

 .../driver-api/vfio-mediated-device.rst       |  19 ++
 drivers/gpu/drm/i915/gvt/aperture_gm.c        |  44 +++--
 drivers/gpu/drm/i915/gvt/gtt.c                |   9 +-
 drivers/gpu/drm/i915/gvt/gvt.c                |   7 +-
 drivers/gpu/drm/i915/gvt/gvt.h                |  42 +++--
 drivers/gpu/drm/i915/gvt/kvmgt.c              | 115 +++++++++++-
 drivers/gpu/drm/i915/gvt/vgpu.c               | 172 ++++++++++++------
 7 files changed, 314 insertions(+), 94 deletions(-)

-- 
2.25.1

