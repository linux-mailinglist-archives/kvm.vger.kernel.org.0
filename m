Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD23442227
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 12:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbfFLKRd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 06:17:33 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43887 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727109AbfFLKR3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 06:17:29 -0400
Received: by mail-wr1-f65.google.com with SMTP id p13so6153063wru.10
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2019 03:17:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Kv7LCbEgp/ES7E3A9FpL8uznQf+7YZrzEljrXGATpdE=;
        b=GsxUof4Aq4sMBZjcFSy51CJ3Kip0VKX3a9xaLMbUGLTWmL9tBQGMU2GvnxxBiwrJ7z
         hrYUgdQnYhEP0Kvx8w879hAYHvfDUabf5uK+v3vzZ5TQTWAAPFMuhA7dOCtsZC+/Vw2Q
         /GhAPjuh5sPMr58xY+HNgegaRm0oJbcpTh2vJ2uh1XP0DvO8AEmbgHv8mSum3xw+KYO3
         IO2QiaQQ1gCO4LzAlnqWViw59/MuAgR9NGhKXnzaIg/6SaDPFxFfujiZWl3VspWqEVvj
         xQC2IpsLVCoeZUPs8fqv0kWuyidH3fB3vrYJ1s2LEjol4wjIe12xH4jDqhycYsv0p2jP
         F7Pg==
X-Gm-Message-State: APjAAAWsnC1rBUslKjQf6CbEi03HoV28/0yD6d/86TyfQxuxstu1SZgq
        o+IEHY2n6EAARN7Y0ZB6g0OA9w==
X-Google-Smtp-Source: APXvYqxzPAQxgfE805E8ecOhU0d3jxt3B5r61pAm0pxDc2tqk8vXILX/wSNAPsyKIcVAa7zcSi3nnw==
X-Received: by 2002:adf:e841:: with SMTP id d1mr54673237wrn.204.1560334646423;
        Wed, 12 Jun 2019 03:17:26 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id 32sm39077824wra.35.2019.06.12.03.17.25
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 03:17:25 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org
Cc:     Prasanna Panchamukhi <panchamukhi@arista.com>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Cathy Avery <cavery@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        "Michael Kelley \(EOSG\)" <Michael.H.Kelley@microsoft.com>,
        Mohammed Gamal <mmorsy@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Roman Kagan <rkagan@virtuozzo.com>,
        Sasha Levin <sashal@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        devel@linuxdriverproject.org, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] x86/hyperv: Disable preemption while setting reenlightenment vector
In-Reply-To: <20190611212003.26382-1-dima@arista.com>
References: <20190611212003.26382-1-dima@arista.com>
Date:   Wed, 12 Jun 2019 12:17:24 +0200
Message-ID: <8736kff6q3.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dmitry Safonov <dima@arista.com> writes:

> KVM support may be compiled as dynamic module, which triggers the
> following splat on modprobe:
>
>  KVM: vmx: using Hyper-V Enlightened VMCS
>  BUG: using smp_processor_id() in preemptible [00000000] code: modprobe/466 caller is debug_smp_processor_id+0x17/0x19
>  CPU: 0 PID: 466 Comm: modprobe Kdump: loaded Not tainted 4.19.43 #1
>  Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090007  06/02/2017
>  Call Trace:
>   dump_stack+0x61/0x7e
>   check_preemption_disabled+0xd4/0xe6
>   debug_smp_processor_id+0x17/0x19
>   set_hv_tscchange_cb+0x1b/0x89
>   kvm_arch_init+0x14a/0x163 [kvm]
>   kvm_init+0x30/0x259 [kvm]
>   vmx_init+0xed/0x3db [kvm_intel]
>   do_one_initcall+0x89/0x1bc
>   do_init_module+0x5f/0x207
>   load_module+0x1b34/0x209b
>   __ia32_sys_init_module+0x17/0x19
>   do_fast_syscall_32+0x121/0x1fa
>   entry_SYSENTER_compat+0x7f/0x91

