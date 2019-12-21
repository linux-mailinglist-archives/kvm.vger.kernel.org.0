Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCF96128942
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2019 14:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbfLUNwB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 Dec 2019 08:52:01 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37405 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726363AbfLUNwB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 Dec 2019 08:52:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576936319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ou/s/3Qi+KNTbaTCh/HiHAyd6BgLstj9qp6oblRG7Vk=;
        b=KwNDPr0hPqmLW13abf6WJS2yD9GGoxppOkrkcLAzg/8ButfB1OyD/tT6NcA6jq1z6oTNtv
        lxKoNxHk7T8rJWbHRXfENAZzPNUMtZh4SWKCp5dNV7W/ZoxLLPEiUsSXqiVt7fGAzLDC30
        bmrlsHEU4xUy+8t5WUXiAXdhPk8BR7M=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-76-B4nWgbJ1MauXK2E7Td_HDg-1; Sat, 21 Dec 2019 08:51:52 -0500
X-MC-Unique: B4nWgbJ1MauXK2E7Td_HDg-1
Received: by mail-wr1-f70.google.com with SMTP id j13so5220536wrr.20
        for <kvm@vger.kernel.org>; Sat, 21 Dec 2019 05:51:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ou/s/3Qi+KNTbaTCh/HiHAyd6BgLstj9qp6oblRG7Vk=;
        b=hc9PzI8ZaEEurl0KezcXFND3M5DPz5i1KsA82v/qSHAaGD1G68SUb03Hj7Hv2DoGo0
         fzHkxn3V0je93uh6fUXQo9tPLdrsvNnWXxoo96bRU+fRJSrfFUinOjCD1vvmL7roStat
         8fMsTCFFLYl2xDpoME5HTOrOMfn8qg+MmgV2haAnJQvt53XkuX2znAGRDFemdFxsQYyj
         OnsVc8WmgtCLsvhTgq611q+1mITpttEscZ9W/Ys3XK6Ul2X9COD7jnRAwFMm6W2nTc2X
         fPwrTQdV1JSchUtPGix/HPtS6g3+t0b9/i8FemCxY0sEGAg8RqG2QOWuhB2wUnLXpOsx
         Lk5Q==
X-Gm-Message-State: APjAAAXL34CACJ9dyqB1ekz0v88VphaINUfHe7LX7NsX5UZ3njUwFFbQ
        D+S5YxLitWkQ9R9IN4N7zg73gRYaPG88rxCkvtwSeyHyMFqfntOzr8KZt0Q6t4PC1CJRExlJtzp
        g/M+EgiVS3C8J
X-Received: by 2002:adf:d850:: with SMTP id k16mr19969152wrl.96.1576936311105;
        Sat, 21 Dec 2019 05:51:51 -0800 (PST)
X-Google-Smtp-Source: APXvYqxqgVwhREg2pxtdFbb+1WRH4sxeJtd0PcROh33qc36OVxJl32z4p4V+j8+mIOql2dt6TCOdeg==
X-Received: by 2002:adf:d850:: with SMTP id k16mr19969133wrl.96.1576936310808;
        Sat, 21 Dec 2019 05:51:50 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:ac09:bce1:1c26:264c? ([2001:b07:6468:f312:ac09:bce1:1c26:264c])
        by smtp.gmail.com with ESMTPSA id w20sm13260670wmk.34.2019.12.21.05.51.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Dec 2019 05:51:50 -0800 (PST)
Subject: Re: [PATCH RESEND v2 03/17] KVM: X86: Don't track dirty for
 KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]
To:     Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20191221014938.58831-1-peterx@redhat.com>
 <20191221014938.58831-4-peterx@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cf232ce8-bc07-0192-580f-d08736980273@redhat.com>
Date:   Sat, 21 Dec 2019 14:51:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191221014938.58831-4-peterx@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/12/19 02:49, Peter Xu wrote:
> Originally, we have three code paths that can dirty a page without
> vcpu context for X86:
> 
>   - init_rmode_identity_map
>   - init_rmode_tss
>   - kvmgt_rw_gpa
> 
> init_rmode_identity_map and init_rmode_tss will be setup on
> destination VM no matter what (and the guest cannot even see them), so
> it does not make sense to track them at all.
> 
> To do this, a new parameter is added to kvm_[write|clear]_guest_page()
> to show whether we would like to track dirty bits for the operations.
> With that, pass in "false" to this new parameter for any guest memory
> write of the ioctls (KVM_SET_TSS_ADDR, KVM_SET_IDENTITY_MAP_ADDR).

