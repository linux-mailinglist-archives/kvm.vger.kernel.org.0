Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9113679F5
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 08:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234909AbhDVGbu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 02:31:50 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:33561 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229967AbhDVGbt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 02:31:49 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FQncd5sz7z9sWD;
        Thu, 22 Apr 2021 16:31:13 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1619073074;
        bh=il4ZXMNxnxf1r1lHcVDm4MNlaD/cBBNKZJyrLI7ywlA=;
        h=Date:From:To:Cc:Subject:From;
        b=BV8da9LS/ezueRAh5xIqL732gaQoWZoVPfSguGCz3vXlMNQf57/PSouIzZy6hQwtr
         kE7DRUg8pM/8pMpMzqutlvHqLB9Iv4mu70+nHZ17BX5vVdhFqfogedMyHasrqsdWH5
         tEZuSZzpyIQ3Q9nso2dYrEHmp/3EcQ50EaejJ/sZqQ0/6vKWwr7Ezwhu5uHs4JNu+e
         iLo/T/Q0Zl34Kdcu/TYytvdDf66+X12h13WCu6c7YEadSFLs6rNvPBoIntnSLbXbnJ
         Ss4ac+3vCc3604D9sUJRS20mZOt/mJKFFbf4/ctj8+hrgRjOGGqFnVtZTUuUXue3n0
         6Z1tvLoTRyViQ==
Date:   Thu, 22 Apr 2021 16:31:13 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Tejun Heo <tj@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        KVM <kvm@vger.kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the cgroup tree
Message-ID: <20210422163113.31fdbc9b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/xO_RFI86LovZrcagAMB7RKF";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/xO_RFI86LovZrcagAMB7RKF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the cgroup tree, today's linux-next build (x86_64
allmodconfig) failed like this:

arch/x86/kvm/svm/sev.c: In function 'sev_asid_new':
arch/x86/kvm/svm/sev.c:118:12: error: invalid type argument of '->' (have '=
int')
  118 |  type =3D sev->es_active ? MISC_CG_RES_SEV_ES : MISC_CG_RES_SEV;
      |            ^~
In file included from arch/x86/include/asm/bug.h:93,
                 from include/linux/bug.h:5,
                 from include/linux/mmdebug.h:5,
                 from include/linux/percpu.h:5,
                 from include/linux/context_tracking_state.h:5,
                 from include/linux/hardirq.h:5,
                 from include/linux/kvm_host.h:7,
                 from arch/x86/kvm/svm/sev.c:11:
arch/x86/kvm/svm/sev.c:119:13: error: invalid type argument of '->' (have '=
int')
  119 |  WARN_ON(sev->misc_cg);
      |             ^~
arch/x86/kvm/svm/sev.c:119:2: note: in expansion of macro 'WARN_ON'
  119 |  WARN_ON(sev->misc_cg);
      |  ^~~~~~~
arch/x86/kvm/svm/sev.c:120:5: error: invalid type argument of '->' (have 'i=
nt')
  120 |  sev->misc_cg =3D get_current_misc_cg();
      |     ^~
arch/x86/kvm/svm/sev.c:121:36: error: invalid type argument of '->' (have '=
int')
  121 |  ret =3D misc_cg_try_charge(type, sev->misc_cg, 1);
      |                                    ^~
arch/x86/kvm/svm/sev.c:123:18: error: invalid type argument of '->' (have '=
int')
  123 |   put_misc_cg(sev->misc_cg);
      |                  ^~
arch/x86/kvm/svm/sev.c:124:6: error: invalid type argument of '->' (have 'i=
nt')
  124 |   sev->misc_cg =3D NULL;
      |      ^~
arch/x86/kvm/svm/sev.c:154:28: error: invalid type argument of '->' (have '=
int')
  154 |  misc_cg_uncharge(type, sev->misc_cg, 1);
      |                            ^~
arch/x86/kvm/svm/sev.c:155:17: error: invalid type argument of '->' (have '=
int')
  155 |  put_misc_cg(sev->misc_cg);
      |                 ^~
arch/x86/kvm/svm/sev.c:156:5: error: invalid type argument of '->' (have 'i=
nt')
  156 |  sev->misc_cg =3D NULL;
      |     ^~

Caused by commit

  7aef27f0b2a8 ("svm/sev: Register SEV and SEV-ES ASIDs to the misc control=
ler")

interacting with commit

  9fa1521daafb ("KVM: SVM: Do not set sev->es_active until KVM_SEV_ES_INIT =
completes")

from the kvm tree.

I have applied the following for today, better suggestions welcome.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 22 Apr 2021 16:13:34 +1000
Subject: [PATCH] fixup for "KVM: SVM: Do not set sev->es_active until KVM_S=
EV_ES_INIT completes"

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/x86/kvm/svm/sev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 5ae091509bb0..3458710a9729 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -109,13 +109,13 @@ static bool __sev_recycle_asids(int min_asid, int max=
_asid)
 	return true;
 }
=20
-static int sev_asid_new(bool es_active)
+static int sev_asid_new(bool es_active, struct kvm_sev_info *sev)
 {
 	int pos, min_asid, max_asid, ret;
 	bool retry =3D true;
 	enum misc_res_type type;
=20
-	type =3D sev->es_active ? MISC_CG_RES_SEV_ES : MISC_CG_RES_SEV;
+	type =3D es_active ? MISC_CG_RES_SEV_ES : MISC_CG_RES_SEV;
 	WARN_ON(sev->misc_cg);
 	sev->misc_cg =3D get_current_misc_cg();
 	ret =3D misc_cg_try_charge(type, sev->misc_cg, 1);
@@ -221,7 +221,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_s=
ev_cmd *argp)
 	if (unlikely(sev->active))
 		return ret;
=20
-	asid =3D sev_asid_new(es_active);
+	asid =3D sev_asid_new(es_active, sev);
 	if (asid < 0)
 		return ret;
 	sev->asid =3D asid;
--=20
2.30.2

--=20
Cheers,
Stephen Rothwell

--Sig_/xO_RFI86LovZrcagAMB7RKF
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmCBGDEACgkQAVBC80lX
0GwdKwgAixSFq3p6EQ/ZzhUE9hlCzKvDEVflFKzpI+Ru4T0Y0uSfGFCg+Zy7HvIM
zEFBotnrx2JdkoRbTWrxMbimmHS/BuvXLsM78uw1IteNPTTGJs9SW6FocGk7FhrY
iykOMt4WDg5UzwRKVECxvFmwHXdOiyPvXxAv8bhLay506V4kjzqHwsPvtbZKpCny
Phzkgcgb9HRf/NuwZGgNCtlOhOkSZ/smGKRPPN36CKC2I9V0exWi45VwEQOmxVL5
eAxUJOT1hHzMsE0haCW1Nr23RuC2SdhIntRQsBPmewRIO+rESUz95x/ETjloEJto
aHtZOSsM4jCJw47fTNpPg1Lx6PbmOA==
=UkOU
-----END PGP SIGNATURE-----

--Sig_/xO_RFI86LovZrcagAMB7RKF--
