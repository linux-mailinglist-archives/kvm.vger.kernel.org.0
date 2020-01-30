Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B128E14DBCB
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 14:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbgA3N3U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 08:29:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:48210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727417AbgA3N3U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 08:29:20 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52977214D8;
        Thu, 30 Jan 2020 13:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580390959;
        bh=dh8dergRizxwfhKXTRtQc9cB5ErpuOCTez5+NklVjS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z+nIVy8Wl+yoeXRp7CAA4BKuc7kQqPHaPC+7dti3zJ3PBhMjCVP07saX/qvMMy4sL
         Z8GqJruaedRUhtDWRSGi715OylUKb+piEIZQhfVhjX4cL+fm09mWNtWPv820OFOYRS
         e9CwBVjz2HW1zkr8iRr3ZVduXJgUBecTJik/sjNI=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1ix9q7-002BmW-97; Thu, 30 Jan 2020 13:26:35 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Beata Michalska <beata.michalska@linaro.org>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Haibin Wang <wanghaibin.wang@huawei.com>,
        James Morse <james.morse@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Shannon Zhao <shannon.zhao@linux.alibaba.com>,
        Steven Price <steven.price@arm.com>,
        Will Deacon <will@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: [PATCH 23/23] KVM: arm64: Treat emulated TVAL TimerValue as a signed 32-bit integer
Date:   Thu, 30 Jan 2020 13:25:58 +0000
Message-Id: <20200130132558.10201-24-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200130132558.10201-1-maz@kernel.org>
References: <20200130132558.10201-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, drjones@redhat.com, andrew.murray@arm.com, beata.michalska@linaro.org, christoffer.dall@arm.com, eric.auger@redhat.com, gshan@redhat.com, wanghaibin.wang@huawei.com, james.morse@arm.com, broonie@kernel.org, mark.rutland@arm.com, rmk+kernel@armlinux.org.uk, shannon.zhao@linux.alibaba.com, steven.price@arm.com, will@kernel.org, yuehaibing@huawei.com, yuzenghui@huawei.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexandru Elisei <alexandru.elisei@arm.com>

According to the ARM ARM, registers CNT{P,V}_TVAL_EL0 have bits [63:32]
RES0 [1]. When reading the register, the value is truncated to the least
significant 32 bits [2], and on writes, TimerValue is treated as a signed
32-bit integer [1, 2].

When the guest behaves correctly and writes 32-bit values, treating TVAL
as an unsigned 64 bit register works as expected. However, things start
to break down when the guest writes larger values, because
(u64)0x1_ffff_ffff = 8589934591. but (s32)0x1_ffff_ffff = -1, and the
former will cause the timer interrupt to be asserted in the future, but
the latter will cause it to be asserted now.  Let's treat TVAL as a
signed 32-bit register on writes, to match the behaviour described in
the architecture, and the behaviour experimentally exhibited by the
virtual timer on a non-vhe host.

[1] Arm DDI 0487E.a, section D13.8.18
[2] Arm DDI 0487E.a, section D11.2.4

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
[maz: replaced the read-side mask with lower_32_bits]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Fixes: 8fa761624871 ("KVM: arm/arm64: arch_timer: Fix CNTP_TVAL calculation")
Link: https://lore.kernel.org/r/20200127103652.2326-1-alexandru.elisei@arm.com
---
 virt/kvm/arm/arch_timer.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index f182b2380345..c6c2a9dde00c 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -805,6 +805,7 @@ static u64 kvm_arm_timer_read(struct kvm_vcpu *vcpu,
 	switch (treg) {
 	case TIMER_REG_TVAL:
 		val = timer->cnt_cval - kvm_phys_timer_read() + timer->cntvoff;
+		val &= lower_32_bits(val);
 		break;
 
 	case TIMER_REG_CTL:
@@ -850,7 +851,7 @@ static void kvm_arm_timer_write(struct kvm_vcpu *vcpu,
 {
 	switch (treg) {
 	case TIMER_REG_TVAL:
-		timer->cnt_cval = kvm_phys_timer_read() - timer->cntvoff + val;
+		timer->cnt_cval = kvm_phys_timer_read() - timer->cntvoff + (s32)val;
 		break;
 
 	case TIMER_REG_CTL:
-- 
2.20.1

