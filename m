Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7D12D5E2F
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2019 11:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730684AbfJNJIb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 14 Oct 2019 05:08:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:36228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730655AbfJNJIa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 05:08:30 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 205171] kernel panic during windows 10pro start
Date:   Mon, 14 Oct 2019 09:08:29 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: vkuznets@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-205171-28872-YCF28yxjs3@https.bugzilla.kernel.org/>
In-Reply-To: <bug-205171-28872@https.bugzilla.kernel.org/>
References: <bug-205171-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=205171

--- Comment #2 from vkuznets@redhat.com ---
bugzilla-daemon@bugzilla.kernel.org writes:

> https://bugzilla.kernel.org/show_bug.cgi?id=205171
>
>             Bug ID: 205171
>            Summary: kernel panic during windows 10pro start
>            Product: Virtualization
>            Version: unspecified
>     Kernel Version: 4.19.74 and higher
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: kvm
>           Assignee: virtualization_kvm@kernel-bugs.osdl.org
>           Reporter: dront78@gmail.com
>         Regression: No
>
> works fine on 4.19.73
>
> [ 5829.948945] BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000000
> [ 5829.948951] PGD 0 P4D 0 
> [ 5829.948954] Oops: 0002 [#1] SMP NOPTI
> [ 5829.948957] CPU: 3 PID: 1699 Comm: CPU 0/KVM Tainted: G           OE    
> 4.19.78-2-lts #1
> [ 5829.948958] Hardware name: Micro-Star International Co., Ltd. GE62
> 6QF/MS-16J4, BIOS E16J4IMS.117 01/18/2018
> [ 5829.948989] RIP: 0010:kvm_write_guest_virt_system+0x1e/0x40 [kvm]

It seems 4.19 stable backport is broken, upstream commit f7eea636c3d50
has:

@@ -4588,7 +4589,8 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
                                vmx_instruction_info, true, len, &gva))
                        return 1;
                /* _system ok, nested_vmx_check_permission has verified cpl=0
*/
-               kvm_write_guest_virt_system(vcpu, gva, &field_value, len,
NULL);
+               if (kvm_write_guest_virt_system(vcpu, gva, &field_value, len,
&e))
+                       kvm_inject_page_fault(vcpu, &e);
        }

and it's 4.19 counterpart (73c31bd92039):

@@ -8798,8 +8799,10 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
                                vmx_instruction_info, true, &gva))
                        return 1;
                /* _system ok, nested_vmx_check_permission has verified cpl=0
*/
-               kvm_write_guest_virt_system(vcpu, gva, &field_value,
-                                           (is_long_mode(vcpu) ? 8 : 4),
NULL);
+               if (kvm_write_guest_virt_system(vcpu, gva, &field_value,
+                                               (is_long_mode(vcpu) ? 8 : 4),
+                                               NULL))
+                       kvm_inject_page_fault(vcpu, &e);
        }

(note the last argument to kvm_write_guest_virt_system() - it's NULL
instead of &e.

And v4.19.74 has 6e60900cfa3e (541ab2aeb282 upstream):

@@ -5016,6 +5016,13 @@ int kvm_write_guest_virt_system(struct kvm_vcpu *vcpu,
gva_t addr, void *val,
        /* kvm_write_guest_virt_system can pull in tons of pages. */
        vcpu->arch.l1tf_flush_l1d = true;

+       /*
+        * FIXME: this should call handle_emulation_failure if
X86EMUL_IO_NEEDED
+        * is returned, but our callers are not ready for that and they blindly
+        * call kvm_inject_page_fault.  Ensure that they at least do not leak
+        * uninitialized kernel stack memory into cr2 and error code.
+        */
+       memset(exception, 0, sizeof(*exception));
        return kvm_write_guest_virt_helper(addr, val, bytes, vcpu,
                                           PFERR_WRITE_MASK, exception);
 }

This all results in memset(NULL). (also, 6e60900cfa3e should come
*after* f7eea636c3d50 and not before but oh well..)

The following will likely fix the problem (untested):

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index e83f4f6bfdac..d3a900a4fa0e 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -8801,7 +8801,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
                /* _system ok, nested_vmx_check_permission has verified cpl=0
*/
                if (kvm_write_guest_virt_system(vcpu, gva, &field_value,
                                                (is_long_mode(vcpu) ? 8 : 4),
-                                               NULL))
+                                               &e))
                        kvm_inject_page_fault(vcpu, &e);
        }

I can send a patch to stable@ if needed.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
