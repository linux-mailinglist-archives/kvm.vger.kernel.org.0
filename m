Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 991FF3F399B
	for <lists+kvm@lfdr.de>; Sat, 21 Aug 2021 10:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233147AbhHUIx5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 Aug 2021 04:53:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232802AbhHUIx5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 Aug 2021 04:53:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8ADB961186
        for <kvm@vger.kernel.org>; Sat, 21 Aug 2021 08:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629535997;
        bh=E6TZuGRlp5RRbuvkVF71XzqBtfChK8lwjsad0AHgHkU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=RN/MaR/EbDW7vJl0M61RnGTPOK3EccUL0yFAE1XcdIBpW6GvjaxWCDDdsZA8Dlvw8
         EMRQrAk/v8tjTXLGuT5l22lcrsfb+QpqJYg3s44D3DHAsDszCQqHnD9g2pQmTuLBzj
         VbauYmJCm9WMH/X9z+N+JoBNjhozopz74VLmZhdBOg+5nbjW/OMqIQ5f9nfnxucxv4
         KS37DyZ3AVoWVoBM0UpFbvIne4tqlk72s+clpZ5uILyx/YSerpYlChGikpH/pKuLG2
         El5MpR6rR0xHhJm8TgGm00gL6MIl2TgO9jWhArnA1oZx4Fdfk53Llq5w9o4pO85vUY
         oIHpt2WfbK/Uw==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 81A3860F6D; Sat, 21 Aug 2021 08:53:17 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 199727] CPU freezes in KVM guests during high IO load on host
Date:   Sat, 21 Aug 2021 08:53:17 +0000
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
Message-ID: <bug-199727-28872-4DPBhqZpKu@https.bugzilla.kernel.org/>
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

--- Comment #3 from Roland Kletzing (devzero@web.de) ---
i had a look at kvm process with strace.=20

with virtual disk caching option set to "Default (no cache)", kvm is doing =
IO
submission via io_submit() instead of pwritev(), and apparently that can be=
 a
long blocking call.

i see whenever the VM getting hickup and pingtime goes through the roof, th=
ere
is long blocking io_submit() operation in progress=20

looks like a "design issue" to me and "Default (no cache)" thus being a bad
default setting.

see:
https://lwn.net/Articles/508064/

and=20
https://stackoverflow.com/questions/34572559/asynchronous-io-io-submit-late=
ncy-in-ubuntu-linux

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
