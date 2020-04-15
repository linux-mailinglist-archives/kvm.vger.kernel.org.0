Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 475651A9054
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 03:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392483AbgDOBTh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 14 Apr 2020 21:19:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:52684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392480AbgDOBTd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 21:19:33 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: =?UTF-8?B?W0J1ZyAyMDcxNzNdIGt2bSBjb21waWxpbmcgcHJvYmxlbSA1LjYu?=
 =?UTF-8?B?eCBrdm1fbWFpbi5jOjIyMzY6NDI6IGVycm9yOiDigJhucl9wYWdlc19hdmFp?=
 =?UTF-8?B?bOKAmSBtYXkgYmUgdXNlZCB1bmluaXRpYWxpemVkIGluIHRoaXMgZnVuY3Rp?=
 =?UTF-8?B?b24=?=
Date:   Wed, 15 Apr 2020 01:19:32 +0000
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
Message-ID: <bug-207173-28872-woP3VumN91@https.bugzilla.kernel.org/>
In-Reply-To: <bug-207173-28872@https.bugzilla.kernel.org/>
References: <bug-207173-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=207173

--- Comment #6 from Sean Christopherson (sean.j.christopherson@intel.com) ---
Ah, fun.  So this falls into the "not technically a kernel problem" category. 
O3 isn't supported outside of the ARC architecture (no clue why it "needs" O3),
and AFAICT, has never been a selectable Kconfig option outside of ARC.

The false positives with -Wmaybe-uninitialized and -O3 (and -Os) is a known
issue, e.g. the kernel adds -Wno-maybe-uninitialized when compiling with either
of those options.  Unfortunately, there is no direct way to force
CONFIG_CC_DISABLE_WARN_MAYBE_UNINITIALIZED=y.  You could select
CONFIG_CC_OPTIMIZE_FOR_SIZE and then edit your Makefile, but I think that might
have unwanted side effects.

The easiest way to workaround this issue is to do CONFIG_KVM_WERROR=n.  The
false positive warning will still occur, but it won't get escalated to an error
and break your build.  I'm guessing there's a way to get
-Wno-maybe-uninitialized, but disabling -Werror for KVM is easy and doesn't
really have downsides.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
