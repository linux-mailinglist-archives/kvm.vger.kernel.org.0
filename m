Return-Path: <kvm+bounces-54789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C69DB2818B
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 16:22:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7B5111D03D81
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 14:22:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FAC321D3F3;
	Fri, 15 Aug 2025 14:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mZIJCBCg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B721B19004E
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 14:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755267738; cv=none; b=NBGjEPuL5qFS19xl5Sq/Aa5zcYxJndGCMZi5ghptjO2pxnTSqM9vlj3Z8i0Fe9Gul8xRjmbaoPFrpAYDOc9BWX2UuJyCZ6yIKmvuS9bY8lFzi7v5Gv3AfBtxPYkzmgbH46tD9EHxcWiQoVh0p2uVYBLa6+GG8Q2U7JFP8xX9+dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755267738; c=relaxed/simple;
	bh=3RDhHTuTyXWdkQU/PxhIP2U/wW9w68NuOjqTfisgIsQ=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=QQ31IdiT2DlBtQfY6E47KTLOLeEiuCcRgMROOtNAZWKsHfArA32HYM0sWr6eok6uek19vPtUxD9XtuDAPsaAfWqCV3+KDZeIdhDQa49dEjzaqSsETMgQIDgEN04r/IviDFBow9rsvtcegyKqypGE5X5fL63tZ1snlA3pH7mh7ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mZIJCBCg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 57C8BC4CEF6
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 14:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755267738;
	bh=3RDhHTuTyXWdkQU/PxhIP2U/wW9w68NuOjqTfisgIsQ=;
	h=From:To:Subject:Date:From;
	b=mZIJCBCgIZ5dc2P4J2VbJCzC1HM/ucpFPsEAaGikqApvTRFkJvZ2yhG2BWGrEL8UD
	 eoR69/PM6C8hKGAO0yWpt2sjt+koryHDIenWzsStMtp4D/jiNYpxYran08+YotfTxb
	 CLnyzT33F18zaOPUELKBQn/FV2uBfiASjx9TdA1jIkLvum6cV9S1305lIhg4HkOcmH
	 J03IQ6mjdSQCg1YuhNbgl32VI5vW/UlamZwxabBB3+kGN52HGETME8Pb7FJtTHxai/
	 rut+O9J7M6n+Rjl4UQqVBNWZP2W6nMmtHO59A0hcUswhiY0QImqf4Qx6jZZV4RRbl/
	 lLun+qz9DcmiQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 4C429C53BC9; Fri, 15 Aug 2025 14:22:18 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 220453] New: kvm/arm64: nv - guest with hypervisor hangs
Date: Fri, 15 Aug 2025 14:22:18 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: amy.fong.3142@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-220453-28872@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220453

            Bug ID: 220453
           Summary: kvm/arm64: nv - guest with hypervisor hangs
           Product: Virtualization
           Version: unspecified
          Hardware: ARM
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: amy.fong.3142@gmail.com
        Regression: No

On a kernel with nested virtualization (seen in 6.16 and 6.17rc1) on a
neoverse-v2 system, attempts to create a guest with virtualization capabili=
ties
fails. The guest hangs and a kernel bug dump is seen.

The defect is not seen when the nested virt system is booted from qemu using
neoverse-v1

* fails: lkvm run ... --nested
* passes: lkvm run ... --nested --e2h0

Using git bisect, the following commit
(b5fa1f91e11fdf74ad4e2ac6dae246a57cbd2d95) results in the defect, reverting=
 the
patch removes the issue.

commit b5fa1f91e11fdf74ad4e2ac6dae246a57cbd2d95
Author: Marc Zyngier <maz@kernel.org>
Date:   Tue Jun 3 08:08:24 2025 +0100

    KVM: arm64: Make __vcpu_sys_reg() a pure rvalue operand

Kernel bug dump:


Aug 15 01:47:28 graviton-d kernel: ------------[ cut here ]------------
Aug 15 01:47:28 graviton-d kernel: WARNING: CPU: 1 PID: 178543 at
./arch/arm64/include/asm/kvm_emulate.h:595 perform_access+0x
d4/0xe0
Aug 15 01:47:28 graviton-d kernel: Modules linked in: snd_seq_dummy snd_hrt=
imer
snd_seq snd_seq_device snd_timer snd soundcore
 xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp
