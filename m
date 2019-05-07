Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE4816DD2
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 01:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbfEGX3m convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 7 May 2019 19:29:42 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:49142 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726091AbfEGX3l (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 May 2019 19:29:41 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 26D892896A
        for <kvm@vger.kernel.org>; Tue,  7 May 2019 23:29:41 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 19CEF28927; Tue,  7 May 2019 23:29:41 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
        pdx-wl-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=2.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS autolearn=unavailable version=3.3.1
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 203543] Starting with kernel 5.1.0-rc6,  kvm_intel can no
 longer be loaded in nested kvm/guests
Date:   Tue, 07 May 2019 23:29:40 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: liran.alon@oracle.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-203543-28872-cDEgoWAWBm@https.bugzilla.kernel.org/>
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

Liran Alon (liran.alon@oracle.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |liran.alon@oracle.com

--- Comment #1 from Liran Alon (liran.alon@oracle.com) ---
If I would have to guess, I would blame my own commit:
e51bfdb68725 ("KVM: nVMX: Expose RDPMC-exiting only when guest supports PMU”)

As in kvm_intel’s setup_vmcs_config() it can be seen that
CPU_BASED_RDPMC_EXITING is required in order for KVM to load.
Therefore, I assume the issue is that now L1 guest is not exposed with
CPU_BASED_RDPMC_EXITING.

My patch is suppose to hide CPU_BASED_RDPMC_EXITING from L1 only in case L1
vCPU is not exposed with PMU.

Can you provide more details on the vCPU your setup expose to L1?
Have you explicitly disabled PMU from L1 vCPU?
Can you run “cpuid -r” on shell and post here it’s output?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
