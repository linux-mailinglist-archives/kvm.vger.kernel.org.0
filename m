Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A911A1680FF
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 15:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729020AbgBUO6z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 09:58:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42530 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728804AbgBUO6y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 09:58:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582297132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HSXfYy+h5IZVIkL8E7vA7JaHekCaaiTzIm2VED1D7A4=;
        b=U2edX0Xt2Wm0u9RW8VZcxDQULR9lL9wcIpmwh2NNolcLbnhNJGoYzc7LUic7CQXpuPo0t0
        a/gScUCQgg/YtKe/F27mtzTzJvPhzp9+SJHUOx9j8iDBwfUjv/TUodE/tPkCXkBSnJw9vm
        8axE24J34cUG8ajSELiIWQYvpcLyKmU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-WH0I8A_qP520L_22o3huVQ-1; Fri, 21 Feb 2020 09:58:50 -0500
X-MC-Unique: WH0I8A_qP520L_22o3huVQ-1
Received: by mail-wr1-f69.google.com with SMTP id n23so1114107wra.20
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2020 06:58:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=HSXfYy+h5IZVIkL8E7vA7JaHekCaaiTzIm2VED1D7A4=;
        b=iVHaSEzYH32C/1KF0Zpgfg3gT4AxKmtkfxaBgxQTT1C8g7Js5linwpOmNS2RPOwYJ0
         aHXIcgHlklX77hLWSnU1TalwlCu2f+DZT5RvNGbrZ+HXAq83vzdHIjtsn3nNDxLFiyuD
         6+J5zbSgjyOudGsq4aXRNyzMiJ4K0LCLcRFV6ib/rGmyw9EPldoRf1C8gHu6m0DSF8dT
         s5AxUo/diucitjzhGz/sprm3/xlQfqtLWwX/QEB6iXi+jDzLK5W5JC1ehpUEZMhhAqik
         GTEd/yOfPVXnnH6Ef0a1HhQ0YIr3xKnOF889VvPTxwxSGgyRGWa5vty8JVSol90vFqaA
         GiiQ==
X-Gm-Message-State: APjAAAXLuQBx3OkWu8wxUxVMrMWLH8KzeakXjmd+hjvhHcXoaknQuSxd
        zpDS1lLIfVJNcJinR70w1yUMev2d2ai0Y90fFj7zugp6d2A1fW25RSkMFV/VN01jaK6qf/SLvDC
        eZLAEsOTx4pXE
X-Received: by 2002:a05:6000:108b:: with SMTP id y11mr50422458wrw.187.1582297129490;
        Fri, 21 Feb 2020 06:58:49 -0800 (PST)
X-Google-Smtp-Source: APXvYqxmrBrCWXRD8lanjyB5jJehsVABDuykGdRMjmHFMXm1DHiLK5p9X9KQ2wwqh92AfZgidzDGpA==
X-Received: by 2002:a05:6000:108b:: with SMTP id y11mr50422442wrw.187.1582297129068;
        Fri, 21 Feb 2020 06:58:49 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id a16sm4351438wrx.87.2020.02.21.06.58.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 06:58:48 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/61] KVM: x86: Encapsulate CPUID entries and metadata in struct
