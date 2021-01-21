Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCFF42FDE63
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 02:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389152AbhAUBBr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 20:01:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733271AbhAUAp7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 19:45:59 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7804C061575
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 16:45:18 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id p15so342630pjv.3
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 16:45:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=imFglJdTNeqwJvKeJ4VHNFXKPIrBEHFFa5LkwwJ3IZ4=;
        b=Q1AyKKDlsja1TMOQV5GDSDgMBDo1WtGRYl0lN4Fe7SCs2rDLcDFmDecqwa2+NZq9yQ
         IFw6nMlD9JBvWxqx3EWKpwWg+vK6F+thiYmsZ4TM2Pc75I+7rVGriCGBiO/VhezBn2Js
         fICne8Bu70AGfBC2cjMfQADoRdwNpsJWaf6JFRTN6IeArHUmXgYSqqcZ+h7In42aXQly
         vY+bONJb3YV5NBkzY0GKG6DZti94SYafg4c5l22tLPrX9tWy8rsAm1cPcsjIM0pgVlv3
         LYSOJbuvYqLb2eSv/k8DtpIxEwQrskbZcUEjCfFXbPO3jc2bThZkSeN9z3AWMRj+Hzy5
         04YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=imFglJdTNeqwJvKeJ4VHNFXKPIrBEHFFa5LkwwJ3IZ4=;
        b=DG76PbGne3W3bm7ijeDfgdaO5s7bf71993qqYFDYB+JyIHkimQYrwEBC5fwuSjXWao
         LeoZYpG2oTJT6slCI8hxZfrN7WCp9Fc8lCOz1rgJVJ9VDt9pR0EBLgGcTzbXIgQ5G8tn
         Z1BZpM4zbMgi4GEzs6DxW5XXS4BCPQF2kue1nNwySOVbV78TozssADGJt1uc9NcRIJBn
         0yXD2v1SUvAZGh3ax2D/4ZpIG8d1UocchiuC2gpHXV6jeUQlKT2l1wz9mB7tSgGUiWwe
         f+p0S58CW8zFA8ks8pPj08ZoLxEPuzhnfIeSj8sYvR/qrNCWjvImLI8F5TDKHuy1/2oA
         bRJQ==
X-Gm-Message-State: AOAM530KeESjuj7qDbj7wIwOzq+jZN69vWZ3aKuYpHMMd4pQvX4Kcddp
        gWngnrGuqf4OPT8CzxaQbXWnOw==
X-Google-Smtp-Source: ABdhPJzCGDnEo0qXcF/pkL5IZn00tv7n/BON+4v0sc/MBGNuUK/1SJtP4hIgeT0GCsbxT9aZhU61jg==
X-Received: by 2002:a17:902:7b84:b029:da:60e0:9d38 with SMTP id w4-20020a1709027b84b02900da60e09d38mr12191777pll.55.1611189918149;
        Wed, 20 Jan 2021 16:45:18 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id 145sm3341817pfu.8.2021.01.20.16.45.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 16:45:17 -0800 (PST)
Date:   Wed, 20 Jan 2021 16:45:10 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH 18/24] kvm: x86/mmu: Use an rwlock for the x86 TDP MMU
Message-ID: <YAjOlmhOSkE4YjDE@google.com>
References: <20210112181041.356734-1-bgardon@google.com>
 <20210112181041.356734-19-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112181041.356734-19-bgardon@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 12, 2021, Ben Gardon wrote:
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index ba296ad051c3..280d7cd6f94b 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5471,6 +5471,11 @@ void kvm_mmu_init_vm(struct kvm *kvm)
>  
>  	kvm_mmu_init_tdp_mmu(kvm);
>  
> +	if (kvm->arch.tdp_mmu_enabled)
> +		rwlock_init(&kvm->arch.mmu_rwlock);
> +	else
> +		spin_lock_init(&kvm->arch.mmu_lock);

Rather than use different lock types, what if we always use a rwlock, but only
acquire it for read when handling page faults for TDP MMUs?  That would
significantly reduce the amount of boilerplate conditionals.

The fast paths for write_lock() and spin_lock() are nearly identical, and
I would hope any differences in the slow paths are hidden in the noise.

> +
>  	node->track_write = kvm_mmu_pte_write;
>  	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
>  	kvm_page_track_register_notifier(kvm, node);
> @@ -6074,3 +6079,87 @@ void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
>  	if (kvm->arch.nx_lpage_recovery_thread)
>  		kthread_stop(kvm->arch.nx_lpage_recovery_thread);
>  }
> +
> +void kvm_mmu_lock_shared(struct kvm *kvm)
> +{
> +	WARN_ON(!kvm->arch.tdp_mmu_enabled);
> +	read_lock(&kvm->arch.mmu_rwlock);
> +}
> +
> +void kvm_mmu_unlock_shared(struct kvm *kvm)
> +{
> +	WARN_ON(!kvm->arch.tdp_mmu_enabled);
> +	read_unlock(&kvm->arch.mmu_rwlock);
> +}
> +
> +void kvm_mmu_lock_exclusive(struct kvm *kvm)
> +{
> +	WARN_ON(!kvm->arch.tdp_mmu_enabled);
> +	write_lock(&kvm->arch.mmu_rwlock);
> +}
> +
> +void kvm_mmu_unlock_exclusive(struct kvm *kvm)
> +{
> +	WARN_ON(!kvm->arch.tdp_mmu_enabled);
> +	write_unlock(&kvm->arch.mmu_rwlock);
> +}

I'm not a fan of all of these wrappers.  It's extra layers and WARNs, and
introduces terminology that differs from the kernel's locking terminology,
e.g. read vs. shared.  The WARNs are particularly wasteful as these all have
exactly one caller that explicitly checks kvm->arch.tdp_mmu_enabled.

Even if we don't unconditionally use the rwlock, I think I'd prefer to omit
these rwlock wrappers and instead use read/write_lock directly (and drop the
WARNs). 

> +
> +void kvm_mmu_lock(struct kvm *kvm)
> +{
> +	if (kvm->arch.tdp_mmu_enabled)
> +		kvm_mmu_lock_exclusive(kvm);
> +	else
> +		spin_lock(&kvm->arch.mmu_lock);
> +}
> +EXPORT_SYMBOL_GPL(kvm_mmu_lock);
> +
> +void kvm_mmu_unlock(struct kvm *kvm)
> +{
> +	if (kvm->arch.tdp_mmu_enabled)
> +		kvm_mmu_unlock_exclusive(kvm);
> +	else
> +		spin_unlock(&kvm->arch.mmu_lock);
> +}
> +EXPORT_SYMBOL_GPL(kvm_mmu_unlock);

These exports aren't needed, I don't see any callers in kvm_intel or kvm_amd.
That's a moot point if we use rwlock unconditionally.

> +
