Return-Path: <kvm+bounces-20361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 701749142F1
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 08:44:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 26C341F239B5
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 06:44:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A30938DD4;
	Mon, 24 Jun 2024 06:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q9ai25Ok"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7DA23746
	for <kvm@vger.kernel.org>; Mon, 24 Jun 2024 06:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719211463; cv=none; b=XvHJKK7FtnzSuExpT7hPrgBGexB4/pxnUjxFEFjhD7jy2ziYHqQHn2+denIj9S9vSrzhq2+bNj0tzoxLCZB/zWjf787br47K186wc9epEmJiP4kqm3keEIMXUW0bBD9deEpX8hvybzgnQwcfxHeiiOoIfFa/VciwN77aEUmDaT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719211463; c=relaxed/simple;
	bh=3qQHV4B42pzkYOpJP/rK5Nu3XE8vTrtSeyCS4yWyOsc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=U2eFs4WnItClDMUs2PHNr6h3gD3oc1H5zv1+rCpm1P9oT1z38C3ti7xgtpgX/7EF518T4ROxt+2rEMUTu8mbnHzcEPkV13JxCXx8RlHku5Zwvq5zMKDjMdFirVcuTzk6OepDTd7S8lCWjgzpgrDqjW+bnBx7RBGI4xoo9Va3rKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q9ai25Ok; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id CB78CC32782
	for <kvm@vger.kernel.org>; Mon, 24 Jun 2024 06:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719211462;
	bh=3qQHV4B42pzkYOpJP/rK5Nu3XE8vTrtSeyCS4yWyOsc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Q9ai25OkGK7dRLQYgZnT7csjZLfo8R5V8rJVAI0df+PrXIL9JXsXFBKMGT7VQZlCy
	 /lGwKYmIajLIR2DtfFFlVGfa7SZHeJS33rOiTUqmuXXh1txCbSVMd7XN6pl/ZUrLom
	 Azj4EfSot0eEQSdSnAhAWwStw0OP7eXKjVGaKXYS/zmEiQPs7bbc22yfp4DMSki9kh
	 B0zMoHHZxi2hDRApEzIOy0ewlAL5qWRlURAO31k2PrVI5XIdAun4A8aNwXns5AfODT
	 txQ5EaxkrZirTHwJnrGUFrAkXS5ag25BBCEzEqN0QsdeOMcC4jHy0SrA4a7nnplLNg
	 U0gnx3odsOmnQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id C4C8AC53B7E; Mon, 24 Jun 2024 06:44:22 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218980] [VM boot] Guest Kernel hit BUG: kernel NULL pointer
 dereference, address: 0000000000000010 and WARNING: CPU: 0 PID: 218 at
 arch/x86/kernel/fpu/core.c:57 x86_task_fpu+0x17/0x20
Date: Mon, 24 Jun 2024 06:44:22 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: hongyu.ning@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-218980-28872-iBoBkp0OIf@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218980-28872@https.bugzilla.kernel.org/>
References: <bug-218980-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218980

--- Comment #1 from hongyuni (hongyu.ning@intel.com) ---
Created attachment 306486
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D306486&action=3Dedit
guest kernel kconfig

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

