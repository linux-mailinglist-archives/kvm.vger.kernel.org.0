Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 244233D0BE0
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 12:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236898AbhGUIrx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 04:47:53 -0400
Received: from foss.arm.com ([217.140.110.172]:49614 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237492AbhGUIjy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jul 2021 04:39:54 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3679731B;
        Wed, 21 Jul 2021 02:20:31 -0700 (PDT)
Received: from entos-thunderx2-desktop.shanghai.arm.com (entos-thunderx2-desktop.shanghai.arm.com [10.169.212.208])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 12F7A3F694;
        Wed, 21 Jul 2021 02:20:27 -0700 (PDT)
From:   Jianyong Wu <jianyong.wu@arm.com>
To:     maz@kernel.org, james.morse@arm.com, andre.przywara@arm.com,
        lushenming@huawei.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        justin.he@arm.com, jianyong.wu@arm.com
Subject: [PATCH] doc/arm: take care restore order of GICR_* in ITS restore
Date:   Wed, 21 Jul 2021 17:20:19 +0800
Message-Id: <20210721092019.144088-1-jianyong.wu@arm.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When restore GIC/ITS, GICR_CTLR must be restored after GICR_PROPBASER
and GICR_PENDBASER. That is important, as both of GICR_PROPBASER and
GICR_PENDBASER will fail to be loaded when lpi has enabled yet in
GICR_CTLR. Keep the restore order above will avoid that issue.
Shout it out at the doc is very helpful that may avoid lots of debug work.

Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
---
 Documentation/virt/kvm/devices/arm-vgic-its.rst | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-its.rst b/Documentation/virt/kvm/devices/arm-vgic-its.rst
index d257eddbae29..6b36de6937f8 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-its.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-its.rst
@@ -126,7 +126,8 @@ ITS Restore Sequence:
 The following ordering must be followed when restoring the GIC and the ITS:
 
 a) restore all guest memory and create vcpus
-b) restore all redistributors
+b) restore all redistributors:
+   make sure restore GICR_CTLR after GICR_PROPBASER and GICR_PENDBASER
 c) provide the ITS base address
    (KVM_DEV_ARM_VGIC_GRP_ADDR)
 d) restore the ITS in the following order:
-- 
2.17.1

