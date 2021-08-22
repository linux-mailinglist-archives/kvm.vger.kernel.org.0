Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E182E3F3F37
	for <lists+kvm@lfdr.de>; Sun, 22 Aug 2021 14:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbhHVMMP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Aug 2021 08:12:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:51860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229961AbhHVMML (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Aug 2021 08:12:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 63ECC61354
        for <kvm@vger.kernel.org>; Sun, 22 Aug 2021 12:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629634290;
        bh=/UsrHwTZxwhF1qFbCYtV6D1yNL4w88tq4OpRQLqioHs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=BH/qzpeY0KWJLuH+Hi29rAsL7WNzg/BoiT2jtMxb5+w2nkV/MAx/IFQGxzqcXlYDF
         aKHJP+9kIfaG3ebXJymRtJUeLedGiTyqPEKxA10cdIxoqiNRZzZcOFt8osFhYGIRlC
         A/BrKomhhMoOfP/p83a792SVkH8Tau2MdNSaNybja+HOl4Vp7yc1+nJm8bCqj8+U/c
         me5OxoVorzipx66fi17S6CxpkFQF3lFlWHeBW9U+Q/nJAvzAMaRu7p1QTvfjHHZ4pl
         Ub6Q3XSJ9eLxG0UkLNyp+iY62YdRuK/M5tW3O+iU77vph2AIDBC4eAk+glda++PHai
         Y2eg2kS4apArw==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 59D5F60F4D; Sun, 22 Aug 2021 12:11:30 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 199727] CPU freezes in KVM guests during high IO load on host
Date:   Sun, 22 Aug 2021 12:11:30 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: devzero@web.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-199727-28872-0XofQ63Wzh@https.bugzilla.kernel.org/>
In-Reply-To: <bug-199727-28872@https.bugzilla.kernel.org/>
References: <bug-199727-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D199727

--- Comment #4 from Roland Kletzing (devzero@web.de) ---
http://blog.vmsplice.net/2015/08/asynchronous-file-io-on-linux-plus-ca.html

"However, the io_submit(2) system call remains a treacherous ally in the qu=
est
for asynchronous file I/O. I don't think much has changed since 2009 in mak=
ing
Linux AIO the best asynchronous file I/O mechanism.

The main problem is that io_submit(2) waits for I/O in some cases. It can
block! This defeats the purpose of asynchronous file I/O because the caller=
 is
stuck until the system call completes. If called from a program's event loo=
p,
the program becomes unresponsive until the system call returns. But even if
io_submit(2) is invoked from a dedicated thread where blocking doesn't matt=
er,
latency is introduced to any further I/O requests submitted in the same
io_submit(2) call.

Sources of blocking in io_submit(2) depend on the file system and block dev=
ices
being used. There are many different cases but in general they occur because
file I/O code paths contain synchronous I/O (for metadata I/O or page cache
write-out) as well as locks/waiting (for serializing operations). This is w=
hy
the io_submit(2) system call can be held up while submitting a request.

This means io_submit(2) works best on fully-allocated files, volumes, or bl=
ock
devices. Anything else is likely to result in blocking behavior and cause p=
oor
performance."

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
