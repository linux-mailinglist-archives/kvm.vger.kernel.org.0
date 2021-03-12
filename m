Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02EAC339501
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 18:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232362AbhCLRcg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 12:32:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55659 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231679AbhCLRcT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Mar 2021 12:32:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615570338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xhSFUQdlA2GO6iSQiZu6P1gE7L7SnxGWpmNseOtj/Ow=;
        b=JPnwpiXnSIMjIKGfj6BihXg8W36ZlxfFUjHxGOG59/ZhfJX9n1/AhCTOrrdJkY9QpiXfiB
        Wa+3Ieu0pbUqtYvnk7yQzuEo2naHtJywdm6HtywoWEDMyUTAqNt+6UajHAbm/0ZiTIhWk8
        hPXYD2sPKpwPD9OSmWI4KyQ3DOJc2SA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-bNhvwPppMU-fq2HEo5pAkw-1; Fri, 12 Mar 2021 12:32:15 -0500
X-MC-Unique: bNhvwPppMU-fq2HEo5pAkw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5FA65192D786;
        Fri, 12 Mar 2021 17:32:13 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-254.ams2.redhat.com [10.36.112.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 60CC410023AB;
        Fri, 12 Mar 2021 17:32:04 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com,
        alexandru.elisei@arm.com
Cc:     james.morse@arm.com, julien.thierry.kdev@gmail.com,
        suzuki.poulose@arm.com, shuah@kernel.org, pbonzini@redhat.com
Subject: [PATCH v3 0/8] KVM/ARM: Some vgic fixes and init sequence KVM selftests
Date:   Fri, 12 Mar 2021 18:31:54 +0100
Message-Id: <20210312173202.89576-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
https://github.com/eauger/linux/tree/vgic_kvmselftests_v3

History:
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
 arch/arm64/kvm/vgic/vgic-mmio-v3.c            | 116 ++-
 arch/arm64/kvm/vgic/vgic-mmio.c               |  10 +-
 arch/arm64/kvm/vgic/vgic.h                    |   1 +
 include/kvm/arm_vgic.h                        |   3 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/aarch64/vgic_init.c | 672 ++++++++++++++++++
 .../testing/selftests/kvm/include/kvm_util.h  |   5 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  51 ++
 11 files changed, 827 insertions(+), 50 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/vgic_init.c

-- 
2.26.2

