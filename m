Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9921618BFC2
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 19:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbgCSS56 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 14:57:58 -0400
Received: from 14.mo3.mail-out.ovh.net ([188.165.43.98]:52030 "EHLO
        14.mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726881AbgCSS54 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 14:57:56 -0400
X-Greylist: delayed 8862 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Mar 2020 14:57:55 EDT
Received: from player756.ha.ovh.net (unknown [10.108.35.185])
        by mo3.mail-out.ovh.net (Postfix) with ESMTP id 8DD3E247BBC
        for <kvm@vger.kernel.org>; Thu, 19 Mar 2020 17:30:12 +0100 (CET)
Received: from kaod.org (lns-bzn-46-82-253-208-248.adsl.proxad.net [82.253.208.248])
        (Authenticated sender: groug@kaod.org)
        by player756.ha.ovh.net (Postfix) with ESMTPSA id 8E596FC4FAA2;
        Thu, 19 Mar 2020 16:30:07 +0000 (UTC)
Date:   Thu, 19 Mar 2020 17:30:00 +0100
From:   Greg Kurz <groug@kaod.org>
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Add a capability for enabling
 secure guests
Message-ID: <20200319173000.20e10c7b@bahia.lan>
In-Reply-To: <20200319043301.GA13052@blackberry>
References: <20200319043301.GA13052@blackberry>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 11390729361711405499
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedugedrudefledgkeelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfgjfhfogggtgfesthejredtredtvdenucfhrhhomhepifhrvghgucfmuhhriicuoehgrhhouhhgsehkrghougdrohhrgheqnecukfhppedtrddtrddtrddtpdekvddrvdehfedrvddtkedrvdegkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehplhgrhigvrhejheeirdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomhepghhrohhugheskhgrohgurdhorhhgpdhrtghpthhtohepkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 19 Mar 2020 15:33:01 +1100
Paul Mackerras <paulus@ozlabs.org> wrote:

> At present, on Power systems with Protected Execution Facility
> hardware and an ultravisor, a KVM guest can transition to being a
> secure guest at will.  Userspace (QEMU) has no way of knowing
> whether a host system is capable of running secure guests.  This
> will present a problem in future when the ultravisor is capable of
> migrating secure guests from one host to another, because
> virtualization management software will have no way to ensure that
> secure guests only run in domains where all of the hosts can
> support secure guests.
> 
> This adds a VM capability which has two functions: (a) userspace
> can query it to find out whether the host can support secure guests,
> and (b) userspace can enable it for a guest, which allows that
> guest to become a secure guest.  If userspace does not enable it,
> KVM will return an error when the ultravisor does the hypercall
> that indicates that the guest is starting to transition to a
> secure guest.  The ultravisor will then abort the transition and
> the guest will terminate.
> 
> Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
> ---

Reviewed-by: Greg Kurz <groug@kaod.org>

Is someone working on wiring this up in QEMU ?

> Note, only compile-tested.  Ram, please test.
> 
>  Documentation/virt/kvm/api.rst      | 17 +++++++++++++++++
>  arch/powerpc/include/asm/kvm_host.h |  1 +
>  arch/powerpc/include/asm/kvm_ppc.h  |  1 +
>  arch/powerpc/kvm/book3s_hv.c        | 13 +++++++++++++
>  arch/powerpc/kvm/book3s_hv_uvmem.c  |  4 ++++
>  arch/powerpc/kvm/powerpc.c          | 13 +++++++++++++
>  include/uapi/linux/kvm.h            |  1 +
>  7 files changed, 50 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 158d118..a925500 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -5779,6 +5779,23 @@ it hard or impossible to use it correctly.  The availability of
>  KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 signals that those bugs are fixed.
>  Userspace should not try to use KVM_CAP_MANUAL_DIRTY_LOG_PROTECT.
>  
> +7.19 KVM_CAP_PPC_SECURE_GUEST
> +------------------------------
> +
> +:Architectures: ppc
> +
> +This capability indicates that KVM is running on a host that has
> +ultravisor firmware and thus can support a secure guest.  On such a
> +system, a guest can ask the ultravisor to make it a secure guest,
> +one whose memory is inaccessible to the host except for pages which
> +are explicitly requested to be shared with the host.  The ultravisor
> +notifies KVM when a guest requests to become a secure guest, and KVM
> +has the opportunity to veto the transition.
> +
> +If present, this capability can be enabled for a VM, meaning that KVM
> +will allow the transition to secure guest mode.  Otherwise KVM will
> +veto the transition.
> +
>  8. Other capabilities.
>  ======================
>  
> diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
> index 6e8b8ff..f99b433 100644
> --- a/arch/powerpc/include/asm/kvm_host.h
> +++ b/arch/powerpc/include/asm/kvm_host.h
> @@ -303,6 +303,7 @@ struct kvm_arch {
>  	u8 radix;
>  	u8 fwnmi_enabled;
>  	u8 secure_guest;
> +	u8 svm_enabled;
>  	bool threads_indep;
>  	bool nested_enable;
>  	pgd_t *pgtable;
> diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
> index 406ec46..0733618 100644
> --- a/arch/powerpc/include/asm/kvm_ppc.h
> +++ b/arch/powerpc/include/asm/kvm_ppc.h
> @@ -316,6 +316,7 @@ struct kvmppc_ops {
>  			       int size);
>  	int (*store_to_eaddr)(struct kvm_vcpu *vcpu, ulong *eaddr, void *ptr,
>  			      int size);
> +	int (*enable_svm)(struct kvm *kvm);
>  	int (*svm_off)(struct kvm *kvm);
>  };
>  
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index fbc55a1..36da720 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -5423,6 +5423,18 @@ static void unpin_vpa_reset(struct kvm *kvm, struct kvmppc_vpa *vpa)
>  }
>  
>  /*
> + * Enable a guest to become a secure VM.
> + * Called when the KVM_CAP_PPC_SECURE_GUEST capability is enabled.
> + */
> +static int kvmhv_enable_svm(struct kvm *kvm)
> +{
> +	if (!firmware_has_feature(FW_FEATURE_ULTRAVISOR))
> +		return -EINVAL;
> +	kvm->arch.svm_enabled = 1;
> +	return 0;
> +}
> +
> +/*
>   *  IOCTL handler to turn off secure mode of guest
>   *
>   * - Release all device pages
> @@ -5543,6 +5555,7 @@ static struct kvmppc_ops kvm_ops_hv = {
>  	.enable_nested = kvmhv_enable_nested,
>  	.load_from_eaddr = kvmhv_load_from_eaddr,
>  	.store_to_eaddr = kvmhv_store_to_eaddr,
> +	.enable_svm = kvmhv_enable_svm,
>  	.svm_off = kvmhv_svm_off,
>  };
>  
> diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
> index 79b1202..2ad999f 100644
> --- a/arch/powerpc/kvm/book3s_hv_uvmem.c
> +++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
> @@ -216,6 +216,10 @@ unsigned long kvmppc_h_svm_init_start(struct kvm *kvm)
>  	if (!kvm_is_radix(kvm))
>  		return H_UNSUPPORTED;
>  
> +	/* NAK the transition to secure if not enabled */
> +	if (!kvm->arch.svm_enabled)
> +		return H_AUTHORITY;
> +
>  	srcu_idx = srcu_read_lock(&kvm->srcu);
>  	slots = kvm_memslots(kvm);
>  	kvm_for_each_memslot(memslot, slots) {
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index 62ee66d..c32e6cc2 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -670,6 +670,11 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  		     (hv_enabled && cpu_has_feature(CPU_FTR_P9_TM_HV_ASSIST));
>  		break;
>  #endif
> +#if defined(CONFIG_KVM_BOOK3S_HV_POSSIBLE) && defined(CONFIG_PPC_UV)
> +	case KVM_CAP_PPC_SECURE_GUEST:
> +		r = hv_enabled && !!firmware_has_feature(FW_FEATURE_ULTRAVISOR);
> +		break;
> +#endif
>  	default:
>  		r = 0;
>  		break;
> @@ -2170,6 +2175,14 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  		r = kvm->arch.kvm_ops->enable_nested(kvm);
>  		break;
>  #endif
> +#if defined(CONFIG_KVM_BOOK3S_HV_POSSIBLE) && defined(CONFIG_PPC_UV)
> +	case KVM_CAP_PPC_SECURE_GUEST:
> +		r = -EINVAL;
> +		if (!is_kvmppc_hv_enabled(kvm) || !kvm->arch.kvm_ops->enable_svm)
> +			break;
> +		r = kvm->arch.kvm_ops->enable_svm(kvm);
> +		break;
> +#endif
>  	default:
>  		r = -EINVAL;
>  		break;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 5e6234c..428c7dd 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1016,6 +1016,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_ARM_INJECT_EXT_DABT 178
>  #define KVM_CAP_S390_VCPU_RESETS 179
>  #define KVM_CAP_S390_PROTECTED 180
> +#define KVM_CAP_PPC_SECURE_GUEST 181
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  

