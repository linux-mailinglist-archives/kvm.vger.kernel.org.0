Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7814B4F8BB
	for <lists+kvm@lfdr.de>; Sun, 23 Jun 2019 00:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbfFVWtV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sat, 22 Jun 2019 18:49:21 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:33952 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726338AbfFVWtV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 22 Jun 2019 18:49:21 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 3A09C28B7A
        for <kvm@vger.kernel.org>; Sat, 22 Jun 2019 22:49:20 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id 2E85328B90; Sat, 22 Jun 2019 22:49:20 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
        pdx-wl-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=2.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS autolearn=unavailable version=3.3.1
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 203923] Running a nested freedos on AMD Athlon i686-pae results
 in NULL pointer dereference in L0 (kvm_mmu_load)
Date:   Sat, 22 Jun 2019 22:49:19 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jpalecek@web.de
X-Bugzilla-Status: REOPENED
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-203923-28872-edfITTzMT5@https.bugzilla.kernel.org/>
In-Reply-To: <bug-203923-28872@https.bugzilla.kernel.org/>
References: <bug-203923-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=203923

--- Comment #7 from Jiri Palecek (jpalecek@web.de) ---
Created attachment 283393
  --> https://bugzilla.kernel.org/attachment.cgi?id=283393&action=edit
Patch that fixes this problem on my system

So, I had a look around the code and found that SVM initialized the nested
vcpus in such a way that ->arch.mmu points to ->arch.guest_mmu. The code in
mmu.c then uses ->arch.mmu->pae_root which crashes.

This patch really takes the path of the least resistance. If they want to have
pae_root allocated even for guest_mmu, let them have it and just allocate it.
Maybe if this is specific to AMD the whole business should be in svm.c though?
Or do it lazily only when actually doing the nesting?

The patch fixes 5.1 kernel on my machine, kvm guest start and the nested guest
start as well. However, in 5.2 there will probably be more problems ahead
because I got a different error there (kvm_spurious_fault in L1).

What are your thoughts on this?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
