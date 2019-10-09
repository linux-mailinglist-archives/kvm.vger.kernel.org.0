Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FEAED1A5E
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 23:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732137AbfJIU7P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 16:59:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43484 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732108AbfJIU7O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 16:59:14 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3EEA365F40
        for <kvm@vger.kernel.org>; Wed,  9 Oct 2019 20:59:14 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id i2so1674722wrv.0
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2019 13:59:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mQUedDk5IixQtgNfS/LbVr5OQ+GLG6+7GAPgfU7Balo=;
        b=JjOcNgZ4kkfT+cVuogztjpZ64jt9lejKswTLx1SWUf0gRgpiR7KpBH7VrfaBw3gvcy
         ylogduBho2H6qc6QIUIxL8fcFc/NK73vuxMXmnDiAhwLosZRuev+x1hBbvVu7EecMsW0
         wW2ei8gcPppSlC7AslrF8wsYlHjbtASAnYKD/fhLozKkehL0AEOrAuaFnVmYRWRGD648
         hYGphpLBGKQM5XW7E5pEcDxZ5sRKzlz3CpE/yuuGzaGxpYOUmXH4IzoYKP04NqM52AMI
         P6b0eRUVgWOpHhvSHanS38sCyvOUgoDoGFTZOzImaloZh7QZ+QPLOXw3SltcKo6ANq0J
         QQaQ==
X-Gm-Message-State: APjAAAVtL8tG8YBSpaQicfGqKoTYTlKsnDDBSJTIDtBEEttlg9NK4DEf
        LuNQA/dcGehD7Izcj1FqeQglz4UEsUMyD8IKFCJDz4ADBq2jX/VfY6pAXXh5JJRk6VvO7ZspCK4
        u0ku4fz5hgERy
X-Received: by 2002:adf:814d:: with SMTP id 71mr4751159wrm.193.1570654752768;
        Wed, 09 Oct 2019 13:59:12 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwFpbepWq2DgiU7FbUtX4DjIcH80wAx7fxPJyEtr3o5Gr/tTJ/GeqM1ydfUzo9JztLIaY4Lpg==
X-Received: by 2002:adf:814d:: with SMTP id 71mr4751141wrm.193.1570654752460;
        Wed, 09 Oct 2019 13:59:12 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1032:7ea1:7f8f:1e5? ([2001:b07:6468:f312:1032:7ea1:7f8f:1e5])
        by smtp.gmail.com with ESMTPSA id g11sm3881984wmh.45.2019.10.09.13.59.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2019 13:59:11 -0700 (PDT)
Subject: Re: [PATCH v2 4/8] KVM: VMX: Optimize vmx_set_rflags() for
 unrestricted guest
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reto Buerki <reet@codelabs.ch>,
        Liran Alon <liran.alon@oracle.com>
References: <20190927214523.3376-1-sean.j.christopherson@intel.com>
 <20190927214523.3376-5-sean.j.christopherson@intel.com>
 <99e57095-d855-99d7-e10e-a415c6ef13b2@redhat.com>
 <20191009163835.GB19952@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <aee0fe86-6a5a-680a-4147-3b68fc3718c9@redhat.com>
Date:   Wed, 9 Oct 2019 22:59:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191009163835.GB19952@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/10/19 18:38, Sean Christopherson wrote:
> On Wed, Oct 09, 2019 at 12:40:53PM +0200, Paolo Bonzini wrote:
>> On 27/09/19 23:45, Sean Christopherson wrote:
>>> Rework vmx_set_rflags() to avoid the extra code need to handle emulation
>>> of real mode and invalid state when unrestricted guest is disabled.  The
>>> primary reason for doing so is to avoid the call to vmx_get_rflags(),
>>> which will incur a VMREAD when RFLAGS is not already available.  When
>>> running nested VMs, the majority of calls to vmx_set_rflags() will occur
>>> without an associated vmx_get_rflags(), i.e. when stuffing GUEST_RFLAGS
>>> during transitions between vmcs01 and vmcs02.
>>>
>>> Note, vmx_get_rflags() guarantees RFLAGS is marked available.
>>
>> Slightly nicer this way:
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 8de9853d7ab6..62ab19d65efd 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -1431,9 +1431,17 @@ unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu)
>>  void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
>>  {
>>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>> -	unsigned long old_rflags = vmx_get_rflags(vcpu);
>> +	unsigned long old_rflags;
>> +
>> +	if (enable_unrestricted_guest) {
>> +		__set_bit(VCPU_EXREG_RFLAGS, (ulong *)&vcpu->arch.regs_avail);
>> +		vmx->rflags = rflags;
>> +		vmcs_writel(GUEST_RFLAGS, rflags);
>> +		return;
>> +	}
>> +
>> +	old_rflags = vmx_get_rflags(vcpu);
>>  
>> -	__set_bit(VCPU_EXREG_RFLAGS, (ulong *)&vcpu->arch.regs_avail);
>>  	vmx->rflags = rflags;
>>  	if (vmx->rmode.vm86_active) {
>>  		vmx->rmode.save_rflags = rflags;
> 
> Works for me.  Do you want me to spin a v3 to incorporate this and remove
> the open coding of the RIP/RSP accessors?  Or are you planning on squashing
> the changes as you apply?

If it's okay for you I can squash it.

Paolo

