Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0ACB36798E
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 07:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234775AbhDVFyl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 01:54:41 -0400
Received: from ozlabs.org ([203.11.71.1]:49913 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234806AbhDVFyh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 01:54:37 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FQmnc44mMz9sTD;
        Thu, 22 Apr 2021 15:53:56 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1619070837;
        bh=BGZPYQkkrhZBKQnH/8AnrujpEbYer6hDxMUZS72H6e4=;
        h=Date:From:To:Cc:Subject:From;
        b=f8Sdg2jpgOZm3ETvhaBqhzh2fGNRPvOH7HcJ3kGq4wesKkELDZfgncJMVkZgLt+eD
         vS0ipQpTq9oSNkn3RMTcafzsQcnniCKxHwdtIQtEj+/4RFPLLCgJczSW7p2fDBsFUX
         zMiAhsPM8BG9G6NZTpW/CmfvxtUQVlaYHJHakw73VlEP1PMBc5C5QYPtLAoxHpft5T
         yYlGniklQBz66onN7adQBYUATthJgSSF3ZK6pZb5FQdkrtx8jvGEne7lf5omuF3rEZ
         kdD9hno/3KeaB1M9/Zosbijzwyn7rFr7AeVjnVkqUfFZgPKeV/ProH9Ddy9mwQE00m
         ljcErt3QFNm8g==
Date:   Thu, 22 Apr 2021 15:53:55 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Tejun Heo <tj@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        KVM <kvm@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vipin Sharma <vipinsh@google.com>
Subject: linux-next: manual merge of the cgroup tree with the kvm tree
Message-ID: <20210422155355.471c7751@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ps.N23AYUV.7aL720N9crLb";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/ps.N23AYUV.7aL720N9crLb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the cgroup tree got conflicts in:

  arch/x86/kvm/svm/sev.c

between commit:

  9fa1521daafb ("KVM: SVM: Do not set sev->es_active until KVM_SEV_ES_INIT =
completes")

from the kvm tree and commit:

  7aef27f0b2a8 ("svm/sev: Register SEV and SEV-ES ASIDs to the misc control=
ler")

from the cgroup tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc arch/x86/kvm/svm/sev.c
index 63923fa0b172,214eefb20414..000000000000
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@@ -93,10 -103,21 +109,21 @@@ static bool __sev_recycle_asids(int min
  	return true;
  }
 =20
 -static int sev_asid_new(struct kvm_sev_info *sev)
 +static int sev_asid_new(bool es_active)
  {
- 	int pos, min_asid, max_asid;
+ 	int pos, min_asid, max_asid, ret;
  	bool retry =3D true;
+ 	enum misc_res_type type;
+=20
+ 	type =3D sev->es_active ? MISC_CG_RES_SEV_ES : MISC_CG_RES_SEV;
+ 	WARN_ON(sev->misc_cg);
+ 	sev->misc_cg =3D get_current_misc_cg();
+ 	ret =3D misc_cg_try_charge(type, sev->misc_cg, 1);
+ 	if (ret) {
+ 		put_misc_cg(sev->misc_cg);
+ 		sev->misc_cg =3D NULL;
+ 		return ret;
+ 	}
 =20
  	mutex_lock(&sev_bitmap_lock);
 =20
@@@ -182,17 -224,16 +221,17 @@@ static int sev_guest_init(struct kvm *k
  	if (unlikely(sev->active))
  		return ret;
 =20
 -	asid =3D sev_asid_new(sev);
 +	asid =3D sev_asid_new(es_active);
  	if (asid < 0)
  		return ret;
+ 	sev->asid =3D asid;
 =20
  	ret =3D sev_platform_init(&argp->error);
  	if (ret)
  		goto e_free;
 =20
  	sev->active =3D true;
 +	sev->es_active =3D es_active;
- 	sev->asid =3D asid;
  	INIT_LIST_HEAD(&sev->regions_list);
 =20
  	return 0;

--Sig_/ps.N23AYUV.7aL720N9crLb
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmCBD3MACgkQAVBC80lX
0GwCVQgAhfLvp18AoPRyOZvFXbln4d0aRLDgCePUCfP5536Ola/QEKtOi0oCnnyx
cQpqdNBh7L/zcaCrVvofNT+COH6mF/gGGXjguMy5BUylZRKCTujNO0s91SVt1x0T
2Ng7cAJo0EvMA+M2/HiR8aKr72+IFj7HSzt6el7kPss+zgnvcI9nClCCpPysZbXu
A6xqleyTzWMiiS8avVnLGYSsCvS7zxOuh82C6eh4eSZwg8oB61kUVQI1EP0TsJ+H
Wb9qznPIjBraQTVI6ao7ci6FbdBpBUiRhYzkevSea97Q5wEA49STzr2t6/c3jGEh
sgk9MPXoAxeRhaxG2Sy6JK/XYgciRw==
=BrK3
-----END PGP SIGNATURE-----

--Sig_/ps.N23AYUV.7aL720N9crLb--
