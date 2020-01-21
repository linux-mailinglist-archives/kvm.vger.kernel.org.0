Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 096D31436FF
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 07:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgAUGTa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 01:19:30 -0500
Received: from mga02.intel.com ([134.134.136.20]:62547 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726052AbgAUGTa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jan 2020 01:19:30 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Jan 2020 22:19:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,344,1574150400"; 
   d="scan'208";a="278301056"
Received: from hyperv-sh3.bj.intel.com ([10.240.193.95])
  by fmsmga001.fm.intel.com with ESMTP; 20 Jan 2020 22:19:27 -0800
From:   Jing Liu <jing2.liu@linux.intel.com>
To:     virtio-dev@lists.oasis-open.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, Jing Liu <jing2.liu@linux.intel.com>
Subject: [virtio-dev] [PATCH v2 0/5] virtio-mmio enhancement
Date:   Tue, 21 Jan 2020 21:54:28 +0800
Message-Id: <1579614873-21907-1-git-send-email-jing2.liu@linux.intel.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current virtio over MMIO has some limitations that impact the performance.
It only supports single legacy, dedicated interrupt and one virtqueue
notification register for all virtqueues which cause performance penalties.

To address such limitations, we proposed to update virtio-mmio spec with
two new feature bits to support MSI interrupt and enhancing notification mechanism.

For keeping virtio-mmio simple as it was, and considering practical usages, this
provides two kinds of mapping mode for device: MSI non-sharing mode and MSI sharing mode.
MSI non-sharng mode indicates a fixed static vector and event relationship specified
in spec, which can simplify the setup process and reduce vmexit, fitting for
a high interrupt rate request.
MSI sharing mode indicates a dynamic mapping, which is more like PCI does, fitting
for a non-high interrupt rate request.

Change Log:
v1->v2:
* Change version update to feature bit
* Add mask/unmask support
* Add two MSI sharing/non-sharing modes
* Change MSI registers layout and bits

Jing Liu (5):
  virtio-mmio: Add feature bit for MMIO notification
  virtio-mmio: Enhance queue notification support
  virtio-mmio: Add feature bit for MMIO MSI
  virtio-mmio: Introduce MSI details
  virtio-mmio: MSI vector and event mapping

 content.tex | 286 ++++++++++++++++++++++++++++++++++++++++++++++++++++++------
 msi-state.c |   5 ++
 2 files changed, 262 insertions(+), 29 deletions(-)
 create mode 100644 msi-state.c

-- 
2.7.4

