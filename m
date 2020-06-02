Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13CCF1EB4BC
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 06:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgFBEyC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jun 2020 00:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgFBEyC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jun 2020 00:54:02 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2E01C061A0E;
        Mon,  1 Jun 2020 21:54:01 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49bfnz4bsxz9sSf;
        Tue,  2 Jun 2020 14:53:59 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1591073640;
        bh=rDyuOagNKw3935ar6u61XTbrq3VfmYxSPPFZvkTS/a4=;
        h=Date:From:To:Cc:Subject:From;
        b=REQ1AbSt8qb5RDz/3aD4wUoufWsmXCOg7kUvF6OzjOBK3U9XDYbI+aj1Vf+hduvZ7
         4VqC6R/nVcaoE32PxKpllqbrgVySqHjli1eA78utQN8r3/fptosamcymYGZfZC61N5
         /VrVWSxzArGm5fLr8CU21RiwwyYSBLf4EFrMsq7z+AvfV3j77oy88slU6OFDidD0EC
         r5aR82dVzi40drsLlzWt3hq2JESSFYzr7a2FA5qpdd4CvmosV7B8mrE9OhWQpnTgOL
         IAnFTQ0DeJD8S9if4nHL3gmoJlQwE7JRcPEbb6w0G9v3BAhbVt541MYKEom5oRdubF
         jR6Dy0cQZghdA==
Date:   Tue, 2 Jun 2020 14:53:58 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: linux-next: manual merge of the kvm tree with the tip tree
Message-ID: <20200602145358.0a70f077@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/_Pdduu78QZE.yAxEGtjndqF";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/_Pdduu78QZE.yAxEGtjndqF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  arch/x86/kernel/kvm.c

between commit:

  a707ae1a9bbb ("x86/entry: Switch page fault exception to IDTENTRY_RAW")

from the tip tree and commit:

  68fd66f100d1 ("KVM: x86: extend struct kvm_vcpu_pv_apf_data with token in=
fo")

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
index 07dc47359c4f,d6f22a3a1f7d..000000000000
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@@ -217,23 -218,23 +217,23 @@@ again
  }
  EXPORT_SYMBOL_GPL(kvm_async_pf_task_wake);
 =20
- u32 noinstr kvm_read_and_reset_pf_reason(void)
 -u32 kvm_read_and_reset_apf_flags(void)
++u32 noinstr kvm_read_and_reset_apf_flags(void)
  {
- 	u32 reason =3D 0;
+ 	u32 flags =3D 0;
 =20
  	if (__this_cpu_read(apf_reason.enabled)) {
- 		reason =3D __this_cpu_read(apf_reason.reason);
- 		__this_cpu_write(apf_reason.reason, 0);
+ 		flags =3D __this_cpu_read(apf_reason.flags);
+ 		__this_cpu_write(apf_reason.flags, 0);
  	}
 =20
- 	return reason;
+ 	return flags;
  }
- EXPORT_SYMBOL_GPL(kvm_read_and_reset_pf_reason);
+ EXPORT_SYMBOL_GPL(kvm_read_and_reset_apf_flags);
 -NOKPROBE_SYMBOL(kvm_read_and_reset_apf_flags);
 =20
 -bool __kvm_handle_async_pf(struct pt_regs *regs, u32 token)
 +noinstr bool __kvm_handle_async_pf(struct pt_regs *regs, u32 token)
  {
- 	u32 reason =3D kvm_read_and_reset_pf_reason();
+ 	u32 reason =3D kvm_read_and_reset_apf_flags();
 +	bool rcu_exit;
 =20
  	switch (reason) {
  	case KVM_PV_REASON_PAGE_NOT_PRESENT:

--Sig_/_Pdduu78QZE.yAxEGtjndqF
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl7V22YACgkQAVBC80lX
0GzKngf/YIiFSUSZ7q/0wgcyOnZZxTpPf3pxnp3f/3JRJN/qc4uJnQ+6V3U0Nm11
LfmXlEvZ7xXr3P5FG2+SeiuqkveRXGfAtpxTyRqG2sfvpHMp+sGca3wUosKN+XTQ
go9OVGwxeB3fh12uj4ZOI+iB7ZvQp1+SZIlcUqBmtZY6bz5qBaktTu0dU3RcJ3TF
EYwWY3llMqX19zAVR8ZEOri7W5ZUMkZ2wEXjek0tVK9kqyaGlLOnEkbzJC+PJjao
jhJS7EDRgte3eTUEVg0ygPwj2DTdHreMV0r0UcZH81hXCRMSUv7V03CWy9tQyfqh
CxaBNq+YfJWeA0DeJ+s96r0MB7MBYg==
=3tsv
-----END PGP SIGNATURE-----

--Sig_/_Pdduu78QZE.yAxEGtjndqF--
