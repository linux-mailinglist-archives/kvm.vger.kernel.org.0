Return-Path: <kvm+bounces-45587-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 632ADAAC08E
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 11:58:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 68E163A234F
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 09:57:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D996226989A;
	Tue,  6 May 2025 09:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O368wlyg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD271E1DE2
	for <kvm@vger.kernel.org>; Tue,  6 May 2025 09:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746525439; cv=none; b=B3EAtVGZh5ideZ28kfUM9+jRW/VX+H6OrnQ86ZNzkte9fhl2s6lfcrrj/4cOc6qKv2PnIKprscKck3bLqticxDFdIg6cfeW+TjwNdp020353RL8BY6sPmNIr6Ii/ffIMWNFBTA7XlLN3Lo7lygU2CYutSkBFWJnsVpEP8IU94zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746525439; c=relaxed/simple;
	bh=dpa3uyFxrlLgnxz4VjRO8qioVS7EEh6s38B3/QGvLQA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=enrv+auCX2GPG6mDqExSfkwyCpstyd1GQywNSlQQPsAihsyxJ0uJAF/usJqoCqj1nmrykjnMDU5I7BXZm8ORGrgRlLz3RTHsvNPCzy+RBubWE+AI5DOVhDQs9j9HLLUuxfkVC8Mz8fCYjNS+BS48rPVRuvs0RB6rqH4apnJzWVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O368wlyg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 657C6C4CEF2
	for <kvm@vger.kernel.org>; Tue,  6 May 2025 09:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746525437;
	bh=dpa3uyFxrlLgnxz4VjRO8qioVS7EEh6s38B3/QGvLQA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=O368wlygB4CXsQhyEkEHP6awJIiLXF2ikKtXTJYmOZkVmGcfDYT12HXyeeEANto8z
	 YTqSJRp3n3bios3wBDM5tKQhSzUR4SGn8ix3fHC1YRjK944GU+XXgEMpvuKB8ahGko
	 XyDdOXLllqmvEofYH3sFDWPgFPT8+ebKjh1TeC05ocuJKdeRBhHZvajRnBaPbAbfp9
	 bxt/phsFkoH7xPTJHC6ql4hQbm1yVSu41lgjxeNkJFcD1ci9oFxKhYuPAVfh34ju43
	 6FHMcl4PyjWq9pmQqGNJT0JR5gMnBKqG6vwPhc+2PitU1JldrlBDabuv4OGTuasdJ8
	 KsrOstNhcoP8Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 5D76EC41613; Tue,  6 May 2025 09:57:17 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220057] Kernel regression. Linux VMs crashing (I did not test
 Windows guest VMs)
Date: Tue, 06 May 2025 09:57:17 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: clg@kaod.org
X-Bugzilla-Status: RESOLVED
X-Bugzilla-Resolution: PATCH_ALREADY_AVAILABLE
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-220057-28872-7VwKs0BUvu@https.bugzilla.kernel.org/>
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

--- Comment #49 from C=C3=A9dric Le Goater (clg@kaod.org) ---
This series was partially merged and QEMU should now report the VFIO_MAP_DMA
error only once.=20
Checking that the IOMMU address space width is smaller than the CPU physical
address width needs some rework. I agree it would be good to have for consu=
mer
grade processors or when using a vIOMMU device with a 39-bit address width.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

