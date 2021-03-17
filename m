Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8107333EE12
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 11:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbhCQKHn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 06:07:43 -0400
Received: from foss.arm.com ([217.140.110.172]:56174 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229999AbhCQKH0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Mar 2021 06:07:26 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E0CB6D6E;
        Wed, 17 Mar 2021 03:07:24 -0700 (PDT)
Received: from e121166-lin.cambridge.arm.com (e121166-lin.cambridge.arm.com [10.1.196.255])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3AD753F70D;
        Wed, 17 Mar 2021 03:07:24 -0700 (PDT)
From:   Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To:     linux-kernel@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v3 0/1] GIC v4.1: Disable VSGI support for GIC CPUIF < v4.1
Date:   Wed, 17 Mar 2021 10:07:18 +0000
Message-Id: <20210317100719.3331-1-lorenzo.pieralisi@arm.com>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20210302102744.12692-1-lorenzo.pieralisi@arm.com>
References: <20210302102744.12692-1-lorenzo.pieralisi@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset is v3 of a previous version [1].

v2 -> v3:
	- Coalesced all checks in one function (Marc's feedback)
	- Allow sgi_ops on cpuif mismatch (to keep v4.1 doorbell
          mechanism that works fine even if GIC CPUIF < v4.1)

v1 -> v2:
	- Fixed vGIC behaviour according to v1 [1] review
	- Removed capability detection - rely on sanitised reg read
	- Added vsgi specific flag (for gic and kvm)

[1] https://lore.kernel.org/linux-arm-kernel/20210302102744.12692-1-lorenzo.pieralisi@arm.com

-- Original cover letter --

GIC v4.1 introduced changes to the GIC CPU interface; systems that
integrate CPUs that do not support GIC v4.1 features (as reported in the
ID_AA64PFR0_EL1.GIC bitfield) and a GIC v4.1 controller must disable in
software virtual SGIs support since the CPUIF and GIC controller version
mismatch results in CONSTRAINED UNPREDICTABLE behaviour at architectural
level.

For systems with CPUs reporting ID_AA64PFR0_EL1.GIC == b0001 integrated
in a system with a GIC v4.1 it _should_ still be safe to enable vLPIs
(other than vSGI) since the protocol between the GIC redistributor and
the GIC CPUIF was not changed from GIC v4.0 to GIC v4.1.

Cc: Marc Zyngier <maz@kernel.org>

Lorenzo Pieralisi (1):
  irqchip/gic-v4.1: Disable vSGI upon (GIC CPUIF < v4.1) detection

 arch/arm64/kvm/vgic/vgic-mmio-v3.c |  4 ++--
 drivers/irqchip/irq-gic-v4.c       | 27 +++++++++++++++++++++++++--
 include/linux/irqchip/arm-gic-v4.h |  2 ++
 3 files changed, 29 insertions(+), 4 deletions(-)

-- 
2.29.1

