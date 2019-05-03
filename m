Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F123012E29
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 14:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbfECMqf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 08:46:35 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:60676 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727737AbfECMqf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 08:46:35 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 299B1374;
        Fri,  3 May 2019 05:46:35 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E6A2B3F220;
        Fri,  3 May 2019 05:46:31 -0700 (PDT)
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
Subject: [PATCH 32/56] KVM: arm64/sve: sys_regs: Demote redundant vcpu_has_sve() checks to WARNs
Date:   Fri,  3 May 2019 13:44:03 +0100
Message-Id: <20190503124427.190206-33-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190503124427.190206-1-marc.zyngier@arm.com>
References: <20190503124427.190206-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Dave Martin <Dave.Martin@arm.com>

Because of the logic in kvm_arm_sys_reg_{get,set}_reg() and
sve_id_visibility(), we should never call
{get,set}_id_aa64zfr0_el1() for a vcpu where !vcpu_has_sve(vcpu).

To avoid the code giving the impression that it is valid for these
functions to be called in this situation, and to help the compiler
make the right optimisation decisions, this patch adds WARN_ON()
for these cases.

Given the way the logic is spread out, this seems preferable to
dropping the checks altogether.

Suggested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 09e9b0625911..7046c7686321 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1144,7 +1144,7 @@ static int get_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
 {
 	u64 val;
 
-	if (!vcpu_has_sve(vcpu))
+	if (WARN_ON(!vcpu_has_sve(vcpu)))
 		return -ENOENT;
 
 	val = guest_id_aa64zfr0_el1(vcpu);
@@ -1159,7 +1159,7 @@ static int set_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
 	int err;
 	u64 val;
 
-	if (!vcpu_has_sve(vcpu))
+	if (WARN_ON(!vcpu_has_sve(vcpu)))
 		return -ENOENT;
 
 	err = reg_from_user(&val, uaddr, id);
-- 
2.20.1

