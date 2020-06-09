Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591EC1F3B46
	for <lists+kvm@lfdr.de>; Tue,  9 Jun 2020 15:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727945AbgFINAh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 9 Jun 2020 09:00:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:36590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726083AbgFINAh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jun 2020 09:00:37 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 208081] Memory leak in kvm_async_pf_task_wake
Date:   Tue, 09 Jun 2020 13:00:36 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bonzini@gnu.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-208081-28872-77yKXsjHqa@https.bugzilla.kernel.org/>
In-Reply-To: <bug-208081-28872@https.bugzilla.kernel.org/>
References: <bug-208081-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=208081

--- Comment #4 from Paolo Bonzini (bonzini@gnu.org) ---
That patch won't work, most APFs have a node that comes from the stack.  The
issue must be arising when you enter this branch of kvm_async_pf_task_wake:

                /*
                 * async PF was not yet handled.
                 * Add dummy entry for the token.
                 */
                n = kzalloc(sizeof(*n), GFP_ATOMIC);

but it should be handled here in kvm_async_pf_task_wait:

        if (e) {
                /* dummy entry exist -> wake up was delivered ahead of PF */
                hlist_del(&e->link);
                raw_spin_unlock(&b->lock);
                kfree(e);
                return false;
        }

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
