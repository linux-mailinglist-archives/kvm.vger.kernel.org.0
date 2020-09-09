Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F20EC26274B
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 08:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725917AbgIIGl0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 9 Sep 2020 02:41:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:44390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725826AbgIIGlV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Sep 2020 02:41:21 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 209079] CPU 0/KVM: page allocation failure on 5.8 kernel
Date:   Wed, 09 Sep 2020 06:41:20 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: sean.j.christopherson@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-209079-28872-gJV3XpdGDm@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209079-28872@https.bugzilla.kernel.org/>
References: <bug-209079-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209079

Sean Christopherson (sean.j.christopherson@intel.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sean.j.christopherson@intel
                   |                            |.com

--- Comment #2 from Sean Christopherson (sean.j.christopherson@intel.com) ---
Are you disabling NPT (via KVM module param)?  You're obviously running a
64-bit kernel, and presumably that CPU supports NPT, so the only way KVM should
reach the failing allocation is if NPT is being explicitly disabled.  There's
nothing wrong with using shadow paging, it's just uncommon these days.

NPT aside, the interesting part of the failing allocation is that it uses
GFP_DMA32.  I did a quick test to force that allocation on my system and
nothing exploded.  Odds are good the bug is outside of KVM, which means a
bisection is probably necessary.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
