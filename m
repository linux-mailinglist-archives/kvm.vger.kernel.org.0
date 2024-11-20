Return-Path: <kvm+bounces-32212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BB0189D429E
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 20:39:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 73D881F217C3
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 19:39:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C256E1BBBCF;
	Wed, 20 Nov 2024 19:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iAgblN1Z"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E700B146A6B
	for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 19:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732131583; cv=none; b=QCVfg7x3BifIn2c+yAqf1V1xc8suo1bPRzSnygH0TMI2wP1EdDNjPxJvkuSRNambp7eFWCqOem9HQtLeVKVKvypsaS71zPvPLWKPZzNr8dJmh+uWqnWQh9AWew1CGsd7bg2C5nnIiDfJHSOEdP3z8GpTMFHmbmDtu8403hj2zNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732131583; c=relaxed/simple;
	bh=T2keTFk3svJAGois2ZCzcwiNRPaB7RiIAyYZHKuwVCE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FBHQiIZbsxxbXXTgt1iwFp2pL7Zv77GlFvaAo0NJtX1xkZ/qGMVp/VZNt8UgruiuXcvoZLdS8uOc9bUdcpo87TRpmjCVgDMjf2KYQlSIgQmuoUvXbSZF8i4EJfnbt0ooyzBDSTSD8uyeaygkwPGuox4GGjFHWL6tZoI1akQ1SDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iAgblN1Z; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6B8F8C4CEDC
	for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 19:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732131582;
	bh=T2keTFk3svJAGois2ZCzcwiNRPaB7RiIAyYZHKuwVCE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=iAgblN1ZRi3L9joh3pYqGuu3fT78RFnsPthRo+b8SWgDTP3c3+timeyYeKJlZq16/
	 JJOu7rInRJ3Nkwf+sSMQgMLjqZk+o6JRkAdDJ3/EkcxA0kCoNRyjiyRPXDPG2mHYgQ
	 yYKrKEudgmxJpyZ4vzzyFgyf5csrk63JrlwgMhzoFAvDuxCCUcXF+G9zSQAAOcWd4T
	 lTSo8r24f8HrD8xbiZfMxQeW1uPeyzsCikbboupsmDsrAAepizX+BF7A7iRIHVDdbo
	 UunM1Nf0iNbS/Pfynb3Gae/E2JjtPtxEl6SXJZ4Z6hfGsHKSKHQoW1b9YSux52x3ag
	 ibGa+CsRHr2HA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 65645CAB784; Wed, 20 Nov 2024 19:39:42 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219009] Random host reboots on Ryzen 7000/8000 using nested VMs
 (vls suspected)
Date: Wed, 20 Nov 2024 19:39:41 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: ozonehelix@gmail.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: CODE_FIX
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219009-28872-4Ezaczxgy5@https.bugzilla.kernel.org/>
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

--- Comment #43 from Ben Hirlston (ozonehelix@gmail.com) ---
the way I obtained Linux Zen 6.12 was by going to the extra-testing repo on
archlinux.org and running sudo pacman -U linux-zen-version
linux-zen-headers-version to upgrade to those packages

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

