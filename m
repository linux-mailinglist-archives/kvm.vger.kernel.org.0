Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF7F115F56A
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 19:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388007AbgBNSgb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 13:36:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:37410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729612AbgBNSgb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 13:36:31 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BF3222314;
        Fri, 14 Feb 2020 18:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581705390;
        bh=5r08mBYS8Hs6Uwk0S9akLYX+TgV0QH11etUSJUNAJAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tdi7bz73Nc2KbtvatmMJF6UVTvU1CDl+8gSh7qXOSUWOpcb1Xwwby3lsNEkIh3xaT
         goU3x/4YreWeMF6slHpFG57QGHydxBcLVF7Hw3teuPXowr+CtLZXcdIDYv2oFOmNAN
         FU45ndjeubj1JZCuasgIUUa1ylQRp59xiOIOsvVg=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j2fpE-005J5c-Uf; Fri, 14 Feb 2020 18:36:29 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 2/2] KVM: arm64: Document PMU filtering API
Date:   Fri, 14 Feb 2020 18:36:15 +0000
Message-Id: <20200214183615.25498-3-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214183615.25498-1-maz@kernel.org>
References: <20200214183615.25498-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a small blurb describing how the event filtering API gets used.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 Documentation/virt/kvm/devices/vcpu.txt | 28 +++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/Documentation/virt/kvm/devices/vcpu.txt b/Documentation/virt/kvm/devices/vcpu.txt
index 6f3bd64a05b0..76902e6bbc05 100644
--- a/Documentation/virt/kvm/devices/vcpu.txt
+++ b/Documentation/virt/kvm/devices/vcpu.txt
@@ -36,6 +36,34 @@ Request the initialization of the PMUv3.  If using the PMUv3 with an in-kernel
 virtual GIC implementation, this must be done after initializing the in-kernel
 irqchip.
 
+1.3 ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_FILTER
+Parameters: in kvm_device_attr.addr the address for a PMU event filter is a
+            pointer to a struct kvm_pmu_event_filter
+Returns: -ENODEV: PMUv3 not supported or GIC not initialized
+         -ENXIO: PMUv3 not properly configured or in-kernel irqchip not
+                 configured as required prior to calling this attribute
+         -EBUSY: PMUv3 already initialized
+
+Request the installation of a PMU event filter describe as follows:
+
+struct kvm_pmu_event_filter {
+	__u16	base_event;
+	__u16	nevents;
+
+#define KVM_PMU_EVENT_ALLOW	0
+#define KVM_PMU_EVENT_DENY	1
+
+	__u8	action;
+	__u8	pad[3];
+};
+
+A filter range is defined as the range [base_event, base_event + nevents[,
+together with an action (KVM_PMU_EVENT_ALLOW or KVM_PMU_EVENT_DENY). The
+first registered range defines the global policy (global ALLOW if the first
+action is DENY, global DENY if the first action is ALLOW). Multiple ranges
+can be programmed, and but fit within the 16bit space defined by the ARMv8.1
+PMU architecture.
+
 
 2. GROUP: KVM_ARM_VCPU_TIMER_CTRL
 Architectures: ARM,ARM64
-- 
2.20.1

