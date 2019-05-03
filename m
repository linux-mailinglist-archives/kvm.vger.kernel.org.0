Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA23F12DE9
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 14:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbfECMo5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 08:44:57 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:60050 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727956AbfECMo5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 08:44:57 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CB8D1374;
        Fri,  3 May 2019 05:44:56 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 94B493F220;
        Fri,  3 May 2019 05:44:53 -0700 (PDT)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Amit Daniel Kachhap <amit.kachhap@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Julien Grall <julien.grall@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Kristina Martsenko <kristina.martsenko@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "zhang . lei" <zhang.lei@jp.fujitsu.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: [PATCH 04/56] KVM: arm64: Refactor kvm_arm_num_regs() for easier maintenance
Date:   Fri,  3 May 2019 13:43:35 +0100
Message-Id: <20190503124427.190206-5-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190503124427.190206-1-marc.zyngier@arm.com>
References: <20190503124427.190206-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Dave Martin <Dave.Martin@arm.com>

kvm_arm_num_regs() adds together various partial register counts in
a freeform sum expression, which makes it harder than necessary to
read diffs that add, modify or remove a single term in the sum
(which is expected to the common case under maintenance).

This patch refactors the code to add the term one per line, for
maximum readability.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
Tested-by: zhang.lei <zhang.lei@jp.fujitsu.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/guest.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index dd436a50fce7..62514cba95ca 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -258,8 +258,14 @@ static int get_timer_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
  */
 unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu)
 {
-	return num_core_regs() + kvm_arm_num_sys_reg_descs(vcpu)
-		+ kvm_arm_get_fw_num_regs(vcpu)	+ NUM_TIMER_REGS;
+	unsigned long res = 0;
+
+	res += num_core_regs();
+	res += kvm_arm_num_sys_reg_descs(vcpu);
+	res += kvm_arm_get_fw_num_regs(vcpu);
+	res += NUM_TIMER_REGS;
+
+	return res;
 }
 
 /**
-- 
2.20.1

