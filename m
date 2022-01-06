Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAACA486BAE
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 22:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244139AbiAFVMS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 16:12:18 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45470 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244039AbiAFVMS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 16:12:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27A6761E17
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 21:12:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8632EC36AE3
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 21:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641503537;
        bh=vRV1dTodqehloVbJAMvZoIJJwSmEUPwcsfX9XS1JefE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=bVZGl7vzFzn3xbKzETvVkkxL1LKXQ4Gu3cpdiNsusjAu4nZ6jyiNbQt0YP7FXrYi6
         Smqkr/SNCybosvKZBCeD0QF2hA5C6lvKiMONIhtNwrbFlqwtunTPSSp6Agi7vr3pbm
         mwjRAUD4MipAYvBvY4T2nfYd+kUJvkEcdIojJt2p3tjdQEFzyZnmGIF+PFq9p2jn0i
         K8YSB3S0PbtUW6AW6TwKmclku3d5kO8cUmeIiiuhGxof37oGPbJLUEO8skKAZ3As/5
         EN0ZhkXe54xlVHGNllgRkJDwJI2Osg83It1tZCLJCOvEUQIwvxCtyjZhTrGuqJt67i
         c8wDsGQjRm1KQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 71C65C05FEF; Thu,  6 Jan 2022 21:12:17 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 215459] VM freezes starting with kernel 5.15
Date:   Thu, 06 Jan 2022 21:12:17 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: th3voic3@mailbox.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215459-28872-kAqeFxqe9P@https.bugzilla.kernel.org/>
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

--- Comment #6 from th3voic3@mailbox.org ---
(In reply to Sean Christopherson from comment #4)
> The fix Maxim is referring to is commit fdba608f15e2 ("KVM: VMX: Wake vCPU
> when delivering posted IRQ even if vCPU =3D=3D this vCPU").  But the buggy
> commit was introduced back in v5.8, so it's unlikely that's the issue, or=
 at
> least that it's the only issue.  And assuming the VM in question has
> multiple vCPUs (which I'm pretty sure is true based on the config), that =
bug
> is unlikely to cause the entire VM to freeze; the expected symptom is tha=
t a
> vCPU isn't awakened when it should be, and while it's possible multiple
> vCPUs could get unlucky, taking down the entire VM is highly improbable.=
=20
> That said, it's worth trying that fix, I'm just not very optimistic :-)
>=20
> Assuming this is something different, the biggest relevant changes in v5.=
15
> are that the TDP MMU is enabled by default, and that the APIC access page
> memslot is not deleted when APICv is inhibited.
>=20
> Can you try disabling the TDP MMU with APICv still enabled?  KVM allows t=
hat
> to be toggled without unloading, e.g. "echo N | sudo tee
> /sys/module/kvm/parameters/tdp_mmu", the VM just needs to be started after
> the param is toggled.

I enabled APICv again and toggled the setting and did a quick test. I teste=
d a
couple of things that often caused freezes. So far so good. Now I've added =
the
toggle to my qemu hooks prepare section and will do further testing.=20

Thanks for the input so far

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
