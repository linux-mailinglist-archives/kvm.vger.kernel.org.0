Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF831E4B24
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 18:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387708AbgE0Q43 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 12:56:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48626 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731072AbgE0Q42 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 12:56:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590598587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iV7PJ6499KBh2jHYA4ZAtJgeGbwihYkeZJNBRtXPRHU=;
        b=M5TM6GBdLQBAkD6ZQB9Xy7MPB66mtSEj/aA6ZZlqI32lntz8MXeXjXyQyRgw+4bJav2pxV
        FP1RV3pQMcLHkufX/fXuTcExG7WOnLOwX9AUNyiZhYYqFTpR+puLx91TeLLUAyhVeIROiK
        4rGCUaJGlArdYuwWuqKCwc+dI2zhc8w=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-8HE5gsRENfanrqjvHzcogw-1; Wed, 27 May 2020 12:56:23 -0400
X-MC-Unique: 8HE5gsRENfanrqjvHzcogw-1
Received: by mail-wr1-f72.google.com with SMTP id w16so3264324wru.18
        for <kvm@vger.kernel.org>; Wed, 27 May 2020 09:56:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iV7PJ6499KBh2jHYA4ZAtJgeGbwihYkeZJNBRtXPRHU=;
        b=Vn/wb29BjZbTL8G3Wg6YypYRhAeGDk88zA2KyHSTPNMhiyQTo0Muu9JN29xPP7hDdq
         01QlssUbW0eYfGBZUDkCvFwvp/QMA3P9EFVx9smgkoPa1N7LNSLPcj2ocDAxe9lkkSbu
         D8ZvNjeSMTnQMeMhGbEACB6OS9cJ7pXu7wsfJRbXRE8IkvgDXCtaO5z2i14ZBb8PydS6
         WloG49s3vi8C73+QPoGebokHKqDYAqYt5hRi3zPjPoE4UFK5qaTA5FaOaxjp/LbcHGN2
         dx1I4MXXlGK4JL5K7dLsW+LuU/JRTABLkCgGI+BrDOuLVZA6M/Y0AWyppJdDxZU+IV3U
         iYyw==
X-Gm-Message-State: AOAM53316VnUl897zp0YiT4hSs7g//CiaF35tAY2oqUIHP2T7qnHnVgU
        bGnki5YDy792f57sMcf1WBEwCLG8QB/4k1sZhpPkKASV1MLv7GuQ7u3i+wyC2yKDRRGOuiFI48u
        DmzMVFNpZuuyl
X-Received: by 2002:a05:600c:1008:: with SMTP id c8mr5127046wmc.95.1590598581817;
        Wed, 27 May 2020 09:56:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyWqtxWIpSj7lNv4aAoT7R1wHmHCL5CoZGek+Bmi7wvG2hiEcJDp9eWQVm/NvOtXtAmmI1Rhw==
X-Received: by 2002:a05:600c:1008:: with SMTP id c8mr5127030wmc.95.1590598581595;
        Wed, 27 May 2020 09:56:21 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:3c1c:ffba:c624:29b8? ([2001:b07:6468:f312:3c1c:ffba:c624:29b8])
        by smtp.gmail.com with ESMTPSA id i21sm3504216wml.5.2020.05.27.09.56.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2020 09:56:21 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: Initialize tdp_level during vCPU creation
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+904752567107eefb728c@syzkaller.appspotmail.com
References: <20200527085400.23759-1-sean.j.christopherson@intel.com>
 <40800163-2b28-9879-f21b-687f89070c91@redhat.com>
 <20200527162933.GE24461@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <078365dd-64ff-4f3c-813c-3d9fc955ed1a@redhat.com>
Date:   Wed, 27 May 2020 18:56:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200527162933.GE24461@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/05/20 18:29, Sean Christopherson wrote:
> On Wed, May 27, 2020 at 06:17:57PM +0200, Paolo Bonzini wrote:
>> On 27/05/20 10:54, Sean Christopherson wrote:
>>> Initialize vcpu->arch.tdp_level during vCPU creation to avoid consuming
>>> garbage if userspace calls KVM_RUN without first calling KVM_SET_CPUID.
>>>
>>> Fixes: e93fd3b3e89e9 ("KVM: x86/mmu: Capture TDP level when updating CPUID")
>>> Reported-by: syzbot+904752567107eefb728c@syzkaller.appspotmail.com
>>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>>> ---
>>>  arch/x86/kvm/x86.c | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index b226fb8abe41b..01a6304056197 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -9414,6 +9414,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>>>  	fx_init(vcpu);
>>>  
>>>  	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
>>> +	vcpu->arch.tdp_level = kvm_x86_ops.get_tdp_level(vcpu);
>>>  
>>>  	vcpu->arch.pat = MSR_IA32_CR_PAT_DEFAULT;
>>
>> Queued, it is probably a good idea to add a selftests testcase for this
>> (it's even okay if it doesn't use the whole selftests infrastructure and
>> invokes KVM_CREATE_VM/KVM_CREATE_VCPU/KVM_RUN manually).
> 
> Ya.  syzbot is hitting a #GP due to NULL pointer during debugfs on the exact
> same sequence.  I haven't been able to reproduce that one (have yet to try
> syzbot's exact config), but it's another example of a "dumb" test hitting
> meaningful bugs.

Saw that, it's mine. :)

Paolo

