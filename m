Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26B60308ED3
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 21:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233302AbhA2Uwr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jan 2021 15:52:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:44726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232917AbhA2UvK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jan 2021 15:51:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id DB81264DE3
        for <kvm@vger.kernel.org>; Fri, 29 Jan 2021 20:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611953412;
        bh=sDq4tACvJoQgJhKVkcf8xV2MvnCSxApi3LOXHs0AKJc=;
        h=From:To:Subject:Date:From;
        b=PN6sfMJBZIjX2sDUDctLYxj6MQQTDPIDWwBQg3A7efI87M26PHaq35gZN7HSkLVVi
         Yekw2cfxaHtGxAzC8WhiN2VPpc0U01WY48TbMjLWZbNJNhcwvh5ieGlnKohquuubgi
         +IzIQ2mF3G5pYSw0gw4/cjHOvj+i5a3zGe219EbUSO1FKafOvpNm9l4sFVeleaIrtg
         00Wtevzq1npTDb9iLtyHU/1to7z19EVONWosMZE+3YFhvkkt7vTA6EjvNkEakoe3Dp
         IpeAY8DmNXQgX3LuMzZeqpfZ90A4fumgFzYNA2zhVkFGq6NzXvS4irTkHNqLIymO9G
         wr9CkSjhWoaxQ==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id DA6A4652CD; Fri, 29 Jan 2021 20:50:12 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 211467] New: Regression affecting 32->64 bit SYSENTER on AMD
Date:   Fri, 29 Jan 2021 20:50:12 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jonny@magicstring.co.uk
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-211467-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D211467

            Bug ID: 211467
           Summary: Regression affecting 32->64 bit SYSENTER on AMD
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.8-rc1
          Hardware: IA-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: jonny@magicstring.co.uk
        Regression: No

For obscure legacy reasons I am running MacOS 10.6.8 in a qemu VM, and since
commit fede8076aab4c2280c673492f8f7a2e87712e8b4 the guest crashes 30 second=
s or
so after boot.

It seems that the crash is triggered by starting a i386 program within the
x86_64 XNU kernel, which makes syscalls using the SYSENTER instruction. The
emulate.c change within the problematic commit truncates the intended EIP
(0xffffff80002e3ad0 corresponding to the _hi64_sysenter symbol in the guest=
's
mach_kernel) down to 32 bits, and the guest then crashes - commenting out t=
he
truncation fixes the problem.

This doesn't seem be a problem on Intel VT since there SYSENTER isn't trapp=
ed
by KVM, but it fails on an AMD Ryzen 5600X. It is also presumably not a pro=
blem
with Linux guests, since the EIP used for Linux SYSENTER syscalls fits with=
in
32 bits (I think).

I don't know what problem the truncation is intended to fix, but I assume it
isn't meant to interfere with SYSENTER. I've looked through all the
documentation I can find and am not certain whether SYSENTER is specified to
copy the full 64 bits from IA32_SYSENTER_EIP when used in 32 bit mode on a =
CPU
with 64 bit support, but I assume it is if the 32->64bit XNU SYSENTER sysca=
ll
is intended to work.

Also, ctxt->mode is still set to X86EMUL_MODE_PROT32 at the point that the
truncation is done, despite em_sysenter having updated CS to enter long mod=
e.
Perhaps em_sysenter should use assign_eip_far to set ctxt->_eip instead, to
ensure that the mode is updated? (if that is indeed correct behaviour?). The
truncation would then not take place and the problem would not occur.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
