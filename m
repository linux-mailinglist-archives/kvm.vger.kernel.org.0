Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE0F22DD98D
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 20:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728684AbgLQTy4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 17 Dec 2020 14:54:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:55886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727368AbgLQTy4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Dec 2020 14:54:56 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 210695] error: kvm run failed Invalid argument
Date:   Thu, 17 Dec 2020 19:54:15 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: seanjc@google.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-210695-28872-ZDrKfe6vd4@https.bugzilla.kernel.org/>
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

--- Comment #7 from Sean Christopherson (seanjc@google.com) ---
Finally figured it out.  When KVM uses PAE shadow paging, the PDPTRs are
effectively skipped when walking the shadow tables because a bad PDPTR will be
detected much earlier and KVM essentially hardcodes the PDPTRs.  As a result,
the corresponding SPTE isn't filled by get_walk() as it never "sees" the SPTE
for the PDTPR.  The refactored get_mmio_spte() doesn't account for this and
checks the PDPTR SPTE array value.  This reads uninitialized stack data, and in
your case, this yields the garbage value '0x80000b0e' that causes things to
explode (my system gets '0' most/all of the time).

I'll get a patch out later today, it's a bit of a mess....

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
