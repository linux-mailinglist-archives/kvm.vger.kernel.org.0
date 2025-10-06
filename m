Return-Path: <kvm+bounces-59518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8260ABBD608
	for <lists+kvm@lfdr.de>; Mon, 06 Oct 2025 10:46:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1DA381891E48
	for <lists+kvm@lfdr.de>; Mon,  6 Oct 2025 08:46:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1D0125F988;
	Mon,  6 Oct 2025 08:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V5/v0KBT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A6E1DE8BE
	for <kvm@vger.kernel.org>; Mon,  6 Oct 2025 08:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759740371; cv=none; b=APzqpgPC6tL+frdRY2CnktR+uC7NwVIlNDH6BDusX4orocjTNiVgi+MjvpW7d0IZVuEnUVdNIY1JenPdwzyOAcstb33qDRYRRnNa26vI4gR5ymLW6SYFRf6b/VJZjeJOlMpL8aQG+oozFwwl7/GchLn6S49mFNBCiatRxeaZOKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759740371; c=relaxed/simple;
	bh=y4xBmH2bOJV9sJTLayPDkD935oRlKxYiBeS3g/c1JVg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Je2ZJer80s35rXvsnP3Ww0wNfrQcKB8wgSTxuoxz9FEBq0pdepaj50Alk6nKxC8atf+SWHhgzkXVu1v1vp24+uTp1uS3hRgBIAHRXgPCdRf0G7bHtHTWDF+Oy+NUPFEF/YhvQwscm+QRULrD5+183xKMBI2TwrIk+ADsi8OoGcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V5/v0KBT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7F673C113D0
	for <kvm@vger.kernel.org>; Mon,  6 Oct 2025 08:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759740366;
	bh=y4xBmH2bOJV9sJTLayPDkD935oRlKxYiBeS3g/c1JVg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=V5/v0KBTlExNbMdvSBmeThBeTQo6uVz7gHb0QQPCcJPdYojuFPwq2O22g3GtcpIlC
	 M5xRExFjODbPRH3KnKlRrprDUb9fCEEQd1WcYIlHWJYqfzP8wttr3Ko5rtkz5p7U64
	 QugKftTAZwzMkvtrgn03OkyvugwzD7pCjpsK2sEUnw4r76fd9yytLsX72jDOi+rcHO
	 mIpnkF5bzDPAJbG3QKMsHTm5Ax0G9C2UvInHYnRa2hQYUWsttef9Ri0Pn+8xTbzjSN
	 JfUaQvuuj1BOhjzFWJGmCBin3AB22cVMvlWs0jBrL/KuKiRKQN2tkWyEml767pbP/u
	 LNv2YcjhQzgtg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 79164C433E1; Mon,  6 Oct 2025 08:46:06 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220631] kernel crash in kvm_intel module on Xeon Silver 4314s
Date: Mon, 06 Oct 2025 08:46:06 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: f.gruenbichler@proxmox.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-220631-28872-7vZyTTsEEB@https.bugzilla.kernel.org/>
In-Reply-To: <bug-220631-28872@https.bugzilla.kernel.org/>
References: <bug-220631-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220631

--- Comment #1 from Fabian Gr=C3=BCnbichler (f.gruenbichler@proxmox.com) ---
Created attachment 308755
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D308755&action=3Dedit
dmesg with kvm_intel.dump_invalid_vmcs=3D1

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

