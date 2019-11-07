Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 621EAF340F
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2019 17:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388564AbfKGQEZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Nov 2019 11:04:25 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:56966 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387459AbfKGQEY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Nov 2019 11:04:24 -0500
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by cheepnis.misterjones.org with esmtpsa (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1iSkGk-0008Bm-6O; Thu, 07 Nov 2019 17:04:22 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 0/2] KVM: arm64: Reduce occurence of GICv4 doorbells on non-oversubscribed systems
Date:   Thu,  7 Nov 2019 16:04:10 +0000
Message-Id: <20191107160412.30301-1-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As I was cleaning up some of the GICv4 code to make way for GICv4.1 it
occured to me that we could drastically reduce the impact of the GICv4
doorbells on systems that are not oversubscribed (each vcpu "owns" a
physical CPU).

The technique borrows its logic from the way we disable WFE trapping
when a vcpu is the only process on the CPU run-queue. If this vcpu is
the target of VLPIs, it is then beneficial not to trap blocking WFIs
and to leave the vcpu waiting for interrupts in guest state.

All we need to do here is to track whether VLPIs are associated to a
vcpu (which is easily done by using a counter that we update on MAPI,
DISCARD and MOVI).

It has been *very lightly* tested on a D05, and behaved pretty well in
my limited test cases (I get almost no doorbell at all in the non
oversubscribed case, and the usual hailstorm as soon as there is
oversubscription). I'd welcome some testing on more current HW.

Marc Zyngier (2):
  KVM: vgic-v4: Track the number of VLPIs per vcpu
  KVM: arm64: Opportunistically turn off WFI trapping when using direct
    LPI injection

 arch/arm/include/asm/kvm_emulate.h   | 4 ++--
 arch/arm64/include/asm/kvm_emulate.h | 9 +++++++--
 include/linux/irqchip/arm-gic-v4.h   | 2 ++
 virt/kvm/arm/arm.c                   | 4 ++--
 virt/kvm/arm/vgic/vgic-init.c        | 1 +
 virt/kvm/arm/vgic/vgic-its.c         | 3 +++
 virt/kvm/arm/vgic/vgic-v4.c          | 2 ++
 7 files changed, 19 insertions(+), 6 deletions(-)

-- 
2.20.1

