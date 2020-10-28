Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B982029D484
	for <lists+kvm@lfdr.de>; Wed, 28 Oct 2020 22:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728324AbgJ1VwZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 28 Oct 2020 17:52:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:45024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728307AbgJ1VwX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Oct 2020 17:52:23 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     kvm@vger.kernel.org
Subject: [Bug 209253] Loss of connectivity on guest after important host <->
 guest traffic
Date:   Wed, 28 Oct 2020 20:35:22 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: alex.williamson@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-209253-28872-Epfs0DEd1f@https.bugzilla.kernel.org/>
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

--- Comment #12 from Alex Williamson (alex.williamson@redhat.com) ---
Created attachment 293281
  --> https://bugzilla.kernel.org/attachment.cgi?id=293281&action=edit
Test fix for ioeventfd_write traces

For those experiencing the issue described by Ian in comment 1 and the first
issue from Martin in comment 2, please try this patch if you're able. 
vfio_pci_ioeventfd_handler() is called in a spinlock context with interrupts
disabled and tries to acquire a read lock on the memory semaphore to verify the
device memory is enabled.  The down_read() call can sleep and therefore should
instead be called from a thread context if there is contention.  TBH, I've
never seen it contended, so in practice the thread is never really used, but
this seems to solve the specific case Ian has identified and it would have been
introduced by the commit noted in comment 5.

This change should be specific to configurations with NVIDIA GPUs assigned. 
I'm curious about the traces with vfio_msihandler as well, if anyone can
provide a reproducer of that it would be appreciated.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
