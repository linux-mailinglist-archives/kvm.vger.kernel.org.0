Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C31A6CA70
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2019 09:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389308AbfGRH4g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jul 2019 03:56:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:11953 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726423AbfGRH4g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jul 2019 03:56:36 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jul 2019 00:56:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,276,1559545200"; 
   d="scan'208";a="158712948"
Received: from gvt-optiplex-7060.bj.intel.com ([10.238.158.89])
  by orsmga007.jf.intel.com with ESMTP; 18 Jul 2019 00:56:33 -0700
From:   Kechen Lu <kechen.lu@intel.com>
To:     intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Kechen Lu <kechen.lu@intel.com>, kraxel@redhat.com,
        zhenyuw@linux.intel.com, zhiyuan.lv@intel.com,
        zhi.a.wang@intel.com, kevin.tian@intel.com, hang.yuan@intel.com,
        alex.williamson@redhat.com
Subject: [RFC PATCH v4 0/6] Deliver vGPU display refresh event to  userspace
Date:   Thu, 18 Jul 2019 23:56:34 +0800
Message-Id: <20190718155640.25928-1-kechen.lu@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series tries to send the vGPU display refresh event to user land.

Instead of delivering page flip events only or vblank events only, we 
choose to combine two of them, i.e. post display refresh event at vblanks 
and skip some of them when no page flip happens. Vblanks as upper bound 
are safe and skipping no-page-flip vblanks guarantees both trivial performance 
impacts and good user experience without screen tearing. Plus, we have the 
mask/unmask mechansim providing user space flexibility to switch between 
event-notified refresh and classic timer-based refresh.

In addition, there are some cases that guest app only uses one framebuffer 
for both drawing and display. In such case, guest OS won't do the plane page 
flip when the framebuffer is updated, thus the user land won't be notified 
about the updated framebuffer. Hence, in single framebuffer case, we apply
a heuristic to determine whether it is the case or not. If it is, notify user
land when each vblank event triggers.

v4:
- Deliver page flip event and single framebuffer refresh event bounded 
by display vblanks. (Kechen)
v3:
- Deliver display vblank event instead of page flip event. (Zhenyu)
v2:
- Use VFIO irq chain to get eventfds from userspace instead of adding
a new ABI. (Alex)
v1:
- https://patchwork.kernel.org/cover/10962341/

Kechen Lu (2):
  drm/i915/gvt: Deliver async primary plane page flip events at vblank
  drm/i915/gvt: Add cursor plane reg update trap emulation handler

Tina Zhang (4):
  vfio: Define device specific irq type capability
  vfio: Introduce vGPU display irq type
  drm/i915/gvt: Register vGPU display event irq
  drm/i915/gvt: Deliver vGPU refresh event to userspace

 drivers/gpu/drm/i915/gvt/cmd_parser.c |   5 +-
 drivers/gpu/drm/i915/gvt/display.c    |  54 ++++++-
 drivers/gpu/drm/i915/gvt/gvt.h        |  11 ++
 drivers/gpu/drm/i915/gvt/handlers.c   |  32 ++++-
 drivers/gpu/drm/i915/gvt/hypercall.h  |   1 +
 drivers/gpu/drm/i915/gvt/interrupt.c  |   7 +
 drivers/gpu/drm/i915/gvt/interrupt.h  |   3 +
 drivers/gpu/drm/i915/gvt/kvmgt.c      | 197 ++++++++++++++++++++++++--
 drivers/gpu/drm/i915/gvt/mpt.h        |  17 +++
 include/uapi/linux/vfio.h             |  22 ++-
 10 files changed, 330 insertions(+), 19 deletions(-)

-- 
2.17.1

