Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09AF317E084
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 13:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgCIMsq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 08:48:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725956AbgCIMsq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 08:48:46 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43F6E20866;
        Mon,  9 Mar 2020 12:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583758125;
        bh=9sTOwmipWBkuYFmW99E2qokfucw21rAYEF30PetE1g0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cBIlgajuyPyHGJ3OqQGtTRH52t71yuBMuSl+M2Q2eK9Acs9oQT3hlFH4OHvLcYrCY
         FciEI5Orm5TKpYqgvAgLIWtuZuEqcjAWF275KEf4LXdbAQ6b5ztMM6bMMPwVwSalXT
         NxWstij5W48OAe8LjrObuJXiKDitQ5hDIjtO1paQ=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jBHpr-00BHiN-Hv; Mon, 09 Mar 2020 12:48:43 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v2 2/2] KVM: arm64: Document PMU filtering API
Date:   Mon,  9 Mar 2020 12:48:37 +0000
Message-Id: <20200309124837.19908-3-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200309124837.19908-1-maz@kernel.org>
References: <20200309124837.19908-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, robin.murphy@arm.com, mark.rutland@arm.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a small blurb describing how the event filtering API gets used.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 Documentation/virt/kvm/devices/vcpu.rst | 40 +++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index 9963e680770a..7262c0469856 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -55,6 +55,46 @@ Request the initialization of the PMUv3.  If using the PMUv3 with an in-kernel
 virtual GIC implementation, this must be done after initializing the in-kernel
 irqchip.
 
+1.3 ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_FILTER
+---------------------------------------
+
+:Parameters: in kvm_device_attr.addr the address for a PMU event filter is a
+             pointer to a struct kvm_pmu_event_filter
+
+:Returns:
+
+	 =======  ======================================================
+	 -ENODEV: PMUv3 not supported or GIC not initialized
+	 -ENXIO:  PMUv3 not properly configured or in-kernel irqchip not
+	 	  configured as required prior to calling this attribute
+	 -EBUSY:  PMUv3 already initialized
+	 =======  ======================================================
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
+A filter range is defined as the range [@base_event, @base_event + @nevents[,
+together with an @action (KVM_PMU_EVENT_ALLOW or KVM_PMU_EVENT_DENY). The
+first registered range defines the global policy (global ALLOW if the first
+@action is DENY, global DENY if the first @action is ALLOW). Multiple ranges
+can be programmed, and must fit within the 16bit space defined by the ARMv8.1
+PMU architecture.
+
+Restrictions: Event 0 (SW_INCR) is never filtered, as it doesn't count a
+hardware event. Filtering event 0x1E (CHAIN) has no effect either, as it
+isn't strictly speaking an event. Filtering the cycle counter is possible
+using event 0x11 (CPU_CYCLES).
+
 
 2. GROUP: KVM_ARM_VCPU_TIMER_CTRL
 =================================
-- 
2.20.1

