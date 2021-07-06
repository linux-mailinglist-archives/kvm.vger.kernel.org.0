Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0523C3BD920
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 16:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbhGFO5k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 10:57:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23188 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231779AbhGFO5j (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 10:57:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625583300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KuYfeHNoqBpl5N4HfNgkRzpz5JKHLkceTMnlQS9abyQ=;
        b=Fm/2iJmpU0guLpDmO0gxItAsZdf0QHu0UkGvb5BORtzv2+SdW2tVZvxn5dWGjdna0ucGcw
        f7d4WuA8Y+LEyKYV2zjy8YYX8vhH4ygXORooY/1qda1PM6ZFzU9Ula/zOb8pupo3SA3Pne
        MRmH55Hnq1POLzA6K1TMWonTYUL3yHY=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-498-GnKdo0kIO7SpwTrnK03MRQ-1; Tue, 06 Jul 2021 10:54:59 -0400
X-MC-Unique: GnKdo0kIO7SpwTrnK03MRQ-1
Received: by mail-ej1-f70.google.com with SMTP id 16-20020a1709063010b029037417ca2d43so5917352ejz.5
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 07:54:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KuYfeHNoqBpl5N4HfNgkRzpz5JKHLkceTMnlQS9abyQ=;
        b=ZuJZZNdLh/62vGImEUnkOyrKV4xZUvW0Xv9YcD5eAcbvmG0xYpF057nmBoyQk21z6q
         H4LeRmDoza/GeEVEK18SPAaabMmrRsW/F6SUPW5Q7jenkh+3w7B4a1J5mKbZRgYM5z5L
         v6PrAufxqrh9ItlkpzlECJismLNzu1yxQ9MWXAMzZV2ch+pxbRd1+bawITFtwxZ2L9Cx
         EqrKED+fb/ucFxndC0O7fbh8NSHQv0MkQU5n5iHHtuQR21EClBjO7LNbQcw7uqOCEXal
         zSdngLad2WWjkNhjocZpr4rpuht68KmXE3XAd+Fyg3NSjwB0PvflEKNoEKVEkQ4tbuVb
         25QA==
X-Gm-Message-State: AOAM530zMYZvBQEhGAiqirh1cubYnors0HaD2PzR/rfbY9qJAj2ehan6
        zbT4Wdd9cjMd2pruRW8ay1AuJE/piko8TV7g1moDGsQUtTUIGpwW6h5/t0W+ysAfp6Rh3ktyF/9
        V2bAsKekBQlj0
X-Received: by 2002:a17:907:2d0e:: with SMTP id gs14mr19653268ejc.49.1625583298178;
        Tue, 06 Jul 2021 07:54:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxu/HxHED8qHhMd++zEduBrLuA+TKJfofjJlP+ABGykUHeQw668AalvTk0MYhBa6r29iCQ07g==
X-Received: by 2002:a17:907:2d0e:: with SMTP id gs14mr19653246ejc.49.1625583298025;
        Tue, 06 Jul 2021 07:54:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id w13sm7240116edd.66.2021.07.06.07.54.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 07:54:57 -0700 (PDT)
Subject: Re: [RFC PATCH v2 42/69] KVM: x86/mmu: Explicitly check for MMIO spte
 in fast page fault
To:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <26005d563a9303ecc6ca68a9baea77895a75e8e0.1625186503.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <534e7bb1-6e81-f1de-3d78-022449ac5a1e@redhat.com>
Date:   Tue, 6 Jul 2021 16:54:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <26005d563a9303ecc6ca68a9baea77895a75e8e0.1625186503.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/21 00:04, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Explicity check for an MMIO spte in the fast page fault flow.  TDX will
> use a not-present entry for MMIO sptes, which can be mistaken for an
> access-tracked spte since both have SPTE_SPECIAL_MASK set.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 990ee645b8a2..631b92e6e9ba 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3060,7 +3060,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>   			break;
>   
>   		sp = sptep_to_sp(iterator.sptep);
> -		if (!is_last_spte(spte, sp->role.level))
> +		if (!is_last_spte(spte, sp->role.level) || is_mmio_spte(spte))
>   			break;
>   
>   		/*
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

