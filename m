Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62ABA2A84BD
	for <lists+kvm@lfdr.de>; Thu,  5 Nov 2020 18:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731594AbgKERUg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 12:20:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60574 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730854AbgKERUf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Nov 2020 12:20:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604596833;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A74c4Q9g1nBt0Ylu7CQA8niTKc2oxLA01JSP+C0l6xM=;
        b=h+F+CX2tSUJRvgO7NlNYw8afEXdCVm11FzkfOqpFlVV5ipGEBLHeFVzG8VnWxgfA4KBR4Q
        4Uou/XTrL0XNKu3+BrlDEjNhpWP33doEXtxM8ZDodi0sXwTNCTqtlKPdN9dWjCUdcLjQCj
        YoBt4Isjr0ck6ujnbTHZh1a7TOO9NBE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-557-8HHn8L-XORSi8_2ZrPjfwg-1; Thu, 05 Nov 2020 12:20:30 -0500
X-MC-Unique: 8HHn8L-XORSi8_2ZrPjfwg-1
Received: by mail-wr1-f72.google.com with SMTP id w6so1004154wrk.1
        for <kvm@vger.kernel.org>; Thu, 05 Nov 2020 09:20:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A74c4Q9g1nBt0Ylu7CQA8niTKc2oxLA01JSP+C0l6xM=;
        b=P6qt8PzERuwTXpHXLr6YnY5Yr0CZS5CZlH03EpK25uAu/cV5LF5lBKaYfUo35BAIjQ
         x2yf0Pf2BkecHqjLCeFsj9LZntlKROLXKTTcFsVsbrtTz0BW2Lj5QlT4xlaqq8CiK987
         Gv35JjKKHD1FYVpNjGegZIycGEzIwQzNzbkB3QPLtuOXqjngMvF1jUzSvdKivRpr1tzl
         zL1lWgHMMjhHZPfpFKBByFCD+Z3vVU9s8pdIJ+tVwWrV9yUCH4QC5SXXTkwBA6PnewMq
         RQs/uBJccciqWT8qVOfkQfUjQVsgoB6Xgku0y019aZHaMId8XSho/wCIm0972FDDsu/f
         iLeg==
X-Gm-Message-State: AOAM532/6Dy88+tIpgsOSymNgsT5zcBvogopSvxqkjsn/oieUH+wikV9
        PqwVP9Kg735V0nHHcTByY7ay1t8YR7FpyzZnoG/z4nzC44jdwp32DQK3Kj5nu5/lyH4Jr+KrMb0
        iuWmIOiOCwsKr
X-Received: by 2002:a1c:7f0f:: with SMTP id a15mr3713557wmd.97.1604596829148;
        Thu, 05 Nov 2020 09:20:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyrgZredQdIK7+ieFbOS9wkGpjUVFJ46T4BeVuLZI0o0rwK+1j8hV+GXok6B8YWvDJ/eg/38A==
X-Received: by 2002:a1c:7f0f:: with SMTP id a15mr3713545wmd.97.1604596828936;
        Thu, 05 Nov 2020 09:20:28 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id d16sm3230032wrw.17.2020.11.05.09.20.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2020 09:20:27 -0800 (PST)
Subject: Re: [PATCH kvm-unit-tests v2 1/3] svm: Add ability to execute test
 via test_run on a vcpu other than vcpu 0
To:     Cathy Avery <cavery@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200717113422.19575-1-cavery@redhat.com>
 <20200717113422.19575-2-cavery@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9e98cbad-97a9-24a6-4ff3-b97b552c03b2@redhat.com>
