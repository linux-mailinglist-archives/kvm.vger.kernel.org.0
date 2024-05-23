Return-Path: <kvm+bounces-18059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B1708CD70C
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 17:28:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4CBB31C215CE
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 15:28:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8E1E11711;
	Thu, 23 May 2024 15:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UXkeeMO/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC6D1097B
	for <kvm@vger.kernel.org>; Thu, 23 May 2024 15:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716478131; cv=none; b=MSJLrNlIjRVzzsn4QMYPGKS2DOivh43P5FticLQpaTSAYRiRTf9CyMvWzt77aZXSEVse34Ycn1uroiB6RME76evREMELf6hEcio810hJWQvd95CyOvIm+YKNSz9OzLrjJoL3S3cR30Eo15KcLhNVg3oIoj/2aWLDLnzMAwUq7eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716478131; c=relaxed/simple;
	bh=QOSn6zessS0OSygBKzaAz5Yjix7aFlmn0z2hEkdrq8M=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JCX6eXbhPyZGWa7ymRH5fCPK3FxcMDSVFY3wuW2YZPVq9dBkYYC1L7jSfIdPu+mOW/Y0aWrar06CBZmxt70AJ6ClAxcINzZGsYSZJHY4D2n5b0syX1Z0AXZ1vFEyKdB+LdYWzp5ZWpGO7pkZjnAoqsYZ5oQy2a+NViT6UlQGoog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UXkeeMO/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6D070C32782
	for <kvm@vger.kernel.org>; Thu, 23 May 2024 15:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716478131;
	bh=QOSn6zessS0OSygBKzaAz5Yjix7aFlmn0z2hEkdrq8M=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=UXkeeMO/fXPqmqibzjqi4c6Sn1VRW99bIhpfYKr8yroASIxk5DqTp+tWpGokj03IK
	 qzddu/6R5W0mYz4gToSRKb9If1pXjBAdou6vnz9TkR9wmdoX81obn8fldr6YBmuFkP
	 4d1rQhJ+FryhuGElIUB78nYAVfntDwlpgiA31VxNv+5QsLTCY3MgpDQNJ+hO64wBVo
	 +pEQueTucJjln1/BAUnrL1nIKxLRhEybIRk3qf8BvShudi+VKowZhvGDqVo/5Ecacf
	 4n+6/4K0g+JM9XhHO/z4RBAfcJmij7gCQXt//rbpwapUTkFMIIOAarDx7JQxkMI/ug
	 FoM7JDfNZEtow==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 6718EC53BB8; Thu, 23 May 2024 15:28:51 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 218876] PCIE device crash when trying to pass through USB PCIe
 Card to virtual machine
Date: Thu, 23 May 2024 15:28:51 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: dan@danalderman.co.uk
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: attachments.created
Message-ID: <bug-218876-28872-ZHxM523bEe@https.bugzilla.kernel.org/>
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

--- Comment #4 from Dan Alderman (dan@danalderman.co.uk) ---
Created attachment 306327
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D306327&action=3Dedit
power reset methods of PCI devices

power reset methods of PCI devices

find /sys/devices/pci0000\:00/ -name reset_method | while read -r f; do ech=
o -e
"$f =3D $(cat $f)"; done

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

