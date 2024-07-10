Return-Path: <kvm+bounces-21249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 85A7992C7B1
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 02:46:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B70991C2243C
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 00:46:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72B1253AC;
	Wed, 10 Jul 2024 00:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="elZEE+oN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A19443D
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 00:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720572364; cv=none; b=D+pLt5kohPL2dtSIpdE8XZz/pmjuB/miefGiJGHEgrA73JiGKlRdeeZbuI00BdJlTcH73Z5w7I4sIrvbm6cfhiz0AIJJRE1N875VFOvt1gJbyxf2JdD1MulhZMTECIjU2YiDsHjkUyUC2kIxJsRpdG0JCa62uZRaXOQvGY54P2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720572364; c=relaxed/simple;
	bh=x92w2a+ZnCETPIvjDaMH/3qZ0ywS7jaxMhDwjMSxcCA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IwoNW+Rx98L0ga1FgRywYSDo/EgsWclaVwjSY1KiIrFY9j/St7JAWAQmi5YLe4Yrr4JvnAGNMTvUipBLWWePtUbk979wzNzqZaTn3gpWorSOaNTuxUrKTr6sRpVOp0LN/qFbJQNAQUmkiTlOFYT/QzH/9KYKYMTj+KE167Y+XHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=elZEE+oN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2D4B6C4AF0B
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 00:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720572364;
	bh=x92w2a+ZnCETPIvjDaMH/3qZ0ywS7jaxMhDwjMSxcCA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=elZEE+oNTyVws5a/hoKwKVtdhGqlarsqaWUWA8UVoyI1gJZ8QMysuwfvmjsnzLk46
	 VQETC6euhHimwtoc84BYF7FJoq5mRhdxb+z0GaTI9kJbIzSlHnge4si0JhA5t0EkFr
	 K/9MBSaK5SSM9AFD+QfZfhpyTXKnYd/l7ltw6DzLMCz4fbK4l14QIdIO6vEglvvutg
	 HG0qCy3PIKq5uU/vA6ndZQLZw4iQkjfFctx8ZDBggdGj8wkGqzyOLvzDirrlmFDCCo
	 reiVumuj5R8dtakQsrXNxOALL9T/UNQPMzFiDnFBG+8mWliTaLz7sPs3tlWduALpe9
	 qzh0I/30KlWvA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 264C2C53BB9; Wed, 10 Jul 2024 00:46:04 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219010] [REGRESSION][VFIO] kernel 6.9.7 causing qemu crash
 because of "Collect hot-reset devices to local buffer"
Date: Wed, 10 Jul 2024 00:46:03 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: yi.l.liu@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219010-28872-7L8R4TrGNU@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219010-28872@https.bugzilla.kernel.org/>
References: <bug-219010-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219010

--- Comment #7 from Liu, Yi L (yi.l.liu@intel.com) ---
On 2024/7/10 08:48, Yi Liu wrote:
> On 2024/7/10 04:49, bugzilla-daemon@kernel.org wrote:
>> https://bugzilla.kernel.org/show_bug.cgi?id=3D219010
>>
>> --- Comment #5 from =C5=BDilvinas =C5=BDaltiena (zaltys@natrix.lt) ---
>> (In reply to Liu, Yi L from comment #3)
>>> It appears that the count is used without init.. And it does not happen
>>> with other devices as they have FLR, hence does not trigger the hotreset
>>> info path. Please try below patch to see if it works.
>>>
>>
>> Patch fixes the problem on my system.
>>
>=20
> patch submitted to mailing list. Thanks, and feel free to let me know if
> it is proper to add your reported-by, and add your tested-by.
>=20

forgot the link. :)

https://lore.kernel.org/kvm/20240710004150.319105-1-yi.l.liu@intel.com/T/#u

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

