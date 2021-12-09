Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5910D46F707
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 23:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233751AbhLIWtm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 17:49:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbhLIWtl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 17:49:41 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A28C061746;
        Thu,  9 Dec 2021 14:46:07 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id w1so24209953edc.6;
        Thu, 09 Dec 2021 14:46:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NS1lvtZdugfA/xg8aK67B6obLpTP/zEVna54spjVEA4=;
        b=IApnGbGpY6Q9n1vUO3LanTvQUz3kEhunUPZmw8OoGNtIrFcbPRywy2paHqld1aY7pM
         nCZ0x1QskUa3FX9DkOpC9/btlv7Zz1/2NJZXSD0uEmG3f8IuCro/FO74ikAKZT21XJPG
         azfqTtKKMVxcMGThisifxPt1Lv+QdLIPpFKzQsobLfy8RLNqnv4dib5ywKKR4oyWd1mv
         Vl68zcbL5ODhQrbTqd9WCBX2cmUBM/GEnVvgids5QQ7PuMJrJfg1LD6wE9AcKMUnUPci
         itjGbjIUj8rrZp+fW6e6ZntmdIMnuozx/qs6P0qIilJp2cJ9KU/dyuQBcTIwIknsgKNF
         Dqiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NS1lvtZdugfA/xg8aK67B6obLpTP/zEVna54spjVEA4=;
        b=A5J4r4Jh8xCHO4Ryy+7OGsHxXP7wNYUoAMe20UUR2OirGn9p8aKJI8JLXJ1Z50lV74
         r/pkbDbjibZHLvdufFQnxtJFLDXZUHPKKTgfHPr4QqQHDSSaDy7Rw9JyRpY+Lkbzbgpy
         97ZXF07UZGKinkQZixxa64J5z2fQW3imyzhwuwDwRnhUfZL5rInjMc3NKLECMuVAirEe
         kgYZunxBZiRhe1o9XaY4dKpN8hkXGlu9CAksmWpBndqAsKXKljoSPfTkbCXZs0oUShhk
         Ty/G8Is9vKor8KOTlGo4+akGZx+3p9ChWKaesHvOaMSl6oosomFlZg54Rv3gjeYiDXw6
         iHwQ==
X-Gm-Message-State: AOAM5307mxAib0t3SChJ9UvPc26J9RBJ3SBQa0bf4FPCpWYWoQ8SHUEm
        +e6QSXb4PgsOgvHH2md1SY0=
X-Google-Smtp-Source: ABdhPJwbg/eEBt/PMypq/Q55fMJB9v4iTesL4r1QHt88/rWA6MrDsHdmt5gPYcYIeKX/Jkw03uC7rg==
X-Received: by 2002:a17:907:94c4:: with SMTP id dn4mr19035475ejc.512.1639089965822;
        Thu, 09 Dec 2021 14:46:05 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id n8sm539729edy.4.2021.12.09.14.46.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 14:46:05 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <11219bdb-669c-cf6f-2a70-f4e5f909a2ad@redhat.com>
Date:   Thu, 9 Dec 2021 23:46:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 17/15] KVM: X86: Ensure pae_root to be reconstructed for
 shadow paging if the guest PDPTEs is changed
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Xiao Guangrong <guangrong.xiao@linux.intel.com>
References: <20211108124407.12187-1-jiangshanlai@gmail.com>
 <20211111144634.88972-1-jiangshanlai@gmail.com> <Ya/5MOYef4L4UUAb@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Ya/5MOYef4L4UUAb@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/21 01:15, Sean Christopherson wrote:
>> @@ -832,8 +832,14 @@ int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3)
>>   	if (memcmp(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs))) {
>>   		memcpy(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs));
>>   		kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
>> -		/* Ensure the dirty PDPTEs to be loaded. */
>> -		kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
>> +		/*
>> +		 * Ensure the dirty PDPTEs to be loaded for VMX with EPT
>> +		 * enabled or pae_root to be reconstructed for shadow paging.
>> +		 */
>> +		if (tdp_enabled)
>> +			kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
>> +		else
>> +			kvm_mmu_free_roots(vcpu, vcpu->arch.mmu, KVM_MMU_ROOT_CURRENT);
> Shouldn't matter since it's legacy shadow paging, but @mmu should be used instead
> of vcpu->arch.mmuvcpu->arch.mmu.

In kvm/next actually there's no mmu parameter to load_pdptrs, so it's 
okay to keep vcpu->arch.mmu.

> To avoid a dependency on the previous patch, I think it makes sense to have this be:
> 
> 	if (!tdp_enabled && memcmp(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs)))
> 		kvm_mmu_free_roots(vcpu, mmu, KVM_MMU_ROOT_CURRENT);
> 
> before the memcpy().
> 
> Then we can decide independently if skipping the KVM_REQ_LOAD_MMU_PGD if the
> PDPTRs are unchanged with respect to the MMU is safe.

Do you disagree that there's already an invariant that the PDPTRs can 
only be dirty if KVM_REQ_LOAD_MMU_PGD---and therefore a previous change 
to the PDPTRs would have triggered KVM_REQ_LOAD_MMU_PGD?  This is 
opposed to the guest TLB flush due to MOV CR3; that one has to be done 
unconditionally for PAE paging, and it is handled separately within 
kvm_set_cr3.

Paolo
