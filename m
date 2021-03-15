Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0958533C04C
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 16:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbhCOPqL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 11:46:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31637 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231591AbhCOPpk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Mar 2021 11:45:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615823138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BV12LgapJ4gNBpAaz+WfOBRFtSSHpOF7WzzNCq2lj9M=;
        b=inHVHJFnTx3jGQ+dFYP3eL1TQIcCiV1JeFp+Y1CGOG9/4tD0kMoMBVDUkMhTb21SXFhOPm
        KpTcxZ8xLWUVRvUwmrEXfb1pdUBQlNn1iW6ibEctP4d+tzcsAzTPyDpC0sokf3LMc4Uu0x
        LZO7dITw7dhBBVguiGQOxlamnJ8FJ/8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475-etxHlJjXMq-H5sDTZvyz_g-1; Mon, 15 Mar 2021 11:45:35 -0400
X-MC-Unique: etxHlJjXMq-H5sDTZvyz_g-1
Received: by mail-ed1-f72.google.com with SMTP id p6so16066182edq.21
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 08:45:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BV12LgapJ4gNBpAaz+WfOBRFtSSHpOF7WzzNCq2lj9M=;
        b=TH+xLmNPCjBfXvnZh1qSMGaL6zxfNe8U31ufDHtz6zksQTdNDC+PE2CT2tOvOdNS9T
         fR5CZvVOqlXzMrCZv/QkLQ3cdMvYaozbMaPNDjOUin8XmZ+y6g+eDdLWmYlSippkd1GF
         NOtEGqi6SFZ2Ro6tqrZV3veWSMs+Xm+mLyLqX+0FD4Ar7eh9ZDcJ1yi9iz/b2xPNffjX
         J92fJWBnKZIeAeP6uvSzm+Sg3n0okbbROGWUBT9FBzv5ypg/3nU+Wk5qGnzOBMDMyOmC
         CVnqZgVDmr3P8MtGKqpcmQG0iNSAMgRtfy0iC/4L64fbpOI92J8kBZkTT7nwuOGakKC4
         WMJg==
X-Gm-Message-State: AOAM5321JOHdRCETPxbldzw4QmNDTZFuhEYNt1WhdTZfv6jYb/tveKAp
        J2TK0wy9U6DYXBxipQXCMg93hCttQA8A3MngwqLkw7v6KnZKsNtgD92Qfd7J7gMU67nGkgSWwTG
        K9kcXRubAmHzh
X-Received: by 2002:a17:906:2692:: with SMTP id t18mr23870661ejc.16.1615823134766;
        Mon, 15 Mar 2021 08:45:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxCkEBEkLGhRof+sbVhlVtllMdBTtOcyoPCcyJL+tMg64RbElKos76Wjo0Dn1+LZa3PnUWHzw==
X-Received: by 2002:a17:906:2692:: with SMTP id t18mr23870633ejc.16.1615823134536;
        Mon, 15 Mar 2021 08:45:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.gmail.com with ESMTPSA id cf4sm2709559edb.19.2021.03.15.08.45.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Mar 2021 08:45:33 -0700 (PDT)
Subject: Re: [PATCH 2/4] KVM: x86: hyper-v: Prevent using not-yet-updated TSC
 page by secondary CPUs
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
References: <20210315143706.859293-1-vkuznets@redhat.com>
 <20210315143706.859293-3-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6b392d7e-8135-53a9-9040-f6f5e316c6cb@redhat.com>
Date:   Mon, 15 Mar 2021 16:45:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210315143706.859293-3-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/03/21 15:37, Vitaly Kuznetsov wrote:
> When KVM_REQ_MASTERCLOCK_UPDATE request is issued (e.g. after migration)
> we need to make sure no vCPU sees stale values in PV clock structures and
> thus all vCPUs are kicked with KVM_REQ_CLOCK_UPDATE. Hyper-V TSC page
> clocksource is global and kvm_guest_time_update() only updates in on vCPU0
> but this is not entirely correct: nothing blocks some other vCPU from
> entering the guest before we finish the update on CPU0 and it can read
> stale values from the page.
> 
> Call kvm_hv_setup_tsc_page() on all vCPUs. Normally, KVM_REQ_CLOCK_UPDATE
> should be very rare so we may not care much about being wasteful.

I think we should instead write 0 to the page in kvm_gen_update_masterclock.

Paolo

> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>   arch/x86/kvm/x86.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 47e021bdcc94..882c509bfc86 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2748,8 +2748,9 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>   				       offsetof(struct compat_vcpu_info, time));
>   	if (vcpu->xen.vcpu_time_info_set)
>   		kvm_setup_pvclock_page(v, &vcpu->xen.vcpu_time_info_cache, 0);
> -	if (v == kvm_get_vcpu(v->kvm, 0))
> -		kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
> +
> +	kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
> +
>   	return 0;
>   }
>   
> 

