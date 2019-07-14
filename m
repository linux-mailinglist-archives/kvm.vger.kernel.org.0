Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4858B68098
	for <lists+kvm@lfdr.de>; Sun, 14 Jul 2019 20:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbfGNSJt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 14 Jul 2019 14:09:49 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:39150 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728125AbfGNSJt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 14 Jul 2019 14:09:49 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 72A5727F7F
        for <kvm@vger.kernel.org>; Sun, 14 Jul 2019 18:09:48 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 5B86E280B0; Sun, 14 Jul 2019 18:09:48 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
        pdx-wl-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=2.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS autolearn=unavailable version=3.3.1
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 103141] Host-triggerable NULL pointer oops
Date:   Sun, 14 Jul 2019 18:09:47 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: alex@zadara.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-103141-28872-zi3T0EBmcx@https.bugzilla.kernel.org/>
In-Reply-To: <bug-103141-28872@https.bugzilla.kernel.org/>
References: <bug-103141-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=103141

Alex Lyakas (alex@zadara.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |alex@zadara.com

--- Comment #4 from Alex Lyakas (alex@zadara.com) ---
We hit the same issue with kernel 3.18.19.

After some debugging, I see that the first test program that felix attached,
causes kvm_x86_ops->vcpu_create to return -EEXIST instead of a valid vcpu
pointer. As a result, the call to kvm_x86_ops->fpu_activate tries to access an
invalid pointer, and causes a NULL pointer dereference.

The suggested fix was delivered in kernel 4.2. Although it was tagged as
"stable", I don't see that it was backported to earlier kernels. I believe that
the fix addresses a different issue, in which the vcpu pointer is valid, but
further VMCS write has a problem (this is my understanding). But, of course,
this fix will address also the issue that felix reported. Although for the
latter, a simpler fix would suffice:

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7012,20 +7012,24 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
                                                unsigned int id)
 {
        struct kvm_vcpu *vcpu;

        if (check_tsc_unstable() && atomic_read(&kvm->online_vcpus) != 0)
                printk_once(KERN_WARNING
                "kvm: SMP vm created on host with unstable TSC; "
                "guest TSC will not be reliable\n");

        vcpu = kvm_x86_ops->vcpu_create(kvm, id);
+       if (IS_ERR(vcpu)) {
+               pr_err("kvm_x86_ops->vcpu_create id=%u err=%ld\n", id,
PTR_ERR(vcpu));
+               return vcpu;
+       }

        /*
         * Activate fpu unconditionally in case the guest needs eager FPU.  It
will be
         * deactivated soon if it doesn't.
         */
        kvm_x86_ops->fpu_activate(vcpu);
        return vcpu;
 }

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
