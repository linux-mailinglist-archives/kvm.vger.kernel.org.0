Return-Path: <kvm+bounces-23828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9890894E807
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 09:45:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB7CB1C21A7A
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 07:45:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41FF015C12B;
	Mon, 12 Aug 2024 07:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Un6ABQ1P"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3D81474D3
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 07:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723448670; cv=none; b=RbGPcv9YPhrSuTZNllICoajVNtVDiC9Zh1ImdoBtTMPlmM6WjBlFHmAkcnVoEYqhGkYQ4Ru9FV7HCcr/DU08FZ66BJB7kOxaIddklHuCMNawk1XD81tmlXGHBF3rFHUx9PnDPIw8UU51EVFYVE7BwcVoK9XwZxqgRHNFYa3Oo3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723448670; c=relaxed/simple;
	bh=UN36u2CCIUhdcPoYEE+SJrlCY0PaRFm9MSEC5NpXl24=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fEy5FL6s1BYPGECHuAa66UAkIwqHtuhA7SjFr6GtWoa5gj6fUAFdQPXO1abMUuxlJdDSqUcwdzQBHHGhd8xAgPmQy0fl2jK9pk2RXI58HcyH5FZ06pCMhUw36uOLb+pKIVTb+eFAhdLgm3i1EDyE3vuhuki+hdFnxPRyblGe7hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Un6ABQ1P; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id F190BC4AF0F
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 07:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723448670;
	bh=UN36u2CCIUhdcPoYEE+SJrlCY0PaRFm9MSEC5NpXl24=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Un6ABQ1P3rCjObpmxkq5rnV1AotkQaPIdBWhpD3Yvb6r72Bsa55XdKgQlHW4NsFJW
	 GuWCWA/wMMQshMeg+W4o2Y1TXW5dpmOedV6QhU9A9P7kWHKrwSYOR49N4iJFEN3p8D
	 WN8DEh7TdJ1WZa+YpKrFtLsS/IK12ToAwnvTHBGGe+uEeVnO89pNIcL+lnncA/t6ZF
	 iQiNJ2fw2F5jbWS1mgvYenZEkluwwbvLEYIUAebUlY6IIugtg0TC/oxeogC9EQ0fON
	 OteOk8L6jY3Re6lE59ND3FTdZZ5h8p7YmCF3+Bww21G5t/KOlTICQeX2E31RUODIgV
	 1rjEvwv4tUaIw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id E424FC53B73; Mon, 12 Aug 2024 07:44:29 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219085] kvm_spurious_fault in L1 when running a nested kvm
 instance on AMD Opteron_G5_qemu L0
Date: Mon, 12 Aug 2024 07:44:29 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: ununpta@mailto.plus
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: INVALID
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_status resolution
Message-ID: <bug-219085-28872-1OLqhp45hG@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219085-28872@https.bugzilla.kernel.org/>
References: <bug-219085-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219085

ununpta@mailto.plus changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |INVALID

--- Comment #6 from ununpta@mailto.plus ---
Closed as invalid since it is a qemu bug.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

