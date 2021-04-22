Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 900263678BB
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 06:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhDVEbi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 00:31:38 -0400
Received: from ozlabs.org ([203.11.71.1]:55037 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229561AbhDVEbh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 00:31:37 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FQkxs3vqCz9sWK;
        Thu, 22 Apr 2021 14:30:57 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1619065861;
        bh=nrrjueQbJLgdff/uUfD6SBTPY8DEJYTf7uaFtxCIUK8=;
        h=Date:From:To:Cc:Subject:From;
        b=b8b+zTluZd0z2JjIQqelSzr8ILEsdpgJjpF09qTJnnzZhZNez7gYhy59bNjcc2mR2
         7tjj/amfOiKxjHvYYGfTD5uCBXYONp6ex1SzINLXcf0Hp2aLdHX/04o63MG+sDW5dk
         RTtiHfAxaaI3cXXKnQb6voyUtvpR9J6gNYplD/S0DpRsXKACHBylKH8+3lqTzgZ0O5
         EnYt0Vkd7Ffvyv3OcH6fJgmYDycMvR4WeB7u8QpYqtrneUrWYR73PsRsFQyO3TUQZT
         WWihwCjRWX+rJfjtn0oU0H5hGbqgxlgrbIfq+kHhLspz0tBodKSR7H6tYwlCFUlFN7
         ZKSGDxSPkzJpg==
Date:   Thu, 22 Apr 2021 14:30:56 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Nadav Amit <namit@vmware.com>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: linux-next: manual merge of the kvm tree with the tip tree
Message-ID: <20210422143056.62a3fee4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/l.H6810xM.cs/2vz.1uqr2v";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/l.H6810xM.cs/2vz.1uqr2v
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  arch/x86/kernel/kvm.c

between commit:

  4ce94eabac16 ("x86/mm/tlb: Flush remote and local TLBs concurrently")

from the tip tree and commit:

  2b519b5797d4 ("x86/kvm: Don't bother __pv_cpu_mask when !CONFIG_SMP")

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
index 5d32fa477a62,224a7a1ed6c3..000000000000
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@@ -574,6 -574,49 +574,54 @@@ static void kvm_smp_send_call_func_ipi(
  	}
  }
 =20
 -static void kvm_flush_tlb_others(const struct cpumask *cpumask,
++static void kvm_flush_tlb_multi(const struct cpumask *cpumask,
+ 			const struct flush_tlb_info *info)
+ {
+ 	u8 state;
+ 	int cpu;
+ 	struct kvm_steal_time *src;
+ 	struct cpumask *flushmask =3D this_cpu_cpumask_var_ptr(__pv_cpu_mask);
+=20
+ 	cpumask_copy(flushmask, cpumask);
+ 	/*
+ 	 * We have to call flush only on online vCPUs. And
+ 	 * queue flush_on_enter for pre-empted vCPUs
+ 	 */
+ 	for_each_cpu(cpu, flushmask) {
++		/*
++		 * The local vCPU is never preempted, so we do not explicitly
++		 * skip check for local vCPU - it will never be cleared from
++		 * flushmask.
++		 */
+ 		src =3D &per_cpu(steal_time, cpu);
+ 		state =3D READ_ONCE(src->preempted);
+ 		if ((state & KVM_VCPU_PREEMPTED)) {
+ 			if (try_cmpxchg(&src->preempted, &state,
+ 					state | KVM_VCPU_FLUSH_TLB))
+ 				__cpumask_clear_cpu(cpu, flushmask);
+ 		}
+ 	}
+=20
 -	native_flush_tlb_others(flushmask, info);
++	native_flush_tlb_multi(flushmask, info);
+ }
+=20
+ static __init int kvm_alloc_cpumask(void)
+ {
+ 	int cpu;
+=20
+ 	if (!kvm_para_available() || nopv)
+ 		return 0;
+=20
+ 	if (pv_tlb_flush_supported() || pv_ipi_supported())
+ 		for_each_possible_cpu(cpu) {
+ 			zalloc_cpumask_var_node(per_cpu_ptr(&__pv_cpu_mask, cpu),
+ 				GFP_KERNEL, cpu_to_node(cpu));
+ 		}
+=20
+ 	return 0;
+ }
+ arch_initcall(kvm_alloc_cpumask);
+=20
  static void __init kvm_smp_prepare_boot_cpu(void)
  {
  	/*
@@@ -655,15 -668,9 +673,9 @@@ static void __init kvm_guest_init(void
 =20
  	if (kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
  		has_steal_clock =3D 1;
 -		pv_ops.time.steal_clock =3D kvm_steal_clock;
 +		static_call_update(pv_steal_clock, kvm_steal_clock);
  	}
 =20
- 	if (pv_tlb_flush_supported()) {
- 		pv_ops.mmu.flush_tlb_multi =3D kvm_flush_tlb_multi;
- 		pv_ops.mmu.tlb_remove_table =3D tlb_remove_table;
- 		pr_info("KVM setup pv remote TLB flush\n");
- 	}
-=20
  	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
  		apic_set_eoi_write(kvm_guest_apic_eoi_write);
 =20
@@@ -673,6 -680,12 +685,12 @@@
  	}
 =20
  #ifdef CONFIG_SMP
+ 	if (pv_tlb_flush_supported()) {
 -		pv_ops.mmu.flush_tlb_others =3D kvm_flush_tlb_others;
++		pv_ops.mmu.flush_tlb_multi =3D kvm_flush_tlb_multi;
+ 		pv_ops.mmu.tlb_remove_table =3D tlb_remove_table;
+ 		pr_info("KVM setup pv remote TLB flush\n");
+ 	}
+=20
  	smp_ops.smp_prepare_boot_cpu =3D kvm_smp_prepare_boot_cpu;
  	if (pv_sched_yield_supported()) {
  		smp_ops.send_call_func_ipi =3D kvm_smp_send_call_func_ipi;

--Sig_/l.H6810xM.cs/2vz.1uqr2v
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmCA/AAACgkQAVBC80lX
0GyQ+wf+JorJjJ2Ke76ONkNhG86QzIx0GCJCRE6scdS324PKy7aGC8yWEB/VbWJd
+A3va4GWh1xqKO/ciCFrwJvcQ8FZbWfgSoPo1NfY8PM3jfd2dT9r6CEc07tl/TYI
pHOWaPlhPCUWy35h+uJZWVKOM16sfXFnktMyECmm/0Q4Ujn0VHB4h48d6XEC2G+7
Aa6YphurN5eGHaZ7HagM8iIDqookj1fCn0nyXJZMU63G3nN5Am67lsbkOFRNa8/x
wrFAZZssYO49CEJdoW23llMRLa0fCDw6+ouo9fEVrJv2a+qELvicfzj+dj3EktRJ
HXw5IxziSnaGBHSfMOAfGvI8R2WaOQ==
=s9HK
-----END PGP SIGNATURE-----

--Sig_/l.H6810xM.cs/2vz.1uqr2v--