In-Reply-To: <20200201185218.24473-17-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-17-sean.j.christopherson@intel.com>
Date:   Fri, 21 Feb 2020 15:58:47 +0100
Message-ID: <87y2swq95k.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Add a struct to hold the array of CPUID entries and its associated
> metadata when handling KVM_GET_SUPPORTED_CPUID.  Lookup and provide
> the correct entry in do_host_cpuid(), which eliminates the majority of
> array indexing shenanigans, e.g. entries[i -1], and generally makes the
> code more readable.  The last array indexing holdout is kvm_get_cpuid(),
> which can't really be avoided without throwing the baby out with the
> bathwater.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 138 ++++++++++++++++++++++++-------------------
>  1 file changed, 76 insertions(+), 62 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index d75d539da759..f9cfc69199f0 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -287,13 +287,21 @@ static __always_inline void cpuid_mask(u32 *word, int wordnum)
>  	*word &= boot_cpu_data.x86_capability[wordnum];
>  }
>  
> -static struct kvm_cpuid_entry2 *do_host_cpuid(struct kvm_cpuid_entry2 *entry,
> -					      int *nent, int maxnent,
> +struct kvm_cpuid_array {
> +	struct kvm_cpuid_entry2 *entries;
> +	const int maxnent;
> +	int nent;
> +};
> +
> +static struct kvm_cpuid_entry2 *do_host_cpuid(struct kvm_cpuid_array *array,
>  					      u32 function, u32 index)
>  {
> -	if (*nent >= maxnent)
> +	struct kvm_cpuid_entry2 *entry;
> +
> +	if (array->nent >= array->maxnent)
>  		return NULL;
> -	++*nent;
> +
> +	entry = &array->entries[array->nent++];
>  
>  	entry->function = function;
>  	entry->index = index;
> @@ -325,9 +333,10 @@ static struct kvm_cpuid_entry2 *do_host_cpuid(struct kvm_cpuid_entry2 *entry,
>  	return entry;
>  }
>  
> -static int __do_cpuid_func_emulated(struct kvm_cpuid_entry2 *entry,
> -				    u32 func, int *nent, int maxnent)
> +static int __do_cpuid_func_emulated(struct kvm_cpuid_array *array, u32 func)
>  {
> +	struct kvm_cpuid_entry2 *entry = &array->entries[array->nent];
> +
>  	entry->function = func;
>  	entry->index = 0;
>  	entry->flags = 0;
> @@ -335,17 +344,17 @@ static int __do_cpuid_func_emulated(struct kvm_cpuid_entry2 *entry,
>  	switch (func) {
>  	case 0:
>  		entry->eax = 7;
> -		++*nent;
> +		++array->nent;
>  		break;
>  	case 1:
>  		entry->ecx = F(MOVBE);
> -		++*nent;
> +		++array->nent;
>  		break;
>  	case 7:
>  		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
>  		entry->eax = 0;
>  		entry->ecx = F(RDPID);
> -		++*nent;
> +		++array->nent;
>  	default:
>  		break;
>  	}
> @@ -436,9 +445,9 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry)
>  	}
>  }
>  
> -static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
> -				  int *nent, int maxnent)
> +static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  {
> +	struct kvm_cpuid_entry2 *entry;
>  	int r, i, max_idx;
>  	unsigned f_nx = is_efer_nx() ? F(NX) : 0;
>  #ifdef CONFIG_X86_64
> @@ -514,7 +523,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>  
>  	r = -E2BIG;
>  
> -	if (WARN_ON(!do_host_cpuid(entry, nent, maxnent, function, 0)))
> +	entry = do_host_cpuid(array, function, 0);
> +	if (WARN_ON(!entry))
>  		goto out;
>  
>  	switch (function) {
> @@ -539,7 +549,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>  		entry->flags |= KVM_CPUID_FLAG_STATE_READ_NEXT;
>  
>  		for (i = 1, max_idx = entry->eax & 0xff; i < max_idx; ++i) {
> -			if (!do_host_cpuid(&entry[i], nent, maxnent, function, 0))
> +			entry = do_host_cpuid(array, 2, 0);

I'd change this to 
                        entry = do_host_cpuid(array, function, 0);

to match other call sites.

> +			if (!entry)
>  				goto out;
>  		}
>  		break;
> @@ -550,8 +561,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>  		 * Read entries until the cache type in the previous entry is
>  		 * zero, i.e. indicates an invalid entry.
>  		 */
> -		for (i = 1; entry[i - 1].eax & 0x1f; ++i) {
> -			if (!do_host_cpuid(&entry[i], nent, maxnent, function, i))
> +		for (i = 1; entry->eax & 0x1f; ++i) {
> +			entry = do_host_cpuid(array, function, i);
> +			if (!entry)
>  				goto out;
>  		}
>  		break;
> @@ -566,10 +578,11 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>  		do_cpuid_7_mask(entry);
>  
>  		for (i = 1, max_idx = entry->eax; i <= max_idx; i++) {
> -			if (!do_host_cpuid(&entry[i], nent, maxnent, function, i))
> +			entry = do_host_cpuid(array, function, i);
> +			if (!entry)
>  				goto out;
>  
> -			do_cpuid_7_mask(&entry[i]);
> +			do_cpuid_7_mask(entry);
>  		}
>  		break;
>  	case 9:
> @@ -610,15 +623,13 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>  	case 0x1f:
>  	case 0xb:
>  		/*
> -		 * We filled in entry[0] for CPUID(EAX=<function>,
> -		 * ECX=00H) above.  If its level type (ECX[15:8]) is
> -		 * zero, then the leaf is unimplemented, and we're
> -		 * done.  Otherwise, continue to populate entries
> -		 * until the level type (ECX[15:8]) of the previously
> -		 * added entry is zero.
> +		 * Populate entries until the level type (ECX[15:8]) of the
> +		 * previous entry is zero.  Note, CPUID EAX.{0x1f,0xb}.0 is
> +		 * the starting entry, filled by the primary do_host_cpuid().
>  		 */
> -		for (i = 1; entry[i - 1].ecx & 0xff00; ++i) {
> -			if (!do_host_cpuid(&entry[i], nent, maxnent, function, i))
> +		for (i = 1; entry->ecx & 0xff00; ++i) {
> +			entry = do_host_cpuid(array, function, i);
> +			if (!entry)
>  				goto out;
>  		}
>  		break;
> @@ -633,24 +644,26 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>  		if (!supported)
>  			break;
>  
> -		if (!do_host_cpuid(&entry[1], nent, maxnent, function, 1))
> +		entry = do_host_cpuid(array, function, 1);
> +		if (!entry)
>  			goto out;
>  
> -		entry[1].eax &= kvm_cpuid_D_1_eax_x86_features;
> -		cpuid_mask(&entry[1].eax, CPUID_D_1_EAX);
> -		if (entry[1].eax & (F(XSAVES)|F(XSAVEC)))
> -			entry[1].ebx = xstate_required_size(supported, true);
> +		entry->eax &= kvm_cpuid_D_1_eax_x86_features;
> +		cpuid_mask(&entry->eax, CPUID_D_1_EAX);
> +		if (entry->eax & (F(XSAVES)|F(XSAVEC)))
> +			entry->ebx = xstate_required_size(supported, true);
>  		else
> -			entry[1].ebx = 0;
> +			entry->ebx = 0;
>  		/* Saving XSS controlled state via XSAVES isn't supported. */
> -		entry[1].ecx = 0;
> -		entry[1].edx = 0;
> +		entry->ecx = 0;
> +		entry->edx = 0;
>  
> -		for (idx = 2, i = 2; idx < 64; ++idx) {
> +		for (idx = 2; idx < 64; ++idx) {
>  			if (!(supported & BIT_ULL(idx)))
>  				continue;
>  
> -			if (!do_host_cpuid(&entry[i], nent, maxnent, function, idx))
> +			entry = do_host_cpuid(array, function, idx);
> +			if (!entry)
>  				goto out;
>  
>  			/*
> @@ -660,14 +673,13 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>  			 * reach this point, and they should have a non-zero
>  			 * save state size.
>  			 */
> -			if (WARN_ON_ONCE(!entry[i].eax || (entry[i].ecx & 1))) {
> -				--*nent;
> +			if (WARN_ON_ONCE(!entry->eax || (entry->ecx & 1))) {
> +				--array->nent;
>  				continue;
>  			}
>  
> -			entry[i].ecx = 0;
> -			entry[i].edx = 0;
> -			++i;
> +			entry->ecx = 0;
> +			entry->edx = 0;
>  		}
>  		break;
>  	}
> @@ -677,7 +689,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>  			break;
>  
>  		for (i = 1, max_idx = entry->eax; i <= max_idx; ++i) {
> -			if (!do_host_cpuid(&entry[i], nent, maxnent, function, i))
> +			if (!do_host_cpuid(array, function, i))
>  				goto out;
>  		}
>  		break;
> @@ -802,22 +814,22 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>  	return r;
>  }
>  
> -static int do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 func,
> -			 int *nent, int maxnent, unsigned int type)
> +static int do_cpuid_func(struct kvm_cpuid_array *array, u32 func,
> +			 unsigned int type)
>  {
> -	if (*nent >= maxnent)
> +	if (array->nent >= array->maxnent)
>  		return -E2BIG;
>  
>  	if (type == KVM_GET_EMULATED_CPUID)
> -		return __do_cpuid_func_emulated(entry, func, nent, maxnent);
> +		return __do_cpuid_func_emulated(array, func);

Would it make sense to move 'if (array->nent >= array->maxnent)' check
to __do_cpuid_func_emulated() to match do_host_cpuid()?

>  
> -	return __do_cpuid_func(entry, func, nent, maxnent);
> +	return __do_cpuid_func(array, func);
>  }
>  
>  #define CENTAUR_CPUID_SIGNATURE 0xC0000000
>  
> -static int get_cpuid_func(struct kvm_cpuid_entry2 *entries, u32 func,
> -			  int *nent, int maxnent, unsigned int type)
> +static int get_cpuid_func(struct kvm_cpuid_array *array, u32 func,
> +			  unsigned int type)
>  {
>  	u32 limit;
>  	int r;
> @@ -826,16 +838,16 @@ static int get_cpuid_func(struct kvm_cpuid_entry2 *entries, u32 func,
>  	    boot_cpu_data.x86_vendor != X86_VENDOR_CENTAUR)
>  		return 0;
>  
> -	r = do_cpuid_func(&entries[*nent], func, nent, maxnent, type);
> +	r = do_cpuid_func(array, func, type);
>  	if (r)
>  		return r;
>  
> -	limit = entries[*nent - 1].eax;
> +	limit = array->entries[array->nent - 1].eax;
>  	for (func = func + 1; func <= limit; ++func) {
> -		if (*nent >= maxnent)
> +		if (array->nent >= array->maxnent)
>  			return -E2BIG;
>  
> -		r = do_cpuid_func(&entries[*nent], func, nent, maxnent, type);
> +		r = do_cpuid_func(array, func, type);


do_cpuid_func() above is already doing 'if (array->nent >=
array->maxnent)' check and returns -E2BIG when it fails, maybe the same
check here in get_cpuid_func() is not needed?

>  		if (r)
>  			break;
>  	}
> @@ -878,8 +890,11 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
>  		0, 0x80000000, CENTAUR_CPUID_SIGNATURE, KVM_CPUID_SIGNATURE,
>  	};
>  
> -	struct kvm_cpuid_entry2 *cpuid_entries;
> -	int nent = 0, r, i;
> +	struct kvm_cpuid_array array = {
> +		.nent = 0,
> +		.maxnent = cpuid->nent,
> +	};
> +	int r, i;
>  
>  	if (cpuid->nent < 1)
>  		return -E2BIG;
> @@ -889,25 +904,24 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
>  	if (sanity_check_entries(entries, cpuid->nent, type))
>  		return -EINVAL;
>  
> -	cpuid_entries = vzalloc(array_size(sizeof(struct kvm_cpuid_entry2),
> +	array.entries = vzalloc(array_size(sizeof(struct kvm_cpuid_entry2),
>  					   cpuid->nent));
> -	if (!cpuid_entries)
> +	if (!array.entries)
>  		return -ENOMEM;
>  
>  	for (i = 0; i < ARRAY_SIZE(funcs); i++) {
> -		r = get_cpuid_func(cpuid_entries, funcs[i], &nent, cpuid->nent,
> -				   type);
> +		r = get_cpuid_func(&array, funcs[i], type);
>  		if (r)
>  			goto out_free;
>  	}
> -	cpuid->nent = nent;
> +	cpuid->nent = array.nent;
>  
> -	if (copy_to_user(entries, cpuid_entries,
> -			 nent * sizeof(struct kvm_cpuid_entry2)))
> +	if (copy_to_user(entries, array.entries,
> +			 array.nent * sizeof(struct kvm_cpuid_entry2)))
>  		r = -EFAULT;
>  
>  out_free:
> -	vfree(cpuid_entries);
> +	vfree(array.entries);
>  	return r;
>  }

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

