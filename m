Return-Path: <kvm+bounces-61942-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0877DC2F65B
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 06:48:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 716294E9C5F
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 05:48:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1869E256C83;
	Tue,  4 Nov 2025 05:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lGajq/pR"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A2534D3B0
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 05:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762235288; cv=none; b=u3n6i/Ok8LnnKmn8AnJQ/VrQoWhzNBDxI/ypxMvHCWufMj6GvrqWtvWxxy6boLZld/CNQGfzXf1XYqRS5BQ4/B6C+WsZpk/z5zatb8s0ptCjGCOyfoh/NDFwQ4tjOK3nRn+56v8XNRUYnCaJzULQwhuPkJRAA3BekSsKcHfGfLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762235288; c=relaxed/simple;
	bh=X4LI7yf6sD2ps/QAeDhL05CIbu7CPKznQcEKtm93V4E=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Zet9VqJfVvyT1IqWUczqBlPQYO4PE9A93dzxaepRR48ODVRID6dPWhvWYrNRHVF6cRxhhPDj5efcOlI9URMyQ2OHlQpKrpBG299byeTP523rxwoIbWUoqtwd8GrSywYstMx+WZWMftMm0m2RNXfZUloH0Q1UT24jQ7cLLpwV38A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lGajq/pR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id B7583C19424
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 05:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762235287;
	bh=X4LI7yf6sD2ps/QAeDhL05CIbu7CPKznQcEKtm93V4E=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=lGajq/pRWXbw7HA3ERF8k7BxzzWdHuQEJ+eG2AWlcRklXwpzwXaz2CEN2Rm6+KajH
	 ssM2gSW8V7A0pHNXyF34bxcqtnZyICZHJkB0qGMRATGHTdis1l0JlyHYt+MERvpwS8
	 THhTCIQKwrtrb/k3qNF021RRQ5yx7xkrGWkgK4VfosWuGI89qvihCcYnzTAwCGm9fm
	 xhczBnlHYgTVjDyoD9Cb50oQjVuvpSKvy1MkvgUc7Iv+5OwfYmFK/BI658ENpWMbmZ
	 Q57+0NljG+vFTEVUcRcM7zFkLSra05oxXJe5ZXvhRaTY5xxY5Md10M4YKkvzHs3BGi
	 TTm2K5RxRXdXQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id B04A2C53BC5; Tue,  4 Nov 2025 05:48:07 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220740] Host crash when do PF passthrough to KVM guest with
 some devices
Date: Tue, 04 Nov 2025 05:48:07 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: farrah.chen@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-220740-28872-5DHQIQxpsF@https.bugzilla.kernel.org/>
In-Reply-To: <bug-220740-28872@https.bugzilla.kernel.org/>
References: <bug-220740-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220740

--- Comment #3 from Chen, Fan (farrah.chen@intel.com) ---
Created attachment 308890
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D308890&action=3Dedit
Kconfig-vfio

.config of my kernel attached

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

