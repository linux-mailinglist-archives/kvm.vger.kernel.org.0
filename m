Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4729C32F199
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 18:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhCERo2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 12:44:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49758 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229493AbhCERoX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Mar 2021 12:44:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614966263;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=okqh6sDpBZCYsBR1dQl2aJ53DQ8g92ilE6eDHLmR8so=;
        b=OhVkgoSvveatM0oajSLhu/SRKuZ7FbUA1IE650VYlpyhUbOPzUi+U/zikz3SFcng3k16UV
        uNIW4JqdN7OK8mTeVIb4pL21+CuXUITmQ1Tb/x4+0uLwAk+n4qVxJeHkvDp1F9eIZnhrGD
        SXWREGELJpJm1pTPpwcUnr0EAbnKtuI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-GDt94GzLPP6HqRe3KJwUoQ-1; Fri, 05 Mar 2021 12:44:21 -0500
X-MC-Unique: GDt94GzLPP6HqRe3KJwUoQ-1
Received: by mail-wr1-f70.google.com with SMTP id x9so1346859wro.9
        for <kvm@vger.kernel.org>; Fri, 05 Mar 2021 09:44:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=okqh6sDpBZCYsBR1dQl2aJ53DQ8g92ilE6eDHLmR8so=;
        b=HzCf2rWSjBbBsZPDYaqO2I0aWZyYjwtW3BZSbD0i7Zr5NRrgskfLNH14ArVKWt4Dh1
         rQu3cd3rZZUlEgelOOvff2HOOWyKSPy57oQqSWdNhjkIUWqnwRFOQgnMLxk3OGVMiset
         0xsdawhKd6Y8uVLBrAUCSfaCHoVrNKChOvpoEeE5vc9F2aaIFev6zTzG3tCaBBJTgYWr
         IwCOurp1xKRhyNCHvcKXbGgFoB81V9e2XqysczlsHJDgzaU7iPs6lIidoklnX+ySROxJ
         HS0+MGMhHonGwdxH799rtvmZOI3crLvJJmSjwh58ZOuhMOmedEvPU8oWtmVEJM7Z8uFi
         UJOg==
X-Gm-Message-State: AOAM533zn5XUTxkGdMYpv70bsrQ8W4Iug+Me2RtjH5tkV8LkdRFxXFBt
        4i96JE5+gFz+Exp3HqLNYvzzTwJ5p9MZvD5xT8iQYEH+L0bnWUxzu+VVFT9JQp1j4Xx5kcvu68L
        ehZtXmyCUrVzA
X-Received: by 2002:adf:d1c2:: with SMTP id b2mr10392560wrd.424.1614966260157;
        Fri, 05 Mar 2021 09:44:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw1LIHX1xlvfLUMkjvEoIYXDFYLUDDO+iiSjiVdr6s6I56LOsAIRsmXl/5qFqyxa0sJuOK0Aw==
X-Received: by 2002:adf:d1c2:: with SMTP id b2mr10392554wrd.424.1614966260002;
        Fri, 05 Mar 2021 09:44:20 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n23sm579324wra.71.2021.03.05.09.44.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Mar 2021 09:44:19 -0800 (PST)
Subject: Re: [PATCH v2 11/17] KVM: x86/mmu: Mark the PAE roots as decrypted
 for shadow paging
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20210305011101.3597423-1-seanjc@google.com>
 <20210305011101.3597423-12-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d18e53f9-f8ce-9793-a3e7-ad945fd1f5f0@redhat.com>
Date:   Fri, 5 Mar 2021 18:44:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210305011101.3597423-12-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/03/21 02:10, Sean Christopherson wrote:
> @@ -5301,6 +5307,22 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
>   	for (i = 0; i < 4; ++i)
>   		mmu->pae_root[i] = 0;

I think this should be deleted, since you have another identical for 
loop below?

Paolo

> +	/*
> +	 * CR3 is only 32 bits when PAE paging is used, thus it's impossible to
> +	 * get the CPU to treat the PDPTEs as encrypted.  Decrypt the page so
> +	 * that KVM's writes and the CPU's reads get along.  Note, this is
> +	 * only necessary when using shadow paging, as 64-bit NPT can get at
> +	 * the C-bit even when shadowing 32-bit NPT, and SME isn't supported
> +	 * by 32-bit kernels (when KVM itself uses 32-bit NPT).
> +	 */
> +	if (!tdp_enabled)
> +		set_memory_decrypted((unsigned long)mmu->pae_root, 1);
> +	else
> +		WARN_ON_ONCE(shadow_me_mask);
> +
> +	for (i = 0; i < 4; ++i)
> +		mmu->pae_root[i] = 0;
> +

