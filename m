Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACF7175F41
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 17:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgCBQMD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 11:12:03 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48031 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726390AbgCBQMD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 11:12:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583165521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xi2o3J2ZcfACr16nVkEKi+8ad1hTmaKkej8tqKEm+Eo=;
        b=KpItDlzGfw6z/FixCQvQhjn9hI9Smny2TUc9oVLiMRvSom3NanyyTXNVOCRqjYcssOcjmW
        j9cOGTXvEvD1fboMvj5+2yYNmKWHaUBwvmOctWGPJ5Rr6TB5wXG0hyEHpygooJe4RPHqmI
        Ei3TqR78we2FRW2uQRQu8p3A7LRhKz4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-HUYyaVk2NKq8in131RLlfQ-1; Mon, 02 Mar 2020 11:11:59 -0500
X-MC-Unique: HUYyaVk2NKq8in131RLlfQ-1
Received: by mail-wr1-f70.google.com with SMTP id 72so5999732wrc.6
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2020 08:11:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xi2o3J2ZcfACr16nVkEKi+8ad1hTmaKkej8tqKEm+Eo=;
        b=XGnZQ8aNtEchTbjucTpedXcjg4xGuZEuHoaJoIph0x5xAy90apWgPstDHgjTztEJz/
         6tBv0ogyTd0rfqDmNQOyLJBQAa5yShaFGfoWUaJCSe5rLDmflDligGi66kpO2b8XMEQo
         Zkojz2rWD/RVP7wJ72r7fzC7EXtM0N+Pp2womVK2+x30FoDzqIBF7Cjwx3jv40Msy/Ga
         HcMneQAAMWH8sARYVOC3XJvoI7m235yi7daLFigTFcjG1XV0ydjyDB6xUs0s487G40K2
         yT9hUzMvJQ/0B/MMLdhfQ59xVVWt0Klk/MWZumM2DTKKNskcXst7tjs1S1/MztxkINcO
         cN6Q==
X-Gm-Message-State: ANhLgQ33IH1hgtnd3s5fXAci15/Q1PxPfKWx0wgsASOn8DKQepnutwLf
        LglRwoUT16/GCsv3bhafClYcq7jKB+fPYUdql6lHZ6dQYwWesht5ZRQ7dnZoEQMg+AqV/HaDgIZ
        ohSSm80CCA0JD
X-Received: by 2002:adf:f84a:: with SMTP id d10mr351751wrq.208.1583165518495;
        Mon, 02 Mar 2020 08:11:58 -0800 (PST)
X-Google-Smtp-Source: ADFU+vsL9HMQs/2MntXNOu8VNLiLvjovAUJQh6TGG3lgQYf7DzlElFZNILPnHyCnaWBInNbPAUbFxQ==
X-Received: by 2002:adf:f84a:: with SMTP id d10mr351738wrq.208.1583165518218;
        Mon, 02 Mar 2020 08:11:58 -0800 (PST)
Received: from [192.168.178.40] ([151.30.85.6])
        by smtp.gmail.com with ESMTPSA id f6sm2155083wmh.29.2020.03.02.08.11.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 08:11:57 -0800 (PST)
Subject: Re: [PATCH] kvm: x86: Make traced and returned value of kvm_cpuid
 consistent again
To:     Jan Kiszka <jan.kiszka@web.de>, kvm <kvm@vger.kernel.org>
Cc:     Jim Mattson <jmattson@google.com>
References: <dd33df29-2c17-2dc8-cb8f-56686cd583ad@web.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <688edd4d-81ad-bb6b-f166-4fb26a90bb9e@redhat.com>
Date:   Mon, 2 Mar 2020 17:11:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <dd33df29-2c17-2dc8-cb8f-56686cd583ad@web.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/03/20 11:47, Jan Kiszka wrote:
> From: Jan Kiszka <jan.kiszka@siemens.com>
> 
> After 43561123ab37, found is not set correctly in case of leaves 0BH,
> 1FH, or anything out-of-range. This is currently harmless for the return
> value because the only caller evaluating it passes leaf 0x80000008.
> 
> However, the trace entry is now misleading due to this inaccuracy. It is
> furthermore misleading because it reports the effective function, not
> the originally passed one. Fix that as well.
> 
> Fixes: 43561123ab37 ("kvm: x86: Improve emulation of CPUID leaves 0BH and 1FH")
> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>

Queued, thanks.

Paolo

> ---
>  arch/x86/kvm/cpuid.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index b1c469446b07..79a738f313f8 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1000,13 +1000,12 @@ static bool cpuid_function_in_range(struct kvm_vcpu *vcpu, u32 function)
>  bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
>  	       u32 *ecx, u32 *edx, bool check_limit)
>  {
> -	u32 function = *eax, index = *ecx;
> +	u32 orig_function = *eax, function = *eax, index = *ecx;
>  	struct kvm_cpuid_entry2 *entry;
>  	struct kvm_cpuid_entry2 *max;
>  	bool found;
> 
>  	entry = kvm_find_cpuid_entry(vcpu, function, index);
> -	found = entry;
>  	/*
>  	 * Intel CPUID semantics treats any query for an out-of-range
>  	 * leaf as if the highest basic leaf (i.e. CPUID.0H:EAX) were
> @@ -1049,7 +1048,8 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
>  			}
>  		}
>  	}
> -	trace_kvm_cpuid(function, *eax, *ebx, *ecx, *edx, found);
> +	found = entry;
> +	trace_kvm_cpuid(orig_function, *eax, *ebx, *ecx, *edx, found);
>  	return found;
>  }
>  EXPORT_SYMBOL_GPL(kvm_cpuid);
> --
> 2.16.4
> 

