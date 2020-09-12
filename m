Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3847267835
	for <lists+kvm@lfdr.de>; Sat, 12 Sep 2020 08:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725824AbgILGWv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Sep 2020 02:22:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49790 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725800AbgILGWt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 12 Sep 2020 02:22:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599891768;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FbHqeqNAHoGS5cecYV7GE6Rcal3U4Cef72NsYYH8yrY=;
        b=FGZxkVh0K5KGXBzKll6WZRj0nQGQWoMUOTRyEg/11wh8d00W8dDMdy+VGhn+iEZW+4eclM
        SxsjKHncWuTs7vThsg7bgMbjb1VlK9IBPUowcY5Qv6SbjNkGkN8KE5N4xnvPf47x48w817
        qRiZ9+eL2NmBlKqFo56mj/g56iUqtpU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-46-2QELDr8oMoOb-5yXbT7E7A-1; Sat, 12 Sep 2020 02:22:46 -0400
X-MC-Unique: 2QELDr8oMoOb-5yXbT7E7A-1
Received: by mail-wm1-f70.google.com with SMTP id k12so2581799wmj.1
        for <kvm@vger.kernel.org>; Fri, 11 Sep 2020 23:22:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FbHqeqNAHoGS5cecYV7GE6Rcal3U4Cef72NsYYH8yrY=;
        b=pIQYYHCMKwVF0da3YCTVBeZL1WiGOqleNWUsUCyZdwPOTKIQsaJ5eHc1qo1k+G3UeI
         b0nFunAxL2MUdnoO+TEORivsvWNNFT/5tEAM4eFhYJn2TmlIs4DnYgBrCOZ/U25F0m71
         HJRrBV/+aLj1wH07rfP2Nb20674/Dj9aAufKYJae27W4nJn6W4jtVcDvFNmLdUAwOZGV
         TGR5DHPWVgODfl2fXYYC59sOLL0VdmqAdjiFudnkru5gA7peU9pP7WdX9mRfs+kU7O9z
         xIiLahs0DEzlIod7oBgZT0gM1nHDJyY8qgSfyRGtZwUbSok8RBwQ3F9g2eNR4OtkbDaH
         GAhg==
X-Gm-Message-State: AOAM532+LokP4jPhJBkE0Dd3mGa/7HwjAb7nXMOYdQEU+71G6EeoYnju
        ALYdvMlrlZPtIf9ksG1Sq5f+3WG7UDiic9jGxR8tTD9/qOXE0ik/BTNWqfU/8jAdAvx3/rgXEyo
        WFthgdawAHnQK
X-Received: by 2002:a1c:4e0a:: with SMTP id g10mr5713877wmh.71.1599891765111;
        Fri, 11 Sep 2020 23:22:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzCyJlmyaV1w4vnzHzU9MnEJqtaRfQ1ans0g/yTAPLXp6FCa3B0lzZRJUtUTxbE/CMdEv4OLQ==
X-Received: by 2002:a1c:4e0a:: with SMTP id g10mr5713859wmh.71.1599891764891;
        Fri, 11 Sep 2020 23:22:44 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id h5sm8274373wrt.31.2020.09.11.23.22.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2020 23:22:44 -0700 (PDT)
Subject: Re: [PATCH 2/2] x86/kvm: don't forget to ACK async PF IRQ
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>
References: <20200908135350.355053-1-vkuznets@redhat.com>
 <20200908135350.355053-3-vkuznets@redhat.com>
 <20200909081613.GB2446260@gmail.com> <878sdjmj1k.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f539c0f4-1cef-a298-fd49-d140b5749b94@redhat.com>
Date:   Sat, 12 Sep 2020 08:22:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <878sdjmj1k.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/09/20 10:49, Vitaly Kuznetsov wrote:
> Ingo Molnar <mingo@kernel.org> writes:
> 
>> * Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>>
>>> Merge commit 26d05b368a5c0 ("Merge branch 'kvm-async-pf-int' into HEAD")
>>> tried to adapt the new interrupt based async PF mechanism to the newly
>>> introduced IDTENTRY magic but unfortunately it missed the fact that
>>> DEFINE_IDTENTRY_SYSVEC() doesn't call ack_APIC_irq() on its own and
>>> all DEFINE_IDTENTRY_SYSVEC() users have to call it manually.
>>>
>>> As the result all multi-CPU KVM guest hang on boot when
>>> KVM_FEATURE_ASYNC_PF_INT is present. The breakage went unnoticed because no
>>> KVM userspace (e.g. QEMU) currently set it (and thus async PF mechanism
>>> is currently disabled) but we're about to change that.
>>>
>>> Fixes: 26d05b368a5c0 ("Merge branch 'kvm-async-pf-int' into HEAD")
>>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>>
>> This also fixes a kvmtool regression, but interestingly it does not set 
>> KVM_FEATURE_ASYNC_PF_INT either AFAICS:
>>
>>   kepler:~/kvmtool.git> git grep KVM_FEATURE_ASYNC_PF_INT
>>   kepler:~/kvmtool.git> 
> 
> My wild guess would be that kvmtool doesn't manually set any of the KVM
> PV features:
> 
> [vitty@vitty kvmtool]$ git grep KVM_FEATURE_
> [vitty@vitty kvmtool]$ 
> 
> it just blindly passes whatever it gets from KVM via
> KVM_GET_SUPPORTED_CPUID to KVM_SET_CPUID2 and KVM_FEATURE_ASYNC_PF_INT
> among other PV features is set there by default.
> 
>>
>>   kepler:~/kvmtool.git> grep url .git/config
>> 	url = https://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git
>>
>> So either I missed the flag-setting in the kvmtools.git source, or maybe 
>> there's some other way to trigger this bug?
>>
>> Anyway, please handle this as a v5.9 regression:
>>
>> 	Tested-by: Ingo Molnar <mingo@kernel.org>
> 
> Thanks!
> 

Queued, thanks.

Paolo

