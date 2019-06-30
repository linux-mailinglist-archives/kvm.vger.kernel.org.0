Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B43DC5B251
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2019 01:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbfF3XRs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 30 Jun 2019 19:17:48 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:45380 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727175AbfF3XRr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 30 Jun 2019 19:17:47 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 3C69D284FC
        for <kvm@vger.kernel.org>; Sun, 30 Jun 2019 23:17:47 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 2EB64284DA; Sun, 30 Jun 2019 23:17:47 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
        pdx-wl-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=2.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS autolearn=unavailable version=3.3.1
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 203979] kvm_spurious_fault in L1 when running a nested kvm
 instance on AMD i686-pae
Date:   Sun, 30 Jun 2019 23:17:46 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jpalecek@web.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-203979-28872-2NOYIB52Yo@https.bugzilla.kernel.org/>
In-Reply-To: <bug-203979-28872@https.bugzilla.kernel.org/>
References: <bug-203979-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=203979

--- Comment #2 from Jiri Palecek (jpalecek@web.de) ---
Created attachment 283501
  --> https://bugzilla.kernel.org/attachment.cgi?id=283501&action=edit
Patch that allows me to run nested kvm instances again

After much looking on the offending commit, which doesn't seem to change any
functionality, but just changes the API, I found out the gfns used inside
__kvm_map_gfn were in fact far off. Further looking into it I found that these
gfns were the result of gfn_to_gpa in some (but not all) places that used the
new api. However, what was clearly meant was gpa_to_gfn. So I prepared this
patch and tested that it allows to run nested linux instances in kvm
successfully on my AMD system.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
