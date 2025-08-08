Return-Path: <kvm+bounces-54340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 94CCEB1F12B
	for <lists+kvm@lfdr.de>; Sat,  9 Aug 2025 00:59:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3644583138
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 22:59:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA436270ED5;
	Fri,  8 Aug 2025 22:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kSLrxZLq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E4D2620F1
	for <kvm@vger.kernel.org>; Fri,  8 Aug 2025 22:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754693974; cv=none; b=YmUhjzqqQ5BILMyHgVPBdATxOQ3JgfnZfc41xux/RKNiLmIpk8EqOrU7ThapHCSZaSZmc746NQSH49XzfKiliBdbqHpxkRJ0It67Mu5TlIK9IzUSa19Io/eJET71hPILu4IjqlHdKygOqjZXaiYkz52s/7Qs396D6gHwjkvyKdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754693974; c=relaxed/simple;
	bh=hfw6d65qE4NY1/7CpgoSiv6vEJ+cf8nu9gOj8B3/AWw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NzfIry7gIzYZt+C3AqXBRrXTAo/Q2hpvBxGC4PdNWWyxhZ33aVMpAdNYwNYN+SxzOWCLkt/1+sZ4cjKhxYJEQHFKviOtczaAEFOtk7hy9u0YLzgi37GhsqgWNsWRTw+t+jPQhgl09wh8liAbJIV2ktf5lwSVrfCUyRqM83inKI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kSLrxZLq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6372FC4CEF6
	for <kvm@vger.kernel.org>; Fri,  8 Aug 2025 22:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754693973;
	bh=hfw6d65qE4NY1/7CpgoSiv6vEJ+cf8nu9gOj8B3/AWw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=kSLrxZLqJyT96f0aQdB7rOTt81aXuGlqYSZ2O2+43aZ+CsLBBiKL3VWOZ8MTEfnWG
	 7G4znr/ssUg2uFmHBj1N9vsJksaXojxHZpypDhBS7fOqgKC0w+a5PwVcayPv4or0uW
	 fO9zyUc1GtU9y0ICe+aQSN/2HrEc6iNsv30qnhppZo8nebVWrugqhAoWJd/N8nag/y
	 cHgk19aDlMDJj8iV5IZfAbM7whJQpusJssAT82KPXhVT6gWGWIa75yo2HkQsywhOE9
	 P7LRtL561VHhAKKucdcmCdb1NEVritrZctmWh55J4k5rYHh1lKY7L2sdmcKDw9cUjH
	 nzd/90W5xyS/A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 5CCC2C433E1; Fri,  8 Aug 2025 22:59:33 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218792] Guest call trace with mwait enabled
Date: Fri, 08 Aug 2025 22:59:33 +0000
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
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218792-28872-5sylPIVpHD@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218792-28872@https.bugzilla.kernel.org/>
References: <bug-218792-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218792

--- Comment #7 from Sean Christopherson (seanjc@google.com) ---
On Fri, Aug 08, 2025, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D218792
>=20
> Len Brown (lenb@kernel.org) changed:
>=20
>            What    |Removed                     |Added
> -------------------------------------------------------------------------=
---
>                  CC|                            |lenb@kernel.org
>=20
> --- Comment #6 from Len Brown (lenb@kernel.org) ---
> Re: intel_idle
>=20
> I agree that the SDM doesn't guarantee this MSR exists
> based on the presence of PC10.
>=20
> I'm not opposed to _safe().
>=20
> but...
>=20
> Why is this "platform" advertising PC10 (or any MWAIT C-states) to intel_=
idle
> in the first place?

Because letting the guest execute MONITOR/MWAIT natively, and thus get into
deeper
sleep states, is advantageous for all the same reasons bare metal CPUs want=
 to
get into deep sleep states, e.g. to let active cores hit higher turbo bins.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

