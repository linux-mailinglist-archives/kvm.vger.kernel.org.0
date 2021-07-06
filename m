Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E47D43BD7C5
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 15:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbhGFN27 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 09:28:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24027 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231736AbhGFN26 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 09:28:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625577979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4Oa/VPfYxGLP3gmpzmtmdJTUZPvZ5vrg9jNApBaEdpU=;
        b=EIzIgYz9MXuuMatLBMBkF3lIDmyzPdBD1MzKvuo0Z94f7cJcufCpc+y8R2RLx98QELxwbV
        cQ4K354t8OvIT/INVELazPyh4m4xRpIS2hNS+8+ZPum2Z7dmGTrKtvzgV+Ky2owGGDqm4y
        JshBmFxZ1xaQyus4hCsHFIDVrzlN7Ys=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-KHZc9F9KNmGhTg6_VgXkyQ-1; Tue, 06 Jul 2021 09:26:18 -0400
X-MC-Unique: KHZc9F9KNmGhTg6_VgXkyQ-1
Received: by mail-ed1-f72.google.com with SMTP id d17-20020a05640208d1b0290399de3a0eecso2667832edz.0
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 06:26:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4Oa/VPfYxGLP3gmpzmtmdJTUZPvZ5vrg9jNApBaEdpU=;
        b=NUbS0tHnbJ1frJpVZnAoWWlVWlDWhnyJS6OvCagAgAOhCo7wT2G51540QjHI27fhio
         f5tuX2Zi7wQf+/3C4KgVArRV+sIrzbSAAj8s/WeAnvnOb90eVOxl2TeljgCRk51TrfEy
         noJHoZEdRlIOBSmjKg8S1OzCZKmMRISmYQnjeJjFeu8w4r1FMD3uWxY+FaDP/BnnQKgm
         b+okGSxDMn+vh2fhvveUZ4ib18YSi+Bh8IDF73mxrLZsbJs1wyU9pBjqhkmQJ/2u9Mqk
         1bobJn6SUZx6z3FEGp3akf6ZaoMg9upUwA200j6F6RJ5Pho3D/Nj2EQi91DpGJxBCjro
         /g7w==
X-Gm-Message-State: AOAM531u1Agjn7KNq1GttpVkrerntlkesUAH5+O5MBMBYhlwC5E+05Wt
        c6/E6lXlPHghgNOBK5tbV30T7A27OIGlLMPqgUdjmI9YkHcJ6Lu02q7+PmOjIWQM3NyB/w8sFtM
        TWw6GbSFMCCNA
X-Received: by 2002:a17:906:e256:: with SMTP id gq22mr18594620ejb.248.1625577976965;
        Tue, 06 Jul 2021 06:26:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzQx/OSfBQAhW+br2mF6GWGfZoWd6kQsWiVVGx3Z1ZugKRYsrj47V9z6d/3UxiAaxzfjl5uHg==
X-Received: by 2002:a17:906:e256:: with SMTP id gq22mr18594587ejb.248.1625577976775;
        Tue, 06 Jul 2021 06:26:16 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id mm27sm5679601ejb.67.2021.07.06.06.26.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 06:26:12 -0700 (PDT)
Subject: Re: [RFC PATCH v2 12/69] KVM: Export kvm_io_bus_read for use by TDX
 for PV MMIO
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
 <2dd423f9764c72624f1fa6d551b45ab245c4255f.1625186503.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9d5a774f-6fa4-d780-a314-c82155d212da@redhat.com>
Date:   Tue, 6 Jul 2021 15:26:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <2dd423f9764c72624f1fa6d551b45ab245c4255f.1625186503.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/21 00:04, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Later kvm_intel.ko will use it.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   virt/kvm/kvm_main.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 46fb042837d2..9e52fe999c92 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4606,6 +4606,7 @@ int kvm_io_bus_read(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
>   	r = __kvm_io_bus_read(vcpu, bus, &range, val);
>   	return r < 0 ? r : 0;
>   }
> +EXPORT_SYMBOL_GPL(kvm_io_bus_read);
>   
>   /* Caller must hold slots_lock. */
>   int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

