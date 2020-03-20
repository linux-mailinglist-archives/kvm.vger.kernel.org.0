Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36B4818C807
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 08:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbgCTHN2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 03:13:28 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:38402 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgCTHN1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 03:13:27 -0400
Received: by mail-oi1-f196.google.com with SMTP id k21so5505166oij.5;
        Fri, 20 Mar 2020 00:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nus3/Oxhup1mA4rIPM1vWTISc0W/aM8ttpO1+GX9e+s=;
        b=je4H4XALva/9h69wXhWHLip6eWIDnW96x4PZ6q5hQtPh/WpRWdFAyAj1IaQIZX5fJ2
         93AQUFtvBabkFiT9sziM06PidkqmfgdJDuQodRs7Pd6hoJZtDnbUY7zVrpv407KDl536
         b3oPY0i8D8MsWN/qfp51ull2k5Qn7nOfyykIWfCaQVC4nJwHeQ8g5BkoEnfWgMsUCg/e
         B1nh2Ldifh1LXTXmOJHlfA9KEUp6BVMdE9qiAiX9sgfxUGfRMY4jSdIzOMr7qy4G/tZe
         TdWSvt18GjIfMbeuf3dR/z0j6PwmavKLlcD0QCEcI2bh/xIvW/GGo/IeM4RfNtQ3hbvv
         sjIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nus3/Oxhup1mA4rIPM1vWTISc0W/aM8ttpO1+GX9e+s=;
        b=fu4bXDGFMHDFFGn7O1QbtkNbs+Qp2LQz/FMVf3o12WHaheq06EbdRC4DziMONTuUun
         Nylo9XaAI8/C+tpXwwgNybNZhzhFD+zxl3eatii2XEHu3jyl+64yrbMmNOOXxhj2+T/i
         ntj2lVtaQD0sDaOcPmAIqX29TBT64MzK3jqcCjah1gyn23cRULbI4QjrPMWBg94gf8Rl
         2SwqTROUFhpPv5/fVbUaY9GFJWYVXChSOjoGQo9AMEVd83oHivCfa9MRdHmwKSV9yE0f
         I+sV6XUfNwJLDQQPUkgRR9Jr29m6KuLf7hqF8uQCjHVkibcbDVFXHPkVrO6Z2jtpfdxh
         W4BA==
X-Gm-Message-State: ANhLgQ23JAFhvvs0WIa3jJ38/L5WVoRj9pXVBTFc6h4pZABtNyDa5kJe
        uujh8xGnn+qq0XFamLPZ4BOuGQKnj6kHj97BsdM=
X-Google-Smtp-Source: ADFU+vugXzr8b7e3gXVDsichbHX3oi7rs0aJ+TbPlvNRlI/11+aRPEJC2tf96cTD9wompyk+YHlhR4h4baCw+EYhqeQ=
X-Received: by 2002:aca:5f09:: with SMTP id t9mr5503594oib.5.1584688405741;
 Fri, 20 Mar 2020 00:13:25 -0700 (PDT)
MIME-Version: 1.0
References: <1584687967-332859-1-git-send-email-zhe.he@windriver.com>
In-Reply-To: <1584687967-332859-1-git-send-email-zhe.he@windriver.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 20 Mar 2020 15:13:14 +0800
Message-ID: <CANRm+Cxq22-Ygxpx18zLSLc2S_gh89S62pLJUaVUHVX2Gwiehg@mail.gmail.com>
Subject: Re: [PATCH] KVM: LAPIC: Mark hrtimer for period or oneshot mode to
 expire in hard interrupt context
To:     zhe.he@windriver.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        kvm <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Sebastian Sewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 20 Mar 2020 at 15:10, <zhe.he@windriver.com> wrote:
>
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

Reviewed-by: Wanpeng Li <wanpengli@tencent.com>

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
>         hrtimer_start(&apic->lapic_timer.timer,
>                 apic->lapic_timer.target_expiration,
> -               HRTIMER_MODE_ABS);
> +               HRTIMER_MODE_ABS_HARD);
>  }
>
>  bool kvm_lapic_hv_timer_in_use(struct kvm_vcpu *vcpu)
> --
> 2.7.4
>
