Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 436CC296727
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 00:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S372781AbgJVW0e convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 22 Oct 2020 18:26:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:51666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S372778AbgJVW0d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Oct 2020 18:26:33 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 209253] Loss of connectivity on guest after important host <->
 guest traffic
Date:   Thu, 22 Oct 2020 22:26:32 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: arequipeno@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-209253-28872-Pp1pYjHhVO@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209253-28872@https.bugzilla.kernel.org/>
References: <bug-209253-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209253

--- Comment #5 from Ian Pilcher (arequipeno@gmail.com) ---
Based on my git bisect, it looks like this commit is triggering the WARNING.

commit c49fa6397b6d29ce10c0ae5b2528bb004a14691f
Author: Alex Williamson <alex.williamson@redhat.com>
Date:   Mon Aug 17 11:08:18 2020 -0600

    vfio-pci: Avoid recursive read-lock usage

    [ Upstream commit bc93b9ae0151ae5ad5b8504cdc598428ea99570b ]

    A down_read on memory_lock is held when performing read/write accesses
    to MMIO BAR space, including across the copy_to/from_user() callouts
    which may fault.  If the user buffer for these copies resides in an
    mmap of device MMIO space, the mmap fault handler will acquire a
    recursive read-lock on memory_lock.  Avoid this by reducing the lock
    granularity.  Sequential accesses requiring multiple ioread/iowrite
    cycles are expected to be rare, therefore typical accesses should not
    see additional overhead.

    VGA MMIO accesses are expected to be non-fatal regardless of the PCI
    memory enable bit to allow legacy probing, this behavior remains with
    a comment added.  ioeventfds are now included in memory access testing,
    with writes dropped while memory space is disabled.

    Fixes: abafbc551fdd ("vfio-pci: Invalidate mmaps and block MMIO access on
disabled memory")
    Reported-by: Zhiyi Guo <zhguo@redhat.com>
    Tested-by: Zhiyi Guo <zhguo@redhat.com>
    Reviewed-by: Cornelia Huck <cohuck@redhat.com>
    Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

 drivers/vfio/pci/vfio_pci_private.h |   2 +
 drivers/vfio/pci/vfio_pci_rdwr.c    | 120 ++++++++++++++++++++++++++++--------
 2 files changed, 98 insertions(+), 24 deletions(-)

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=bc93b9ae0151ae5ad5b8504cdc598428ea99570b

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
