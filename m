Return-Path: <kvm+bounces-7768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E717884618F
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 20:57:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4DBA286421
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 19:57:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B035A8529E;
	Thu,  1 Feb 2024 19:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k69rznO4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3B585278
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 19:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817414; cv=none; b=EjHc870ygBwFA7Q3ubRUlHswkvyDKvum9jg9/JvuL8YbuyHzSm41gHUeR2aqfeCG+/VBUju/NUKXZiQFVsGz5mUhoCs0mLfIts/ZxmF1F7379848wnsnVmIU63NfsMlTTnhaP5baIgzynjzV0DxpbqZGbzrUtDeIvmRspEufnR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817414; c=relaxed/simple;
	bh=He7+KGIhUYjTF5NvPD+CinD8Ne2GNfZBLSvX88v4ZaQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iMzxTMPteL4ylVQA9C1sFVWKeDjiObZnpu2qZO0Quj9xXvM+lYloukc6BZL816IzZD2X/ERXKE839mKnNgXXxZ5xOxip5LSSfd0j5KU+ASQK6LkZ11+c22ANKN5UHdtogf99CiS2FiLfVsIiUnOuGBWGlidfJWUA0OEkdi4m700=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k69rznO4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 64BBEC433A6
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 19:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706817414;
	bh=He7+KGIhUYjTF5NvPD+CinD8Ne2GNfZBLSvX88v4ZaQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=k69rznO4AwA8sxQiNeWQCSN+IMenKv/GW5RRBAz79Fljz8/iRutHG6cwBwMUiJbBm
	 O7L+Hd5v7KSBF4bfT2/2X8cFH0bN8U178r2TOE3AngK8hYHTrL7ZEU2ixGmXjG+rpK
	 61DeymIMtpC47TCt1Uiw5IBq/MUPF8Ga7gzN8QHI1syzTO+xhee7Yy7z/2SXRUTL2Y
	 yL+agGJJoWMe5v0uQ4trbpOmc9/RoCcv63scHCFfKKIqHl3N0JAMWFgb/Z3DSAWzoA
	 Rk1soeXKfj71eOAdZdeNM7yla1/3Ha3ZpI98B31ekIT63J2dhCpVwztMQEM9m49G8c
	 1twbKJ9jUviOQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 52CB7C53BCD; Thu,  1 Feb 2024 19:56:54 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 199727] CPU freezes in KVM guests during high IO load on host
Date: Thu, 01 Feb 2024 19:56:53 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: gkovacs@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-199727-28872-rfa1G8PEAg@https.bugzilla.kernel.org/>
In-Reply-To: <bug-199727-28872@https.bugzilla.kernel.org/>
References: <bug-199727-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D199727

--- Comment #24 from Gergely Kovacs (gkovacs@gmail.com) ---
To be clear, in our experience aio=3Dthreads and iothread=3D1 solved all VM=
 freezes
on local storage, regardless of the VM running from SATA/SAS HDD or SSD, or
NVME SSD, so it's a great mitigating step. Ceph is not solved for us either,
therefore using Ceph is still not recommended for KVM storage until this bu=
g is
actually fixed (instead of mitigated).

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

