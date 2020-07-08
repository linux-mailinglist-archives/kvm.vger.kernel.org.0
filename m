Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43CF6218594
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 13:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728763AbgGHLIe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 07:08:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28576 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728717AbgGHLId (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 07:08:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594206512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UsTH2g5Srh8ZxaMtl2dCP3xACw/aEbSOpSitaM2tt8A=;
        b=dfuebEZ69Nl8u7couTN5mm/RTDEhc2SqsiKHx3p574k1YF1CtlZnSUeDqz7ZzjT5oSwfJ6
        7mwHhtBoO3GKNt8OPLQa2qi3VmyNww79RaEXP/qwchJt8A1sSWDLCpnOW9+9YmXUoxrKmU
        T/yYaSWBTtXtgdE066jkEQPAlTu16GY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369-2gPzu692NmeWs4hU2xFXvw-1; Wed, 08 Jul 2020 07:08:30 -0400
X-MC-Unique: 2gPzu692NmeWs4hU2xFXvw-1
Received: by mail-wr1-f69.google.com with SMTP id b14so51764523wrp.0
        for <kvm@vger.kernel.org>; Wed, 08 Jul 2020 04:08:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UsTH2g5Srh8ZxaMtl2dCP3xACw/aEbSOpSitaM2tt8A=;
        b=VO1HNK7nh4f4Y34al0f3JHQJHjqnLA3XsmasB66hTPX6zMwkKXzV9ih4MgDBVZwEaA
         UFu1y4BtTfMsh+lyZrlNzbumogC22CFpRtWHusrW95zPjzsX6BTpzNU/fLbEk5gG4Ukf
         pDbmtBiiRxjpkMqAKjr/cFNVNkB5CkFNs7UVd9dfV/wsJx2g1Npe7MUqbT7e8DZB27Qq
         zMH2V0xwTHA5YPzENSb0N2vUVNkLqrIuUC2Q0eLIywZ6+LjoEadZLOylogxcTTqZf4xT
         uqQZeXWaGuZUESgYuRT9pAOhGA3fcPb49CaJcK1qixa3otC16kfS3MuM9gBBc6W6PljZ
         aVXw==
X-Gm-Message-State: AOAM531T8XfV/KdThb/k6x6x/FVE0kMCuXWZzylIp5Lg6ZCDEQLyTppf
        WlTKVldM02/V95MADIuKno80esZtVBCoSGSHv/blKkRCkVIOwsfPKvvzarz8TJDbSmDTUUyvkcz
        3BnE8RiaR5Rsb
X-Received: by 2002:a1c:9e84:: with SMTP id h126mr8405466wme.61.1594206509465;
        Wed, 08 Jul 2020 04:08:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyfhETRvUhtCmEHWo63nXGRqkOPlkqmDpTb+2sESQBbbdmRxlhpOu5S/wmhPtZ2fWEh5Is7Nw==
X-Received: by 2002:a1c:9e84:: with SMTP id h126mr8405427wme.61.1594206509215;
        Wed, 08 Jul 2020 04:08:29 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id c136sm5923589wmd.10.2020.07.08.04.08.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 04:08:28 -0700 (PDT)
Subject: Re: [PATCH] kvm: x86: limit the maximum number of vPMU fixed counters
 to 3
To:     Like Xu <like.xu@linux.intel.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
References: <20200624015928.118614-1-like.xu@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cd56533f-3dd5-70c3-c124-78c0d8950496@redhat.com>
Date:   Wed, 8 Jul 2020 13:08:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200624015928.118614-1-like.xu@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/06/20 03:59, Like Xu wrote:
> Some new Intel platforms (such as TGL) already have the
> fourth fixed counter TOPDOWN.SLOTS, but it has not been
> fully enabled on KVM and the host.
> 
> Therefore, we limit edx.split.num_counters_fixed to 3,
> so that it does not break the kvm-unit-tests PMU test
> case and bad-handled userspace.
> 
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 2 +-
>  arch/x86/kvm/pmu.h   | 2 ++
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 8a294f9747aa..0a2c6d2b4650 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -604,7 +604,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		eax.split.bit_width = cap.bit_width_gp;
>  		eax.split.mask_length = cap.events_mask_len;
>  
> -		edx.split.num_counters_fixed = cap.num_counters_fixed;
> +		edx.split.num_counters_fixed = min(cap.num_counters_fixed, MAX_FIXED_COUNTERS);
>  		edx.split.bit_width_fixed = cap.bit_width_fixed;
>  		edx.split.reserved = 0;
>  
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index ab85eed8a6cc..067fef51760c 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -15,6 +15,8 @@
>  #define VMWARE_BACKDOOR_PMC_REAL_TIME		0x10001
>  #define VMWARE_BACKDOOR_PMC_APPARENT_TIME	0x10002
>  
> +#define MAX_FIXED_COUNTERS	3
> +
>  struct kvm_event_hw_type_mapping {
>  	u8 eventsel;
>  	u8 unit_mask;
> 

Queued, thanks.

Paolo

