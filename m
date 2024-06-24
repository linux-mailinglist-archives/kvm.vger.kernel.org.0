Return-Path: <kvm+bounces-20390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F13C2914815
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 13:09:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC6332853B1
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 11:09:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02D8613A3F9;
	Mon, 24 Jun 2024 11:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TMehKA23"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B397137743
	for <kvm@vger.kernel.org>; Mon, 24 Jun 2024 11:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719227314; cv=none; b=h13DyHEnmNA5L4RXtliX02z+lYL0iw4RKV08B7kyK9ho6JS27wEJ3DO/000cKH2WuBTwb9qDPrG0q9j4/qGmhvo8DtLtzISaT0Shv6jEuFIaQZ0fDxoECoOJdRWPDYKckw0C7CWyq79SPLohwG2J6JkgokgHBp44+aKfywl1wis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719227314; c=relaxed/simple;
	bh=uFiZoJ0uJtjl5Ac//bgRjXhjG28/tZxW76cfSWQgKYw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=a/YCkIW3VmQpVXE0tLuPUlerAeIO2/hZqRkAs5uFj+GolBm7YtQhnMorty3wd5EtrrxcRv5u3u9GuNgdvQjGrT9kbvSs8Rqwbh4KvnxYhbYJkSWSUwo7Ohd21oZc1ccUbl28eS3Btqezs3Yf5iiqtJPIYO/4GeZeiBA2RA16tSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TMehKA23; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id ABC6FC32786
	for <kvm@vger.kernel.org>; Mon, 24 Jun 2024 11:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719227313;
	bh=uFiZoJ0uJtjl5Ac//bgRjXhjG28/tZxW76cfSWQgKYw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=TMehKA23AhaVhrHS9Ze9Txq99HqMnC6pTm+g3lQiSmWdQrYSd3R+jCeHZFl166ETt
	 O3tBj6zqXFtvHn9UPZBN5F9WTmhG99tH7OBW+dLKfMciIBN4yrf1VpbjvECUFwq4XA
	 AEGTCgwhZM9ALi8F3UDmoLLrelZtgrh3kEz60aR+nzTW6gq5B3MwezsgdpKQTicXlZ
	 gUqpttdXRIunSUbWVld3L5OueW83ggPNN3KZGA8LKtpUuwHuNXr9g5MC4W29h+OZ5F
	 tIzqyX3cbNe42o8wa48U2eFMGisNKmFay7JxsM28VaiXPNv50VhjPUf+52oOHRAZW/
	 ORecwZEz+rhuw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 9C309C53BB9; Mon, 24 Jun 2024 11:08:33 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218980] [VM boot] Guest Kernel hit BUG: kernel NULL pointer
 dereference, address: 0000000000000010 and WARNING: CPU: 0 PID: 218 at
 arch/x86/kernel/fpu/core.c:57 x86_task_fpu+0x17/0x20
Date: Mon, 24 Jun 2024 11:08:33 +0000
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
X-Bugzilla-Changed-Fields: cf_kernel_version cf_regression
Message-ID: <bug-218980-28872-2LyFRu422V@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218980-28872@https.bugzilla.kernel.org/>
References: <bug-218980-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218980

Artem S. Tashkinov (aros@gmx.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Kernel Version|                            |6.10.0-rc4-00234-g859e6ded5
                   |                            |e41
         Regression|No                          |Yes

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

