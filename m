Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDFCD54409A
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 02:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbiFIAd0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 20:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231710AbiFIAdZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 20:33:25 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB4D611A28;
        Wed,  8 Jun 2022 17:33:19 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4LJQ6z0bVRz4xXD;
        Thu,  9 Jun 2022 10:33:15 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1654734795;
        bh=yGik6OUtan7WWJyZq3UlVKhKyLFGDZiTq/DnPBlfoEM=;
        h=Date:From:To:Cc:Subject:From;
        b=ZasjAYD+Y4Oa11tuMoTPulV4bmIYtWrYftkXI3VOzy8fRuZfuBEBCfeYGxBxN3KrT
         HL70cKLyoq8Dl6SVNpmMpS+m0gyP2GL9URvIXpiaActaMhsil856EFVSazKn0EIIBn
         bJB7UC0Gc7oKX3f+ND9J0pX7SmP98HzYMJC+N7xTY+O1LkOsq7SIbKqbp0QO4wvcMZ
         y5FEQWuxyvgteTO7aK70iwRwUbBDVUqH1W5puioa0tptf5jwbzrQEO+ryjHFEW/q7w
         acX/Sm4CznZahwOMtyYDjxpwig61R8ZdjLDG1V2SE5jh8vZxC/vZ22tlBxV345HABg
         ri43BsAFsNcbQ==
Date:   Thu, 9 Jun 2022 10:33:13 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Tao Xu <tao3.xu@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: linux-next: manual merge of the kvm tree with Linus' tree
Message-ID: <20220609103313.0f05e4b5@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/KdtGegsGOUrQOwgR3MG0I2N";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/KdtGegsGOUrQOwgR3MG0I2N
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  arch/x86/kvm/x86.c

between commit:

  6cd88243c7e0 ("KVM: x86: do not report a vCPU as preempted outside instru=
ction boundaries")

from Linus' tree and commit:

  2f4073e08f4c ("KVM: VMX: Enable Notify VM exit")

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
index 2ec6a110ec6c,79efdc19b4c8..000000000000
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@@ -296,9 -284,8 +284,10 @@@ const struct _kvm_stats_desc kvm_vcpu_s
  	STATS_DESC_COUNTER(VCPU, nested_run),
  	STATS_DESC_COUNTER(VCPU, directed_yield_attempted),
  	STATS_DESC_COUNTER(VCPU, directed_yield_successful),
 +	STATS_DESC_COUNTER(VCPU, preemption_reported),
 +	STATS_DESC_COUNTER(VCPU, preemption_other),
- 	STATS_DESC_ICOUNTER(VCPU, guest_mode)
+ 	STATS_DESC_ICOUNTER(VCPU, guest_mode),
+ 	STATS_DESC_COUNTER(VCPU, notify_window_exits),
  };
 =20
  const struct kvm_stats_header kvm_vcpu_stats_header =3D {

--Sig_/KdtGegsGOUrQOwgR3MG0I2N
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmKhP8oACgkQAVBC80lX
0GyBYwf/Xl33nd4uOU7Nvnaj3aMg+lsBjcTKAHwL6MIcLM/8DnaJVdERZG0B6pGL
ZlrqDjc2V6HKq0bhaQXCPyfS/9yOU6a3BamJ4OF970TiLcck7GAUrfpd+eeF8G+o
1/hng47aDuBYajtV/K1mqh5u3n8xUJtc4HmbddGE9d0zZ40FBTx72AwcqYLT6l+K
rSXAXdY6f2NUi+QWLagFP0IFA61U3ODV3Fgf65GteeU88IoQ7QmxrBxfa1T3defj
41qIz4DzpNqtDCDSBGviFpVhnj80FnyVaX4IxsCka5Tm0o4vGc0wq8NpMtO9NKTB
Nkt52IFDkH3Ntwsc19YSUuhZJ0SeBQ==
=neXc
-----END PGP SIGNATURE-----

--Sig_/KdtGegsGOUrQOwgR3MG0I2N--
