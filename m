Return-Path: <kvm+bounces-26302-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3ADA4973D32
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 18:27:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0004128545A
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 16:27:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97A861A08A6;
	Tue, 10 Sep 2024 16:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WgErgIyO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C3B19D09E
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 16:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725985635; cv=none; b=t1kiuLITAK1KFlbQLDBrDkadBgndPZ3qroJANQxjVum4Ry5nXc1wzQfK9ZDA8FRS0/vC+AdPnfhxPK49Fh8TJP9Hs3yA7vfQAIE+9s/MHs8Z1MvKAFGJnTSCSihydH/k29l6dLMIu5Y1YCRN7EM2+U+1Bppik59+08+PdJX3Uso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725985635; c=relaxed/simple;
	bh=sNdM72VKfym5RvZv8miujIEtFB7ScTzofSuhGamnBY8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WM2FcMGXfO/+dow7EbfoJV3PDHVYsbe6llcCQDEWddXwdpmPf9Zh9t0P0OJZRk1mdWXCGkw4NRODxW8IjtYI1TX1vtsYyF0hf52ZcgPJmkshCL7tyGQRcH2oOp17N/B2MDSKzEzKE49yZb0Zvdr+NaYXmVpB/9RhkJeEMrSPPQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WgErgIyO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725985633;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/PjEl6mFJkuQW4vsqywuAqJOG8AiYKC0xgXwvl4ipkI=;
	b=WgErgIyOeRyWAuHzIfZ8Zw2QS0gS0anBC2dsqHUkTAbxRcmjCBIOx76mq2NK7ZQQVKu3ZI
	XCJXXkkTworBqsI6bkJ4At5DvfjRQrUoOPNCLXIA24xYEF/REmVDcU3/DDHpRNAExX92wi
	1IQLBLfJYpHBfq1Hv4szPqzIT1x6NDQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-677-AkVrX2ayMyWrYO2p68Be_Q-1; Tue, 10 Sep 2024 12:27:12 -0400
X-MC-Unique: AkVrX2ayMyWrYO2p68Be_Q-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-374c960ee7aso4220627f8f.3
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 09:27:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725985631; x=1726590431;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/PjEl6mFJkuQW4vsqywuAqJOG8AiYKC0xgXwvl4ipkI=;
        b=KeEM0iElfUr5zIyT7zh+nXweeVb3bsQ9D8kFilhwrZgw4b4b8FMAUvGFC6sdoEadMC
         j7bpnCAR5K529e+Bc+ulIzj8uGORQkR1dsJd7vic+1DXikhK8GmMVhseI/VIj8D+3GYT
         nGTZpZaZKf5dxeLXhdaVMY1SBBalHyMUtUydtCE8+krBYoE5JdQXC6jkX8N+Yg9I6grv
         fq2wBOk503x014c3Y8BUI1KkUg5Aj5id1EXW5IxRP9Qu109BGFLmyTmj19LeoKC1cOHB
         1E5ZYpzhwjRmXZZ//ljRfM5koO6d1SKrzRZxCd2dGdYVj+GCbq8+EufLmbZ+IsXTRvgL
         ArDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXMmYsmK6WJ+aS4x/4R+TJRVKeDB7fpU2Qk7/Deskcb7UNCAgBxu8+qe04sKb/Y5L5ki6A=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGWpDgwMyM/phvf2lrrtQtk8Xy4UQBKEU+c9HI4FEjCRCsTBVy
	LywbNH7QyyqA1Efcx5phayg5TLqCigt1AV0/OfJYafEwIa+HmUA81+CBkyTzHuQxV7MV8Mg9Goe
	9x4MONC/j5WSLAZn+Ws1xq0VxHo57NhM6NzdfgEONyawhHvxjxQ==
X-Received: by 2002:adf:cc91:0:b0:374:c658:706e with SMTP id ffacd0b85a97d-3789243fb15mr10292582f8f.39.1725985630713;
        Tue, 10 Sep 2024 09:27:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEstKZAyuSuTiS5trq8tzmNOO85qmHw5bCd6iDNwzdmjW8pWpNOoAENbTQ05p71domucqjKiA==
X-Received: by 2002:adf:cc91:0:b0:374:c658:706e with SMTP id ffacd0b85a97d-3789243fb15mr10292556f8f.39.1725985630171;
        Tue, 10 Sep 2024 09:27:10 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-378956761c6sm9410580f8f.61.2024.09.10.09.27.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 09:27:09 -0700 (PDT)
Message-ID: <661e790f-7ed8-46ce-9f7c-9776de7127a8@redhat.com>
Date: Tue, 10 Sep 2024 18:27:08 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/25] KVM: TDX: Add helper functions to allocate/free TDX
 private host key id
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 kvm@vger.kernel.org
Cc: kai.huang@intel.com, isaku.yamahata@gmail.com,
 tony.lindgren@linux.intel.com, xiaoyao.li@intel.com,
 linux-kernel@vger.kernel.org, Isaku Yamahata <isaku.yamahata@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-8-rick.p.edgecombe@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240812224820.34826-8-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/13/24 00:48, Rick Edgecombe wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Add helper functions to allocate/free TDX private host key id (HKID).
> 
> The memory controller encrypts TDX memory with the assigned HKIDs. Each TDX
> guest must be protected by its own unique TDX HKID.
> 
> The HW has a fixed set of these HKID keys. Out of those, some are set aside
> for use by for other TDX components, but most are saved for guest use. The
> code that does this partitioning, records the range chosen to be available
> for guest use in the tdx_guest_keyid_start and tdx_nr_guest_keyids
> variables.
> 
> Use this range of HKIDs reserved for guest use with the kernel's IDA
> allocator library helper to create a mini TDX HKID allocator that can be
> called when setting up a TD. This way it can have an exclusive HKID, as is
> required. This allocator will be used in future changes.

This is basically what Dave was asking for, isn't it?

Paolo

> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> uAPI breakout v1:
>   - Update the commit message
>   - Delete stale comment on global hkdi
>   - Deleted WARN_ON_ONCE() as it doesn't seemed very usefull
> 
> v19:
>   - Removed stale comment in tdx_guest_keyid_alloc() by Binbin
>   - Update sanity check in tdx_guest_keyid_free() by Binbin
> 
> v18:
>   - Moved the functions to kvm tdx from arch/x86/virt/vmx/tdx/
>   - Drop exporting symbols as the host tdx does.
> ---
>   arch/x86/kvm/vmx/tdx.c | 15 +++++++++++++++
>   1 file changed, 15 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index dbcc1ed80efa..b1c885ce8c9c 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -14,6 +14,21 @@ static enum cpuhp_state tdx_cpuhp_state;
>   
>   static const struct tdx_sysinfo *tdx_sysinfo;
>   
> +/* TDX KeyID pool */
> +static DEFINE_IDA(tdx_guest_keyid_pool);
> +
> +static int __used tdx_guest_keyid_alloc(void)
> +{
> +	return ida_alloc_range(&tdx_guest_keyid_pool, tdx_guest_keyid_start,
> +			       tdx_guest_keyid_start + tdx_nr_guest_keyids - 1,
> +			       GFP_KERNEL);
> +}
> +
> +static void __used tdx_guest_keyid_free(int keyid)
> +{
> +	ida_free(&tdx_guest_keyid_pool, keyid);
> +}
> +
>   static int tdx_online_cpu(unsigned int cpu)
>   {
>   	unsigned long flags;


