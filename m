Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDE73485A0
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 01:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234876AbhCYAGY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 20:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231902AbhCYAGH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 20:06:07 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C17AC06174A
        for <kvm@vger.kernel.org>; Wed, 24 Mar 2021 17:06:07 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id k14-20020a9d7dce0000b02901b866632f29so321029otn.1
        for <kvm@vger.kernel.org>; Wed, 24 Mar 2021 17:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=4Qs/sgDqugGRTTL6PsWyD8H8wV2UUkQBgt4/HJljqEw=;
        b=upbMDEkW6thi8wcyYRSamL9Yi7OPLl8Q7k6cQgtFc7ziEdsoVtqvE1WHVuZIxxuK0r
         p4H3pGSa1OVOkxWpwwekBJL0cDcgfkVVvMp5om7G1ygkLcU1OQEFfQ1msjEAQKMR62Qj
         tQ4mfunfAgFRrs3SctxdCib9b70e6AbiWuqnOkE6FtsfjbzDZ5Q7ULwWt/BpRXtYxqt9
         YTkyJ0rClpZ+GL+aWyh+Z/soO1y5G4e67qRWS7NMw90cUeO8DWak4pKph32KxMv1V7Ow
         wQ7JY7w66R26suGkamQeiKYEXPOL+BidVrg05G7FfIebntJekkIPW3IlFQ7IFIv0Bvv2
         ZPkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=4Qs/sgDqugGRTTL6PsWyD8H8wV2UUkQBgt4/HJljqEw=;
        b=onwutPidA/fOKpXmglePsx/Pzfojfb9DRSIxYI6iVNi+JeFVJPec8ighLLKdwzomnK
         8w+6r9dLA5RjrU04K06o9mdkrctfrLHAwFG6yP0w1C8ATPAZubz8iKG4EXgO39lYAAy6
         FVZBmlChjyrn522asjsiIKvO15frl5OF89XDJoxEE9Pe/K6/69rMOhL96ZEYzTGaG5dC
         nGyh153a+vECNMr+tMZ7yBXOoZExEhgVLFaYYC6V4f1a34AKwYJ5M5zq64A6mnNtngnN
         Iwn4kNhAv2D6Bw0P534q3GKZsmIMUQLhu4EncpUriCvbqlL38Aagt6HrBaT73X0lLkHy
         Oeag==
X-Gm-Message-State: AOAM532SzSPnp4Jhd9z4L75nj0ZVh4J4PVnm+RaL6gvT4ErmA7sF55qL
        NneWu2MvRQ9JEQ2ssRmzNmcHPA==
X-Google-Smtp-Source: ABdhPJzP4x6IABBkCCAgBvTaA2NT7oOvAc50/0OSf8S4sryxHjJucsjHL0w5hj7M7s6jtFidhApm0g==
X-Received: by 2002:a9d:4792:: with SMTP id b18mr5206672otf.350.1616630765984;
        Wed, 24 Mar 2021 17:06:05 -0700 (PDT)
Received: from eggly.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id w12sm919622oti.53.2021.03.24.17.06.04
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Wed, 24 Mar 2021 17:06:05 -0700 (PDT)
Date:   Wed, 24 Mar 2021 17:05:43 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To:     Borislav Petkov <bp@alien8.de>
cc:     Babu Moger <babu.moger@amd.com>, Hugh Dickins <hughd@google.com>,
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
Subject: Re: [PATCH v6 00/12] SVM cleanup and INVPCID feature support
In-Reply-To: <20210324212139.GN5010@zn.tnic>
Message-ID: <alpine.LSU.2.11.2103241651280.9593@eggly.anvils>
References: <78cc2dc7-a2ee-35ac-dd47-8f3f8b62f261@redhat.com> <d7c6211b-05d3-ec3f-111a-f69f09201681@amd.com> <20210311200755.GE5829@zn.tnic> <20210311203206.GF5829@zn.tnic> <2ca37e61-08db-3e47-f2b9-8a7de60757e6@amd.com> <20210311214013.GH5829@zn.tnic>
 <d3e9e091-0fc8-1e11-ab99-9c8be086f1dc@amd.com> <4a72f780-3797-229e-a938-6dc5b14bec8d@amd.com> <20210311235215.GI5829@zn.tnic> <ed590709-65c8-ca2f-013f-d2c63d5ee0b7@amd.com> <20210324212139.GN5010@zn.tnic>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 24 Mar 2021, Borislav Petkov wrote:

