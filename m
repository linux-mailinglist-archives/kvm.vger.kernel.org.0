Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3347B433CE5
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 19:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234517AbhJSRCd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 13:02:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:53967 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234441AbhJSRCc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Oct 2021 13:02:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634662818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zGvLIs148hziB4PUxgRa4SMQOneyHkfkSPS3E4B1O/U=;
        b=f1DebP4SeQSz/51ulKZ1YJsZqxxaj1hOxegGnVBUsX/wHg6NyOtO4NUkbCqYkyl9n+gDOo
        68XA4RS74mqrhT1RkGJFsta1sywNreIeCF/ZwObc8FVLtCkZ2a73spHS6Z2UfqkRU9I7nD
        LfdTfULVdz9T3k2fT01T+N+nCZyjurs=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-AF6LcvVjOCKk1AtFKgt-7w-1; Tue, 19 Oct 2021 13:00:16 -0400
X-MC-Unique: AF6LcvVjOCKk1AtFKgt-7w-1
Received: by mail-ed1-f70.google.com with SMTP id a3-20020a50da43000000b003dca31dcfc2so1812036edk.14
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 10:00:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zGvLIs148hziB4PUxgRa4SMQOneyHkfkSPS3E4B1O/U=;
        b=3t+CDMtLg/VJ/f8RX5XZOJtkxazbaQyJC5HOWY3gPt4Ub58Bv/+T41ZRHNiLlr7Nlz
         RHsxQsYihRNRq+G+XOHFG/2Bb9jTm8uwhJUjtvrVmzZt/JR1tjt/9KASnIq2Z27MECAO
         F9XDdiDdpnPSqZ81m8MOHxSZModTwL1DPZGTrs5iYMvfbaFaMmConvCzzly9hqAYq4lo
         vkzcKYatmxtjtNn049o8arLho+9nhlNhfX6stiN5XlCUdhVtDzonT4I1PPRbyhUEFczD
         a5zbftOF5NyZK/2clIJ7oqAxrNruMKKMdc9GC5zMduC4drQiAPol+qG3A/KS/sNVpFaq
         GknA==
X-Gm-Message-State: AOAM5330Tz8Mrrn6FGbou+2X/9rT9KMJDeSo+u7Gaugvb7IlSz7sunow
        rBEINA/wZpS90F8rWBBWpdBXu4nGFcqQkoyQ6/R5V1yoS8aCp/8ruRpKFcnhe5ZYrZ9/tKLY1cy
        y6/JjT8F97lFK
X-Received: by 2002:a17:906:cccb:: with SMTP id ot11mr38326054ejb.219.1634662810987;
        Tue, 19 Oct 2021 10:00:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzVDgHSlgJMQQCpSKbI6RvbpD0gCr7VgQKsONRyAup2RQedluzTYxrKtWBegjWiO9mZ9tbj8Q==
X-Received: by 2002:a17:906:cccb:: with SMTP id ot11mr38325973ejb.219.1634662810372;
        Tue, 19 Oct 2021 10:00:10 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:8e02:b072:96b1:56d0? ([2001:b07:6468:f312:8e02:b072:96b1:56d0])
        by smtp.gmail.com with ESMTPSA id n10sm10310389ejk.86.2021.10.19.10.00.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Oct 2021 10:00:09 -0700 (PDT)
Message-ID: <39b178d0-f3aa-9bab-e142-60f917b0f707@redhat.com>
Date:   Tue, 19 Oct 2021 19:00:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 1/3] KVM: emulate: Don't inject #GP when emulating
 RDMPC if CR0.PE=0
Content-Language: en-US
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1634631160-67276-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <1634631160-67276-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/10/21 10:12, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> SDM mentioned that, RDPMC:
> 
>    IF (((CR4.PCE = 1) or (CPL = 0) or (CR0.PE = 0)) and (ECX indicates a supported counter))
>        THEN
>            EAX := counter[31:0];
>            EDX := ZeroExtend(counter[MSCB:32]);
>        ELSE (* ECX is not valid or CR4.PCE is 0 and CPL is 1, 2, or 3 and CR0.PE is 1 *)
>            #GP(0);
>    FI;
> 
> Let's add the CR0.PE is 1 checking to rdpmc emulate, though this isn't
> strictly necessary since it's impossible for CPL to be >0 if CR0.PE=0.

Why not just add a comment then instead?

Paolo

> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> v2 -> v3:
>   * add the missing 'S'
> v1 -> v2:
>   * update patch description
> 
>   arch/x86/kvm/emulate.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 9a144ca8e146..ab7ec569e8c9 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -4213,6 +4213,7 @@ static int check_rdtsc(struct x86_emulate_ctxt *ctxt)
>   static int check_rdpmc(struct x86_emulate_ctxt *ctxt)
>   {
>   	u64 cr4 = ctxt->ops->get_cr(ctxt, 4);
> +	u64 cr0 = ctxt->ops->get_cr(ctxt, 0);
>   	u64 rcx = reg_read(ctxt, VCPU_REGS_RCX);
>   
>   	/*
> @@ -4222,7 +4223,7 @@ static int check_rdpmc(struct x86_emulate_ctxt *ctxt)
>   	if (enable_vmware_backdoor && is_vmware_backdoor_pmc(rcx))
>   		return X86EMUL_CONTINUE;
>   
> -	if ((!(cr4 & X86_CR4_PCE) && ctxt->ops->cpl(ctxt)) ||
> +	if ((!(cr4 & X86_CR4_PCE) && ctxt->ops->cpl(ctxt) && (cr0 & X86_CR0_PE)) ||
>   	    ctxt->ops->check_pmc(ctxt, rcx))
>   		return emulate_gp(ctxt, 0);
>   
> 

