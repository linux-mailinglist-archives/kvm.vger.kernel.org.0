Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B525251323
	for <lists+kvm@lfdr.de>; Tue, 25 Aug 2020 09:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729416AbgHYH02 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 25 Aug 2020 03:26:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729322AbgHYH02 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Aug 2020 03:26:28 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 209025] The "VFIO_MAP_DMA failed: Cannot allocate memory" bug
 is back
Date:   Tue, 25 Aug 2020 07:26:26 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: niklas@komani.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-209025-28872-zSYm1afPfK@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209025-28872@https.bugzilla.kernel.org/>
References: <bug-209025-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209025

Niklas Schnelle (niklas@komani.de) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |axboe@kernel.dk,
                   |                            |niklas@komani.de

--- Comment #5 from Niklas Schnelle (niklas@komani.de) ---
Hi,

it's me Niklas from the KVM mailinglist discussion and yes
this is a very old pre-IBM, pre any work, Bugzilla account :D

I too did a bisect yesterday and also
encountered a few commits that had KVM in a very weird state
where not even the UEFI in the VM would boot, funnily enough
a BIOS based FreeBSD VM did still boot.

Anyway my bisect was successful and reverting the found
commit makes things work even on v5.9-rc2.

That said it is quite a strange result but I guess it makes
sense as that also deals with locked/pinned memory.
I'm assuming this might use the same accounting mechanism?

f74441e6311a28f0ee89b9c8e296a33730f812fc is the first bad commit
commit f74441e6311a28f0ee89b9c8e296a33730f812fc
Author: Jens Axboe <axboe@kernel.dk>
Date:   Wed Aug 5 13:00:44 2020 -0600

    io_uring: account locked memory before potential error case

    The tear down path will always unaccount the memory, so ensure that we
    have accounted it before hitting any of them.

    Reported-by: Tomáš Chaloupka <chalucha@gmail.com>
    Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

 fs/io_uring.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

I've added Jens to the Bugzilla CC list not sure if he'll see
that though.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
