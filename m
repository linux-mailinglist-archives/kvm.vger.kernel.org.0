Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2BC62DB8BB
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 03:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725308AbgLPCEJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 15 Dec 2020 21:04:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:39486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725208AbgLPCEJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 21:04:09 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 210695] error: kvm run failed Invalid argument
Date:   Wed, 16 Dec 2020 02:03:28 +0000
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
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-210695-28872-vQTu33nCVK@https.bugzilla.kernel.org/>
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

Sean Christopherson (seanjc@google.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |seanjc@google.com

--- Comment #1 from Sean Christopherson (seanjc@google.com) ---
Hrm, this is more than likely related to refactoring for the introduction of
the TDP MMU.

> kernel get_mmio_spte: detect reserved bits on spte, addr 0xfe013000, dump
> hierarchy:
> kernel        ------ spte 0x80000b0e level 3.

This SPTE looks odd/wrong, but unless I'm misreading things, there are no
reserved bits set.

> kernel        ------ spte 0x49c0027 level 2.
> kernel        ------ spte 0x38001ffe0134d7 level 1.

And this SPTE obviously has reserved bits set, but that's intentional and this
should not trigger the warning as the SPTE should be recognized as an MMIO
SPTE.

I'll stare at this more tomorrow and play with things a bit to see if I can
figure out what's broken.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
