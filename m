Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 620E617400E
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 20:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgB1TBG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 14:01:06 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55336 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725877AbgB1TBG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Feb 2020 14:01:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582916465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LiPBqOuIz1/2RBKHODOZDGbhSVpJxU4zscd7lrZcSRs=;
        b=FlCZIGA062by7+paWX8GHjD41R6D8ojB10eR0pqLI+T6CsdIqXIRB0qi7yTEGkKKoy95Zg
        8c1SOQMwsNafQqIrYqhR2aoTtTvRv2I5xue3XJlIt6ztQY3EO/OXvHF/9LHoeG5Fm7ufEH
        dUHKBbuOtCWs4ROxhOpi0f6z4/cEANw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-N5baH9SIO1ipZ1rDSTXX4A-1; Fri, 28 Feb 2020 14:01:01 -0500
X-MC-Unique: N5baH9SIO1ipZ1rDSTXX4A-1
Received: by mail-wm1-f70.google.com with SMTP id o24so1034949wmh.0
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2020 11:01:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LiPBqOuIz1/2RBKHODOZDGbhSVpJxU4zscd7lrZcSRs=;
        b=MoBkrdhZDY/yM5VdwdqGlDC/1bFss7M7Tkk42wDV9LgJWJO2VP4jkpRzcKvB+crF8q
         DYQsvUVhAEykUjUlHT64Jz0fkll31/y6XZ9CN6KQuEL8vTS/kxi8Pftk5kLUgF/psWC0
         2SHScAXH5asgLGhhZ7We9cIf6Xkg4yvzcp2g/0hz/mTwBfK7UjV3YAFMLZXZwLGqqHSe
         tcpu5XpKcL5/FCEPq2Gz9z9h9JCXAQk0kRVzpJbaMvySv6n8J7IbXeHaUVQZwXM/qvp3
         bX0iQJmMJJD556jeiUzg/0jytkXRzpy2XKeEN9KzbKw/lTj9TU4/8V7IP4Do2+EspqLI
         +IBA==
X-Gm-Message-State: APjAAAUR+HeJcFmOQLtENacxdNQ+08UqIeQIY8vkV0QQ85T2YNCV7Ozs
        8NrMyGbHiLPttjhWCm28hUhfOTJCKFQqtbM+cSxqzIV90E5yh3SxeESwxoVkG4g2KFU8TZNuOyL
        lCI4XP8VqN1yq
X-Received: by 2002:adf:fecf:: with SMTP id q15mr6360069wrs.360.1582916460476;
        Fri, 28 Feb 2020 11:01:00 -0800 (PST)
X-Google-Smtp-Source: APXvYqyUAOtHhcNdh6zAcXkMCkMKGN203lllm4k+2H8nx7TxQKT3GaUWUFcFp7bJ8X90a6ZWDESlqA==
X-Received: by 2002:adf:fecf:: with SMTP id q15mr6360049wrs.360.1582916460182;
        Fri, 28 Feb 2020 11:01:00 -0800 (PST)
Received: from [192.168.178.40] ([151.20.130.54])
        by smtp.gmail.com with ESMTPSA id h15sm6613102wrr.73.2020.02.28.11.00.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2020 11:00:59 -0800 (PST)
Subject: Re: [PATCH] x86/kvm: Handle async page faults directly through
 do_page_fault()
To:     Andy Lutomirski <luto@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        kvm list <kvm@vger.kernel.org>,
        Radim Krcmar <rkrcmar@redhat.com>
References: <6bf68d0facc36553324c38ec798b0feebf6742b7.1582915284.git.luto@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c80e3380-d484-1b01-a638-0ee130dea11a@redhat.com>
Date:   Fri, 28 Feb 2020 20:00:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <6bf68d0facc36553324c38ec798b0feebf6742b7.1582915284.git.luto@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/02/20 19:42, Andy Lutomirski wrote:
> KVM overloads #PF to indicate two types of not-actually-page-fault
> events.  Right now, the KVM guest code intercepts them by modifying
> the IDT and hooking the #PF vector.  This makes the already fragile
> fault code even harder to understand, and it also pollutes call
> traces with async_page_fault and do_async_page_fault for normal page
> faults.
> 
> Clean it up by moving the logic into do_page_fault() using a static
> branch.  This gets rid of the platform trap_init override mechanism
> completely.
> 
> Signed-off-by: Andy Lutomirski <luto@kernel.org>

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Just one thing:

> @@ -1505,6 +1506,25 @@ do_page_fault(struct pt_regs *regs, unsigned long hw_error_code,
>  		unsigned long address)
>  {
>  	prefetchw(&current->mm->mmap_sem);
> +	/*
> +	 * KVM has two types of events that are, logically, interrupts, but
> +	 * are unfortunately delivered using the #PF vector.

At least the not-present case isn't entirely an interrupt because it
must be delivered precisely.  Regarding the page-ready case you're
right, it could be an interrupt. However, generally speaking this is not
a problem.  Using something in memory rather than overloading the error
code was the mistake.

> +      * These events are
> +	 * "you just accessed valid memory, but the host doesn't have it right
> +	 * not, so I'll put you to sleep if you continue" and "that memory
> +	 * you tried to access earlier is available now."
> +	 *
> +	 * We are relying on the interrupted context being sane (valid
> +	 * RSP, relevant locks not held, etc.), which is fine as long as
> +	 * the the interrupted context had IF=1.

This is not about IF=0/IF=1; the KVM code is careful about taking
spinlocks only with IRQs disabled, and async PF is not delivered if the
interrupted context had IF=0.  The problem is that the memory location
is not reentrant if an NMI is delivered in the wrong window, as you hint
below.

Paolo

> We are also relying on
> +	 * the KVM async pf type field and CR2 being read consistently
> +	 * instead of getting values from real and async page faults
> +	 * mixed up.
> +	 *
> +	 * Fingers crossed.
> +	 */
> +	if (kvm_handle_async_pf(regs, hw_error_code, address))
> +		return;
> +
>  	trace_page_fault_entries(regs, hw_error_code, address);
>  
>  	if (unlikely(kmmio_fault(regs, address)))
> 

