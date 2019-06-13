Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 883BA43D69
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 17:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732844AbfFMPlu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 13 Jun 2019 11:41:50 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:45264 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731869AbfFMJtf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jun 2019 05:49:35 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id EF08128B68
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2019 09:49:34 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id D955E28B27; Thu, 13 Jun 2019 09:49:34 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on
        pdx-wl-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=2.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS autolearn=unavailable version=3.3.1
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 203845] Can't run qemu/kvm on 5.0.0 kernel (NULL pointer
 dereference)
Date:   Thu, 13 Jun 2019 09:49:33 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-203845-28872-I1NIDx6cjD@https.bugzilla.kernel.org/>
In-Reply-To: <bug-203845-28872@https.bugzilla.kernel.org/>
References: <bug-203845-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=203845

--- Comment #3 from Jiri Palecek (jpalecek@web.de) ---
So, after bisecting, the first bad commit is:

commit ee6268ba3a6861b2806e569bff7fe91fbdf846dd (refs/bisect/bad)
Author: Liang Chen <liangchen.linux@gmail.com>
Date:   Wed Jul 25 16:32:14 2018 +0800

    KVM: x86: Skip pae_root shadow allocation if tdp enabled

    Considering the fact that the pae_root shadow is not needed when
    tdp is in use, skip the pae_root shadow page allocation to allow
    mmu creation even not being able to obtain memory from DMA32
    zone when particular cgroup cpuset.mems or mempolicy control is
    applied.

    Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
    Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
