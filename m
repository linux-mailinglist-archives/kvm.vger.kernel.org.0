Return-Path: <kvm+bounces-21006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A50AF92804F
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 04:19:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5CD28285FE3
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 02:19:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8552817571;
	Fri,  5 Jul 2024 02:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WrV/9Unb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4172E1D559
	for <kvm@vger.kernel.org>; Fri,  5 Jul 2024 02:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720145928; cv=none; b=u9tjFskz8xfDQTtni9WzKfhmtFmtKs+yN0lDrjyzyLuZQJpHTmNj+vKVeyRgQxDiZnEaGy0NirjlvAb/HQkKEQ3mYb/GR2ryevn3pBD+9EtDtrHqtxu3xEqIR6kXKPSKVHsXAIcMr2heymBO/BoLgQgx8VIAvgE4VqYQHf2N0pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720145928; c=relaxed/simple;
	bh=+2wqG4NpFMDYnBYgfaNisaUfobnUBeKE5vgJSPAusHo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Fqg69I8rxLcDanNgPU6AwhEikGtkIX/zUlvebqyMHjO8uCvRyHAK+R/LRxOaRYYVzeG3KQZkTOgXGf+TIETZrws/yAoQsVPRoK0qx1VNrRsWbwQpuwTobB75oVsMwWG57UnPB24I3176Ii7bbvX0+9r4p5DQx6FaGu4RH+MafbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WrV/9Unb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720145926;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CeU5ZXdnFTjQ32AowEM/69JBo6FJECNkW/27K06LO5g=;
	b=WrV/9UnblyCYz0uKebij8j2W8d2S5o/DyYOyCnJscoq+C9n/+QpPd3wbe8h9soTFeayZeB
	vZvsiXbkMf8HOlGtViBKzCO31Pe/V+G+Ih89SKpsWgUL7Avkd3A+UtJqO1BkhYcE5qyA+W
	JFpTDPnSI6zgCSpc9tTY+6FbZkrp6uY=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-122-Y63I6oZoOW-EeeQB-nMbJw-1; Thu, 04 Jul 2024 22:18:44 -0400
X-MC-Unique: Y63I6oZoOW-EeeQB-nMbJw-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-79d7db4f62cso156438685a.3
        for <kvm@vger.kernel.org>; Thu, 04 Jul 2024 19:18:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720145924; x=1720750724;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CeU5ZXdnFTjQ32AowEM/69JBo6FJECNkW/27K06LO5g=;
        b=B3c+ptPNOs+S0/wVHwVaxjdNR4KXgmj5GXjECG5rh/cE7+62N50qfGxsb92Lcmyda4
         Cz/kFB3UYhIgrB2ODQgOCl702LvbXR1jAT6bCsNqvMo36wd2G0WzTYyvD3i/c9hIhEak
         NBJ0ZxxF3+fzuqvHhfUz1ysMxoJTvcR7mx3LILg5y6ncC9p5KyiAILMWehTonI/SA6Fq
         iSlUukUPolscYft2Lphvknaezu+C3Nu2UjvGjEzxlVk/Q7yVs9nfq7cj4uNIc3hNVcDF
         hbCAkYqPwtaRojCgtH4j/SincSOs3of8nWfpkl2fdB1JymouM9b09xOAPKDvq4ZeAM6P
         W4kA==
X-Gm-Message-State: AOJu0YxrewoH7P/ZAI1mj86WMApM++KOxyyMY9oofqivaoiAYuLGWQQS
	jJB7bmSTOLhyCaVBOfKK2eFzp9lWoDODETC9WfFE4RoB2Q3n/OuDqylPCdEYkvqFmee4dRBcTNT
	TJJNjGKL+3Cu3SaA2WsL2Ng4rFHEBkVMGPZ9AG20iwMPX7gUh8Q==
X-Received: by 2002:a37:de0e:0:b0:79d:7777:1f52 with SMTP id af79cd13be357-79eee29b370mr374054185a.64.1720145924382;
        Thu, 04 Jul 2024 19:18:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGSh7GgWJ6tVdavrY330ke3bIne4kuWLkPjC14UYb6bOIadTXYbZtwdARpKCh9EG9fERVdN/g==
X-Received: by 2002:a37:de0e:0:b0:79d:7777:1f52 with SMTP id af79cd13be357-79eee29b370mr374052485a.64.1720145924016;
        Thu, 04 Jul 2024 19:18:44 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:7b7f:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79ee5970614sm206009885a.2.2024.07.04.19.18.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 19:18:43 -0700 (PDT)
