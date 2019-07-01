Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6E4657A2B
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 05:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbfF0DoC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 23:44:02 -0400
Received: from mga17.intel.com ([192.55.52.151]:21244 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726447AbfF0DoC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 23:44:02 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jun 2019 20:44:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,422,1557212400"; 
   d="scan'208";a="360560931"
Received: from gvt.bj.intel.com ([10.238.158.187])
  by fmsmga005.fm.intel.com with ESMTP; 26 Jun 2019 20:43:59 -0700
From:   Tina Zhang <tina.zhang@intel.com>
To:     intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Tina Zhang <tina.zhang@intel.com>, kraxel@redhat.com,
        zhenyuw@linux.intel.com, zhiyuan.lv@intel.com,
        zhi.a.wang@intel.com, kevin.tian@intel.com, hang.yuan@intel.com,
        alex.williamson@redhat.com
Subject: [RFC PATCH v3 0/4] Deliver vGPU display vblank event to userspace
Date:   Thu, 27 Jun 2019 11:37:58 +0800
Message-Id: <20190627033802.1663-1-tina.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series tries to send the vGPU display vblank event to user land.

Instead of delivering page flip events, we choose to post display vblank
event. Handling page flip events for both primary plane and cursor plane
may make user space quite busy, although we have the mask/unmask mechansim
for mitigation. Besides, there are some cases that guest app only uses
one framebuffer for both drawing and display. In such case, guest OS won't
do the plane page flip when the framebuffer is updated, thus the user
land won't be notified about the updated framebuffer.

With vGPU's vblank event working as a timer, userspace still needs to
query the framebuffer first, before getting a new dma-buf for it.

v3:
- Deliver display vblank event instead of page flip event. (Zhenyu)
v2:
- Use VFIO irq chain to get eventfds from userspace instead of adding
a new ABI. (Alex)
v1:
- https://patchwork.kernel.org/cover/10962341/


Tina Zhang (4):
  vfio: Define device specific irq type capability
  vfio: Introduce vGPU display irq type
  drm/i915/gvt: Register vGPU display vblank irq
  drm/i915/gvt: Deliver vGPU vblank event to userspace

 drivers/gpu/drm/i915/gvt/display.c   |  14 +-
 drivers/gpu/drm/i915/gvt/gvt.h       |   6 +
 drivers/gpu/drm/i915/gvt/hypercall.h |   1 +
 drivers/gpu/drm/i915/gvt/kvmgt.c     | 193 +++++++++++++++++++++++++--
 drivers/gpu/drm/i915/gvt/mpt.h       |  17 +++
 include/uapi/linux/vfio.h            |  22 ++-
 6 files changed, 241 insertions(+), 12 deletions(-)

-- 
2.17.1

