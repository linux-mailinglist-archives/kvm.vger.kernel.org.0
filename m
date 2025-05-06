Return-Path: <kvm+bounces-45583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5679AAAC05C
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 11:51:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C8463A52B6
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 09:46:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9BC2EAC6;
	Tue,  6 May 2025 09:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IAG9pMFB"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5BC914B965
	for <kvm@vger.kernel.org>; Tue,  6 May 2025 09:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746524828; cv=none; b=i2cl5r67tr9MUG6h4s3YqsOt/zhiuhNUGMSr1LJ6E7d4Io/FQdRlR9dnYoTrtAfsm6yTnCMml8dw4zem9XWn8wUIyXEhgJI372XdYLFwTkaI3tNXpSgrg2F4lajH42OMXvWG4rR1p/1yumTpAoq5m0gwCeXG4zCL72i8RfZx+8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746524828; c=relaxed/simple;
	bh=NaOHLUD38g5uVAPkJa3LDoV309bafTR84K0xWTZR1FU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=clK55aF0j2uqa/in0e0BDJ2K+ZCOFTlnh3oZQx5lOGIKhBq8JxBKW2TkjUueHf+kPnQyA3tHvrG15fG/Vi77IS59yYD8sRZ9y4nJlkx5e1Au7AwJW7HNa/FNFmTFQv8iIXUtVXfKALCeGD5hBOSATEft+r3BvXZUHhIslmtMblY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IAG9pMFB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 62DC4C4CEE4
	for <kvm@vger.kernel.org>; Tue,  6 May 2025 09:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746524827;
	bh=NaOHLUD38g5uVAPkJa3LDoV309bafTR84K0xWTZR1FU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=IAG9pMFBfBONcjg7gVcJcnnwe6xkZXCZa9bL4RaUuXnNnxHwsIUR5RVrGff6UULAJ
	 aBrCRHASldRlpvoeOdiuHvYp3fq7NCDWcicXEQFVAxf0dci2PzTBjyULt8JbFuuii/
	 AQiimpGQzM1/WiafpIAg/p4WOqOT2akLv8pnp0P/2oqdEeEFS3T1AnBSw8uviqznOf
	 wceXRBTvKmQ2PUHOf75CrOiKv3aj6Eadokm2k37pVvf0YDuDSirpuWtFtF2FGYhoJb
	 Rfy7sQ5BMO9HjwiK1vwLlaLkuenVnKa7gZoa51hMTiDP/giMFQYhe4mcq69L0lThxW
	 0HZsSiHVeILOA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 5C002C41616; Tue,  6 May 2025 09:47:07 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Tue, 06 May 2025 09:47:06 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: f.gruenbichler@proxmox.com
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: PATCH_ALREADY_AVAILABLE
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-220057-28872-FcOvlGrmqf@https.bugzilla.kernel.org/>
In-Reply-To: <bug-220057-28872@https.bugzilla.kernel.org/>
References: <bug-220057-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220057

--- Comment #48 from Fabian Gr=C3=BCnbichler (f.gruenbichler@proxmox.com) -=
--
also see
https://lore.kernel.org/qemu-devel/20250130134346.1754143-1-clg@redhat.com/

I filed a bug about getting guest-phys-bits exposed on the PVE side as well:

https://bugzilla.proxmox.com/show_bug.cgi?id=3D6378

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

