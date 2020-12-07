Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15D732D0B68
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 09:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbgLGIAk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 03:00:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:54312 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725972AbgLGIAk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 03:00:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CE2ECAC90;
        Mon,  7 Dec 2020 07:59:58 +0000 (UTC)
Subject: Re: [RFC PATCH 18/19] target/mips: Restrict some TCG specific
 CPUClass handlers
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paul Burton <paulburton@kernel.org>, kvm@vger.kernel.org,
        Huacai Chen <chenhuacai@kernel.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20201206233949.3783184-1-f4bug@amsat.org>
 <20201206233949.3783184-19-f4bug@amsat.org>
From:   Claudio Fontana <cfontana@suse.de>
Message-ID: <88161f99-aae5-3b80-e8c6-a57d122a28c4@suse.de>
Date:   Mon, 7 Dec 2020 08:59:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201206233949.3783184-19-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/7/20 12:39 AM, Philippe Mathieu-Daudé wrote:
> Restrict the following CPUClass handlers to TCG:
> - do_interrupt

In this patch it seems do_interrupt is changed to be CONFIG_USER_ONLY, it is not restricted to TCG.
Was this desired, should be commented as such?

Also, should the whole function then be #ifdefed out in helpers.c?
I guess I am vouching for moving the ifndef CONFIG_USER_ONLY one line up in helpers.c.

But you wanted this CONFIG_TCG-only?


> - do_transaction_failed
> - do_unaligned_access
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
> Cc: Claudio Fontana <cfontana@suse.de>
> 
>  target/mips/cpu.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/target/mips/cpu.c b/target/mips/cpu.c
> index 8a4486e3ea1..03bd35b7903 100644
> --- a/target/mips/cpu.c
> +++ b/target/mips/cpu.c
> @@ -483,7 +483,6 @@ static void mips_cpu_class_init(ObjectClass *c, void *data)
>  
>      cc->class_by_name = mips_cpu_class_by_name;
>      cc->has_work = mips_cpu_has_work;
> -    cc->do_interrupt = mips_cpu_do_interrupt;
>      cc->cpu_exec_interrupt = mips_cpu_exec_interrupt;
>      cc->dump_state = mips_cpu_dump_state;
>      cc->set_pc = mips_cpu_set_pc;
> @@ -491,8 +490,7 @@ static void mips_cpu_class_init(ObjectClass *c, void *data)
>      cc->gdb_read_register = mips_cpu_gdb_read_register;
>      cc->gdb_write_register = mips_cpu_gdb_write_register;
>  #ifndef CONFIG_USER_ONLY
> -    cc->do_transaction_failed = mips_cpu_do_transaction_failed;
> -    cc->do_unaligned_access = mips_cpu_do_unaligned_access;
> +    cc->do_interrupt = mips_cpu_do_interrupt;
>      cc->get_phys_page_debug = mips_cpu_get_phys_page_debug;
>      cc->vmsd = &vmstate_mips_cpu;
>  #endif
> @@ -500,6 +498,10 @@ static void mips_cpu_class_init(ObjectClass *c, void *data)
>  #ifdef CONFIG_TCG
>      cc->tcg_initialize = mips_tcg_init;
>      cc->tlb_fill = mips_cpu_tlb_fill;
> +#if !defined(CONFIG_USER_ONLY)
> +    cc->do_unaligned_access = mips_cpu_do_unaligned_access;
> +    cc->do_transaction_failed = mips_cpu_do_transaction_failed;
> +#endif /* CONFIG_TCG && !CONFIG_USER_ONLY */
>  #endif
>  
>      cc->gdb_num_core_regs = 73;
> 

