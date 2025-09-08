Return-Path: <kvm+bounces-56962-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 35D7FB484D0
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 09:10:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB16B177FE9
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 07:10:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 262FE1F1932;
	Mon,  8 Sep 2025 07:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XZ+YVAur"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CFD92E3AE6
	for <kvm@vger.kernel.org>; Mon,  8 Sep 2025 07:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757315428; cv=none; b=WxkJ1z0KakYIohyTuk7+sUXLaZXlOUdFwYTwcpVuFhalCnRi/Pr00hezPMyzu3qdmgu2V8SstanfvZsW/2vAu0D0JGwot78NYxzM+Np61MsWkGzI3+j13kR5wleWTU3wA40m97cWcePKJzXpUXne+Cg/ruF8WQFFsy0FU6St5As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757315428; c=relaxed/simple;
	bh=FVaUYDjs3dz391xuTXKVAu9abLSph2NuH08Mi4EVgE4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Oj8b7N+YGgWmLcUMKa+XJVl4OYF35ti+6ljF60T0g+HxPLeCx6Hp2pe8DuveHABs0WesDDPS0EDS6Tik+hivHDw96jQFT52k0B7RmG54HE0l+9WNetVg+y1H8SLyICKUYggpaA6cLJK+hRb0JqRR3mzsLIrpHTwih1eH9O99Z1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XZ+YVAur; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id D592BC4CEFB
	for <kvm@vger.kernel.org>; Mon,  8 Sep 2025 07:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757315427;
	bh=FVaUYDjs3dz391xuTXKVAu9abLSph2NuH08Mi4EVgE4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=XZ+YVAurrxftCqNmIyaB/kHBj5prMhb4kwMlXM1TOVLc9QX/II6+0gMP8TGqbmij+
	 ubOyBfqRjCS9LftWYNV93kWuVD22lq8FtxSi2305qJFciXS9FYBomN76VC2Mtj1gH4
	 y4o3Y+6W3Y02Oq/4UiQ/URuAUNkyI9evAxfHJ1yGOcSF/1IQ+b5aY3Tlvx3ds9xtbL
	 R1BJYq1Jrf0Cb71q+gKvNlDdl+UgvCng4uJN0oYEEEVn8X1cknh8kblnEnQouLpcTO
	 EzMaIXaeQa4qrFWgSK9Y2YTiKvL8r/WmP6/0idRrUQy7+xlW4Cxf605Ag8hwrMi/ei
	 5K+VQB0aV8mSg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id CE4D0C41614; Mon,  8 Sep 2025 07:10:27 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220549] [KVM/VMX] Level triggered interrupts mishandled on
 Windows w/ nested virt(Credential Guard) when using split irqchip
Date: Mon, 08 Sep 2025 07:10:27 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: khushit.shah@nutanix.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cf_kernel_version
Message-ID: <bug-220549-28872-HMLiYvZDIe@https.bugzilla.kernel.org/>
In-Reply-To: <bug-220549-28872@https.bugzilla.kernel.org/>
References: <bug-220549-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220549

Khushit Shah (khushit.shah@nutanix.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Kernel Version|                            |6.17, 6.12

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

