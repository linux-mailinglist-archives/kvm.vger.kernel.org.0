Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A993C2CDC93
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 18:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730697AbgLCRkp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 12:40:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27649 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727498AbgLCRko (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Dec 2020 12:40:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607017158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zbIwQHwInAT5GLKTqpYwDY6NAxTvt+ZgkanC6avIhjE=;
        b=UTE4TfnoDPlkLcVVO8j+ugURAiTXAN9sXUXxB6gasE+tnnCJ5nGyPeMlmnbvhqjD+Y01A4
        qTi98L9A1UTPhGcc5Fvn2wMwRT1iA+4SnMnwoNsDICqx3VvM+FFfp+fXU2NEtZKRFsdNz/
        4lUASRqgRL4bGLplJCu+JCzzbkZoYfo=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-134-SJY5-IW2MsuOnxylczwrlA-1; Thu, 03 Dec 2020 12:39:14 -0500
X-MC-Unique: SJY5-IW2MsuOnxylczwrlA-1
Received: by mail-ej1-f71.google.com with SMTP id dv25so1049617ejb.15
        for <kvm@vger.kernel.org>; Thu, 03 Dec 2020 09:39:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zbIwQHwInAT5GLKTqpYwDY6NAxTvt+ZgkanC6avIhjE=;
        b=lMH1UJEFMpNOPXCFaIivpKaMuDZkq2ja0/XkK0ZR2C3XRS1CG/gBmaFjXprX3fogjE
         DMAjXAriKkWC40C7v5Z5ca8fmFrNaIKCnDWGe3THXSqhBsCE106wY2qVJ9/Q6vL7PKR0
         OsxHap8muO4HvwDt/OXcHKoD51bZ9gG23l+u8wF0SyIPMILU/LkCCXNX02Wdoyf2wvtb
         RPeYHoPDNLLwPI0gK7oufgkaemmOQVKXqwX9qdaxHf4e8EqyAmv+11iYBpTnieJfftYv
         w8G363ixB0267D5Q0FbZE1xH6d4oDq/XJIMgk/qNqSqWxi//OTaBh0r6qMb3IS1ZN+ec
         OyuQ==
X-Gm-Message-State: AOAM533QvcYqtCj9yyw6adVnNmv9IxGH24cf1AvNSuth85pMe8alVaRl
        XhPV6ZwWrAwbJbOpIz+Ur9YvuKs6Js8AEnAOPvUZRRnkaum2ezzq1iAhImddvCXJ/zH/BrAmLLI
        z5aS0DV/7v9It
X-Received: by 2002:aa7:cb4a:: with SMTP id w10mr3888349edt.343.1607017153427;
        Thu, 03 Dec 2020 09:39:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzJA9jcVQLaPryS8bR4jvZr1+czrk7Ubj//AYw6JSdyIinZP3c9Va7M1+4lGM9Ovquxqx1bmQ==
X-Received: by 2002:aa7:cb4a:: with SMTP id w10mr3888335edt.343.1607017153262;
        Thu, 03 Dec 2020 09:39:13 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n17sm1278629ejh.49.2020.12.03.09.39.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Dec 2020 09:39:12 -0800 (PST)
Subject: Re: [PATCH] selftests: kvm/set_memory_region_test: Fix race in move
 region test
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        Shuah Khan <shuah@kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <0fdddb94bb0e31b7da129a809a308d91c10c0b5e.1606941224.git.maciej.szmigiero@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6e0f1fcf-c8ac-c05a-778b-eeb7a4cd50e7@redhat.com>
Date:   Thu, 3 Dec 2020 18:39:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <0fdddb94bb0e31b7da129a809a308d91c10c0b5e.1606941224.git.maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/12/20 21:35, Maciej S. Szmigiero wrote:
> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> 
> The current memory region move test correctly handles the situation that
> the second (realigning) memslot move operation would temporarily trigger
> MMIO until it completes, however it does not handle the case in which the
> first (misaligning) move operation does this, too.
> This results in false test assertions in case it does so.
> 
> Fix this by handling temporary MMIO from the first memslot move operation
> in the test guest code, too.
> 
> Fixes: 8a0639fe9201 ("KVM: sefltests: Add explicit synchronization to move mem region test")
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> ---
>      The race is pretty hard to trigger on the current KVM memslot code,
>      to trigger it reliably an extra delay in memslot move op is needed:
>      --- a/virt/kvm/kvm_main.c
>      +++ b/virt/kvm/kvm_main.c
>      @@ -1173,7 +1173,7 @@ static struct kvm_memslots *kvm_dup_memslots(struct kvm_memslots *old,
>      
>              return slots;
>       }
>      -
>      +#include <linux/delay.h>
>       static int kvm_set_memslot(struct kvm *kvm,
>                                 const struct kvm_userspace_memory_region *mem,
>                                 struct kvm_memory_slot *old,
>      @@ -1212,6 +1212,8 @@ static int kvm_set_memslot(struct kvm *kvm,
>                       *      - kvm_is_visible_gfn (mmu_check_root)
>                       */
>                      kvm_arch_flush_shadow_memslot(kvm, slot);
>      +
>      +               if (change == KVM_MR_MOVE) mdelay(100);
>              }
>      
>              r = kvm_arch_prepare_memory_region(kvm, new, mem, change);
> 
>   .../selftests/kvm/set_memory_region_test.c      | 17 +++++++++++++----
>   1 file changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
> index b3ece55a2da6..6f441dd9f33c 100644
> --- a/tools/testing/selftests/kvm/set_memory_region_test.c
> +++ b/tools/testing/selftests/kvm/set_memory_region_test.c
> @@ -156,14 +156,23 @@ static void guest_code_move_memory_region(void)
>   	GUEST_SYNC(0);
>   
>   	/*
> -	 * Spin until the memory region is moved to a misaligned address.  This
> -	 * may or may not trigger MMIO, as the window where the memslot is
> -	 * invalid is quite small.
> +	 * Spin until the memory region starts getting moved to a
> +	 * misaligned address.
> +	 * Every region move may or may not trigger MMIO, as the
> +	 * window where the memslot is invalid is usually quite small.
>   	 */
>   	val = guest_spin_on_val(0);
>   	GUEST_ASSERT_1(val == 1 || val == MMIO_VAL, val);
>   
> -	/* Spin until the memory region is realigned. */
> +	/* Spin until the misaligning memory region move completes. */
> +	val = guest_spin_on_val(MMIO_VAL);
> +	GUEST_ASSERT_1(val == 1 || val == 0, val);
> +
> +	/* Spin until the memory region starts to get re-aligned. */
> +	val = guest_spin_on_val(0);
> +	GUEST_ASSERT_1(val == 1 || val == MMIO_VAL, val);
> +
> +	/* Spin until the re-aligning memory region move completes. */
>   	val = guest_spin_on_val(MMIO_VAL);
>   	GUEST_ASSERT_1(val == 1, val);
>   
> 

Queued, thanks.

paolo

