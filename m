Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD163351133
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 10:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233662AbhDAIxN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 04:53:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25253 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229459AbhDAIwr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 04:52:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617267166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=BP9WZNqxIzPCA5LtPAzAvwf0rm1qTrzO8RqIvNWUBDg=;
        b=Rg3rDWb/f1dPfILyOdVRc42JL0x2MHNDK3Zm9JA4nkvrjIEauCN/5yTMDg/R3pobRk8uDv
        X2NtO3ITHi6S6ZCkzfmXpTgYEcaFGO5unNzUSGOk+0pjxqo57K1VHywUE+Xeu803xRndOE
        HWA1Ox8D+brqc541ksGRVPtomg5qdfE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-37QGPauRPAqjbxf-145CTA-1; Thu, 01 Apr 2021 04:52:44 -0400
X-MC-Unique: 37QGPauRPAqjbxf-145CTA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED606802B7F;
        Thu,  1 Apr 2021 08:52:42 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-13.ams2.redhat.com [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0924E5D9DE;
        Thu,  1 Apr 2021 08:52:39 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com,
        alexandru.elisei@arm.com
Cc:     james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        pbonzini@redhat.com
Subject: [PATCH v4 0/8] KVM/ARM: Some vgic fixes and init sequence KVM selftests
Date:   Thu,  1 Apr 2021 10:52:30 +0200
Message-Id: <20210401085238.477270-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
https://github.com/eauger/linux/tree/vgic_kvmselftests_v4

History:
v3 -> v4:
- take into account Drew's comment on the kvm selftests. No
  change to the KVM related patches compared to v3
v2 ->v3:
- reworked last bit read accessor to handle contiguous redist
  regions and rdist not registered in ascending order
- removed [PATCH 5/9] KVM: arm: move has_run_once after the
  map_resources
v1 -> v2:
- Took into account all comments from Marc and Alexandru's except
  the has_run_once still after the map_resources (this would oblige
  me to revisit in depth the selftests)


Eric Auger (8):
  KVM: arm64: vgic-v3: Fix some error codes when setting RDIST base
  KVM: arm64: Fix KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION read
  KVM: arm64: vgic-v3: Fix error handling in vgic_v3_set_redist_base()
  KVM: arm/arm64: vgic: Reset base address on kvm_vgic_dist_destroy()
  docs: kvm: devices/arm-vgic-v3: enhance KVM_DEV_ARM_VGIC_CTRL_INIT doc
  KVM: arm64: Simplify argument passing to vgic_uaccess_[read|write]
  KVM: arm64: vgic-v3: Expose GICR_TYPER.Last for userspace
  KVM: selftests: aarch64/vgic-v3 init sequence tests

 .../virt/kvm/devices/arm-vgic-v3.rst          |   2 +-
 arch/arm64/kvm/vgic/vgic-init.c               |  13 +-
 arch/arm64/kvm/vgic/vgic-kvm-device.c         |   3 +
 arch/arm64/kvm/vgic/vgic-mmio-v3.c            | 116 +++-
 arch/arm64/kvm/vgic/vgic-mmio.c               |  10 +-
 arch/arm64/kvm/vgic/vgic.h                    |   1 +
 include/kvm/arm_vgic.h                        |   3 +
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/aarch64/vgic_init.c | 652 ++++++++++++++++++
 .../testing/selftests/kvm/include/kvm_util.h  |   9 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  77 +++
 12 files changed, 838 insertions(+), 50 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/vgic_init.c

-- 
2.26.3

