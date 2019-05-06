Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5DF150F5
	for <lists+kvm@lfdr.de>; Mon,  6 May 2019 18:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbfEFQLC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 May 2019 12:11:02 -0400
Received: from 14.mo1.mail-out.ovh.net ([178.32.97.215]:39451 "EHLO
        14.mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbfEFQLC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 May 2019 12:11:02 -0400
Received: from player793.ha.ovh.net (unknown [10.108.35.59])
        by mo1.mail-out.ovh.net (Postfix) with ESMTP id BD44916DF9B
        for <kvm@vger.kernel.org>; Mon,  6 May 2019 18:05:29 +0200 (CEST)
Received: from kaod.org (lfbn-1-10649-41.w90-89.abo.wanadoo.fr [90.89.235.41])
        (Authenticated sender: clg@kaod.org)
        by player793.ha.ovh.net (Postfix) with ESMTPSA id 8189F58B01D8;
        Mon,  6 May 2019 16:05:24 +0000 (UTC)
Subject: Re: [PATCH v2] KVM: PPC: Book3S HV: XIVE: Prevent races when
 releasing device
To:     Paul Mackerras <paulus@ozlabs.org>, kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
References: <20190418103942.2883-1-clg@kaod.org>
 <20190418103942.2883-18-clg@kaod.org> <20190426061014.GB12768@blackberry>
 <20190429012403.GA11154@blackberry>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <576628e1-724a-7691-598b-74072f06416d@kaod.org>
Date:   Mon, 6 May 2019 18:05:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190429012403.GA11154@blackberry>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 6577788732898642918
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddrjeejgdeliecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/29/19 3:24 AM, Paul Mackerras wrote:
> Now that we have the possibility of a XIVE or XICS-on-XIVE device being
> released while the VM is still running, we need to be careful about
> races and potential use-after-free bugs.  Although the kvmppc_xive
> struct is not freed, but kept around for re-use, the kvmppc_xive_vcpu
> structs are freed, and they are used extensively in both the XIVE native
> and XICS-on-XIVE code.
> 
> There are various ways in which XIVE code gets invoked:
> 
> - VCPU entry and exit, which do push and pull operations on the XIVE hardware
> - one_reg get and set functions (vcpu->mutex is held)
> - XICS hypercalls (but only inside guest execution, not from
>   kvmppc_pseries_do_hcall)
> - device creation calls (kvm->lock is held)
> - device callbacks - get/set attribute, mmap, pagefault, release/destroy
> - set_mapped/clr_mapped calls (kvm->lock is held)
> - connect_vcpu calls
> - debugfs file read callbacks
> 
> Inside a device release function, we know that userspace cannot have an
> open file descriptor referring to the device, nor can it have any mmapped
> regions from the device.  Therefore the device callbacks are excluded,
> as are the connect_vcpu calls (since they need a fd for the device).
> Further, since the caller holds the kvm->lock mutex, no other device
> creation calls or set/clr_mapped calls can be executing concurrently.
> 
> To exclude VCPU execution and XICS hypercalls, we temporarily set
> kvm->arch.mmu_ready to 0.  This forces any VCPU task that is trying to
> enter the guest to take the kvm->lock mutex, which is held by the caller
> of the release function.  Then, sending an IPI to all other CPUs forces
> any VCPU currently executing in the guest to exit.

For my understanding, this method is faster than looping on all vCPUs
and calling kvm_vcpu_kick() ? 

> 
> Finally, we take the vcpu->mutex for each VCPU around the process of
> cleaning up and freeing its XIVE data structures, in order to exclude
> any one_reg get/set calls.
> 
> To exclude the debugfs read callbacks, we just need to ensure that
> debugfs_remove is called before freeing any data structures.  Once it
> returns we know that no CPU can be executing the callbacks (for our
> kvmppc_xive instance).
> 
> Signed-off-by: Paul Mackerras <paulus@ozlabs.org>

LGTM, 

Reviewed-by: Cédric Le Goater <clg@kaod.org>

one minor comment below,

Thanks,

C.

> ---
> v2: move debugfs_remove call to eliminate race
> 
>  arch/powerpc/kvm/book3s_xive.c        | 51 ++++++++++++++++++++++++++++-------
>  arch/powerpc/kvm/book3s_xive_native.c | 43 ++++++++++++++++++++++++-----
>  2 files changed, 78 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
> index 922689b..4280cd8 100644
> --- a/arch/powerpc/kvm/book3s_xive.c
> +++ b/arch/powerpc/kvm/book3s_xive.c
> @@ -846,7 +846,8 @@ int kvmppc_xive_set_icp(struct kvm_vcpu *vcpu, u64 icpval)
>  
>  	/*
>  	 * We can't update the state of a "pushed" VCPU, but that
> -	 * shouldn't happen.
> +	 * shouldn't happen because the vcpu->mutex makes running a
> +	 * vcpu mutually exclusive with doing one_reg get/set on it.
>  	 */
>  	if (WARN_ON(vcpu->arch.xive_pushed))
>  		return -EIO;
> @@ -1835,7 +1836,7 @@ void kvmppc_xive_free_sources(struct kvmppc_xive_src_block *sb)
>  }
>  
>  /*
> - * Called when device fd is closed
> + * Called when device fd is closed.  kvm->lock is held.
>   */
>  static void kvmppc_xive_release(struct kvm_device *dev)
>  {
> @@ -1843,21 +1844,46 @@ static void kvmppc_xive_release(struct kvm_device *dev)
>  	struct kvm *kvm = xive->kvm;
>  	struct kvm_vcpu *vcpu;
>  	int i;
> +	int was_ready;
>  
>  	pr_devel("Releasing xive device\n");
>  
> +	debugfs_remove(xive->dentry);
> +
>  	/*
> -	 * When releasing the KVM device fd, the vCPUs can still be
> -	 * running and we should clean up the vCPU interrupt
> -	 * presenters first.
> +	 * Clearing mmu_ready temporarily while holding kvm->lock
> +	 * is a way of ensuring that no vcpus can enter the guest
> +	 * until we drop kvm->lock.  Doing kick_all_cpus_sync()
> +	 * ensures that any vcpu executing inside the guest has
> +	 * exited the guest.  Once kick_all_cpus_sync() has finished,
> +	 * we know that no vcpu can be executing the XIVE push or
> +	 * pull code, or executing a XICS hcall.
> +	 *
> +	 * Since this is the device release function, we know that
> +	 * userspace does not have any open fd referring to the
> +	 * device.  Therefore there can not be any of the device
> +	 * attribute set/get functions being executed concurrently,
> +	 * and similarly, the connect_vcpu and set/clr_mapped
> +	 * functions also cannot be being executed.
>  	 */
> -	kvm_for_each_vcpu(i, vcpu, kvm)
> -		kvmppc_xive_cleanup_vcpu(vcpu);
> +	was_ready = kvm->arch.mmu_ready;
> +	kvm->arch.mmu_ready = 0;
> +	kick_all_cpus_sync();
>  
> -	debugfs_remove(xive->dentry);
> +	/*
> +	 * We should clean up the vCPU interrupt presenters first.
> +	 */
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		/*
> +		 * Take vcpu->mutex to ensure that no one_reg get/set ioctl
> +		 * (i.e. kvmppc_xive_[gs]et_icp) can be done concurrently.
> +		 */
> +		mutex_lock(&vcpu->mutex);
> +		kvmppc_xive_cleanup_vcpu(vcpu);
> +		mutex_unlock(&vcpu->mutex);
> +	}
>  
> -	if (kvm)
> -		kvm->arch.xive = NULL;
> +	kvm->arch.xive = NULL;
>  
>  	/* Mask and free interrupts */
>  	for (i = 0; i <= xive->max_sbid; i++) {
> @@ -1870,6 +1896,8 @@ static void kvmppc_xive_release(struct kvm_device *dev)
>  	if (xive->vp_base != XIVE_INVALID_VP)
>  		xive_native_free_vp_block(xive->vp_base);
>  
> +	kvm->arch.mmu_ready = was_ready;
> +
>  	/*
>  	 * A reference of the kvmppc_xive pointer is now kept under
>  	 * the xive_devices struct of the machine for reuse. It is
> @@ -1906,6 +1934,9 @@ struct kvmppc_xive *kvmppc_xive_get_device(struct kvm *kvm, u32 type)
>  	return xive;
>  }
>  
> +/*
> + * Create a XICS device with XIVE backend.  kvm->lock is held.
> + */
>  static int kvmppc_xive_create(struct kvm_device *dev, u32 type)
>  {
>  	struct kvmppc_xive *xive;
> diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
> index 0497272a..5e14df1 100644
> --- a/arch/powerpc/kvm/book3s_xive_native.c
> +++ b/arch/powerpc/kvm/book3s_xive_native.c

May be also add the comment :

kvm->lock is held when kvmppc_xive_native_release() is called.


> @@ -973,21 +973,47 @@ static void kvmppc_xive_native_release(struct kvm_device *dev)
>  	struct kvm *kvm = xive->kvm;
>  	struct kvm_vcpu *vcpu;
>  	int i;
> +	int was_ready;
>  
>  	debugfs_remove(xive->dentry);
>  
>  	pr_devel("Releasing xive native device\n");
>  
>  	/*
> -	 * When releasing the KVM device fd, the vCPUs can still be
> -	 * running and we should clean up the vCPU interrupt
> -	 * presenters first.
> +	 * Clearing mmu_ready temporarily while holding kvm->lock
> +	 * is a way of ensuring that no vcpus can enter the guest
> +	 * until we drop kvm->lock.  Doing kick_all_cpus_sync()
> +	 * ensures that any vcpu executing inside the guest has
> +	 * exited the guest.  Once kick_all_cpus_sync() has finished,
> +	 * we know that no vcpu can be executing the XIVE push or
> +	 * pull code or accessing the XIVE MMIO regions.
> +	 *
> +	 * Since this is the device release function, we know that
> +	 * userspace does not have any open fd or mmap referring to
> +	 * the device.  Therefore there can not be any of the
> +	 * device attribute set/get, mmap, or page fault functions
> +	 * being executed concurrently, and similarly, the
> +	 * connect_vcpu and set/clr_mapped functions also cannot
> +	 * be being executed.
>  	 */
> -	kvm_for_each_vcpu(i, vcpu, kvm)
> +	was_ready = kvm->arch.mmu_ready;
> +	kvm->arch.mmu_ready = 0;
> +	kick_all_cpus_sync();
> +
> +	/*
> +	 * We should clean up the vCPU interrupt presenters first.
> +	 */
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		/*
> +		 * Take vcpu->mutex to ensure that no one_reg get/set ioctl
> +		 * (i.e. kvmppc_xive_native_[gs]et_vp) can be being done.
> +		 */
> +		mutex_lock(&vcpu->mutex);
>  		kvmppc_xive_native_cleanup_vcpu(vcpu);
> +		mutex_unlock(&vcpu->mutex);
> +	}
>  
> -	if (kvm)
> -		kvm->arch.xive = NULL;
> +	kvm->arch.xive = NULL;
>  
>  	for (i = 0; i <= xive->max_sbid; i++) {
>  		if (xive->src_blocks[i])
> @@ -999,6 +1025,8 @@ static void kvmppc_xive_native_release(struct kvm_device *dev)
>  	if (xive->vp_base != XIVE_INVALID_VP)
>  		xive_native_free_vp_block(xive->vp_base);
>  
> +	kvm->arch.mmu_ready = was_ready;
> +
>  	/*
>  	 * A reference of the kvmppc_xive pointer is now kept under
>  	 * the xive_devices struct of the machine for reuse. It is
> @@ -1009,6 +1037,9 @@ static void kvmppc_xive_native_release(struct kvm_device *dev)
>  	kfree(dev);
>  }
>  
> +/*
> + * Create a XIVE device.  kvm->lock is held.
> + */
>  static int kvmppc_xive_native_create(struct kvm_device *dev, u32 type)
>  {
>  	struct kvmppc_xive *xive;
> 

