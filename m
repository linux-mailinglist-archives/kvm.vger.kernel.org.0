Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3111B5F99
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 17:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729261AbgDWPkc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 11:40:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:51188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728865AbgDWPkc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 11:40:32 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D9902075A;
        Thu, 23 Apr 2020 15:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587656431;
        bh=MzR7Ksg3zN//9VOBpsR8Z+gdJA8z+zcljbVAhZW0Gyc=;
        h=From:To:Cc:Subject:Date:From;
        b=mTU6YpolqaV19yyRc48VQLOC1Jqjzcdyj5HPnQpEz0AYioRan12wH3QPWszCwvuce
         T0l2slm7G+McCqfFgf9SBPzsxti3Kaq0ecuYpmeKeXTSVgmi72EDQ/F7tl9VySE+dv
         FgLrdRgrbi37eP5GL/JHmTk7euKnZ4BuGhYCns+I=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jRdxl-005oPM-Sh; Thu, 23 Apr 2020 16:40:30 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        =?UTF-8?q?Andr=C3=A9=20Przywara?= <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Julien Grall <julien@xen.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu
Subject: [GIT PULL] KVM/arm fixes for 5.7, take #1
Date:   Thu, 23 Apr 2020 16:40:01 +0100
Message-Id: <20200423154009.4113562-1-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, andre.przywara@arm.com, christoffer.dall@arm.com, julien@xen.org, yuzenghui@huawei.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Here is a bunch of fixes for the next -rc, focusing on the PSCI
implementation (spec conformance), and the usual vGIC patches
(preventing userspace from messing with the HW state and plugging a
couple of memory leaks).

Please pull,

	M.

The following changes since commit 8f3d9f354286745c751374f5f1fcafee6b3f3136:

  Linux 5.7-rc1 (2020-04-12 12:35:55 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.7-1

for you to fetch changes up to 446c0768f5509793a0e527a439d4866b24707b0e:

  Merge branch 'kvm-arm64/vgic-fixes-5.7' into kvmarm-master/master (2020-04-23 16:27:33 +0100)

----------------------------------------------------------------
KVM/arm fixes for Linux 5.7, take #1

- Prevent the userspace API from interacting directly with the HW
  stage of the virtual GIC
- Fix a couple of vGIC memory leaks
- Tighten the rules around the use of the 32bit PSCI functions
  for 64bit guest, as well as the opposite situation (matches the
  specification)

----------------------------------------------------------------
Marc Zyngier (8):
      KVM: arm: vgic: Fix limit condition when writing to GICD_I[CS]ACTIVER
      KVM: arm64: PSCI: Narrow input registers when using 32bit functions
      KVM: arm64: PSCI: Forbid 64bit functions for 32bit guests
      KVM: arm: vgic: Synchronize the whole guest on GIC{D,R}_I{S,C}ACTIVER read
      KVM: arm: vgic: Only use the virtual state when userspace accesses enable bits
      KVM: arm: vgic-v2: Only use the virtual state when userspace accesses pending bits
      Merge branch 'kvm-arm64/psci-fixes-5.7' into kvmarm-master/master
      Merge branch 'kvm-arm64/vgic-fixes-5.7' into kvmarm-master/master

Zenghui Yu (2):
      KVM: arm64: vgic-v3: Retire all pending LPIs on vcpu destroy
      KVM: arm64: vgic-its: Fix memory leak on the error path of vgic_add_lpi()

 virt/kvm/arm/psci.c              |  40 +++++++
 virt/kvm/arm/vgic/vgic-init.c    |  10 +-
 virt/kvm/arm/vgic/vgic-its.c     |  11 +-
 virt/kvm/arm/vgic/vgic-mmio-v2.c |  16 +--
 virt/kvm/arm/vgic/vgic-mmio-v3.c |  28 ++---
 virt/kvm/arm/vgic/vgic-mmio.c    | 228 +++++++++++++++++++++++++++++----------
 virt/kvm/arm/vgic/vgic-mmio.h    |  19 ++++
 7 files changed, 272 insertions(+), 80 deletions(-)
