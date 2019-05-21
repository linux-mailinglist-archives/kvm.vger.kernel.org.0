Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5F6924661
	for <lists+kvm@lfdr.de>; Tue, 21 May 2019 05:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbfEUDhV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 23:37:21 -0400
Received: from mga14.intel.com ([192.55.52.115]:26339 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726265AbfEUDhV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 23:37:21 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 May 2019 20:37:20 -0700
X-ExtLoop1: 1
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.239.13.123]) ([10.239.13.123])
  by orsmga006.jf.intel.com with ESMTP; 20 May 2019 20:37:18 -0700
Subject: Re: [PATCH] kvm: x86: refine kvm_get_arch_capabilities()
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
References: <20190419021624.186106-1-xiaoyao.li@linux.intel.com>
From:   Xiaoyao Li <xiaoyao.li@linux.intel.com>
Message-ID: <be5bb1d6-ca22-8480-1bf9-b60b617df8cf@linux.intel.com>
Date:   Tue, 21 May 2019 11:37:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190419021624.186106-1-xiaoyao.li@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ping.

On 4/19/2019 10:16 AM, Xiaoyao Li wrote:
> 1. Using X86_FEATURE_ARCH_CAPABILITIES to enumerate the existence of
> MSR_IA32_ARCH_CAPABILITIES to avoid using rdmsrl_safe().
> 
> 2. Since kvm_get_arch_capabilities() is only used in this file, making
> it static.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@linux.intel.com>
> ---
>   arch/x86/include/asm/kvm_host.h | 1 -
>   arch/x86/kvm/x86.c              | 8 ++++----
>   2 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index a9d03af34030..d4ae67870764 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1526,7 +1526,6 @@ int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_bitmap_low,
>   		    unsigned long ipi_bitmap_high, u32 min,
>   		    unsigned long icr, int op_64_bit);
>   
> -u64 kvm_get_arch_capabilities(void);
>   void kvm_define_shared_msr(unsigned index, u32 msr);
>   int kvm_set_shared_msr(unsigned index, u64 val, u64 mask);
>   
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a0d1fc80ac5a..ba8e269a8cd2 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1205,11 +1205,12 @@ static u32 msr_based_features[] = {
>   
>   static unsigned int num_msr_based_features;
>   
> -u64 kvm_get_arch_capabilities(void)
> +static u64 kvm_get_arch_capabilities(void)
>   {
> -	u64 data;
> +	u64 data = 0;
>   
> -	rdmsrl_safe(MSR_IA32_ARCH_CAPABILITIES, &data);
> +	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))
> +		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, data);
>   
>   	/*
>   	 * If we're doing cache flushes (either "always" or "cond")
> @@ -1225,7 +1226,6 @@ u64 kvm_get_arch_capabilities(void)
>   
>   	return data;
>   }
> -EXPORT_SYMBOL_GPL(kvm_get_arch_capabilities);
>   
>   static int kvm_get_msr_feature(struct kvm_msr_entry *msr)
>   {
> 
