Return-Path: <kvm+bounces-16231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D583C8B748D
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 13:32:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 961B1287F57
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 11:32:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0859412D761;
	Tue, 30 Apr 2024 11:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RgGs3GKJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365A012D1E9
	for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 11:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476741; cv=none; b=jRkWW70T4bjqTuQ41pc/Clsxd53+Lifw6fNN3Z/i5Ea5GK8twCgQq/ntQz4sSXA4RHj0wuUcnqM5tINHZKgH0o5E57JvGnBOjj/aegb/LH82/m/X50oL4ZnYRe+NHNI1luR3tRNBd4NN8KHcvqblyeMVoxg4pIToL5uFzFJTibo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476741; c=relaxed/simple;
	bh=qTLTjMBqUAZzbJw23rk2+Mi+qfZ7tHZM02zjuQvwKZU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CbIHcJzRexBzW7ifDpWJxLUmryek+EcEYjg7lE2KrkTVZxT/ZLALYfFm6hjHBRY0a8WllidHibimwm22SIeSwV4caRW7ifajgEUCPCXZKQYXY6THOMDF3fCnph3xai4m3dIQqxujUKydzQV48i24+kXPhi4ZJjfBdPjeknPz+/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RgGs3GKJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 045BFC4AF18
	for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 11:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714476741;
	bh=qTLTjMBqUAZzbJw23rk2+Mi+qfZ7tHZM02zjuQvwKZU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=RgGs3GKJwefDNXiGqx76p1M/mfn6SuOKGNPJ9jINv7mjqRPzpIcLvMu+1AKGn1X34
	 btbwFAn2skISXcaZNhOCHBHLIoGDgsRChF2UmBC2F4zoD8PQ3FqIhGMl5j+kX6VPJq
	 rWALeDL3rOEh5/bDHTGmxMOJ2m+M6fBhMpssSS+TQE3VqQWdZRR/tu8dc34D+tgYmz
	 5WNZxA3nnHq3qr7jGyWyeYAiIlO6oXDls6MLvlG+aF2/yQ+MS4ZyLO2liJ2iiUslu9
	 2STuIPwPcDT+ynDqKlC5Sk8bbJkWrhoziK5Hy7LTpJCtfrx8f9rRAy82rgfWzPtTLd
	 4CvkjUNL+mhoQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id F22EEC433E5; Tue, 30 Apr 2024 11:32:20 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218792] Guest call trace with mwait enabled
Date: Tue, 30 Apr 2024 11:32:20 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: aros@gmx.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cf_kernel_version
Message-ID: <bug-218792-28872-WTmTGM4gld@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218792-28872@https.bugzilla.kernel.org/>
References: <bug-218792-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218792

Artem S. Tashkinov (aros@gmx.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Kernel Version|                            |6.9-rc6

--- Comment #1 from Artem S. Tashkinov (aros@gmx.com) ---
Is this a regression? Could you bisect?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

