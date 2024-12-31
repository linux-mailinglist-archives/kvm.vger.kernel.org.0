Return-Path: <kvm+bounces-34425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 887D99FF0A9
	for <lists+kvm@lfdr.de>; Tue, 31 Dec 2024 17:27:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 474FC1622FD
	for <lists+kvm@lfdr.de>; Tue, 31 Dec 2024 16:27:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EA8419E7D3;
	Tue, 31 Dec 2024 16:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X7b52l+a"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5D918BC0F
	for <kvm@vger.kernel.org>; Tue, 31 Dec 2024 16:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735662432; cv=none; b=SuoF3z+u1oqUnCNoAYH++tUpwaO4fYdWwry1Bp3PbJiQyuEiLxSme5AaqjeVeiWpK1DvmUgBoVZEsCiJLHvMyoIRxZjd7h4K9LT+Ch6pZeoN/HrAwopD03/N0kKg69IyNo1XlHEsKwMnwZJ3axjn/HEW7mveg793T2YlWX4miRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735662432; c=relaxed/simple;
	bh=3w2wDM72+ACLeJKmrlrBjb/7g6fYbYsQJXJIoSzp6GU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qeBxVwVjPIgUFswYPNp0BkRI0ie3sP1RLeXliaVAdSLkimTQ1dwE36Ny5/a2qKV4QqkHdAqWcP/MypQ/VqA3xewfZ6an6maGu/iw6MiDzaZMqvDEFvU/Qo3jbfdGoIYCDCBbkz2SiQys0E8aFK39ZQDROnmbu8kDxUAqxiIO1lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X7b52l+a; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id E9816C4CEDE
	for <kvm@vger.kernel.org>; Tue, 31 Dec 2024 16:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735662431;
	bh=3w2wDM72+ACLeJKmrlrBjb/7g6fYbYsQJXJIoSzp6GU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=X7b52l+aEG5V+cBFiVHgFVPCbuxycW7LjLS+aDfyDnARz7oxA1vnHL71iuXGgBjaI
	 +/aXBuuHnV+eLZ0ZbRPYwvFjPH4P2gWappRocDShjY1to8MpdqEohjqf4Z1RyL6vQ5
	 dQgdMNBL/DB+NXlHrGR6EwdFSJy0s8O/KoRX7VPEi6geAiKgNfWFU+P3VXCJ5SJMRb
	 SxIkSjEHEHedY0YE48cwK8Fv28Bc0npaX6prGgA4YthyOIlG0tBzhDDLZQIIR6+8xC
	 NWegqSaGDhdOjgUOS1cW/Ky7MZBiV7zJ+fXVzdlR94O3g/uJfBcrZNvFHsUha2Lb7X
	 U86q9Miy1j3Ng==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id DDDAAC41614; Tue, 31 Dec 2024 16:27:11 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219618] [REGRESSION, BISECTED] qemu cannot not start with -cpu
 hypervisor=off parameter
Date: Tue, 31 Dec 2024 16:27:11 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: athul.krishna.kr@protonmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219618-28872-WOcZb48TR8@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219618-28872@https.bugzilla.kernel.org/>
References: <bug-219618-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219618

--- Comment #1 from Athul Krishna K R (athul.krishna.kr@protonmail.com) ---
working in qemu 9.2.0, issue resolved

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

