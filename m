Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83400558F7D
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 06:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbiFXEKE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 00:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiFXEKD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 00:10:03 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E7C68036;
        Thu, 23 Jun 2022 21:10:01 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4LTkD40yFcz4xD9;
        Fri, 24 Jun 2022 14:09:55 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1656043796;
        bh=NO6gwIyi/Vom9COuKpinlF5k4tXD56005MmLKL+dN0w=;
        h=Date:From:To:Cc:Subject:From;
        b=JVh5a8t9/x+kX7/oKEJgu218npZY2vlU8FcmMgsl2yzwKXTHW7uQTJK7PHrvOoDT0
         lOcyXInjOfINvyM/ilnPlglkgs6gEqOhnN0AY/ZmWz4C6KHTtnsPbrYIIegH7dXVee
         OhtdT7zzbNDvYqUFZyvSVR5Ermt9weHR/2aVQYzuaxEag1wz1sFczP9Zaz7XroHsY+
         MsGFWgbGR4oHQri6MQK5odLARKZeur6ifUq7Rf7rmwHCgZ/lR3jeaY1b1qC0enOuT8
         OEbDSNETTh4p22X639ih6YwwEE41/AGrig45sCoTGSam9aZWQCYNsSi7UdZtTcfEZo
         GQgXcCYI50yqg==
Date:   Fri, 24 Jun 2022 14:09:54 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Guo Zhengkui <guozhengkui@vivo.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Raghavendra Rao Ananta <rananta@google.com>
Subject: linux-next: manual merge of the kvm tree with the kvm-fixes tree
Message-ID: <20220624140954.2ff3de30@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/OgCw0P=XsdnZ810zrH_w7y+";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/OgCw0P=XsdnZ810zrH_w7y+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  tools/testing/selftests/kvm/lib/aarch64/ucall.c

between commit:

  9e2f6498efbb ("selftests: KVM: Handle compiler optimizations in ucall")

from the kvm-fixes tree and commit:

  5d9cd8b55cdc ("selftests: kvm: replace ternary operator with min()")

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

diff --cc tools/testing/selftests/kvm/lib/aarch64/ucall.c
index be1d9728c4ce,0b949ee06b5e..000000000000
--- a/tools/testing/selftests/kvm/lib/aarch64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
@@@ -77,20 -78,19 +76,20 @@@ void ucall(uint64_t cmd, int nargs, ...
  	va_list va;
  	int i;
 =20
 +	WRITE_ONCE(uc.cmd, cmd);
- 	nargs =3D nargs <=3D UCALL_MAX_ARGS ? nargs : UCALL_MAX_ARGS;
+ 	nargs =3D min(nargs, UCALL_MAX_ARGS);
 =20
  	va_start(va, nargs);
  	for (i =3D 0; i < nargs; ++i)
 -		uc.args[i] =3D va_arg(va, uint64_t);
 +		WRITE_ONCE(uc.args[i], va_arg(va, uint64_t));
  	va_end(va);
 =20
 -	*ucall_exit_mmio_addr =3D (vm_vaddr_t)&uc;
 +	WRITE_ONCE(*ucall_exit_mmio_addr, (vm_vaddr_t)&uc);
  }
 =20
- uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc)
+ uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
  {
- 	struct kvm_run *run =3D vcpu_state(vm, vcpu_id);
+ 	struct kvm_run *run =3D vcpu->run;
  	struct ucall ucall =3D {};
 =20
  	if (uc)

--Sig_/OgCw0P=XsdnZ810zrH_w7y+
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmK1ORIACgkQAVBC80lX
0GxKpgf/VbU3YPMdd9IlNDJWJHa94TFUZualU3MXl6Wz4hF5GRzoIKGOPLUxmGpE
R8WZf82XJy2d1ea4zjLghyF7JGVzbD2O62qTzg16eJasp4hu9bxV78Bfav5ed5zQ
pYjWUK5yHTH6Cjfxj8efKPa82RBuqp67KeHSlZ4LaAAmchFHA+Z/7F7MZJsT4zKf
tlFOZoCr8EeBustjWs4FowCE6DMvwfAWBEJIi+6XtkDKoI/P9ZgnS+/OxwxsxFTZ
IdqdwlFO/GLmfqS5P6axvU2qGvARPLDSGhv16UJECBHDoxHge28DGEgpXSRSQNaA
4zbEqJijkl3GXliDBGcypMjKkPG6Sw==
=elo4
-----END PGP SIGNATURE-----

--Sig_/OgCw0P=XsdnZ810zrH_w7y+--
