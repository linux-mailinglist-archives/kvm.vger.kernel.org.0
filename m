Return-Path: <kvm+bounces-18049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B35588CD5E7
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 16:36:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E4D5D1C21567
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 14:36:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD2F013C670;
	Thu, 23 May 2024 14:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DFD6Rmyz"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA3F1EA74
	for <kvm@vger.kernel.org>; Thu, 23 May 2024 14:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716474958; cv=none; b=Z7ZowCgUvBLYmST30wqbabhK85jpp2f6qWCu3uOt3+BPw+vIWiGIu8zrNSxcTJt7T7k8l+Wd3t/i9wi4C8uMKO56k8xWLLbVxzxa8Z+SY70r/e+iATHCb8OGEJyHQP8paOSvJZSIxLdrV1yDRIGQsoh+LdqHxlXZXdP5ACrgFGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716474958; c=relaxed/simple;
	bh=hujLA40izkhkyk4cHbMtRAp8JZKr0b1Cbo1fGXhH2Gk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uYxxWRS8QCSDH+FJ+xLTxEUrb/1snOpJEEymJvAtTkSVW/Y3GBOkGrbj+ObF+ExoBNT/Q0iPQlC+TmLttwK0bukNu3ix7NV1Ux5y5NL1pvNNF7qFfDIaAK1QJ01434GhJVoxxjPZIE4kg2AWUJuLhWsKAbJItqu28gj1Qab/3kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DFD6Rmyz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 663D2C32782
	for <kvm@vger.kernel.org>; Thu, 23 May 2024 14:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716474957;
	bh=hujLA40izkhkyk4cHbMtRAp8JZKr0b1Cbo1fGXhH2Gk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=DFD6RmyzyBQ2K5fJgp1Nz8kL72/rX5gLKVGK4qFoJqxLuZd1APd+hoIaiXd/7TbLL
	 sM3uXhXnHZFDaMS5hQJ2R8n6hZMUlcu6dzuCCVpIrN1E4pIF5pToJMnS1t1PaqSZ1m
	 CCzHHFe4KlANVtZz9aoggOCOJtRyy+wYU9EwFNMJ7ocLF4KXZKmmEvI6ExVyxuoBtx
	 khnMsLhLjd4kKgO9mQfeKQn5I2r+yL82JhiLfBh7QYwLml7zLbRCIV3wT08wPk0vjO
	 WTVIgzeUU2PA042yFGOznZjKukcOKYp7wi8+jTVJNYawRI86yG0OnhIX+n/Kpzo22s
	 CGgSaVIx4fOXA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 5A224C53B50; Thu, 23 May 2024 14:35:57 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218876] PCIE device crash when trying to pass through USB PCIe
 Card to virtual machine
Date: Thu, 23 May 2024 14:35:57 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: linux@iam.tj
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-218876-28872-DcGxJThr5N@https.bugzilla.kernel.org/>
In-Reply-To: <bug-218876-28872@https.bugzilla.kernel.org/>
References: <bug-218876-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218876

TJ (linux@iam.tj) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |linux@iam.tj

--- Comment #2 from TJ (linux@iam.tj) ---
This could be a power management issue:

  vfio-pci 0000:02:00.0: Unable to change power state from D3cold to D0, de=
vice
inaccessible

Could you add the outputs of these commands?

# detailed PCI device info
sudo lspci -vvnnk

# power reset methods of PCI devices
find /sys/devices/pci0000\:00/ -name reset_method | while read -r f; do ech=
o -e
"$f =3D $(cat $f)"; done

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

