Return-Path: <kvm+bounces-44582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 556E3A9F41C
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 17:10:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B5713B818A
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 15:09:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1990727979D;
	Mon, 28 Apr 2025 15:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mecAt24T"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C56127978F
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 15:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745853007; cv=none; b=K2v/dEkd1K55eAPJVjKX2qgpskKoU4Bw+Q0sId3ZY1Vd8gRXKxjwWn6T0KIWYLptnDCtDGcu3cRuqPAm8fnvADCNbUkCf9QWnie5kYurt0A73iIQB6zWYHZ9dJ9/JlnDWmZgADuUTOALZEmFl/NZhiQix7ArxuSjF5/g+EWL8l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745853007; c=relaxed/simple;
	bh=T86KxSdfruNeE7iGAj5AONml49hUexAVMFx/mLrqgtg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Qf8xApdZY1L05CV76iZM046lXhNfM4ACa+Hto96wADu7B7sAI424l0r/zkcgcD0qSN7n4KxQWqGAiZkXWu0MufhximpMp8cHMzMpYm8uxyOJ+Rs4ecdatQT8pJ608EVelOV3YNgQmnxX6IwRTfvkI7gJqQ2GoxXQbyalSGF8E9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mecAt24T; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 17C73C4CEED
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 15:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745853007;
	bh=T86KxSdfruNeE7iGAj5AONml49hUexAVMFx/mLrqgtg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=mecAt24TpocTpZBiccbzM3h73MgxsyeaGE7hJldo1CPPjWcXYxJU2iyVTeYD/gc79
	 V28Q7C0iK8GGaGx64q/9DYYfu/feLMfkjVbqlj5tBdZsHwszOB1mnjBAHcwxnnP43w
	 s2HFab+XZYqDySX7sI8tt/NUmJgke+SQH82eSGcwvVDmLhaQNZAkCunV6lCNXdX4d2
	 51dSSaEytO7bkzDhY0KLPtJVScJrbi3MDyza2Y6FyS9H7dp+eZLEYtubryo8Yusm/h
	 +Upm/V9lINZEK3Gwh3U83aX63fAUVWi0CGZT6wpwubC4XEZPmoPpmpuvSl5WbXQwXE
	 CtdG8+C4L3/tg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 0F3B4C53BC5; Mon, 28 Apr 2025 15:10:07 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Mon, 28 Apr 2025 15:10:06 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: alex.williamson@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-220057-28872-agbQ8b2niO@https.bugzilla.kernel.org/>
In-Reply-To: <bug-220057-28872@https.bugzilla.kernel.org/>
References: <bug-220057-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220057

--- Comment #6 from Alex Williamson (alex.williamson@redhat.com) ---
What's the VM configuration? The GPU assigned?  The host CPU?  The QEMU
version?  Is the guest using novueau or the nvidia driver?  Please link the
other report of this issue.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

