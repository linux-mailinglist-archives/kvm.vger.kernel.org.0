Return-Path: <kvm+bounces-67658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 88CFAD0DD0C
	for <lists+kvm@lfdr.de>; Sat, 10 Jan 2026 21:03:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 84D133008988
	for <lists+kvm@lfdr.de>; Sat, 10 Jan 2026 20:03:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6677B2BDC10;
	Sat, 10 Jan 2026 20:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gq1SZFV4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9604929B795
	for <kvm@vger.kernel.org>; Sat, 10 Jan 2026 20:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768075388; cv=none; b=B1e37Mzfg1Kc+9M7aMeqp+CyXGa0IgieVEv3JzSnM0V5szKNQ2EHGe8rvXgtuZacI7QFRFBIdFXa6EqdCOYzMGAohVDdQeqAFyIqrmCRWb+3MjdORk7u6ukMbos2ZUVHpnWdTEoD9tGjzbO5+C+9sClpOeLv8zLadyMJGwskZUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768075388; c=relaxed/simple;
	bh=LXWycroEfD3YqrjtWFUi+1Lngay5LYjhFbUggkE0ofM=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=pGSy4FbvAzmpLuuSDJ6060ac+vgInopoAGeOEAJIKluBWQ01q4HwQEL7k3lRNt+9Qd4AXoMXoVijCfSJFy6+CUnts+mSVN5OZhbI9T9wHloj5mQxvR/dsB9MURKy9sVjVZk7G4m/udVku4/npdMWfd0dqGtZuasyMUZ2Fhlw87E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gq1SZFV4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2D1FBC19424
	for <kvm@vger.kernel.org>; Sat, 10 Jan 2026 20:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768075388;
	bh=LXWycroEfD3YqrjtWFUi+1Lngay5LYjhFbUggkE0ofM=;
	h=From:To:Subject:Date:From;
	b=Gq1SZFV4azVO1p5cvAgOWGAyEIGe+adCu9EQ0zoQTDfXDFPJwQGUp1gqSfOEGUk27
	 ZIwM7ZOfyDpYMylbJLq6XsyR3H5sz7bZxxzEgdEkVgjNohL8Ba0tbGelWZE3s7fC4W
	 V3lYPny3qbUpFA9y4B5lC2AlbPFkoWa+EGno70Ap37HvAYC7M4WecBpHKskyxvHQMm
	 ZVBCTRE1BfY/c8vPiSsdD0jHnWwZ6IwLWTp0g0TX68q/rBY9ArCsbbzb2vUXTNpFmO
	 OgPgi5b/ro5KY6G5a33DO7yLI+P9x/pZw+6JGbJrm1fRDfE3imdyIeLiVu+w0bk/bL
	 QoQGN975JO2JQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 23A9FC4160E; Sat, 10 Jan 2026 20:03:08 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220964] New: nSVM: missing sanity checks in svm_leave_smm()
Date: Sat, 10 Jan 2026 20:03:07 +0000
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
Message-ID: <bug-220964-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220964

            Bug ID: 220964
           Summary: nSVM: missing sanity checks in svm_leave_smm()
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

In svm_leave_smm():

    svm_copy_vmrun_state(&svm->vmcb01.ptr->save, map_save.hva + 0x400);
...
    nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
    nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
    ret =3D enter_svm_guest_mode(vcpu, smram64->svm_guest_vmcb_gpa, vmcb12,
false);

map_save.hva and vmcb12 are guest mappings, but there is no sanity check
performed on the copied control/save areas. It seems that this allows the g=
uest
to modify restricted values (intercepts, EFER, CR4) and gain access to CPU
features the host may not support or expose.

nested_copy_vmcb_control_to_cache() and nested_vmcb_check_controls() ought =
to
be combined into one function, same with nested_copy_vmcb_save_to_cache() a=
nd
nested_vmcb_check_save(), to eliminate the risk that a copy is made without
sanity check.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

