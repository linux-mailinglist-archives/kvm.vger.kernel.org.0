Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DABE488E9C
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 03:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238174AbiAJCQs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Jan 2022 21:16:48 -0500
Received: from gandalf.ozlabs.org ([150.107.74.76]:40119 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234152AbiAJCQr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Jan 2022 21:16:47 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4JXHWb5gCRz4xtf;
        Mon, 10 Jan 2022 13:16:43 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1641781006;
        bh=6+f18ZytRVV6ZaJN651JtsXZrQaqFJ8HTPPIaAtVkGI=;
        h=Date:From:To:Cc:Subject:From;
        b=seJzmcEXPNZgKSMfYSq70ONkvm4sLqPw+0xeRCbbD/e286IrAz0FZmfGce0TR/cwy
         n7wo6wnOKjzMMlsQoDDsE25oIAFSZqYrVbARitylvV+bLL8XCqSJXc/mi9tI9/Jz4H
         z7uDkRY2kGeovu2NXVJNQ8kJzGz7lWMpk1rBTyIIABiIcJ7+a9g5sxJx6JtKvHulBu
         oUCNQRRd1UFBThvQ0jCjZIN1ZLotJTSLCB8Ctvs7ljeDPqJ9zd+vqGxiN4Lr2f0uwB
         Um36ul3M7VDtvWqNNvjOtrOXGWrsvZGo/Rwb4hTdlavQ9oPh5TTqcfNok1jAUTnYBC
         sLpKkueEnVn9w==
Date:   Mon, 10 Jan 2022 13:16:42 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Like Xu <like.xu@linux.intel.com>, Like Xu <likexu@tencent.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: linux-next: manual merge of the kvm tree with the tip tree
Message-ID: <20220110131642.75375b09@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/_VVmxq40xsv17Zf05GUT0+I";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/_VVmxq40xsv17Zf05GUT0+I
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  arch/x86/kvm/pmu.c

between commits:

  b9f5621c9547 ("perf/core: Rework guest callbacks to prepare for static_ca=
ll support")
  73cd107b9685 ("KVM: x86: Drop current_vcpu for kvm_running_vcpu + kvm_arc=
h_vcpu variable")

from the tip tree and commit:

  40ccb96d5483 ("KVM: x86/pmu: Add pmc->intr to refactor kvm_perf_overflow{=
_intr}()")

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

diff --cc arch/x86/kvm/pmu.c
index 0c2133eb4cf6,8abdadb7e22a..000000000000
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@@ -55,43 -55,41 +55,41 @@@ static void kvm_pmi_trigger_fn(struct i
  	kvm_pmu_deliver_pmi(vcpu);
  }
 =20
- static void kvm_perf_overflow(struct perf_event *perf_event,
- 			      struct perf_sample_data *data,
- 			      struct pt_regs *regs)
+ static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
  {
- 	struct kvm_pmc *pmc =3D perf_event->overflow_handler_context;
  	struct kvm_pmu *pmu =3D pmc_to_pmu(pmc);
 =20
- 	if (!test_and_set_bit(pmc->idx, pmu->reprogram_pmi)) {
- 		__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
- 		kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
- 	}
+ 	/* Ignore counters that have been reprogrammed already. */
+ 	if (test_and_set_bit(pmc->idx, pmu->reprogram_pmi))
+ 		return;
+=20
+ 	__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
+ 	kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
+=20
+ 	if (!pmc->intr)
+ 		return;
+=20
+ 	/*
+ 	 * Inject PMI. If vcpu was in a guest mode during NMI PMI
+ 	 * can be ejected on a guest mode re-entry. Otherwise we can't
+ 	 * be sure that vcpu wasn't executing hlt instruction at the
+ 	 * time of vmexit and is not going to re-enter guest mode until
+ 	 * woken up. So we should wake it, but this is impossible from
+ 	 * NMI context. Do it from irq work instead.
+ 	 */
 -	if (in_pmi && !kvm_is_in_guest())
++	if (in_pmi && !kvm_handling_nmi_from_guest(pmc->vcpu))
+ 		irq_work_queue(&pmc_to_pmu(pmc)->irq_work);
+ 	else
+ 		kvm_make_request(KVM_REQ_PMI, pmc->vcpu);
  }
 =20
- static void kvm_perf_overflow_intr(struct perf_event *perf_event,
- 				   struct perf_sample_data *data,
- 				   struct pt_regs *regs)
+ static void kvm_perf_overflow(struct perf_event *perf_event,
+ 			      struct perf_sample_data *data,
+ 			      struct pt_regs *regs)
  {
  	struct kvm_pmc *pmc =3D perf_event->overflow_handler_context;
- 	struct kvm_pmu *pmu =3D pmc_to_pmu(pmc);
-=20
- 	if (!test_and_set_bit(pmc->idx, pmu->reprogram_pmi)) {
- 		__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
- 		kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
 =20
- 		/*
- 		 * Inject PMI. If vcpu was in a guest mode during NMI PMI
- 		 * can be ejected on a guest mode re-entry. Otherwise we can't
- 		 * be sure that vcpu wasn't executing hlt instruction at the
- 		 * time of vmexit and is not going to re-enter guest mode until
- 		 * woken up. So we should wake it, but this is impossible from
- 		 * NMI context. Do it from irq work instead.
- 		 */
- 		if (!kvm_handling_nmi_from_guest(pmc->vcpu))
- 			irq_work_queue(&pmc_to_pmu(pmc)->irq_work);
- 		else
- 			kvm_make_request(KVM_REQ_PMI, pmc->vcpu);
- 	}
+ 	__kvm_perf_overflow(pmc, true);
  }
 =20
  static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,

--Sig_/_VVmxq40xsv17Zf05GUT0+I
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmHblwoACgkQAVBC80lX
0GxGqAf/S5/gwpIWoyOwbSmC0GOiMlOh/aJrlngCftQFNBVJVjjNWqMG4qCTKcFB
c5dUhqFc9QQUc/95bW7Z2V0zvgElnTBQp/yEVepVR9Jna2GqK1tMK+/AG8qJfNa3
ht1Ply8p/UDEStcN3vXIFLJSKPDlslrFC59oeoQ0yoZjQpAIrxinydZEFu4iFGja
fM+67wkDnTDWKG/tLRbn5YAdjplA91mgOI0JOxTSxuphLzUOBU65BkM+IBGxYm/R
XlhKSBlNRBJ1x+Wh3qehl3MTfYNS3kKXyxPXistYop8qvBbxbFa59CMP0jn5bBzU
SjY2KDrLFhTgebw4zyE8VuJjA9YXiQ==
=Hkz0
-----END PGP SIGNATURE-----

--Sig_/_VVmxq40xsv17Zf05GUT0+I--
