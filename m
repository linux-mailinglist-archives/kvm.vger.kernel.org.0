Return-Path: <kvm+bounces-46031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EC61AB0DCB
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 10:51:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E88F500EA9
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 08:50:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D2DD27510F;
	Fri,  9 May 2025 08:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jdzTT6Y4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C405D2749DA
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 08:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746780537; cv=none; b=Yx0ynwj6WfkMvQLhGfJ8dO3sADAwt8olVzOtM9fe9XT9UeZqKsrbWqRQlvN3klDLxFGzgsF4XOmgU+/YOGg7NUK0r47TZOn1HG+aI9cxjoebZXDSFlfO0XdCu57XpmpxHUsB3lGTZT+1Rnii8LcYmGetQUrqQpWf+LARc/Ql37c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746780537; c=relaxed/simple;
	bh=4h8yW3D8RfZkwJwxL7/ITZyfT1u/UGlN/tQNSazro1A=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tNLsYrJXFHt6rISz/8wnz/MvARt/xVxrN1kQR8NRhkbORgbGvYWueiIiBmYNJcCG5nxnfB/7wzBxqoorsWo9XT8Wjc4hlzZWwCmk98CPyyMNSe1D5dDZaS5ia6uZhz0/14SZbbVLzqVIpzGyi/eRZn1nkegJe83mX9fMGk5EE7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jdzTT6Y4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3F3A5C4CEE9
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 08:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746780537;
	bh=4h8yW3D8RfZkwJwxL7/ITZyfT1u/UGlN/tQNSazro1A=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=jdzTT6Y4A7M/k0025r7i2FDdQKTCFDzhASJhCrUYCNZeMYP7L0uebuBx6FO+ibZZm
	 3kN2vBuXeqMFXUmgqocW2HBB8EYR0/sLejw8nTaSUQ2i/zC8TSTndHspynGZAeIOel
	 ZA4mdbd6PdYH4CaqwAeaHiwDyQzH1wrTtkMiFyETlHNuclC4ovhtbF2jVj6SYCF58z
	 kTrorIW3CJblr5Sp8WSTSrnQLBDfjSE1cqyldwfEb4nXgxCT3XvtzjhhN5ZECdOTaf
	 sHhZb2J38yB7bp28U4yW1nWz/1KuqKLOFxHMBfsSNxQkco1WHCjXx28Y9EkCI2thQ2
	 u9Z/7J7ZZkaFw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 36CE1C41616; Fri,  9 May 2025 08:48:57 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 199727] CPU freezes in KVM guests during high IO load on host
Date: Fri, 09 May 2025 08:48:56 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: devzero@web.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-199727-28872-2dP4GgR0b1@https.bugzilla.kernel.org/>
In-Reply-To: <bug-199727-28872@https.bugzilla.kernel.org/>
References: <bug-199727-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D199727

--- Comment #29 from Roland Kletzing (devzero@web.de) ---
can anybody reproduce this in an environemnt without qemu ?

if that is not the case, maybe it would be better to file a bug report at
https://gitlab.com/qemu-project/qemu/-/issues , as nobody seems to care here
anyway.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

