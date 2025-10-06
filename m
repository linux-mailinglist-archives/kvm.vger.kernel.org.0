Return-Path: <kvm+bounces-59517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B14C8BBD5FF
	for <lists+kvm@lfdr.de>; Mon, 06 Oct 2025 10:45:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 85C671894D95
	for <lists+kvm@lfdr.de>; Mon,  6 Oct 2025 08:45:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A7912620F5;
	Mon,  6 Oct 2025 08:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LrwfvgOZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1191DBB13
	for <kvm@vger.kernel.org>; Mon,  6 Oct 2025 08:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759740296; cv=none; b=LxT1PmU/TBvF5xg7fBdY4uddVQ35WPfyKwRrT+PBDAZ5WKh2xQ1CD2wNUTOvpcwam6K+YIVEbj5COSkLTeVZ9IcQ1O1HXjZKNafPCSonDvH5gUBts3YAHegqyPhr0+Cfj1aC5TNzEuZp697ruZeELQmdexRPT9Yi8BW4W6v8Pe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759740296; c=relaxed/simple;
	bh=3WC8KZTkSIGtfaTknfQZXvrYqr8nh+GdhPBF+a1Ii34=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=IoYhdqlV/B70OmvBZjExpEIohZcQyScZHP/G290Ya+uCUgXQbHhBAbNPmebncEsphGq+Nfe3MLEwaZ3zh+Xftsnghw+PD4MuDmT5POIVe1qt1qH0J0kNwKxbwL8gct7q0FohpcSHMxqU86bZS0VBraZ6MQsEwzSmbdFhW0jR/vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LrwfvgOZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4B0A5C4CEFF
	for <kvm@vger.kernel.org>; Mon,  6 Oct 2025 08:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759740296;
	bh=3WC8KZTkSIGtfaTknfQZXvrYqr8nh+GdhPBF+a1Ii34=;
	h=From:To:Subject:Date:From;
	b=LrwfvgOZhNfjA0kiMaJBtlHQOuIidN3aGQKG1pJ02fCN06lSMFPc3V0jQlOzZLMme
	 zgqZyuRsQZ8QsqUv39lYDX8+MjXoOLS8qCo+CW0RWIBAsyc1wW1UVnlTDCVR5z0rAm
	 r5Y9uy0Y2b8vmHHTYr0MapqAE2R4m48YKthi6l50zpHi7N4zvarBqfHabklXCRNzTS
	 TGEp/ZsmnR4H/UHJhY18uAGtkjwCT/AWDuOZ71p1LPK2F+vSka6n8ldQNAPJmodde2
	 1CQy1izWJ3vn82uQ7PI3TWczMkhRe83kbSk87KqtIw/98D0gNuROoz/Qqm0U4pX4BC
	 F/1hUhjM7C2UQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 3FF2BC53BC5; Mon,  6 Oct 2025 08:44:56 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220631] New: kernel crash in kvm_intel module on Xeon Silver
 4314s
Date: Mon, 06 Oct 2025 08:44:55 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: f.gruenbichler@proxmox.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_file_loc bug_id short_desc product version
 rep_platform op_sys bug_status bug_severity priority component assigned_to
 reporter cf_regression attachments.created
Message-ID: <bug-220631-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220631

               URL: https://bugzilla.proxmox.com/show_bug.cgi?id=3D6767
            Bug ID: 220631
           Summary: kernel crash in kvm_intel module on Xeon Silver 4314s
           Product: Virtualization
           Version: unspecified
          Hardware: Intel
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: f.gruenbichler@proxmox.com
        Regression: No

Created attachment 308754
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D308754&action=3Dedit
Qemu commandline

one of our users reports a crash in kvm_intel with Windows guests and live
migration. the source and target hosts are identical hardware, kernel versi=
on
and bios version wise:

- Supermicro SYS-120C-TN10R servers with Xeon Silver 4314s
- microcode       : 0xd000404
- 6.14.8-2-pve (based on Ubuntu 6.14.0-26.26 and upstream stable 6.14.
- guest OS: Windows 11 24H2

the Qemu commandline and dmesg output is attached, the user is CCed to this
bug. unfortunately, we don't have the hardware to reproduce and bisect
ourselves.

this is likely a regression, since the user reports running into the issue
since upgrading to PVE 9, which means switching from kernel 6.8.x to 6.14.x

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

