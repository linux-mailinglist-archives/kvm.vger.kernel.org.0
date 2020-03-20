Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B090018D637
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 18:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgCTRtV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 13:49:21 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:39676 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726816AbgCTRtV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Mar 2020 13:49:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584726559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TQ/kl3k3iNBv74F3FBzAiK43NBYNWmyKSIiqcjfF37g=;
        b=GfeTpFNLVaQOXDwzsml7AjmudVp4xa4k7nOXQHufMai2mPN9N+DNc5xFYvMlQ6PKix+9s6
        7bKqxCWUP8pWZTb2hJw+KRWvkO+heTFHIjvAmnft09PJbDJMpLE2ENOYgYonBHQs4yg+tf
        DL/JGS+JEfrvn9MU2HghHk7F6mE2D8Q=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435-yy48rGGbPUGHEjja6shD7g-1; Fri, 20 Mar 2020 13:49:17 -0400
X-MC-Unique: yy48rGGbPUGHEjja6shD7g-1
Received: by mail-wr1-f69.google.com with SMTP id w11so2963260wrp.20
        for <kvm@vger.kernel.org>; Fri, 20 Mar 2020 10:49:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TQ/kl3k3iNBv74F3FBzAiK43NBYNWmyKSIiqcjfF37g=;
        b=b4SZRtsXYgIjDChuWIsOG/H5hPYrnXYOaud/3sKearg2e1dDNYy6fJIlTtjk3Aw6LS
         9wMovMvpfR8oFs5BE5U+0MHWortAPKOb2z8lfDxYdrfXNuJH/z42lWwRb1bzUhaDISMf
         MJf4q1EU5EmUMl1yNkeNQzTEnQm/JJsvmHcpir/bXYW5KiRlRm1EiNb15flCqPMtkEGn
         BdH/w/xXvOYV9ShAje26zyZuMTA03eKFR+zpmOQDc5ZfTjx6Mcy36lQ3P2hMFb3pbT8V
         rgG+3yMy2iumkcD6HRcFwpWc3Os9M5Bg9CrkjXtG/w8jCnxG3zivqnW0Fqgc8MV4U0Ge
         4uXw==
X-Gm-Message-State: ANhLgQ2Wk9ES/0d0DROe9NIqa7pcLqb+zS650nF+ldbW+pmjIZ/Y/QO4
        mHOTrjJ+Y39O24CXijq1hRQOGq33MuRLjIcNTk6NX98YegNgrol1lXJUJi4VwQ/PcGjOMOZP8we
        Ae//X/6hoaGnd
X-Received: by 2002:a5d:5386:: with SMTP id d6mr5030745wrv.92.1584726555536;
        Fri, 20 Mar 2020 10:49:15 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuwrpJCSjtnao11u4mVs5NZYw5SWprvWCKktGMDqGolsFu1I3ESvR7jqa9fFsBJmL82OAvWKg==
X-Received: by 2002:a5d:5386:: with SMTP id d6mr5030716wrv.92.1584726555252;
        Fri, 20 Mar 2020 10:49:15 -0700 (PDT)
Received: from [192.168.178.58] ([151.21.15.43])
        by smtp.gmail.com with ESMTPSA id y11sm9198156wrd.65.2020.03.20.10.49.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Mar 2020 10:49:14 -0700 (PDT)
Subject: Re: [PATCH] KVM: LAPIC: Mark hrtimer for period or oneshot mode to
 expire in hard interrupt context
To:     zhe.he@windriver.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, bigeasy@linutronix.de,
        linux-rt-users@vger.kernel.org
