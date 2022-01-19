Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2736F494302
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 23:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232704AbiASWZc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 17:25:32 -0500
Received: from gandalf.ozlabs.org ([150.107.74.76]:52633 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357489AbiASWZb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 17:25:31 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4JfKw91KTXz4y3q;
        Thu, 20 Jan 2022 09:25:28 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1642631129;
        bh=HUdoUmXAE4umbq1ha82W4mzfeV6PIiWF9Q2FlUbPvhg=;
        h=Date:From:To:Cc:Subject:From;
        b=kot4OaUkUGOhlUT+7MXUvBZXx3gI0a6zPGKst2UDvK83yrHlpkmGkmyYmCyHF5aom
         vXG3fycxnCL+7+Nn6ZHpWroq9gGR8RM0omi1bdi3cIeRrT5bL5ANgtgCOQwpAhKMrd
         ptfmBB9jZhRRgMcvECVqlE6+0TuhOlQvc7hdwocpPKxDxomP1OPOSb3Vj4f+wcY/D4
         PUzy6XVD277dp/t7HdyzmcTbKyf2P2Djis/77KqmpGzUysHXFvRmm4j7oDufqLt4GM
         6NioQUwYNH/nCYPActkdAUdQDWuOMLlXRR9ZPw4Vza6COHJ0wqINzJtU4zdvPPPnzG
         B9mQz/dQ4fPPQ==
Date:   Thu, 20 Jan 2022 09:25:27 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: linux-next: manual merge of the kvm-fixes tree with Linus' tree
Message-ID: <20220120092527.71e3a85f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/SwT/asWo.n/bgmzssX9Tue0";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/SwT/asWo.n/bgmzssX9Tue0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm-fixes tree got a conflict in:

  arch/x86/kvm/vmx/posted_intr.c

between commits:

  c95717218add ("KVM: VMX: Drop unnecessary PI logic to handle impossible c=
onditions")
  29802380b679 ("KVM: VMX: Drop pointless PI.NDST update when blocking")
  89ef0f21cf96 ("KVM: VMX: Save/restore IRQs (instead of CLI/STI) during PI=
 pre/post block")
  cfb0e1306a37 ("KVM: VMX: Read Posted Interrupt "control" exactly once per=
 loop iteration")
  baed82c8e489 ("KVM: VMX: Remove vCPU from PI wakeup list before updating =
PID.NV")
  45af1bb99b72 ("KVM: VMX: Clean up PI pre/post-block WARNs")

from Linus' tree and commit:

  5f02ef741a78 ("KVM: VMX: switch blocked_vcpu_on_cpu_lock to raw spinlock")

from the kvm-fixes tree.

I fixed it up (I think - see below) and can carry the fix as
necessary. This is now fixed as far as linux-next is concerned, but any
non trivial conflicts should be mentioned to your upstream maintainer
when your tree is submitted for merging.  You may also want to consider
cooperating with the maintainer of the conflicting tree to minimise any
particularly complex conflicts.

It may be worth while rebasing this fix on top of Linus' current tree.

--=20
Cheers,
Stephen Rothwell

diff --cc arch/x86/kvm/vmx/posted_intr.c
index 88c53c521094,21ea58d25771..000000000000
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@@ -11,23 -11,11 +11,23 @@@
  #include "vmx.h"
 =20
  /*
 - * We maintain a per-CPU linked-list of vCPU, so in wakeup_handler() we
 - * can find which vCPU should be waken up.
 + * Maintain a per-CPU list of vCPUs that need to be awakened by wakeup_ha=
ndler()
 + * when a WAKEUP_VECTOR interrupted is posted.  vCPUs are added to the li=
st when
 + * the vCPU is scheduled out and is blocking (e.g. in HLT) with IRQs enab=
led.
 + * The vCPUs posted interrupt descriptor is updated at the same time to s=
et its
 + * notification vector to WAKEUP_VECTOR, so that posted interrupt from de=
vices
 + * wake the target vCPUs.  vCPUs are removed from the list and the notifi=
cation
 + * vector is reset when the vCPU is scheduled in.
   */
  static DEFINE_PER_CPU(struct list_head, blocked_vcpu_on_cpu);
 +/*
-  * Protect the per-CPU list with a per-CPU spinlock to handle task migrat=
ion.
++ * Protect the per-CPU list with a per-CPU raw_spinlock to handle task mi=
gration.
 + * When a blocking vCPU is awakened _and_ migrated to a different pCPU, t=
he
 + * ->sched_in() path will need to take the vCPU off the list of the _prev=
ious_
 + * CPU.  IRQs must be disabled when taking this lock, otherwise deadlock =
will
 + * occur if a wakeup IRQ arrives and attempts to acquire the lock.
 + */
- static DEFINE_PER_CPU(spinlock_t, blocked_vcpu_on_cpu_lock);
+ static DEFINE_PER_CPU(raw_spinlock_t, blocked_vcpu_on_cpu_lock);
 =20
  static inline struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
  {
@@@ -129,25 -103,17 +129,25 @@@ static void __pi_post_block(struct kvm_
  	struct pi_desc old, new;
  	unsigned int dest;
 =20
 -	do {
 -		old.control =3D new.control =3D pi_desc->control;
 -		WARN(old.nv !=3D POSTED_INTR_WAKEUP_VECTOR,
 -		     "Wakeup handler not enabled while the VCPU is blocked\n");
 +	/*
 +	 * Remove the vCPU from the wakeup list of the _previous_ pCPU, which
 +	 * will not be the same as the current pCPU if the task was migrated.
 +	 */
- 	spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
++	raw_spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
 +	list_del(&vcpu->blocked_vcpu_list);
- 	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
++	raw_spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
 =20
 -		dest =3D cpu_physical_id(vcpu->cpu);
 +	dest =3D cpu_physical_id(vcpu->cpu);
 +	if (!x2apic_mode)
 +		dest =3D (dest << 8) & 0xFF00;
 =20
 -		if (x2apic_mode)
 -			new.ndst =3D dest;
 -		else
 -			new.ndst =3D (dest << 8) & 0xFF00;
 +	WARN(pi_desc->nv !=3D POSTED_INTR_WAKEUP_VECTOR,
 +	     "Wakeup handler not enabled while the vCPU was blocking");
 +
 +	do {
 +		old.control =3D new.control =3D READ_ONCE(pi_desc->control);
 +
 +		new.ndst =3D dest;
 =20
  		/* set 'NV' to 'notification vector' */
  		new.nv =3D POSTED_INTR_VECTOR;
@@@ -170,27 -143,45 +170,27 @@@
   */
  int pi_pre_block(struct kvm_vcpu *vcpu)
  {
 -	unsigned int dest;
  	struct pi_desc old, new;
  	struct pi_desc *pi_desc =3D vcpu_to_pi_desc(vcpu);
 +	unsigned long flags;
 =20
 -	if (!vmx_can_use_vtd_pi(vcpu->kvm))
 +	if (!vmx_can_use_vtd_pi(vcpu->kvm) ||
 +	    vmx_interrupt_blocked(vcpu))
  		return 0;
 =20
 -	WARN_ON(irqs_disabled());
 -	local_irq_disable();
 -	if (!WARN_ON_ONCE(vcpu->pre_pcpu !=3D -1)) {
 -		vcpu->pre_pcpu =3D vcpu->cpu;
 -		raw_spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
 -		list_add_tail(&vcpu->blocked_vcpu_list,
 -			      &per_cpu(blocked_vcpu_on_cpu,
 -				       vcpu->pre_pcpu));
 -		raw_spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
 -	}
 +	local_irq_save(flags);
 +
 +	vcpu->pre_pcpu =3D vcpu->cpu;
- 	spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->cpu));
++	raw_spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->cpu));
 +	list_add_tail(&vcpu->blocked_vcpu_list,
 +		      &per_cpu(blocked_vcpu_on_cpu, vcpu->cpu));
- 	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->cpu));
++	raw_spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->cpu));
 +
 +	WARN(pi_desc->sn =3D=3D 1,
 +	     "Posted Interrupt Suppress Notification set before blocking");
 =20
  	do {
 -		old.control =3D new.control =3D pi_desc->control;
 -
 -		WARN((pi_desc->sn =3D=3D 1),
 -		     "Warning: SN field of posted-interrupts "
 -		     "is set before blocking\n");
 -
 -		/*
 -		 * Since vCPU can be preempted during this process,
 -		 * vcpu->cpu could be different with pre_pcpu, we
 -		 * need to set pre_pcpu as the destination of wakeup
 -		 * notification event, then we can find the right vCPU
 -		 * to wakeup in wakeup handler if interrupts happen
 -		 * when the vCPU is in blocked state.
 -		 */
 -		dest =3D cpu_physical_id(vcpu->pre_pcpu);
 -
 -		if (x2apic_mode)
 -			new.ndst =3D dest;
 -		else
 -			new.ndst =3D (dest << 8) & 0xFF00;
 +		old.control =3D new.control =3D READ_ONCE(pi_desc->control);
 =20
  		/* set 'NV' to 'wakeup vector' */
  		new.nv =3D POSTED_INTR_WAKEUP_VECTOR;
@@@ -229,10 -220,10 +229,10 @@@ void pi_wakeup_handler(void
  			blocked_vcpu_list) {
  		struct pi_desc *pi_desc =3D vcpu_to_pi_desc(vcpu);
 =20
 -		if (pi_test_on(pi_desc) =3D=3D 1)
 +		if (pi_test_on(pi_desc))
  			kvm_vcpu_kick(vcpu);
  	}
- 	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, cpu));
+ 	raw_spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, cpu));
  }
 =20
  void __init pi_init_cpu(int cpu)

--Sig_/SwT/asWo.n/bgmzssX9Tue0
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmHoj9cACgkQAVBC80lX
0Gxd9wf8DAP2lOImp9lnQArh/E/fz55khWRz9nh70lEZNgr8fB5bkL377MEkPEBU
R096IX2DeDRPNiLOJGkyCOanzp6TbFKEcfQ1TPTtb4mFd9igcgLUqkTirwIA/wRP
WpOAa+wRE3sxXwEDKKBFzsab8NTaGT26ygl/3KnbECqgPlJu5JD63ZK29OT6+v/9
3fkorntB0p88kR0NnQWfkJrZ6xPwx+X1TIkZvtgbPrThGCFK/P5siNI6Zdd5F9vP
iV1z/cVfo+RTwHIJC1vG5zpVcex0TExdubIkSs7AWRpTTv53zNWI1cWAJ9b/knUk
g00pm3vVW858FPesIoJI1Eizb4KOXg==
=1Eg8
-----END PGP SIGNATURE-----

--Sig_/SwT/asWo.n/bgmzssX9Tue0--
