Return-Path: <kvm+bounces-16900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87A1E8BEACC
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 19:48:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A213285932
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 17:48:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1641416C871;
	Tue,  7 May 2024 17:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E16icK21"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3BF616C695
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 17:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715104104; cv=none; b=RY/pBeE77T89O/rdkfpoC4uuT3TPXkQGLYggxVxqT3pFmfgQw9tzjkbtvBDoWqj+m0Pl7BThc0UTc2i4/fmBAfW8bBNCbB1VM2cpp0MbCGbOwFDS+AE+Vzu4gb4Y45MFCZqnR+k3lb68knHETzA5ymEbe1A+ttrnTyw28uo3CR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715104104; c=relaxed/simple;
	bh=G4sKnEbJdMGDqqOOZcGjKlz86s6SEc8Aai9Vaa1zX6Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P2Ix3WVqriC1OnUBBX1h4CaktK3PiatjzFfNRfrrZXVCrzhxzj8d/34Q9fqNRm7BGXPq1y7S9pQ/mZ6nV5gK3G/9dIokRyFrdmhP835N98x2icKD3i/ll3TKopf9dAbCB3bmTmgsFZ6O7KwcZCon4OgOmijcKzfv2jkBlL1SKBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E16icK21; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715104101;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=U7NSWv2sngdGccyzHhW9zKoCfPe+XKegdqJlyPFodbI=;
	b=E16icK2184rGoPWH2bEBWPXJZtGGn9IuSbomFmgWyhqqa1ruGKqhGhtqOmdBud9HvxmNF8
	k+VmqjaN1GCvbVHjRurw9a5R6X8ORqMflupozOg9FWcquJGX2GuADfbdyV2D6n3le9qlAy
	7cR7RWsjIaPqUqnhqUs2tSPvXoMUcDw=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-WCOJ_ZIiNM2-vtUHt_EFag-1; Tue, 07 May 2024 13:48:19 -0400
X-MC-Unique: WCOJ_ZIiNM2-vtUHt_EFag-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-5729fd97df9so1302578a12.1
        for <kvm@vger.kernel.org>; Tue, 07 May 2024 10:48:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715104098; x=1715708898;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U7NSWv2sngdGccyzHhW9zKoCfPe+XKegdqJlyPFodbI=;
        b=XFnnesR/dxc6EtnDPRhbArOayK5jo+ZK5OtHhIvX2uJZVQaNwodDiMU+lN2jGzyepX
         ZW+37fasHncKTcXtrLE8PLRbwqd+L5dIUBJCZSobiHa7+J9xN2mobYvXT14cNTioRBrh
         zE7FTJdSbijVCMSNKej6lzpc9tEck7NDcDHkase5dl8QmH5juUAAo+JY3wWxXjo3Mpoo
         efxRd8X1qpvC9DzudnccibP9LRJUt1JQgk89mG5Euz9NzH8Ez+OX0K03sNHEnIqogtdq
         +uS+DUDS/9tIoi8dZQSyh6GrUr+zwWcO+sOR1KlX1nf5yvBZDsi56H3/smtLMCL/97Jt
         20Cg==
X-Forwarded-Encrypted: i=1; AJvYcCXj6Rm4wjmbnhLRFDH+fUSk02UnkEtcKymq/UoFZWwKumGC2mNfde5qTUngyW5kfqTY5GXLIKXYQ/5jL/VtHym5tGtJ
X-Gm-Message-State: AOJu0YyvB1aFXcyEh32aEof5m7a5kGXoisBrnKrRaTiDX20kET2PpeQf
	BRKwB6OYIEDYkjWZNjFnCEj0CwD13t6O6kw1lm+OXB7q66e8pG9ya9gaSZIcaNTMgAh1lKXQyzv
	o/8ReEYaAFNUTef8OKJ/88JJxwt6pk///CayC2UI/fmcoRgko2Q==
X-Received: by 2002:a50:8ac8:0:b0:572:9d8a:20f4 with SMTP id 4fb4d7f45d1cf-5731da81922mr272388a12.32.1715104098650;
        Tue, 07 May 2024 10:48:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHWO0ZFjdL3U8Z+4qw3ObkPaduqAGsZ1NMcH6woNnJqGwZdQRg/xxY47WaZMcri4ZL0ky7IXA==
