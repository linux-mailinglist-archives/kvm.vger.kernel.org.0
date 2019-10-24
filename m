Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B13FDE2B46
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 09:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407145AbfJXHof (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 03:44:35 -0400
Received: from 3.mo3.mail-out.ovh.net ([46.105.44.175]:45187 "EHLO
        3.mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404543AbfJXHof (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 03:44:35 -0400
Received: from player788.ha.ovh.net (unknown [10.109.146.53])
        by mo3.mail-out.ovh.net (Postfix) with ESMTP id EA96D22A291
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 09:04:46 +0200 (CEST)
Received: from kaod.org (lns-bzn-46-82-253-208-248.adsl.proxad.net [82.253.208.248])
        (Authenticated sender: groug@kaod.org)
        by player788.ha.ovh.net (Postfix) with ESMTPSA id CA63BB4D6960;
        Thu, 24 Oct 2019 07:04:07 +0000 (UTC)
Date:   Thu, 24 Oct 2019 09:04:03 +0200
From:   Greg Kurz <groug@kaod.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
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
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/45] KVM: PPC: Book3S HV: Uninit vCPU if vcore
 creation fails
Message-ID: <20191024090403.5e564e39@bahia.lan>
In-Reply-To: <20191022015925.31916-2-sean.j.christopherson@intel.com>
References: <20191022015925.31916-1-sean.j.christopherson@intel.com>
        <20191022015925.31916-2-sean.j.christopherson@intel.com>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 5552375392181655889
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedufedrledtgdduudefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 21 Oct 2019 18:58:41 -0700
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> Call kvm_vcpu_uninit() if vcore creation fails to avoid leaking any
> resources allocated by kvm_vcpu_init(), i.e. the vcpu->run page.
> 
> Fixes: 371fefd6f2dc4 ("KVM: PPC: Allow book3s_hv guests to use SMT processor modes")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---

Reviewed-by: Greg Kurz <groug@kaod.org>

>  arch/powerpc/kvm/book3s_hv.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 709cf1fd4cf4..36abbe3c346d 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -2354,7 +2354,7 @@ static struct kvm_vcpu *kvmppc_core_vcpu_create_hv(struct kvm *kvm,
>  	mutex_unlock(&kvm->lock);
>  
>  	if (!vcore)
> -		goto free_vcpu;
> +		goto uninit_vcpu;
>  
>  	spin_lock(&vcore->lock);
>  	++vcore->num_threads;
> @@ -2371,6 +2371,8 @@ static struct kvm_vcpu *kvmppc_core_vcpu_create_hv(struct kvm *kvm,
>  
>  	return vcpu;
>  
> +uninit_vcpu:
> +	kvm_vcpu_uninit(vcpu);
>  free_vcpu:
>  	kmem_cache_free(kvm_vcpu_cache, vcpu);
>  out:

