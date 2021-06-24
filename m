Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5063B2954
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 09:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbhFXHdk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 03:33:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27019 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231531AbhFXHdg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Jun 2021 03:33:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624519877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1ummzXLEBVOW6zJVjd9RvyjdRwJ4z9g5ls7IEU8SqM4=;
        b=R/y7rJsvxaZ3LSb3r3KagQkRBukpodq6YsNcoQIJnDM1numaIMAHqf3h70No+idSjOo8ZZ
        cFShiMbzitDaIXAVmFLGu8uy+kGfKmvwUSEA63DlvGASqXMyU1IXIyPBjeLQKmbLSk6uXP
        QiyL3qQK4UNEbR/Kd6vj/QVgGib5pwg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-540-3n1xiNxAOVK8azJ9awYVmg-1; Thu, 24 Jun 2021 03:31:15 -0400
X-MC-Unique: 3n1xiNxAOVK8azJ9awYVmg-1
Received: by mail-wr1-f71.google.com with SMTP id b3-20020a05600018a3b029011a84f85e1cso1865611wri.10
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 00:31:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1ummzXLEBVOW6zJVjd9RvyjdRwJ4z9g5ls7IEU8SqM4=;
        b=iqgBimf7TU8HArdjXQpENtpj1IBenhDlF766fGLTgvwpBtyPrO2uUD00WF3vzRgPsy
         v8xNR9Feq0HHVf+46pwG+kt5mKQ+8a9yJJV3TpBLRTwJom/I5IWU2W99WUKi0912UHZ5
         FAQtRJaFh2je6gO6bnybUrEr9gxrpCE089NkWY6yaQXhrEPJ1wNsPnQQD7EyJ4ZNtjZ7
         +C1I42mjjo9gyEfaRGYd/uY1P3gRc+6MeWH+Yhp2canOcc51yZxObzUjSGQ7zB94Sn4k
         hpWz1T7yBxFyuDmh8YqRnbR+Iv8Cz4flIPef54TkR5hARErebgKD1VFVvLpQfuTQj4y5
         4oUA==
X-Gm-Message-State: AOAM531ABA2kxNJkagzQ/OC+zOep4v+D8o9vnZexDbW9FYQ4y5PGbMuf
        4BJAxbXshYDB16iIFg4Derx9OkTSbaUBMkCd6saeN71DJhPQQP4a5QpFXJshukPrylsKu3xLi2B
        sQxxazB5oIY3b
X-Received: by 2002:adf:f88e:: with SMTP id u14mr2674309wrp.391.1624519873869;
        Thu, 24 Jun 2021 00:31:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwmU2A8muf7XixWmRWMn8O50eJCa1GKEjZYZIlN1VsKBfgiuuBfyX9v0BcxFt1KFEfxAoHypw==
X-Received: by 2002:adf:f88e:: with SMTP id u14mr2674272wrp.391.1624519873717;
        Thu, 24 Jun 2021 00:31:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f19sm2269746wre.48.2021.06.24.00.31.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 00:31:13 -0700 (PDT)
Subject: Re: [PATCH 3/6] KVM: x86/mmu: avoid struct page in MMU
To:     David Stevens <stevensd@chromium.org>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
References: <20210624035749.4054934-1-stevensd@google.com>
 <20210624035749.4054934-4-stevensd@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <49504c79-2cd4-1707-a0a5-79b679a4b214@redhat.com>
Date:   Thu, 24 Jun 2021 09:31:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210624035749.4054934-4-stevensd@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/06/21 05:57, David Stevens wrote:
>   static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
> -			int map_writable, int max_level, kvm_pfn_t pfn,
> +			int map_writable, int max_level,
> +			const struct kvm_pfn_page *pfnpg,
>   			bool prefault, bool is_tdp)
>   {
>   	bool nx_huge_page_workaround_enabled = is_nx_huge_pa

So the main difference with my tentative patches is that here I was 
passing the struct by value.  I'll try to clean this up for 5.15, but 
for now it's all good like this.  Thanks again!

Paolo

