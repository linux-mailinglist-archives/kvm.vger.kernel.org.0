Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A10DC34CE2
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 18:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbfFDQJZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 12:09:25 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36044 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728166AbfFDQJU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 12:09:20 -0400
Received: by mail-wm1-f66.google.com with SMTP id v22so676841wml.1
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2019 09:09:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i2GOZSsboUyjyadR02A1xcM2g/DGUFQmrqakyY+cAKw=;
        b=aLPf9xVVZ3pPlmeRg7Q3I+wTQQpeU8kd1kgR/y5JiN3lIfkqQCC+q3bikRbRCfXrsD
         s9wI1TDiQii5amSCo+YovUv0L1tdR40N7JlkRWkJaffedk+vNeKBssTCFf3eKIowgsWk
         wg3VWbeNUM18OSwYJhtfXTI97a6Ei3Sm0ysfKs0QFknVv0rpCGcORF8f2vEJYEkO82NV
         QFGrG4oFGqT+CbQAPkD5R7IwtahStajWAXuMUSUMim6FIlcpzni3n/sbcmrQzD6u7LhV
         VJa9pWviedkJx/aqRSKf7qxQFN1X5I4EsSfhvWpfRSWabFQMAtayIxReDzhI3kc2iD+i
         3VnA==
X-Gm-Message-State: APjAAAXUcJaqaRqNs4nCrILQJd5qxyS7QnGAlzYGs8o6KqlD6tu9mAci
        gwYruxZUw2Sfu5WNrjPiqb2ucA==
X-Google-Smtp-Source: APXvYqxLccJzxQ2PJCZAiaWV3+iHGSvElrpldaQ0nmJ5PhJfuQhfD9kl+GNsCND0u2qWHyIpzpq0sQ==
X-Received: by 2002:a1c:98d6:: with SMTP id a205mr6467195wme.145.1559664558756;
        Tue, 04 Jun 2019 09:09:18 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id d17sm20007242wrx.9.2019.06.04.09.09.17
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 09:09:17 -0700 (PDT)
Subject: Re: [PATCH] kvm: x86: refine kvm_get_arch_capabilities()
To:     Xiaoyao Li <xiaoyao.li@linux.intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
References: <20190419021624.186106-1-xiaoyao.li@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1c653e8d-29d5-3f55-a0a0-c3ee37560650@redhat.com>
Date:   Tue, 4 Jun 2019 18:09:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190419021624.186106-1-xiaoyao.li@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/04/19 04:16, Xiaoyao Li wrote:
> 1. Using X86_FEATURE_ARCH_CAPABILITIES to enumerate the existence of
> MSR_IA32_ARCH_CAPABILITIES to avoid using rdmsrl_safe().
> 
> 2. Since kvm_get_arch_capabilities() is only used in this file, making
> it static.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@linux.intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 1 -
>  arch/x86/kvm/x86.c              | 8 ++++----
>  2 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index a9d03af34030..d4ae67870764 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1526,7 +1526,6 @@ int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_bitmap_low,
>  		    unsigned long ipi_bitmap_high, u32 min,
>  		    unsigned long icr, int op_64_bit);
>  
> -u64 kvm_get_arch_capabilities(void);
>  void kvm_define_shared_msr(unsigned index, u32 msr);
>  int kvm_set_shared_msr(unsigned index, u64 val, u64 mask);
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a0d1fc80ac5a..ba8e269a8cd2 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1205,11 +1205,12 @@ static u32 msr_based_features[] = {
>  
>  static unsigned int num_msr_based_features;
>  
> -u64 kvm_get_arch_capabilities(void)
> +static u64 kvm_get_arch_capabilities(void)
>  {
> -	u64 data;
> +	u64 data = 0;
>  
> -	rdmsrl_safe(MSR_IA32_ARCH_CAPABILITIES, &data);
> +	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))
> +		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, data);
>  
>  	/*
>  	 * If we're doing cache flushes (either "always" or "cond")
> @@ -1225,7 +1226,6 @@ u64 kvm_get_arch_capabilities(void)
>  
>  	return data;
>  }
> -EXPORT_SYMBOL_GPL(kvm_get_arch_capabilities);
>  
>  static int kvm_get_msr_feature(struct kvm_msr_entry *msr)
>  {
> 

Queued, thanks.

Paolo
