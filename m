Return-Path: <kvm+bounces-21247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 643CF92C7AF
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 02:45:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 957891C2290F
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 00:45:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6F9853AC;
	Wed, 10 Jul 2024 00:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="phRzbQTu"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72974A0F
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 00:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720572295; cv=none; b=i0hl1MDF5uMEHtB6nxMGRMMYYHcNOgiQwC35V7lPdqdqO/mXyIFM9junlagtZKt5Hdj/HYknCB7RRnpuh9gnaM75LjWfu0UIqO4/qXU+dViiN3EcUIcYd8fipXm44xXkKeM8JLxk7XqPRnAZgUpFjNV+2/OJkbCNzX5Zo27OKZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720572295; c=relaxed/simple;
	bh=TSDrcGiCr57XrhRhLbZyiBS2mSNgOWnH8SPDAjSjUCs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BV1Hj7EEszPKeRYwqjJyI5mYd3nAWBcZnRIoI6yff+HqTLRJiTspR9K1CRm698nYlrADd8LbgZ6f+q0fcwT9p+Jw5tIbAFxTPgBe1qHNrQHub9bBPpCBrIlAvO7FTmxp1N5tHoV4j6dOk3zENz/wlxHdUsQ1SOZnCdmPQOfbr5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=phRzbQTu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 41301C4AF0E
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 00:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720572295;
	bh=TSDrcGiCr57XrhRhLbZyiBS2mSNgOWnH8SPDAjSjUCs=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=phRzbQTuYRmYi8tvjAvx9nUyxuRZx70Kllk9ETcQW7J9Ci+xM4vZHkRxFioozfWPj
	 zNbnLyw6huLrM2WZ4TY2CXuDMKN9p/E5bKLwCnhfYYPJ0/PxMRUhSLMqpDePOQMu7a
	 6JBHczuP1/muAu5idP9DpEgqCtmc7P3fn+Vin1IXEcqG4Yaq2rfdfHYdr1kOmL9scr
	 LdZO5OliFYBNNYwK68RwS7FIfRt9DXkmQ0yFnZBX4Xuc0uVQwn6bRMWykw5pzCvDpC
	 TFpdpxkGq86gKe39GJZYH0QY8TnOx3Sb9PtHGXP0oVWWCCrL9BYfyd6s3Bth63flnB
	 N47HXwlvpJsFA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 3901CC53BB8; Wed, 10 Jul 2024 00:44:55 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219010] [REGRESSION][VFIO] kernel 6.9.7 causing qemu crash
 because of "Collect hot-reset devices to local buffer"
Date: Wed, 10 Jul 2024 00:44:54 +0000
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
Message-ID: <bug-219010-28872-gYnU4foqdY@https.bugzilla.kernel.org/>
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

--- Comment #6 from Liu, Yi L (yi.l.liu@intel.com) ---
On 2024/7/10 04:49, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D219010
>=20
> --- Comment #5 from =C5=BDilvinas =C5=BDaltiena (zaltys@natrix.lt) ---
> (In reply to Liu, Yi L from comment #3)
>> It appears that the count is used without init.. And it does not happen
>> with other devices as they have FLR, hence does not trigger the hotreset
>> info path. Please try below patch to see if it works.
>>
>=20
> Patch fixes the problem on my system.
>=20

patch submitted to mailing list. Thanks, and feel free to let me know if
it is proper to add your reported-by, and add your tested-by.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

