Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 454FB438EAC
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 07:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232362AbhJYFN6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 01:13:58 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:33803 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbhJYFN5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Oct 2021 01:13:57 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Hd32r3QQQz4xZ0;
        Mon, 25 Oct 2021 16:11:32 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1635138694;
        bh=dqey1eA2UwdztCXkBRMrK2SIQ19yGv/mM6F7haswWG0=;
        h=Date:From:To:Cc:Subject:From;
        b=uCG2vzS1gYLtqrvXZ1jIjfNXuFvgSWXtwFLRk/AnRQrlvhxU2gSCS1U075gNmAxBu
         4LthcWUIPfXGU1d27zXmg5Rt0lHFA93I64wgxfDaDhUPxvzud3z3T9XLl2frhMn8ID
         VO8CCCHsZo1EQt+j0n06b5BZ+igq4uj7Jsk9Z+Czm0emLH1nXP6F/x87ddKWmHbShC
         Q3J59coD4AFvVnm4rsbAMd9YLnZwWOhDN0qu9R3ZtJ6D0B84SV/FlYElFqBvsSPsA6
         eZ3zGgIG7PR0nsBGzlgQ4GZMkNryQa1397D52ADkK5Uzn+l3/vbgDxy3K16qiM+/Kb
         JxgrGdF5f4O7A==
Date:   Mon, 25 Oct 2021 16:11:31 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Borislav Petkov <bp@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>
Subject: linux-next: manual merge of the kvm tree with the tip tree
Message-ID: <20211025161131.5f2a2459@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/JzVuLz4fIkxGYvP21YSHyzC";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/JzVuLz4fIkxGYvP21YSHyzC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  arch/x86/kvm/x86.c

between commits:

  d69c1382e1b7 ("x86/kvm: Convert FPU handling to a single swap buffer")
  126fe0401883 ("x86/fpu: Cleanup xstate xcomp_bv initialization")

from the tip tree and commits:

  e8f65b9bb483 ("KVM: x86: Remove defunct setting of XCR0 for guest during =
vCPU create")
  583d369b36a9 ("KVM: x86: Fold fx_init() into kvm_arch_vcpu_create()")

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

diff --cc arch/x86/kvm/x86.c
index 5f1fc8224414,ac83d873d65b..000000000000
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@@ -10477,16 -10869,15 +10722,6 @@@ static int sync_regs(struct kvm_vcpu *v
  	return 0;
  }
 =20
- static void fx_init(struct kvm_vcpu *vcpu)
 -void kvm_free_guest_fpu(struct kvm_vcpu *vcpu)
--{
- 	/*
- 	 * Ensure guest xcr0 is valid for loading
- 	 */
- 	vcpu->arch.xcr0 =3D XFEATURE_MASK_FP;
-=20
- 	vcpu->arch.cr0 |=3D X86_CR0_ET;
 -	if (vcpu->arch.guest_fpu) {
 -		kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
 -		vcpu->arch.guest_fpu =3D NULL;
 -	}
--}
 -EXPORT_SYMBOL_GPL(kvm_free_guest_fpu);
--
  int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
  {
  	if (kvm_check_tsc_unstable() && atomic_read(&kvm->online_vcpus) !=3D 0)
@@@ -10543,13 -10934,24 +10778,11 @@@ int kvm_arch_vcpu_create(struct kvm_v=
cp
  	if (!alloc_emulate_ctxt(vcpu))
  		goto free_wbinvd_dirty_mask;
 =20
 -	vcpu->arch.user_fpu =3D kmem_cache_zalloc(x86_fpu_cache,
 -						GFP_KERNEL_ACCOUNT);
 -	if (!vcpu->arch.user_fpu) {
 -		pr_err("kvm: failed to allocate userspace's fpu\n");
 -		goto free_emulate_ctxt;
 -	}
 -
 -	vcpu->arch.guest_fpu =3D kmem_cache_zalloc(x86_fpu_cache,
 -						 GFP_KERNEL_ACCOUNT);
 -	if (!vcpu->arch.guest_fpu) {
 +	if (!fpu_alloc_guest_fpstate(&vcpu->arch.guest_fpu)) {
  		pr_err("kvm: failed to allocate vcpu's fpu\n");
 -		goto free_user_fpu;
 +		goto free_emulate_ctxt;
  	}
 -	fpstate_init(&vcpu->arch.guest_fpu->state);
 -	if (boot_cpu_has(X86_FEATURE_XSAVES))
 -		vcpu->arch.guest_fpu->state.xsave.header.xcomp_bv =3D
 -			host_xcr0 | XSTATE_COMPACTION_ENABLED;
 =20
- 	fx_init(vcpu);
-=20
  	vcpu->arch.maxphyaddr =3D cpuid_query_maxphyaddr(vcpu);
  	vcpu->arch.reserved_gpa_bits =3D kvm_vcpu_reserved_gpa_bits_raw(vcpu);
 =20

--Sig_/JzVuLz4fIkxGYvP21YSHyzC
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmF2PIMACgkQAVBC80lX
0GxIXwgAhFRBBXN8TicCFlnXDTCCTcqH/BKGU6+GtJwpit1FKb3e9uRtqdBAEZ3T
0xV57z2pG+PTEpsEHzkT2SHcm+EJUWHqyqNOiMD+ujwCDXJa6BmfopGhP4NmxLj0
/V22naNz/KKf77bOMmaAcqhf1AFCf15cVjpjIjPtZnjai8XrB+IU3bpi4kRsF09p
nc1uWEglXCDzfRJYYjsNrSZLs0LbzirFc2nqAS7sk+5pTVmK4pJXRKqI8G4AFz7n
qulKjxAZwuWTzBR5C5HyhWaVU+lAQSqCZP2yjKUw2KKrrAoXSDbiQtLDQLSd0bmp
MHJT0cbd8U9+vEXcu3ZtwzagJh5mJQ==
=/qAC
-----END PGP SIGNATURE-----

--Sig_/JzVuLz4fIkxGYvP21YSHyzC--
