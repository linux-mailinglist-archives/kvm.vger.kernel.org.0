Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBA294418DE
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 10:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234664AbhKAJwk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 05:52:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46263 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232650AbhKAJt3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Nov 2021 05:49:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635760016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GCQW+jtyc2XjG8UWnT8I+n1wYys3/xqxOYsbCwWgH3Y=;
        b=LYacjvScFea19Yn2ChMUIRU/Xoo51meFnXi/XWUZMmNTO3kWTWVjxiEHRLk5LsGkFvtyJm
        j5r1n1gMbSeydR5RlUYSaAwErfTcgiW4H0uzN8FuLtVP5kFm9yZHPYwSJ5UGLkP6CumlkS
        ULfU2UWmncfII8mPD8ce5F41cVg9IBA=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-jFCrYdasOwKTNpuy2i_DxQ-1; Mon, 01 Nov 2021 05:46:55 -0400
X-MC-Unique: jFCrYdasOwKTNpuy2i_DxQ-1
Received: by mail-ed1-f70.google.com with SMTP id v9-20020a50d849000000b003dcb31eabaaso15106534edj.13
        for <kvm@vger.kernel.org>; Mon, 01 Nov 2021 02:46:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=GCQW+jtyc2XjG8UWnT8I+n1wYys3/xqxOYsbCwWgH3Y=;
        b=l9O+ba+zs9vxrBXb0Mj97Wtonhg1W2FMA5TNT0stZE1lfG1+VKEDcjDWF/Nztrg0bR
         CfqAYX22bTYp5ybXUswGhY8LlWzt63UZshBRUAqzyHRdYx4oWDSz78qBv7wToF/pD1XY
         uxAAoB/W6OWNrSeED8zVf5c5rAAw/HtBLTohDpNXZ2cJ9d671o24eWuQd9Jq7wRYNUbz
         SQbqMVaklBWS+KgJpSQCnpq02s7fa2xro+ytvKuGPJJCVYiKRl127pUUUdT1qPC8URZ7
         VJbz+IgCM4cOnBlyofZYjIl/osCs+hzhRweifWTFwWF3jyf1yFI39rGBCl40s+r5W+aV
         MJ8Q==
X-Gm-Message-State: AOAM530XRaXFUCWBvWLTXRdMJbQWwrlTU+HXVKGNp3UxE9j87K2KurIv
        qOMe9E5w5qRyt31ELUn+dHob3W7N11HFN1I8tioHgg7dUC8VnV5+92IArEfsMAD9ncaKux8JxaY
        AJ0D2OWXo0ZWH
X-Received: by 2002:a17:906:3ac6:: with SMTP id z6mr35445469ejd.196.1635760014519;
        Mon, 01 Nov 2021 02:46:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxejlhpYXWU9PII72c+LiDvOdFySsKViVbsnUuc9wubsgDsL/nqusncIRxzQXqTz90uOamjhQ==
X-Received: by 2002:a17:906:3ac6:: with SMTP id z6mr35445442ejd.196.1635760014308;
        Mon, 01 Nov 2021 02:46:54 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id me7sm3921028ejb.33.2021.11.01.02.46.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 02:46:53 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ajay Garg <ajaygargnsit@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 5/8] KVM: x86: Don't bother reading sparse banks that
 end up being ignored
In-Reply-To: <20211030000800.3065132-6-seanjc@google.com>
References: <20211030000800.3065132-1-seanjc@google.com>
 <20211030000800.3065132-6-seanjc@google.com>
