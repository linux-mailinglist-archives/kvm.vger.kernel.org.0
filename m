Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7C8014DBC8
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 14:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbgA3N3T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 08:29:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:48138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727132AbgA3N3S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 08:29:18 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79EB1214AF;
        Thu, 30 Jan 2020 13:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580390957;
        bh=AxpqAinrqMqcSc1J5l+Lh01LGoqatehtYQ3jSu83bmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YQHKmHwDbcO0+V9Gnnu7/QajLLMEUruOslRDCZauCaKshGtbJOc9Sm9mJtnvCTgHp
         x55jp5xndll4VNALZACVz3F/1zv17eJjPLVPm3gRCQkObs+g5iZwSKSPSnbn67+NYs
         H22nIXcfBobhD/mgUTrlczkxSLn38fDzJpRq62dY=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1ix9pz-002BmW-To; Thu, 30 Jan 2020 13:26:28 +0000
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
Subject: [PATCH 17/23] KVM: arm: Fix DFSR setting for non-LPAE aarch32 guests
Date:   Thu, 30 Jan 2020 13:25:52 +0000
Message-Id: <20200130132558.10201-18-maz@kernel.org>
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

From: James Morse <james.morse@arm.com>

Beata reports that KVM_SET_VCPU_EVENTS doesn't inject the expected
exception to a non-LPAE aarch32 guest.

The host intends to inject DFSR.FS=0x14 "IMPLEMENTATION DEFINED fault
(Lockdown fault)", but the guest receives DFSR.FS=0x04 "Fault on
instruction cache maintenance". This fault is hooked by
do_translation_fault() since ARMv6, which goes on to silently 'handle'
the exception, and restart the faulting instruction.

It turns out, when TTBCR.EAE is clear DFSR is split, and FS[4] has
to shuffle up to DFSR[10].

As KVM only does this in one place, fix up the static values. We
now get the expected:
| Unhandled fault: lock abort (0x404) at 0x9c800f00

Fixes: 74a64a981662a ("KVM: arm/arm64: Unify 32bit fault injection")
Reported-by: Beata Michalska <beata.michalska@linaro.org>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200121123356.203000-2-james.morse@arm.com
---
 virt/kvm/arm/aarch32.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/arm/aarch32.c b/virt/kvm/arm/aarch32.c
index 631d397ac81b..2da482ca7067 100644
--- a/virt/kvm/arm/aarch32.c
+++ b/virt/kvm/arm/aarch32.c
@@ -181,10 +181,12 @@ static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt,
 
 	/* Give the guest an IMPLEMENTATION DEFINED exception */
 	is_lpae = (vcpu_cp15(vcpu, c2_TTBCR) >> 31);
-	if (is_lpae)
+	if (is_lpae) {
 		*fsr = 1 << 9 | 0x34;
-	else
-		*fsr = 0x14;
+	} else {
+		/* Surprise! DFSR's FS[4] lives in bit 10 */
+		*fsr = BIT(10) | 0x4; /* 0x14 */
+	}
 }
 
 void kvm_inject_dabt32(struct kvm_vcpu *vcpu, unsigned long addr)
-- 
2.20.1

