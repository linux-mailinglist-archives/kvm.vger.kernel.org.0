Return-Path: <kvm+bounces-30586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A561F9BC2B4
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 02:37:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 67D3F282356
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 01:37:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C0E8208AD;
	Tue,  5 Nov 2024 01:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TR4gS4OX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50AF0CA4E
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 01:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730770639; cv=none; b=LGvS5duqK8YzxWwLYIUszuJXbn05Yhnl/nUZ9ltPomCou7GfWX5agnF1q6mo+UHyJC0iHSyp1hOjl8WSN+NqKK8fG/Lp8g3LHyuJTUgg+EKWma4U6SEpRAhKL90iOj7oLBnLsGey62ZNdu8iKAC/rsNjQomFxVtMwdk8gNWBCbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730770639; c=relaxed/simple;
	bh=We8q/8REyA2acf51vN235VyRpqHWuvByPNybxyPTdi4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZIpP+LXgUgOkvHgao75t3BU7MgReqvyB0dDDGgq5bBJR3gCFca0GLqJ1NXaUH4Wovd0i7qEH8VGVwLyKeFA2wwDa1GJSOlkfIpPLXBX+2jYY7zzpd3ZAqbOWBPZUBLyXHcmmJx8mzJbYjs0c1bxlFRYVQIDk+WbPND1o2T/+lro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TR4gS4OX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2374FC4CED5
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 01:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730770639;
	bh=We8q/8REyA2acf51vN235VyRpqHWuvByPNybxyPTdi4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=TR4gS4OXvIRuZoED10sSYH5lJFBDytLRU8BKQH0/iucQvt9XPwTxrKfWTCW80EGgB
	 5Wm36W4LfezcSouX7g5oXLo8/xUIeWmoDrx0dQZCSJqmmPRQxlgO0dMu8u1z13S9Ab
	 NQJtPyCqbRQGbvvCMXyRi5nfoIYy/5soX48q3kwWPCKqBO6aT6+pf+LxZkABpv1cVv
	 kAH0Fpiij5048PvhMM2wwFb2PpHu9G/hNnpPStFga6RbN2FCk7J+6bX8DBJYlTox5C
	 wKdoZfViggWOHJ4NZjhTm0ilJp8M9ubQDob6s4MjhYBk46yJZQ+Iy4aDepchlY2gC1
	 VQphyvySzU65w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 1B583C53BC4; Tue,  5 Nov 2024 01:37:19 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219112] Machine will not wake from suspend if KVM VM is running
Date: Tue, 05 Nov 2024 01:37:18 +0000
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
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-219112-28872-9p2rHH6xbD@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219112-28872@https.bugzilla.kernel.org/>
References: <bug-219112-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219112

Sean Christopherson (seanjc@google.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |seanjc@google.com

--- Comment #5 from Sean Christopherson (seanjc@google.com) ---
Heh, that was quite the rabbit hole.  Poking around reminded me of a bug re=
port
from Tejun about KVM worker threads not freezing in certain scenarios[*].

Long explanation very short, can you try setting KVM's "nx_huge_pages" modu=
le
param to "never"?  E.g. via

  echo "never" | sudo tee /sys/module/kvm/parameters/nx_huge_pages

Note, the module param is writable even while KVM is loaded, but it needs t=
o be
set to "never' _before_ launching any VMs, in which case KVM won't spawn the
associated worker thread.  I.e. the "never" setting only affects worker thr=
eads
for new VMs.

AFAIK, that's the only problematic flavor of worker thread in KVM.  If that
makes the suspend/resume problem go away, then odds are very good the
underlying issue is the same one Tejun reported.

[*] https://lore.kernel.org/all/ZyAnSAw34jwWicJl@slm.duckdns.org

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

