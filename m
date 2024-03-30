Return-Path: <kvm+bounces-13154-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D639892D52
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 21:52:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 325E8282DEC
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 20:52:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4712A482D8;
	Sat, 30 Mar 2024 20:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GvQEOb9I"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A781119F
	for <kvm@vger.kernel.org>; Sat, 30 Mar 2024 20:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711831918; cv=none; b=E3Hpq0/3+LEqrHWKPxj6cBr8D5Ci58defHLZ/Ne4QaI3Iz6qEGx1PgrCv7hSfcDsLKgYNd4PobeEKR62wsfgFyDh0cdW0P0uWtAEx87GZEfScJIEgK1zEIBShgiM131m7WkwMEbSNFMrIro8kkkxlE8BF4m9OwmODHMC5JSqFcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711831918; c=relaxed/simple;
	bh=eo76hJ5KgggZKPYnrOo0bwJDa2FPFvtChdiC2X3NlIs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YFxoAWgnUCBSG6rOqCuPbsAtIGfzU9uxTIB4lfFVuPLgQqpFjBK7RrvClz7R6DPoVBA31HCDTMSa5f+USfYDgxeWdhWrOQrBIM623UQ1kahUKJiE2d/VazwfuIHP87/JOY/y/iTp0AwpCIY7zclUvKcM6Yaqo7yb+Fk5uHEer0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GvQEOb9I; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711831916;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OZ3Ciau6EpVtoog0PBxIAt4mBisJnFBL8QU+3ujOsIY=;
	b=GvQEOb9Inztvo8KFkcxl/+MZWVTYtDclyMRAeOoIW2WXZS7LdiFJWyiR7ItwkCI1GLxY8k
	6ErdHLBZeNToPzWKhfZXLJiELM0GbBUeeMKyoJHvzdpKFuElQkq4H/hkbLQoM0MdKcGQ3D
	fFwPWGRPPOBa6bVrJXsfFmCDOfmsqGM=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-43-yh9vNM9WOp2dVlZun9gJ2Q-1; Sat, 30 Mar 2024 16:51:53 -0400
X-MC-Unique: yh9vNM9WOp2dVlZun9gJ2Q-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a46852c2239so192215166b.1
        for <kvm@vger.kernel.org>; Sat, 30 Mar 2024 13:51:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711831912; x=1712436712;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OZ3Ciau6EpVtoog0PBxIAt4mBisJnFBL8QU+3ujOsIY=;
        b=N2l4UR7yDDh9qKVFdwNjIRR4hmcyCYamzGzreIGkxQkbjpbjLoxOb8vpLIOmZvWOyt
         +rvo8PK9o+VtDZtRHL9+RXDrhMox7uZDXLsGV5/cpgKn6XMSLpDV3GVY80/9L5jNIYRh
         Tdt31QDBXD+KU5nOUzYPUcUwpovgYB5Nc3B0rsFNSqEXKNo0h05kslvZ1d6EbBy81gds
         AH2oFT41Uh6OTBa3V5pbfVAjtCIEu2ZKFvFydfV4rScAsk5cog9rK5BjQHQeuQerhsg2
         wgmMMjXS5myrVh3xmxdJcAUb+c/nxbOP+10UMuFQHrFTOqSE5hHn7hbPIwbQaADDVdkC
         7eWw==
X-Forwarded-Encrypted: i=1; AJvYcCU+DHv9G71rixT+fhGsJUTcnO3Kg78R9kv8VSFfAXzK1p/u4KZ6M1PKcuz34BYqno5D1FF+/YbxzVo1DiiAUnEK5OKX
X-Gm-Message-State: AOJu0YxS68KzsjILnYDpy1w4160CQ1Dr2MBxFSo0fWzmkl97U/wkTGMS
	VdirJdua1uF25jTaZmiSAN0yPxhpDOyXdf8LCYSQg4MZKkk4OTz35fpM6ikuCBrdz7HNT97gs/n
	YgzskGkz81SlpCkvgYOoCzrq06kkTbBSISyqMflmYNao5wVgfhw==
X-Received: by 2002:a17:906:1253:b0:a4d:ff5f:98ad with SMTP id u19-20020a170906125300b00a4dff5f98admr3545171eja.37.1711831912737;
        Sat, 30 Mar 2024 13:51:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE01IT9TeNxfmx0zF5Xk6kwBCeppMFBPly3IZPz1shqv6ixk8RRaNFkk5C/OVE5TsIYrwjytA==
X-Received: by 2002:a17:906:1253:b0:a4d:ff5f:98ad with SMTP id u19-20020a170906125300b00a4dff5f98admr3545135eja.37.1711831912424;
        Sat, 30 Mar 2024 13:51:52 -0700 (PDT)
Received: from [192.168.10.4] ([151.95.49.219])
        by smtp.googlemail.com with ESMTPSA id z3-20020a170906714300b00a4650ec48d0sm3489665ejj.140.2024.03.30.13.51.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Mar 2024 13:51:51 -0700 (PDT)
Message-ID: <30c5f2f3-ff1e-4b0d-bb1f-eba95f578376@redhat.com>
Date: Sat, 30 Mar 2024 21:51:49 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 16/29] KVM: x86: Export the kvm_zap_gfn_range() for
 the SNP use
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
 thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, seanjc@google.com,
 vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
 dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
 peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
 rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
 vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
 tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
 alpergun@google.com, jarkko@kernel.org, ashish.kalra@amd.com,
 nikunj.dadhania@amd.com, pankaj.gupta@amd.com, liam.merwick@oracle.com,
 Brijesh Singh <brijesh.singh@amd.com>
References: <20240329225835.400662-1-michael.roth@amd.com>
 <20240329225835.400662-17-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240329225835.400662-17-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/29/24 23:58, Michael Roth wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> While resolving the RMP page fault, there may be cases where the page
> level between the RMP entry and TDP does not match and the 2M RMP entry
> must be split into 4K RMP entries. Or a 2M TDP page need to be broken
> into multiple of 4K pages.
> 
> To keep the RMP and TDP page level in sync, zap the gfn range after
> splitting the pages in the RMP entry. The zap should force the TDP to
> gets rebuilt with the new page level.

Just squash this in patch 17.

Paolo

> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>   arch/x86/include/asm/kvm_host.h | 1 +
>   arch/x86/kvm/mmu.h              | 2 --
>   arch/x86/kvm/mmu/mmu.c          | 1 +
>   3 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index a3f8eba8d8b6..49b294a8d917 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1950,6 +1950,7 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
>   				   const struct kvm_memory_slot *memslot);
>   void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen);
>   void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long kvm_nr_mmu_pages);
> +void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
>   
>   int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3);
>   
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 2c54ba5b0a28..89da37be241a 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -253,8 +253,6 @@ static inline bool kvm_mmu_honors_guest_mtrrs(struct kvm *kvm)
>   	return __kvm_mmu_honors_guest_mtrrs(kvm_arch_has_noncoherent_dma(kvm));
>   }
>   
> -void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
> -
>   int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
>   
>   int kvm_mmu_post_init_vm(struct kvm *kvm);
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 0049d49aa913..c5af52e3f0c5 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6772,6 +6772,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
>   
>   	return need_tlb_flush;
>   }
> +EXPORT_SYMBOL_GPL(kvm_zap_gfn_range);
>   
>   static void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
>   					   const struct kvm_memory_slot *slot)


