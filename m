Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE6D454EC3
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 21:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236410AbhKQUx0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 15:53:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbhKQUx0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 15:53:26 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E6AC061570
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 12:50:27 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id g19so3782956pfb.8
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 12:50:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ICT5nm0AaEkcwcRtYLxy19E9qWThqJpOXj3qwEYWH/U=;
        b=YY1XtIprpNM5LCnfuA8Ol2j1xAKhTvZb/9h4I6b+Pt33qQ7dnDxi02qaqHMtHpV+CX
         TskOFQQosvjpyAfPwyF/y9yAIydJfb24Q1ePj8uky59qaeUYEz+Cu5JYe8whodV5Cqki
         hYvaj3lkxiJTpPECSNSiH92ySs5NDsoIvS6o76lD5XMI361+xQp0DHnB5WrUd+VqhWWA
         TgM6V0FT+/4rABcpwCxWQQfwD7b2ERtot/3BeOoj9pGBHgNXOrGsbVkDlUGME7fgGQHf
         CBk7s2w+5fr2YmzcDl55wSQYp/l69L5A6rqf/1eo3HUGkarhzR+3bTy/nCWWQwBRXNrc
         Jf5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ICT5nm0AaEkcwcRtYLxy19E9qWThqJpOXj3qwEYWH/U=;
        b=IcRlH+00m76Le7l2yn+p37u0NX5YgvqiZi2FNDictfuo0Dh6ermXUVj4nD9RQuDx52
         +guj3M0CqKFDzyobAB85rANfgELN5TK6iOxexW3g35dPVZ1l7Wt8eZcrE06YN+waw4J2
         6dihHBWwFqj1SIJue0XG8yBuElTcLQ70w1BFgMAaDwiJV4p3HeDFsoCg+aaRFTRo6Kfj
         GDB8OoPBQn+nFsq05uN9Yij/pEYfkwYi708af09y6USBQiz/j4+G+Cs3wzzvHi959ZdS
         9uN3q6Ol2hYGuVVfiYhzR5qvREZYg+ZZ/9fr8pWboeAShBnoektVYTxKW/ccIkeRi8SP
         ob4w==
X-Gm-Message-State: AOAM532qsYQZewxgSMJjYd1KbxyykG/epoJOHlILyS7mTr7EA9OJNf0O
        QNLE6/OoZwQgR6p4OpEdcgYmCQ==
X-Google-Smtp-Source: ABdhPJzRitWfpIl9ERHa7VOvprmzRlXkuSUeEoOIfJVAqgkJrzvVHfn5EsbuXOLPyfDRozB0oWix1Q==
X-Received: by 2002:a63:155d:: with SMTP id 29mr7106745pgv.302.1637182226543;
        Wed, 17 Nov 2021 12:50:26 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m18sm552007pfk.68.2021.11.17.12.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 12:50:26 -0800 (PST)
Date:   Wed, 17 Nov 2021 20:50:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3 3/4] x86/kvm: add max number of vcpus for hyperv
 emulation
Message-ID: <YZVrDpjW0aZjFxo1@google.com>
References: <20211116141054.17800-1-jgross@suse.com>
 <20211116141054.17800-4-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211116141054.17800-4-jgross@suse.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 16, 2021, Juergen Gross wrote:
> When emulating Hyperv the theoretical maximum of vcpus supported is
> 4096, as this is the architectural limit for sending IPIs via the PV
> interface.
> 
> For restricting the actual supported number of vcpus for that case
> introduce another define KVM_MAX_HYPERV_VCPUS and set it to 1024, like
> today's KVM_MAX_VCPUS. Make both values unsigned ones as this will be
> needed later.
> 
> The actual number of supported vcpus for Hyperv emulation will be the
> lower value of both defines.
> 
> This is a preparation for a future boot parameter support of the max
> number of vcpus for a KVM guest.
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---
> V3:
> - new patch
> ---
>  arch/x86/include/asm/kvm_host.h |  3 ++-
>  arch/x86/kvm/hyperv.c           | 15 ++++++++-------
>  2 files changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 886930ec8264..8ea03ff01c45 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -38,7 +38,8 @@
>  
>  #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
>  
> -#define KVM_MAX_VCPUS 1024
> +#define KVM_MAX_VCPUS 1024U
> +#define KVM_MAX_HYPERV_VCPUS 1024U

I don't see any reason to put this in kvm_host.h, it should never be used outside
of hyperv.c.

>  #define KVM_MAX_VCPU_IDS kvm_max_vcpu_ids()
>  /* memory slots that are not exposed to userspace */
>  #define KVM_PRIVATE_MEM_SLOTS 3
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 4a555f32885a..c0fa837121f1 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -41,7 +41,7 @@
>  /* "Hv#1" signature */
>  #define HYPERV_CPUID_SIGNATURE_EAX 0x31237648
>  
> -#define KVM_HV_MAX_SPARSE_VCPU_SET_BITS DIV_ROUND_UP(KVM_MAX_VCPUS, 64)
> +#define KVM_HV_MAX_SPARSE_VCPU_SET_BITS DIV_ROUND_UP(KVM_MAX_HYPERV_VCPUS, 64)
>  
>  static void stimer_mark_pending(struct kvm_vcpu_hv_stimer *stimer,
>  				bool vcpu_kick);
> @@ -166,7 +166,7 @@ static struct kvm_vcpu *get_vcpu_by_vpidx(struct kvm *kvm, u32 vpidx)
>  	struct kvm_vcpu *vcpu = NULL;
>  	int i;
>  
> -	if (vpidx >= KVM_MAX_VCPUS)
> +	if (vpidx >= min(KVM_MAX_VCPUS, KVM_MAX_HYPERV_VCPUS))

IMO, this is conceptually wrong.  KVM should refuse to allow Hyper-V to be enabled
if the max number of vCPUs exceeds what can be supported, or should refuse to create
the vCPUs.  I agree it makes sense to add a Hyper-V specific limit, since there are
Hyper-V structures that have a hard limit, but detection of violations should be a
BUILD_BUG_ON, not a silent failure at runtime.
