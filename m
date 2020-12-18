Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 948952DDD2F
	for <lists+kvm@lfdr.de>; Fri, 18 Dec 2020 04:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbgLRDKr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 17 Dec 2020 22:10:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:41306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726951AbgLRDKr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Dec 2020 22:10:47 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 210695] error: kvm run failed Invalid argument
Date:   Fri, 18 Dec 2020 03:10:06 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: rherbert@sympatico.ca
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-210695-28872-QofEkBtmYs@https.bugzilla.kernel.org/>
In-Reply-To: <bug-210695-28872@https.bugzilla.kernel.org/>
References: <bug-210695-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=210695

Richard Herbert (rherbert@sympatico.ca) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--- Comment #8 from Richard Herbert (rherbert@sympatico.ca) ---
Get the so called "root" level from the low level shadow page table
walkers instead of manually attempting to calculate it higher up the
stack, e.g. in get_mmio_spte().  When KVM is using PAE shadow paging,
the starting level of the walk, from the callers perspective, is not
the CR3 root but rather the PDPTR "root".  Checking for reserved bits
from the CR3 root causes get_mmio_spte() to consume uninitialized stack
data due to indexing into sptes[] for a level that was not filled by
get_walk().  This can result in false positives and/or negatives
depending on what garbage happens to be on the stack.

Opportunistically nuke a few extra newlines.

Fixes: 95fb5b0258b7 ("kvm: x86/mmu: Support MMIO in the TDP MMU")

Signed-off-by: Sean Christopherson <seanjc@google.com>

Marking as RESOLVED, with Thanks.

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.
