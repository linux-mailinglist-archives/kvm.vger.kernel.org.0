Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B60591464C2
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 10:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgAWJpU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 04:45:20 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32276 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726103AbgAWJpU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 04:45:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579772718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MzX6+vB1Xsw4thPSPKllXzkIMMw9yMJ4EsBg/hWVsio=;
        b=gzQwEsqNP1SzqA4yjn9QN7D34bIHi0CHbLmnB9gnjAUQdnxc0nEU/h4mBTZMPO+5Epk+UN
        ov7J/8Ymob1Lzgp5zVOuCwhmrXGlmxvE5FxdNhjoquAK5P822IFwpg4x9oTT7MrVLo5/E4
        TvtgNPc+tgQiQRvk/vs/5coRcPycLIA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-122-p_8EiuVnOb-Xp368ozJ7jg-1; Thu, 23 Jan 2020 04:45:16 -0500
X-MC-Unique: p_8EiuVnOb-Xp368ozJ7jg-1
Received: by mail-wm1-f72.google.com with SMTP id n17so371252wmk.1
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2020 01:45:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=MzX6+vB1Xsw4thPSPKllXzkIMMw9yMJ4EsBg/hWVsio=;
        b=Pryf7KKtAmOVOpg+oWCB7QEq89ZpUi3NRGwMCYNbTsoQadAE6fHtEarl6OA3rfl26Y
         mFCQDeyvYEhDCJVpJnWr7/VP8k8yQ+wfnl+3pT2SeaTf2oFQVKxsfP/KiNjFtUQ8wVFR
         q8zh41hNKz1Hvk8r0T6/3RF4w2ERoHEoqZ+VKimFLC4zfBEmFUXyD+FNLOF5+/1N6Voj
         RghzWpIPQuyEL5zFU6lgSq8NWS4TohXLhlGgW0lt96CNMb9KUDuL+Fw1c5rV1MYG2H06
         ukQGiOe5IplX0Axv9CNMLWbsnqbW/n2Flybh7N6qdZK2rqhtQj0T2S6Nuq9flvv8VFGO
         LFjA==
X-Gm-Message-State: APjAAAUBQvjAT3xeV0vU+Kg8/8GLJciGfZZnRUjs7xZ99Hy20MRmUWGA
        2ACVKiLzL0dQUaeTL2pDqX4v9eynJAwaI0ftIdcUrijQIk+uSuzqok41SZgwrMMwh5mUNJHWF8K
        Dc+fK54/814ZZ
X-Received: by 2002:a1c:4144:: with SMTP id o65mr3109659wma.81.1579772715480;
        Thu, 23 Jan 2020 01:45:15 -0800 (PST)
X-Google-Smtp-Source: APXvYqxAIX93bsgTcrSBiFj30of2pgg0VpgNuw/XwpFAIlGghwGu9wEyJwZ0l8Ywl/vNLBijmNtpdQ==
X-Received: by 2002:a1c:4144:: with SMTP id o65mr3109641wma.81.1579772715295;
        Thu, 23 Jan 2020 01:45:15 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id o15sm2251300wra.83.2020.01.23.01.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 01:45:14 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        linmiaohe <linmiaohe@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Subject: Re: [PATCH] KVM: nVMX: set rflags to specify success in handle_invvpid() default case
In-Reply-To: <1a083ac8-3b01-fd2d-d867-2b3956cdef6d@redhat.com>
References: <1579749241-712-1-git-send-email-linmiaohe@huawei.com> <8736c6sga7.fsf@vitty.brq.redhat.com> <1a083ac8-3b01-fd2d-d867-2b3956cdef6d@redhat.com>
Date:   Thu, 23 Jan 2020 10:45:13 +0100
Message-ID: <87wo9iqzfa.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 23/01/20 09:55, Vitaly Kuznetsov wrote:
>>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>>> index 7608924ee8c1..985d3307ec56 100644
>>> --- a/arch/x86/kvm/vmx/nested.c
>>> +++ b/arch/x86/kvm/vmx/nested.c
>>> @@ -5165,7 +5165,7 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
>>>  		break;
>>>  	default:
>>>  		WARN_ON_ONCE(1);
>>> -		return kvm_skip_emulated_instruction(vcpu);
>>> +		break;
>>>  	}
>>>  
>>>  	return nested_vmx_succeed(vcpu);
>> Your patch seems to do the right thing, however, I started wondering if
>> WARN_ON_ONCE() is the right thing to do. SDM says that "If an
>> unsupported INVVPID type is specified, the instruction fails." and this
>> is similar to INVEPT and I decided to check what handle_invept()
>> does. Well, it does BUG_ON(). 
>> 
>> Are we doing the right thing in any of these cases?
>
> Yes, both INVEPT and INVVPID catch this earlier.
>
> For INVEPT:
>
>         types = (vmx->nested.msrs.ept_caps >> VMX_EPT_EXTENT_SHIFT) & 6;
>
>         if (type >= 32 || !(types & (1 << type)))
>                 return nested_vmx_failValid(vcpu,
>                                 VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
>
>
>
> For INVVPID:
>
>         types = (vmx->nested.msrs.vpid_caps &
>                         VMX_VPID_EXTENT_SUPPORTED_MASK) >> 8;
>
>         if (type >= 32 || !(types & (1 << type)))
>                 return nested_vmx_failValid(vcpu,
>                         VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
>

Ah, true, thanks for checking!

> So I'm leaning towards not applying Miaohe's patch.

Well, we may at least want to converge on BUG_ON() for both
handle_invvpid()/handle_invept(), there's no need for them to differ.

-- 
Vitaly

