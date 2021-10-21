Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B56194358B3
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 04:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbhJUClv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 22:41:51 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:44987 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbhJUClv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 22:41:51 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HZWsK2Q6yz4xbR;
        Thu, 21 Oct 2021 13:39:33 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1634783974;
        bh=+YyK2gDFC5pqxheqkppYraxAoWcWTs5ApJx+siznQCA=;
        h=Date:From:To:Cc:Subject:From;
        b=aOu1rVLY8PczP6jaNaEL2OlgAf3P9/Ton1QIJrYym+HqdNHcZJLqvkf3G3lfpo9Rv
         LKA/D/oSxAC263a/A5zrictSLAwftvYDxVTKiodOgC3IYdS1pD5+gwXA8BC4AoXQ7u
         u+u9EyObG5DKEBoE6wBhD3tJCM2bLBVQGb3Vavr5E1qcieEQR0KLLfwIBQtfUaU8R6
         VZU2hS6Rjf3rloxA+NRP1cqvc/4XVylgyp4YWQamDWjZhCbbJpmPuXRn4xoMxJ9Le9
         2ODbyd5xFitKLygz61/1Pji3zVQaSGd65yhp0HJhCqic7CUEaM4C1yQUcaCZxHN2Du
         HzB3O34vAbQwQ==
Date:   Thu, 21 Oct 2021 13:39:31 +1100
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
Message-ID: <20211021133931.1a0e096b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/c2ZN7YoM3op9KtXwdjXKaVS";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/c2ZN7YoM3op9KtXwdjXKaVS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  arch/x86/kvm/x86.c

between commit:

  126fe0401883 ("x86/fpu: Cleanup xstate xcomp_bv initialization")

from the tip tree and commits:

  5ebbc470d7f3 ("KVM: x86: Remove defunct setting of CR0.ET for guests duri=
ng vCPU create")
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
index 04350680b649,3ea4f6ef2474..000000000000
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@@ -10615,10 -10687,10 +10590,9 @@@ int kvm_arch_vcpu_create(struct kvm_vcp
  		pr_err("kvm: failed to allocate vcpu's fpu\n");
  		goto free_user_fpu;
  	}
 -	fpstate_init(&vcpu->arch.guest_fpu->state);
 -	if (boot_cpu_has(X86_FEATURE_XSAVES))
 -		vcpu->arch.guest_fpu->state.xsave.header.xcomp_bv =3D
 -			host_xcr0 | XSTATE_COMPACTION_ENABLED;
 +
 +	fpu_init_fpstate_user(vcpu->arch.user_fpu);
 +	fpu_init_fpstate_user(vcpu->arch.guest_fpu);
- 	fx_init(vcpu);
 =20
  	vcpu->arch.maxphyaddr =3D cpuid_query_maxphyaddr(vcpu);
  	vcpu->arch.reserved_gpa_bits =3D kvm_vcpu_reserved_gpa_bits_raw(vcpu);

--Sig_/c2ZN7YoM3op9KtXwdjXKaVS
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmFw0uQACgkQAVBC80lX
0GyBgwf+Pk2g4riGFW+HoU4haeM9uGsd7l5rHyG+ms6+/U0s0XCtyMNHeGYKX8x4
6m7XJe7iDQaK0pawBEwxubEfEpbpCgIdu/sUArKVde+xiP8YxGfOr8U7U7sdkpF0
l/d4E/KCVY35NdA4XmfZCqZ+/gHTUSCgf81zOI7WUYvsdxpgsN4j6jk2ZY5Ifa0w
sN+iNi9afboUml3T1V3d5SHlgE1KBkaXu4lpsRX6nwa4FqEJKRyCqVsafQQL6qpp
X4Pox2t4Gkj51GmQcJzWGP/H4QP/DEUIYHrXknjwe4eo1m2PBmVeYbqL+1CV/d1c
b7MlYNhLH1LYm1Tka/gD+ZHnJGB43A==
=keu7
-----END PGP SIGNATURE-----

--Sig_/c2ZN7YoM3op9KtXwdjXKaVS--
