Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F131BC1F0
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 08:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440556AbfIXGnG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 02:43:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:25186 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394281AbfIXGnG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 02:43:06 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Sep 2019 23:43:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,543,1559545200"; 
   d="scan'208";a="203306293"
Received: from gvt.bj.intel.com ([10.238.158.180])
  by fmsmga001.fm.intel.com with ESMTP; 23 Sep 2019 23:43:02 -0700
From:   Tina Zhang <tina.zhang@intel.com>
To:     intel-gvt-dev@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Tina Zhang <tina.zhang@intel.com>, kraxel@redhat.com,
        zhenyuw@linux.intel.com, zhiyuan.lv@intel.com,
        zhi.a.wang@intel.com, kevin.tian@intel.com, hang.yuan@intel.com,
        alex.williamson@redhat.com, yi.l.liu@intel.com
Subject: [PATCH v6 0/6] Deliver vGPU display refresh event to userspace
Date:   Tue, 24 Sep 2019 14:41:37 +0800
Message-Id: <20190924064143.9282-1-tina.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series sends the vGPU display refresh events to user land. A vGPU
display IRQ is proposed to notify user space with all the display
updates events.  With this IRQ supported by vendor driver, user space
can stop the display update timer and fully depend on getting the
notification if an update is needed.

How does gvt-g provide the vGPU display refresh IRQ covering all the
display update events?

Instead of delivering page flip events only or vblank events only, we
choose to combine two of them, i.e. post display refresh event at
vblanks and skip some of them when no page flip happens. Vblanks as
upper bound are safe and skipping no-page-flip vblanks guarantees both
trivial performance impacts and good user experience without screen
tearing. Plus, we have the mask/unmask mechansim providing user space
flexibility to switch between event-notified refresh and classic
timer-based refresh.

In addition, there are some cases that guest app only uses one
framebuffer for both drawing and display. In such case, guest OS won't
do the plane page flip when the framebuffer is updated, thus the user
land won't be notified about the updated framebuffer. Hence, in single
framebuffer case, we apply a heuristic to determine whether it is the
case or not. If it is, notify user land when each vblank event
triggers.

v6:
- Add more description to VFIO_IRQ_SUBTYPE_GFX_DISPLAY_IRQ and
  VFIO_IRQ_INFO_CAP_DISPLAY. (Alex & Gerd)
- Irq capability index starts from 1
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
 drivers/gpu/drm/i915/gvt/display.c    |  47 +++++-
 drivers/gpu/drm/i915/gvt/display.h    |   3 +
 drivers/gpu/drm/i915/gvt/gvt.h        |   7 +
 drivers/gpu/drm/i915/gvt/handlers.c   |  32 +++-
 drivers/gpu/drm/i915/gvt/hypercall.h  |   1 +
 drivers/gpu/drm/i915/gvt/interrupt.c  |   7 +
 drivers/gpu/drm/i915/gvt/interrupt.h  |   3 +
 drivers/gpu/drm/i915/gvt/kvmgt.c      | 230 +++++++++++++++++++++++++-
 drivers/gpu/drm/i915/gvt/mpt.h        |  17 ++
 include/uapi/linux/vfio.h             |  57 ++++++-
 11 files changed, 391 insertions(+), 19 deletions(-)

-- 
2.17.1

