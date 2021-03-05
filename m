Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFB4D32E64D
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 11:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbhCEK0l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 05:26:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:54070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229578AbhCEK0e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Mar 2021 05:26:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 3FBE86501C
        for <kvm@vger.kernel.org>; Fri,  5 Mar 2021 10:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614939994;
        bh=r7g6LOf/AhpDyppuadaIwabsRh5/AWaAxVMjbcOE6TU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=uKESqhQNF7JAzLP+elG76VkSNM/HbGeD6VioKw3lxzKY3b3wRTmjZIQAPkUWU62P1
         8y7zppbh6PV8fIeW4NPvgcv0QY70nzDMLaXY0piLa9thOiMMYN/YBqOGGBJaiVQ9Ur
         SQD617OtRMQ82COWO8Ho9tQmo1RCOosv1bE4SP2j7xobeke8aJecvzp5Ri71tv9iaG
         9x90YsfiDNAZ4PD4JlQiswZGgBOjuoDXX0FUj29PYv+chsiS8ghFIiSGhE3/Uf/Sj8
         MRG5uhgPHcFjwmdESsqKBMaJXPRExR3X9JLHa0Kp9C4xUEo0afmL/qO76R6a0zl3tx
         ujWfYwiSo0xlA==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 398236530C; Fri,  5 Mar 2021 10:26:34 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 201753] AMD-Vi: Unable to write to IOMMU perf counter
Date:   Fri, 05 Mar 2021 10:26:33 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: david.coe@live.co.uk
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-201753-28872-2gHp1459Tk@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201753-28872@https.bugzilla.kernel.org/>
References: <bug-201753-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D201753

--- Comment #20 from David Coe (david.coe@live.co.uk) ---
More results and some progress!!

A. Alex Hung (Ubuntu) has cherry-picked the kernel-commit [1} of Suravee's
version 3 patch and placed test-builds on [2]. It works for his Ryzen 2500U=
.=20
Bravo for a quick take-up!

I've checked it out and (alas, as expected with the original 5 x 20 msec de=
lay)
it is isn't enough for my Ryzen 2400G which needs ~120 msecs to respond :-(.

B. I've done a couple more rebuilds for the current kernels on Ubuntu 20.10=
 and
21.04 using Suravee's patch updated both with Pauls' retry-logging and with
increasing the maximum delay to 25 x 20 msec.

Grepp'ing dmesg for IOMMU (on my 2400g) gives:

[    1.018329] pci 0000:00:00.2: AMD-Vi: IOMMU performance counters support=
ed
(retry =3D 19)
[    1.022185] pci 0000:00:00.2: AMD-Vi: Found IOMMU cap 0x40
[    1.023669] perf/amd_iommu: Detected AMD IOMMU #0 (2 banks, 4
counters/bank).
[    1.283218] AMD-Vi: AMD IOMMUv2 driver by Joerg Roedel <jroedel@suse.de>

The retrys count backwards so that confirms the Ryzen 2500G still needs 120
msecs to respond.

My (very strong) proposal is that we increase Suravee's retry-count to
something large enough to cover the numerous entry-level Ryzen's out there.
Only the absolutely necessary boot-up delay is introduced (and checked, if
required, by Paul's logging statement). Most purchasers of Ryzen CPUs are t=
hen
covered! Only the dyed-in-the-wool speed-merchants have to make a choice
between boot-up time and IOMMU capability - at least until the underlying
problem can be corrected in firmware or silicon.

Thanks again, good people.

David

[1].
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D6778ff5b21bd8e78c8bd547fd66437cf2657fd9b
[2]. https://people.canonical.com/~alexhung/LP1917203/

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
