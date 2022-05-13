Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59870525A65
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 05:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376828AbiEMDxn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 23:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347440AbiEMDxl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 23:53:41 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B042D663C1;
        Thu, 12 May 2022 20:53:37 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KzvrZ4rXHz4xXH;
        Fri, 13 May 2022 13:53:34 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1652414016;
        bh=n54DZblynk0VLimaT4qwoyLi4hiRgpE+b2L0ESdGaHM=;
        h=Date:From:To:Cc:Subject:From;
        b=sLBt/6U8CGhSm31XnTRHMBl1iTWZ8GGU9isT69jNUTFCYKmwfOFTE8YFMvg04484Z
         T1XE2yj6zofXyCDpRXY0yAG7Fchmey6cZXc2+6++HEJpT94OQN+DbnuiPeZRZX2zLc
         u699hzn6+42NxpwPifsJmKi1YcP8PXLDg8e0FFsHZWrmZFUU4cLrGqC3/bxTHnSAsb
         cB3+NgwOfcMNfhPsFFkEk4XklQ1TBPq2905keOywO9iqAbDr0G3B9L/6g5daWy5Edx
         K8Ho/KbEQ/1InZRzzV+HLUW1DY41RyMVOQ0PBXgXyCXaN5rAOLVbs63NDeKR4OjpQy
         m1+lJHjKAkMcg==
Date:   Fri, 13 May 2022 13:53:33 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Like Xu <like.xu@linux.intel.com>, Like Xu <likexu@tencent.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the kvm tree with Linus' tree
Message-ID: <20220513135333.7424c1c8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/CPSWij8og/R7ZeDUpbSdcPj";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/CPSWij8og/R7ZeDUpbSdcPj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  arch/x86/kvm/pmu.h

between commit:

  75189d1de1b3 ("KVM: x86/pmu: Update AMD PMC sample period to fix guest NM=
I-watchdog")

from Linus' tree and commits:

  a10cabf6815c ("KVM: x86/pmu: Move pmc_speculative_in_use() to arch/x86/kv=
m/pmu.h")
  8eeac7e999e8 ("KVM: x86/pmu: Add kvm_pmu_cap to optimize perf_get_x86_pmu=
_capability")

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

diff --cc arch/x86/kvm/pmu.h
index 22992b049d38,dbf4c83519a4..000000000000
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@@ -138,15 -143,35 +143,44 @@@ static inline u64 get_sample_period(str
  	return sample_period;
  }
 =20
 +static inline void pmc_update_sample_period(struct kvm_pmc *pmc)
 +{
 +	if (!pmc->perf_event || pmc->is_paused)
 +		return;
 +
 +	perf_event_period(pmc->perf_event,
 +			  get_sample_period(pmc, pmc->counter));
 +}
 +
+ static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
+ {
+ 	struct kvm_pmu *pmu =3D pmc_to_pmu(pmc);
+=20
+ 	if (pmc_is_fixed(pmc))
+ 		return fixed_ctrl_field(pmu->fixed_ctr_ctrl,
+ 					pmc->idx - INTEL_PMC_IDX_FIXED) & 0x3;
+=20
+ 	return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
+ }
+=20
+ extern struct x86_pmu_capability kvm_pmu_cap;
+=20
+ static inline void kvm_init_pmu_capability(void)
+ {
+ 	perf_get_x86_pmu_capability(&kvm_pmu_cap);
+=20
+ 	/*
+ 	 * Only support guest architectural pmu on
+ 	 * a host with architectural pmu.
+ 	 */
+ 	if (!kvm_pmu_cap.version)
+ 		memset(&kvm_pmu_cap, 0, sizeof(kvm_pmu_cap));
+=20
+ 	kvm_pmu_cap.version =3D min(kvm_pmu_cap.version, 2);
+ 	kvm_pmu_cap.num_counters_fixed =3D min(kvm_pmu_cap.num_counters_fixed,
+ 					     KVM_PMC_MAX_FIXED);
+ }
+=20
  void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel);
  void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int fixed_idx);
  void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx);

--Sig_/CPSWij8og/R7ZeDUpbSdcPj
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEyBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmJ91j0ACgkQAVBC80lX
0Gzbegf4ofT6xvOHdoukMsxm8dYMjCzLyPKWbtK6K5hwBoa4/JgRWx5EynVkl6ze
J06LGRnBBDXzds/x3EOi1tDEIB08faMVGVHsF+0K0reROt3UgLXKtyRwS0Drt2iM
Br9e8bUqh14rdX5hRT8FhLdBxlYfUgAxyXfM1J9GhnNdGoLX1BIcbutBjbXq4+np
jAOMC/VasQlXT4VaHEueWUIGfdN6I4QqWcAggsrU0qQ+KS9m6NWAsjiI/Rux2iPB
3xZY4sJs9CXVoIQHqnSfhizcOnA29ZBATetm2CrxSFoxkqsc4e4ivlcjW6SMqjtG
jnwYAltIwBVGcRibq2BJ/dd4xG9k
=Z9xG
-----END PGP SIGNATURE-----

--Sig_/CPSWij8og/R7ZeDUpbSdcPj--
