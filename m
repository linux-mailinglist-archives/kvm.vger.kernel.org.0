Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE312239E6
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 16:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391542AbfETOYM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 10:24:12 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46956 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732407AbfETOYM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 10:24:12 -0400
Received: by mail-wr1-f68.google.com with SMTP id r7so14803198wrr.13
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 07:24:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nnXZPX4ct7LRLox3/K/IstDBj0VKAIJBiwgu3pREze8=;
        b=pRZoTCwkXDfxM07scJzlTOERkYASD4yppKEtxQevjKTZBOFRDazN3au0pY/huWOvrY
         zXQ6gAnQMLjEtc6443Wf7ieN9YM1/i8anMKbXFL1WIcRDFM4RDzipPDnxdq8XnnqmML5
         AllOFFubLsJbXGVZxVydAweOcd8eHPkMlAY+Uz4x+bQ3j7ZaAgf7XCJYPt+otPcEOj/q
         7VBDLooOa7we1vxaIwQF5ZS1AAJYHSQs4PX9uXZpcdu//C2gDoHlzXokBw3pW/RIpNCz
         15+ShE0LK4vLgSUsfGgg5mhn+xA6wU6kg9gymuntAbuGnRR7AGzp9vUZojMoA3X0LSaR
         078w==
X-Gm-Message-State: APjAAAWh8JvEzOmz98xTsqoUNEwW/3INSD8h4TPjNf+ke0qmSaCsuBKP
        z8/te3aLE7X3MpvmC8nzfVgFHA==
