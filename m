Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63A8E9CC94
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 11:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730888AbfHZJ2o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 05:28:44 -0400
Received: from 6.mo69.mail-out.ovh.net ([46.105.50.107]:35754 "EHLO
        6.mo69.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730846AbfHZJ2n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 05:28:43 -0400
X-Greylist: delayed 603 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Aug 2019 05:28:41 EDT
Received: from player692.ha.ovh.net (unknown [10.108.35.12])
        by mo69.mail-out.ovh.net (Postfix) with ESMTP id C2B6B619CF
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2019 11:08:45 +0200 (CEST)
Received: from kaod.org (lfbn-ren-1-123-36.w83-205.abo.wanadoo.fr [83.205.208.36])
        (Authenticated sender: clg@kaod.org)
        by player692.ha.ovh.net (Postfix) with ESMTPSA id 8581F8FD28C2;
        Mon, 26 Aug 2019 09:08:39 +0000 (UTC)
Subject: Re: [PATCH] KVM: PPC: Book3S: Enable XIVE native capability only if
 OPAL has required functions
To:     Paul Mackerras <paulus@ozlabs.org>, kvm@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Cc:     kvm-ppc@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
References: <20190826081455.GA7402@blackberry>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <4d31ae7f-9653-9552-ab4f-0c71afee61b7@kaod.org>
Date:   Mon, 26 Aug 2019 11:08:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190826081455.GA7402@blackberry>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 11645464212932168678
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduvddrudehgedguddvucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/08/2019 10:14, Paul Mackerras wrote:
> There are some POWER9 machines where the OPAL firmware does not support
> the OPAL_XIVE_GET_QUEUE_STATE and OPAL_XIVE_SET_QUEUE_STATE calls.
> The impact of this is that a guest using XIVE natively will not be able
> to be migrated successfully.  On the source side, the get_attr operation
> on the KVM native device for the KVM_DEV_XIVE_GRP_EQ_CONFIG attribute
> will fail; on the destination side, the set_attr operation for the same
> attribute will fail.
> 
> This adds tests for the existence of the OPAL get/set queue state
> functions, and if they are not supported, the XIVE-native KVM device
> is not created and the KVM_CAP_PPC_IRQ_XIVE capability returns false.
> Userspace can then either provide a software emulation of XIVE, or
> else tell the guest that it does not have a XIVE controller available
> to it.
> 
> Signed-off-by: Paul Mackerras <paulus@ozlabs.org>

Reviewed-by: Cédric Le Goater <clg@kaod.org>

Thanks,

C.


> ---
>  arch/powerpc/include/asm/kvm_ppc.h    | 1 +
>  arch/powerpc/include/asm/xive.h       | 1 +
>  arch/powerpc/kvm/book3s.c             | 8 +++++---
>  arch/powerpc/kvm/book3s_xive_native.c | 5 +++++
>  arch/powerpc/kvm/powerpc.c            | 3 ++-
>  arch/powerpc/sysdev/xive/native.c     | 7 +++++++
>  6 files changed, 21 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
> index 2484e6a..8e8514e 100644
> --- a/arch/powerpc/include/asm/kvm_ppc.h
> +++ b/arch/powerpc/include/asm/kvm_ppc.h
> @@ -598,6 +598,7 @@ extern int kvmppc_xive_native_get_vp(struct kvm_vcpu *vcpu,
>  				     union kvmppc_one_reg *val);
>  extern int kvmppc_xive_native_set_vp(struct kvm_vcpu *vcpu,
>  				     union kvmppc_one_reg *val);
> +extern bool kvmppc_xive_native_supported(void);
>  
>  #else
>  static inline int kvmppc_xive_set_xive(struct kvm *kvm, u32 irq, u32 server,
> diff --git a/arch/powerpc/include/asm/xive.h b/arch/powerpc/include/asm/xive.h
> index efb0e59..818989e 100644
> --- a/arch/powerpc/include/asm/xive.h
> +++ b/arch/powerpc/include/asm/xive.h
> @@ -135,6 +135,7 @@ extern int xive_native_get_queue_state(u32 vp_id, uint32_t prio, u32 *qtoggle,
>  extern int xive_native_set_queue_state(u32 vp_id, uint32_t prio, u32 qtoggle,
>  				       u32 qindex);
>  extern int xive_native_get_vp_state(u32 vp_id, u64 *out_state);
> +extern bool xive_native_has_queue_state_support(void);
>  
>  #else
>  
> diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
> index 9524d92..d7fcdfa 100644
> --- a/arch/powerpc/kvm/book3s.c
> +++ b/arch/powerpc/kvm/book3s.c
> @@ -1083,9 +1083,11 @@ static int kvmppc_book3s_init(void)
>  	if (xics_on_xive()) {
>  		kvmppc_xive_init_module();
>  		kvm_register_device_ops(&kvm_xive_ops, KVM_DEV_TYPE_XICS);
> -		kvmppc_xive_native_init_module();
> -		kvm_register_device_ops(&kvm_xive_native_ops,
> -					KVM_DEV_TYPE_XIVE);
> +		if (kvmppc_xive_native_supported()) {
> +			kvmppc_xive_native_init_module();
> +			kvm_register_device_ops(&kvm_xive_native_ops,
> +						KVM_DEV_TYPE_XIVE);
> +		}
>  	} else
>  #endif
>  		kvm_register_device_ops(&kvm_xics_ops, KVM_DEV_TYPE_XICS);
> diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
> index f0cab43..248c1ea 100644
> --- a/arch/powerpc/kvm/book3s_xive_native.c
> +++ b/arch/powerpc/kvm/book3s_xive_native.c
> @@ -1179,6 +1179,11 @@ int kvmppc_xive_native_set_vp(struct kvm_vcpu *vcpu, union kvmppc_one_reg *val)
>  	return 0;
>  }
>  
> +bool kvmppc_xive_native_supported(void)
> +{
> +	return xive_native_has_queue_state_support();
> +}
> +
>  static int xive_native_debug_show(struct seq_file *m, void *private)
>  {
>  	struct kvmppc_xive *xive = m->private;
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index 0dba7eb..7012dd7 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -566,7 +566,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  		 * a POWER9 processor) and the PowerNV platform, as
>  		 * nested is not yet supported.
>  		 */
> -		r = xive_enabled() && !!cpu_has_feature(CPU_FTR_HVMODE);
> +		r = xive_enabled() && !!cpu_has_feature(CPU_FTR_HVMODE) &&
> +			kvmppc_xive_native_supported();
>  		break;
>  #endif
>  
> diff --git a/arch/powerpc/sysdev/xive/native.c b/arch/powerpc/sysdev/xive/native.c
> index 2f26b74..37987c8 100644
> --- a/arch/powerpc/sysdev/xive/native.c
> +++ b/arch/powerpc/sysdev/xive/native.c
> @@ -800,6 +800,13 @@ int xive_native_set_queue_state(u32 vp_id, u32 prio, u32 qtoggle, u32 qindex)
>  }
>  EXPORT_SYMBOL_GPL(xive_native_set_queue_state);
>  
> +bool xive_native_has_queue_state_support(void)
> +{
> +	return opal_check_token(OPAL_XIVE_GET_QUEUE_STATE) &&
> +		opal_check_token(OPAL_XIVE_SET_QUEUE_STATE);
> +}
> +EXPORT_SYMBOL_GPL(xive_native_has_queue_state_support);
> +
>  int xive_native_get_vp_state(u32 vp_id, u64 *out_state)
>  {
>  	__be64 state;
> 

