Return-Path: <kvm+bounces-32391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5550A9D66EF
	for <lists+kvm@lfdr.de>; Sat, 23 Nov 2024 02:06:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B373281EF4
	for <lists+kvm@lfdr.de>; Sat, 23 Nov 2024 01:06:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C093D530;
	Sat, 23 Nov 2024 01:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NsqC6ypi"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF16566A
	for <kvm@vger.kernel.org>; Sat, 23 Nov 2024 01:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732324004; cv=none; b=R1ab5GFsiQLzxqqpc1iHNkpTwKQ52FWR5S2FRwSZFJL06/5Budn/yvIUg0HvY1i/o0pGLpu/InJuNpllNTY4qVB7AgyMEIg1s/mQuRaupi2oibnfmDW1YeDQJNcUQXxw6encGL1slEbtXePpIGXepCjvK7yos7dWFEZRDSxhrsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732324004; c=relaxed/simple;
	bh=00nq9616afLsTQZCOsjyRQg6n6kCZoiA3x1P7O+/3yY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZHWEljhKuga8MzD9gvd0OMnJEK3pPoIQ73O1sEDzv+mElk7m0gjqcJrj7w4lmDhkG+25Taqt2DwttYqqwBwvsk95wVE9kYdwoDGL4eQS2OXzx3Gbad5HnvGIunZXIgjqPLp8G8CoMrhrpgy91lfA0TI/ke9hgcOqViZlIeb9TCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NsqC6ypi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4131DC4CEDC
	for <kvm@vger.kernel.org>; Sat, 23 Nov 2024 01:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732324004;
	bh=00nq9616afLsTQZCOsjyRQg6n6kCZoiA3x1P7O+/3yY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=NsqC6ypiJgsYR84CDNrPVkJvIQf946I1DKIcL+xNz6euCxQqEJ47oi1Ebao7yoEfF
	 TSVHqKcz69noARGFqtnYLVnL6PtUBM/W/zIaPElC/b7XyBEUjoDyfW15xEzrnpLZvm
	 duJGPbL7FximSISr4HJO8HV8XQZX6zDi1brG+5PnWaAjtbatmylywQEmUwJRUPenpB
	 F9xTUAwU46c/xkFVeQCy2YKqrd8E3MHmX0E/bYILwGwD2FVLIah5YIxDfVMb0eOG7c
	 ipBJU9EDC/bJz8g1/0hnstC1HpuD9IPjI0Jg06/6WBgu98zJURaZewK8jsNr7qXIeI
	 HPHqEl4K7TONA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 3B403C53BC7; Sat, 23 Nov 2024 01:06:44 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Sat, 23 Nov 2024 01:06:43 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: edtoml@gmail.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-219009-28872-OKX073MKc8@https.bugzilla.kernel.org/>
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

Ed Tomlinson (edtoml@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |edtoml@gmail.com

--- Comment #44 from Ed Tomlinson (edtoml@gmail.com) ---
I applied the patch for this errata on Saturday, seven days later no resets=
.  I
am not using VMs.  I do run Arch and their kernel is built with virtualizat=
ion
support and warns "kernel: Booting paravirtualized kernel on bare hardware"=
.=20
Wonder if somewhere in the kernel VMLOAD/VMSAVE gets used.  The closest I c=
ome
to running a VM is using an appimage.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