Date:   Mon, 01 Nov 2021 10:46:52 +0100
Message-ID: <87bl34ky2b.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> When handling "sparse" VP_SET requests, don't read sparse banks that
> can't possibly contain a legal VP index instead of ignoring such banks
> later on in sparse_set_to_vcpu_mask().  This allows KVM to cap the size
> of its sparse_banks arrays for VP_SET at KVM_HV_MAX_SPARSE_VCPU_SET_BITS.
>
> Reducing the size of sparse_banks fudges around a compilation warning
> (that becomes error with KVM_WERROR=y) when CONFIG_KASAN_STACK=y, which
> is selected (and can't be unselected) by CONFIG_KASAN=y when using gcc
> (clang/LLVM is a stack hog in some cases so it's opt-in for clang).
> KASAN_STACK adds a redzone around every stack variable, which pushes the
> Hyper-V functions over the default limit of 1024.
>
> Ideally, KVM would flat out reject such impossibilities, but the TLFS
> explicitly allows providing empty banks, even if a bank can't possibly
> contain a valid VP index due to its position exceeding KVM's max.
>
>   Furthermore, for a bit 1 in ValidBankMask, it is valid state for the
>   corresponding element in BanksContents can be all 0s, meaning no
>   processors are specified in this bank.
>
> Arguably KVM should reject and not ignore the "extra" banks, but that can
> be done independently and without bloating sparse_banks, e.g. by reading
> each "extra" 8-byte chunk individually.
>
> Reported-by: Ajay Garg <ajaygargnsit@gmail.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/hyperv.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 3d0981163eed..8832727d74d9 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1753,11 +1753,16 @@ struct kvm_hv_hcall {
>  static u64 kvm_get_sparse_vp_set(struct kvm *kvm, struct kvm_hv_hcall *hc,
>  				 u64 *sparse_banks, gpa_t offset)
>  {
> +	u16 var_cnt;
> +
>  	if (hc->var_cnt > 64)
>  		return -EINVAL;
>  
> +	/* Ignore banks that cannot possibly contain a legal VP index. */
> +	var_cnt = min_t(u16, hc->var_cnt, KVM_HV_MAX_SPARSE_VCPU_SET_BITS);
> +

One may wonder why we're mixing up VP indices and VCPU ids (caped by
KVM_MAX_VCPUS) here as these don't have to match. The following commit
sheds some light:

commit 9170200ec0ebad70e5b9902bc93e2b1b11456a3b
Author: Vitaly Kuznetsov <vkuznets@redhat.com>
Date:   Wed Aug 22 12:18:28 2018 +0200

    KVM: x86: hyperv: enforce vp_index < KVM_MAX_VCPUS
    
    Hyper-V TLFS (5.0b) states:
    
    > Virtual processors are identified by using an index (VP index). The
    > maximum number of virtual processors per partition supported by the
    > current implementation of the hypervisor can be obtained through CPUID
    > leaf 0x40000005. A virtual processor index must be less than the
    > maximum number of virtual processors per partition.
    
    Forbid userspace to set VP_INDEX above KVM_MAX_VCPUS. get_vcpu_by_vpidx()
    can now be optimized to bail early when supplied vpidx is >= KVM_MAX_VCPUS.

>  	return kvm_read_guest(kvm, hc->ingpa + offset, sparse_banks,
> -			      hc->var_cnt * sizeof(*sparse_banks));
> +			      var_cnt * sizeof(*sparse_banks));
>  }
>  
>  static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool ex)
> @@ -1770,7 +1775,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
>  	DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS);
>  	unsigned long *vcpu_mask;
>  	u64 valid_bank_mask;
> -	u64 sparse_banks[64];
> +	u64 sparse_banks[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
>  	bool all_cpus;
>  
>  	if (!ex) {
> @@ -1894,7 +1899,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
>  	DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS);
>  	unsigned long *vcpu_mask;
>  	unsigned long valid_bank_mask;
> -	u64 sparse_banks[64];
> +	u64 sparse_banks[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
>  	u32 vector;
>  	bool all_cpus;

Saves the day until KVM_MAX_VCPUS goes above 4096 (and when it does the
problem strikes back even worse as KVM_HV_MAX_SPARSE_VCPU_SET_BITS is
not caped at '64'). As we're good for now,

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

(I'd even suggest we add BUILD_BUG_ON(KVM_HV_MAX_SPARSE_VCPU_SET_BITS > 64))

Going forward, we can probably get rid of thes on-stack allocations
completely by either allocating these 512 bytes dynamically (lazily)
upon first usage or just adding a field to 'struct kvm_vcpu_hv' -- which
is being allcated dynamically nowadays so non-Windows guests won't suffer.

-- 
Vitaly

