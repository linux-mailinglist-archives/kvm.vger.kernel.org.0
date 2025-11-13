Return-Path: <kvm+bounces-62985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 04AB1C55ECB
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 07:30:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B87873A5350
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 06:30:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C253E320A34;
	Thu, 13 Nov 2025 06:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ck6dP5v2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3AD3320CAC
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 06:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763015438; cv=none; b=rldkVcg05duPywtYhjU1YLhS1XoTEueaWt2ZVCHnaXjNrQOS+tve/6BUeZwhWsTJIA0yORbfCeH96jzv3z7U+Cp6yXq/Zo7BOAoOdO2bLerU2PfdK23hVPAbGV8I0Hl51xnJj6mFSBCwIT10vAQ0DMhlJK79QgBeVkSDgeslfAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763015438; c=relaxed/simple;
	bh=haVHQVJsDLLuhsqok9h8w6p46BwZG92+GssXe5yxVI4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=e3jw0ZbQ+NJLW2nCw8vJ63anqVQZGudTMt5hcF3k9kVMM804DaXmI4mtiFT2SF9z8/glisFz8UoFlhWNjWVOodwORR/Gv5LoMylMf8KSpDu6L5TMbQOCYX5uueNwGOmtq/Xc5Nq3TH5qMm388dfm2lFAyumahe5tNTEmPeRzFJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ck6dP5v2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5593DC4CEF5
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 06:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763015438;
	bh=haVHQVJsDLLuhsqok9h8w6p46BwZG92+GssXe5yxVI4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Ck6dP5v2y7fFcYDvxH3oJ0KCfS+RNCJxMjuj3lvtsX/z3C2xtSzg14YXbNcKcgUsR
	 4pavs532E7auL+t2awWpAsQ7UAYj7uRkB7Frq0CAdMV+EtXspUNumivcLypeZa2AAK
	 IoQUPSVTa6p4ItgN5boGC1C+NyQYak20dgv+bZXFfo7mli/DkYAuST866lz+6skC1o
	 LcGgX6GwCENZpDBndn88LgFoOuikBpYNfQ5FX9LhYaq4b4sMVM6y4Ghc6BtKG445zm
	 GuZre87ewvldDP1dKq+t9EirR2cw5KVMJEyyDlQFq+7VCRaqmPr6seSr7Uim1m78PA
	 4HdnOTNztnGyw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 44F9DCAB789; Thu, 13 Nov 2025 06:30:38 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220776] When passthrough device to KVM guest with
 iommufd+hugepage, more hugepage are used than assigned, and DMAR error
 reported from host dmesg
Date: Thu, 13 Nov 2025 06:30:36 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: farrah.chen@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-220776-28872-mYDxR2M3st@https.bugzilla.kernel.org/>
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

--- Comment #2 from Chen, Fan (farrah.chen@intel.com) ---
Involve the author steven.sistare@oracle.com of related patches to take=20
a look.

Thanks,
Fan

On 11/11/2025 5:01 PM, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D220776
>=20
> chenyi.qiang@intel.com changed:
>=20
>             What    |Removed                     |Added
> -------------------------------------------------------------------------=
---
>                   CC|                            |chenyi.qiang@intel.com
>=20
> --- Comment #1 from chenyi.qiang@intel.com ---
> After some bisect, it is found that this issue is introduced by the suppo=
rt
> of
> dma_map_file in iommufd [1][2]. With hugetlbfs as backend, it will go to =
the
> path of IOMMU_IOAS_MAP_FILE ioctl. If we fallback to the IOMMU_IOAS_MAP
> ioctl,
> there's no such problem.
>=20
> [1]
>
> https://lore.kernel.org/qemu-devel/1751493538-202042-9-git-send-email-ste=
ven.sistare@oracle.com/
> [2]
>
> https://lore.kernel.org/all/1729861919-234514-1-git-send-email-steven.sis=
tare@oracle.com/
>

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

