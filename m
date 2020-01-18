Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3DF1419E6
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2020 22:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbgARVjF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Jan 2020 16:39:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27185 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726960AbgARVjE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Jan 2020 16:39:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579383543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LpBEUuDwvWW3/yC4b/2BYg92lPDd6HIiI6tDhikopY8=;
        b=TmiLbhNZKVhJxQeIS2H8pioaAHL4XvrXJ2aZ/do0o2QFRH6RKf+Fnk8VqakXDKthWOr8m2
        utSNheZ77Tx/hAjxlmtVZGO2zqYBLYPig8o4BYzoUoiNJA3oS3UZeaBUMXKWWLepl+JWzl
        xDrmwJLODe+G+PBB8qytcN1yZP9ZlsM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-2N70pFI1OFSEVIwKIgnm_g-1; Sat, 18 Jan 2020 16:39:00 -0500
X-MC-Unique: 2N70pFI1OFSEVIwKIgnm_g-1
Received: by mail-wr1-f70.google.com with SMTP id u18so12078575wrn.11
        for <kvm@vger.kernel.org>; Sat, 18 Jan 2020 13:39:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LpBEUuDwvWW3/yC4b/2BYg92lPDd6HIiI6tDhikopY8=;
        b=Wdf7pTuJzvgZfx7wpzyPjJ7BjABsWaY4TJNn1zXsnwtGLmR7uY6dvC7M9ghj19uK2R
         RjQDmKGOoLoF9RNhPPDIOtqOmbAsF9/gWekRrOeGs/3W3yAh1LxsKD7qpt+dEFCK/Pwb
         gekCTdP2rsAuIh73vsqjKtLnBRU0zxjwxkHElnkBJQG1f/i1/x8lMFUmDPMf7RELy5R3
         kTKU2tV9bBVt8rexkr7UhjDMM3XdYrvwzDAdZPhAkOag/L3x5Qogyn4wBDZgLaPSEHPD
         sFYiOqmRNNoXy3BQLV5ujI115lPG+bdSdfDnK8DJYjPeLHsi6Amc3vTkg+pnX5DXF2Nx
         esQw==
X-Gm-Message-State: APjAAAVN3EJfKj8LkyazRCep1nP6qtFlsUFNStUMd2l7GTTm508FH44Y
        tg8tOhB1hKRn09nBttwGNT6GcXmF0csCAFD+m85YfYgY2+LT/gJc7nIG/aLakt6w5DZGWiKPcFk
        fqXzEsbH+89dH
X-Received: by 2002:a1c:9d52:: with SMTP id g79mr11312262wme.148.1579383539127;
        Sat, 18 Jan 2020 13:38:59 -0800 (PST)
X-Google-Smtp-Source: APXvYqz1wOzcIlp0MwOfex7nuYP8ORd5FMC/dhKir9fpXdSSBz/nJbqOxTtUELUes+VzgjVRx9V5Qw==
X-Received: by 2002:a1c:9d52:: with SMTP id g79mr11312254wme.148.1579383538917;
        Sat, 18 Jan 2020 13:38:58 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e0d6:d2cd:810b:30a9? ([2001:b07:6468:f312:e0d6:d2cd:810b:30a9])
        by smtp.gmail.com with ESMTPSA id w17sm40345413wrt.89.2020.01.18.13.38.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jan 2020 13:38:58 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: Perform non-canonical checks in 32-bit KVM
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200115183605.15413-1-sean.j.christopherson@intel.com>
 <cf9a9746-e0b8-8303-afd5-b1c3a2a9ac83@oracle.com>
 <20200116155057.GB20561@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c88c77f4-83c8-2d6d-6c78-c004f7917efd@redhat.com>
Date:   Sat, 18 Jan 2020 22:38:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200116155057.GB20561@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/01/20 16:50, Sean Christopherson wrote:
> On Wed, Jan 15, 2020 at 05:37:16PM -0800, Krish Sadhukhan wrote:
>>
>> On 01/15/2020 10:36 AM, Sean Christopherson wrote:
>>>  arch/x86/kvm/x86.h | 8 --------
>>>  1 file changed, 8 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
>>> index cab5e71f0f0f..3ff590ec0238 100644
>>> --- a/arch/x86/kvm/x86.h
>>> +++ b/arch/x86/kvm/x86.h
>>> @@ -166,21 +166,13 @@ static inline u64 get_canonical(u64 la, u8 vaddr_bits)
>>>  static inline bool is_noncanonical_address(u64 la, struct kvm_vcpu *vcpu)
>>>  {
>>> -#ifdef CONFIG_X86_64
>>>  	return get_canonical(la, vcpu_virt_addr_bits(vcpu)) != la;
>>> -#else
>>> -	return false;
>>> -#endif
>>>  }
>>>  static inline bool emul_is_noncanonical_address(u64 la,
>>>  						struct x86_emulate_ctxt *ctxt)
>>>  {
>>> -#ifdef CONFIG_X86_64
>>>  	return get_canonical(la, ctxt_virt_addr_bits(ctxt)) != la;
>>> -#else
>>> -	return false;
>>> -#endif
>>>  }
>>>  static inline void vcpu_cache_mmio_info(struct kvm_vcpu *vcpu,
>>
>> nested_vmx_check_host_state() still won't call it on 32-bit because it has
>> the CONFIG_X86_64 guard around the callee:
>>
>>  #ifdef CONFIG_X86_64
>>         if (CC(is_noncanonical_address(vmcs12->host_fs_base, vcpu)) ||
>>             CC(is_noncanonical_address(vmcs12->host_gs_base, vcpu)) ||
>>  ...
> 
> Doh, I was looking at an older version of nested.c.  Nice catch!
> 
>> Don't we need to remove these guards in the callers as well ?
> 
> Ya, that would be my preference.
> 

Fixed and queued, thanks.

Paolo

