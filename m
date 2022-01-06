Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8DA486A2B
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 19:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243028AbiAFSwJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 13:52:09 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42086 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242979AbiAFSwI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 13:52:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C133B8216A
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 18:52:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 42FB0C36AF2
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 18:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641495126;
        bh=rWqtOwhmn7pFOcrcgKUUSLqgsXth/CcKPgLbLO3Z6AI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Vcr+KZFWjKKXg9ctkfQTXBb+zBtsorjGA6YriUiGs6+rYv3etolprvYUoyQO08QGf
         8cjtcLbS7tAwQpWgXub6iPwmrO0rLAWISXaciAjbhVAGPlgHkgAYlIYMo6a/+ve7vj
         uJvrrG1hQurBn/l1A18fUCM+pzsLKaj1YEFUpa34l6w1XUZPv2GH1ZbcOt5WscnpMJ
         /wQql/CP0ZluRqszNGM08stXlLZ67IIKBbO62CEM416lqOyxgNl+WmK+NPyHoG2ZIa
         N3rhidi7+8fIE2q53MBxmP2iv02LBP9HUoRvNi+diVWQMWWAI97vUprgomNtc+3AuD
         sekAI8wjKLegg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 2B20AC05FD1; Thu,  6 Jan 2022 18:52:06 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 215459] VM freezes starting with kernel 5.15
Date:   Thu, 06 Jan 2022 18:52:05 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: seanjc@google.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-215459-28872-TQlaXRXjPh@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215459-28872@https.bugzilla.kernel.org/>
References: <bug-215459-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215459

Sean Christopherson (seanjc@google.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |seanjc@google.com

--- Comment #4 from Sean Christopherson (seanjc@google.com) ---
The fix Maxim is referring to is commit fdba608f15e2 ("KVM: VMX: Wake vCPU =
when
delivering posted IRQ even if vCPU =3D=3D this vCPU").  But the buggy commi=
t was
introduced back in v5.8, so it's unlikely that's the issue, or at least that
it's the only issue.  And assuming the VM in question has multiple vCPUs (w=
hich
I'm pretty sure is true based on the config), that bug is unlikely to cause=
 the
entire VM to freeze; the expected symptom is that a vCPU isn't awakened whe=
n it
should be, and while it's possible multiple vCPUs could get unlucky, taking
down the entire VM is highly improbable.  That said, it's worth trying that
fix, I'm just not very optimistic :-)

Assuming this is something different, the biggest relevant changes in v5.15=
 are
that the TDP MMU is enabled by default, and that the APIC access page memsl=
ot
is not deleted when APICv is inhibited.

Can you try disabling the TDP MMU with APICv still enabled?  KVM allows tha=
t to
be toggled without unloading, e.g. "echo N | sudo tee
/sys/module/kvm/parameters/tdp_mmu", the VM just needs to be started after =
the
param is toggled.

Running v5.16 (or v5.16-rc8, as there are no KVM changes expected between r=
c8
ad the final release) would also be very helpful.  If we get lucky and the
issue is resolved in v5.16, then it would be nice to "reverse" bisect to
understand exactly what fixed the problem.

> Assuming I really do have APICv: is there anything I need to change in my=
 XML
> to really make use of this feature or does it work "out of the box"?

APICv works out of the box, though lack of IOMMU support does mean that your
system can't post interrupts from devices, which is usually the biggest
performance benefit to APICv on Intel.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
