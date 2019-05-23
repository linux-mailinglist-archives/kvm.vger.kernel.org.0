Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2A11276B6
	for <lists+kvm@lfdr.de>; Thu, 23 May 2019 09:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbfEWHLI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 May 2019 03:11:08 -0400
Received: from 8.mo3.mail-out.ovh.net ([87.98.172.249]:60115 "EHLO
        8.mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726222AbfEWHLI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 May 2019 03:11:08 -0400
Received: from player716.ha.ovh.net (unknown [10.108.35.13])
        by mo3.mail-out.ovh.net (Postfix) with ESMTP id BFCF0207690
        for <kvm@vger.kernel.org>; Thu, 23 May 2019 09:11:05 +0200 (CEST)
Received: from kaod.org (lfbn-1-10649-41.w90-89.abo.wanadoo.fr [90.89.235.41])
        (Authenticated sender: clg@kaod.org)
        by player716.ha.ovh.net (Postfix) with ESMTPSA id 08BC96027F5A;
        Thu, 23 May 2019 07:11:02 +0000 (UTC)
Subject: Re: [PATCH 4/4] KVM: PPC: Book3S HV: Don't take kvm->lock around
 kvm_for_each_vcpu
To:     Paul Mackerras <paulus@ozlabs.org>, kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org
References: <20190523063424.GB19655@blackberry>
 <20190523063632.GF19655@blackberry>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <f8316367-7ad4-7c3a-f076-88a98085d4b3@kaod.org>
Date:   Thu, 23 May 2019 09:11:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190523063632.GF19655@blackberry>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 5154651250244422615
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddruddufedguddvtdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecu
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/23/19 8:36 AM, Paul Mackerras wrote:
> Currently the HV KVM code takes the kvm->lock around calls to
> kvm_for_each_vcpu() and kvm_get_vcpu_by_id() (which can call
> kvm_for_each_vcpu() internally).  However, that leads to a lock
> order inversion problem, because these are called in contexts where
> the vcpu mutex is held, but the vcpu mutexes nest within kvm->lock
> according to Documentation/virtual/kvm/locking.txt.  Hence there
> is a possibility of deadlock.
> 
> To fix this, we simply don't take the kvm->lock mutex around these
> calls.  This is safe because the implementations of kvm_for_each_vcpu()
> and kvm_get_vcpu_by_id() have been designed to be able to be called
> locklessly.

Yes.

Reviewed-by: Cédric Le Goater <clg@kaod.org>

Thanks,

C.

> 
> Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
> ---
>  arch/powerpc/kvm/book3s_hv.c | 9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index b1c0a9b..27054d3 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -446,12 +446,7 @@ static void kvmppc_dump_regs(struct kvm_vcpu *vcpu)
>  
>  static struct kvm_vcpu *kvmppc_find_vcpu(struct kvm *kvm, int id)
>  {
> -	struct kvm_vcpu *ret;
> -
> -	mutex_lock(&kvm->lock);
> -	ret = kvm_get_vcpu_by_id(kvm, id);
> -	mutex_unlock(&kvm->lock);
> -	return ret;
> +	return kvm_get_vcpu_by_id(kvm, id);
>  }
>  
>  static void init_vpa(struct kvm_vcpu *vcpu, struct lppaca *vpa)
> @@ -1583,7 +1578,6 @@ static void kvmppc_set_lpcr(struct kvm_vcpu *vcpu, u64 new_lpcr,
>  	struct kvmppc_vcore *vc = vcpu->arch.vcore;
>  	u64 mask;
>  
> -	mutex_lock(&kvm->lock);
>  	spin_lock(&vc->lock);
>  	/*
>  	 * If ILE (interrupt little-endian) has changed, update the
> @@ -1623,7 +1617,6 @@ static void kvmppc_set_lpcr(struct kvm_vcpu *vcpu, u64 new_lpcr,
>  		mask &= 0xFFFFFFFF;
>  	vc->lpcr = (vc->lpcr & ~mask) | (new_lpcr & mask);
>  	spin_unlock(&vc->lock);
> -	mutex_unlock(&kvm->lock);
>  }
>  
>  static int kvmppc_get_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
> 

