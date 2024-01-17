Return-Path: <kvm+bounces-6368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71BA882FE29
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 02:05:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 753141C24003
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 01:05:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2D536119;
	Wed, 17 Jan 2024 01:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f47PlKZM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3F1524F
	for <kvm@vger.kernel.org>; Wed, 17 Jan 2024 01:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705453520; cv=none; b=ppZsywMj7KTO/QkZpVPzGTqfGmSkBi7igMGoU75QJ84sMt5Rvw7dUgpZFgOQPePKAsBQxsvAtoccl3inXeg6nRUzjsv7eZS2qAq4QQALWmEHTcJvYKcSFSAC/WU6/8+k36EvUYglZuqyfGPeEqM2NFFaD0J4odNUWlo069dUpT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705453520; c=relaxed/simple;
	bh=/9SP4gVE658v9YfGwNONAmmBxsrhpmUg1lullqfLtEY=;
	h=Received:DKIM-Signature:Received:From:To:Subject:Date:
	 X-Bugzilla-Reason:X-Bugzilla-Type:X-Bugzilla-Watch-Reason:
	 X-Bugzilla-Product:X-Bugzilla-Component:X-Bugzilla-Version:
	 X-Bugzilla-Keywords:X-Bugzilla-Severity:X-Bugzilla-Who:
	 X-Bugzilla-Status:X-Bugzilla-Resolution:X-Bugzilla-Priority:
	 X-Bugzilla-Assigned-To:X-Bugzilla-Flags:X-Bugzilla-Changed-Fields:
	 Message-ID:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:X-Bugzilla-URL:Auto-Submitted:
	 MIME-Version; b=NvUrgInAHzWulo1MoVYlbd1FxOxrw4VtVjfqlaRDpUW4p84fp0ERILgfQxNXYfH99UR9yHpkbS75BL+gmd3jauScdJObKdSpPA9OKRWHxKCmTMs5FAVXuaqO2oS0EmR3X4tu9ZUyGIoL6vMd2kyTXVYAXhXtbUNqv8nN6s3Wyj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f47PlKZM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 95C9BC43390
	for <kvm@vger.kernel.org>; Wed, 17 Jan 2024 01:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705453519;
	bh=/9SP4gVE658v9YfGwNONAmmBxsrhpmUg1lullqfLtEY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=f47PlKZMRlXTNXvyL0mhAbajohJ1JxdsJVowbvaTFrPUPeOe9rb8ksSNF+wNKxg18
	 c8DUoZdgE7TNKoO9TbaFBqFR2/PFPPBJL+dB+WqHTOfMEYwTGdO/C8ZhnAe5Kc8WS3
	 DUxmvfMdC45O6gb9iVFhdIQAY1lyRIo4c88x/wvhCNcH9A0yaEaJiKsH7qgbWXarEO
	 A2aBSmcD8tKECPQ9c6GefUU89xBkThMYQbhiceQIw5PX/JtzZV0hYrVg8ngeZiT7Al
	 79EpUUTlYsxxPWZ2iX1tQlzYkMtJO4MXGgmQCcubnlRbE56/LiAat/ZS0i+rh/6Hb/
	 0XWruUm6BhTAg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 80885C53BD3; Wed, 17 Jan 2024 01:05:19 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218259] High latency in KVM guests
Date: Wed, 17 Jan 2024 01:05:19 +0000
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
Message-ID: <bug-218259-28872-m1wKQYWfTH@https.bugzilla.kernel.org/>
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

--- Comment #10 from Sean Christopherson (seanjc@google.com) ---
On Tue, Jan 16, 2024, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D218259
>=20
> --- Comment #9 from Joern Heissler (kernelbugs2012@joern-heissler.de) ---
> (In reply to Sean Christopherson from comment #5)
> > On Thu, Dec 14, 2023, bugzilla-daemon@kernel.org wrote:
>=20
> > While the [tdp_mmu] module param is writable, it's effectively snapshot=
ted
> by
> > each VM during creation, i.e. toggling it won't affect running VMs.
>=20
> How can I see which MMU a running VM is using?

You can't, which in hindsight was a rather stupid thing for us to not make
visible
somewhere.  As of v6.3, the module param is read-only, i.e. it's either ena=
ble
or
disabled for all VMs, so sadly it's unlikely that older kernels will see any
kind
of "fix".

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

