Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 478932319B6
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 08:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgG2GrQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 02:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbgG2GrQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jul 2020 02:47:16 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF447C061794;
        Tue, 28 Jul 2020 23:47:15 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BGkcK12Y3z9sRW;
        Wed, 29 Jul 2020 16:47:13 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1596005233;
        bh=ijyyUr82wI4HGbRSdFt2yLXZvyup+U2Kte8u90b/Go0=;
        h=Date:From:To:Cc:Subject:From;
        b=YjGyXU2UayxF+EpN+uQL/BM2Hyx/tT2nZSgTgjC1xzEkY6KSF9Yc22ixCNRNu0hjA
         BEAtGCl67giZnwKliNaKWPUhofKH92pD+8XXgyBufPMltFc4xqzmjPxsCbOZVNAkL+
         AwnXvyiM0DBLpTorLCJS7hc2bg7QeJz0oM4v0ennWaW5HD+FLD5Vz5TDO5QN/RsUat
         0QtxeEmGROekvXVZb8CD9BdkNSk2bP0yW61QZa3NdTqjmqGGqcGSriJgVxHEYIdCKR
         UJQuSy4u9FargUgsSz2HwgSLAw0KzDpw0mPGkEujn09EFdB+g6MsogXClPkpFssf9K
         sLZy6z913zr8g==
Date:   Wed, 29 Jul 2020 16:47:12 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: linux-next: manual merge of the kvm tree with the tip tree
Message-ID: <20200729164712.4f429876@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/XHfzbWnBxBMDLwmII4hFvje";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/XHfzbWnBxBMDLwmII4hFvje
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  arch/x86/kernel/kvm.c

between commits:

  b037b09b9058 ("x86/entry: Rename idtentry_enter/exit_cond_rcu() to idtent=
ry_enter/exit()")
  a27a0a55495c ("x86/entry: Cleanup idtentry_enter/exit")

from the tip tree and commits:

  b1d405751cd5 ("KVM: x86: Switch KVM guest to using interrupts for page re=
ady APF delivery")
  26d05b368a5c ("Merge branch 'kvm-async-pf-int' into HEAD")

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

diff --cc arch/x86/kernel/kvm.c
index 233c77d056c9,d9995931ea18..000000000000
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@@ -232,18 -235,13 +235,13 @@@ EXPORT_SYMBOL_GPL(kvm_read_and_reset_ap
 =20
  noinstr bool __kvm_handle_async_pf(struct pt_regs *regs, u32 token)
  {
- 	u32 reason =3D kvm_read_and_reset_apf_flags();
+ 	u32 flags =3D kvm_read_and_reset_apf_flags();
 -	bool rcu_exit;
 +	irqentry_state_t state;
 =20
- 	switch (reason) {
- 	case KVM_PV_REASON_PAGE_NOT_PRESENT:
- 	case KVM_PV_REASON_PAGE_READY:
- 		break;
- 	default:
+ 	if (!flags)
  		return false;
- 	}
 =20
 -	rcu_exit =3D idtentry_enter_cond_rcu(regs);
 +	state =3D irqentry_enter(regs);
  	instrumentation_begin();
 =20
  	/*

--Sig_/XHfzbWnBxBMDLwmII4hFvje
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8hG3AACgkQAVBC80lX
0GzXTAf/UAzhjiwuIBm+VzF5IuHJ0gdp9QmrlbRsW2OIKY3Py04zMX8umaPT08dF
tGEV/2hAwC8bBVm10fhfXeQonLsRiIrgsCHyTaRi31okGrqkFNc/ntKqKLK9qJf6
iZt/TdJOaGZRV+dusjOK8Z8Vo+ndUhPR2NFCVV2digKBbFfaM2En0lBpNEMtxDJM
ZsIhORnUv3JfQ0AdpkVoUb46mKb17jHkqWTewdFJGnfxR3F9ijhtsveEMp1PxGhv
39RzeCeSu6GTZtaWLmdA/mqdKXUWms44wCDc+RGbzFuLwV+sItWB74i10ovWzbZZ
5GZzPlqX0s1r9y2M5qoyHX9fdSomYw==
=Q1Ke
-----END PGP SIGNATURE-----

--Sig_/XHfzbWnBxBMDLwmII4hFvje--