We can also return the hva from x86_set_memory_region and
__x86_set_memory_region.

Paolo

> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c   | 18 ++++++++++--------
>  include/linux/kvm_host.h |  5 +++--
>  virt/kvm/kvm_main.c      | 25 ++++++++++++++++---------
>  3 files changed, 29 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 04a8212704c1..1ff5a428f489 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3452,24 +3452,24 @@ static int init_rmode_tss(struct kvm *kvm)
>  
>  	idx = srcu_read_lock(&kvm->srcu);
>  	fn = to_kvm_vmx(kvm)->tss_addr >> PAGE_SHIFT;
> -	r = kvm_clear_guest_page(kvm, fn, 0, PAGE_SIZE);
> +	r = kvm_clear_guest_page(kvm, fn, 0, PAGE_SIZE, false);
>  	if (r < 0)
>  		goto out;
>  	data = TSS_BASE_SIZE + TSS_REDIRECTION_SIZE;
>  	r = kvm_write_guest_page(kvm, fn++, &data,
> -			TSS_IOPB_BASE_OFFSET, sizeof(u16));
> +				 TSS_IOPB_BASE_OFFSET, sizeof(u16), false);
>  	if (r < 0)
>  		goto out;
> -	r = kvm_clear_guest_page(kvm, fn++, 0, PAGE_SIZE);
> +	r = kvm_clear_guest_page(kvm, fn++, 0, PAGE_SIZE, false);
>  	if (r < 0)
>  		goto out;
> -	r = kvm_clear_guest_page(kvm, fn, 0, PAGE_SIZE);
> +	r = kvm_clear_guest_page(kvm, fn, 0, PAGE_SIZE, false);
>  	if (r < 0)
>  		goto out;
>  	data = ~0;
>  	r = kvm_write_guest_page(kvm, fn, &data,
>  				 RMODE_TSS_SIZE - 2 * PAGE_SIZE - 1,
> -				 sizeof(u8));
> +				 sizeof(u8), false);
>  out:
>  	srcu_read_unlock(&kvm->srcu, idx);
>  	return r;
> @@ -3498,7 +3498,7 @@ static int init_rmode_identity_map(struct kvm *kvm)
>  		goto out2;
>  
>  	idx = srcu_read_lock(&kvm->srcu);
> -	r = kvm_clear_guest_page(kvm, identity_map_pfn, 0, PAGE_SIZE);
> +	r = kvm_clear_guest_page(kvm, identity_map_pfn, 0, PAGE_SIZE, false);
>  	if (r < 0)
>  		goto out;
>  	/* Set up identity-mapping pagetable for EPT in real mode */
> @@ -3506,7 +3506,8 @@ static int init_rmode_identity_map(struct kvm *kvm)
>  		tmp = (i << 22) + (_PAGE_PRESENT | _PAGE_RW | _PAGE_USER |
>  			_PAGE_ACCESSED | _PAGE_DIRTY | _PAGE_PSE);
>  		r = kvm_write_guest_page(kvm, identity_map_pfn,
> -				&tmp, i * sizeof(tmp), sizeof(tmp));
> +					 &tmp, i * sizeof(tmp),
> +					 sizeof(tmp), false);
>  		if (r < 0)
>  			goto out;
>  	}
> @@ -7265,7 +7266,8 @@ static int vmx_write_pml_buffer(struct kvm_vcpu *vcpu)
>  		dst = vmcs12->pml_address + sizeof(u64) * vmcs12->guest_pml_index;
>  
>  		if (kvm_write_guest_page(vcpu->kvm, gpa_to_gfn(dst), &gpa,
> -					 offset_in_page(dst), sizeof(gpa)))
> +					 offset_in_page(dst), sizeof(gpa),
> +					 false))
>  			return 0;
>  
>  		vmcs12->guest_pml_index--;
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 2ea1ea79befd..4e34cf97ca90 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -734,7 +734,7 @@ int kvm_read_guest(struct kvm *kvm, gpa_t gpa, void *data, unsigned long len);
>  int kvm_read_guest_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
>  			   void *data, unsigned long len);
>  int kvm_write_guest_page(struct kvm *kvm, gfn_t gfn, const void *data,
> -			 int offset, int len);
> +			 int offset, int len, bool track_dirty);
>  int kvm_write_guest(struct kvm *kvm, gpa_t gpa, const void *data,
>  		    unsigned long len);
>  int kvm_write_guest_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
> @@ -744,7 +744,8 @@ int kvm_write_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
>  				  unsigned long len);
>  int kvm_gfn_to_hva_cache_init(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
>  			      gpa_t gpa, unsigned long len);
> -int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len);
> +int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len,
> +			 bool track_dirty);
>  int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len);
>  struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
>  bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 7ee28af9eb48..b1047173d78e 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2051,7 +2051,8 @@ int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa,
>  EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
>  
>  static int __kvm_write_guest_page(struct kvm_memory_slot *memslot, gfn_t gfn,
> -			          const void *data, int offset, int len)
> +			          const void *data, int offset, int len,
> +				  bool track_dirty)
>  {
>  	int r;
>  	unsigned long addr;
> @@ -2062,16 +2063,19 @@ static int __kvm_write_guest_page(struct kvm_memory_slot *memslot, gfn_t gfn,
>  	r = __copy_to_user((void __user *)addr + offset, data, len);
>  	if (r)
>  		return -EFAULT;
> -	mark_page_dirty_in_slot(memslot, gfn);
> +	if (track_dirty)
> +		mark_page_dirty_in_slot(memslot, gfn);
>  	return 0;
>  }
>  
>  int kvm_write_guest_page(struct kvm *kvm, gfn_t gfn,
> -			 const void *data, int offset, int len)
> +			 const void *data, int offset, int len,
> +			 bool track_dirty)
>  {
>  	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
>  
> -	return __kvm_write_guest_page(slot, gfn, data, offset, len);
> +	return __kvm_write_guest_page(slot, gfn, data, offset, len,
> +				      track_dirty);
>  }
>  EXPORT_SYMBOL_GPL(kvm_write_guest_page);
>  
> @@ -2080,7 +2084,8 @@ int kvm_vcpu_write_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn,
>  {
>  	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
>  
> -	return __kvm_write_guest_page(slot, gfn, data, offset, len);
> +	return __kvm_write_guest_page(slot, gfn, data, offset,
> +				      len, true);
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_write_guest_page);
>  
> @@ -2093,7 +2098,7 @@ int kvm_write_guest(struct kvm *kvm, gpa_t gpa, const void *data,
>  	int ret;
>  
>  	while ((seg = next_segment(len, offset)) != 0) {
> -		ret = kvm_write_guest_page(kvm, gfn, data, offset, seg);
> +		ret = kvm_write_guest_page(kvm, gfn, data, offset, seg, true);
>  		if (ret < 0)
>  			return ret;
>  		offset = 0;
> @@ -2232,11 +2237,13 @@ int kvm_read_guest_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
>  }
>  EXPORT_SYMBOL_GPL(kvm_read_guest_cached);
>  
> -int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len)
> +int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len,
> +			 bool track_dirty)
>  {
>  	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
>  
> -	return kvm_write_guest_page(kvm, gfn, zero_page, offset, len);
> +	return kvm_write_guest_page(kvm, gfn, zero_page, offset, len,
> +				    track_dirty);
>  }
>  EXPORT_SYMBOL_GPL(kvm_clear_guest_page);
>  
> @@ -2248,7 +2255,7 @@ int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len)
>  	int ret;
>  
>  	while ((seg = next_segment(len, offset)) != 0) {
> -		ret = kvm_clear_guest_page(kvm, gfn, offset, seg);
> +		ret = kvm_clear_guest_page(kvm, gfn, offset, seg, true);
>  		if (ret < 0)
>  			return ret;
>  		offset = 0;
> 

