Return-Path: <kvm+bounces-44517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C82CCA9E538
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 02:00:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F05223B9C51
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 00:00:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BB8F1D6AA;
	Mon, 28 Apr 2025 00:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KqEL1xKE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446C43595C
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 00:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745798432; cv=none; b=EwcdyUxkPcA8xc2Y5FKypcSqKBG1vG8JO/SjvDCE6sdNuMOW1qwhAyJxH2BfkX4UPZ9dhTh6lgUPsJWoaIFF9SbeZfLdGMqn23TOi0EaDqlinix0PXgvglR6no6Aq5KpEHi247KkPxoAjwBP/jrHdquzlCh+ttQ9OdSqePnAdvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745798432; c=relaxed/simple;
	bh=qt7iC51hj41j0oimeo4+W+Pz/DtSRa23wlhspJmaEos=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ophJAn9UPVir7YdJdBEOMdNepQS/AmnquRLVyarC8S8vlsf4Ej7LHG1ZNccLeyQt77mqDgMkjgQDGslAE4WSURMFu1ysRN4ceMGZd0cNUuifyzFDU+VKid5u+i0SgxelHHt1peoNnHSAqHdnhK4eSDRcZWgEXtVtYw3D7n1+8L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KqEL1xKE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id AD334C4CEEF
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 00:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745798431;
	bh=qt7iC51hj41j0oimeo4+W+Pz/DtSRa23wlhspJmaEos=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=KqEL1xKEg/dh5HWb/EZsoATrzK8SX9dCxt4PV1hHhPAOXKUlWVMUjG38S66zMP7Er
	 Zxfl2D3IneV2LIYDtVgOswe/cNkICRRP61iIcRYRQpjUplEcQuMOy9NWOHE0KjCxzR
	 KC+G/xM0K1hwhFNo2YcGo+HkDN4e/cp3+ZvAukSlvWJ0mt+sRABoNTGsFvYtE7T7so
	 AlYiNzkzMz0J5xKn5h+XnZgQpp18r1u+o+Vcjd+wODYgrRdZr+1cdljGCCuWP8lTtJ
	 GhTgGYRr3D9/kCniPEndHfBH1VD/CDL2D0B5CKN/cCFt79vOnW7YPEepk9RMwQ5c+m
	 Bwa1IwC1OROSQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id A0CCEC53BBF; Mon, 28 Apr 2025 00:00:31 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Mon, 28 Apr 2025 00:00:31 +0000
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
Message-ID: <bug-220057-28872-dVmCooPto5@https.bugzilla.kernel.org/>
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

--- Comment #3 from Alex Williamson (alex.williamson@redhat.com) ---
https://github.com/torvalds/linux/commit/09dfc8a5f2ce897005a94bf66cca4f91e4=
e03700

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

