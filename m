Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA9C1E11B0
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 17:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404188AbgEYP1G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 11:27:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37350 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2404160AbgEYP1E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 11:27:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590420423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=D//cvB4ccMcU7KW9UZeTWAleysSnbPmlxts0hTz3QMU=;
        b=eXUisQw9YjXCmbyjVS+/gbkH0znmy3p6sxaBvXi69LqER2FMR1WQGb7Y++/Gp6LvFuDx9X
        OSEIAIBrebmb0uWXnS1DT6+MFG+vxJiVNO3xoizQ4Nk4ISdqE1FRfFNhSJ9TnQjlFXchuj
        XYEILfXJpKPWOdG1m/E62/x/XYmpmwE=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-490-vLDf5wndPo-qWHm1hKwg2A-1; Mon, 25 May 2020 11:27:01 -0400
X-MC-Unique: vLDf5wndPo-qWHm1hKwg2A-1
Received: by mail-ed1-f72.google.com with SMTP id c10so7571102edw.17
        for <kvm@vger.kernel.org>; Mon, 25 May 2020 08:27:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=D//cvB4ccMcU7KW9UZeTWAleysSnbPmlxts0hTz3QMU=;
        b=VNTFuWfHPq/SwTkaCxSbDycIvU+xP/N3zS7Wo9290CuYRCCLpGbzgYeJJ/KyXcix/H
         oM3AMRzjX9W01g5UBq1f316f2C7yNv/0x+nET+AoF6gMFxEPO++E6E2HfpA/TJuKjTJG
         helvTTQQymUnzZCv/sYTsZeZ+WbmJf9bS9M4M/XBHo7xG38UZ02g1088zSArIvJh7hK1
         Cew26CYkHbpRsJNHbXfzzNuo1/igUdcB26Wu+lFiupVl1JbrIgNkDJVUIRCGMAy98T8m
         Z4KNNnx57581iPYVrz4wt/oN1amcGyhLc6d2cxt0vHoTN2okxZJe0oIqf2lsfUOgTTBl
         8Bdw==
X-Gm-Message-State: AOAM531QzlM1Q7ye/hP4zRYz/5a5EFBhuHoQX8HP/B7LyX8wv0mqWoL+
        iewIBqC9vyHleKi2Rj6dpTfODwS3X5J6hgrEbD3fXWjdcYiPLvje4JY6P06aHpYYHWG69w/Xmew
        Fw4LyWu6fxQvb
X-Received: by 2002:aa7:c3cb:: with SMTP id l11mr15085923edr.364.1590420420657;
        Mon, 25 May 2020 08:27:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxZJ5nnz6Pm1rUfoN4Xt+hW/+DcDkZEDQAlbclmL9sVABHeTOqcq9oYu+WEZFJdsIkhoWrV9g==
X-Received: by 2002:aa7:c3cb:: with SMTP id l11mr15085907edr.364.1590420420401;
        Mon, 25 May 2020 08:27:00 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id cm26sm15655925edb.87.2020.05.25.08.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 08:26:59 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe\, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen\, Andi" <andi.kleen@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [RFC 10/16] KVM: x86: Enabled protected memory extension
In-Reply-To: <20200522125214.31348-11-kirill.shutemov@linux.intel.com>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com> <20200522125214.31348-11-kirill.shutemov@linux.intel.com>
Date:   Mon, 25 May 2020 17:26:58 +0200
Message-ID: <871rn8827x.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"Kirill A. Shutemov" <kirill@shutemov.name> writes:

> Wire up hypercalls for the feature and define VM_KVM_PROTECTED.
>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  arch/x86/Kconfig     | 1 +
>  arch/x86/kvm/cpuid.c | 3 +++
>  arch/x86/kvm/x86.c   | 9 +++++++++
>  include/linux/mm.h   | 4 ++++
>  4 files changed, 17 insertions(+)
>
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 58dd44a1b92f..420e3947f0c6 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -801,6 +801,7 @@ config KVM_GUEST
>  	select ARCH_CPUIDLE_HALTPOLL
>  	select X86_MEM_ENCRYPT_COMMON
>  	select SWIOTLB
> +	select ARCH_USES_HIGH_VMA_FLAGS
>  	default y
>  	---help---
>  	  This option enables various optimizations for running under the KVM
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 901cd1fdecd9..94cc5e45467e 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -714,6 +714,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  			     (1 << KVM_FEATURE_POLL_CONTROL) |
>  			     (1 << KVM_FEATURE_PV_SCHED_YIELD);
>  
> +		if (VM_KVM_PROTECTED)
> +			entry->eax |=(1 << KVM_FEATURE_MEM_PROTECTED);

Nit: missing space.

> +
>  		if (sched_info_on())
>  			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c17e6eb9ad43..acba0ac07f61 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7598,6 +7598,15 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>  		kvm_sched_yield(vcpu->kvm, a0);
>  		ret = 0;
>  		break;
> +	case KVM_HC_ENABLE_MEM_PROTECTED:
> +		ret = kvm_protect_all_memory(vcpu->kvm);
> +		break;
> +	case KVM_HC_MEM_SHARE:
> +		ret = kvm_protect_memory(vcpu->kvm, a0, a1, false);
> +		break;
> +	case KVM_HC_MEM_UNSHARE:
> +		ret = kvm_protect_memory(vcpu->kvm, a0, a1, true);
> +		break;
>  	default:
>  		ret = -KVM_ENOSYS;
>  		break;
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 4f7195365cc0..6eb771c14968 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -329,7 +329,11 @@ extern unsigned int kobjsize(const void *objp);
>  # define VM_MAPPED_COPY	VM_ARCH_1	/* T if mapped copy of data (nommu mmap) */
>  #endif
>  
> +#if defined(CONFIG_X86_64) && defined(CONFIG_KVM)
> +#define VM_KVM_PROTECTED VM_HIGH_ARCH_4
> +#else
>  #define VM_KVM_PROTECTED 0
> +#endif
>  
>  #ifndef VM_GROWSUP
>  # define VM_GROWSUP	VM_NONE

-- 
Vitaly