> Ok,
> 
> some more experimenting Babu and I did lead us to:
> 
> ---
> diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
> index f5ca15622dc9..259aa4889cad 100644
> --- a/arch/x86/include/asm/tlbflush.h
> +++ b/arch/x86/include/asm/tlbflush.h
> @@ -250,6 +250,9 @@ static inline void __native_flush_tlb_single(unsigned long addr)
>  	 */
>  	if (kaiser_enabled)
>  		invpcid_flush_one(X86_CR3_PCID_ASID_USER, addr);
> +	else
> +		asm volatile("invlpg (%0)" ::"r" (addr) : "memory");
> +
>  	invpcid_flush_one(X86_CR3_PCID_ASID_KERN, addr);
>  }
> 
> applied on the guest kernel which fixes the issue. And let me add Hugh
> who did that PCID stuff at the time. So lemme summarize for Hugh and to
> ask him nicely to sanity-check me. :-)

Just a brief interim note to assure you that I'm paying attention,
but wow, it's a long time since I gave any thought down here!
Trying to page it all back in...

I see no harm in your workaround if it works, but it's not as if
this is a previously untried path: so I'm suspicious how an issue
here with Globals could have gone unnoticed for so long, and need
to understand it better.

Hugh

> 
> Basically, you have an AMD host which supports PCID and INVPCID and you
> boot on it a 4.9 guest. It explodes like the panic below.
> 
> What fixes it is this:
> 
> diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
> index f5ca15622dc9..259aa4889cad 100644
> --- a/arch/x86/include/asm/tlbflush.h
> +++ b/arch/x86/include/asm/tlbflush.h
> @@ -250,6 +250,9 @@ static inline void __native_flush_tlb_single(unsigned long addr)
>  	 */
>  	if (kaiser_enabled)
>  		invpcid_flush_one(X86_CR3_PCID_ASID_USER, addr);
> +	else
> +		asm volatile("invlpg (%0)" ::"r" (addr) : "memory");
> +
>  	invpcid_flush_one(X86_CR3_PCID_ASID_KERN, addr);
>  }
> 
> ---
> 
> and the reason why it does, IMHO, is because on AMD, kaiser_enabled is
> false because AMD is not affected by Meltdown, which means, there's no
> user/kernel pagetables split.
> 
> And that also means, you have global TLB entries which means that if you
> look at that __native_flush_tlb_single() function, it needs to flush
> global TLB entries on CPUs with X86_FEATURE_INVPCID_SINGLE by doing an
> INVLPG in the kaiser_enabled=0 case. Errgo, the above hunk.
> 
> But I might be completely off here thus this note...
> 
> Thoughts?
> 
> Thx.
> 
> 
> [    1.235726] ------------[ cut here ]------------
> [    1.237515] kernel BUG at /build/linux-dqnRSc/linux-4.9.228/arch/x86/kernel/alternative.c:709!
> [    1.240926] invalid opcode: 0000 [#1] SMP
> [    1.243301] Modules linked in:
> [    1.244585] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 4.9.0-13-amd64 #1 Debian 4.9.228-1
> [    1.247657] Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> [    1.251249] task: ffff909363e94040 task.stack: ffffa41bc0194000
> [    1.253519] RIP: 0010:[<ffffffff8fa2e40c>]  [<ffffffff8fa2e40c>] text_poke+0x18c/0x240
> [    1.256593] RSP: 0018:ffffa41bc0197d90  EFLAGS: 00010096
> [    1.258657] RAX: 000000000000000f RBX: 0000000001020800 RCX: 00000000feda3203
> [    1.261388] RDX: 00000000178bfbff RSI: 0000000000000000 RDI: ffffffffff57a000
> [    1.264168] RBP: ffffffff8fbd3eca R08: 0000000000000000 R09: 0000000000000003
> [    1.266983] R10: 0000000000000003 R11: 0000000000000112 R12: 0000000000000001
> [    1.269702] R13: ffffa41bc0197dcf R14: 0000000000000286 R15: ffffed1c40407500
> [    1.272572] FS:  0000000000000000(0000) GS:ffff909366300000(0000) knlGS:0000000000000000
> [    1.275791] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    1.278032] CR2: 0000000000000000 CR3: 0000000010c08000 CR4: 00000000003606f0
> [    1.280815] Stack:
> [    1.281630]  ffffffff8fbd3eca 0000000000000005 ffffa41bc0197e03 ffffffff8fbd3ecb
> [    1.284660]  0000000000000000 0000000000000000 ffffffff8fa2e835 ccffffff8fad4326
> [    1.287729]  1ccd0231874d55d3 ffffffff8fbd3eca ffffa41bc0197e03 ffffffff90203844
> [    1.290852] Call Trace:
> [    1.291782]  [<ffffffff8fbd3eca>] ? swap_entry_free+0x12a/0x300
> [    1.294900]  [<ffffffff8fbd3ecb>] ? swap_entry_free+0x12b/0x300
> [    1.297267]  [<ffffffff8fa2e835>] ? text_poke_bp+0x55/0xe0
> [    1.299473]  [<ffffffff8fbd3eca>] ? swap_entry_free+0x12a/0x300
> [    1.301896]  [<ffffffff8fa2b64c>] ? arch_jump_label_transform+0x9c/0x120
> [    1.304557]  [<ffffffff9073e81f>] ? set_debug_rodata+0xc/0xc
> [    1.306790]  [<ffffffff8fb81d92>] ? __jump_label_update+0x72/0x80
> [    1.309255]  [<ffffffff8fb8206f>] ? static_key_slow_inc+0x8f/0xa0
> [    1.311680]  [<ffffffff8fbd7a57>] ? frontswap_register_ops+0x107/0x1d0
> [    1.314281]  [<ffffffff9077078c>] ? init_zswap+0x282/0x3f6
> [    1.316547]  [<ffffffff9077050a>] ? init_frontswap+0x8c/0x8c
> [    1.318784]  [<ffffffff8fa0223e>] ? do_one_initcall+0x4e/0x180
> [    1.321067]  [<ffffffff9073e81f>] ? set_debug_rodata+0xc/0xc
> [    1.323366]  [<ffffffff9073f08d>] ? kernel_init_freeable+0x16b/0x1ec
> [    1.325873]  [<ffffffff90011d50>] ? rest_init+0x80/0x80
> [    1.327989]  [<ffffffff90011d5a>] ? kernel_init+0xa/0x100
> [    1.330092]  [<ffffffff9001f424>] ? ret_from_fork+0x44/0x70
> [    1.332311] Code: 00 0f a2 4d 85 e4 74 4a 0f b6 45 00 41 38 45 00 75 19 31 c0 83 c0 01 48 63 d0 49 39 d4 76 33 41 0f b6 4c 15 00 38 4c 15 00 74 e9 <0f> 0b 48 89 ef e8 da d6 19 00 48 8d bd 00 10 00 00 48 89 c3 e8 
> [    1.342818] RIP  [<ffffffff8fa2e40c>] text_poke+0x18c/0x240
> [    1.345859]  RSP <ffffa41bc0197d90>
> [    1.347285] ---[ end trace 0a1c5ab5eb16de89 ]---
> [    1.349169] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
> [    1.349169] 
> [    1.352885] Kernel Offset: 0xea00000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> [    1.357039] ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
> [    1.357039] 
> 
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
> 
