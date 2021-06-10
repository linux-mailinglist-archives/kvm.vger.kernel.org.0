Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33B183A2CCB
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 15:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbhFJNVK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 09:21:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32445 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230313AbhFJNVJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 09:21:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623331153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zy+ioEX8QbWPVNS5mTQ1lBruzExGYIs1Y2im4YELuWM=;
        b=EGlzgcrtV7qdxdSmifjQxjeIVtWcDb1ygZudc+jFiXC8F7KBnUEFtBz4WI7ql5G/rwJ2bu
        Lq0WPtVj6+jdtVsgv4f2MR2Angd/spOxGTI2SVwrGCf8EZ8FPteUFLRPifKtUp9BlKdQSm
        KjgeRLhQdQDUhI1fzaLZadw9JGef5Qw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-532-rm4sWfiXPWam57uzXUJyqA-1; Thu, 10 Jun 2021 09:19:11 -0400
X-MC-Unique: rm4sWfiXPWam57uzXUJyqA-1
Received: by mail-wm1-f70.google.com with SMTP id h9-20020a05600c3509b02901b985251fdcso1925472wmq.9
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 06:19:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zy+ioEX8QbWPVNS5mTQ1lBruzExGYIs1Y2im4YELuWM=;
        b=Ux6UtnfjQzOvdwvfOMbX6DDtOtMzMBf4DIODP4SJBYPfEuS9sqS4fNIhCREubJOq7v
         Ms9GZJsrGuujhEcfi/EPyoI0ixc+fWV5ZsOEliUlt2ftWf1y+BEcORPNmhxvuh5uudKh
         U+yqMkjOa5zg0Bq7pdtGwRQl6OWhBKfybAicieopfhb9nyf5A6OrXnHHTWEJ5SuZVsE/
         3okAxTHTanDjCV2wZon0dhy2ghWT2Y4s06esloWWKv09fbklX/roRCX3xbs7NlmuuYN5
         D0xlGqyqxboFz44ONd8Q64Et1y2ZUOUc6gAVGDETw3diKgfu922NYaj5cKXkUjuhXC5/
         2img==
X-Gm-Message-State: AOAM532mzTYtqjV/dmCo8rUAy0GwtUK1/GsCln18k7n2HUl2SdK97yze
        1zbhQA05CRK5NrXw4h0vrura0iwVR3048CFhzPZKEoGR60H+JDec10aSpGhHIe8Wc7o5cDz+7it
        IfrgJ6TNve6Vy
X-Received: by 2002:adf:ed03:: with SMTP id a3mr5466297wro.166.1623331149954;
        Thu, 10 Jun 2021 06:19:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyNWQbpsUkE8WmLIns+cDBz0m/aQwzQO+W9jG9ohTUbbulFK2fQtSJ/SsVHcVhIdPR41vuLfw==
X-Received: by 2002:adf:ed03:: with SMTP id a3mr5466279wro.166.1623331149796;
        Thu, 10 Jun 2021 06:19:09 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id l3sm3182636wmh.2.2021.06.10.06.19.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 06:19:08 -0700 (PDT)
Subject: Re: [PATCH 1/9] KVM: x86: Immediately reset the MMU context when the
 SMM flag is cleared
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+fb0b6a7e8713aeb0319c@syzkaller.appspotmail.com
References: <20210609185619.992058-1-seanjc@google.com>
 <20210609185619.992058-2-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <eb0b94d4-9edf-6ef6-25f9-27a3e407f60b@redhat.com>
