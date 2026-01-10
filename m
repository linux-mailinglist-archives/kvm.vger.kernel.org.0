Return-Path: <kvm+bounces-67657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A51DD0DB5C
	for <lists+kvm@lfdr.de>; Sat, 10 Jan 2026 20:33:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BC4353023526
	for <lists+kvm@lfdr.de>; Sat, 10 Jan 2026 19:33:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D1F61A9F84;
	Sat, 10 Jan 2026 19:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gKSWJa3j"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D394A500948
	for <kvm@vger.kernel.org>; Sat, 10 Jan 2026 19:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768073605; cv=none; b=jmxH89xZQMMitvNGjid18t+eq77D94l1LC3nuTtZC100NPX1oRka6en6XWLsafy7FjDzZiYix1K4Q+adTt+Vz75gPXthtE2xseHqlCYvSf6ZOgJ8n2Q7adFi9+1CG29bjjpwau6mShcpvqi72ITgzukuhvcTohhBoTF6u2T1f9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768073605; c=relaxed/simple;
	bh=vCuQV2HPEThYfD439aivLTAKxmmk2vE3G0q4pKhrjS8=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=hnCe1RpFh13ftIWmTpcBufHJEqjurxiuU07lYKlcxDYbQDZx1FCGSOJ1QCFmEPdlZ+E9C9cczEQWnW9rOuarRGTTpS/6N5SQz6CLrxi57ioPmJqcHKaKQbwEu52bqgTSz0hPybgNdRKrTNt3E5x7ROBw3Jz9gdYCJuFZJ6HwCKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gKSWJa3j; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 64311C16AAE
	for <kvm@vger.kernel.org>; Sat, 10 Jan 2026 19:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768073605;
	bh=vCuQV2HPEThYfD439aivLTAKxmmk2vE3G0q4pKhrjS8=;
	h=From:To:Subject:Date:From;
	b=gKSWJa3joHNptr9/KnFm25F8HQ14ZJM0qEJPCWcCDdi6tsEevkIQi9++f7pR7MDJL
	 0LH2EBQOGnO64JAdnbfYMvdXG12gvrXeA4ApO30cNfoRqMD06I2DJ1eC2CISvO66S7
	 e4bTkr+vRLVn0liAB7wHTwtsHTACmAAqRacgacc2ZMbX9355Eui65s4NvVD3Sqr+mG
	 FnjUaNeAg3l2y+D4d9+0ifjGdMwa/CeRZFv+qHhw0gAdeS/3OJ9FvvlQ6C5QA2YgJk
	 qhFv0VF27FqDC4HF+CtAMlFZsOrBnYEmcc+sw+d/uQqIcPk5pIg6xpPqkWC8Y/z1ao
	 stUyUvvlENACQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 59E6AC53BC5; Sat, 10 Jan 2026 19:33:25 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220963] New: nSVM: missing unmap in nested_svm_vmrun()
Date: Sat, 10 Jan 2026 19:33:25 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: max@m00nbsd.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-220963-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220963

            Bug ID: 220963
           Summary: nSVM: missing unmap in nested_svm_vmrun()
           Product: Virtualization
           Version: unspecified
          Hardware: AMD
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: max@m00nbsd.net
        Regression: No

In nested_svm_vmrun():

    ret =3D kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map);
...
    if (WARN_ON_ONCE(!svm->nested.initialized))
        return -EINVAL;

A call to kvm_vcpu_unmap() is missing before the return.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