Message-ID: <960ef7f670c264824fe43b87b8177a84640b8b5d.camel@redhat.com>
Subject: Re: [PATCH v2 39/49] KVM: x86: Extract code for generating
 per-entry emulated CPUID information
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Hou Wenlong
 <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, Oliver Upton
 <oliver.upton@linux.dev>, Binbin Wu <binbin.wu@linux.intel.com>, Yang
 Weijiang <weijiang.yang@intel.com>, Robert Hoo <robert.hoo.linux@gmail.com>
Date: Thu, 04 Jul 2024 22:18:42 -0400
In-Reply-To: <20240517173926.965351-40-seanjc@google.com>
References: <20240517173926.965351-1-seanjc@google.com>
	 <20240517173926.965351-40-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2024-05-17 at 10:39 -0700, Sean Christopherson wrote:
> Extract the meat of __do_cpuid_func_emulated() into a separate helper,
> cpuid_func_emulated(), so that cpuid_func_emulated() can be used with a
> single CPUID entry.  This will allow marking emulated features as fully
> supported in the guest cpu_caps without needing to hardcode the set of
> emulated features in multiple locations.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index fd725cbbcce5..d1849fe874ab 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1007,14 +1007,10 @@ static struct kvm_cpuid_entry2 *do_host_cpuid(struct kvm_cpuid_array *array,
>  	return entry;
>  }
>  
> -static int __do_cpuid_func_emulated(struct kvm_cpuid_array *array, u32 func)
> +static int cpuid_func_emulated(struct kvm_cpuid_entry2 *entry, u32 func)
>  {
> -	struct kvm_cpuid_entry2 *entry;
> +	memset(entry, 0, sizeof(*entry));
>  
> -	if (array->nent >= array->maxnent)
> -		return -E2BIG;
> -
> -	entry = &array->entries[array->nent];
>  	entry->function = func;
>  	entry->index = 0;
>  	entry->flags = 0;
> @@ -1022,23 +1018,27 @@ static int __do_cpuid_func_emulated(struct kvm_cpuid_array *array, u32 func)
>  	switch (func) {
>  	case 0:
>  		entry->eax = 7;
> -		++array->nent;
> -		break;
> +		return 1;
>  	case 1:
>  		entry->ecx = F(MOVBE);
> -		++array->nent;
> -		break;
> +		return 1;
>  	case 7:
>  		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
>  		entry->eax = 0;
>  		if (kvm_cpu_cap_has(X86_FEATURE_RDTSCP))
>  			entry->ecx = F(RDPID);
> -		++array->nent;
> -		break;
> +		return 1;
>  	default:
> -		break;
> +		return 0;
>  	}
> +}
>  
> +static int __do_cpuid_func_emulated(struct kvm_cpuid_array *array, u32 func)
> +{
> +	if (array->nent >= array->maxnent)
> +		return -E2BIG;
> +
> +	array->nent += cpuid_func_emulated(&array->entries[array->nent], func);
>  	return 0;
>  }
>  
Hi,

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>


PS: I spoke with Paolo about the meaning of KVM_GET_EMULATED_CPUID, because it is not clear
from the documentation what it does, or what it supposed to do because qemu doesn't use this
IOCTL.

So this ioctl is meant to return a static list of CPU features which *can* be emulated
by KVM, if the cpu doesn't support them, but there is a cost to it, so they
should not be enabled by default.

This means that if you run 'qemu -cpu host', these features (like rdpid) will only
be enabled if supported by the host cpu, however if you explicitly ask
qemu for such a feature, like 'qemu -cpu host,+rdpid', 
qemu should not warn if the feature is not supported on host cpu but can be emulated
(because kvm can emulate the feature, which is stated by KVM_GET_EMULATED_CPUID ioctl).

Qemu currently doesn't support this but the support can be added.

So I think that the two ioctls should be redefined as such:

KVM_GET_SUPPORTED_CPUID - returns all CPU features that are supported
by KVM, supported by host hardware, or that KVM can efficiently emulate.


KVM_GET_EMULATED_CPUID - returns all CPU features that KVM *can* emulate
if the host cpu lacks support, but emulation is not efficient and thus
these features should be used with care when not supported by the host 
(e.g only when the user explicitly asks for them).


I can post a patch to fix this or you can add something like that to your
patch series if you prefer.


Best regards,
	Maxim Levitsky


