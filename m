Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC7A3496E5
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 17:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhCYQdu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 12:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbhCYQdh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 12:33:37 -0400
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12BFC06174A
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 09:33:36 -0700 (PDT)
Received: by mail-oo1-xc2f.google.com with SMTP id q127-20020a4a33850000b02901b646aa81b1so623923ooq.8
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 09:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=icx8/ROiUGbXEvPXqjuw1B6ZehL0QY6lhCYqvdH4CJ8=;
        b=eUCzvhUoDqhYbjAH/SCI1XADZLyN9X7jUMHfbTvpOy+csA1Cd9M43F9i7MlUaxXEz5
         yjZ9APiih/xX2QvOayE8n2i48Pm03qMcm/gKdnnrSPrxls0mSoFpGG7OhwS9/mxLYnZw
         BHer52FF/fh/x1nUmykh3jFZQWB1CRBhXMAefu1mGtIWjD7OVai7eoZLk8lNe9MmofEh
         UqzW2fDxQU0jHq4ksI/9OZGcJ6DGWY4axXrtkMbrvBIgfhnctemnFSOIFa/BNTL049Dm
         +kyxe8PMkzbTxJlue49Lr2ed3MnhWbVbvpz+QaY9l7MhFUoG+4bw5YJcw+j548AvwYuY
         xtug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=icx8/ROiUGbXEvPXqjuw1B6ZehL0QY6lhCYqvdH4CJ8=;
        b=Pd8gUezrOosVVc/hDlu2ekjgdaQ6qbdK84xoun/r520pm4edgQkiYA7ERV2U5ae+qs
         ddNKl/loj4F97h4ac0Sh0dPdqeRLCsK7sEw1xfQC7K06nlHvuhaq2JiyXS1lOpBGiMY4
         l+8JpEI4cQQKHrZ1xkbrOXjONC7vXXJHnCocljJrUGrPFC4H9MDW6cFwX9xjeXqPQMz/
         e5Adcd5+l9tEIgxurkq1cGqJqT97ZgO/WBmfqAQBK8AdtadXMheCYyjyAgAluCHOUWep
         L/ZngUOHXqZ2pVdpGrL//DkbbtIyJrQPHHgdQ9/Q585TvR0ExEns5aouWZB/R4GtJui/
         3rVw==
X-Gm-Message-State: AOAM532fUz2XA6piRKkFVpiL4qnBSD2gJrsz0EGTr1Bl6plHWSLoM+m1
        cZQiaSPtBY64tsT3VP7GTqehzA==
X-Google-Smtp-Source: ABdhPJytwirDMt+cb8gz0ZuTetwO20FIEReA2W/wsPOb73esowNet2q0uFtGoqomeSGLfCo344U6aQ==
X-Received: by 2002:a4a:c316:: with SMTP id c22mr7878829ooq.65.1616690015522;
        Thu, 25 Mar 2021 09:33:35 -0700 (PDT)
Received: from eggly.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id h24sm1442657otg.20.2021.03.25.09.33.34
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Thu, 25 Mar 2021 09:33:35 -0700 (PDT)
Date:   Thu, 25 Mar 2021 09:33:18 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To:     Borislav Petkov <bp@alien8.de>
cc:     Hugh Dickins <hughd@google.com>, Babu Moger <babu.moger@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Makarand Sonare <makarandsonare@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH] x86/tlb: Flush global mappings when KAISER is disabled
In-Reply-To: <20210325102959.GD31322@zn.tnic>
Message-ID: <alpine.LSU.2.11.2103250929110.10977@eggly.anvils>
References: <2ca37e61-08db-3e47-f2b9-8a7de60757e6@amd.com> <20210311214013.GH5829@zn.tnic> <d3e9e091-0fc8-1e11-ab99-9c8be086f1dc@amd.com> <4a72f780-3797-229e-a938-6dc5b14bec8d@amd.com> <20210311235215.GI5829@zn.tnic> <ed590709-65c8-ca2f-013f-d2c63d5ee0b7@amd.com>
 <20210324212139.GN5010@zn.tnic> <alpine.LSU.2.11.2103241651280.9593@eggly.anvils> <alpine.LSU.2.11.2103241913190.10112@eggly.anvils> <20210325095619.GC31322@zn.tnic> <20210325102959.GD31322@zn.tnic>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 25 Mar 2021, Borislav Petkov wrote:

