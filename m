Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9643276B8
	for <lists+kvm@lfdr.de>; Thu, 23 May 2019 09:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbfEWHLT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 May 2019 03:11:19 -0400
Received: from 7.mo173.mail-out.ovh.net ([46.105.44.159]:40558 "EHLO
        7.mo173.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbfEWHLT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 May 2019 03:11:19 -0400
Received: from player718.ha.ovh.net (unknown [10.109.146.168])
        by mo173.mail-out.ovh.net (Postfix) with ESMTP id D307310A9A8
        for <kvm@vger.kernel.org>; Thu, 23 May 2019 09:11:16 +0200 (CEST)
Received: from kaod.org (lfbn-1-10649-41.w90-89.abo.wanadoo.fr [90.89.235.41])
        (Authenticated sender: clg@kaod.org)
        by player718.ha.ovh.net (Postfix) with ESMTPSA id 8EE755FFECF3;
        Thu, 23 May 2019 07:11:14 +0000 (UTC)
Subject: Re: [PATCH 3/4] KVM: PPC: Book3S: Use new mutex to synchronize access
 to rtas token list
To:     Paul Mackerras <paulus@ozlabs.org>, kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org
References: <20190523063424.GB19655@blackberry>
 <20190523063601.GE19655@blackberry>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <ca922e73-5801-0938-d86d-63b60fcce68e@kaod.org>
Date:   Thu, 23 May 2019 09:11:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190523063601.GE19655@blackberry>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 5157747473747774423
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddruddufedguddvtdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecu
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/23/19 8:36 AM, Paul Mackerras wrote:
> Currently the Book 3S KVM code uses kvm->lock to synchronize access
> to the kvm->arch.rtas_tokens list.  Because this list is scanned
> inside kvmppc_rtas_hcall(), which is called with the vcpu mutex held,
> taking kvm->lock cause a lock inversion problem, which could lead to
> a deadlock.
> 
> To fix this, we add a new mutex, kvm->arch.rtas_token_lock, which nests
> inside the vcpu mutexes, and use that instead of kvm->lock when
> accessing the rtas token list.

We still need to remove the use of the kvm->lock in the RTAS call 
"set-xive" doing the EQ provisioning for all the vCPUs of the VM.  
I am looking at that part.

> Signed-off-by: Paul Mackerras <paulus@ozlabs.org>

Reviewed-by: Cédric Le Goater <clg@kaod.org>

Thanks,

C.

> ---
>  arch/powerpc/include/asm/kvm_host.h |  1 +
>  arch/powerpc/kvm/book3s.c           |  1 +
>  arch/powerpc/kvm/book3s_rtas.c      | 14 +++++++-------
>  3 files changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
> index 26b3ce4..d10df67 100644
> --- a/arch/powerpc/include/asm/kvm_host.h
> +++ b/arch/powerpc/include/asm/kvm_host.h
> @@ -309,6 +309,7 @@ struct kvm_arch {
>  #ifdef CONFIG_PPC_BOOK3S_64
>  	struct list_head spapr_tce_tables;
>  	struct list_head rtas_tokens;
> +	struct mutex rtas_token_lock;
>  	DECLARE_BITMAP(enabled_hcalls, MAX_HCALL_OPCODE/4 + 1);
>  #endif
>  #ifdef CONFIG_KVM_MPIC
> diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
> index 61a212d..ac56648 100644
> --- a/arch/powerpc/kvm/book3s.c
> +++ b/arch/powerpc/kvm/book3s.c
> @@ -902,6 +902,7 @@ int kvmppc_core_init_vm(struct kvm *kvm)
>  #ifdef CONFIG_PPC64
>  	INIT_LIST_HEAD_RCU(&kvm->arch.spapr_tce_tables);
>  	INIT_LIST_HEAD(&kvm->arch.rtas_tokens);
> +	mutex_init(&kvm->arch.rtas_token_lock);
>  #endif
>  
>  	return kvm->arch.kvm_ops->init_vm(kvm);
> diff --git a/arch/powerpc/kvm/book3s_rtas.c b/arch/powerpc/kvm/book3s_rtas.c
> index 4e178c4..47279a5 100644
> --- a/arch/powerpc/kvm/book3s_rtas.c
> +++ b/arch/powerpc/kvm/book3s_rtas.c
> @@ -146,7 +146,7 @@ static int rtas_token_undefine(struct kvm *kvm, char *name)
>  {
>  	struct rtas_token_definition *d, *tmp;
>  
> -	lockdep_assert_held(&kvm->lock);
> +	lockdep_assert_held(&kvm->arch.rtas_token_lock);
>  
>  	list_for_each_entry_safe(d, tmp, &kvm->arch.rtas_tokens, list) {
>  		if (rtas_name_matches(d->handler->name, name)) {
> @@ -167,7 +167,7 @@ static int rtas_token_define(struct kvm *kvm, char *name, u64 token)
>  	bool found;
>  	int i;
>  
> -	lockdep_assert_held(&kvm->lock);
> +	lockdep_assert_held(&kvm->arch.rtas_token_lock);
>  
>  	list_for_each_entry(d, &kvm->arch.rtas_tokens, list) {
>  		if (d->token == token)
> @@ -206,14 +206,14 @@ int kvm_vm_ioctl_rtas_define_token(struct kvm *kvm, void __user *argp)
>  	if (copy_from_user(&args, argp, sizeof(args)))
>  		return -EFAULT;
>  
> -	mutex_lock(&kvm->lock);
> +	mutex_lock(&kvm->arch.rtas_token_lock);
>  
>  	if (args.token)
>  		rc = rtas_token_define(kvm, args.name, args.token);
>  	else
>  		rc = rtas_token_undefine(kvm, args.name);
>  
> -	mutex_unlock(&kvm->lock);
> +	mutex_unlock(&kvm->arch.rtas_token_lock);
>  
>  	return rc;
>  }
> @@ -245,7 +245,7 @@ int kvmppc_rtas_hcall(struct kvm_vcpu *vcpu)
>  	orig_rets = args.rets;
>  	args.rets = &args.args[be32_to_cpu(args.nargs)];
>  
> -	mutex_lock(&vcpu->kvm->lock);
> +	mutex_lock(&vcpu->kvm->arch.rtas_token_lock);
>  
>  	rc = -ENOENT;
>  	list_for_each_entry(d, &vcpu->kvm->arch.rtas_tokens, list) {
> @@ -256,7 +256,7 @@ int kvmppc_rtas_hcall(struct kvm_vcpu *vcpu)
>  		}
>  	}
>  
> -	mutex_unlock(&vcpu->kvm->lock);
> +	mutex_unlock(&vcpu->kvm->arch.rtas_token_lock);
>  
>  	if (rc == 0) {
>  		args.rets = orig_rets;
> @@ -282,7 +282,7 @@ void kvmppc_rtas_tokens_free(struct kvm *kvm)
>  {
>  	struct rtas_token_definition *d, *tmp;
>  
> -	lockdep_assert_held(&kvm->lock);
> +	lockdep_assert_held(&kvm->arch.rtas_token_lock);
>  
>  	list_for_each_entry_safe(d, tmp, &kvm->arch.rtas_tokens, list) {
>  		list_del(&d->list);
> 

