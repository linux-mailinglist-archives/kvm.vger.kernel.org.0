Return-Path: <kvm+bounces-7702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 832DB8458A1
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 14:15:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 22B2A1F27F82
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 13:15:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5154C5336D;
	Thu,  1 Feb 2024 13:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d5agUdta"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780A88663B
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 13:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706793345; cv=none; b=e3ScytN0D0KtdZYpGCofC6/q3KC5/Gd8VEN95w9ZhT6+VD3nNMQ0y21ne7oWfHN9lsFpBgBvY9b70ErjF/IER1U/DYWxUdQyzAb7TEbPa2No875SRFt7bMSrlwM0inrQf21ASyy5jCtPakd4a+yJER3vyPBhWStpJI1HRShBiSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706793345; c=relaxed/simple;
	bh=95Al4M4zzYYWgDMNKKLIKfN2s5dioAEvN0pvFJtyDLc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jQ3QS4b39H/tVIag5Q14kvv/KSM2scDcK/aOEsNjzP74U8uiLRxNSq8xhnZ3wdButQoHjYF29MAit5ed2qLf+Io3jYXMSo2/PHiySrpVagHIHm5IuK572udq/l8OXCqwuYBiod227tv4d4qJMexjoD9d4vsKhCixBWapAd+Jf2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d5agUdta; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id E6821C43609
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 13:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706793344;
	bh=95Al4M4zzYYWgDMNKKLIKfN2s5dioAEvN0pvFJtyDLc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=d5agUdtaW/93mP+VkuaaxYKmlzhJQIEbpoHQaAe7ZRzwHLXaUQqV1bJXeOz0HtlBp
	 /GR2x7HUDMEiz2gbTTYuWutUYoT2e6hVE2TpULoUg8ovsZUxO1w3QNXcjFxMTBb9RX
	 /HASzKb66c6S6R1LvfZ+UYiCTTNdKbwZ8wfPsW2NiiEqu+BKJgOeRvaYplovpCCUGV
	 e3oBDDIyq2EeqE62vpRF7RbCphG+2nXn2J7/6zsvp/jZeg0+SkcTdRpzCgG+wVfNxF
	 vmgdfyslrGK9NgqDPRPPI0jECcVAalpcjc6N6oOUlTyaISCPsPk8mBsOBfSpjYwq7l
	 lpkRwcR+Zv2Kg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id D750DC53BC6; Thu,  1 Feb 2024 13:15:44 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 199727] CPU freezes in KVM guests during high IO load on host
Date: Thu, 01 Feb 2024 13:15:44 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: mgabriel@inett.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-199727-28872-7mN4dUss0U@https.bugzilla.kernel.org/>
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

--- Comment #20 from Marco Gabriel (mgabriel@inett.de) ---
Thanks to all, especially Robert, Stefan and Gergely for this exhaustive bug
research.

Please keep this ticket open as this problem still persists in Proxmox 8.x =
with
kernel 6.5 and it seems to get worse.

Thanks to all,
Marco

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

