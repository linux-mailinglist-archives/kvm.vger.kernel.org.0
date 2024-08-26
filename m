Return-Path: <kvm+bounces-25017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0092B95E5EE
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 02:07:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B9C01C208CC
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 00:07:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72806653;
	Mon, 26 Aug 2024 00:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eGyY6xcj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AECD623
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 00:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724630853; cv=none; b=e2XViKEVpghlNO0TrHnU+NCc/drOA+J0TTPeq3hN5RtWL612iNUDlZdD5sdv3BWe1VCIxt/TQvkUH6+r5l3Jhp0vXcU4DxxcIynjFr6dZNGXBBgTldnZvmb+cV5ivFeonejPAosr7rOWY+8XFvuLg0LdxCVh/Hp4nnEi+nirPRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724630853; c=relaxed/simple;
	bh=FqWHHuaAGYmkqdvYMTlGZ/xpiwrVR5QaFQSQYJGsE/s=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IU0nKKhZQY3BUgE3PIWg34x6b13YJXyOfYxC4FW064HEHZaibHbSBaIpRpFpWvwA/GVuIvcbfgyUDw0cDQI4cZDatTU5N/Vmi31alzcyqYH66ENFQRE9GC6sOMsesuV73KD4dzJE/JGZ2oiT3jGrdTCCc1EAm+UHy13i9upz8FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eGyY6xcj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 11D8CC4AF1D
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 00:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724630853;
	bh=FqWHHuaAGYmkqdvYMTlGZ/xpiwrVR5QaFQSQYJGsE/s=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=eGyY6xcjwePeZcBkUVvI6k7/gdIGGTprTKuIRvNw1iiAkHOPfqaiF6zIPeWh5CMXn
	 clqDtdV15P7GYvL6SD5M2h6mwCyRcDA3Y883qpmDs8NfY/eEj3C+GacCQd5BQoL3RD
	 Z5d9QCe0eZbOd/zfwIZrm8YhnZ8oEBfIXfLe7qfb7W8CMDvaIhQ1Da7yUQhONhYAqO
	 kDq8RrVsoScl0ucuRX1G96yfcNo03woJA9XjYVkJi4wRawNQW+SwarnTkQFilsuENz
	 Z7ryYhCXIlg74zStxDHoyWgvIeYltasnInikTOMZn0iKN7sglV5BZrgKNre1I+1sZm
	 qKFzSzAXF2N4g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 0D46EC53B7F; Mon, 26 Aug 2024 00:07:33 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Mon, 26 Aug 2024 00:07:32 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: ozonehelix@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219009-28872-9aTsytDR8p@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219009-28872@https.bugzilla.kernel.org/>
References: <bug-219009-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219009

--- Comment #9 from Ben Hirlston (ozonehelix@gmail.com) ---
(In reply to h4ck3r from comment #8)
> (In reply to Ben Hirlston from comment #6)
> > do we know if Ryzen 9000 has this issue? I know I had this issue on Ryz=
en
> > 5000 but to a lessor extent
>=20
> Could you elaborate on what was happening with 5000?
> (reboots, mce, something other)

I would be using my Virtual Machine to Windows Windows 11 and would be doing
something intensive that was using vls and the machine would reset just like
7000 but it happened way less often

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

