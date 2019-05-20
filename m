Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5723239DC
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 16:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732806AbfETOXq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 10:23:46 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38762 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732785AbfETOXp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 10:23:45 -0400
Received: by mail-wr1-f67.google.com with SMTP id d18so14858562wrs.5
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 07:23:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LDnI6wJquhgWYOFHoUonm3c+UK0Uz3h26k8vckCjAHA=;
        b=BR0qKghqTh7cwF1ZLP0m8nS75UJKG6g71Cy43yAN0Dcpd7vkaH5326smY0goE/WAxU
         cKn6YuKDM02I51YwLM6GpmP0ZiTromjWRvhGK3wA0U6hc9Ada/HN85H1wJnG+eQXh9WM
         NYjONbIdQqZr5yYf/UiqGVQWY18MZ7xSdb4ZrQLLzOqGP20Gd7CIZ6b/lt3WgQainyiB
         +1BxBigcWleNYhnGvRJ72/z8c/nnYuDi5dVma2k856csNziUmiqSelXcvuASxD7MgCJ0
         IlOVe8L3WVXbubVryyBtP/n7eKj/YlbM5Nk6rt0W6aPugz1AWATKqQR8h0PWsbK7X4lt
         9Fgw==
X-Gm-Message-State: APjAAAU7XSqXqs0eZJXb67zA9Ms+26U21Ozc3cCqGZaZAf9rKu2lIfv7
        5rob/7V552BmgZW81nmWPA8qVMVruluh3A==
X-Google-Smtp-Source: APXvYqy51Jsd+5IJ3uSCECLtpRmhr62aaxmUNpOUSYlUn3MarDvA45O+JXMijlUOP5d8vSAIoact2w==
X-Received: by 2002:a5d:4907:: with SMTP id x7mr33171687wrq.199.1558362224446;
        Mon, 20 May 2019 07:23:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac04:eef9:b257:b844? ([2001:b07:6468:f312:ac04:eef9:b257:b844])
        by smtp.gmail.com with ESMTPSA id f16sm15101500wrx.58.2019.05.20.07.23.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 07:23:43 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2] x86: Set "APIC Software Enable" after
 APIC reset
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     kvm@vger.kernel.org, rkrcmar@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20190518154855.3604-1-nadav.amit@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <082d3823-96db-6048-18c6-2bf5f10287fa@redhat.com>
Date:   Mon, 20 May 2019 16:23:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190518154855.3604-1-nadav.amit@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/05/19 17:48, Nadav Amit wrote:
> After the APIC is reset, some of its registers might be reset. As the
> SDM says: "When IA32_APIC_BASE[11] is set to 0, prior initialization to
> the APIC may be lost and the APIC may return to the state described in
> Section 10.4.7.1". The SDM also says that after APIC reset "the
> spurious-interrupt vector register is initialized to 000000FFH". This
> means that after the APIC is reset it needs to be software-enabled
> through the SPIV.
> 
> This is done one occasion, but there are other occasions that do not
> software-enable the APIC after reset (e.g., __test_apic_id() and main()
> in vmx.c). Reenable software-enable APIC in these cases.
> 
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> 
> ---
> 
> v1->v2: Change 0xf0 to APIC_SPIV in one occasion [Krish]
> ---
>  lib/x86/apic.c | 3 ++-
>  x86/apic.c     | 1 -
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/x86/apic.c b/lib/x86/apic.c
> index 2aeffbd..d4528bd 100644
> --- a/lib/x86/apic.c
> +++ b/lib/x86/apic.c
> @@ -161,6 +161,7 @@ void reset_apic(void)
>  {
>      disable_apic();
>      wrmsr(MSR_IA32_APICBASE, rdmsr(MSR_IA32_APICBASE) | APIC_EN);
> +    apic_write(APIC_SPIV, 0x1ff);
>  }
>  
>  u32 ioapic_read_reg(unsigned reg)
> @@ -219,7 +220,7 @@ void set_irq_line(unsigned line, int val)
>  void enable_apic(void)
>  {
>      printf("enabling apic\n");
> -    xapic_write(0xf0, 0x1ff); /* spurious vector register */
> +    xapic_write(APIC_SPIV, 0x1ff);
>  }
>  
>  void mask_pic_interrupts(void)
> diff --git a/x86/apic.c b/x86/apic.c
> index 3eff588..7ef4a27 100644
> --- a/x86/apic.c
> +++ b/x86/apic.c
> @@ -148,7 +148,6 @@ static void test_apic_disable(void)
>      verify_disabled_apic_mmio();
>  
>      reset_apic();
> -    apic_write(APIC_SPIV, 0x1ff);
>      report("Local apic enabled in xAPIC mode",
>  	   (rdmsr(MSR_IA32_APICBASE) & (APIC_EN | APIC_EXTD)) == APIC_EN);
>      report("CPUID.1H:EDX.APIC[bit 9] is set", cpuid(1).d & (1 << 9));
> 

Queued, thanks.

Paolo
