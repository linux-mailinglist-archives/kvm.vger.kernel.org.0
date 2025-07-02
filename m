Return-Path: <kvm+bounces-51275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AF2FBAF0EC9
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 11:05:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E6114E51E5
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 09:05:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD98923D2B3;
	Wed,  2 Jul 2025 09:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KkSjUOq9"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E7D23C4F8
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 09:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751447108; cv=none; b=JgssxTVEt2/9xLVhzJGcay1CzAijIsU5wynenAbalIdQ2eqNtXdqhaVYYAa3/hK9/vSf3xJOVKmHiG0OHffpLaD85NzIzVF3quRZCBI2vXWaAL47M1c8z4zqxA0CenE8cIAct4RStellJS/5hO4XjF4WjDKRkkZl02NjY7MqxOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751447108; c=relaxed/simple;
	bh=KKswsMvpHdV1t/EAQ5y3wMktmyBAL1xtFXc215wpAvY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YsxynlwbXtIIzP/SMt2KlBfZ+g7dV4fva9/VIwnLFyHqsFSuITS5GaBW6Ug3oTEM74JNdiLDvhy3+NOy9AGrEvxStJn7UFS3hmIIksVtdywzkpAuEDZSsmrZ4UvtiSRBtcCkV/8Gv0+EL2fw6RdZOxOyyNw1l5PnBHrcG7KAnKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KkSjUOq9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6F66CC4CEF6
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 09:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751447107;
	bh=KKswsMvpHdV1t/EAQ5y3wMktmyBAL1xtFXc215wpAvY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=KkSjUOq9lyKUz9+OknOURIoYlccRWt5wGOsgwe8uegRpLccd2WAs9MVXflamX7fxG
	 gUibTJ1kKf1mpFcf4ogMJmSLXoi0ULm+yPTlvNOIBVrXhe+rfH+jO4s7w7Vo6NkFdP
	 mXaEzoRjI13z2g3p6uavhuwkKOw/zH6rkxghGsMAZjPINtbrCWkl1DYZd/K2cJQwp2
	 NdgNxkJwos9D7HydgkMQOiAlbvte92Si3Gl3NS9xfVzx19Wo9kVf9+UEqm61T5fbo1
	 Nl1wofV7wligsqujWUTf//Mu31KD6vhpo+jvV81BU/SKQQx+BUFfRmMVdicGUKsj9k
	 3s9lY5OoWy/rw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 68BC7C433E1; Wed,  2 Jul 2025 09:05:07 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219787] Guest's applications crash with EXCEPTION_SINGLE_STEP
 (0x80000004)
Date: Wed, 02 Jul 2025 09:05:06 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: maps@knutsson.it
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219787-28872-rwucD0njze@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219787-28872@https.bugzilla.kernel.org/>
References: <bug-219787-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219787

--- Comment #21 from Brian (maps@knutsson.it) ---
How can I still have the problem on Ubuntu 6.14.0-22-generic with VMware
Workstation and VirtualBox?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