Date:   Thu, 10 Jun 2021 15:19:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210609185619.992058-2-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/06/21 20:56, Sean Christopherson wrote:
> Immediately reset the MMU context when the vCPU's SMM flag is cleared so
> that the SMM flag in the MMU role is always synchronized with the vCPU's
> flag.  If RSM fails (which isn't correctly emulated), KVM will bail
> without calling post_leave_smm() and leave the MMU in a bad state.
> 
> The bad MMU role can lead to a NULL pointer dereference when grabbing a
> shadow page's rmap for a page fault as the initial lookups for the gfn
> will happen with the vCPU's SMM flag (=0), whereas the rmap lookup will
> use the shadow page's SMM flag, which comes from the MMU (=1).  SMM has
> an entirely different set of memslots, and so the initial lookup can find
> a memslot (SMM=0) and then explode on the rmap memslot lookup (SMM=1).
> 
>    general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
>    KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
>    CPU: 1 PID: 8410 Comm: syz-executor382 Not tainted 5.13.0-rc5-syzkaller #0
>    Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>    RIP: 0010:__gfn_to_rmap arch/x86/kvm/mmu/mmu.c:935 [inline]
>    RIP: 0010:gfn_to_rmap+0x2b0/0x4d0 arch/x86/kvm/mmu/mmu.c:947
>    Code: <42> 80 3c 20 00 74 08 4c 89 ff e8 f1 79 a9 00 4c 89 fb 4d 8b 37 44
>    RSP: 0018:ffffc90000ffef98 EFLAGS: 00010246
>    RAX: 0000000000000000 RBX: ffff888015b9f414 RCX: ffff888019669c40
>    RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000001
>    RBP: 0000000000000001 R08: ffffffff811d9cdb R09: ffffed10065a6002
>    R10: ffffed10065a6002 R11: 0000000000000000 R12: dffffc0000000000
>    R13: 0000000000000003 R14: 0000000000000001 R15: 0000000000000000
>    FS:  000000000124b300(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
>    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>    CR2: 0000000000000000 CR3: 0000000028e31000 CR4: 00000000001526e0
>    DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>    DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>    Call Trace:
>     rmap_add arch/x86/kvm/mmu/mmu.c:965 [inline]
>     mmu_set_spte+0x862/0xe60 arch/x86/kvm/mmu/mmu.c:2604
>     __direct_map arch/x86/kvm/mmu/mmu.c:2862 [inline]
>     direct_page_fault+0x1f74/0x2b70 arch/x86/kvm/mmu/mmu.c:3769
>     kvm_mmu_do_page_fault arch/x86/kvm/mmu.h:124 [inline]
>     kvm_mmu_page_fault+0x199/0x1440 arch/x86/kvm/mmu/mmu.c:5065
>     vmx_handle_exit+0x26/0x160 arch/x86/kvm/vmx/vmx.c:6122
>     vcpu_enter_guest+0x3bdd/0x9630 arch/x86/kvm/x86.c:9428
>     vcpu_run+0x416/0xc20 arch/x86/kvm/x86.c:9494
>     kvm_arch_vcpu_ioctl_run+0x4e8/0xa40 arch/x86/kvm/x86.c:9722
>     kvm_vcpu_ioctl+0x70f/0xbb0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3460
>     vfs_ioctl fs/ioctl.c:51 [inline]
>     __do_sys_ioctl fs/ioctl.c:1069 [inline]
>     __se_sys_ioctl+0xfb/0x170 fs/ioctl.c:1055
>     do_syscall_64+0x3f/0xb0 arch/x86/entry/common.c:47
>     entry_SYSCALL_64_after_hwframe+0x44/0xae
>    RIP: 0033:0x440ce9
> 
> Reported-by: syzbot+fb0b6a7e8713aeb0319c@syzkaller.appspotmail.com
> Fixes: 9ec19493fb86 ("KVM: x86: clear SMM flags before loading state while leaving SMM")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/x86.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9dd23bdfc6cc..54d212fe9b15 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7106,7 +7106,10 @@ static unsigned emulator_get_hflags(struct x86_emulate_ctxt *ctxt)
>   
>   static void emulator_set_hflags(struct x86_emulate_ctxt *ctxt, unsigned emul_flags)
>   {
> -	emul_to_vcpu(ctxt)->arch.hflags = emul_flags;
> +	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
> +
> +	vcpu->arch.hflags = emul_flags;
> +	kvm_mmu_reset_context(vcpu);
>   }
>   
>   static int emulator_pre_leave_smm(struct x86_emulate_ctxt *ctxt,
> 

Queued for kvm/master, thanks.

Paolo

