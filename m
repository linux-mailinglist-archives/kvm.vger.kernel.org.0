Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98A28647855
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 22:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbiLHV4p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 16:56:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiLHV4b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 16:56:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E406B9BE
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 13:55:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670536524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fZEl3N04EMAP2CKa6UNjlTejw3q2BTFmKhNwbtfSXdQ=;
        b=FBFylfhyWgP5zi41KT1AUJqfaYISFIFtVuXF06ZmzOU5VB1fcFuqt5XgQklXiBgbaRSPAq
        CV3DlTO7LS854s/fg/j383k8fCF1o+8g+oNUss23CdhH3AMlYfiiVdQqsXQEDQe3186P81
        fqO8bkYzU7s5xsE9qpYtVz+DYHsYbGc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-256-Pkd-WK6wM6SjpHbiMn6xxw-1; Thu, 08 Dec 2022 16:55:21 -0500
X-MC-Unique: Pkd-WK6wM6SjpHbiMn6xxw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A516185A78B;
        Thu,  8 Dec 2022 21:55:21 +0000 (UTC)
Received: from starship (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D64B6140EBF5;
        Thu,  8 Dec 2022 21:55:19 +0000 (UTC)
Message-ID: <b358ea43c7647c4ec4678932d1912845a2b29f1b.camel@redhat.com>
Subject: Re: [PATCH v4 10/32] KVM: x86: Move APIC access page helper to
 common x86 code
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Thu, 08 Dec 2022 23:55:18 +0200
In-Reply-To: <20221001005915.2041642-11-seanjc@google.com>
References: <20221001005915.2041642-1-seanjc@google.com>
         <20221001005915.2041642-11-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-10-01 at 00:58 +0000, Sean Christopherson wrote:
> Move the APIC access page allocation helper function to common x86 code,
> the allocation routine is virtually identical between APICv (VMX) and
> AVIC (SVM).  Keep APICv's gfn_to_page() + put_page() sequence, which
> verifies that a backing page can be allocated, i.e. that the system isn't
> under heavy memory pressure.  Forcing the backing page to be populated
> isn't strictly necessary, but skipping the effective prefetch only delays
> the inevitable.


Just a note on the way we deal with that dummy page differs between APICv and AVIC
a bit:


On APICv we need physical address of the dummy page, since APICv 
has physical address of this page in VMCB, and when guest "accesses"
only then APICv specific handling is invoked.

Since we don't want to pin it, we have a mmu notifier telling us where
it is currently and we update the vmcb each time it moves.

If the page is swapped out, mmu notifier will call us, and we will
pretty much swap it back in on next VM entry, in 'vmx_set_apic_access_page_addr'
I hope that this code doesn't have races, I never looked at depth at it.


On AVIC on the other hand we don't force the page to be mapped at all, since
AVIC stores in the vmcb the virtual address of the page and only checkes that
'something' is mapped there.

If we get nothing mapped there, AVIC will not intercept, we will get normal
NPT fault and hopefully swap that page in.


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky



> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/lapic.c    | 35 +++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/lapic.h    |  1 +
>  arch/x86/kvm/svm/avic.c | 41 +++++++----------------------------------
>  arch/x86/kvm/vmx/vmx.c  | 35 +----------------------------------
>  4 files changed, 44 insertions(+), 68 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 316b61b56cca..80e8b1cc6dc2 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2436,6 +2436,41 @@ void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
>  }
>  EXPORT_SYMBOL_GPL(kvm_apic_update_apicv);
>  
> +int kvm_alloc_apic_access_page(struct kvm *kvm)
> +{
> +	struct page *page;
> +	void __user *hva;
> +	int ret = 0;
> +
> +	mutex_lock(&kvm->slots_lock);
> +	if (kvm->arch.apic_access_memslot_enabled)
> +		goto out;
> +
> +	hva = __x86_set_memory_region(kvm, APIC_ACCESS_PAGE_PRIVATE_MEMSLOT,
> +				      APIC_DEFAULT_PHYS_BASE, PAGE_SIZE);
> +	if (IS_ERR(hva)) {
> +		ret = PTR_ERR(hva);
> +		goto out;
> +	}
> +
> +	page = gfn_to_page(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
> +	if (is_error_page(page)) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	/*
> +	 * Do not pin the page in memory, so that memory hot-unplug
> +	 * is able to migrate it.
> +	 */
> +	put_page(page);




> +	kvm->arch.apic_access_memslot_enabled = true;
> +out:
> +	mutex_unlock(&kvm->slots_lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(kvm_alloc_apic_access_page);
> +
>  void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
>  {
>  	struct kvm_lapic *apic = vcpu->arch.apic;
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index a5ac4a5a5179..0587a8282cb3 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -112,6 +112,7 @@ int kvm_apic_set_irq(struct kvm_vcpu *vcpu, struct kvm_lapic_irq *irq,
>  		     struct dest_map *dest_map);
>  int kvm_apic_local_deliver(struct kvm_lapic *apic, int lvt_type);
>  void kvm_apic_update_apicv(struct kvm_vcpu *vcpu);
> +int kvm_alloc_apic_access_page(struct kvm *kvm);
>  
>  bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
>  		struct kvm_lapic_irq *irq, int *r, struct dest_map *dest_map);
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 97ad0661f963..ec28ba4c5f1b 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -256,39 +256,6 @@ static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
>  	return &avic_physical_id_table[index];
>  }
>  
> -/*
> - * Note:
> - * AVIC hardware walks the nested page table to check permissions,
> - * but does not use the SPA address specified in the leaf page
> - * table entry since it uses  address in the AVIC_BACKING_PAGE pointer
> - * field of the VMCB. Therefore, we set up the
> - * APIC_ACCESS_PAGE_PRIVATE_MEMSLOT (4KB) here.
> - */
> -static int avic_alloc_access_page(struct kvm *kvm)
> -{
> -	void __user *ret;
> -	int r = 0;
> -
> -	mutex_lock(&kvm->slots_lock);
> -
> -	if (kvm->arch.apic_access_memslot_enabled)
> -		goto out;
> -
> -	ret = __x86_set_memory_region(kvm,
> -				      APIC_ACCESS_PAGE_PRIVATE_MEMSLOT,
> -				      APIC_DEFAULT_PHYS_BASE,
> -				      PAGE_SIZE);
> -	if (IS_ERR(ret)) {
> -		r = PTR_ERR(ret);
> -		goto out;
> -	}
> -
> -	kvm->arch.apic_access_memslot_enabled = true;
> -out:
> -	mutex_unlock(&kvm->slots_lock);
> -	return r;
> -}
> -
>  static int avic_init_backing_page(struct kvm_vcpu *vcpu)
>  {
>  	u64 *entry, new_entry;
> @@ -305,7 +272,13 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
>  	if (kvm_apicv_activated(vcpu->kvm)) {
>  		int ret;
>  
> -		ret = avic_alloc_access_page(vcpu->kvm);
> +		/*
> +		 * Note, AVIC hardware walks the nested page table to check
> +		 * permissions, but does not use the SPA address specified in
> +		 * the leaf SPTE since it uses address in the AVIC_BACKING_PAGE
> +		 * pointer field of the VMCB.
> +		 */
> +		ret = kvm_alloc_apic_access_page(vcpu->kvm);
>  		if (ret)
>  			return ret;
>  	}
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 9dba04b6b019..974d9a366d5d 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3771,39 +3771,6 @@ static void seg_setup(int seg)
>  	vmcs_write32(sf->ar_bytes, ar);
>  }
>  
> -static int alloc_apic_access_page(struct kvm *kvm)
> -{
> -	struct page *page;
> -	void __user *hva;
> -	int ret = 0;
> -
> -	mutex_lock(&kvm->slots_lock);
> -	if (kvm->arch.apic_access_memslot_enabled)
> -		goto out;
> -	hva = __x86_set_memory_region(kvm, APIC_ACCESS_PAGE_PRIVATE_MEMSLOT,
> -				      APIC_DEFAULT_PHYS_BASE, PAGE_SIZE);
> -	if (IS_ERR(hva)) {
> -		ret = PTR_ERR(hva);
> -		goto out;
> -	}
> -
> -	page = gfn_to_page(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
> -	if (is_error_page(page)) {
> -		ret = -EFAULT;
> -		goto out;
> -	}
> -
> -	/*
> -	 * Do not pin the page in memory, so that memory hot-unplug
> -	 * is able to migrate it.
> -	 */
> -	put_page(page);
> -	kvm->arch.apic_access_memslot_enabled = true;
> -out:
> -	mutex_unlock(&kvm->slots_lock);
> -	return ret;
> -}
> -
>  int allocate_vpid(void)
>  {
>  	int vpid;
> @@ -7348,7 +7315,7 @@ static int vmx_vcpu_create(struct kvm_vcpu *vcpu)
>  	vmx->loaded_vmcs = &vmx->vmcs01;
>  
>  	if (cpu_need_virtualize_apic_accesses(vcpu)) {
> -		err = alloc_apic_access_page(vcpu->kvm);
> +		err = kvm_alloc_apic_access_page(vcpu->kvm);
>  		if (err)
>  			goto free_vmcs;
>  	}