nft_compat x_tables nft_chain_nat nf_nat nf_conntr
ack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables nfnetlink bridge stp llc vgem
drm_shmem_helper drm_kms_helper binfmt_misc nls_asci
i nls_cp437 vfat fat rpcsec_gss_krb5 aes_ce_blk aes_ce_cipher polyval_ce
ghash_ce gf128mul sha3_ce sha3_generic arm_smmuv3_pmu
 arm_spe_pmu arm_cmn evdev nfsv4 nfsd dns_resolver nfs auth_rpcgss nfs_acl
lockd drm grace dm_mod sunrpc ecryptfs loop dax drm
_panel_orientation_quirks configfs efivarfs autofs4
Aug 15 01:47:28 graviton-d kernel: CPU: 1 UID: 0 PID: 178543 Comm: kvm-vcpu=
-0
Not tainted 6.17.0-rc1-dirty #29 VOLUNTARY=20
Aug 15 01:47:28 graviton-d kernel: Hardware name: Amazon EC2 r8g.metal-24xl=
/Not
Specified, BIOS 1.0 10/16/2017
Aug 15 01:47:28 graviton-d kernel: pstate: 02400009 (nzcv daif +PAN -UAO +T=
CO
-DIT -SSBS BTYPE=3D--)
Aug 15 01:47:28 graviton-d kernel: pc : perform_access+0xd4/0xe0
Aug 15 01:47:28 graviton-d kernel: lr : perform_access+0x4c/0xe0
Aug 15 01:47:28 graviton-d kernel: sp : ffff8000c31af850
Aug 15 01:47:28 graviton-d kernel: x29: ffff8000c31af850 x28: ffff0003d8886=
d80
x27: 0000000000000000
Aug 15 01:47:28 graviton-d kernel: x26: 0000000000000000 x25: ffff00007780c=
4e0
x24: 0000000000000000
Aug 15 01:47:28 graviton-d kernel: x23: ffff00007780c528 x22: 0000000000000=
000
x21: ffff8000c31af890
Aug 15 01:47:28 graviton-d kernel: x20: ffffb5accbdc0da0 x19: ffff00007780c=
4e0
x18: ffff8000c31af180
Aug 15 01:47:28 graviton-d kernel: x17: 000000040044ffff x16: 00100075f5507=
510
x15: 0000000000000000
Aug 15 01:47:28 graviton-d kernel: x14: 0000000000000000 x13: 0000000000000=
000
x12: 0000000000001388
Aug 15 01:47:28 graviton-d kernel: x11: 00000000000013f0 x10: 0000000000001=
4c0
x9 : ffffb5accac9e2f0
Aug 15 01:47:28 graviton-d kernel: x8 : ffff8000c31af8d8 x7 : 0000000000000=
000
x6 : 0000000000000004
Aug 15 01:47:28 graviton-d kernel: x5 : 000000000000000f x4 : ffffb5accac9e=
3dc
x3 : ffff0003d8886d80
Aug 15 01:47:28 graviton-d kernel: x2 : ffffb5accaca1510 x1 : 0000000000000=
000
x0 : 0000000000000009
Aug 15 01:47:28 graviton-d kernel: Call trace:
Aug 15 01:47:28 graviton-d kernel:  perform_access+0xd4/0xe0 (P)
Aug 15 01:47:28 graviton-d kernel:  kvm_handle_sys_reg+0xfc/0x1a0
Aug 15 01:47:28 graviton-d kernel:  handle_exit+0x68/0x168
Aug 15 01:47:28 graviton-d kernel:  kvm_arch_vcpu_ioctl_run+0x2cc/0x908
Aug 15 01:47:28 graviton-d kernel:  kvm_vcpu_ioctl+0x1a8/0xb20
Aug 15 01:47:28 graviton-d kernel:  __arm64_sys_ioctl+0xb4/0x118
Aug 15 01:47:28 graviton-d kernel:  invoke_syscall+0x70/0x100
Aug 15 01:47:28 graviton-d kernel:  el0_svc_common.constprop.0+0xc8/0xf0
Aug 15 01:47:28 graviton-d kernel:  do_el0_svc+0x24/0x38
Aug 15 01:47:28 graviton-d kernel:  el0_svc+0x34/0xf0
Aug 15 01:47:28 graviton-d kernel:  el0t_64_sync_handler+0xa0/0xe8
Aug 15 01:47:28 graviton-d kernel:  el0t_64_sync+0x198/0x1a0
Aug 15 01:47:28 graviton-d kernel: ---[ end trace 0000000000000000 ]---

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

