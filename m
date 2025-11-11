Return-Path: <kvm+bounces-62735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id DC2B9C4C81D
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 10:02:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 43E7E4EE0F5
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 09:01:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42B42257859;
	Tue, 11 Nov 2025 09:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kf57C/VV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6413E1EF091
	for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 09:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762851690; cv=none; b=BDMUUv8sOzDTzrHxGG/PA1HbzqARsjQToLzH7ForF5NH7not4IvpJOhvw4ze0LuTjVmODnW/9i6ryyzAwzgc+DU63VIujwiNi/h6VzLNGm4y78ThqQE1I5QCz6tRWt2izBTZaxwZGruOnP0nLI7yNqhbRrcvBPNM0LMrG5xQGEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762851690; c=relaxed/simple;
	bh=3Rc0vTpdgZAi+xwr39T2Z0I1tMf0gx5jz+PKfoiespI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=p6FXBwXgsWGzazF6MpIiR1bKSa+4faqkhp3gRhvc73Z9n1SdUrJkHndYlZZVc0BOGeqZV0ty+c0lPxktiwtg0rF3E51NV8VTWq3FlfLPDEQXwHA9p+Yve2vWQhn4U0XhTB6ji8y2gD7WFDWtjhHabpFTYuhjhO4LiskvkpSEw88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kf57C/VV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id DB27EC4CEF7
	for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 09:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762851689;
	bh=3Rc0vTpdgZAi+xwr39T2Z0I1tMf0gx5jz+PKfoiespI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Kf57C/VVOkNfqROv1acN7W7oop2SjRpV59EswDK124zAbkg4tCUIVPdPtRChnU0D7
	 EyusnqnOkSBr2jPA0mZcXZjsCvRIbsNPJ6MgLsfWh7RdOxGdZNma9z38h7cOHUhXo6
	 JDh9CkJbDMqyC9BsKcZdfMMrBAumJasL3HtBFbK4bghLhf3PF2Ey7aqdZP48gJpiR9
	 1DzMVsdskOjX4rhO4yeyEdepiT6k8i3Y+FVy2yAEvMrc8qagvfNGE4WnH9yo6y+zxB
	 DQp/95TV5Vf9edeOPk/f6p5rWJtDQGMDSRR0QlCNJy1S3bBFpFFBmz5kQ9b8fs9nre
	 +0tIhBz2b2Itg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id CFBD0CAB784; Tue, 11 Nov 2025 09:01:29 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220776] When passthrough device to KVM guest with
 iommufd+hugepage, more hugepage are used than assigned, and DMAR error
 reported from host dmesg
Date: Tue, 11 Nov 2025 09:01:27 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: chenyi.qiang@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-220776-28872-BlSJOmrKdb@https.bugzilla.kernel.org/>
In-Reply-To: <bug-220776-28872@https.bugzilla.kernel.org/>
References: <bug-220776-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220776

chenyi.qiang@intel.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |chenyi.qiang@intel.com

--- Comment #1 from chenyi.qiang@intel.com ---
After some bisect, it is found that this issue is introduced by the support=
 of
dma_map_file in iommufd [1][2]. With hugetlbfs as backend, it will go to the
path of IOMMU_IOAS_MAP_FILE ioctl. If we fallback to the IOMMU_IOAS_MAP ioc=
tl,
there's no such problem.

[1]
https://lore.kernel.org/qemu-devel/1751493538-202042-9-git-send-email-steve=
n.sistare@oracle.com/
[2]
https://lore.kernel.org/all/1729861919-234514-1-git-send-email-steven.sista=
re@oracle.com/

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