Hm, I never noticed this one, you probably need something like
CONFIG_PREEMPT enabled so see it.

>
> The easiest solution seems to be disabling preemption while setting up
> reenlightment MSRs. While at it, fix hv_cpu_*() callbacks.
>
> Fixes: 93286261de1b4 ("x86/hyperv: Reenlightenment notifications
> support")
>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Cathy Avery <cavery@redhat.com>
> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "K. Y. Srinivasan" <kys@microsoft.com>
> Cc: "Michael Kelley (EOSG)" <Michael.H.Kelley@microsoft.com>
> Cc: Mohammed Gamal <mmorsy@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Cc: Roman Kagan <rkagan@virtuozzo.com>
> Cc: Sasha Levin <sashal@kernel.org>
> Cc: Stephen Hemminger <sthemmin@microsoft.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
>
> Cc: devel@linuxdriverproject.org
> Cc: kvm@vger.kernel.org
> Cc: linux-hyperv@vger.kernel.org
> Cc: x86@kernel.org
> Reported-by: Prasanna Panchamukhi <panchamukhi@arista.com>
> Signed-off-by: Dmitry Safonov <dima@arista.com>
> ---
>  arch/x86/hyperv/hv_init.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
> index 1608050e9df9..0bdd79ecbff8 100644
> --- a/arch/x86/hyperv/hv_init.c
> +++ b/arch/x86/hyperv/hv_init.c
> @@ -91,7 +91,7 @@ EXPORT_SYMBOL_GPL(hv_max_vp_index);
>  static int hv_cpu_init(unsigned int cpu)
>  {
>  	u64 msr_vp_index;
> -	struct hv_vp_assist_page **hvp = &hv_vp_assist_page[smp_processor_id()];
> +	struct hv_vp_assist_page **hvp = &hv_vp_assist_page[cpu];
>  	void **input_arg;
>  	struct page *pg;
>  
> @@ -103,7 +103,7 @@ static int hv_cpu_init(unsigned int cpu)
>  
>  	hv_get_vp_index(msr_vp_index);
>  
> -	hv_vp_index[smp_processor_id()] = msr_vp_index;
> +	hv_vp_index[cpu] = msr_vp_index;
>  
>  	if (msr_vp_index > hv_max_vp_index)
>  		hv_max_vp_index = msr_vp_index;

The above is unrelated cleanup (as cpu == smp_processor_id() for
CPUHP_AP_ONLINE_DYN callbacks), right? As I'm pretty sure these can'd be
preempted.

> @@ -182,7 +182,6 @@ void set_hv_tscchange_cb(void (*cb)(void))
>  	struct hv_reenlightenment_control re_ctrl = {
>  		.vector = HYPERV_REENLIGHTENMENT_VECTOR,
>  		.enabled = 1,
> -		.target_vp = hv_vp_index[smp_processor_id()]
>  	};
>  	struct hv_tsc_emulation_control emu_ctrl = {.enabled = 1};
>  
> @@ -196,7 +195,11 @@ void set_hv_tscchange_cb(void (*cb)(void))
>  	/* Make sure callback is registered before we write to MSRs */
>  	wmb();
>  
> +	preempt_disable();
> +	re_ctrl.target_vp = hv_vp_index[smp_processor_id()];
>  	wrmsrl(HV_X64_MSR_REENLIGHTENMENT_CONTROL, *((u64 *)&re_ctrl));
> +	preempt_enable();
> +

My personal preference would be to do something like
   int cpu = get_cpu();

   ... set things up ...

   put_cpu();

instead, there are no long-running things in the whole function. But
what you've done should work too, so

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

>  	wrmsrl(HV_X64_MSR_TSC_EMULATION_CONTROL, *((u64 *)&emu_ctrl));
>  }
>  EXPORT_SYMBOL_GPL(set_hv_tscchange_cb);

-- 
Vitaly
