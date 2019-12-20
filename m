Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6A02127838
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 10:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727283AbfLTJds (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 04:33:48 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57406 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727265AbfLTJdo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Dec 2019 04:33:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576834422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kARvpg6EeSn47uf+HJvOWWm63eTYV3jwqH0aHeRURHY=;
        b=KoEe95fXnH3+7rYUbP5Hts1DNLWdfbNzptZwkKz2TRf2ARuv2Kj6C3PfBIF5D5C4MleZbj
        ljBUto9BjwrkUvIZDoZyQHGHU7XupKqHT7UrTi25AT2KCzsey2jJXMnfSj4yTq7vb9CfZX
        v02eH6fh8zjJ9iQ8/niHvCplbCniFL4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-euuv6RBAMwGCsT-Q338LuQ-1; Fri, 20 Dec 2019 04:33:41 -0500
X-MC-Unique: euuv6RBAMwGCsT-Q338LuQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 444D1911EB;
        Fri, 20 Dec 2019 09:33:38 +0000 (UTC)
Received: from gondolin (dhcp-192-245.str.redhat.com [10.33.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 82CC560BF3;
        Fri, 20 Dec 2019 09:33:27 +0000 (UTC)
Date:   Fri, 20 Dec 2019 10:33:25 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kurz <groug@kaod.org>
Subject: Re: [PATCH v2 30/45] KVM: Move vcpu alloc and init invocation to
 common code
Message-ID: <20191220103325.34fc2bf0.cohuck@redhat.com>
In-Reply-To: <20191218215530.2280-31-sean.j.christopherson@intel.com>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
        <20191218215530.2280-31-sean.j.christopherson@intel.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 18 Dec 2019 13:55:15 -0800
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> Now that all architectures tightly couple vcpu allocation/free with the
> mandatory calls to kvm_{un}init_vcpu(), move the sequences verbatim to
> common KVM code.
> 
> Move both allocation and initialization in a single patch to eliminate
> thrash in arch specific code.  The bisection benefits of moving the two
> pieces in separate patches is marginal at best, whereas the odds of
> introducing a transient arch specific bug are non-zero.
> 
> Acked-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/mips/kvm/mips.c       | 33 ++++++---------------------------
>  arch/powerpc/kvm/powerpc.c | 27 ++++-----------------------
>  arch/s390/kvm/kvm-s390.c   | 31 +++++--------------------------
>  arch/x86/kvm/x86.c         | 28 ++--------------------------
>  include/linux/kvm_host.h   |  2 +-
>  virt/kvm/arm/arm.c         | 29 ++---------------------------
>  virt/kvm/kvm_main.c        | 21 ++++++++++++++++++---
>  7 files changed, 38 insertions(+), 133 deletions(-)

(...)

> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 8543d338a06a..2ed76584ebd9 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2530,9 +2530,6 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>  	if (vcpu->kvm->arch.use_cmma)
>  		kvm_s390_vcpu_unsetup_cmma(vcpu);
>  	free_page((unsigned long)(vcpu->arch.sie_block));
> -
> -	kvm_vcpu_uninit(vcpu);
> -	kmem_cache_free(kvm_vcpu_cache, vcpu);
>  }
>  
>  static void kvm_free_vcpus(struct kvm *kvm)
> @@ -3014,29 +3011,15 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
>  	return 0;
>  }
>  
> -struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
> -				      unsigned int id)
> +int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  {
> -	struct kvm_vcpu *vcpu;
>  	struct sie_page *sie_page;
>  	int rc;
>  
> -	rc = -ENOMEM;
> -
> -	vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
> -	if (!vcpu)
> -		goto out;
> -
> -	rc = kvm_vcpu_init(vcpu, kvm, id);
> -	if (rc)
> -		goto out_free_cpu;
> -
> -	rc = -ENOMEM;
> -
>  	BUILD_BUG_ON(sizeof(struct sie_page) != 4096);
>  	sie_page = (struct sie_page *) get_zeroed_page(GFP_KERNEL);
>  	if (!sie_page)
> -		goto out_uninit_vcpu;
> +		return -ENOMEM;
>  
>  	vcpu->arch.sie_block = &sie_page->sie_block;
>  	vcpu->arch.sie_block->itdba = (unsigned long) &sie_page->itdb;
> @@ -3087,15 +3070,11 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
>  		 vcpu->arch.sie_block);
>  	trace_kvm_s390_create_vcpu(id, vcpu, vcpu->arch.sie_block);
>  
> -	return vcpu;
> +	return 0;
> +
>  out_free_sie_block:
>  	free_page((unsigned long)(vcpu->arch.sie_block));
> -out_uninit_vcpu:
> -	kvm_vcpu_uninit(vcpu);
> -out_free_cpu:
> -	kmem_cache_free(kvm_vcpu_cache, vcpu);
> -out:
> -	return ERR_PTR(rc);
> +	return rc;

This is getting a bit hard to follow across the patches, but I think rc
is now only set for ucontrol guests. So this looks correct right now,
but feels a bit brittle... should we maybe init rc to 0 and always
return rc instead?

>  }
>  
>  int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)

Otherwise, looks good.

