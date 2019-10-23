Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76DB6E15E2
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2019 11:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403928AbfJWJ3j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Oct 2019 05:29:39 -0400
Received: from [217.140.110.172] ([217.140.110.172]:45844 "EHLO foss.arm.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1732648AbfJWJ3i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Oct 2019 05:29:38 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 699E54F2;
        Wed, 23 Oct 2019 02:29:15 -0700 (PDT)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.145.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E83E23F718;
        Wed, 23 Oct 2019 02:29:14 -0700 (PDT)
Date:   Wed, 23 Oct 2019 11:29:13 +0200
From:   Christoffer Dall <christoffer.dall@arm.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Cornelia Huck <cohuck@redhat.com>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 02/15] KVM: Don't free new memslot if allocation of
 said memslot fails
Message-ID: <20191023092913.GE2652@e113682-lin.lund.arm.com>
References: <20191022003537.13013-1-sean.j.christopherson@intel.com>
 <20191022003537.13013-3-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191022003537.13013-3-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 21, 2019 at 05:35:24PM -0700, Sean Christopherson wrote:
> The two implementations of kvm_arch_create_memslot() in x86 and PPC are
> both good citizens and free up all local resources if creation fails.
> Return immediately (via a superfluous goto) instead of calling
> kvm_free_memslot().
> 
> Note, the call to kvm_free_memslot() is effectively an expensive nop in
> this case as there are no resources to be freed.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  virt/kvm/kvm_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 9afd706dc038..2cb38b2148cb 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1014,7 +1014,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  		new.userspace_addr = mem->userspace_addr;
>  
>  		if (kvm_arch_create_memslot(kvm, &new, npages))
> -			goto out_free;
> +			goto out;
>  	}
>  
>  	/* Allocate page dirty bitmap if needed */
> -- 
> 2.22.0
> 

Acked-by: Christoffer Dall <christoffer.dall@arm.com>
