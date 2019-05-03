Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09A6A12E1F
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 14:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbfECMqV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 08:46:21 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:60594 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727997AbfECMqV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 08:46:21 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 281E116A3;
        Fri,  3 May 2019 05:46:21 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E4E863F220;
        Fri,  3 May 2019 05:46:17 -0700 (PDT)
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
Subject: [PATCH 28/56] arm64: KVM: Fix system register enumeration
Date:   Fri,  3 May 2019 13:43:59 +0100
Message-Id: <20190503124427.190206-29-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190503124427.190206-1-marc.zyngier@arm.com>
References: <20190503124427.190206-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The introduction of the SVE registers to userspace started with a
refactoring of the way we expose any register via the ONE_REG
interface.

Unfortunately, this change doesn't exactly behave as expected
if the number of registers is non-zero and consider everything
to be an error. The visible result is that QEMU barfs very early
when creating vcpus.

Make sure we only exit early in case there is an actual error, rather
than a positive number of registers...

Fixes: be25bbb392fa ("KVM: arm64: Factor out core register ID enumeration")
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/guest.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 086ab0508d69..4f7b26bbf671 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -604,22 +604,22 @@ int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 	int ret;
 
 	ret = copy_core_reg_indices(vcpu, uindices);
-	if (ret)
+	if (ret < 0)
 		return ret;
 	uindices += ret;
 
 	ret = copy_sve_reg_indices(vcpu, uindices);
-	if (ret)
+	if (ret < 0)
 		return ret;
 	uindices += ret;
 
 	ret = kvm_arm_copy_fw_reg_indices(vcpu, uindices);
-	if (ret)
+	if (ret < 0)
 		return ret;
 	uindices += kvm_arm_get_fw_num_regs(vcpu);
 
 	ret = copy_timer_indices(vcpu, uindices);
-	if (ret)
+	if (ret < 0)
 		return ret;
 	uindices += NUM_TIMER_REGS;
 
-- 
2.20.1

