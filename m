Return-Path: <kvm+bounces-21763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 251359335E8
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 05:58:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1990FB21882
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 03:58:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 374219445;
	Wed, 17 Jul 2024 03:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="N3RBKi2y"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69283FC0C;
	Wed, 17 Jul 2024 03:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721188697; cv=none; b=dfPGj4I5u74UsBoqhwiNLxYg4J+2UJqqRSy60e3gJ75kPQedP9Io09D++aUy++aboReUgIkZ94gVBXLNZYI+Rt6LKMkn08+g+vnLahO9Pt8sIm0poBsSU9044J3elT9iELDL2x5vLO8gB0rlpH/Pm8LZ1rgPRAns27cUERIrq/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721188697; c=relaxed/simple;
	bh=ErzNXfVr9t0N2i+mZKNCo2YiLrO+KAwhi0XJ235rc/Y=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=rEr9dOaTQI23Qovi8xGq7gdBKcmEcNCPFkAWiRW31JVhWF22unizN2gZlk4no7eXyZ/TSHaBrU6GYc22ryu/91X02pktXQG7W3K1NRF90VqbKyJv3xXStbvtCiwwB9ddxVR2pVmMtYqXHZVwzmaVkfPi2Rq9dNgum81zeUkNlII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au; spf=pass smtp.mailfrom=canb.auug.org.au; dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b=N3RBKi2y; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canb.auug.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canb.auug.org.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1721188690;
	bh=qjmvMW3ryvAUVCwVa8SsKtZOuv9jvCjURGIzXMW8qrY=;
	h=Date:From:To:Cc:Subject:From;
	b=N3RBKi2ynwFWds6cGhVhjwzvS/cJRMNq1hkp21+rccFInIKSutg9QqFVAXf05yHD6
	 oLtDp8VPDojyA411LDHsdBpOi0DfqHB7uJi5wiCy2jocO9fcTXzNeVgAhnxT9ofANf
	 hD52e3JjLE0YJF5os5cEdSNFkqQWa9uUbUSPMGROcjPtMoe/7xxTE2dG3lsim/OYDE
	 CusihFZR5PUYQcd5bEX7IGW+qgC7WywpHFwEuzU5K9qTB/jTo03BDrZ33DLKptLDDl
	 Mi5i/v617oi5WLsolAY59v1ZDUxJFMixzuGik7juQnZ5BGGzsUYzQ+wrCUAx0hDZPJ
	 SPZd1CFW+hs8g==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4WP2GS5CL0z4w2R;
	Wed, 17 Jul 2024 13:58:08 +1000 (AEST)
Date: Wed, 17 Jul 2024 13:58:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>, Julian Stecklina
 <julian.stecklina@cyberus-technology.de>, Reinette Chatre
 <reinette.chatre@intel.com>, Thomas Prescher
 <thomas.prescher@cyberus-technology.de>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: linux-next: manual merge of the kvm-x86 tree with the kvm tree
Message-ID: <20240717135808.4336a972@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/k86CtB=6SdCjLZkhyLhDNaR";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/k86CtB=6SdCjLZkhyLhDNaR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm-x86 tree got conflicts in:

  arch/x86/kvm/x86.c
  include/uapi/linux/kvm.h

between commits:

  bc1a5cd00211 ("KVM: Add KVM_PRE_FAULT_MEMORY vcpu ioctl to pre-populate g=
uest memory")
  6e01b7601dfe ("KVM: x86: Implement kvm_arch_vcpu_pre_fault_memory()")

from the kvm tree and commits:

  6fef518594bc ("KVM: x86: Add a capability to configure bus frequency for =
APIC timer")
  85542adb65ec ("KVM: x86: Add KVM_RUN_X86_GUEST_MODE kvm_run flag")

from the kvm-x86 tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc arch/x86/kvm/x86.c
index a6968eadd418,994743266480..000000000000
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@@ -4703,11 -4690,12 +4690,15 @@@ int kvm_vm_ioctl_check_extension(struc
  	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
  	case KVM_CAP_IRQFD_RESAMPLE:
  	case KVM_CAP_MEMORY_FAULT_INFO:
+ 	case KVM_CAP_X86_GUEST_MODE:
  		r =3D 1;
  		break;
 +	case KVM_CAP_PRE_FAULT_MEMORY:
 +		r =3D tdp_enabled;
 +		break;
+ 	case KVM_CAP_X86_APIC_BUS_CYCLES_NS:
+ 		r =3D APIC_BUS_CYCLE_NS_DEFAULT;
+ 		break;
  	case KVM_CAP_EXIT_HYPERCALL:
  		r =3D KVM_EXIT_HYPERCALL_VALID_MASK;
  		break;
diff --cc include/uapi/linux/kvm.h
index e5af8c692dc0,e065d9fe7ab2..000000000000
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@@ -917,7 -930,8 +930,9 @@@ struct kvm_enable_cap=20
  #define KVM_CAP_MEMORY_ATTRIBUTES 233
  #define KVM_CAP_GUEST_MEMFD 234
  #define KVM_CAP_VM_TYPES 235
 -#define KVM_CAP_X86_APIC_BUS_CYCLES_NS 236
 -#define KVM_CAP_X86_GUEST_MODE 237
 +#define KVM_CAP_PRE_FAULT_MEMORY 236
++#define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
++#define KVM_CAP_X86_GUEST_MODE 238
 =20
  struct kvm_irq_routing_irqchip {
  	__u32 irqchip;

--Sig_/k86CtB=6SdCjLZkhyLhDNaR
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmaXQVAACgkQAVBC80lX
0GwDvwf+MbMjZO3kyub4am8TJrGJh0V8CIxAGcQzgjOEPGJyaXHkti9B8+xkqqwE
fUtxlHfwdykKa8MrmLFNv2C6vR1nyiMNyOzCeQKmNSru6zIO/QpKjRlPNBbxET2N
5RW5H5NqDGz2iQNDUCLJ8OyccAoysgk+a9yMFZsGhvZonRq/01FnBGVgv4MTOxLq
Q11t9kqmWeZ8YCUMRuzyZ8CtOYRC/CXAwAKckikOJ4K+om858+UhmBVVD2zZ7IVo
AB1KO4rYWL6GJd8ZtH2wqspg1VkLJExVzuI3EJ7+noyv1YnTcqcaDjp6g+r1dVnp
HsHkta/UadRytDd325CZFWHdbZ/W7A==
=Ug80
-----END PGP SIGNATURE-----

--Sig_/k86CtB=6SdCjLZkhyLhDNaR--

