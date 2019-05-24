Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C23F29DF9
	for <lists+kvm@lfdr.de>; Fri, 24 May 2019 20:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729348AbfEXSWs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 24 May 2019 14:22:48 -0400
Received: from 2.mo69.mail-out.ovh.net ([178.33.251.80]:39423 "EHLO
        2.mo69.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbfEXSWr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 May 2019 14:22:47 -0400
Received: from player779.ha.ovh.net (unknown [10.108.42.192])
        by mo69.mail-out.ovh.net (Postfix) with ESMTP id 0B3F159126
        for <kvm@vger.kernel.org>; Fri, 24 May 2019 20:16:27 +0200 (CEST)
Received: from kaod.org (lns-bzn-46-82-253-208-248.adsl.proxad.net [82.253.208.248])
        (Authenticated sender: groug@kaod.org)
        by player779.ha.ovh.net (Postfix) with ESMTPSA id 4FD8560BA986;
        Fri, 24 May 2019 18:16:22 +0000 (UTC)
Date:   Fri, 24 May 2019 20:16:21 +0200
From:   Greg Kurz <groug@kaod.org>
To:     =?UTF-8?B?Q8OpZHJpYw==?= Le Goater <clg@kaod.org>
Cc:     Paul Mackerras <paulus@samba.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH] KVM: PPC: Book3S HV: XIVE: introduce a KVM device lock
Message-ID: <20190524201621.23eb7c44@bahia.lan>
In-Reply-To: <20190524132030.6349-1-clg@kaod.org>
References: <20190524132030.6349-1-clg@kaod.org>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Ovh-Tracer-Id: 3817645111006042507
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddrudduiedguddvhecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 24 May 2019 15:20:30 +0200
Cédric Le Goater <clg@kaod.org> wrote:

> The XICS-on-XIVE KVM device needs to allocate XIVE event queues when a
> priority is used by the OS. This is referred as EQ provisioning and it
> is done under the hood when :
> 
>   1. a CPU is hot-plugged in the VM
>   2. the "set-xive" is called at VM startup
>   3. sources are restored at VM restore
> 
> The kvm->lock mutex is used to protect the different XIVE structures
> being modified but in some contextes, kvm->lock is taken under the
> vcpu->mutex which is a forbidden sequence by KVM.
> 
> Introduce a new mutex 'lock' for the KVM devices for them to
> synchronize accesses to the XIVE device structures.
> 
> Signed-off-by: Cédric Le Goater <clg@kaod.org>
> ---
>  arch/powerpc/kvm/book3s_xive.h        |  1 +
>  arch/powerpc/kvm/book3s_xive.c        | 23 +++++++++++++----------
>  arch/powerpc/kvm/book3s_xive_native.c | 15 ++++++++-------
>  3 files changed, 22 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_xive.h b/arch/powerpc/kvm/book3s_xive.h
> index 426146332984..862c2c9650ae 100644
> --- a/arch/powerpc/kvm/book3s_xive.h
> +++ b/arch/powerpc/kvm/book3s_xive.h
> @@ -141,6 +141,7 @@ struct kvmppc_xive {
>  	struct kvmppc_xive_ops *ops;
>  	struct address_space   *mapping;
>  	struct mutex mapping_lock;
> +	struct mutex lock;
>  };
>  
>  #define KVMPPC_XIVE_Q_COUNT	8
> diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
> index f623451ec0a3..12c8a36dd980 100644
> --- a/arch/powerpc/kvm/book3s_xive.c
> +++ b/arch/powerpc/kvm/book3s_xive.c
> @@ -271,14 +271,14 @@ static int xive_provision_queue(struct kvm_vcpu *vcpu, u8 prio)
>  	return rc;
>  }
>  
> -/* Called with kvm_lock held */
> +/* Called with xive->lock held */
>  static int xive_check_provisioning(struct kvm *kvm, u8 prio)
>  {
>  	struct kvmppc_xive *xive = kvm->arch.xive;

Since the kvm_lock isn't protecting kvm->arch anymore, this looks weird.
Passing xive instead of kvm and using xive->kvm would make more sense IMHO.

Maybe fold the following into your patch ?

============================================================================
--- a/arch/powerpc/kvm/book3s_xive.c
+++ b/arch/powerpc/kvm/book3s_xive.c
@@ -272,9 +272,9 @@ static int xive_provision_queue(struct kvm_vcpu *vcpu, u8 prio)
 }
 
 /* Called with xive->lock held */
