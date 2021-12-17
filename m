Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFF094783E9
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 05:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbhLQETG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 23:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbhLQETF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Dec 2021 23:19:05 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4556BC061574;
        Thu, 16 Dec 2021 20:19:05 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4JFbMq3bGSz4xd4;
        Fri, 17 Dec 2021 15:19:02 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1639714743;
        bh=yp0Ur0rx7YNSHB/zptC4hYpq036nZ3WtqihqjHB1tGs=;
        h=Date:From:To:Cc:Subject:From;
        b=ssC4Rr3KiYVZ7xbm9EV7NgpDdNvK8mLuC9HXi2LWzue7+FZRSiuzhOflmdg8/RIoP
         yEAoF2P/HlVOjl8fSbwh4tBpLKTvEweA+Js42kmHwWqXgEg3nnd0iZMwhsBnLPZDMO
         wdGBwuJr1+sfToaUTLhkDj1QcB96iWLAu2orZ8AnU3btGrIDkVpfqULoPgeFObnYnD
         VadSCEX5Eup0CJXD8cG3KhJy6itFP34leo05AY+e0A7aLeb+z/LbH7VXGjzF5ADonK
         CIzGB0ZJfZe+9IP0U6stMiSjgiPF65K4V7qlj+ppg/0VlCMgdLTtuoYcq6/tQwSjMO
         Zcj/Awh86mftQ==
Date:   Fri, 17 Dec 2021 15:19:02 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Quentin Perret <qperret@google.com>
Subject: linux-next: manual merge of the kvm-arm tree with the kvm tree
Message-ID: <20211217151902.2ae43d1f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/GUwPDrOjltl_sEP2d_WZhqs";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/GUwPDrOjltl_sEP2d_WZhqs
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm-arm tree got a conflict in:

  arch/arm64/kvm/arm.c

between commit:

  27592ae8dbe4 ("KVM: Move wiping of the kvm->vcpus array to common code")

from the kvm tree and commit:

  52b28657ebd7 ("KVM: arm64: pkvm: Unshare guest structs during teardown")

from the kvm-arm tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc arch/arm64/kvm/arm.c
index 7385bbdfdc42,6057f3c5aafe..000000000000
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@@ -179,7 -181,15 +179,9 @@@ void kvm_arch_destroy_vm(struct kvm *kv
 =20
  	kvm_vgic_destroy(kvm);
 =20
 -	for (i =3D 0; i < KVM_MAX_VCPUS; ++i) {
 -		if (kvm->vcpus[i]) {
 -			kvm_vcpu_destroy(kvm->vcpus[i]);
 -			kvm->vcpus[i] =3D NULL;
 -		}
 -	}
 -	atomic_set(&kvm->online_vcpus, 0);
 +	kvm_destroy_vcpus(kvm);
+=20
+ 	kvm_unshare_hyp(kvm, kvm + 1);
  }
 =20
  int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)

--Sig_/GUwPDrOjltl_sEP2d_WZhqs
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmG8D7YACgkQAVBC80lX
0GzSXgf/R6Xx9mnLIXjZlcoQKleXRwbNv28RwZWo1wBigNpv5ITzTYWKPfRk4VWm
Hwz6QvLyrq66Sq1v3/i/84ivbqqXlIMApRQJrhf8HzfSKSUFvVoCTHf85Kjr9uhF
sg0DE2t2A8iDuYigW9a+ABuGgggTNjCMN3rYsiVf6ITVzhXl+FEqIyvbzB3IVXhT
BG+PibeY3lWUULjQ+CrZVeYC/qz9V9+mei4MUcZaGekerVxZ8zX8Rp8AKX35Rc/B
KrHnctwF6XwXZF09zHMYRFnzyXlTARZKjMSyeVJyzTgbi09BIy/SgEyvlG45IDb+
bittel+ZmOShhMldlrRx/FTwGvfiEQ==
=1UaZ
-----END PGP SIGNATURE-----

--Sig_/GUwPDrOjltl_sEP2d_WZhqs--