Date:   Thu, 5 Nov 2020 18:20:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20200717113422.19575-2-cavery@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/07/20 13:34, Cathy Avery wrote:
> When running tests that can result in a vcpu being left in an
> indeterminate state it is useful to be able to run the test on
> a vcpu other than 0. This patch allows test_run to be executed
> on any vcpu indicated by the on_vcpu member of the svm_test struct.
> The initialized state of the vcpu0 registers used to populate the
> vmcb is carried forward to the other vcpus.
> 
> Signed-off-by: Cathy Avery <cavery@redhat.com>
> ---
>   lib/x86/vm.c | 18 ++++++++++++++++++
>   lib/x86/vm.h |  7 +++++++
>   x86/svm.c    | 24 +++++++++++++++++++++++-
>   x86/svm.h    |  2 ++
>   4 files changed, 50 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/x86/vm.c b/lib/x86/vm.c
> index 41d6d96..e223bb4 100644
> --- a/lib/x86/vm.c
> +++ b/lib/x86/vm.c
> @@ -2,6 +2,7 @@
>   #include "libcflat.h"
>   #include "vmalloc.h"
>   #include "alloc_page.h"
> +#include "smp.h"
>   
>   pteval_t *install_pte(pgd_t *cr3,
>   		      int pte_level,
> @@ -139,9 +140,18 @@ static void setup_mmu_range(pgd_t *cr3, phys_addr_t start, size_t len)
>   	install_pages(cr3, phys, max - phys, (void *)(ulong)phys);
>   }
>   
> +static void set_additional_vcpu_vmregs(struct vm_vcpu_info *info)
> +{
> +	write_cr3(info->cr3);
> +	write_cr4(info->cr4);
> +	write_cr0(info->cr0);
> +}
> +
>   void *setup_mmu(phys_addr_t end_of_memory)
>   {
>       pgd_t *cr3 = alloc_page();
> +    struct vm_vcpu_info info;
> +    int i;
>   
>       memset(cr3, 0, PAGE_SIZE);
>   
> @@ -166,6 +176,14 @@ void *setup_mmu(phys_addr_t end_of_memory)
>       printf("cr0 = %lx\n", read_cr0());
>       printf("cr3 = %lx\n", read_cr3());
>       printf("cr4 = %lx\n", read_cr4());
> +
> +    info.cr3 = read_cr3();
> +    info.cr4 = read_cr4();
> +    info.cr0 = read_cr0();
> +
> +    for (i = 1; i < cpu_count(); i++)
> +        on_cpu(i, (void *)set_additional_vcpu_vmregs, &info);
> +
>       return cr3;
>   }
>   
> diff --git a/lib/x86/vm.h b/lib/x86/vm.h
> index 8750a1e..3a1432f 100644
> --- a/lib/x86/vm.h
> +++ b/lib/x86/vm.h
> @@ -45,4 +45,11 @@ static inline void *current_page_table(void)
>   
>   void split_large_page(unsigned long *ptep, int level);
>   void force_4k_page(void *addr);
> +
> +struct vm_vcpu_info {
> +        u64 cr3;
> +        u64 cr4;
> +        u64 cr0;
> +};
> +
>   #endif
> diff --git a/x86/svm.c b/x86/svm.c
> index d8c8272..975c477 100644
> --- a/x86/svm.c
> +++ b/x86/svm.c
> @@ -275,6 +275,17 @@ static void test_run(struct svm_test *test)
>   	irq_enable();
>   
>   	report(test->succeeded(test), "%s", test->name);
> +
> +        if (test->on_vcpu)
> +	    test->on_vcpu_done = true;
> +}
> +
> +static void set_additional_vpcu_msr(void *msr_efer)
> +{
> +	void *hsave = alloc_page();
> +
> +	wrmsr(MSR_VM_HSAVE_PA, virt_to_phys(hsave));
> +	wrmsr(MSR_EFER, (ulong)msr_efer | EFER_SVME | EFER_NX);
>   }
>   
>   static void setup_svm(void)
> @@ -294,6 +305,9 @@ static void setup_svm(void)
>   	if (!npt_supported())
>   		return;
>   
> +	for (i = 1; i < cpu_count(); i++)
> +		on_cpu(i, (void *)set_additional_vpcu_msr, (void *)rdmsr(MSR_EFER));
> +
>   	printf("NPT detected - running all tests with NPT enabled\n");
>   
>   	/*
> @@ -396,7 +410,15 @@ int main(int ac, char **av)
>   		if (svm_tests[i].supported && !svm_tests[i].supported())
>   			continue;
>   		if (svm_tests[i].v2 == NULL) {
> -			test_run(&svm_tests[i]);
> +			if (svm_tests[i].on_vcpu) {
> +				if (cpu_count() <= svm_tests[i].on_vcpu)
> +					continue;
> +				on_cpu_async(svm_tests[i].on_vcpu, (void *)test_run, &svm_tests[i]);
> +				while (!svm_tests[i].on_vcpu_done)
> +					cpu_relax();
> +			}
> +			else
> +				test_run(&svm_tests[i]);
>   		} else {
>   			vmcb_ident(vmcb);
>   			v2_test = &(svm_tests[i]);
> diff --git a/x86/svm.h b/x86/svm.h
> index f8e7429..1e60d52 100644
> --- a/x86/svm.h
> +++ b/x86/svm.h
> @@ -348,6 +348,8 @@ struct svm_test {
>   	ulong scratch;
>   	/* Alternative test interface. */
>   	void (*v2)(void);
> +	int on_vcpu;
> +	bool on_vcpu_done;
>   };
>   
>   struct regs {
> 

Queued, thanks.

Paolo

