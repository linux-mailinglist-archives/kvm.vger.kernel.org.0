Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 786622189CA
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 16:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729133AbgGHOGR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 10:06:17 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23571 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728148AbgGHOGR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 10:06:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594217175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g1QdAfsz6hOzCxXEuoKjy0120IGcwZSXG6p/fqOOsy0=;
        b=epTeRBuKVq2BuGpDiL3IoRNk65u1vtQy1r3/VJIz1hxU3BQtIbElj71Ro6fDFQwnpYMVWd
        qn/UrDqpN4ouQ3VvtJFNzK3AT33ijMwecNNc5X5roRDgUZHK/IJQTaS/i+9bs2UCBA0BzG
        zxS6dmcSC8jkS0GqNY99TnR/sSp9ehM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-JapmJLRGNNqossZNi9oZAg-1; Wed, 08 Jul 2020 10:06:13 -0400
X-MC-Unique: JapmJLRGNNqossZNi9oZAg-1
Received: by mail-wr1-f69.google.com with SMTP id z1so22317549wrn.18
        for <kvm@vger.kernel.org>; Wed, 08 Jul 2020 07:06:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g1QdAfsz6hOzCxXEuoKjy0120IGcwZSXG6p/fqOOsy0=;
        b=F45HU9e2KrKcvhGanfd5R8Bg3REVmUMfN9ycqhMg9XCYZy8A3woiWMd2yUTN6cefCZ
         aocIq5SYdSirOgvOpV+RP7iJqlYpaD+DTTS111uybKruxEfp7eHOCcC+ue26wGeand0W
         K+COMe5nNuvTaDex5FEkCov97oWVO154Lb9XkLxFpWtydIcEllO/9Niyf5ToNTl56B5W
         pi/NxwGzSW4rsORYdyD6GzcAlNAsK+h6KX8G+F7uf5IMZzN8GePFj0LxEN0R7qYyA714
         WsoHUUfgaSN8M4S82TySzH4qtU9Mgt28AOo5F+cj2jeD38/+k2XdIvQGE1WO6o7k/g7i
         Py+A==
X-Gm-Message-State: AOAM530Szn1xC0EROvzdqVUZGi/nsoJTs3Z3C3dfpgjFUSt2Z8SFf2l5
        h6qNLsrxH/x2Kbp12jLB7AVILUeopQJRxh45VBkIJpLc9R1eKxxw0KWNO5Ef41uffsheg+NL54v
        MWLPhQ0FBZwYM
X-Received: by 2002:adf:828b:: with SMTP id 11mr63226500wrc.58.1594217170533;
        Wed, 08 Jul 2020 07:06:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyb8D5gvP4RQNaXaJPCmtCzy9nqbwuEvAH6/tWvVOah83zyfRByzJN1GRzgbS9vv8tsP5Y4oA==
X-Received: by 2002:adf:828b:: with SMTP id 11mr63226478wrc.58.1594217170288;
        Wed, 08 Jul 2020 07:06:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id c20sm40034wrb.65.2020.07.08.07.06.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 07:06:09 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: take as_id into account when checking PGD
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
References: <20200708140023.1476020-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <88e517df-0887-2687-b3db-0892ac479211@redhat.com>
Date:   Wed, 8 Jul 2020 16:06:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200708140023.1476020-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/07/20 16:00, Vitaly Kuznetsov wrote:
> OVMF booted guest running on shadow pages crashes on TRIPLE FAULT after
> enabling paging from SMM. The crash is triggered from mmu_check_root() and
> is caused by kvm_is_visible_gfn() searching through memslots with as_id = 0
> while vCPU may be in a different context (address space).
> 
> Introduce kvm_vcpu_is_visible_gfn() and use it from mmu_check_root().
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c   | 2 +-
>  include/linux/kvm_host.h | 1 +
>  virt/kvm/kvm_main.c      | 8 ++++++++
>  3 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 4fd4b5de8996..309024210a35 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3668,7 +3668,7 @@ static int mmu_check_root(struct kvm_vcpu *vcpu, gfn_t root_gfn)
>  {
>  	int ret = 0;
>  
> -	if (!kvm_is_visible_gfn(vcpu->kvm, root_gfn)) {
> +	if (!kvm_vcpu_is_visible_gfn(vcpu, root_gfn)) {
>  		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
>  		ret = 1;
>  	}
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index d564855243d8..f74d2a5afc26 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -774,6 +774,7 @@ int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len);
>  int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len);
>  struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
>  bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn);
> +bool kvm_vcpu_is_visible_gfn(struct kvm_vcpu *vcpu, gfn_t gfn);
>  unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn);
>  void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
>  
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index a852af5c3214..b131c7da1d12 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1626,6 +1626,14 @@ bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
>  }
>  EXPORT_SYMBOL_GPL(kvm_is_visible_gfn);
>  
> +bool kvm_vcpu_is_visible_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
> +{
> +	struct kvm_memory_slot *memslot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
> +
> +	return kvm_is_visible_memslot(memslot);
> +}
> +EXPORT_SYMBOL_GPL(kvm_vcpu_is_visible_gfn);
> +
>  unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn)
>  {
>  	struct vm_area_struct *vma;
> 

Queued, thanks.

Paolo

