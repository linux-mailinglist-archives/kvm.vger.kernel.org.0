Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 433E442F6FD
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 17:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240952AbhJOP0k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 11:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233156AbhJOP0j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 11:26:39 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7546BC061762
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 08:24:33 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id q10-20020a17090a1b0a00b001a076a59640so7505290pjq.0
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 08:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2el1wBIdx4TGzNhRzDaHytILcWWNyw9UG65A/X8JUoo=;
        b=LQOmtUysXNdUFpPqglFGKKKwQob2Rat45tHAcSJKy0TLMsP9H8XRmO6T21biFNGGqM
         a5BFGyuHTLifN8s0J4bSUK4avhEzf6rhR80ETykDpNi33QwXENV3lV2l60FvoflpDLj8
         vHu36ZXSH+tU+G+ecbghNbeaCKd+dKNLpbdZ+qKtOTe0qHRHHWSIwmuKw8vQCJLFxTL9
         9exyCrGWss+LKmVNWf6KV91JZIi8MQXdIzwsWwc9EAf18jvtRs2K5fs1Dt+3rj6JQ1vB
         31jOeUdbkMlThbKRXipy4RJ3RFLWwITGDXo9h52JLZXJpzo/jg4Ry82ouEHQ4tDVFA9c
         2D3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2el1wBIdx4TGzNhRzDaHytILcWWNyw9UG65A/X8JUoo=;
        b=10yUP7TXJ+Uc/o2xxJVSzESuU72OWjcIPn15KTxKvlfX3NKRreYv9cRnHQX3yOnPcj
         ctRj8KmFf1gOOz6kLx3Xzh2xYWBt5TkFaaPIy0o/20GBeVSc2M4ffy3c3hFBf/8ACUgF
         HxOTIbT8uQr9JGCcXjFE9k/dyOXFhpqirskld+EuEfvOVb2cBP99wbahMYe9e/eQRNSo
         qFnN3UZsbKrQ2Ref+9/IX1VEYM2wybH7Obn51Ywhe2wQrGl1AF38bemN93OhQCOIIXgK
         DQGAnMddyg/UqWqtM8k03on/8dQ9JZgnVQPjynNp5WQXEfFAWLoo1GvjxFc8HwKSJsTQ
         iVLw==
X-Gm-Message-State: AOAM531QRdVO0wauF7C6e1W7XMaea4Y76SI7xsrW1zYqBVMGTLvBUuwo
        K8cp40V6/4hYVA4uLLYSHIt9yg==
X-Google-Smtp-Source: ABdhPJwDCyeHqh5AWou0vyYclGHKCsH03HM8KWthWDRZEkbLQMPNiHKRLeJR+JBGwagC3Z5W3mszlQ==
X-Received: by 2002:a17:90a:b706:: with SMTP id l6mr28465203pjr.200.1634311472685;
        Fri, 15 Oct 2021 08:24:32 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x7sm5292267pfj.28.2021.10.15.08.24.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 08:24:32 -0700 (PDT)
Date:   Fri, 15 Oct 2021 15:24:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Matlack <dmatlack@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] KVM: SVM: reduce guest MAXPHYADDR by one in case
 C-bit is a physical bit
Message-ID: <YWmdLPsa6qccxtEa@google.com>
References: <20211015150524.2030966-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211015150524.2030966-1-vkuznets@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 15, 2021, Vitaly Kuznetsov wrote:
> Several selftests (memslot_modification_stress_test, kvm_page_table_test,
> dirty_log_perf_test,.. ) which rely on vm_get_max_gfn() started to fail
> since commit ef4c9f4f65462 ("KVM: selftests: Fix 32-bit truncation of
> vm_get_max_gfn()") on AMD EPYC 7401P:
> 
>  ./tools/testing/selftests/kvm/demand_paging_test
>  Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
>  guest physical test memory offset: 0xffffbffff000

This look a lot like the signature I remember from the original bug[1].  I assume
you're hitting the magic HyperTransport region[2].  I thought that was fixed, but
the hack-a-fix for selftests never got applied[3].

[1] https://lore.kernel.org/lkml/20210623230552.4027702-4-seanjc@google.com/
[2] https://lkml.kernel.org/r/7e3a90c0-75a1-b8fe-dbcf-bda16502ace9@amd.com
[3] https://lkml.kernel.org/r/20210805105423.412878-1-pbonzini@redhat.com

>  Finished creating vCPUs and starting uffd threads
>  Started all vCPUs
>  ==== Test Assertion Failure ====
>    demand_paging_test.c:63: false
>    pid=47131 tid=47134 errno=0 - Success
>       1	0x000000000040281b: vcpu_worker at demand_paging_test.c:63
>       2	0x00007fb36716e431: ?? ??:0
>       3	0x00007fb36709c912: ?? ??:0
>    Invalid guest sync status: exit_reason=SHUTDOWN
> 
> The commit, however, seems to be correct, it just revealed an already
> present issue. AMD CPUs which support SEV may have a reduced physical
> address space, e.g. on AMD EPYC 7401P I see:
> 
>  Address sizes:  43 bits physical, 48 bits virtual
> 
> The guest physical address space, however, is not reduced as stated in
> commit e39f00f60ebd ("KVM: x86: Use kernel's x86_phys_bits to handle
> reduced MAXPHYADDR"). This seems to be almost correct, however, APM has one
> more clause (15.34.6):
> 
>   Note that because guest physical addresses are always translated through
>   the nested page tables, the size of the guest physical address space is
>   not impacted by any physical address space reduction indicated in CPUID
>   8000_001F[EBX]. If the C-bit is a physical address bit however, the guest
>   physical address space is effectively reduced by 1 bit.
> 
> Implement the reduction.
> 
> Fixes: e39f00f60ebd (KVM: x86: Use kernel's x86_phys_bits to handle reduced MAXPHYADDR)
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
> - RFC: I may have misdiagnosed the problem as I didn't dig to where exactly
>  the guest crashes.
> ---
>  arch/x86/kvm/cpuid.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 751aa85a3001..04ae280a0b66 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -923,13 +923,20 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		 *
>  		 * If TDP is enabled but an explicit guest MAXPHYADDR is not
>  		 * provided, use the raw bare metal MAXPHYADDR as reductions to
> -		 * the HPAs do not affect GPAs.
> +		 * the HPAs do not affect GPAs. The value, however, has to be
> +		 * reduced by 1 in case C-bit is a physical bit (APM section
> +		 * 15.34.6).
>  		 */
> -		if (!tdp_enabled)
> +		if (!tdp_enabled) {
>  			g_phys_as = boot_cpu_data.x86_phys_bits;
> -		else if (!g_phys_as)
> +		} else if (!g_phys_as) {
>  			g_phys_as = phys_as;
>  
> +			if (kvm_cpu_cap_has(X86_FEATURE_SEV) &&
> +			    (cpuid_ebx(0x8000001f) & 0x3f) < g_phys_as)
> +				g_phys_as -= 1;

This is incorrect, non-SEV guests do not see a reduced address space.  See Tom's
explanation[*]

[*] https://lkml.kernel.org/r/324a95ee-b962-acdf-9bd7-b8b23b9fb991@amd.com

> +		}
> +
>  		entry->eax = g_phys_as | (virt_as << 8);
>  		entry->edx = 0;
>  		cpuid_entry_override(entry, CPUID_8000_0008_EBX);
> -- 
> 2.31.1
> 
