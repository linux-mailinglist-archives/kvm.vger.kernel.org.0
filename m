Return-Path: <kvm+bounces-21061-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 658229294DE
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2024 19:19:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0B2E11F21C06
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2024 17:19:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1261813C3D2;
	Sat,  6 Jul 2024 17:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oLoxw01d"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4F912AAFD
	for <kvm@vger.kernel.org>; Sat,  6 Jul 2024 17:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720286360; cv=none; b=SH2JiCLn7xgXpcWsauJ9raFEMOZXFRP4aEHpNlzzGvUkq4YN1J1OA3fc5gDpNQsFDoaMwxaXNTn0YxyNpH4F65PCy3qJQ+nYkqasODf0jje98lORNuye8q9gw1SKr0cQOmPR2tJir48Q+Tnnjt6lvk5kzcG8Xa7BRsniwI3mwOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720286360; c=relaxed/simple;
	bh=tYn5Sw8hpOhEsfNvGbB77T/02+KRTpwefKDVCjWbFWs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ppjc1CXbPbr8wcgnfhZfrzl5sR+calGjD5WIZ8NFCt/S/tGqYpze13ppfcwfJR7w1YCY16eQJQWK1UO7Qeuma8X6TurJ+ljxjhfSSVfiuW8nNnfvsD6WOa/0Fifa9I5Ts/3dOKg7Q43vnqjOlQuJmXr46T8Ef6z72dtGjwX3yrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oLoxw01d; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id AFC02C4AF0B
	for <kvm@vger.kernel.org>; Sat,  6 Jul 2024 17:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720286359;
	bh=tYn5Sw8hpOhEsfNvGbB77T/02+KRTpwefKDVCjWbFWs=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=oLoxw01dwFPq3EK8r1gUm/MIm9chcIuIUjp7Q1q2s/SS/fSnYLILRZarQnv+hxJVM
	 lth+3bwF6dViP42Uu2DWxyLonkXIchR15ALhxoNcbNiCIITwvhWiZrcRMFjtkBuL4Z
	 zc0gCn74c8+/o+E6lcxPWtR0AAl4g07l6RzClGT7e83KZroTfO/31/5UYwSg01GeuL
	 wxrpwcky3VN4QCyguDvI64UdNGnQPeYxwMrCIdayRxWupFL+B9qG35j2DLAo+fn0rX
	 /NEOGTerC5tn4kn3QCVov+VJF3vOvYrRzqBGAvcT24/40u6oUhnaDotm5DN8RUUu0h
	 d0EKoex3hnreQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 9EEA7C53BB7; Sat,  6 Jul 2024 17:19:19 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219010] [REGRESSION][VFIO] kernel 6.9.7 causing qemu crash
 because of "Collect hot-reset devices to local buffer"
Date: Sat, 06 Jul 2024 17:19:19 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zaltys@natrix.lt
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219010-28872-7nnWxWVTff@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219010-28872@https.bugzilla.kernel.org/>
References: <bug-219010-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219010

--- Comment #1 from =C5=BDilvinas =C5=BDaltiena (zaltys@natrix.lt) ---
Additional information: passing NVIDIA GPU, Samsung NVMEs works, passing Fr=
esco
 FL1100 based USB card does not work. Fresco card is single VF device, but =
like
that sound card it does not report FLR. Reverting "vfio/pci: Collect hot-re=
set
devices to local buffer" allows to pass every mentioned device.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

