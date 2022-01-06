Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E36A486B54
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 21:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243908AbiAFUmj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 15:42:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232673AbiAFUmh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 15:42:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE24C061245
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 12:42:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE2A561E16
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 20:42:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 43E0DC36AE5
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 20:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641501756;
        bh=akZpk0YXruR30BchkQKK+97VwLLh3iKgPM8ufq8qD/U=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=G2Y6K1HaQZ10zC5ohBAgTisCL24tmCzkPH8+YeEHGGty3+17dVZgTozK62KTBczog
         pffdGbUlXgYAvNAe9pNVjM85ipB2KCnUuiE7QyLO2rjjvL4D9+CbOqvmciYjlagIll
         RuZbkacOGNyPuwYd0ovp6Dyopl7n4SEa+g7qpzfLCB9arLncGLb52oRvSACDOLQDO4
         AEvmYYFDvYhH8a0t1AXOVNdtphzGoqcapBYn7qAVstxBcjjnqgnICJ2WHpi6+h/H3X
         fL6wJyT7eF3Fq67xp9/BNYS8Gm/wHvOvItL1Uws8MbnM7sHv50UzY994pvG/Vak7Sw
         32q7ygxS6RTiw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 256FBCAC6E4; Thu,  6 Jan 2022 20:42:36 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 215459] VM freezes starting with kernel 5.15
Date:   Thu, 06 Jan 2022 20:42:35 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: mlevitsk@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215459-28872-zacp8md5In@https.bugzilla.kernel.org/>
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

--- Comment #5 from mlevitsk@redhat.com ---
On Thu, 2022-01-06 at 18:52 +0000, bugzilla-daemon@bugzilla.kernel.org wrot=
e:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D215459
>=20
> Sean Christopherson (seanjc@google.com) changed:
>=20
>            What    |Removed                     |Added
> -------------------------------------------------------------------------=
---
>                  CC|                            |seanjc@google.com
>=20
> --- Comment #4 from Sean Christopherson (seanjc@google.com) ---
> The fix Maxim is referring to is commit fdba608f15e2 ("KVM: VMX: Wake vCPU
> when
> delivering posted IRQ even if vCPU =3D=3D this vCPU").  But the buggy com=
mit was
> introduced back in v5.8, so it's unlikely that's the issue, or at least t=
hat
> it's the only issue.  And assuming the VM in question has multiple vCPUs
> (which
> I'm pretty sure is true based on the config), that bug is unlikely to cau=
se
> the
> entire VM to freeze; the expected symptom is that a vCPU isn't awakened w=
hen
> it
> should be, and while it's possible multiple vCPUs could get unlucky, taki=
ng
> down the entire VM is highly improbable.  That said, it's worth trying th=
at
> fix, I'm just not very optimistic :-)

Actually in my experience in both Linux and Windows, a stuck vCPU derails t=
he
whole VM.
That is how I found about the AVIC errata - only one vCPU got stuck and the
whole VM froze,
and it was a a windows VM.

On Linux also these days things like RCU and such make everything freeze ve=
ry
fast.

>=20
> Assuming this is something different, the biggest relevant changes in v5.=
15
> are
> that the TDP MMU is enabled by default, and that the APIC access page mem=
slot
> is not deleted when APICv is inhibited.

>=20
> Can you try disabling the TDP MMU with APICv still enabled?  KVM allows t=
hat
> to
> be toggled without unloading, e.g. "echo N | sudo tee
> /sys/module/kvm/parameters/tdp_mmu", the VM just needs to be started after
> the
> param is toggled.

This is a very good idea. I keep on forgetting that TDP mmu is now the defa=
ult.

>=20
> Running v5.16 (or v5.16-rc8, as there are no KVM changes expected between=
 rc8
> ad the final release) would also be very helpful.  If we get lucky and the
> issue is resolved in v5.16, then it would be nice to "reverse" bisect to
> understand exactly what fixed the problem.

Or just bisect it if not fixed. It would be very helpful!

>=20
> > Assuming I really do have APICv: is there anything I need to change in =
my
> XML
> > to really make use of this feature or does it work "out of the box"?
>=20
> APICv works out of the box, though lack of IOMMU support does mean that y=
our
> system can't post interrupts from devices, which is usually the biggest
> performance benefit to APICv on Intel.

I haven't measured it formally, but with posted timer interrupts on AMD,
this does quite reduce the number of VM exits, even without any pass-through
devices.

For passthrough devices, also note that without IOMMU support, still,
while the device does send a regular interrupt to the host, then host
handler uses APICv to deliver it to the guest, so assuming that interrupt
is not pinned on one of vCPUs, the VM still doesn't get a VM exit.

I once benchmarked a pass-through nvme device on old Xeon which didn't had
IOMMU posted interrupts, and APICv still made quite a difference.

I so wish Intel would not disable this feature on consumer systems.
But then AVIC has bugs.. Oh well.

Best regards,
        Maxim Levitsky

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
