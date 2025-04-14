Return-Path: <kvm+bounces-43206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 72EEDA876A9
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 06:14:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8DB73ABBFA
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 04:14:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DE6A19DFB4;
	Mon, 14 Apr 2025 04:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="HN6IPRCX"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951ABF9FE;
	Mon, 14 Apr 2025 04:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744604064; cv=none; b=Yd74YKoK5CGIX5l568sDcgxdec9s4zE3NxsF96E+myXKQHm+ZJzVrJgkGiFzALhQdW79F/pUB0PJYUvwRvNOKqZ+FxPVY/UWgs507cO9Tha2Lc3lYOklOzvdYxq56GzwJxkgTaul3Ylhr7sOSbpwIqX7LsD8peQ4smRsbKnn2EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744604064; c=relaxed/simple;
	bh=9ycSAGCn/N7lHXI00aJ49NEF/zfU6sodzqjJrT6h6Lw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=bR4lmZshICPcDSMZw1ut0S3c/XOtXzGjmhbqDzELlJqq2JGoxrdSTmb/bPJNPT9l5Pqs+/bVzWUO0OjRakoD4Cj8j0TtU06cXppGrz46voYWTg1SVcpM7fB7Lws8XQl2P7WZ0Xi1vNp6H7MlZbBwz0jc936xNcEdorPoT88Jn5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=HN6IPRCX; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=202503; t=1744604054;
	bh=+W04DPVRK/5aBuiIFsxv0Q9xp/bifT9N7ci3BNtR8oQ=;
	h=Date:From:To:Cc:Subject:From;
	b=HN6IPRCX9Q+zAxm9iIgtg+x3BldQum1YUaay2DEmtrB88goNETQck4100TT25o6ZL
	 H7JPBoiPARz/7+8KjvlrnPtfyGtvK9N4q15U/1o4dDGOfymDrHpv+fh6THaNsI370Z
	 3AfPotLKZ3FUGsyAIqCl+p77AL3w4hfJM95uBQCnsGTNDeOrmsFNEycA3KPtA1H66d
	 DQ3Fsg9YW+KLAyL4ErCz6RWtqaCOMIKsxhzROv6HvulzJ9BE8XqwT6AUop0eielSm6
	 IXFJ71RCJzolFbJSSFaYFmcy+5qYrJP2g/aAEpn5vhCt6mxMZOy99lc4cahjVmPN8Z
	 IYJ7Lp0wCoVAw==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4ZbYnw1YcMz4wbr;
	Mon, 14 Apr 2025 14:14:12 +1000 (AEST)
Date: Mon, 14 Apr 2025 14:14:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner
 <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin"
 <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>, Binbin Wu
 <binbin.wu@linux.intel.com>, Ingo Molnar <mingo@kernel.org>, KVM
 <kvm@vger.kernel.org>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the kvm tree with the tip tree
Message-ID: <20250414141411.469e897f@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/nSJ+XbEAEFZjcicWsadWvu3";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/nSJ+XbEAEFZjcicWsadWvu3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  arch/x86/kvm/vmx/vmx.c

between commits:

  c435e608cf59 ("x86/msr: Rename 'rdmsrl()' to 'rdmsrq()'")
  78255eb23973 ("x86/msr: Rename 'wrmsrl()' to 'wrmsrq()'")

from the tip tree and commit:

  7172c753c26a ("KVM: VMX: Move common fields of struct vcpu_{vmx,tdx} to a=
 struct")

from the kvm tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc arch/x86/kvm/vmx/vmx.c
index cd0d6c1fcf9c,ef2d7208dd20..000000000000
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@@ -1335,10 -1337,10 +1337,10 @@@ void vmx_prepare_switch_to_guest(struc
  		savesegment(fs, fs_sel);
  		savesegment(gs, gs_sel);
  		fs_base =3D read_msr(MSR_FS_BASE);
- 		vmx->msr_host_kernel_gs_base =3D read_msr(MSR_KERNEL_GS_BASE);
+ 		vt->msr_host_kernel_gs_base =3D read_msr(MSR_KERNEL_GS_BASE);
  	}
 =20
 -	wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);
 +	wrmsrq(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);
  #else
  	savesegment(fs, fs_sel);
  	savesegment(gs, gs_sel);
@@@ -1382,10 -1384,10 +1384,10 @@@ static void vmx_prepare_switch_to_host(
  #endif
  	invalidate_tss_limit();
  #ifdef CONFIG_X86_64
- 	wrmsrq(MSR_KERNEL_GS_BASE, vmx->msr_host_kernel_gs_base);
 -	wrmsrl(MSR_KERNEL_GS_BASE, vmx->vt.msr_host_kernel_gs_base);
++	wrmsrq(MSR_KERNEL_GS_BASE, vmx->vt.msr_host_kernel_gs_base);
  #endif
  	load_fixmap_gdt(raw_smp_processor_id());
- 	vmx->guest_state_loaded =3D false;
+ 	vmx->vt.guest_state_loaded =3D false;
  	vmx->guest_uret_msrs_loaded =3D false;
  }
 =20
@@@ -1393,8 -1395,8 +1395,8 @@@
  static u64 vmx_read_guest_kernel_gs_base(struct vcpu_vmx *vmx)
  {
  	preempt_disable();
- 	if (vmx->guest_state_loaded)
+ 	if (vmx->vt.guest_state_loaded)
 -		rdmsrl(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);
 +		rdmsrq(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);
  	preempt_enable();
  	return vmx->msr_guest_kernel_gs_base;
  }
@@@ -1402,8 -1404,8 +1404,8 @@@
  static void vmx_write_guest_kernel_gs_base(struct vcpu_vmx *vmx, u64 data)
  {
  	preempt_disable();
- 	if (vmx->guest_state_loaded)
+ 	if (vmx->vt.guest_state_loaded)
 -		wrmsrl(MSR_KERNEL_GS_BASE, data);
 +		wrmsrq(MSR_KERNEL_GS_BASE, data);
  	preempt_enable();
  	vmx->msr_guest_kernel_gs_base =3D data;
  }

--Sig_/nSJ+XbEAEFZjcicWsadWvu3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmf8i5MACgkQAVBC80lX
0GzeIwgAnzRzSi2V66oIYBWxZD4sIyBa2SGobBMhHPkR8v10wuPt3U3Tqj7EQ0pr
PKXY+6Yn+6qRpbce9eMFJvGwKf8IfeT6/pvCm6Skv+QAZMHTJ4Fa1HItT5nltvyB
4+APOrzYjg7CMyXtVWPQlyA08FgH5O3c4VheP3tapvsjCz7NF+nUtQZkgWWyCfly
yIfmq1PWrVGB1Jf+B3j7U7AFhzBHIjEodxh2/1X276Hu2oCHXzf+9t9MFF2cGLlM
tPkBrCGxxQ2bvQzAld9rPU+f0tRyE1jpBP3+W9JuzZYW3HPCbYdrXd6Qxcvav0ED
DJfzmKAq99fbx/PDEIq47MiBSfVLSw==
=U3sT
-----END PGP SIGNATURE-----

--Sig_/nSJ+XbEAEFZjcicWsadWvu3--

