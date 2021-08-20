Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA0F3F3231
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 19:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232738AbhHTR0F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 13:26:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:55502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232585AbhHTR0E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 13:26:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7702D61157
        for <kvm@vger.kernel.org>; Fri, 20 Aug 2021 17:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629480326;
        bh=HMiNn4FxpVvGW+XUjLcjnIib8sYIGSF0TPfEOqe6jqQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=mdKZ+ypVsT4uksRv/gEYx93tNv872+a6QplQfa++oNzctaZ6NuhMgaefTkIqga1aw
         6lAuk3F0Br01jwQL5ojVgRqKtpKsPCpYX8b0554qpHdCf5nnZVIGJnyuMruCoXVcm2
         nSOrlHChHOa0a0vh92b0Hlyxg3ABlM5bUB5CLoxnuG7RgX0KUBfD0oAlKtIRdf1Vob
         0ZyDS28N/QjpLY+Zlip1CB8BGLCEZKJx88u+BZDd94lf2sdjwru/jJIs0tl0MI6xJd
         PaqJBX5a+B5BksBp1hInoOwBh++IUgCQvR+eij6On8mOHlSgINK92F6xCDttZczPFa
         ysLW5KkM8hiAQ==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 6A66660F36; Fri, 20 Aug 2021 17:25:26 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 199727] CPU freezes in KVM guests during high IO load on host
Date:   Fri, 20 Aug 2021 17:25:26 +0000
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
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-199727-28872-kDDzZg5AZW@https.bugzilla.kernel.org/>
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

Roland Kletzing (devzero@web.de) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |devzero@web.de

--- Comment #1 from Roland Kletzing (devzero@web.de) ---
i can confirm there is a severe issue here, which renders kvm/proxmox virtu=
ally
unusable when you have significantly io loaded hosts, i.e. if there is lots=
 of
write io on the host or guest.

whenever you get into a situation when the disk io where the vm resides on =
is
getting saturated, the VMs start going nuts and getting hiccup, i.e. severe
latency is getting added to the guests.=20

they behave "jumpy", you can't use the console or they are totaly sluggish,
ping goes up above 10secs , kernel throws "BUG: soft lockup - CPU#X stuck f=
or
XXs!" and such...

i have found that with cache=3Dwriteback for the virtual machines disk which
reside on the appropriate hdd wich heavy io, things go much much more smoot=
hly.=20

without cache=3Dwriteback , live migration/move could make a guest go crazy.

now with cache=3Dwriteback i could do 3 live migrations in parallel , even =
with
lots of io inside the virtual machines, and even with additional writer/rea=
der
in the host os (dd from/to the disk - ping to the guests mostly is <5ms.

so, to me this problem appears to be related to disk io saturation and prob=
ably
related to sync writes, what else can explain that cache=3Dwriteback helps =
so
much ?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
