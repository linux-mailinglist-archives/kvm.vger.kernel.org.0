Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A964E43554C
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 23:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbhJTVfI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 17:35:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54350 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229695AbhJTVfG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 17:35:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634765571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+m6bzLId3io/wO6+zODL/eJosW6ab9oTsOZW/f6Hvcg=;
        b=ZkBI+WLjQMyymOvt5639YqXptcXMCCAh/NSRj3ogG9vDkuLmWJ76q8Mv82hYi/CYpeMChw
        LSTkq3hGMPLWCyrB/ypQWeFAzxwmyDQLqnSoWQ5wmlceHzxdNR8WtJM9BHQXu/APetM9PD
        n3ko2RUqDNxJfnzNexh/HlrpgKtq5dc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-Ya8Emz4mMuK60ZUgDZ0frQ-1; Wed, 20 Oct 2021 17:32:50 -0400
X-MC-Unique: Ya8Emz4mMuK60ZUgDZ0frQ-1
Received: by mail-wr1-f70.google.com with SMTP id j12-20020adf910c000000b0015e4260febdso3486804wrj.20
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 14:32:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+m6bzLId3io/wO6+zODL/eJosW6ab9oTsOZW/f6Hvcg=;
        b=BCcYm0+TBJfeQZTLF0+AQ+1mt5sG8A9UYXteEbmbzyXmLOJutlWK+xbNThyQIwhK3s
         59JTswElgO5WfyopK5lb40CSOllf0dDw25kiPcDE0K14XVIwIZ2/vDo2JsDLG3iOE0rm
         AxqBMIZekcQoBDL1QCMh0jsEMKms3sq9c1C8MEfC0ycrEsuOEK+8rIAllmOg4upDWpfX
         S3tiJxHUmM/5zV+8eOS5HM7lq6SZXULAUMMkHSVCkBTulEXXv2oiw0moyLWTXTm82sWR
         ufKI7ERbGvFmgsE+yVTwHB0iin3W0riBHAnEW2HyzNXf5qbEE4d2U2+pKviXWigkf4P+
         rh1w==
X-Gm-Message-State: AOAM531YsqBo/IiCyWnL+9FT+EBDQ27z/9A/A4FqjHLxptGfvWF5aYrf
        0cfvMJjrsocPrC3QleVLVbSNhpU2kvQNyR9lhIHWZ0ivWIJxZ8u0WUaJWTkBdwy57LcmELMoE/G
        6zSw6ZYVVElqG
X-Received: by 2002:adf:a387:: with SMTP id l7mr2116801wrb.214.1634765569148;
        Wed, 20 Oct 2021 14:32:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzsw9X0b8cQNRNSYxe4USWipSUlN9OgVtuvQLNO8/HE+MVnZi8sGbuuT/LMlBZEQXYCM2cTCg==
X-Received: by 2002:adf:a387:: with SMTP id l7mr2116781wrb.214.1634765568932;
        Wed, 20 Oct 2021 14:32:48 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id c7sm145262wrp.51.2021.10.20.14.32.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 14:32:48 -0700 (PDT)
Message-ID: <78be3e02-aac5-0f5b-339e-5969a14974d7@redhat.com>
Date:   Wed, 20 Oct 2021 23:32:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] KVM: Avoid atomic operations when kicking the running
 vCPU
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        wanpengli@tencent.com
References: <20211020145231.871299-3-pbonzini@redhat.com>
 <YXBvOR1qQpsbNUIs@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YXBvOR1qQpsbNUIs@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/10/21 21:34, Sean Christopherson wrote:
>>
>> +	/*
>> +	 * The only state change done outside the vcpu mutex is IN_GUEST_MODE
>> +	 * to EXITING_GUEST_MODE.  Therefore the moderately expensive "should
>> +	 * kick" check does not need atomic operations if kvm_vcpu_kick is used
>> +	 * within the vCPU thread itself.
>> +	 */
>> +	if (vcpu == __this_cpu_read(kvm_running_vcpu)) {
>> +		if (vcpu->mode == IN_GUEST_MODE)
>> +			WRITE_ONCE(vcpu->mode, EXITING_GUEST_MODE);
> 
> Fun.  I had a whole thing typed out about this being unsafe because it implicitly
> relies on a pending request and that there's a kvm_vcpu_exit_request() check _after_
> this kick.  Then I saw your other patches, and then I realized we already have this
> bug in the kvm_arch_vcpu_should_kick() below.

Yeah, the three patches are independent but part of the same rabbit hole.

> Anyways, I also think we should add do:
> 
> 	if (vcpu == __this_cpu_read(kvm_running_vcpu)) {
> 		if (vcpu->mode == IN_GUEST_MODE &&
> 		    !WARN_ON_ONCE(!kvm_request_pending(vcpu)))
> 			WRITE_ONCE(vcpu->mode, EXITING_GUEST_MODE);
> 		goto out;
> 	}
> 
> The idea being that delaying or even missing an event in case of a KVM bug is
> preferable to letting the vCPU state become invalid due to running in the guest
> with EXITING_GUEST_MODE.

On one hand I like the idea of having a safety net; for example a test 
similar to this one would have triggered for the naked 
kvm_vcpu_exiting_guest_mode(vcpu) call in vmx_sync_pir_to_irr.

On the other hand, "request-less VCPU kicks", as 
Documentation/virt/kvm/vcpu-requests.rst calls them, are a thing; PPC 
book3s_hv does not use vcpu->requests at all. For an artificial but more 
relatable example, the ON bit takes the role of vcpu->requests when 
processing PIR.  Hence the code below would be suboptimal but still correct:

         for (;;) {
                 exit_fastpath = static_call(kvm_x86_run)(vcpu);
                 if (likely(exit_fastpath !=
			   EXIT_FASTPATH_REENTER_GUEST))
                         break;

                 if (vcpu->arch.apicv_active && pi_test_on(vcpu))
                         kvm_vcpu_kick(vcpu);

                 if (unlikely(kvm_vcpu_exit_request(vcpu))) {
                         exit_fastpath = EXIT_FASTPATH_EXIT_HANDLED;
                         break;
                 }
         }

All that really matters is that every call to kvm_x86_run is guarded by 
kvm_vcpu_exit_request(vcpu), and indeed that's what is restored by "KVM: 
x86: check for interrupts before deciding whether to exit the fast 
path".  The other architectures also have similar checks, though again 
it's a bit hard to find it for book3s_hv (due to not using 
vcpu->requests) and MIPS (which only uses KVM_REQ_TLB_FLUSH).

Paolo

