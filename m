Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B109368E9E
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 10:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241147AbhDWINs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 04:13:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37364 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241356AbhDWINr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Apr 2021 04:13:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619165590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JV8lxB5jxKaMLebE0kj34sple4uhf5PyGZQen4ktIWM=;
        b=LDz91TX5E08jq4PvBHjAAmeNhVuzOJpP2I+AlgYMgcXhJP5ychacd+buwwUkA1q9y/DIHn
        elV3qE9Z+WqQwod+eNb56F32CtxMzlFEixaW0qY8vN/jCMG1Tc+l5EeSw7x+B5T6wPbBrV
        m7GXp92o5N0zw74YkH+H1xesbOZ3snw=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-462-0ZMbPSX3NgGMeQViDzRdAg-1; Fri, 23 Apr 2021 04:13:08 -0400
X-MC-Unique: 0ZMbPSX3NgGMeQViDzRdAg-1
Received: by mail-ed1-f71.google.com with SMTP id p16-20020a0564021550b029038522733b66so10148876edx.11
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 01:13:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JV8lxB5jxKaMLebE0kj34sple4uhf5PyGZQen4ktIWM=;
        b=QRw+lX+6sA4fnhRBvFiTV6nzoJARCohy56cOR3+NvjQRnbUOAilNPLzHE+2+eFKI1x
         YKOmpynK37ldYmOJB4GQTsnRIvNzZJQd7ImbgapdKPxO8K5VaNL8DNtAgny2yGwG8zdF
         PRuJE1QjNpHokkytCuXYXukBr8O40NtW7Yo4FbeBiKV9aITDPiq+jTXqeFCG01d1F8w9
         k6Hm0CM3W42K7gHjpraBFnc4BR8FJlRBfe6pdmT8GFeEM5MvIYcCT+DouhprCLar8HYn
         fMwQUpWsju/7v4qshl641gAeFdI7wyyCQ664ZZwpOvZ11S84H3SBXh3qnK9g4sQt6grA
         tHXQ==
X-Gm-Message-State: AOAM530SpqO7Z/BFEqPfbnzTpjOu0S4LmNc4iphvFM2E4yCvqFwjmpto
        npoN6/EARH4zRbq0NBc0Oe1qZ2Yigqi217oBE9UX4lF87qw10K6XybWCJaswxuXm5nNV8sTvrCw
        wVzx4Xq+xfdam
X-Received: by 2002:a17:906:80d1:: with SMTP id a17mr2940522ejx.55.1619165587543;
        Fri, 23 Apr 2021 01:13:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwmHJI1X+H7hKlvBNxRQOwhvUiNXWScEBXZM+Kc2dHSs2YT40KOzysDXFu7gbrM6y/ENjHjaw==
X-Received: by 2002:a17:906:80d1:: with SMTP id a17mr2940509ejx.55.1619165587397;
        Fri, 23 Apr 2021 01:13:07 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f19sm3521662ejc.54.2021.04.23.01.13.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Apr 2021 01:13:06 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86/xen: Take srcu lock when accessing
 kvm_memslots()
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1619161883-5963-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f025b59c-5a8a-abf7-20fc-323a5b450ba5@redhat.com>
Date:   Fri, 23 Apr 2021 10:13:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1619161883-5963-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/04/21 09:11, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> kvm_memslots() will be called by kvm_write_guest_offset_cached() so
> take the srcu lock.
> 
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>

Good catch.  But I would pull it from kvm_steal_time_set_preempted to 
kvm_arch_vcpu_put instead.

Paolo

> ---
>   arch/x86/kvm/xen.c | 18 ++++++++++++++----
>   1 file changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index ae17250..d0df782 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -96,6 +96,7 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
>   	struct kvm_vcpu_xen *vx = &v->arch.xen;
>   	uint64_t state_entry_time;
>   	unsigned int offset;
> +	int idx;
>   
>   	kvm_xen_update_runstate(v, state);
>   
> @@ -133,10 +134,16 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
>   	BUILD_BUG_ON(sizeof(((struct compat_vcpu_runstate_info *)0)->state_entry_time) !=
>   		     sizeof(state_entry_time));
>   
> +	/*
> +	 * Take the srcu lock as memslots will be accessed to check the gfn
> +	 * cache generation against the memslots generation.
> +	 */
> +	idx = srcu_read_lock(&v->kvm->srcu);
> +
>   	if (kvm_write_guest_offset_cached(v->kvm, &v->arch.xen.runstate_cache,
>   					  &state_entry_time, offset,
>   					  sizeof(state_entry_time)))
> -		return;
> +		goto out;
>   	smp_wmb();
>   
>   	/*
> @@ -154,7 +161,7 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
>   					  &vx->current_runstate,
>   					  offsetof(struct vcpu_runstate_info, state),
>   					  sizeof(vx->current_runstate)))
> -		return;
> +		goto out;
>   
>   	/*
>   	 * Write the actual runstate times immediately after the
> @@ -173,7 +180,7 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
>   					  &vx->runstate_times[0],
>   					  offset + sizeof(u64),
>   					  sizeof(vx->runstate_times)))
> -		return;
> +		goto out;
>   
>   	smp_wmb();
>   
> @@ -186,7 +193,10 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
>   	if (kvm_write_guest_offset_cached(v->kvm, &v->arch.xen.runstate_cache,
>   					  &state_entry_time, offset,
>   					  sizeof(state_entry_time)))
> -		return;
> +		goto out;
> +
> +out:
> +	srcu_read_unlock(&v->kvm->srcu, idx);
>   }
>   
>   int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
> 

