Return-Path: <kvm+bounces-28156-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF38199594D
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 23:35:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C64C61C219F7
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 21:35:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1327212D2F;
	Tue,  8 Oct 2024 21:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qqxEWUkc"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022FC2AEFE
	for <kvm@vger.kernel.org>; Tue,  8 Oct 2024 21:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728423306; cv=none; b=ZA3BoGC048Dqp7eBTvgdr7l96PRe1GZcrGuuSfW14hazbS0B2VEzyThpgtyE7+hROGnTiATzsBebCjhpFdhnwvph6ypd2v3E8rDcfTsM/R/hjAbXBPVHDEfCQlVl5JvNqJRVxGQrGOqOc2+kkoMODSYpKDEcjm/ev23h4/f4lIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728423306; c=relaxed/simple;
	bh=m5BMcqwy3SqOXFBwLFk7fhpM47mCTk6T0xkUPZFwDuo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=c0Rwh6LOhL8bH8vDehRu51bwg3MNDr00B/ABDGaj5K1VwJ7ytLF2FTqj7qaya7UEkKtgph+HkuNtuimo+onc8SgWBi9rUGW1a4FU7YSucA/5em8Ednm8TCzSNSD3J9600CFohWc9ROu/R7Dk3cE3EHcEDMLVXRj+ttPiHWmJp4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qqxEWUkc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8CD6CC4CED3
	for <kvm@vger.kernel.org>; Tue,  8 Oct 2024 21:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728423305;
	bh=m5BMcqwy3SqOXFBwLFk7fhpM47mCTk6T0xkUPZFwDuo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=qqxEWUkcNdNRb5Y98P73EmAibtY47omMxAdx6wcmtV5ZbbXxZYTxOJk+khHe7wvvK
	 6GgMeXpRYU9c3z4dtYYcOoOoXAIKLP4TRYjjEmpy7CHv9cqNLj10JHzcKKZv60G0b3
	 KwID+5IFhPkYKXEf89ht+Z6QZP91z0d/3WLK2ZZrtPZHwZKDOymiusI3AXGNkb9XdM
	 Rw3RjnW2fO/+w/JZZXr8YEVrgZrREjEirHRZxALCdery0nw1sow9MJlAYVaBBG6s8m
	 1e+WcfZ1Pg31UrXWhKiNOZS2YGPIxSLaoyTkNqACIcLqcT5rgs+5uxyUMIAp0LRnHc
	 ptLzB83oZFqLg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 82B2CC53BCA; Tue,  8 Oct 2024 21:35:05 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Tue, 08 Oct 2024 21:35:04 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: ozonehelix@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219009-28872-OGVBXygMUl@https.bugzilla.kernel.org/>
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

--- Comment #31 from Ben Hirlston (ozonehelix@gmail.com) ---
in my case I am on Arch Linux and I am running 6.11.2-zen1-1-zen the Zen
Kernel. I need to disable vls for my VM to remain stable if I don't my syst=
em
will randomly reboot after a random amount of time. disabling vls helps stop
that but it makes nested virtualization stop working so I can't run WSL 2 i=
n my
Windows 11 guest. or Hyper V correctly

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

