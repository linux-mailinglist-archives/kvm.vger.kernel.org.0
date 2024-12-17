Return-Path: <kvm+bounces-33900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C86A9F4129
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 04:14:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 19EF8188A32D
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 03:14:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23B6D14600D;
	Tue, 17 Dec 2024 03:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NOKWyLO+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A81145A17
	for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 03:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734405231; cv=none; b=BK1g2okU3set2g1k4F7MCr80GlcKqnlG7YygB82VDNBN1S5ACDllr2ry3J/a3K7iSzc3nO+RTezNPOszJPkR09lDwMea3kx1Gyc+yP1fPozQjHpUHIIV+RGz/lY5XIl/OTOSwiFP4uQCzcj8hMBgtBTLUPqPgNBY6mUWN7hlF2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734405231; c=relaxed/simple;
	bh=aHBDe5EYS/C2G1SdrSsn2GnygqX9yYjd8DRQnWA3IDs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FNEe4mP3xlgD0QySC/JWXk/FEvPSx//pX3MDxi72W75oWC4SmEuVbqAv1WkOwOkZxMBjA0JsjZnXplbYNxZ3kXnfWDr6kFPWwPTF5VN9lk+JakrZvQc8I0hu8T3bXTW94jf00luNQUU77BvWH472jwdMzkDG9pTzsRWviChVMqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NOKWyLO+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id CD49AC4CEDF
	for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 03:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734405229;
	bh=aHBDe5EYS/C2G1SdrSsn2GnygqX9yYjd8DRQnWA3IDs=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=NOKWyLO+FYUy6FL21JSMA3yEq9M6grrV2fyh1MfDsQ8rL+jkdT/8mIwNDJJAKg/Aw
	 huf3IqfE44Lwa2KIXBSbK9IZAT0TP1nW+N2BIKZzXWlT6WwLrgqzBQPHw5/Hq1Htib
	 eNCZBcBWzyvdcR7Um32xeWAiLMk+q/QB7w0AKteSpLEG5ZEb+b4sFuIvHVeqXzMy2d
	 Xn4dcqoKv1myP5AyTeUeDiJC1rZ1qnL0cRVpSO982OsXRkWocOWlVwL5gS1NxXLl7k
	 9DzWEgmjFzCvbHBs7cuBk5PWIfOd9U9ymkVgwOXgy3bwCEjwxfAJ1WUAk88PIosFnA
	 tK7stDJzBNxbA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id C433BC41614; Tue, 17 Dec 2024 03:13:49 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218267] [Sapphire Rapids][Upstream]Boot up multiple Windows VMs
 hang
Date: Tue, 17 Dec 2024 03:13:49 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: chao.gao@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218267-28872-ea0yY7wIwt@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218267-28872@https.bugzilla.kernel.org/>
References: <bug-218267-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D218267

--- Comment #9 from Chao Gao (chao.gao@intel.com) ---
On Mon, Dec 16, 2024 at 07:08:13PM +0000, bugzilla-daemon@kernel.org wrote:
>https://bugzilla.kernel.org/show_bug.cgi?id=3D218267
>
>--- Comment #8 from Sean Christopherson (seanjc@google.com) ---
>Thanks Chao!
>
>Until the ucode update is available, I think we can workaround the issue in
>KVM
>by clearing VECTORING_INFO_VALID_MASK _immediately_ after exit, i.e. before
>queueing the event for re-injection, if it should be impossible for the ex=
it
>to
>have occurred while vectoring.  I'm not sure I want to carry something like

Yes. I tried a similar workaround (i.e., clearing the "valid" bit only for
EXIT_REASON_MSR_WRITE) and our tests showed that it works well.

Strictly speaking, this issue also impacts those VM exits which may occur
during event delivery. Because they might be reported as occurring during e=
vent
delivery even if they didn't. KVM won't notice this, and the guest will rec=
eive
an extra event due to event re-injection. I wrote a kselftest to demonstrate
this.

Clearing the valid bit works in practice. And there is no ideal software
workaround for all cases. Disabling APICv or intercepting MOV-to-CR8 can
eliminate the issue, but neither is ideal due to the performance impact.

>this long-term since a ucode fix is imminent, but at the least it can
>hopefully
>unblock end users.
>
>The below uses a fairly conservative list of exits (a false positive could=
 be
>quite painful).  A slightly less conservative approach would be to also
>include:
>
>case EXIT_REASON_EXTERNAL_INTERRUPT:

We need to include EXTERNAL_INTERRUPT because we observed it in real worklo=
ads
on affected CPUs.

>case EXIT_REASON_TRIPLE_FAULT:
>case EXIT_REASON_INIT_SIGNAL:
>case EXIT_REASON_SIPI_SIGNAL:
>case EXIT_REASON_INTERRUPT_WINDOW:
>case EXIT_REASON_NMI_WINDOW:
>
>as those exits should all be recognized only at instruction boundaries.
>
>Compile tested only...
>
>---

...

>@@ -8487,6 +8549,10 @@ __init int vmx_hardware_setup(void)
>        if (!enable_apicv || !cpu_has_vmx_ipiv())
>                enable_ipiv =3D false;
>
>+       if (boot_cpu_data.x86_vfm !=3D INTEL_SAPPHIRERAPIDS_X &&
>+           boot_cpu_data.x86_vfm !=3D INTEL_EMERALDRAPIDS_X)
>+               enable_spr141_erratum_workaround =3D false;

RaptorLake has the same issue.

https://cdrdv2.intel.com/v1/dl/getContent/740518

>+
>        if (cpu_has_vmx_tsc_scaling())
>                kvm_caps.has_tsc_control =3D true;
>
>
>base-commit: 50e5669285fc2586c9f946c1d2601451d77cb49e
>--
>
>--=20
>You may reply to this email to add a comment.
>
>You are receiving this mail because:
>You are on the CC list for the bug.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

