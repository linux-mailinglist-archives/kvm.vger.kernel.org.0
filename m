Return-Path: <kvm+bounces-21059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11B9B9294BD
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2024 18:31:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DE216B2157C
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2024 16:31:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAA5513AD2B;
	Sat,  6 Jul 2024 16:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NtJ10oqt"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BDD4689
	for <kvm@vger.kernel.org>; Sat,  6 Jul 2024 16:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720283458; cv=none; b=d7meiddhoWWMB89dcchH/iTA/SaFfP5Sc/9c3F958b2C+gUpK1MI6wAxUMoNwkBdbChXmCPg6iAqfhZ5Dcin3gDzJTtcw1LDqOKTtLWKWr80LT/tHg8M+m3/WEK+tp5j+X9478LmYDUeUNIksumstLCKplFYhVgVz7SlJjojvFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720283458; c=relaxed/simple;
	bh=mXyeBqriJtINuOEHJsehMoOG80gOKQlr8q4YiSxixy0=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=NPxbMSivGBtne1GvqPBspZB9L+ZJSs9pEXcysm+ugr0/DmA0Ns8gkwzcBMJS7/p6lUhAUIaIEvlse7BeB9312pKTKKaOMIRxaUFJ85ABAhv5QDwy+qzAdl8moK9ngiuYgwrHEPvs+Y7TCxQVGhmV57bsvdwx1qdew24Dmrc7l0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NtJ10oqt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8AA78C4AF0B
	for <kvm@vger.kernel.org>; Sat,  6 Jul 2024 16:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720283457;
	bh=mXyeBqriJtINuOEHJsehMoOG80gOKQlr8q4YiSxixy0=;
	h=From:To:Subject:Date:From;
	b=NtJ10oqtJHigBhKXy7EmfbkwUJp/CwkDBePGCKN3zTxY6uQSM0/S4/CVTTqgW0TfY
	 4+nTg5Y/DLI9ZFcgxryoaGBh+6doaFrLBHbW73uVUl/7sRMcVnqOlkJ++4Pg45NXo5
	 wEz0gVk5dcsPUCHgWcnmryTFZVXSo45JASDou/rT36I7iV+HNFqbKcrKmWps64QAAG
	 FqV68uFAKe4onXlXCUu52X7c32seH/t2RBBxxoQEYgMjj4aWB4AxsiL5DAbdCylkdu
	 9G6Jr37cEJ/I1IZLkZCxJRcmmj5t+dw1cuBUZiZ9caV27nAZAyK4llBAQcC48jf2IR
	 sxaXPSxkwcMOQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 78247C53BB7; Sat,  6 Jul 2024 16:30:57 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219010] New: [REGRESSION][VFIO] kernel 6.9.7 causing qemu crash
 because of "Collect hot-reset devices to local buffer"
Date: Sat, 06 Jul 2024 16:30:57 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zaltys@natrix.lt
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-219010-28872@https.bugzilla.kernel.org/>
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

            Bug ID: 219010
           Summary: [REGRESSION][VFIO] kernel 6.9.7 causing qemu crash
                    because of "Collect hot-reset devices to local buffer"
           Product: Virtualization
           Version: unspecified
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: zaltys@natrix.lt
        Regression: No

One of my virtual machines using PCI device passthrough (vfio) stopped work=
ing
on OpenSuse Tumbleweed since kernel 6.9.7. Qemu 9.0.1 complains:

qemu-system-x86_64: vfio: hot reset info failed: No space left on device
qemu-system-x86_64: GLib: ../glib/gmem.c:177: failed to allocate
18446744068411217972 bytes

and then coredumps. Qemu backtrace shows vfio_pci_get_pci_hot_reset_info()
being the last qemu function being called.

Reverting kernel 6.9.7 commit 9313244c26f3792daa86f3a18cc3bd5ad60310e0
(upstream f6944d4a0b87c16bc34ae589169e1ded3d4db08e) - "vfio/pci: Collect
hot-reset devices to local buffer" fixes the problem. As I understand, that=
 was
backported to 6.9.7 from 6.10 tree.

Upon more throughout analysis I pinpointed that crash is happening because =
of
one specific passed device: sound card of Asus B650 Creator motherboard. VM
starts on 6.9.7 if I remove this sound card from it. I think the important =
bit
is this card being VF of device which does not report support for FLR:

15:00.0 | iommu group 28 | Phoenix PCIe Dummy Function <-- not passed to VM=
, no
driver, reset method: pm bus=20
15:00.2 | iommu group 29 | Encryption controller (PSP/CCP) <-- ccp driver
15:00.3 | iommu group 30 | USB controller <-- xhci_hcd driver
15:00.4 | iommu group 31 | USB controller <-- xhci_hcd driver
15:00.6 | iommu group 32 | HD Audio Controller <-- sound card passed to VM

After reverting the above mentioned commit, qemu complains:

vfio: Cannot reset device 0000:15:00.6, depends on group 28 which is not ow=
ned

exactly the same as before 6.9.7 and VM starts with that sound card passed.

This might be an unsupported configuration, but qemu crashing with 6.9.7 al=
so
feels like kernel might be breaking userspace by handling/mishandling this
differently, especially with minor version change.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

