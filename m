Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD77914220C
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2020 04:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729122AbgATDeM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Jan 2020 22:34:12 -0500
Received: from ozlabs.org ([203.11.71.1]:37193 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729011AbgATDeM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Jan 2020 22:34:12 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 481HMj02PMz9sRK; Mon, 20 Jan 2020 14:34:08 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1579491249; bh=Bx1QENbI/taNJYozRF14LNd8JjoLRwCSpGh5bRXaoZc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BalvDW2whNPsvCmtISkbOhDMpZauUgvHl09Uaty2WElwJ6Cza+b4DeHGcnUNwOLV3
         g6DRm1DMzCI/vBJ1PlZfghThTKRiDTXm/9cEYl1gDtPWzG4q+29NKYsabkOFnLKJZW
         pu7HnKn8KFD4ACQ0z1wJAaZ09+iERSqPxVmZuqJ9tVnb3xT4AbRscYT7AxP5jHVWa0
         3Gb0VAa6x9zDA27RPpRqnF9yfWp6Q9n39W6+HvqOjYYy/h9z34BptPYaZs8RzgPLLz
         x8CTvY8aTo7+f8KU7v7y459Sv+srWbj2FDlNPNQXb3Ix1Y7vabAiDRVuXNEoR2XexB
         QTFYCAbB5+mEg==
Date:   Mon, 20 Jan 2020 13:57:16 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Hogan <jhogan@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kurz <groug@kaod.org>
Subject: Re: [PATCH v2 01/45] KVM: PPC: Book3S HV: Uninit vCPU if vcore
 creation fails
Message-ID: <20200120025716.GA14307@blackberry>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
 <20191218215530.2280-2-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218215530.2280-2-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 18, 2019 at 01:54:46PM -0800, Sean Christopherson wrote:
> Call kvm_vcpu_uninit() if vcore creation fails to avoid leaking any
> resources allocated by kvm_vcpu_init(), i.e. the vcpu->run page.
> 
> Fixes: 371fefd6f2dc4 ("KVM: PPC: Allow book3s_hv guests to use SMT processor modes")
> Cc: stable@vger.kernel.org
> Reviewed-by: Greg Kurz <groug@kaod.org>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/powerpc/kvm/book3s_hv.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index dc53578193ee..d07d2f5273e5 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -2368,7 +2368,7 @@ static struct kvm_vcpu *kvmppc_core_vcpu_create_hv(struct kvm *kvm,
>  	mutex_unlock(&kvm->lock);
>  
>  	if (!vcore)
> -		goto free_vcpu;
> +		goto uninit_vcpu;
>  
>  	spin_lock(&vcore->lock);
>  	++vcore->num_threads;
> @@ -2385,6 +2385,8 @@ static struct kvm_vcpu *kvmppc_core_vcpu_create_hv(struct kvm *kvm,
>  
>  	return vcpu;
>  
> +uninit_vcpu:
> +	kvm_vcpu_uninit(vcpu);
>  free_vcpu:
>  	kmem_cache_free(kvm_vcpu_cache, vcpu);
>  out:
> -- 
> 2.24.1

Looks correct.

Acked-by: Paul Mackerras <paulus@ozlabs.org>