References: <1584687967-332859-1-git-send-email-zhe.he@windriver.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a2eb9c9e-b8db-6d17-82b2-70014324f02a@redhat.com>
Date:   Fri, 20 Mar 2020 18:49:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1584687967-332859-1-git-send-email-zhe.he@windriver.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/03/20 08:06, zhe.he@windriver.com wrote:
> From: He Zhe <zhe.he@windriver.com>
> 
> apic->lapic_timer.timer was initialized with HRTIMER_MODE_ABS_HARD but
> started later with HRTIMER_MODE_ABS, which may cause the following warning
> in PREEMPT_RT kernel.
> 
> WARNING: CPU: 1 PID: 2957 at kernel/time/hrtimer.c:1129 hrtimer_start_range_ns+0x348/0x3f0
> CPU: 1 PID: 2957 Comm: qemu-system-x86 Not tainted 5.4.23-rt11 #1
> Hardware name: Supermicro SYS-E300-9A-8C/A2SDi-8C-HLN4F, BIOS 1.1a 09/18/2018
> RIP: 0010:hrtimer_start_range_ns+0x348/0x3f0
> Code: 4d b8 0f 94 c1 0f b6 c9 e8 35 f1 ff ff 4c 8b 45
>       b0 e9 3b fd ff ff e8 d7 3f fa ff 48 98 4c 03 34
>       c5 a0 26 bf 93 e9 a1 fd ff ff <0f> 0b e9 fd fc ff
>       ff 65 8b 05 fa b7 90 6d 89 c0 48 0f a3 05 60 91
> RSP: 0018:ffffbc60026ffaf8 EFLAGS: 00010202
> RAX: 0000000000000001 RBX: ffff9d81657d4110 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000006cc7987bcf RDI: ffff9d81657d4110
> RBP: ffffbc60026ffb58 R08: 0000000000000001 R09: 0000000000000010
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000006cc7987bcf
> R13: 0000000000000000 R14: 0000006cc7987bcf R15: ffffbc60026d6a00
> FS: 00007f401daed700(0000) GS:ffff9d81ffa40000(0000) knlGS:0000000000000000
> CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000ffffffff CR3: 0000000fa7574000 CR4: 00000000003426e0
> Call Trace:
> ? kvm_release_pfn_clean+0x22/0x60 [kvm]
> start_sw_timer+0x85/0x230 [kvm]
> ? vmx_vmexit+0x1b/0x30 [kvm_intel]
> kvm_lapic_switch_to_sw_timer+0x72/0x80 [kvm]
> vmx_pre_block+0x1cb/0x260 [kvm_intel]
> ? vmx_vmexit+0xf/0x30 [kvm_intel]
> ? vmx_vmexit+0x1b/0x30 [kvm_intel]
> ? vmx_vmexit+0xf/0x30 [kvm_intel]
> ? vmx_vmexit+0x1b/0x30 [kvm_intel]
> ? vmx_vmexit+0xf/0x30 [kvm_intel]
> ? vmx_vmexit+0x1b/0x30 [kvm_intel]
> ? vmx_vmexit+0xf/0x30 [kvm_intel]
> ? vmx_vmexit+0xf/0x30 [kvm_intel]
> ? vmx_vmexit+0x1b/0x30 [kvm_intel]
> ? vmx_vmexit+0xf/0x30 [kvm_intel]
> ? vmx_vmexit+0x1b/0x30 [kvm_intel]
> ? vmx_vmexit+0xf/0x30 [kvm_intel]
> ? vmx_vmexit+0x1b/0x30 [kvm_intel]
> ? vmx_vmexit+0xf/0x30 [kvm_intel]
> ? vmx_vmexit+0x1b/0x30 [kvm_intel]
> ? vmx_vmexit+0xf/0x30 [kvm_intel]
> ? vmx_sync_pir_to_irr+0x9e/0x100 [kvm_intel]
> ? kvm_apic_has_interrupt+0x46/0x80 [kvm]
> kvm_arch_vcpu_ioctl_run+0x85b/0x1fa0 [kvm]
> ? _raw_spin_unlock_irqrestore+0x18/0x50
> ? _copy_to_user+0x2c/0x30
> kvm_vcpu_ioctl+0x235/0x660 [kvm]
> ? rt_spin_unlock+0x2c/0x50
> do_vfs_ioctl+0x3e4/0x650
> ? __fget+0x7a/0xa0
> ksys_ioctl+0x67/0x90
> __x64_sys_ioctl+0x1a/0x20
> do_syscall_64+0x4d/0x120
> entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x7f4027cc54a7
> Code: 00 00 90 48 8b 05 e9 59 0c 00 64 c7 00 26 00 00
>       00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00
>       00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff
>       73 01 c3 48 8b 0d b9 59 0c 00 f7 d8 64 89 01 48
> RSP: 002b:00007f401dae9858 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00005558bd029690 RCX: 00007f4027cc54a7
> RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 000000000000000d
> RBP: 00007f4028b72000 R08: 00005558bc829ad0 R09: 00000000ffffffff
> R10: 00005558bcf90ca0 R11: 0000000000000246 R12: 0000000000000000
> R13: 0000000000000000 R14: 0000000000000000 R15: 00005558bce1c840
> --[ end trace 0000000000000002 ]--
> 
> Signed-off-by: He Zhe <zhe.he@windriver.com>
> ---
>  arch/x86/kvm/lapic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index e3099c6..929511e 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1715,7 +1715,7 @@ static void start_sw_period(struct kvm_lapic *apic)
>  
>  	hrtimer_start(&apic->lapic_timer.timer,
>  		apic->lapic_timer.target_expiration,
> -		HRTIMER_MODE_ABS);
> +		HRTIMER_MODE_ABS_HARD);
>  }
>  
>  bool kvm_lapic_hv_timer_in_use(struct kvm_vcpu *vcpu)
> 

Queued, thanks.

Paolo

