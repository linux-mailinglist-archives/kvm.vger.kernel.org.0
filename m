Return-Path: <kvm+bounces-25194-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F3CC79616CA
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 20:20:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AF8BB286748
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 18:20:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30D711D365A;
	Tue, 27 Aug 2024 18:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uc+Z9bhw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0211D3647
	for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 18:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724782746; cv=none; b=e+Mfiz+Wjx+IZFxdjN5IgA4OkDoowNSmNmzfKV1pMDrsg9nAhnHTzpWK/hOLtYLV+H/RAkhsvNvBq0my/z/9aQ71hcVxiKaLDnie7bGBq2BrCS1gV6ZmoNK143e/HOhUl2kQyvEdlyp1H6o1UUGGbXbidC6MznxeM6NFa6Cj6c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724782746; c=relaxed/simple;
	bh=CpQKqy0D/mEr8xjvpOeCBawkoshcsozY32QQIyHIb/U=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pcX3qydHi1X7Ohi43UTzZaToWARCKknnTFy0D49EnrfN38/M9tWdnmsWeT7v/QQ5YUjE65QLP1j0qfYoFUzFqWhANSklIwb7YmOuXjG5bUeii0Exau4ThA7IHkxLGPs7ItdCc3KOfMvj0qhT9JTzLanYCKbWef+dYERcGfJfmKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uc+Z9bhw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id BC044C4AF51
	for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 18:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724782745;
	bh=CpQKqy0D/mEr8xjvpOeCBawkoshcsozY32QQIyHIb/U=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=uc+Z9bhwVMH2t0juimp9vPtPxCmA9nrWlUcEeQ53NSlL7T8KZROT2dO2e7g0YXPtY
	 0PW+I4L8knGhM9Xv8664tL8fTzRuJAxxJoeWn92MeKtZBnM3Ft7jgF4qH8K3NuLcfE
	 +uRgWng1DQ8f1rYXQ2CYipE9QCJknoJtfTaWgRVRuX/kif7ylyEyNay8o7UjglKmAp
	 6CGX6xocsIw09fhteKGAhJxD8ftzy2WTK+JBeYlZsmGL8YYjZsQbiHOKzmuQTq5Uyo
	 50FuZiNIJ3JAvfIql2/AtdySoyvS2TkhfeyHKG+FXTHEx5FwIkftq+OoOUAw/qOe4p
	 QAezhSJ/xYY4g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id B50AEC53BC0; Tue, 27 Aug 2024 18:19:05 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Tue, 27 Aug 2024 18:19:05 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: michal.litwinczuk@op.pl
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219009-28872-bMAwU1qecQ@https.bugzilla.kernel.org/>
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

--- Comment #12 from h4ck3r (michal.litwinczuk@op.pl) ---
Kernel and qemu devs perspective is also appriciated on that topic.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