-static int xive_check_provisioning(struct kvm *kvm, u8 prio)
+static int xive_check_provisioning(struct kvmppc_xive *xive, u8 prio)
 {
-	struct kvmppc_xive *xive = kvm->arch.xive;
+	struct kvm *kvm = xive->kvm;
 	struct kvm_vcpu *vcpu;
 	int i, rc;
 
@@ -623,7 +623,7 @@ int kvmppc_xive_set_xive(struct kvm *kvm, u32 irq, u32 server,
 	/* First, check provisioning of queues */
 	if (priority != MASKED) {
 		mutex_lock(&xive->lock);
-		rc = xive_check_provisioning(xive->kvm,
+		rc = xive_check_provisioning(xive,
 			      xive_prio_from_guest(priority));
 		mutex_unlock(&xive->lock);
 	}
@@ -1673,7 +1673,7 @@ static int xive_set_source(struct kvmppc_xive *xive, long irq, u64 addr)
 	if (act_prio != MASKED) {
 		/* First, check provisioning of queues */
 		mutex_lock(&xive->lock);
-		rc = xive_check_provisioning(xive->kvm, act_prio);
+		rc = xive_check_provisioning(xive, act_prio);
 		mutex_unlock(&xive->lock);
 
 		/* Target interrupt */
============================================================================

The rest looks good.

>  	struct kvm_vcpu *vcpu;
>  	int i, rc;
>  
> -	lockdep_assert_held(&kvm->lock);
> +	lockdep_assert_held(&xive->lock);
>  
>  	/* Already provisioned ? */
>  	if (xive->qmap & (1 << prio))
> @@ -621,9 +621,12 @@ int kvmppc_xive_set_xive(struct kvm *kvm, u32 irq, u32 server,
>  		 irq, server, priority);
>  
>  	/* First, check provisioning of queues */
> -	if (priority != MASKED)
> +	if (priority != MASKED) {
> +		mutex_lock(&xive->lock);
>  		rc = xive_check_provisioning(xive->kvm,
>  			      xive_prio_from_guest(priority));
> +		mutex_unlock(&xive->lock);
> +	}
>  	if (rc) {
>  		pr_devel("  provisioning failure %d !\n", rc);
>  		return rc;
> @@ -1199,7 +1202,7 @@ int kvmppc_xive_connect_vcpu(struct kvm_device *dev,
>  		return -ENOMEM;
>  
>  	/* We need to synchronize with queue provisioning */
> -	mutex_lock(&vcpu->kvm->lock);
> +	mutex_lock(&xive->lock);
>  	vcpu->arch.xive_vcpu = xc;
>  	xc->xive = xive;
>  	xc->vcpu = vcpu;
> @@ -1283,7 +1286,7 @@ int kvmppc_xive_connect_vcpu(struct kvm_device *dev,
>  		xive_vm_esb_load(&xc->vp_ipi_data, XIVE_ESB_SET_PQ_00);
>  
>  bail:
> -	mutex_unlock(&vcpu->kvm->lock);
> +	mutex_unlock(&xive->lock);
>  	if (r) {
>  		kvmppc_xive_cleanup_vcpu(vcpu);
>  		return r;
> @@ -1527,13 +1530,12 @@ static int xive_get_source(struct kvmppc_xive *xive, long irq, u64 addr)
>  struct kvmppc_xive_src_block *kvmppc_xive_create_src_block(
>  	struct kvmppc_xive *xive, int irq)
>  {
> -	struct kvm *kvm = xive->kvm;
>  	struct kvmppc_xive_src_block *sb;
>  	int i, bid;
>  
>  	bid = irq >> KVMPPC_XICS_ICS_SHIFT;
>  
> -	mutex_lock(&kvm->lock);
> +	mutex_lock(&xive->lock);
>  
>  	/* block already exists - somebody else got here first */
>  	if (xive->src_blocks[bid])
> @@ -1560,7 +1562,7 @@ struct kvmppc_xive_src_block *kvmppc_xive_create_src_block(
>  		xive->max_sbid = bid;
>  
>  out:
> -	mutex_unlock(&kvm->lock);
> +	mutex_unlock(&xive->lock);
>  	return xive->src_blocks[bid];
>  }
>  
> @@ -1670,9 +1672,9 @@ static int xive_set_source(struct kvmppc_xive *xive, long irq, u64 addr)
>  	/* If we have a priority target the interrupt */
>  	if (act_prio != MASKED) {
>  		/* First, check provisioning of queues */
> -		mutex_lock(&xive->kvm->lock);
> +		mutex_lock(&xive->lock);
>  		rc = xive_check_provisioning(xive->kvm, act_prio);
> -		mutex_unlock(&xive->kvm->lock);
> +		mutex_unlock(&xive->lock);
>  
>  		/* Target interrupt */
>  		if (rc == 0)
> @@ -1963,6 +1965,7 @@ static int kvmppc_xive_create(struct kvm_device *dev, u32 type)
>  	dev->private = xive;
>  	xive->dev = dev;
>  	xive->kvm = kvm;
> +	mutex_init(&xive->lock);
>  
>  	/* Already there ? */
>  	if (kvm->arch.xive)
> diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
> index cdce9f94738e..684619517d67 100644
> --- a/arch/powerpc/kvm/book3s_xive_native.c
> +++ b/arch/powerpc/kvm/book3s_xive_native.c
> @@ -114,7 +114,7 @@ int kvmppc_xive_native_connect_vcpu(struct kvm_device *dev,
>  		return -EINVAL;
>  	}
>  
> -	mutex_lock(&vcpu->kvm->lock);
> +	mutex_lock(&xive->lock);
>  
>  	if (kvmppc_xive_find_server(vcpu->kvm, server_num)) {
>  		pr_devel("Duplicate !\n");
> @@ -159,7 +159,7 @@ int kvmppc_xive_native_connect_vcpu(struct kvm_device *dev,
>  
>  	/* TODO: reset all queues to a clean state ? */
>  bail:
> -	mutex_unlock(&vcpu->kvm->lock);
> +	mutex_unlock(&xive->lock);
>  	if (rc)
>  		kvmppc_xive_native_cleanup_vcpu(vcpu);
>  
> @@ -772,7 +772,7 @@ static int kvmppc_xive_reset(struct kvmppc_xive *xive)
>  
>  	pr_devel("%s\n", __func__);
>  
> -	mutex_lock(&kvm->lock);
> +	mutex_lock(&xive->lock);
>  
>  	kvm_for_each_vcpu(i, vcpu, kvm) {
>  		struct kvmppc_xive_vcpu *xc = vcpu->arch.xive_vcpu;
> @@ -810,7 +810,7 @@ static int kvmppc_xive_reset(struct kvmppc_xive *xive)
>  		}
>  	}
>  
> -	mutex_unlock(&kvm->lock);
> +	mutex_unlock(&xive->lock);
>  
>  	return 0;
>  }
> @@ -878,7 +878,7 @@ static int kvmppc_xive_native_eq_sync(struct kvmppc_xive *xive)
>  
>  	pr_devel("%s\n", __func__);
>  
> -	mutex_lock(&kvm->lock);
> +	mutex_lock(&xive->lock);
>  	for (i = 0; i <= xive->max_sbid; i++) {
>  		struct kvmppc_xive_src_block *sb = xive->src_blocks[i];
>  
> @@ -892,7 +892,7 @@ static int kvmppc_xive_native_eq_sync(struct kvmppc_xive *xive)
>  	kvm_for_each_vcpu(i, vcpu, kvm) {
>  		kvmppc_xive_native_vcpu_eq_sync(vcpu);
>  	}
> -	mutex_unlock(&kvm->lock);
> +	mutex_unlock(&xive->lock);
>  
>  	return 0;
>  }
> @@ -965,7 +965,7 @@ static int kvmppc_xive_native_has_attr(struct kvm_device *dev,
>  }
>  
>  /*
> - * Called when device fd is closed
> + * Called when device fd is closed.  kvm->lock is held.
>   */
>  static void kvmppc_xive_native_release(struct kvm_device *dev)
>  {
> @@ -1064,6 +1064,7 @@ static int kvmppc_xive_native_create(struct kvm_device *dev, u32 type)
>  	xive->kvm = kvm;
>  	kvm->arch.xive = xive;
>  	mutex_init(&xive->mapping_lock);
> +	mutex_init(&xive->lock);
>  
>  	/*
>  	 * Allocate a bunch of VPs. KVM_MAX_VCPUS is a large value for

