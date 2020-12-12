Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3F6C2D896A
	for <lists+kvm@lfdr.de>; Sat, 12 Dec 2020 19:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407704AbgLLSv4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Dec 2020 13:51:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50169 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726167AbgLLSv4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 12 Dec 2020 13:51:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607799029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+8PgvJ932tyD+kO+UM8no2CrJ/budWb9RkQW3XvAXW0=;
        b=YTBz67tS3WZyrosk8S0kfB68Unl9Ul6S7aGh9SsQzHmE9Psnwh/4ShiM3gC6rzhSGDaKkp
        +JeBJyQ0zQxB5SO/Z3iF6KpYG1R3UQoYi9sdtXpXtfUXaDkYy3MmmAmWFSygXrTlkDP44H
        cZgII/C9ZUoEqGllAl77a5yZ4tF7BIQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-577-UfkopIKKNhqhAsb6XnWmPQ-1; Sat, 12 Dec 2020 13:50:27 -0500
X-MC-Unique: UfkopIKKNhqhAsb6XnWmPQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E2716180A087;
        Sat, 12 Dec 2020 18:50:25 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-115-41.ams2.redhat.com [10.36.115.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B91CC1F45B;
        Sat, 12 Dec 2020 18:50:19 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com
Cc:     alexandru.elisei@arm.com, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        shuah@kernel.org, pbonzini@redhat.com
Subject: [PATCH 0/9] KVM/ARM: Some vgic fixes and init sequence KVM selftests
Date:   Sat, 12 Dec 2020 19:50:01 +0100
Message-Id: <20201212185010.26579-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While writting vgic v3 init sequence KVM selftests I noticed some
relatively minor issues. This was also the opportunity to try to
fix the issue laterly reported by Zenghui, related to the RDIST_TYPER
last bit emulation. The final patch is a first batch of VGIC init
sequence selftests. Of course they can be augmented with a lot more
register access tests, but let's try to move forward incrementally ...

Best Regards

Eric

This series can be found at:
https://github.com/eauger/linux/tree/vgic-selftests-and-fixes-v1

Eric Auger (9):
  KVM: arm64: vgic-v3: Fix some error codes when setting RDIST base
  KVM: arm64: Fix KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION read
  KVM: arm64: vgic-v3: Fix error handling in vgic_v3_set_redist_base()
  KVM: arm/arm64: vgic: Reset base address on kvm_vgic_dist_destroy()
  KVM: arm: move has_run_once after the map_resources
  docs: kvm: devices/arm-vgic-v3: enhance KVM_DEV_ARM_VGIC_CTRL_INIT doc
  KVM: arm64: Simplify argument passing to vgic_uaccess_[read|write]
  KVM: arm64: vgic-v3: Expose GICR_TYPER.Last for userspace
  KVM: selftests: aarch64/vgic-v3 init sequence tests

 .../virt/kvm/devices/arm-vgic-v3.rst          |   2 +-
 arch/arm64/kvm/arm.c                          |   4 +-
 arch/arm64/kvm/vgic/vgic-init.c               |   7 +-
 arch/arm64/kvm/vgic/vgic-kvm-device.c         |   3 +
 arch/arm64/kvm/vgic/vgic-mmio-v3.c            |  24 +-
 arch/arm64/kvm/vgic/vgic-mmio.c               |  10 +-
 include/kvm/arm_vgic.h                        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/aarch64/vgic_init.c | 453 ++++++++++++++++++
 .../testing/selftests/kvm/include/kvm_util.h  |   5 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  51 ++
 11 files changed, 546 insertions(+), 15 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/vgic_init.c

-- 
2.21.3

