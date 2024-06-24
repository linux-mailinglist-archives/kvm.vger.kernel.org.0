Return-Path: <kvm+bounces-20362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D32839142F5
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 08:44:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 089E01C22014
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 06:44:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 074D444361;
	Mon, 24 Jun 2024 06:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ryg1saf8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318193F9FC
	for <kvm@vger.kernel.org>; Mon, 24 Jun 2024 06:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719211491; cv=none; b=my8jZOx8ZaCQ+IhyQv7D1piYUpgXFsviQQUaFDBqk38uZoo8w+Y68A56t37nDyMxHf+dfERX/7IpHF2boo3M5rI82qkC1/TpPWDr5CgCgXnHbAnECkPgsfcvlQbwcn+k9Or9G0ebMUR+DkHwOqR3zW0yCrCbcNy4LHxE6QPbEUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719211491; c=relaxed/simple;
	bh=FIjttnVCN/+cyqeDAOXlwq4dR4RJtGK617Q1vxRRKYE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=o1qPy5ByEg2G1a2t0hDZmkjp5X+FipnyiT6ePRFwN6O3fo5QadAiuL67JkQtTNshaMGwB0301nsBbaDU1NycptZchL/mTl8BNJtQfQZnGHhQz3esjs3xfv55cnAronL6+1j7yifgFMPBfNLHXi2oNG5MSp9+5KvpIa+CpSW01LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ryg1saf8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id D1D3EC32789
	for <kvm@vger.kernel.org>; Mon, 24 Jun 2024 06:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719211490;
	bh=FIjttnVCN/+cyqeDAOXlwq4dR4RJtGK617Q1vxRRKYE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ryg1saf88mH7pAvslvpANApmKVTK6FItPd/rPilgR3KyizOEqx28UuOlQsf2WV2fl
	 PLIZvdGuXpq/sEZK36Bxlu49lWFGKd+Irq60GbOKaQyrFtHRUwAUq8FcLtICuUvVkR
	 bcvFhe0Zu5TysUsuAI9GM7c83gaKY0CGABieLRfBANsN4R98oidQPVi8L6p357LEi5
	 mZcSaC1HNlfoJ8VVaHSQfmlr0UNjxNpL2DSk4M2al4OKfwCkuEdmMPNpxe9T8ZnKZ3
	 /9p0ov/xncMzqi9aVZQm8cc/lze3yGCFAlfAcclqs+xG2R2qWk953s2+cR6oUC26N3
	 WjO1tycS46DBA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id CB10BC53B7E; Mon, 24 Jun 2024 06:44:50 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218980] [VM boot] Guest Kernel hit BUG: kernel NULL pointer
 dereference, address: 0000000000000010 and WARNING: CPU: 0 PID: 218 at
 arch/x86/kernel/fpu/core.c:57 x86_task_fpu+0x17/0x20
Date: Mon, 24 Jun 2024 06:44:50 +0000
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
Message-ID: <bug-218980-28872-wO8Ra586yq@https.bugzilla.kernel.org/>
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

--- Comment #2 from hongyuni (hongyu.ning@intel.com) ---
Created attachment 306487
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D306487&action=3Dedit
vm_boot_pass.log

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

