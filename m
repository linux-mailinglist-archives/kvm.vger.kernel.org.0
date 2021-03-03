Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F75432C745
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348108AbhCDAbX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:31:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:38164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236310AbhCCShZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Mar 2021 13:37:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 3B38364EFC
        for <kvm@vger.kernel.org>; Wed,  3 Mar 2021 18:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614795896;
        bh=sebix/Q/mbwnM9Tx94jBnrz79zIIYeIUYnv8UJTkXTA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=PhaE/e66lGlQhY5Umgj/vFLkfRRba40lWixfHEpoCHy3aqIYzKAt+t1Qc7EiU7vh9
         clpRna8HmgPvLXLj9qYkwbi6opuptsZAATbO79co+OLgr5CLfZP5tMkhI+4N2KEFo1
         QSuQbVP/QWifz5pWODgMdZoOS/HKOIHw2QZsRuN0cp3xlsd+U/1jxtdJw/9X4y9dFO
         v5xal8fiM7mFFMtMsuXeBRcSXmjvqmiDekahtl/2h4ABoGVIltqnZHodoANl56AaDs
         IUxT6X5gHlSJJta8bvzUzX6RwS5aVdkBJRiqhKFocJgpiNpS+C8aU3NRaLODdE97/D
         bWAfY8ZJvbB/g==
Received: by pdx-korg-bugzilla-2.web.codeaurora.org (Postfix, from userid 48)
        id 346E165374; Wed,  3 Mar 2021 18:24:56 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 201753] AMD-Vi: Unable to write to IOMMU perf counter
Date:   Wed, 03 Mar 2021 18:24:55 +0000
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
Message-ID: <bug-201753-28872-xwD1p7MJLk@https.bugzilla.kernel.org/>
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

--- Comment #19 from David Coe (david.coe@live.co.uk) ---
Hi all!

It's a knotty problem: the Ryzen has IOMMU performance counters, but can't =
tell
you they're working without a (120 msec 2400g, > 200 msec 2200G) delay (not
popular with Paul or Alex). It can assume they are working pro-tem but check
later in the boot sequence (Alex's patch but Suravee has some products that
don't like this). It can assume they aren't working (although they are) and
leave the user-space application to handle the loss of facility (not at all
keen on this myself).

System OEM's will want clean boot interfaces and road-warriors with high-end
laptops hate unnecessary delay when they lift their lids. However, day-to-d=
ay
users of virtualisation software like (for example) KDM will notice if IOMM=
U/Vi
hardware acceleration is present but crippled by the OS (how do the Windows
drivers handle the same issue?). The usual solution for this sort of dilemm=
a, I
think, is to put in a BIOS switch or have a boot command-line option.

The current default is to turn slow-reporting IOMMU performance counters of=
f.
This gives problems later with:

# perf stat -a -e amd_iommu/mem_trans_total/ test
event syntax error: 'amd_iommu/mem_trans_total/'
                     \___ Cannot find PMU `amd_iommu'. Missing kernel suppo=
rt?

After either Suravee or Alex's patch:

# perf stat -a -e amd_iommu/mem_trans_total/ test
Performance counter stats for 'system wide':
               897      amd_iommu/mem_trans_total/=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
       0.000990106 seconds time elapsed

Installation checks for KVM like systool -m kvm_amd -v and kvm-ok then give
expected results about modules and hardware acceleration. In principle, I'm
sorted for the 2400G but repeatedly recompiling the kernel is not a lovely
solution. Very, very appreciative of all attempts to get a generally-accept=
able
patch into the distributions!

Best regards

David

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
