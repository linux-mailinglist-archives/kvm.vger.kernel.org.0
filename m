Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A62612E6E9
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2020 14:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728429AbgABNrR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jan 2020 08:47:17 -0500
Received: from foss.arm.com ([217.140.110.172]:47330 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728342AbgABNrQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jan 2020 08:47:16 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5A9B71FB;
        Thu,  2 Jan 2020 05:47:16 -0800 (PST)
Received: from e121566-lin.arm.com,emea.arm.com,asiapac.arm.com,usa.arm.com (unknown [10.37.9.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id EBA023F68F;
        Thu,  2 Jan 2020 05:47:14 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, maz@kernel.org,
        andre.przywara@arm.com
Subject: [kvm-unit-tests RFC PATCH v3 6/7] arm64: selftest: Expand EL2 test to disable and re-enable VHE
Date:   Thu,  2 Jan 2020 13:46:45 +0000
Message-Id: <1577972806-16184-7-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1577972806-16184-1-git-send-email-alexandru.elisei@arm.com>
References: <1577972806-16184-1-git-send-email-alexandru.elisei@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check that disabling VHE, then re-enabling it again, works.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---

Disabling VHE is broken with version v1 of the NV patches; to run the tests
I use this patch:

--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -333,7 +333,8 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
                 * to reverse-translate virtual EL2 system registers for a
                 * non-VHE guest hypervisor.
                 */
-               __vcpu_sys_reg(vcpu, reg) = val;
+               if (reg != HCR_EL2)
+                       __vcpu_sys_reg(vcpu, reg) = val;
 
                switch (reg) {
                case ELR_EL2:
@@ -370,7 +371,17 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
                return;
 
 memory_write:
-        __vcpu_sys_reg(vcpu, reg) = val;
+       if (reg == HCR_EL2 && vcpu_el2_e2h_is_set(vcpu) && !(val & HCR_E2H)) {
+               preempt_disable();
+               kvm_arch_vcpu_put(vcpu);
+
+               __vcpu_sys_reg(vcpu, reg) = val;
+
+               kvm_arch_vcpu_load(vcpu, smp_processor_id());
+               preempt_enable();
+       } else {
+                __vcpu_sys_reg(vcpu, reg) = val;
+       }
 }
 
 /* 3 bits per cache level, as per CLIDR, but non-existent caches always 0 */

 arm/selftest.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arm/selftest.c b/arm/selftest.c
index a30e101a4920..b7f2a83be65f 100644
--- a/arm/selftest.c
+++ b/arm/selftest.c
@@ -424,6 +424,14 @@ static void check_el2_cpu(void *data __unused)
 	report(current_level() == CurrentEL_EL2, "CPU(%3d) Running at EL2", cpu);
 	report(vhe_supported() && vhe_enabled(),
 			"CPU(%3d) VHE supported and enabled", cpu);
+
+	disable_vhe();
+	report(current_level() == CurrentEL_EL2 && vhe_supported() && !vhe_enabled(),
+			"CPU(%3d) VHE disable", cpu);
+
+	enable_vhe();
+	report(current_level() == CurrentEL_EL2 && vhe_supported() && vhe_enabled(),
+			"CPU(%3d) VHE re-enable", cpu);
 }
 
 static bool psci_check(void);
-- 
2.7.4

