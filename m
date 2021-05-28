Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8C43941B3
	for <lists+kvm@lfdr.de>; Fri, 28 May 2021 13:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbhE1LV6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 May 2021 07:21:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:46830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229552AbhE1LV5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 May 2021 07:21:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 08D54613E3
        for <kvm@vger.kernel.org>; Fri, 28 May 2021 11:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622200823;
        bh=sLvchkGTTBT12OhEpWTb2OhFW0PhzUzyHKc+gbCmvsM=;
        h=From:To:Subject:Date:From;
        b=OzgHBeKCJRb1F9uGU5TFVTzb6YerhZYC7m6EbP1NTm950BRTBVYHVMf2u1T2Ewv4N
         T68M8b57LyjVBcQ6vyZksI5oV9iC9qp6AfDLpAuizP1XlqTCMKlBWofxgZqRFNQUSK
         OpCYcfmsB5DDLLmUfR3YOP+rbzoM2MZxWI0Mb2nJgI5TABgUIv/BHmx4rq93OScJAR
         4dteicIGUk/79G5kE74FT74EAQRRoAvTwarhyPBx82H5K7rnyWgxuWm8tBl42HNg+L
         t3J83m5HyLELSpPG8SLVaeaye2UkTh18EbMiEn++GJoPv+SEUVwlc+fgxQ7Yb7gHTY
         o1I6UaHTpm7UQ==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id F019561241; Fri, 28 May 2021 11:20:22 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 213257] New: KVM-PR: FPU is broken when single-stepping
Date:   Fri, 28 May 2021 11:20:22 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: cand@gmx.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-213257-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D213257

            Bug ID: 213257
           Summary: KVM-PR: FPU is broken when single-stepping
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.6
          Hardware: PPC-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: cand@gmx.com
        Regression: No

The FPU is completely broken when single-stepping on KVM-PR. Registers stay
zeroes, computation results are zeroes. If I disable single-stepping,
computation results are correct, but of course then I cannot dump FPRs betw=
een
every instruction.

HW is POWER9, 18-core Talos II.

5.6 is slightly old, but there are no commits under arch/powerpc/kvm since =
that
mention single stepping.

Program:
https://git.libre-soc.org/?p=3Dkvm-minippc.git;a=3Dsummary

Test file:
https://ftp.libre-soc.org/mini-float-test-kvm.bin

Repro instructions:
git clone https://git.libre-soc.org/git/kvm-minippc.git
cd kvm-minippc
make

wget https://ftp.libre-soc.org/mini-float-test-kvm.bin
./kvm-minippc -i mini-float-test-kvm.bin -t trace
less trace
# you will see FPRs stay zeroes. In larger test programs that dump the comp=
uted
memory, that is wrong too (all zero).

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
