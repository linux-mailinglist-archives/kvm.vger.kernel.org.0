Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAEDA29AC7D
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 13:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751535AbgJ0Mvx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 27 Oct 2020 08:51:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:47652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751529AbgJ0Mvv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 08:51:51 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 209253] Loss of connectivity on guest after important host <->
 guest traffic
Date:   Tue, 27 Oct 2020 12:51:50 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: arequipeno@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-209253-28872-FgwvMiD1IG@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209253-28872@https.bugzilla.kernel.org/>
References: <bug-209253-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209253

--- Comment #10 from Ian Pilcher (arequipeno@gmail.com) ---
(In reply to Alex Williamson from comment #7)
> Color me suspicious, but there are backtraces from two configurations in the
> comments here that have no vfio devices, the original post and Justin's
> second trace.  The identified commit can only affect vfio configurations.
> 
> All of the backtraces seem to be from triggering this warning:
> 
> __u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
> {
>         unsigned long flags;
> 
>         /*
>          * Deadlock or stack overflow issues can happen if we recurse here
>          * through waitqueue wakeup handlers. If the caller users potentially
>          * nested waitqueues with custom wakeup handlers, then it should
>          * check eventfd_signal_count() before calling this function. If
>          * it returns true, the eventfd_signal() call should be deferred to a
>          * safe context.
>          */
>         if (WARN_ON_ONCE(this_cpu_read(eventfd_wake_count)))
>                 return 0;

It's quite possible that some of the backtraces in this bug have different root
cause(s).  That doesn't change the fact that commit
c49fa6397b6d29ce10c0ae5b2528bb004a14691f does reliably trigger the WARNING for
some of us.

> It's not obvious to me how the backtraces shown can lead to recursive
> eventfd signals.  I've setup a configuration for stress testing, but any
> detailed description of a reliable reproducer would be appreciated.

Is the VM XML and other information sufficient for you to reproduce?  (If not,
I can set up access to my hypervisor.)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
