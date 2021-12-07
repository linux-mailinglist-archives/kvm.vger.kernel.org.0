Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 688B546BFB9
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 16:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238352AbhLGPuZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 10:50:25 -0500
Received: from foss.arm.com ([217.140.110.172]:35210 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231955AbhLGPuZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 10:50:25 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 29BF911D4;
        Tue,  7 Dec 2021 07:46:54 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 679B53F5A1;
        Tue,  7 Dec 2021 07:46:53 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH 0/4] arm: Timer fixes
Date:   Tue,  7 Dec 2021 15:46:37 +0000
Message-Id: <20211207154641.87740-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series intends to fix two bugs in the timer test. The first one is the
TVAL comparison to check that the timer has expired and was found by code
inspection.

The second one I found while playing with KVM, but it can manifest itself
on certain hardware configuration with an unmodified version of KVM
(details in the commit message for the last patch). Or on baremetal (not
tested). In short, WFI can complete for a variety of reason, not just
because an interrupt targetted at the VM was asserted. The fix I
implemented was to do WFI in a loop until we get the interrupt or TVAL
shows that the timer has expired.

All the patches in between are an attempt make the tests more robust and
slightly easier to understand. If these changes are considered unnecessary,
I would be more than happy to drop them; the main goal of the series is to
fix the two bugs.

Tested on a rockpro64 with KVM modifed to clear HCR_EL2.TWI, which means
that the WFI instruction is not trapped (WFI trapping is a performance
optimization, not a correctness requirement):

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index f4871e47b2d0..9af13e01ffeb 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -96,18 +96,12 @@ static inline unsigned long *vcpu_hcr(struct kvm_vcpu *vcpu)
 
 static inline void vcpu_clear_wfx_traps(struct kvm_vcpu *vcpu)
 {
-       vcpu->arch.hcr_el2 &= ~HCR_TWE;
-       if (atomic_read(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vlpi_count) ||
-           vcpu->kvm->arch.vgic.nassgireq)
-               vcpu->arch.hcr_el2 &= ~HCR_TWI;
-       else
-               vcpu->arch.hcr_el2 |= HCR_TWI;
+       vcpu->arch.hcr_el2 &= ~(HCR_TWE | HCR_TWI);
 }
 
 static inline void vcpu_set_wfx_traps(struct kvm_vcpu *vcpu)
 {
-       vcpu->arch.hcr_el2 |= HCR_TWE;
-       vcpu->arch.hcr_el2 |= HCR_TWI;
+       vcpu->arch.hcr_el2 &= ~(HCR_TWE | HCR_TWI);
 }
 
 static inline void vcpu_ptrauth_enable(struct kvm_vcpu *vcpu)

Log when running ./run_test.sh timer (truncated for brevity) without the
fixes:

...
INFO: vtimer-busy-loop: waiting for interrupt...
FAIL: vtimer-busy-loop: interrupt received after TVAL/WFI
FAIL: vtimer-busy-loop: timer has expired
INFO: vtimer-busy-loop: TVAL is 144646 ticks
...
INFO: ptimer-busy-loop: waiting for interrupt...
FAIL: ptimer-busy-loop: interrupt received after TVAL/WFI
FAIL: ptimer-busy-loop: timer has expired
INFO: ptimer-busy-loop: TVAL is 50384 ticks
SUMMARY: 18 tests, 4 unexpected failures

Log when running the same command with the series applied:

...
INFO: vtimer-busy-loop: waiting for interrupt...
INFO: vtimer-busy-loop: waiting for interrupt...
INFO: vtimer-busy-loop: waiting for interrupt...
PASS: vtimer-busy-loop: interrupt received after TVAL/WFI
PASS: vtimer-busy-loop: timer has expired
INFO: vtimer-busy-loop: TVAL is -56982 ticks
...
INFO: ptimer-busy-loop: waiting for interrupt...
INFO: ptimer-busy-loop: waiting for interrupt...
PASS: ptimer-busy-loop: interrupt received after TVAL/WFI
PASS: ptimer-busy-loop: timer has expired
INFO: ptimer-busy-loop: TVAL is -22997 ticks
SUMMARY: 18 tests


Alexandru Elisei (4):
  arm: timer: Fix TVAL comparison for timer condition met
  arm: timer: Move the different tests into their own functions
  arm: timer: Test CVAL before interrupt pending state
  arm: timer: Take into account other wake-up events for the TVAL test

 arm/timer.c | 81 +++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 66 insertions(+), 15 deletions(-)

-- 
2.34.1

