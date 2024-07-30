Return-Path: <kvm+bounces-22710-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 13B2294225E
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 23:54:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B37211F242D0
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 21:54:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8924718E04C;
	Tue, 30 Jul 2024 21:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZBA0XnSv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9935D1AA3EF
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 21:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722376458; cv=none; b=AUzkWYHazduNvPij1YQiTVkuVc5El/EHtlW3jusuOIfDys7L/24dgB1YCl3F0jQAVXNjy/i1z6I/ot5jyTou/nMnCB2t8GtnE2iVfp8jPDcmy5YyTbQrtxdNxmZjC8kIyUwPDZt9HMmn7tfk89Lu7aHz75fUQrwDrFWvouOaT9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722376458; c=relaxed/simple;
	bh=zVZUmfkmOLRagsFyF53cvEGwQYYKTaSDCCso/G3m670=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=hyrt9Uj1EykYQRSoMfH43qb1BbGO68CnZSXWhUERc6TrYi/AgVp6EQsGDonnn2DgGC/in4xIECsOmxa+Xq6B6DJFnfI5G5FMDg7dpCPnX8FL5VicpXREKiBm30X72eSzbwej5iETjPkyZ6aWWgbK8NGx5bJpH8blxWvV3tpx7xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZBA0XnSv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1B6FDC4AF0E
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 21:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722376458;
	bh=zVZUmfkmOLRagsFyF53cvEGwQYYKTaSDCCso/G3m670=;
	h=From:To:Subject:Date:From;
	b=ZBA0XnSvhe9cVAw0ydCWnk7/gwTqdnPKk74bDszRi2bYvTPnPjBYGAH6XxlaEc21L
	 mZ8Dmgs2Tbi7K/8p0PgGZejkZxaPapVSpAhF0S00X5tZMbCa7DPaZHVRs7StxrdzsS
	 Yo0vJvFIbOnYDdz303v/c6I5kKksAg0B36zJ23WxNg6J5rs0VAMgDSF2LGlA2GH31y
	 ym5JJJL3zdFXkt8Lc5hKdrubWkPO66+AvzWQWjfIYn0pl0lzN6QdIgNAzT66iZbeVF
	 u7FkAb6vdoalLOFAlRZtDnToGsxP/qpWhROKNDbe/+G+MnK9dNqxJTLuSXmbFdPjUl
	 0bYWdtZN6dwWw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 0E36CC53BB8; Tue, 30 Jul 2024 21:54:18 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219112] New: Machine will not wake from suspend if KVM VM is
 running
Date: Tue, 30 Jul 2024 21:54:17 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: alex.delorenzo@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-219112-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219112

            Bug ID: 219112
           Summary: Machine will not wake from suspend if KVM VM is
                    running
           Product: Virtualization
           Version: unspecified
          Hardware: AMD
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: alex.delorenzo@gmail.com
        Regression: No

Steps to reproduce:

1) Start a KVM virtual machine with QEMU. I used Quickemu to build and star=
t a
VM.=20

2) Suspend to RAM

3) Wake from suspend

Expected outcome: Machine should resume from suspend when a KVM VM is runni=
ng

Observed outcome: Machine will not resume from suspend

I tried this on 6.6.42 LTS, 6.9.x, and 6.10-rc1 through 6.10.2, and ran into
the same problem. Unfortunately, I can't find a kernel version where this
problem isn't present. Nothing gets printed to the system or kernel logs.

This is on an AMD Ryzen 7 5850U laptop.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

