Return-Path: <kvm+bounces-20585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 615D1919DED
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 05:41:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 023F41F21FB0
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 03:41:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BF311798F;
	Thu, 27 Jun 2024 03:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MWA0mdYJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CF0291E
	for <kvm@vger.kernel.org>; Thu, 27 Jun 2024 03:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719459668; cv=none; b=UowSqECQngDOQjfxH+Hb0pOuuyVYXeUewq0qqKk6pOhUmX8bEMrs4SA5+hmSo0a6NwJ+9rHN2U2V1oEKfQk0b8o9xITWIVatyKs4aPKYgpNJqJUfExzIxysK2FyL7R23luCbHDVF1QDibBTwUTBIhXEb1Na3CUnLtJvnvC6SnOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719459668; c=relaxed/simple;
	bh=D9P1QYc/B2P3PVhld9XPAgCLi9YLKRmEcTqIV24sUTA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fKdHXLcdKbYIVsv2VEdtHfY6sp1Htg986cQB+wZoX5gp5HZ/LTtlRxX7zRemNOX5rFFHQSjZJ5vsImikUG3Pr0uHKT/9/pXjQt3KKGkkQaRj85Ns7n2a9puy3/27fmvo8AOrpSlgb5Huhht48eUn+ikSN3imXdRuDSaObpEO1YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MWA0mdYJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id D108CC4AF07
	for <kvm@vger.kernel.org>; Thu, 27 Jun 2024 03:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719459667;
	bh=D9P1QYc/B2P3PVhld9XPAgCLi9YLKRmEcTqIV24sUTA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=MWA0mdYJxv50URDQgyBmhr//QpG1moRQ/wonxcg5LAn1RdjB+vtXdCWOR5tDpuUmR
	 6Dwd3uBAscto21dEtoAIJ9p8PIVK1m23QqtnZk+0vbCrODc/j0Yay1L+0JM5opo3B3
	 6gyqTvTPdF+uS8rp5RuNpRHBxStkvZPsm2mSS9ZvuKkoRGI4fdpbph0Rlwwelj9Bg9
	 +cMmvgziVThPD0LHz+BnIwRh44nlRg22MDOzGgIWVnXWkvNkG/EmAzsIqE4t/6kNGE
	 VUeODM81I3v6S21CTboEjulh6L7xfOdsOhjQmnf7yGGvPNCXSkHF6s+gbfzLiHazIL
	 GAg0TBOOTB7CQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id B1F76C53BB8; Thu, 27 Jun 2024 03:41:07 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218980] [VM boot] Guest Kernel hit BUG: kernel NULL pointer
 dereference, address: 0000000000000010 and WARNING: CPU: 0 PID: 218 at
 arch/x86/kernel/fpu/core.c:57 x86_task_fpu+0x17/0x20
Date: Thu, 27 Jun 2024 03:41:07 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218980-28872-4OHNzilOjt@https.bugzilla.kernel.org/>
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

--- Comment #4 from hongyuni (hongyu.ning@intel.com) ---
Quick update: issue won't be reproduced if disable kconfig option
CONFIG_X86_DEBUG_FPU, hopefully it could narrow down the regression issue to
CONFIG_X86_DEBUG_FPU related code.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

