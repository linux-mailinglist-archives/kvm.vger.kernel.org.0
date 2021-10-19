Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1207443417A
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 00:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbhJSWkX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 18:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbhJSWkW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 18:40:22 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37E6C061746
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 15:38:09 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id y1so14724956plk.10
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 15:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gv9iKD/051YBgWPPhC/HTFIzqkllsYUHNPUYQDNnqYs=;
        b=pNd338bWlykLi5uoiRwWPRZo1qKvRgN06IYDn+bXiSvHZZmFFTBm80Jr+8jA8SlRVH
         nzcQsWW/ijMRHO/5n97jsVfHbzX22NB07xJ55MUcMu6HWAt3tlup3H2KGWkEJeKb9Sw+
         EE6eadYJsFLZFYa8dBVSiZ2JNFLf1q1j1iagGLIxDsvKsbbhqlHO237BQnURwDx5q17q
         zsWScr4A+QTtsGjcdZdtK+0aBiBCgJUrqiY/7sZNzTBykMKkKVnR7zJW27yFwrAAlC1K
         Obc4212YAYxBs9uILLwz947JuYeYLZNLDEyz/DTln1jkV3B3mxORuh/vWnezKFdAYwMU
         27PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gv9iKD/051YBgWPPhC/HTFIzqkllsYUHNPUYQDNnqYs=;
        b=P50t8BOOVgGj98Et8zOKAyjeozxi0pFkLCQUZMF1+ykg4IBjLN6qZc79OM2FgY4YKT
         emKW3GfcrFrUDZvIrjftyShngG/X+0rh2l0CkxB9mzRjhV7Y4TsZ/Z5Xiu4M4CaW0jac
         c4dMORy4EQh9AQT71NHJ25sQFjuX3Qtw9YbPGS8QOAc0yFkePmq1tPsA0J3MrFUj/962
         VOV7Ot1+lxFmMZ50GUfe5R5kVx76n2DEYdkY27ZNxpRxARksJq9am8uX+0krvF8BphBA
         ojrR6R68S7K/2HLkKJFrBdZMj9a9C8y+QlSwPV3ne0tLpTLYd683rP9V0OiZwZrDay2y
         Wriw==
X-Gm-Message-State: AOAM531oE4IrwCBZT6U8LJvVi918DuIyl60Tdnt4/qKwCR8qf2KDYksA
        JCuGyfNKyipyl0d/kTgMKXd9dQ==
X-Google-Smtp-Source: ABdhPJz270E8Q6Pz7mxLjGAwMV7RPMg0UY5qQ4z1CzEDyexYE30SUGEmQomRdvceBW5dyNmF1zNMYA==
X-Received: by 2002:a17:902:900c:b0:13f:974c:19b0 with SMTP id a12-20020a170902900c00b0013f974c19b0mr25710961plp.12.1634683088938;
        Tue, 19 Oct 2021 15:38:08 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b18sm255135pfl.24.2021.10.19.15.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 15:38:08 -0700 (PDT)
Date:   Tue, 19 Oct 2021 22:38:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 04/13] KVM: x86: Move n_memslots_pages recalc to
 kvm_arch_prepare_memory_region()
Message-ID: <YW9IzAQuQ+oMP61N@google.com>
References: <cover.1632171478.git.maciej.szmigiero@oracle.com>
 <2a4ceee16546deeab7090efea2ee9c0db5444b84.1632171479.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a4ceee16546deeab7090efea2ee9c0db5444b84.1632171479.git.maciej.szmigiero@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 20, 2021, Maciej S. Szmigiero wrote:
> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> 
> This allows us to return a proper error code in case we spot an underflow.
> 
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> ---
>  arch/x86/kvm/x86.c | 49 ++++++++++++++++++++++++++--------------------
>  1 file changed, 28 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 97d86223427d..0fffb8414009 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11511,9 +11511,23 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>  				const struct kvm_userspace_memory_region *mem,
>  				enum kvm_mr_change change)
>  {
> -	if (change == KVM_MR_CREATE || change == KVM_MR_MOVE)
> -		return kvm_alloc_memslot_metadata(kvm, new,
> -						  mem->memory_size >> PAGE_SHIFT);
> +	if (change == KVM_MR_CREATE || change == KVM_MR_MOVE) {
> +		int ret;
> +
> +		ret = kvm_alloc_memslot_metadata(kvm, new,
> +						 mem->memory_size >> PAGE_SHIFT);
> +		if (ret)
> +			return ret;
> +
> +		if (change == KVM_MR_CREATE)
> +			kvm->arch.n_memslots_pages += new->npages;
> +	} else if (change == KVM_MR_DELETE) {
> +		if (WARN_ON(kvm->arch.n_memslots_pages < old->npages))
> +			return -EIO;

This is not worth the churn.  In a way, it's worse because userspace can spam
the living snot out of the kernel log by retrying the ioctl().

Since underflow can happen if and only if there's a KVM bug, and a pretty bad one
at that, just make the original WARN_ON a KVM_BUG_ON.  That will kill the VM and
also provide the WARN_ON_ONCE behavior that we probably want.

> +
> +		kvm->arch.n_memslots_pages -= old->npages;
> +	}
> +
>  	return 0;
>  }
>  
