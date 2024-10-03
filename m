Return-Path: <kvm+bounces-27850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A69198F210
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 17:03:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C3AC1C21143
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 15:03:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD6E21A01BD;
	Thu,  3 Oct 2024 15:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KwnLYfwW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C501865EB
	for <kvm@vger.kernel.org>; Thu,  3 Oct 2024 15:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727967821; cv=none; b=ZKp4U3IpZnyERNpfiLw0h2tkc/5krSpuzwsEK3aAjFBAyrw1gjXp5wSskaWKPUI0kucBTm8r3ZlucJEG5Ssxl4vmcmkDaBGum4rZYhvlNK62itISIQWXk6JQpMdOTqhb+HtqJqOoYTy0Tv5egvDD6nr4cFnR1GR/vdgujS+ELFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727967821; c=relaxed/simple;
	bh=kVs43RnyqR42Gf2RuFUcLebTC2KbGB6ExBhJZT9g8EI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=a3jrsnB9Yv2JqesqZysLYjaN289p3tLbwnbYt+ugp/GnZ3xMYW6Ew38hUqNpvZYaM6cliE68GhEmCLCmra5c5V5XEKPBQiqcvU/TVcN1a45Zkm3WObEEp9K8Kt+StHy9NI71C44xVkeISWpG4Yf5BTA0GyYRO7S43p+gQ6msGJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KwnLYfwW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7372CC4CED4
	for <kvm@vger.kernel.org>; Thu,  3 Oct 2024 15:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727967820;
	bh=kVs43RnyqR42Gf2RuFUcLebTC2KbGB6ExBhJZT9g8EI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=KwnLYfwWkji91DbDUcdePX8kL8mCSjK1RvGE8iel/M/PzYY0ialPeYlGBY8YAnoQ1
	 JtATQIYRFByDxgyJs+Qo2slRJtGEmd7RFE4lWlLMZeolza/0LZNhkwtz1buuVbPN3v
	 /SUoBKMfmCdr2Ne3TByhhPryjZasbMpCGhYwoZw2yB/v7XX/sQOc4ma0D8fLzq59Dh
	 All1YR3BPPPpgnWwRaoqMuX0TUa//ShSuLK+YTerUnmJ/cMhAyrot9uLV27WLpW4/K
	 EDLqBnnRiJmdyTmNmNvrqMJaBhk3Fh66hAhRzRiP0qAKDy0N/nWilhol0DAJHy8iF5
	 koaxw2iObOEtQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 6BD0BC53BC7; Thu,  3 Oct 2024 15:03:40 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Thu, 03 Oct 2024 15:03:39 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: mlevitsk@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-219009-28872-TjVqZvZYyt@https.bugzilla.kernel.org/>
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

mlevitsk@redhat.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |mlevitsk@redhat.com

--- Comment #21 from mlevitsk@redhat.com ---
Nope, these are not related, but do check if disabling AVIC helps (set
enable_avic parameter of kvm_amd to 0)

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

