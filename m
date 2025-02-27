Return-Path: <kvm+bounces-39574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B700A47F32
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 14:32:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD341188E962
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 13:28:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84A2623027C;
	Thu, 27 Feb 2025 13:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UL/zzBUq"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF03522CBF5
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 13:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740662799; cv=none; b=FWCPS7GLvCfF76SyI68IxV0d73EJdwbvzuvK/lqbvtF7mzzXZUcE6m8CiCOQbzXfXRmaXUfJeR6TwqdsU1lvy7XHGtUlFMwLAM0VVzt0lPAWwEE+aoSsns3LVo+uoOJCTjlSMH3q3nbdWcS4+qkMvnDhAYSxNSNkb7BLuO4hSWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740662799; c=relaxed/simple;
	bh=v8OzljkzdEztVBDsq2Qj9ptsJwrSvZcjmvGNHa1l8+8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=l/FdBzkjCBVsnT+bxb2IROGKJi+2+26ly0kEW8wvDeDPIm6fX+EbewbjDhTtckuQM8QimB2OGea9Uk0EuodBy/O0RQb1ClJ+P4I7RpRhfhsyhAgL72GwDoDBVclyuLqKO8OVffNoczqFgM8WPCU1p89pol2pwKYlA5utyIP7dE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UL/zzBUq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2B662C4CEDD
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 13:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740662799;
	bh=v8OzljkzdEztVBDsq2Qj9ptsJwrSvZcjmvGNHa1l8+8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=UL/zzBUq8oMiCW6DNyFA+nVJB/xGaA3s3qJcSF1ocxD0LgCShOCehuEDNY1Ih1vvc
	 NM9cQ9uRd8MTVF3c1jl74r0UlCvdG/YC3hScureVXU+YZcBY13F72n91ef7IbCR7ve
	 wCH6EjKJ2np9RQBW5X0HCtX2szBCLF472KxhACgJP252WfnRrH2dgdY9HsCyxBexk4
	 1hCB8Leq8ge/qqBJd6RndW/3eWWzBgNoMVmtFohd/2XftigRV64ql+7jomAnibhTXL
	 XQ8YJMjDiPY7S/KhMP7NHHk8ZRA09V6/U5CwizELYmDCMzQwoOeIT0qMKSETqOpB3B
	 bo8+hyFgqu/4g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 1D479C433E1; Thu, 27 Feb 2025 13:26:38 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Thu, 27 Feb 2025 13:26:17 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: michal.litwinczuk@op.pl
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219009-28872-ieWV3xJChV@https.bugzilla.kernel.org/>
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

--- Comment #50 from h4ck3r (michal.litwinczuk@op.pl) ---
(In reply to Christian Haefeli from comment #49)

They should at least announce that issue globally.
I got new cpu specifficly for nested virt workloads.
Turns out - that "patch" makes it so windows can't use nested virt.
Its complaining about missing features.

Bigger issue - windows does not have patch applied afaik.
This means that win host with hyperv enabled can crash anytime.

Back to linux - disabling vls does have performance penalty around 10-20% as
far as i tested.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

