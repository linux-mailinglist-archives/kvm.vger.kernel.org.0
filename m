Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8836C1F10BE
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 02:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbgFHAqv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 7 Jun 2020 20:46:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728001AbgFHAqv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Jun 2020 20:46:51 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 208081] Memory leak in kvm_async_pf_task_wake
Date:   Mon, 08 Jun 2020 00:46:50 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: wanpeng.li@hotmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-208081-28872-82mfGYMepi@https.bugzilla.kernel.org/>
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

Wanpeng Li (wanpeng.li@hotmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |wanpeng.li@hotmail.com

--- Comment #2 from Wanpeng Li (wanpeng.li@hotmail.com) ---
Could you apply below to the guest kernel and have a try again?

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index d6f22a3..93d267e 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -156,6 +156,7 @@ static void apf_task_wake_one(struct kvm_task_sleep_node
*n)
        hlist_del_init(&n->link);
        if (swq_has_sleeper(&n->wq))
                swake_up_one(&n->wq);
+       kfree(n);
 }

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
