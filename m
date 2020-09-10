Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4626A2645CF
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 14:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgIJMO1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 10 Sep 2020 08:14:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:44092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730450AbgIJMNm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 08:13:42 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 209155] KVM Linux guest with more than 1 CPU panics after
 commit 404d5d7bff0d419fe11c7eaebca9ec8f25258f95 on old CPU (Phenom x4)
Date:   Thu, 10 Sep 2020 12:12:58 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: kronenpj@kronenpj.dyndns.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-209155-28872-vK91HaShfP@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209155-28872@https.bugzilla.kernel.org/>
References: <bug-209155-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209155

--- Comment #14 from Paul K. (kronenpj@kronenpj.dyndns.org) ---
I'm having a bit of a problem applying the patches cleanly. Working with both
v5.9-rc3 and 5.9-rc4 give the same:

Patch 1/3 goes fine:
$ patch -p1 < /net/phenom/export/home2/users/kronenpj/tmp/patch1-3.txt 
patching file arch/x86/kvm/svm/svm.c

Patch 2/3 fails on hunk #3:
$ patch -p1 < /net/phenom/export/home2/users/kronenpj/tmp/patch2-3.txt 
patching file arch/x86/kvm/svm/svm.c
Hunk #1 succeeded at 3349 (offset 2 lines).
Hunk #2 succeeded at 3504 (offset 4 lines).
Hunk #3 FAILED at 3533.
1 out of 3 hunks FAILED -- saving rejects to file arch/x86/kvm/svm/svm.c.rej

$ cat svm.c.rej 
--- arch/x86/kvm/svm/svm.c
+++ arch/x86/kvm/svm/svm.c
@@ -3533,6 +3537,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu
*vcpu)
                svm_handle_mce(svm);

        svm_complete_interrupts(svm);
+       exit_fastpath = svm_exit_handlers_fastpath(vcpu);

        vmcb_mark_all_clean(svm->vmcb);
        return exit_fastpath;

Adding that line manually and continuing with the third patch:
$ patch -p1 < /net/phenom/export/home2/users/kronenpj/tmp/patch3-3.txt 
patching file arch/x86/kvm/svm/svm.c
Hunk #2 succeeded at 3536 with fuzz 2 (offset 8 lines).

The patch against v5.9-rc4+ works as expected.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
