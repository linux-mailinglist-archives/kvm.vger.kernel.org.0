Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C92A74ED045
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 01:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351822AbiC3XoQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 19:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234233AbiC3XoO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 19:44:14 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE50C5A094;
        Wed, 30 Mar 2022 16:42:27 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KTNJd5vsyz4x7X;
        Thu, 31 Mar 2022 10:42:25 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1648683746;
        bh=RivFaA1EdxuYaOBnxyzYnCLAZKxrTkZ/IYD7drusmdM=;
        h=Date:From:To:Cc:Subject:From;
        b=DiXQw0nxunAhLjOGin7ZVRFIjXWkhnhnFLmWWkj4Q2VdNY/9LncViUQ2xUD9EUlTM
         YS5fyRq3GYWe6frxqElJBPjZsxyc0oC4DXJvxL78LPu811JQmRPJf+nFwFMUQ0ssSO
         NBpahNK+3rkEyxcVtYobCLmMchXxvxopm756na7WDyXgY2Avj3h7rVhf+mFQVt5csH
         Uf3q7Mn4g7HOSHLpFHII/wDIJJUCEFOYOuOC/CLlT8dVAQKUuKwupcw7y+nIKR/nYO
         rnv/V/DcIL5zju+4dqyyLESqNK3beSJyQPHCwyclM2MNzXtRDXxRy/oZbBPEOoCxXZ
         8rhr5sxDtLOlg==
Date:   Thu, 31 Mar 2022 10:42:24 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Li RongQing <lirongqing@baidu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: linux-next: manual merge of the kvm tree with Linus' tree
Message-ID: <20220331104224.665e456b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/gdoklM4=rXX+/codRxPTZlu";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/gdoklM4=rXX+/codRxPTZlu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  arch/x86/kernel/kvm.c

between commit:

  c3b037917c6a ("x86/ibt,paravirt: Sprinkle ENDBR")

from Linus' tree and commit:

  8c5649e00e00 ("KVM: x86: Support the vCPU preemption check with nopvspin =
and realtime hint")

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
index 79e0b8d63ffa,21933095a10e..000000000000
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@@ -752,6 -752,39 +752,40 @@@ static void kvm_crash_shutdown(struct p
  }
  #endif
 =20
+ #ifdef CONFIG_X86_32
+ __visible bool __kvm_vcpu_is_preempted(long cpu)
+ {
+ 	struct kvm_steal_time *src =3D &per_cpu(steal_time, cpu);
+=20
+ 	return !!(src->preempted & KVM_VCPU_PREEMPTED);
+ }
+ PV_CALLEE_SAVE_REGS_THUNK(__kvm_vcpu_is_preempted);
+=20
+ #else
+=20
+ #include <asm/asm-offsets.h>
+=20
+ extern bool __raw_callee_save___kvm_vcpu_is_preempted(long);
+=20
+ /*
+  * Hand-optimize version for x86-64 to avoid 8 64-bit register saving and
+  * restoring to/from the stack.
+  */
+ asm(
+ ".pushsection .text;"
+ ".global __raw_callee_save___kvm_vcpu_is_preempted;"
+ ".type __raw_callee_save___kvm_vcpu_is_preempted, @function;"
+ "__raw_callee_save___kvm_vcpu_is_preempted:"
++ASM_ENDBR
+ "movq	__per_cpu_offset(,%rdi,8), %rax;"
+ "cmpb	$0, " __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax);"
+ "setne	%al;"
 -"ret;"
++ASM_RET
+ ".size __raw_callee_save___kvm_vcpu_is_preempted, .-__raw_callee_save___k=
vm_vcpu_is_preempted;"
+ ".popsection");
+=20
+ #endif
+=20
  static void __init kvm_guest_init(void)
  {
  	int i;

--Sig_/gdoklM4=rXX+/codRxPTZlu
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmJE6uEACgkQAVBC80lX
0GysIggAgZLlFR0JazxZVmzSWhTc+SxURS5IO4gvBe841gbTbZEXylVU6NLuStfi
f2Ih0ioOkanFqflY5Ecbu6kxPaDPdiEUjsRcaJOr5Ldp8Z84dtanQ47r5mewBzRV
cEFtn6wqU92BoE5QqnQGtM1aneLQ0tCDTbmqOkk+kYj3Q7D/1tVwr6gewm77YABF
Ds0JAFZXGiXwAnAvluSl65/KSlUQPKmOCQ1BbT/vaxkgRw4pHS6t0a+rUfqHbMc6
oVvi4sq0AUaXyWfMHbSAE4bkFGFbHS/G0omE06pSFsLB35F7wsYJAbuqe5Net23d
3xD2UxtAq6a2TzFSJOSfEqmo6WQk0Q==
=nR3e
-----END PGP SIGNATURE-----

--Sig_/gdoklM4=rXX+/codRxPTZlu--
