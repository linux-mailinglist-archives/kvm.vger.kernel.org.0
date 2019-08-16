Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA368F90A
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2019 04:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbfHPCgB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 22:36:01 -0400
Received: from mga07.intel.com ([134.134.136.100]:39512 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726414AbfHPCgB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 22:36:01 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Aug 2019 19:35:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,391,1559545200"; 
   d="scan'208";a="194894829"
Received: from gvt.bj.intel.com ([10.238.158.180])
  by fmsmga001.fm.intel.com with ESMTP; 15 Aug 2019 19:35:43 -0700
From:   Tina Zhang <tina.zhang@intel.com>
To:     intel-gvt-dev@lists.freedesktop.org
Cc:     Tina Zhang <tina.zhang@intel.com>, kraxel@redhat.com,
        alex.williamson@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, hang.yuan@intel.com,
        zhiyuan.lv@intel.com
Subject: [PATCH v5 0/6] Deliver vGPU display refresh event to userspace
Date:   Fri, 16 Aug 2019 10:35:22 +0800
Message-Id: <20190816023528.30210-1-tina.zhang@intel.com>
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

v5:
- Introduce a vGPU display irq cap which can notify user space with
  both primary and cursor plane update events through one eventfd. (Gerd & Alex)
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

 drivers/gpu/drm/i915/gvt/cmd_parser.c |   6 +-
 drivers/gpu/drm/i915/gvt/display.c    |  49 +++++-
 drivers/gpu/drm/i915/gvt/display.h    |   3 +
 drivers/gpu/drm/i915/gvt/gvt.h        |   6 +
 drivers/gpu/drm/i915/gvt/handlers.c   |  32 +++-
 drivers/gpu/drm/i915/gvt/hypercall.h  |   1 +
 drivers/gpu/drm/i915/gvt/interrupt.c  |   7 +
 drivers/gpu/drm/i915/gvt/interrupt.h  |   3 +
 drivers/gpu/drm/i915/gvt/kvmgt.c      | 230 +++++++++++++++++++++++++-
 drivers/gpu/drm/i915/gvt/mpt.h        |  17 ++
 include/uapi/linux/vfio.h             |  40 ++++-
 11 files changed, 375 insertions(+), 19 deletions(-)

-- 
2.17.1

