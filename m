Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4384176E4F
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 06:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725818AbgCCFEX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 3 Mar 2020 00:04:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:36770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbgCCFEX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 00:04:23 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 206579] KVM with passthrough generates "BUG: kernel NULL
 pointer dereference" and crashes
Date:   Tue, 03 Mar 2020 05:04:22 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: rmuncrief@humanavance.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-206579-28872-0jsFHG7KPr@https.bugzilla.kernel.org/>
In-Reply-To: <bug-206579-28872@https.bugzilla.kernel.org/>
References: <bug-206579-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=206579

--- Comment #45 from muncrief (rmuncrief@humanavance.com) ---
Well, I spent some time today trying to figure out why the
AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK is sometimes set when executing
"avic_vcpu_load". I thought it might be a concurrency issue with
"avic_physical_id_cache" so I put spinlocks around all access code but that
didn't change anything, and tried some other things but I regret to say I
failed.

First of all, I don't even know how "avic_vcpu_load" ends up being executed
without being called by any of the functions in "svm_x86_ops"
(svm_vcpu_blocking, svm_vcpu_unblocking, svm_vcpu_load). I did my best to
figure out how swait worked, but I must really be missing something, and not
understanding the call stack trace correctly.

In any case, the basic issue is that occasionally "avic_vcpu_load" is executed
when the AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK bit is 1, and it always expects
it to be 0. And this always seems to happen after a cpu is placed on the swait
wait queue in the "kvm_vcpu_block" function. It seems like somehow when it
resumes it's executing"avic_vcpu_load", and the
AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK bit is 1 instead of 0.

I'm sure this is just mass misunderstanding on my part. And by the way I'm
going through all of this because it's a good way for me to learn how real time
concurrent kernel code operates. I know it seems like a backwards way to learn,
but that's the only way I can.

However, despite my ignorance, the header in "swait.h" is concerning, and makes
me wonder if there's something wrong with swait itself. It even titles itself
"BROKEN wait-queues." Here's an excerpt from the header:

```
/*
 * BROKEN wait-queues.
 *
 * These "simple" wait-queues are broken garbage, and should never be
 * used. The comments below claim that they are "similar" to regular
 * wait-queues, but the semantics are actually completely different, and
 * every single user we have ever had has been buggy (or pointless).
 * ...
```

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
