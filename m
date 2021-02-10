Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6DEA316C58
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 18:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbhBJRQi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 12:16:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37335 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232323AbhBJRQU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Feb 2021 12:16:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612977293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pnXK/IR7kwRHioWi4n+z2d1LBLzC5VDv46lVgWiUcLw=;
        b=WlZI6l9mINXQB+XZHaj11qr870vLJux68p2Kfgqehs0Xh/vd3FB3bYLxGdDTajGU77Mmvm
        Vx8/Lq1NjamHzi0wDYAY++qEkJQrzm7JPqppm5CghsGSjQAyJdtsKbTMmA08Ilj9U4AiZj
        dm55dlW3Ff9Z+W5YRrJnM59XLlGxtvw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-eAjNzP4bOxirjhhNg5GNUA-1; Wed, 10 Feb 2021 12:14:49 -0500
X-MC-Unique: eAjNzP4bOxirjhhNg5GNUA-1
Received: by mail-wr1-f71.google.com with SMTP id d7so2239438wri.23
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 09:14:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pnXK/IR7kwRHioWi4n+z2d1LBLzC5VDv46lVgWiUcLw=;
        b=rY6B6xbmg0rfOf1CqJRNgLg3pTtzhKCbtBpBUP8guqmLr3its3s1Yd5W5d8rmMjxjb
         s4I2uSYZZpdyA1sGMallaPz44psstS7ETsxKwZx/qI6i7lFJe87JATTiTTnGR7z+fqX/
         OiZphHhFhG3R1Q3smJH8miHL7SINnyToKs5ydvjX0UMeWY0VxlRJdZYIpjl5POHu/Qwv
         vhvy43WYEOzGxbcyhfeVr0yHwLG///k235jXdCbnhLgyKpl9Z2kCqKOl3LTOT/fobcQB
         PlZ/2ioMdwIevfgrjLIX3RvuJrO7HfEgKO+PSDDfj2eyF4Z5ZUsbusiny4NHFFTlZYWo
         j5ew==
X-Gm-Message-State: AOAM5328L1mXmPuLNgQP5mpGF/MBQyYOQq6zx9b62ijt4X8PTCDwZJG4
        sowQwpQxnke2tNTL/tCM/fLH3WGgEZ9W9tUzMCNsgVdtqYJoOrs3Vb2xCX1/2JRVVvFEZKGdxTJ
        709dRPzhwJXJ1
X-Received: by 2002:a05:6000:18a3:: with SMTP id b3mr4764946wri.373.1612977288615;
        Wed, 10 Feb 2021 09:14:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzrpfJC7m73xLVSUOZX8qz5cgWYm6hrGbObJc78i3V++vWyATGZZhotcOFwqDWQAzyVJRcu1g==
X-Received: by 2002:a05:6000:18a3:: with SMTP id b3mr4764930wri.373.1612977288448;
        Wed, 10 Feb 2021 09:14:48 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id l83sm3440826wmf.4.2021.02.10.09.14.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Feb 2021 09:14:47 -0800 (PST)
Subject: Re: [PATCH v3] KVM: x86/MMU: Do not check unsync status for root SP.
To:     Yu Zhang <yu.c.zhang@linux.intel.com>, seanjc@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org
References: <20210209170111.4770-1-yu.c.zhang@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <aa265bd9-851e-1823-8807-df50cd9820ab@redhat.com>
Date:   Wed, 10 Feb 2021 18:14:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210209170111.4770-1-yu.c.zhang@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/02/21 18:01, Yu Zhang wrote:
> In shadow page table, only leaf SPs may be marked as unsync;
> instead, for non-leaf SPs, we store the number of unsynced
> children in unsync_children. Therefore, in kvm_mmu_sync_root(),
> sp->unsync shall always be zero for the root SP and there is
> no need to check it. Remove the check, and add a warning
> inside mmu_sync_children() to assert that the flags are used
> properly.
> 
> While at it, move the warning from mmu_need_write_protect()
> to kvm_unsync_page().
> 
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 12 +++++++++---
>   1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 86af58294272..5f482af125b4 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1995,6 +1995,12 @@ static void mmu_sync_children(struct kvm_vcpu *vcpu,
>   	LIST_HEAD(invalid_list);
>   	bool flush = false;
>   
> +	/*
> +	 * Only 4k SPTEs can directly be made unsync, the parent pages
> +	 * should never be unsyc'd.
> +	 */
> +	WARN_ON_ONCE(parent->unsync);
> +
>   	while (mmu_unsync_walk(parent, &pages)) {
>   		bool protected = false;
>   
> @@ -2502,6 +2508,8 @@ EXPORT_SYMBOL_GPL(kvm_mmu_unprotect_page);
>   
>   static void kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
>   {
> +	WARN_ON(sp->role.level != PG_LEVEL_4K);
> +
>   	trace_kvm_mmu_unsync_page(sp);
>   	++vcpu->kvm->stat.mmu_unsync;
>   	sp->unsync = 1;
> @@ -2524,7 +2532,6 @@ bool mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
>   		if (sp->unsync)
>   			continue;
>   
> -		WARN_ON(sp->role.level != PG_LEVEL_4K);
>   		kvm_unsync_page(vcpu, sp);
>   	}
>   
> @@ -3406,8 +3413,7 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
>   		 * mmu_need_write_protect() describe what could go wrong if this
>   		 * requirement isn't satisfied.
>   		 */
> -		if (!smp_load_acquire(&sp->unsync) &&
> -		    !smp_load_acquire(&sp->unsync_children))
> +		if (!smp_load_acquire(&sp->unsync_children))
>   			return;
>   
>   		write_lock(&vcpu->kvm->mmu_lock);
> 

Queued, thanks.

Paolo

