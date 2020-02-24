Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07E5016B3C7
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 23:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbgBXWVz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 17:21:55 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:52393 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726651AbgBXWVy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Feb 2020 17:21:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582582912;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MlgLBPA54fWuuAEYeFoGWhJfgNH9YMvWTW66al92frM=;
        b=MYtQrlRUvizHbecgkAINQfLBnbvTS4WwR9Zg5khkjAtYeWZDGXq6s3lLOJ+jqc9IDRMC7b
        0U1AgoPZzBbW+kzPei6gXWWCiZKDqCmJIHGhDuP4AOhrrsn1mxuqrr5OiydZrYwczclT7m
        dzEpNGReYmKHmwwwX+QMqJQq/bHlUZM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-372-rXTNEd17Oz2CQeb_lh9xfQ-1; Mon, 24 Feb 2020 17:21:50 -0500
X-MC-Unique: rXTNEd17Oz2CQeb_lh9xfQ-1
Received: by mail-wr1-f72.google.com with SMTP id s13so6242122wru.7
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2020 14:21:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=MlgLBPA54fWuuAEYeFoGWhJfgNH9YMvWTW66al92frM=;
        b=Oo8VUTk55gAeahsowFLy19hFrOyoL+XBEym0pl6IZpzStORa+njwpfrQiYxj9rcD75
         kkzSHgM/74rVCbf3kAeL0xArOhVD5xAjdZmckZpomguCKa96GmZjnqOLKUMN8B9wJJAt
         n8qc2OarM46IEIOf/bcxX1+4b8rzKYmYuejPcusa3YTHyNvIATgNUYIFIMrDN8UgSKsr
         t5dqAq6v5SL4a1yqP4E45VwY0UGUq2V2U1nVbM7Y9PKwhG1nCI5+kUwfBbCfEA2wSYze
         37BWMFDO8x7OG0c+FyJU08AZezUPx1OegdrSMuRWHxRAardoE/kQXtLaMTYiGstTltdk
         oeGQ==
X-Gm-Message-State: APjAAAXOn7RDdqSPYabOGrM+epHiAXrHVeDvAIOU7EgwNShDKKkpHhtZ
        5U7B0eilOkXn7oml+SgeVFd6lVJ6j1VfvSxltrhzr1Ji50FQwcIXd1THxpGOysQdBtFBxNocR/9
        Ac6njL+rRDQHR
X-Received: by 2002:a5d:55d2:: with SMTP id i18mr12087163wrw.287.1582582909000;
        Mon, 24 Feb 2020 14:21:49 -0800 (PST)
X-Google-Smtp-Source: APXvYqwv1OrYJptTCi459Nv4K1OBAqX8b1+jzsWwgqC+Y0BdxTs1+Ttq2a4ssxOPNtqrc/4OGz6Qyg==
X-Received: by 2002:a5d:55d2:: with SMTP id i18mr12087142wrw.287.1582582908750;
        Mon, 24 Feb 2020 14:21:48 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id p15sm1067820wma.40.2020.02.24.14.21.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 14:21:48 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 45/61] KVM: x86: Fold CPUID 0x7 masking back into __do_cpuid_func()
In-Reply-To: <20200201185218.24473-46-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-46-sean.j.christopherson@intel.com>
Date:   Mon, 24 Feb 2020 23:21:47 +0100
Message-ID: <87wo8bmxs4.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Move the CPUID 0x7 masking back into __do_cpuid_func() now that the
> size of the code has been trimmed down significantly.
>
> Tweak the WARN case, which is impossible to hit unless the CPU is
> completely broken, to break the loop before creating the bogus entry.
>
> Opportunustically reorder the cpuid_entry_set() calls and shorten the
> comment about emulation to further reduce the footprint of CPUID 0x7.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 62 ++++++++++++++++----------------------------
>  1 file changed, 22 insertions(+), 40 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 77a6c1db138d..7362e5238799 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -456,44 +456,6 @@ static int __do_cpuid_func_emulated(struct kvm_cpuid_array *array, u32 func)
>  	return 0;
>  }
>  
> -static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry)
> -{
> -	switch (entry->index) {
> -	case 0:
> -		entry->eax = min(entry->eax, 1u);
> -		cpuid_entry_mask(entry, CPUID_7_0_EBX);
> -		/* TSC_ADJUST is emulated */
> -		cpuid_entry_set(entry, X86_FEATURE_TSC_ADJUST);
> -		cpuid_entry_mask(entry, CPUID_7_ECX);
> -		cpuid_entry_mask(entry, CPUID_7_EDX);
> -		if (boot_cpu_has(X86_FEATURE_IBPB) && boot_cpu_has(X86_FEATURE_IBRS))
> -			cpuid_entry_set(entry, X86_FEATURE_SPEC_CTRL);
> -		if (boot_cpu_has(X86_FEATURE_STIBP))
> -			cpuid_entry_set(entry, X86_FEATURE_INTEL_STIBP);
> -		if (boot_cpu_has(X86_FEATURE_AMD_SSBD))
> -			cpuid_entry_set(entry, X86_FEATURE_SPEC_CTRL_SSBD);
> -		/*
> -		 * We emulate ARCH_CAPABILITIES in software even
> -		 * if the host doesn't support it.
> -		 */
> -		cpuid_entry_set(entry, X86_FEATURE_ARCH_CAPABILITIES);
> -		break;
> -	case 1:
> -		cpuid_entry_mask(entry, CPUID_7_1_EAX);
> -		entry->ebx = 0;
> -		entry->ecx = 0;
> -		entry->edx = 0;
> -		break;
> -	default:
> -		WARN_ON_ONCE(1);
> -		entry->eax = 0;
> -		entry->ebx = 0;
> -		entry->ecx = 0;
> -		entry->edx = 0;
> -		break;
> -	}
> -}
> -
>  static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  {
>  	struct kvm_cpuid_entry2 *entry;
> @@ -555,14 +517,34 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		break;
>  	/* function 7 has additional index. */
>  	case 7:
> -		do_cpuid_7_mask(entry);
> +		entry->eax = min(entry->eax, 1u);
> +		cpuid_entry_mask(entry, CPUID_7_0_EBX);
> +		cpuid_entry_mask(entry, CPUID_7_ECX);
> +		cpuid_entry_mask(entry, CPUID_7_EDX);
> +
> +		/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
> +		cpuid_entry_set(entry, X86_FEATURE_TSC_ADJUST);
> +		cpuid_entry_set(entry, X86_FEATURE_ARCH_CAPABILITIES);
> +
> +		if (boot_cpu_has(X86_FEATURE_IBPB) && boot_cpu_has(X86_FEATURE_IBRS))
> +			cpuid_entry_set(entry, X86_FEATURE_SPEC_CTRL);
> +		if (boot_cpu_has(X86_FEATURE_STIBP))
> +			cpuid_entry_set(entry, X86_FEATURE_INTEL_STIBP);
> +		if (boot_cpu_has(X86_FEATURE_AMD_SSBD))
> +			cpuid_entry_set(entry, X86_FEATURE_SPEC_CTRL_SSBD);
>  
>  		for (i = 1, max_idx = entry->eax; i <= max_idx; i++) {
> +			if (WARN_ON_ONCE(i > 1))
> +				break;
> +
>  			entry = do_host_cpuid(array, function, i);
>  			if (!entry)
>  				goto out;
>  
> -			do_cpuid_7_mask(entry);
> +			cpuid_entry_mask(entry, CPUID_7_1_EAX);
> +			entry->ebx = 0;
> +			entry->ecx = 0;
> +			entry->edx = 0;
>  		}
>  		break;
>  	case 9:

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

