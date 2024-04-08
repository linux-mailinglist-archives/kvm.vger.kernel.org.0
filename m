Return-Path: <kvm+bounces-13917-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A46D289CCE7
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 22:19:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 12941B2237E
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 20:19:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C17C146A90;
	Mon,  8 Apr 2024 20:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cS2h6igt"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3639B14659B
	for <kvm@vger.kernel.org>; Mon,  8 Apr 2024 20:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712607581; cv=none; b=Kuqmhzk8872SpIqqEAlD01l2t73ikUpmXeEsaNshrWjmsS5ohQlRP3qoJDuQTCbLOemJHzHYtMOKZjZelTRvnwSm+LtBjOr0YXihQ9J/eKiwsUfw0WMUWSpy7OaFdo+ZXTCJzZxekQinjTfSlZBumfo4hbcdUr/2kqT19ArSdKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712607581; c=relaxed/simple;
	bh=tAo06xeu17uOkSnEC/Gp+GAR1IBMrc4JfkGQOXb4Wtc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eRkYQUuoo8DBJPAwZYWIPngtM8MvMPppFOXMIoLdF64r0BrTGojNw22OW+p8x9BWhcc5lJJlGCwMxWbeSH6s98+rOzY9lRg6h6+TbHbP6czSTZ3hCJG3Aw9WsHYFcDLJZUbZWpf8DBqgo1IKXwnoztqhkaQamoza46ZezYjfcHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cS2h6igt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id BABC1C433F1
	for <kvm@vger.kernel.org>; Mon,  8 Apr 2024 20:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712607580;
	bh=tAo06xeu17uOkSnEC/Gp+GAR1IBMrc4JfkGQOXb4Wtc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=cS2h6igtOpWYSWfZKcsbtBPVdMaNLkT4rnWsYBizLjAMKa3Ehoss57UpOh+1wrcb3
	 CYvCwZ7uh3xhCQvs79vk3vFiJPLS2RgMIF7P5idvTFPQFY5zjoVhPllQf8Tqv74A4q
	 7i/7QR75Bn+Rn7hITFl3jEPBIb5Fx/BFr00ubtDza0tl/SHjGqxWWIhIXnVPxkbsqQ
	 QynCDtGEr+H9BLKh8Ij71iIH+EfaEVPDsys56WbY1htYYfkURzUgQTnG8Rfw0j2P4C
	 qAzddGxkSm51dY/6P34iLoQZmmtOLzqhDnIoMdcCRecaGXQZHJ7H1lkb7w69XyIKyp
	 Fu+7b8DgGa2cg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id B0200C53BD3; Mon,  8 Apr 2024 20:19:39 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218684] CPU soft lockups in KVM VMs on kernel 6.x after
 switching hypervisor from C8S to C9S
Date: Mon, 08 Apr 2024 20:19:39 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: seanjc@google.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: PATCH_ALREADY_AVAILABLE
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-218684-28872-O4Wh6B1mSZ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218684-28872@https.bugzilla.kernel.org/>
References: <bug-218684-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218684

Sean Christopherson (seanjc@google.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |seanjc@google.com

--- Comment #3 from Sean Christopherson (seanjc@google.com) ---
Given that 6.7 is still broken, my money is on commit d02c357e5bfa ("KVM:
x86/mmu: Retry fault before acquiring mmu_lock if mapping is changing").  U=
gh,
which I neglected to mark for stable.

Note, if that's indeed what's to blame, there's also a bug in the kernel's
preemption model logic that is contributing to the problems.
https://lore.kernel.org/all/20240110214723.695930-1-seanjc@google.com

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

