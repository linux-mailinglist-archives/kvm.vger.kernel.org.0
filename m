Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6E8D6EBBF
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2019 22:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbfGSUql convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 19 Jul 2019 16:46:41 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:45378 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728148AbfGSUql (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Jul 2019 16:46:41 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 6D502289A1
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2019 20:46:40 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 61D45289BA; Fri, 19 Jul 2019 20:46:40 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
        pdx-wl-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=2.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS autolearn=unavailable version=3.3.1
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 204209] kernel 5.2.1: "floating point exception" in qemu with
 kvm enabled
Date:   Fri, 19 Jul 2019 20:46:38 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: antdev66@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-204209-28872-MIBnXnwk9l@https.bugzilla.kernel.org/>
In-Reply-To: <bug-204209-28872@https.bugzilla.kernel.org/>
References: <bug-204209-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=204209

--- Comment #2 from anthony (antdev66@gmail.com) ---
I tested the patch indicated on https://lkml.org/lkml/2019/7/19/644 with simple
row position adjustments for the kernel 5.2.1 and it seems to work.


--- a/arch/x86/kvm/x86.c    2019-07-19 20:17:35.358848175 +0200
+++ b/arch/x86/kvm/x86.c    2019-07-19 20:17:17.956692942 +0200
@@ -3264,6 +3264,12 @@

    kvm_x86_ops->vcpu_load(vcpu, cpu);

+
+   // fix floating point error kvm guest
+   if (test_thread_flag(TIF_NEED_FPU_LOAD))
+       switch_fpu_return();
+
+
    /* Apply any externally detected TSC adjustments (due to suspend) */
    if (unlikely(vcpu->arch.tsc_offset_adjustment)) {
        adjust_tsc_offset_host(vcpu, vcpu->arch.tsc_offset_adjustment);
@@ -7955,9 +7961,11 @@
        wait_lapic_expire(vcpu);
    guest_enter_irqoff();

-   fpregs_assert_state_consistent();
-   if (test_thread_flag(TIF_NEED_FPU_LOAD))
-       switch_fpu_return();
+// fix floating point error kvm guest
+//
+//     fpregs_assert_state_consistent();
+//     if (test_thread_flag(TIF_NEED_FPU_LOAD))
+//         switch_fpu_return();

    if (unlikely(vcpu->arch.switch_db_regs)) {
        set_debugreg(0, 7);

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