X-Google-Smtp-Source: APXvYqym3KQkyULClSYCzcrtyso4ZbDM9TuNaoRzWJQ4pVVqnrhHSfQMWdKIon47amHw7UDDqzVxeA==
X-Received: by 2002:adf:ab45:: with SMTP id r5mr19837826wrc.100.1558362250160;
        Mon, 20 May 2019 07:24:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac04:eef9:b257:b844? ([2001:b07:6468:f312:ac04:eef9:b257:b844])
        by smtp.gmail.com with ESMTPSA id j82sm27384788wmj.40.2019.05.20.07.24.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 07:24:09 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: Do not run vmx tests if feature is
 unsupported by CPU
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     kvm@vger.kernel.org, rkrcmar@redhat.com
References: <20190518155321.3832-1-nadav.amit@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8c396eba-a905-e3be-4a22-f8169f2c1d38@redhat.com>
Date:   Mon, 20 May 2019 16:24:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190518155321.3832-1-nadav.amit@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/05/19 17:53, Nadav Amit wrote:
> Instruction tests of VMX should not be executed if the feature is
> unsupported by the CPU. Even if the execution controls allow to trap
> exits on the feature, the feature might be disabled, for example through
> IA32_MISC_ENABLES. Therefore, checking that the feature is supported
> through CPUID is needed.
> 
> Introduce a general mechanism to check that a feature is supported and
> use it for monitor/mwait.
> 
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
>  x86/vmx_tests.c | 34 ++++++++++++++++++++++++++++------
>  1 file changed, 28 insertions(+), 6 deletions(-)
> 
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index cade812..bdff938 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -842,6 +842,17 @@ extern void insn_rdseed(void);
>  u32 cur_insn;
>  u64 cr3;
>  
> +#define X86_FEATURE_MONITOR	(1 << 3)
> +#define X86_FEATURE_MCE		(1 << 7)
> +#define X86_FEATURE_PCID	(1 << 17)
> +
> +typedef bool (*supported_fn)(void);
> +
> +static bool monitor_supported(void)
> +{
> +	return cpuid(1).c & X86_FEATURE_MONITOR;
> +}
> +
>  struct insn_table {
>  	const char *name;
>  	u32 flag;
> @@ -853,6 +864,8 @@ struct insn_table {
>  	// Use FIELD_EXIT_QUAL and FIELD_INSN_INFO to define
>  	// which field need to be tested, reason is always tested
>  	u32 test_field;
> +	const supported_fn supported_fn;
> +	u8 disabled;
>  };
>  
>  /*
> @@ -868,7 +881,7 @@ static struct insn_table insn_table[] = {
>  	{"HLT",  CPU_HLT, insn_hlt, INSN_CPU0, 12, 0, 0, 0},
>  	{"INVLPG", CPU_INVLPG, insn_invlpg, INSN_CPU0, 14,
>  		0x12345678, 0, FIELD_EXIT_QUAL},
> -	{"MWAIT", CPU_MWAIT, insn_mwait, INSN_CPU0, 36, 0, 0, 0},
> +	{"MWAIT", CPU_MWAIT, insn_mwait, INSN_CPU0, 36, 0, 0, 0, &monitor_supported},
>  	{"RDPMC", CPU_RDPMC, insn_rdpmc, INSN_CPU0, 15, 0, 0, 0},
>  	{"RDTSC", CPU_RDTSC, insn_rdtsc, INSN_CPU0, 16, 0, 0, 0},
>  	{"CR3 load", CPU_CR3_LOAD, insn_cr3_load, INSN_CPU0, 28, 0x3, 0,
> @@ -881,7 +894,7 @@ static struct insn_table insn_table[] = {
>  	{"CR8 store", CPU_CR8_STORE, insn_cr8_store, INSN_CPU0, 28, 0x18, 0,
>  		FIELD_EXIT_QUAL},
>  #endif
> -	{"MONITOR", CPU_MONITOR, insn_monitor, INSN_CPU0, 39, 0, 0, 0},
> +	{"MONITOR", CPU_MONITOR, insn_monitor, INSN_CPU0, 39, 0, 0, 0, &monitor_supported},
>  	{"PAUSE", CPU_PAUSE, insn_pause, INSN_CPU0, 40, 0, 0, 0},
>  	// Flags for Secondary Processor-Based VM-Execution Controls
>  	{"WBINVD", CPU_WBINVD, insn_wbinvd, INSN_CPU1, 54, 0, 0, 0},
> @@ -904,13 +917,19 @@ static struct insn_table insn_table[] = {
>  
>  static int insn_intercept_init(struct vmcs *vmcs)
>  {
> -	u32 ctrl_cpu;
> +	u32 ctrl_cpu, cur_insn;
>  
>  	ctrl_cpu = ctrl_cpu_rev[0].set | CPU_SECONDARY;
>  	ctrl_cpu &= ctrl_cpu_rev[0].clr;
>  	vmcs_write(CPU_EXEC_CTRL0, ctrl_cpu);
>  	vmcs_write(CPU_EXEC_CTRL1, ctrl_cpu_rev[1].set);
>  	cr3 = read_cr3();
> +
> +	for (cur_insn = 0; insn_table[cur_insn].name != NULL; cur_insn++) {
> +		if (insn_table[cur_insn].supported_fn == NULL)
> +			continue;
> +		insn_table[cur_insn].disabled = !insn_table[cur_insn].supported_fn();
> +	}
>  	return VMX_TEST_START;
>  }
>  
> @@ -928,6 +947,12 @@ static void insn_intercept_main(void)
>  			continue;
>  		}
>  
> +		if (insn_table[cur_insn].disabled) {
> +			printf("\tFeature required for %s is not supported.\n",
> +			       insn_table[cur_insn].name);
> +			continue;
> +		}
> +
>  		if ((insn_table[cur_insn].type == INSN_CPU0 &&
>  		     !(ctrl_cpu_rev[0].set & insn_table[cur_insn].flag)) ||
>  		    (insn_table[cur_insn].type == INSN_CPU1 &&
> @@ -6841,9 +6866,6 @@ static void vmentry_movss_shadow_test(void)
>  	vmcs_write(GUEST_RFLAGS, X86_EFLAGS_FIXED);
>  }
>  
> -#define X86_FEATURE_PCID       (1 << 17)
> -#define X86_FEATURE_MCE        (1 << 7)
> -
>  static int write_cr4_checking(unsigned long val)
>  {
>  	asm volatile(ASM_TRY("1f")
> 

Queued, thanks.

Paolo
