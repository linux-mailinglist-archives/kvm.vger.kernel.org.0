Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F020142203
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2020 04:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729140AbgATDeM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Jan 2020 22:34:12 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:34613 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729015AbgATDeM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Jan 2020 22:34:12 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 481HMj2M00z9sRQ; Mon, 20 Jan 2020 14:34:09 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1579491249; bh=6J0yPKo/kn+WbG/Jx05ZU6+6m/AlQNEvaTssDj+re3g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J+bOs+MonJV9E7pI5lPc45XM0RCY2NjfQhio5m6/DttgJzWYQ3HNgH1xNUIV476t1
         ts+G5ufVu2nlLxna51nc4RLV4i+BMxNIj8OtXWtlekVH++JUnEo50tNL+EcDdMfnkK
         0tKNeAH0zTIwzwjt/ddygd75H6MloM9kMawF09dx8px7N8Z19MLfg0DZDiMcl7Jxj9
         O7BDLwTM/8mWG+Mi5fGu3SEx+TpDcDN2c+ViWcUIssgNg+IQQZy1GA8JrmdTUkDUam
         B5LzqGm2UwjQc0vxq2SUD2N7ikcbM2cnwWO5UhkiGCsdd5z9MQlNdr+cIMYXi//Jw1
         JWsmSqN7nCbMg==
Date:   Mon, 20 Jan 2020 14:00:41 +1100
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
Subject: Re: [PATCH v2 02/45] KVM: PPC: Book3S PR: Free shared page if mmu
 initialization fails
Message-ID: <20200120030041.GB14307@blackberry>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
 <20191218215530.2280-3-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218215530.2280-3-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 18, 2019 at 01:54:47PM -0800, Sean Christopherson wrote:
> Explicitly free the shared page if kvmppc_mmu_init() fails during
> kvmppc_core_vcpu_create(), as the page is freed only in
> kvmppc_core_vcpu_free(), which is not reached via kvm_vcpu_uninit().
> 
> Fixes: 96bc451a15329 ("KVM: PPC: Introduce shared page")
> Cc: stable@vger.kernel.org
> Reviewed-by: Greg Kurz <groug@kaod.org>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/powerpc/kvm/book3s_pr.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
> index ce4fcf76e53e..26ca62b6d773 100644
> --- a/arch/powerpc/kvm/book3s_pr.c
> +++ b/arch/powerpc/kvm/book3s_pr.c
> @@ -1806,10 +1806,12 @@ static struct kvm_vcpu *kvmppc_core_vcpu_create_pr(struct kvm *kvm,
>  
>  	err = kvmppc_mmu_init(vcpu);
>  	if (err < 0)
> -		goto uninit_vcpu;
> +		goto free_shared_page;
>  
>  	return vcpu;
>  
> +free_shared_page:
> +	free_page((unsigned long)vcpu->arch.shared);
>  uninit_vcpu:
>  	kvm_vcpu_uninit(vcpu);
>  free_shadow_vcpu:
> -- 
> 2.24.1

Looks correct.

Acked-by: Paul Mackerras <paulus@ozlabs.org>
