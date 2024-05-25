Return-Path: <kvm+bounces-18150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C5FF58CEF40
	for <lists+kvm@lfdr.de>; Sat, 25 May 2024 16:16:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EEC401C20A14
	for <lists+kvm@lfdr.de>; Sat, 25 May 2024 14:16:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50D684EB3D;
	Sat, 25 May 2024 14:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rUDolBrx"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D472A1D3
	for <kvm@vger.kernel.org>; Sat, 25 May 2024 14:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716646601; cv=none; b=ViqGFufEHIs5Q+AjAKgH/1xHzgJjqP78yvWbHc/L9BVwVOshMnfiMpA4ghiWd8+TTq0qxnOHX+1ZgjxbSRjohY9Q46I8lYfnWzY1qZ1BxzArMgNSw+P4e3dWaoepRoyb7wGg/AeNQahMJhSpK+s7JCSRI+tO5EFQNZ751Z9S9Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716646601; c=relaxed/simple;
	bh=0bDvysWcxPTh5AOHvKqTnhOAxhZSZYClJPn80KpoofY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QbfQmjrRgUKpqeHxvWvDED5mNSGgCje6R1bbFJcLWCh2F7gGm9vNJbouz0OIYKR4TBFRIszPjCIhfxmDHH3YhcW0FOVF9atVKIwAJvQTwYswJEMLLq1isk6nJWuaRjwUOhvNO2HRnyF8ZFj3Hs/WpNUxHylutKRds/OwoCgvhh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rUDolBrx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id D5EE6C32789
	for <kvm@vger.kernel.org>; Sat, 25 May 2024 14:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716646600;
	bh=0bDvysWcxPTh5AOHvKqTnhOAxhZSZYClJPn80KpoofY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=rUDolBrxFOAJUDUQQ6TjzaDrMfBQboy6CFAb2BLvwodpN5I4EBtOOpkkRgusWI4e2
	 S/2u6XbKvnaisplVKUnDnrSQ8H8hom6pEFMd8XS1zggSlu96HM8R5xPMDcbfrCVoN0
	 gS9kc/NG0vPliQmvUIJxYcH6U7eTu9m753KYQGjNhjxx5me+M7sqTz9hEmni2nMhXW
	 KruFqq48jGQum8K5u1aBVw4mS1Q2/kpaqJxJZw/RlhQEXHPr/hmV53cxB9+s7aNcOj
	 ngfkCV3yAPhFVs6vV2FNQKDzF9N9WLrxZ0Hd2q1ZNV/ZeIducVht+ncq+OYeLc7+Nt
	 eschN1tfBPpJA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id C1839C53BB8; Sat, 25 May 2024 14:16:40 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218876] PCIE device crash when trying to pass through USB PCIe
 Card to virtual machine
Date: Sat, 25 May 2024 14:16:40 +0000
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-218876-28872-6RBP7yi45z@https.bugzilla.kernel.org/>
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

--- Comment #7 from TJ (linux@iam.tj) ---
I've done some basic analysis and testing here to develop a udev rule. This
looks like it ought to do the job.

# this is /etc/udev/rules.d/00-vfiio-pci.rules
SUBSYSTEM=3D=3D"pci", ATTR{endor}=3D=3D"1912", ATTR{device}=3D=3D"0014", RU=
N+=3D"modprobe
vfio-pci ids=3D1912:0014"

It needs testing so what I'd suggest is:

1. use the unbind method in (2) in my previous comment to detach the xhci_h=
cd
driver and check there is no "Kernel driver in use" with:

  $ lspci -nnk -d 1912:0014"

2. Tell the kernel to replay events to test if the rule reacts as expected:

  # udevadm trigger --type=3Dsubsystems --subsystem-match=3Dpci

3. Check if VFIO bound to the device ("Kernel driver in use") with:

  $ lspci -nnk -d 1912:0014"

If that works then the module and rule need adding to the initrd.img with:

  # echo "vfio-pci" >> /etc/initramfs-tools/modules
  # update-initramfs -u

and then do a reboot test when convenient.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

