Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4150417E16
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 18:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbfEHQ3J convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 8 May 2019 12:29:09 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:40100 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727150AbfEHQ3J (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 May 2019 12:29:09 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 9B7C328A09
        for <kvm@vger.kernel.org>; Wed,  8 May 2019 16:29:08 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 8FF8E284F9; Wed,  8 May 2019 16:29:08 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
        pdx-wl-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=2.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS autolearn=unavailable version=3.3.1
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 203543] Starting with kernel 5.1.0-rc6,  kvm_intel can no
 longer be loaded in nested kvm/guests
Date:   Wed, 08 May 2019 16:29:07 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: sean.j.christopherson@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-203543-28872-Kwk0Oe7lCj@https.bugzilla.kernel.org/>
In-Reply-To: <bug-203543-28872@https.bugzilla.kernel.org/>
References: <bug-203543-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=203543

--- Comment #7 from Sean Christopherson (sean.j.christopherson@intel.com) ---
On Wed, May 08, 2019 at 07:00:54PM +0300, Liran Alon wrote:
> +Paolo
> 
> What are your thoughts on this?  What is the reason that KVM relies on
> CPU_BASED_RDPMC_EXITING to be exposed from underlying CPU? How is it critical
> for it’s functionality?  If it’s because we want to make sure that we hide
> host PMCs, we should condition this to be a min requirement of kvm_intel only
> in case underlying CPU exposes PMU to begin with.  Do you agree? If yes, I
> can create the patch to fix this.

I sent a revert of the change to hide CPU_BASED_RDPMC_EXITING, KVM's
previous behavior is correct.  The RDPMC instruction was introduced long
before Architctural Perf Mon and so the existence of the exiting control
is dependent only on the instruction, e.g. P4 (Prescott), Core (Yonah)
and Core2 (Merom) all support VMX and RDPMC with non-archictectural
perf mon capabilities.

The KVM unit test first execute RDPMC with interception disabled in the
unit test host, i.e. the #GP is the correct architectural behavior and
needs to be handled by the unit test.  The most robust fix would be to
eat any #GP on RDPMC in the unit test, though it's likely much simpler
to only execute RDPMC with interception disabled if arch perf mon is
supported.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
