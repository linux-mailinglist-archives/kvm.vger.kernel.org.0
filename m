Return-Path: <kvm+bounces-6097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA32782B236
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 16:55:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2C91CB24183
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 15:55:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EECC94F887;
	Thu, 11 Jan 2024 15:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dm5ENcQL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255A54F8B8
	for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 15:55:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7649EC433F1
	for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 15:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704988508;
	bh=bPxy3xoGx6CkJLLwvHSmnElchYkmTUm5NhMvJ/rrBUQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=dm5ENcQLiwXbL1m0S64iPg1rulizjGP/SQZV0iXjxURbe2V5wjHiFDiOVKEYhnEKf
	 b+zp7stlSs2C+l9R0hweVIqHfI50WQi6GlOAdOm274Pvp/2zwX1MquT78VC6ybFvDs
	 yv4LRmYOJD3/OBATp2EdeVNOBNhM3RswU56nHoXh7jAxzlPNTaJDTEXXwNgt4QUaRu
	 qNADdT8RrIysi6vj/i7JRQ4M+gvwv6w4RRQvFa15c/tTNSakOTs82jX5Yqrmxpp0Fk
	 SYdedblWaymgF1TU4VizqFH1RVeOz/c6klGoBXqJ7FQTrykIn7DafvCtjB9RMPnYot
	 +jkcB/+lJy5Lw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 61540C53BD3; Thu, 11 Jan 2024 15:55:08 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218259] High latency in KVM guests
Date: Thu, 11 Jan 2024 15:55:08 +0000
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
Message-ID: <bug-218259-28872-CSzJkkb9cN@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218259-28872@https.bugzilla.kernel.org/>
References: <bug-218259-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218259

--- Comment #8 from Sean Christopherson (seanjc@google.com) ---
On Mon, Dec 18, 2023, bugzilla-daemon@kernel.org wrote:
> > I think the kernel is preemptible:
>=20
> Ya, not fully preemptible (voluntary only), but the important part is that
> KVM
> will drop mmu_lock if there is contention (which is a "requirement" for t=
he
> bug
> that Yan encountered).

For posterity, the above is wrong.  Volutary preemption isn't _supposed_ to
enable
yielding of contended spinlocks/rwlocks, but due to a bug with dynamic
preemption,
the behavior got enabled for all preempt models:

https://lore.kernel.org/all/20240110214723.695930-1-seanjc@google.com

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

