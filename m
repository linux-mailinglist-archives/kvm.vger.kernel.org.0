Return-Path: <kvm+bounces-20371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F3E6F91436C
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 09:17:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A9ED21F24156
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 07:17:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03EFE3C099;
	Mon, 24 Jun 2024 07:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UzI4bQWa"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6A0381B1
	for <kvm@vger.kernel.org>; Mon, 24 Jun 2024 07:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719213420; cv=none; b=Q485e8F3UNqmZFOYVv7cZQBRx2gU0R35WH4MjJPw6eDJpE+pSKaZDDOsLzwCAPBAuHe9COaJdYpPTmuKxFFDEouLMwPmqo2Myov1/ynrpl4UYTBB0It7AKoNC25ELa5MM5G3QWOTEz4vuab/25TYxB60JBBCpHywe23xZQko2Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719213420; c=relaxed/simple;
	bh=xLXRqMHtTJplrNTM4G72ikgB7r/JLCZ3tnpY5j0npaU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mwvV9OYXM7QgYW7Bo06JntHrn4WJE+LaJz7rbRszrWWLHgtWJNIPoqJ21/COQznAB4mxYC1Wo4uDC7oA0kH+AX9VPO5aK7fR0dRs86tVJNYyq/n1DZTZHgiq38g/dnbgAXT72TiJ1Ce8ZpcBPXx8r8L2NE6KdQFOdrpchAnSFgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UzI4bQWa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 979E1C4AF09
	for <kvm@vger.kernel.org>; Mon, 24 Jun 2024 07:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719213419;
	bh=xLXRqMHtTJplrNTM4G72ikgB7r/JLCZ3tnpY5j0npaU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=UzI4bQWactX3dXMbpSGEFg+tcDmy5Qp1ig+GeVME6Ljeh25CC0gIpTwgAYhzX8Xfx
	 Unub5nzsN5BCi/1bevpxBMj3T/uJQ+VQbrL3pObuwsL3I8v1T0hPxDZc8EM6mvwdfH
	 dSKmr8wQOmPcnZX/xZ1/qG+AngXAhUwtYwQfBCn8dx/yOLYx5YOowedNRUUlaTOVHJ
	 hcSFnLGRhbLNwzPC02oaLR9KAs74t5TYs1qkS3RnYKWGWZ6JUcwK1CKC7LrlnaEiRQ
	 zBxkNZoSKYuw1l7Rn1BlBBuNYuNsfwjgigApgfx1/qLMlMH+XZqEcqk9vQWkRk/XsV
	 vFlDLSoOUehoA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 7B0E8C53BB8; Mon, 24 Jun 2024 07:16:59 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218980] [VM boot] Guest Kernel hit BUG: kernel NULL pointer
 dereference, address: 0000000000000010 and WARNING: CPU: 0 PID: 218 at
 arch/x86/kernel/fpu/core.c:57 x86_task_fpu+0x17/0x20
Date: Mon, 24 Jun 2024 07:16:59 +0000
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
Message-ID: <bug-218980-28872-A9FOtw9Uo8@https.bugzilla.kernel.org/>
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

--- Comment #3 from hongyuni (hongyu.ning@intel.com) ---
Created attachment 306488
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D306488&action=3Dedit
Call_Trace_decoded.log

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