> Ok,
> 
> I tried to be as specific as possible in the commit message so that we
> don't forget. Please lemme know if I've missed something.
> 
> Babu, Jim, I'd appreciate it if you ran this to confirm.
> 
> Thx.
> 
> ---
> From: Borislav Petkov <bp@suse.de>
> Date: Thu, 25 Mar 2021 11:02:31 +0100
> 
> Jim Mattson reported that Debian 9 guests using a 4.9-stable kernel
> are exploding during alternatives patching:
> 
>   kernel BUG at /build/linux-dqnRSc/linux-4.9.228/arch/x86/kernel/alternative.c:709!
>   invalid opcode: 0000 [#1] SMP
>   Modules linked in:
>   CPU: 1 PID: 1 Comm: swapper/0 Not tainted 4.9.0-13-amd64 #1 Debian 4.9.228-1
>   Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>   Call Trace:
>    swap_entry_free
>    swap_entry_free
>    text_poke_bp
>    swap_entry_free
>    arch_jump_label_transform
>    set_debug_rodata
>    __jump_label_update
>    static_key_slow_inc
>    frontswap_register_ops
>    init_zswap
>    init_frontswap
>    do_one_initcall
>    set_debug_rodata
>    kernel_init_freeable
>    rest_init
>    kernel_init
>    ret_from_fork
> 
> triggering the BUG_ON in text_poke() which verifies whether patched
> instruction bytes have actually landed at the destination.
> 
> Further debugging showed that the TLB flush before that check is
> insufficient because there could be global mappings left in the TLB,
> leading to a stale mapping getting used.
> 
> I say "global mappings" because the hardware configuration is a new one:
> machine is an AMD, which means, KAISER/PTI doesn't need to be enabled
> there, which also means there's no user/kernel pagetables split and
> therefore the TLB can have global mappings.
> 
> And the configuration is new one for a second reason: because that AMD
> machine supports PCID and INVPCID, which leads the CPU detection code to
> set the synthetic X86_FEATURE_INVPCID_SINGLE flag.
> 
> Now, __native_flush_tlb_single() does invalidate global mappings when
> X86_FEATURE_INVPCID_SINGLE is *not* set and returns.
> 
> When X86_FEATURE_INVPCID_SINGLE is set, however, it invalidates the
> requested address from both PCIDs in the KAISER-enabled case. But if
> KAISER is not enabled and the machine has global mappings in the TLB,
> then those global mappings do not get invalidated, which would lead to
> the above mismatch from using a stale TLB entry.
> 
> So make sure to flush those global mappings in the KAISER disabled case.
> 
> Co-debugged by Babu Moger <babu.moger@amd.com>.
> 
> Reported-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Link: https://lkml.kernel.org/r/CALMp9eRDSW66%2BXvbHVF4ohL7XhThoPoT0BrB0TcS0cgk=dkcBg@mail.gmail.com

Acked-by: Hugh Dickins <hughd@google.com>

Great write-up too: many thanks.

> ---
>  arch/x86/include/asm/tlbflush.h | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
> index f5ca15622dc9..2bfa4deb8cae 100644
> --- a/arch/x86/include/asm/tlbflush.h
> +++ b/arch/x86/include/asm/tlbflush.h
> @@ -245,12 +245,15 @@ static inline void __native_flush_tlb_single(unsigned long addr)
>  	 * ASID.  But, userspace flushes are probably much more
>  	 * important performance-wise.
>  	 *
> -	 * Make sure to do only a single invpcid when KAISER is
> -	 * disabled and we have only a single ASID.
> +	 * In the KAISER disabled case, do an INVLPG to make sure
> +	 * the mapping is flushed in case it is a global one.
>  	 */
> -	if (kaiser_enabled)
> +	if (kaiser_enabled) {
>  		invpcid_flush_one(X86_CR3_PCID_ASID_USER, addr);
> -	invpcid_flush_one(X86_CR3_PCID_ASID_KERN, addr);
> +		invpcid_flush_one(X86_CR3_PCID_ASID_KERN, addr);
> +	} else {
> +		asm volatile("invlpg (%0)" ::"r" (addr) : "memory");
> +	}
>  }
>  
>  static inline void __flush_tlb_all(void)
> -- 
> 2.29.2
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
