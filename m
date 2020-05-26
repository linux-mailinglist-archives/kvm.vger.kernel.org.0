Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B66721B4A1E
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 18:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbgDVQTW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 12:19:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726466AbgDVQTV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 12:19:21 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E25242076E;
        Wed, 22 Apr 2020 16:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587572361;
        bh=7VEPAypFNkCLCXVaH5VuvuZA8Ena++dogWtuuNEmwT4=;
        h=From:To:Cc:Subject:Date:From;
        b=xcvSTJokq2ZrkNRcIv6uVgGazPlia+USShG5kmef9EYj0VeDChVzz3C9tW4jvqKY9
         yMBsuRARGHoDHUycJA7mPKlYAJwALXoiEApfJDXWcOQTb8FvcIHvpDKywYvgg4WUYR
         JqzNUC+vMd8nSYqNltqt+AqS14K3OPRa2vbMRlMw=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jRI5n-005Ynp-6B; Wed, 22 Apr 2020 17:19:19 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Zenghui Yu <yuzenghui@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Andre Przywara <Andre.Przywara@arm.com>,
        Julien Grall <julien@xen.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v3 0/6] KVM: arm: vgic fixes for 5.7
Date:   Wed, 22 Apr 2020 17:18:38 +0100
Message-Id: <20200422161844.3848063-1-maz@kernel.org>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, yuzenghui@huawei.com, eric.auger@redhat.com, Andre.Przywara@arm.com, julien@xen.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Here's a few vgic fixes I've been piling on during the merge window,
plus a couple that Zenghui contributed, and which I added to the mix.

The first patch is a silly off-by-one bug in the ACTIVE handling code,
where we miss fail to stop the guest if writing to the first set of
GICv2 SPIs. Oopsie boo.

The second patch improves the handling of the ACTIVE registers, which
we never synchronise on the read side (the distributor state can only
be updated when the vcpu exits). Let's fix it the same way we do it on
the write side (stop-the-world, read, restart). Yes, this is
expensive.

The following two patches deal with an issue where we consider the HW
state of an interrupt when responding to a userspace access. We should
never do this, as the guest shouldn't be running at this stage and if
it is, it is absolutely fine to return random bits to userspace. It
could also be that there is no active guest context at this stage, and
you end up with an Oops, which nobody really enjoys.

The last two patches fix a couple of memory leaks.

* From v2:
  - Now handle userspace access to GICv2 GICD_I{S,C}PENDR, which never
    really worked (pointed out by James)
  - Collected tags from Andre and James

Marc Zyngier (4):
  KVM: arm: vgic: Fix limit condition when writing to GICD_I[CS]ACTIVER
  KVM: arm: vgic: Synchronize the whole guest on GIC{D,R}_I{S,C}ACTIVER
    read
  KVM: arm: vgic: Only use the virtual state when userspace accesses
    enable bits
  KVM: arm: vgic-v2: Only use the virtual state when userspace accesses
    pending bits

Zenghui Yu (2):
  KVM: arm64: vgic-v3: Retire all pending LPIs on vcpu destroy
  KVM: arm64: vgic-its: Fix memory leak on the error path of
    vgic_add_lpi()

 virt/kvm/arm/vgic/vgic-init.c    |   6 +
 virt/kvm/arm/vgic/vgic-its.c     |  11 +-
 virt/kvm/arm/vgic/vgic-mmio-v2.c |  16 ++-
 virt/kvm/arm/vgic/vgic-mmio-v3.c |  28 ++--
 virt/kvm/arm/vgic/vgic-mmio.c    | 228 +++++++++++++++++++++++--------
 virt/kvm/arm/vgic/vgic-mmio.h    |  19 +++
 6 files changed, 230 insertions(+), 78 deletions(-)

-- 
2.26.1