X-Received: by 2002:a50:8ac8:0:b0:572:9d8a:20f4 with SMTP id 4fb4d7f45d1cf-5731da81922mr272359a12.32.1715104098236;
        Tue, 07 May 2024 10:48:18 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.155.52])
        by smtp.googlemail.com with ESMTPSA id b14-20020a0564021f0e00b00572cebc5f32sm5776641edb.65.2024.05.07.10.48.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 May 2024 10:48:17 -0700 (PDT)
Message-ID: <044e8953-56f0-405e-9b50-7dde4ca8986b@redhat.com>
Date: Tue, 7 May 2024 19:48:15 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 02/20] KVM: x86: Add hook for determining max NPT
 mapping level
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
 nikunj.dadhania@amd.com, pankaj.gupta@amd.com, liam.merwick@oracle.com
References: <20240501085210.2213060-1-michael.roth@amd.com>
 <20240501085210.2213060-3-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240501085210.2213060-3-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/1/24 10:51, Michael Roth wrote:
> In the case of SEV-SNP, whether or not a 2MB page can be mapped via a
> 2MB mapping in the guest's nested page table depends on whether or not
> any subpages within the range have already been initialized as private
> in the RMP table. The existing mixed-attribute tracking in KVM is
> insufficient here, for instance:
> 
> - gmem allocates 2MB page
> - guest issues PVALIDATE on 2MB page
> - guest later converts a subpage to shared
> - SNP host code issues PSMASH to split 2MB RMP mapping to 4K
> - KVM MMU splits NPT mapping to 4K
> - guest later converts that shared page back to private
> 
> At this point there are no mixed attributes, and KVM would normally
> allow for 2MB NPT mappings again, but this is actually not allowed
> because the RMP table mappings are 4K and cannot be promoted on the
> hypervisor side, so the NPT mappings must still be limited to 4K to
> match this.
> 
> Add a hook to determine the max NPT mapping size in situations like
> this.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>   arch/x86/include/asm/kvm-x86-ops.h |  1 +
>   arch/x86/include/asm/kvm_host.h    |  1 +
>   arch/x86/kvm/mmu/mmu.c             | 18 ++++++++++++++++--
>   3 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index c81990937ab4..566d19b02483 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -140,6 +140,7 @@ KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
>   KVM_X86_OP_OPTIONAL(get_untagged_addr)
>   KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
>   KVM_X86_OP_OPTIONAL_RET0(gmem_prepare)
> +KVM_X86_OP_OPTIONAL_RET0(private_max_mapping_level)
>   KVM_X86_OP_OPTIONAL(gmem_invalidate)
>   
>   #undef KVM_X86_OP
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index c6c5018376be..87265b73906a 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1816,6 +1816,7 @@ struct kvm_x86_ops {
>   	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
>   	int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
>   	void (*gmem_invalidate)(kvm_pfn_t start, kvm_pfn_t end);
> +	int (*private_max_mapping_level)(struct kvm *kvm, kvm_pfn_t pfn);
>   };
>   
>   struct kvm_x86_nested_ops {
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 510eb1117012..0d556da052f6 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4271,6 +4271,20 @@ static inline u8 kvm_max_level_for_order(int order)
>   	return PG_LEVEL_4K;
>   }
>   
> +static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
> +					u8 max_level, int gmem_order)
> +{
> +	if (max_level == PG_LEVEL_4K)
> +		return PG_LEVEL_4K;
> +
> +	max_level = min(kvm_max_level_for_order(gmem_order), max_level);
> +	if (max_level == PG_LEVEL_4K)
> +		return PG_LEVEL_4K;
> +
> +	return min(max_level,
> +		   static_call(kvm_x86_private_max_mapping_level)(kvm, pfn));
> +}

Since you're returning 0 both as a default and, later in the series, for non-SNP guests, you need to treat 0 as "don't care":

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index de35dee25bf6..62ad38b2a8c9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4274,6 +4274,8 @@ static inline u8 kvm_max_level_for_order(int order)
  static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
  					u8 max_level, int gmem_order)
  {
+	u8 req_max_level;
+
  	if (max_level == PG_LEVEL_4K)
  		return PG_LEVEL_4K;
  
@@ -4281,8 +4283,11 @@ static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
  	if (max_level == PG_LEVEL_4K)
  		return PG_LEVEL_4K;
  
-	return min(max_level,
-		   static_call(kvm_x86_private_max_mapping_level)(kvm, pfn));
+	req_max_level = static_call(kvm_x86_private_max_mapping_level)(kvm, pfn);
+	if (req_max_level)
+		max_level = min(max_level, req_max_level);
+
+	return req_max_level;
  }
  
  static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,


Not beautiful but it does the job I guess.

Paolo


