Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B53094FECFC
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 04:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbiDMCgh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 22:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiDMCgg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 22:36:36 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D89DC6;
        Tue, 12 Apr 2022 19:34:16 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KdRVv0DDjz4xLQ;
        Wed, 13 Apr 2022 12:34:14 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1649817255;
        bh=Gg/b6OBoVPLkyC8Zt70CWjXEHj+DMMNe3GomLkFFDrA=;
        h=Date:From:To:Cc:Subject:From;
        b=csIkXQc7BuexSkhqpvxKQBeIJJf5EP7cKPsfoKwdmWEcTbQYEmQsaS/ThabpHzNee
         S3HD7jmhf2fbybxoC2Z17w6Bc1ZL9OC3bMlXDn2KHnFhldzgfn2ey1k4o8otQfgO3O
         moqC+Gb9H/RV5epQTJzohx4pCoYt7QYiAVeqN6ZyiYmjSf30yqyZinGSWpk8o0wO7D
         fNYA81bHPJ2FQCxwA8kS0bC0lg+NMUJtRMduHb2riR4mPlL5Vq8YCM9el+EKcmgGI5
         AaPvn+2oiG9gWa36MwJMFN+gUnhJNCBpWiY8DXs0loHpD1ZEuWbd1IJgYx0wNb5Roi
         pndXp05NWa6/A==
Date:   Wed, 13 Apr 2022 12:34:14 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     David Woodhouse <dwmw@amazon.co.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: linux-next: manual merge of the kvm tree with the kvm-fixes tree
Message-ID: <20220413123414.01119890@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/jThhaPy3QoHXwP_vypFKGdn";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/jThhaPy3QoHXwP_vypFKGdn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  arch/x86/kvm/x86.c

between commit:

  42dcbe7d8bac ("KVM: x86: hyper-v: Avoid writing to TSC page without an ac=
tive vCPU")

from the kvm-fixes tree and commits:

  916d3608df82 ("KVM: x86: Use gfn_to_pfn_cache for pv_time")
  7caf9571563e ("KVM: x86/xen: Use gfn_to_pfn_cache for vcpu_info")
  69d413cfcf77 ("KVM: x86/xen: Use gfn_to_pfn_cache for vcpu_time_info")

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
index 547ba00ef64f,7a066cf92692..000000000000
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@@ -3106,14 -3101,15 +3101,14 @@@ static int kvm_guest_time_update(struc
 =20
  	vcpu->hv_clock.flags =3D pvclock_flags;
 =20
- 	if (vcpu->pv_time_enabled)
- 		kvm_setup_pvclock_page(v, &vcpu->pv_time, 0);
- 	if (vcpu->xen.vcpu_info_set)
- 		kvm_setup_pvclock_page(v, &vcpu->xen.vcpu_info_cache,
- 				       offsetof(struct compat_vcpu_info, time));
- 	if (vcpu->xen.vcpu_time_info_set)
- 		kvm_setup_pvclock_page(v, &vcpu->xen.vcpu_time_info_cache, 0);
+ 	if (vcpu->pv_time.active)
+ 		kvm_setup_guest_pvclock(v, &vcpu->pv_time, 0);
+ 	if (vcpu->xen.vcpu_info_cache.active)
+ 		kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_info_cache,
+ 					offsetof(struct compat_vcpu_info, time));
+ 	if (vcpu->xen.vcpu_time_info_cache.active)
+ 		kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_time_info_cache, 0);
 -	if (!v->vcpu_idx)
 -		kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
 +	kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
  	return 0;
  }
 =20

--Sig_/jThhaPy3QoHXwP_vypFKGdn
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmJWNqYACgkQAVBC80lX
0GwE7Qf+Nl9w7aAKNeI+dWE09Es9ZGiwiDSvWVLDaweE3mPzVFIXTgHW5znqTAxi
f98rAecJh+yJckl3mFILF/SBmU04GximtU2xkAEvJnAyN0RTqJXHxRQfjcTA2uo1
NonkIWMHzwrPNgyjP8FU9EKJRqZ2mLBT6imtJOdO7dDpfjoTUheh2xDZPzzw4R1Z
KFHfe2o55G39SmZdm2o/BcINaRNFpyKPjbG2EnGfqI9l8pVxFQioeacz0LVw3gCB
NXcPJNw9vO0MKPJV8+wN9Mv4d12lUv5MM76aeZVMx3qwZ9HRsSDZiVJeRFLHPf2z
Soym1YcwVXynueHo8gjSJu5V4Pdf5g==
=4B8S
-----END PGP SIGNATURE-----

--Sig_/jThhaPy3QoHXwP_vypFKGdn--
