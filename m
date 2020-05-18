Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6961D7079
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 07:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgERFqt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 01:46:49 -0400
Received: from ozlabs.org ([203.11.71.1]:43497 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726040AbgERFqt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 01:46:49 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49QSgp2X8Dz9sPK;
        Mon, 18 May 2020 15:46:46 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1589780806;
        bh=camaI/CUsYpafRr4ZNug59q6ikP4R0PDtFMjRrbZOhk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pYMWqZhbeB49L6XUAq/AUp2sa1Jx6y/j134OlfBWprHeY0s5vcqpVF2TSQNjWeiiL
         YkBf/dVqe6cAoF/Mv+FTT4+zYz/l+ArNpgd+u9Lnfkcq8WFY6yURUykD9owB0jA5hw
         RiAofTofHpPIt4Mkt04t9WBgMC4a129C3W7pgTe1Zy2vPsGOT2PRYZ5HnOlnZR3Mb4
         OM0csLlTo/kIkMF2h1pnzzFbWnLtye8k1KIzF96Abn5HZ6TmOdalFdcm5btc64EwLi
         2MYbppyyUHkDvpWHUykHKHn3j8ZS5tixL392xi+eaEITNSbvYhPNJUypkVFUniE5ZP
         Rt3MC1YzKNLgw==
Date:   Mon, 18 May 2020 15:46:45 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Qian Cai <cai@lca.pw>, Wanpeng Li <wanpengli@tencent.com>
Subject: Re: linux-next: manual merge of the kvm tree with the rcu tree
Message-ID: <20200518154645.1b85a1c4@canb.auug.org.au>
In-Reply-To: <20200518154240.777ca18e@canb.auug.org.au>
References: <20200518154240.777ca18e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/YO/8f+_NysuHb44fRCtBNr2";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/YO/8f+_NysuHb44fRCtBNr2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 18 May 2020 15:42:40 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>=20
> Today's linux-next merge of the kvm tree got a conflict in:
>=20
>   arch/x86/kvm/svm/svm.c
>=20
> between commit:
>=20
>   9f24847d8fdb ("kvm/svm: Disable KCSAN for svm_vcpu_run()")
>=20
> from the rcu tree and commits:
>=20
>   a9ab13ff6e84 ("KVM: X86: Improve latency for single target IPI fastpath=
")
>   404d5d7bff0d ("KVM: X86: Introduce more exit_fastpath_completion enum v=
alues")
>=20
> from the kvm tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc arch/x86/kvm/svm/svm.c
index dca2bdbe34a7,4e9cd2a73ad0..000000000000
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@@ -3279,10 -3315,21 +3315,21 @@@ static void svm_cancel_injection(struc
        svm_complete_interrupts(svm);
  }

+ static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
+ {
+       if (!is_guest_mode(vcpu) &&
+           to_svm(vcpu)->vmcb->control.exit_code =3D=3D SVM_EXIT_MSR &&
+           to_svm(vcpu)->vmcb->control.exit_info_1)
+               return handle_fastpath_set_msr_irqoff(vcpu);
+
+       return EXIT_FASTPATH_NONE;
+ }
+
  void __svm_vcpu_run(unsigned long vmcb_pa, unsigned long *regs);

- static __no_kcsan void svm_vcpu_run(struct kvm_vcpu *vcpu)
 -static fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
++static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
  {
+       fastpath_t exit_fastpath;
        struct vcpu_svm *svm =3D to_svm(vcpu);

        svm->vmcb->save.rax =3D vcpu->arch.regs[VCPU_REGS_RAX];
s

--Sig_/YO/8f+_NysuHb44fRCtBNr2
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl7CIUUACgkQAVBC80lX
0GzpqwgAjl8NVo9R0myWOP1T9NnrAue46nQwyyzOO9AOz9JJWtAi4V7Bhhw9scBm
3JSCVuONL6W/k0XUYe+ipF7k2Cxbq4deYIgbfwBgXLYQ+y+Ba8LatABScEAdFKW5
i8ePrODqNASHyyx1Sy6GRQw8XRgRsMlujKg8zIqOtOWmo1n57U/sz26SBrS11yFH
D9hTVx5+KcqLK3pWW8oh1gafNp7PIxpbCyMNq6jKalLPMSrG/1918tEH+Lwjw2v1
81eg/Cb+OHIZ0L/C9UTQjMbvwxWI3SrlqOfIKbuvRpt8oPBTvCHSBBDwliQ4+oDd
NFv4fgAaOg36UCh0CU6n5Rs40YUImg==
=+K9t
-----END PGP SIGNATURE-----

--Sig_/YO/8f+_NysuHb44fRCtBNr2--
