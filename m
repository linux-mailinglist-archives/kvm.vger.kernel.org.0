Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E34A53678C9
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 06:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbhDVEkg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 00:40:36 -0400
Received: from ozlabs.org ([203.11.71.1]:53873 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229441AbhDVEkf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 00:40:35 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FQl8G53X5z9sRf;
        Thu, 22 Apr 2021 14:39:57 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1619066399;
        bh=gytcSQ0EK1A2/+Z/7YRsitFG89wvMlfVFxtZpQz7+Do=;
        h=Date:From:To:Cc:Subject:From;
        b=oi7ot3VlB0LJnu8c+jxixbdFRQPWaz1M5SDl2JQdE6yWZTeU4ngUXMbY1G1GXbzZ0
         SQtVxrOABbsDhhC0BsD0UoZG5jmkrx4zEevSHELyHHekwAuvrvF5h+KtTvvnHtufU/
         fH3ayb9bbe0MVRzvOgQFKbKzqbRxy4YDu7mq+hgFtptml9z7fmIiMMNcw0zduLRKqT
         RkDdUB3rwpSnspYdDR9+Bep4FzV8d6uU3ruK0crjkQRkJPwPx9Xzx1PkNsBL1azoTz
         eVO0NGPL4NjJltfxgUxjkSYq+YytjeSTA2KDbTxlEL4KtsobQDWp++k6wEKyU4szMd
         PRNBAQstqPvFg==
Date:   Thu, 22 Apr 2021 14:39:56 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Jianyong Wu <jianyong.wu@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the kvm-arm tree with the kvm tree
Message-ID: <20210422143956.5a43d00a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/=oiWDzj.pqXgWaGtuj6Jipk";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/=oiWDzj.pqXgWaGtuj6Jipk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm-arm tree got a conflict in:

  Documentation/virt/kvm/api.rst

between commit:

  24e7475f931a ("doc/virt/kvm: move KVM_CAP_PPC_MULTITCE in section 8")

from the kvm tree and commit:

  3bf725699bf6 ("KVM: arm64: Add support for the KVM PTP service")

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

diff --cc Documentation/virt/kvm/api.rst
index ee3446bf2a01,3f210953c135..000000000000
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@@ -6744,28 -6738,12 +6757,38 @@@ The KVM_XEN_HVM_CONFIG_RUNSTATE flag in
  features KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADDR/_CURRENT/_DATA/_ADJUST are
  supported by the KVM_XEN_VCPU_SET_ATTR/KVM_XEN_VCPU_GET_ATTR ioctls.
 =20
 -8.31 KVM_CAP_PTP_KVM
 +8.31 KVM_CAP_PPC_MULTITCE
 +-------------------------
 +
 +:Capability: KVM_CAP_PPC_MULTITCE
 +:Architectures: ppc
 +:Type: vm
 +
 +This capability means the kernel is capable of handling hypercalls
 +H_PUT_TCE_INDIRECT and H_STUFF_TCE without passing those into the user
 +space. This significantly accelerates DMA operations for PPC KVM guests.
 +User space should expect that its handlers for these hypercalls
 +are not going to be called if user space previously registered LIOBN
 +in KVM (via KVM_CREATE_SPAPR_TCE or similar calls).
 +
 +In order to enable H_PUT_TCE_INDIRECT and H_STUFF_TCE use in the guest,
 +user space might have to advertise it for the guest. For example,
 +IBM pSeries (sPAPR) guest starts using them if "hcall-multi-tce" is
 +present in the "ibm,hypertas-functions" device-tree property.
 +
 +The hypercalls mentioned above may or may not be processed successfully
 +in the kernel based fast path. If they can not be handled by the kernel,
 +they will get passed on to user space. So user space still has to have
 +an implementation for these despite the in kernel acceleration.
 +
 +This capability is always enabled.
++
++8.32 KVM_CAP_PTP_KVM
+ --------------------
+=20
+ :Architectures: arm64
+=20
+ This capability indicates that the KVM virtual PTP service is
+ supported in the host. A VMM can check whether the service is
+ available to the guest on migration.
+=20

--Sig_/=oiWDzj.pqXgWaGtuj6Jipk
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmCA/hwACgkQAVBC80lX
0GyIjwf/YPnoOnaIgaC8Xd9bRX01z2AHcpCdT47MVpd8fOgbfYIvtjLlYtkESyWl
Mq/NcUPyWj+mZgHSH9gcf1WU6sqWfHpkhdJsrOQ+6tHm+JPyk3izXmp679YrDVDp
WGGItboYI7XGBoNhZIwlJNol0BmtW5EhEdyqnNTAeRgVnxWiOCWB82mal7mv73/V
W+qsLXe/EE7auftJvCS6OxoYMTg/PBgSK0TuBJGZUsMoeADKeGxLuydxazs9mPhE
sm5lEQ1+G44Q1x2I2YkV6ieYO9KNKlk/3F2qu7nenSGXaYOZmk2NEPhNKDHyqHqu
geoBjrGN5R0XSvV4ph+mBzCUPe/gMQ==
=9tep
-----END PGP SIGNATURE-----

--Sig_/=oiWDzj.pqXgWaGtuj6Jipk--
