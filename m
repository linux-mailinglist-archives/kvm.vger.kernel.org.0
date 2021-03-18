Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6F0340C43
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 18:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbhCRRzx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 13:55:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27538 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232402AbhCRRzg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 13:55:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616090135;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LIthaCPfEMaPsdAY5ThVlMRUnMT/maNnKeXQkXykv2Q=;
        b=HTadi4sP2lWBwONmzWj+4B5ew78CAfqbUKkHeaqUn7lVzwBTcT9sVVDN6FTpGzAaU5u9Uf
        gFhrE3OiYBgNu44n88Hn3/dxgnFMAT+pPwWRIZOjeyEI1fFN01hi646grQPBaAF1nxBqtU
        qrqO+qQlibHkNl5Lmgt0nptclvKihHY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-308-bHHa6z6GN8yyvig8Mmn_eg-1; Thu, 18 Mar 2021 13:55:33 -0400
X-MC-Unique: bHHa6z6GN8yyvig8Mmn_eg-1
Received: by mail-wr1-f69.google.com with SMTP id s10so20470588wre.0
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 10:55:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LIthaCPfEMaPsdAY5ThVlMRUnMT/maNnKeXQkXykv2Q=;
        b=o4H8nvF4p0y3iqa4iuqU5gb+hIoXTAVaYJsaweNUYOfEcdCPfh+aKHmRqZvnSXiFty
         ZnZPMVcm2LbokTncLMeL3wQQAWJASsGRiaDhUQvWGx2sJMBN+XDnZeYrcW4uFG13Gqk7
         DzIuCDc57MEYQNIEuLI4LQZEt7UWsBqxyheqzxeTYwIqb31G8LnJ9g90do7Ylmh7zQrw
         XuAdsX8QPXDqefViJFGwj1cm+KdknSByT+M5jKz5ARCu9U2Fu2ywtfqjk5zW0mvjADdY
         HxUkfvg5His65ObegVaBrQMd5pBY0nyUSYCCtePiLHDHUZrCY5EPjAZzvVSMkmK+wrLa
         QuLQ==
X-Gm-Message-State: AOAM533wysdrWhmMpI9Q+lQ9MGxjdy0CH6lX0ceIPXEzWsdUCpvZUzE9
        TInoItzgDKBZJTWGYNsUWAa8Y8b/T1Tm1gFUsjTclDUud+2Zmh8lRsE1hDa6BuDprRupIEJkxuW
        wILfn41wpRzkd
X-Received: by 2002:a5d:5744:: with SMTP id q4mr489546wrw.390.1616090132304;
        Thu, 18 Mar 2021 10:55:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzngAEXRO5HNCZLAOI0ZJiIVObmYJ3MwjuzQ6tHtgjDNK7r9zMdUo5YDT7qVH2LRtDU/xCMiA==
X-Received: by 2002:a5d:5744:: with SMTP id q4mr489531wrw.390.1616090132098;
        Thu, 18 Mar 2021 10:55:32 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u2sm4110393wmm.5.2021.03.18.10.55.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 10:55:31 -0700 (PDT)
Subject: Re: [PATCH] KVM: X86: Fix missing local pCPU when executing wbinvd on
 all dirty pCPUs
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Nadav Amit <namit@vmware.com>
References: <1615517151-7465-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4c37a4f6-8b73-9285-0aa5-2e86350b3b06@redhat.com>
Date:   Thu, 18 Mar 2021 18:55:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1615517151-7465-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/03/21 03:45, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> We should execute wbinvd on all dirty pCPUs when guest wbinvd exits
> to maintain datat consistency in order to deal with noncoherent DMA.
> smp_call_function_many() does not execute the provided function on
> the local core, this patch replaces it by on_each_cpu_mask().
> 
> Reported-by: Nadav Amit <namit@vmware.com>
> Cc: Nadav Amit <namit@vmware.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>   arch/x86/kvm/x86.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 012d5df..aa6d667 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6638,7 +6638,7 @@ static int kvm_emulate_wbinvd_noskip(struct kvm_vcpu *vcpu)
>   		int cpu = get_cpu();
>   
>   		cpumask_set_cpu(cpu, vcpu->arch.wbinvd_dirty_mask);
> -		smp_call_function_many(vcpu->arch.wbinvd_dirty_mask,
> +		on_each_cpu_mask(vcpu->arch.wbinvd_dirty_mask,
>   				wbinvd_ipi, NULL, 1);
>   		put_cpu();
>   		cpumask_clear(vcpu->arch.wbinvd_dirty_mask);
> 

Queued, thanks.

Paolo

