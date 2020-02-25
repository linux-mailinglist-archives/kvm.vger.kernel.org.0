Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42F7916C3B2
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 15:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730525AbgBYOUs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 09:20:48 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:58821 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730297AbgBYOUs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Feb 2020 09:20:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582640447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w6FPpUbqRjz4gpl8i29mEumqWVf8GMxTT6jsxq0Z1Hc=;
        b=FA4DXFE8vzh0IpublXZB/DMSUfXFj2Gch4KvXq1v8cQNhmVUGkwQZ8Yw3e+YubV38bEbjb
        MQpJ0n1KLIJa5CjIXVDHPF98qO5jmLT1Lk3uywhYMlKgnSiysJY1RxHXDY5rIvfrp/9Pyu
        MipkGk8QdPw/zhfokAych96EQxvZrwg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-TPOCQsw4NFCfTYPaj3rhXg-1; Tue, 25 Feb 2020 09:20:45 -0500
X-MC-Unique: TPOCQsw4NFCfTYPaj3rhXg-1
Received: by mail-wr1-f70.google.com with SMTP id n12so5478275wrp.19
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 06:20:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w6FPpUbqRjz4gpl8i29mEumqWVf8GMxTT6jsxq0Z1Hc=;
        b=bYtkFNa1EdRetcauU8ZeFWJuecN5CannS8UOTUzWhFpUWOG9Xko+FLmsMZjsgKSHJo
         wbdBUjxEuRzyv8UDWj+fMwwERb8JOYxfUgiRCiWw9xBVzBekINMMmfSiKuFHo3iTi2Cu
         ZX6I6MPeO0KOBpydwgSiMn1Wi7enq5OYtiI2Lgt3BVOvdpW/vmx7F6Cb+2tWk3bxUGoj
         U5szO7DUNmkUc4cKi0BhJqEb/28596zw4yBgBDZIlOsP/+630fLXDQUMCxjEqaVoslBn
         p30T9jmncEOgSbSGm/+qDHCA6kBrUZAioAp8v5g3B5YZzeqXgnUBFzvDDaFVMxnDKJZS
         qgBQ==
X-Gm-Message-State: APjAAAUW0Pyqu6Pj0I5+/aPhO+IsCziznrwEWi+0kdp3od+yj2H4scyt
        OY4UPK+SgyPLEmKsSJYeUws1EsnNRv397QyXplAUZ17yCQPSnD9Scxkxx3qsPIDt6tYI2x1m9fx
        EwF6lLFH14YsF
X-Received: by 2002:a5d:4b91:: with SMTP id b17mr10625464wrt.325.1582640444254;
        Tue, 25 Feb 2020 06:20:44 -0800 (PST)
X-Google-Smtp-Source: APXvYqw0/r6jYINhIO7NFbSrZU8U9CXVckXX4lL7VhdkK/P9c93FiJxF+RGAU6OqxmnOGX3IqqCZYg==
X-Received: by 2002:a5d:4b91:: with SMTP id b17mr10625439wrt.325.1582640443944;
        Tue, 25 Feb 2020 06:20:43 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:3577:1cfe:d98a:5fb6? ([2001:b07:6468:f312:3577:1cfe:d98a:5fb6])
        by smtp.gmail.com with ESMTPSA id 133sm4826515wmd.5.2020.02.25.06.20.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 06:20:43 -0800 (PST)
Subject: Re: [PATCH v2] KVM: LAPIC: Recalculate apic map in batch
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1582624061-5814-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0af6b96a-16ac-5054-7754-6ab4a239a2d4@redhat.com>
Date:   Tue, 25 Feb 2020 15:20:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1582624061-5814-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/02/20 10:47, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> In the vCPU reset and set APIC_BASE MSR path, the apic map will be recalculated 
> several times, each time it will consume 10+ us observed by ftrace in my 
> non-overcommit environment since the expensive memory allocate/mutex/rcu etc 
> operations. This patch optimizes it by recaluating apic map in batch, I hope 
> this can benefit the serverless scenario which can frequently create/destroy 
> VMs.
> 
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> v1 -> v2:
>  * add apic_map_dirty to kvm_lapic
>  * error condition in kvm_apic_set_state, do recalcuate  unconditionally
> 
>  arch/x86/kvm/lapic.c | 29 +++++++++++++++++++----------
>  arch/x86/kvm/lapic.h |  2 ++
>  arch/x86/kvm/x86.c   |  2 ++
>  3 files changed, 23 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index afcd30d..3476dbc 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -164,7 +164,7 @@ static void kvm_apic_map_free(struct rcu_head *rcu)
>  	kvfree(map);
>  }
>  
> -static void recalculate_apic_map(struct kvm *kvm)
> +void kvm_recalculate_apic_map(struct kvm *kvm)
>  {

It's better to add an "if" here rather than in every caller.  It should
be like:

	if (!apic->apic_map_dirty) {
		/*
		 * Read apic->apic_map_dirty before
		 * kvm->arch.apic_map.
		 */
		smp_rmb();
		return;
	}

        mutex_lock(&kvm->arch.apic_map_lock);
	if (!apic->apic_map_dirty) {
		/* Someone else has updated the map.  */
		mutex_unlock(&kvm->arch.apic_map_lock);
		return;
	}
	...
out:
        old = rcu_dereference_protected(kvm->arch.apic_map,
                        lockdep_is_held(&kvm->arch.apic_map_lock));
        rcu_assign_pointer(kvm->arch.apic_map, new);
	/*
	 * Write kvm->arch.apic_map before
	 * clearing apic->apic_map_dirty.
	 */
	smp_wmb();
	apic->apic_map_dirty = false;
        mutex_unlock(&kvm->arch.apic_map_lock);
	...

But actually it seems to me that, given we're going through all this
pain, it's better to put the "dirty" flag in kvm->arch, next to the
mutex and the map itself.  This should also reduce the number of calls
to kvm_recalculate_apic_map that recompute the map.  A lot of them will
just wait on the mutex and exit.

Paolo

