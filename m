Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41FE61BE129
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 16:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgD2Oee (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 10:34:34 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:21356 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726503AbgD2Oee (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Apr 2020 10:34:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588170872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p4kiLu8V0HCQMULCb4mzXR2k3NPYOqPbuW0DbQgjM/E=;
        b=XRi9J4ZQgojT/1ZV9Q5RT2IxbYs5J7YpDI4shl5/bKk+sYlgqajHWUYFOp0zuS02AD09/K
        9I27Fp/nyJFXVJ7t+rYH7oRm8rHvlUvlsy/AsCAJAFbTcB5T0aHo7sAzlSvl/Fr3ImQIEx
        SfDTOqbLzgKzI5faGGXrpOUcDtHEczQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-xVbJRHx4O2mXR9bRHUhgvQ-1; Wed, 29 Apr 2020 10:34:30 -0400
X-MC-Unique: xVbJRHx4O2mXR9bRHUhgvQ-1
Received: by mail-wm1-f72.google.com with SMTP id d134so2698702wmd.0
        for <kvm@vger.kernel.org>; Wed, 29 Apr 2020 07:34:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=p4kiLu8V0HCQMULCb4mzXR2k3NPYOqPbuW0DbQgjM/E=;
        b=XGkSHIYsmGLnzuub8H90A89wrdPDbCk/NnTmOaSA4vQupJs+mpziOOgSs/Syk/Q64V
         eZIt/HQ8i9B4JMNEs+CUKB/WVFZi3YRuSux8Hv6oTqd2PwBfVGjCsm9dctJOkRG38KYB
         PmH/738poGGks+VEAJmKtKUiiUYP+BDmKWWWsypcmnVO4aCCMcFnsFS7B/y1L7hUDWfI
         9i7aLbwczkvF2gafPHPMs6y8eKdHgsKm8+y0nljBd2uM1tb4bAa+TS++ezAZH+9saHx1
         wdMQ8f8dMFN7r1BFMoq7lRjW7jEQmcMO7mggXyQvzLNYDuoBWKnnOcgCol5MXJnL4BgZ
         RlfA==
X-Gm-Message-State: AGi0PuYx6Wo9x1DFh8f4+smrnvInSBVkrzim+Wbro15gQF4S+d9XJ6cf
        SYxHzYBDkwFTOGzQ7AzsIFovGrp3PrkJCwFKySDqA6lBapkKvUQvETPm92yV05lFXMUVmrYj45P
        aj2jAG3JmZZk0
X-Received: by 2002:a7b:c459:: with SMTP id l25mr3548740wmi.52.1588170869400;
        Wed, 29 Apr 2020 07:34:29 -0700 (PDT)
X-Google-Smtp-Source: APiQypKUYGGAwkA649DZykcL9h0opLmcbvGeZjQ+IUimBYTbNV7txgnKFnO8Th1tobHLYFW8DcCp+w==
X-Received: by 2002:a7b:c459:: with SMTP id l25mr3548713wmi.52.1588170869173;
        Wed, 29 Apr 2020 07:34:29 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id q143sm8603108wme.31.2020.04.29.07.34.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 07:34:28 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH RFC 6/6] KVM: x86: Switch KVM guest to using interrupts for page ready APF delivery
In-Reply-To: <465678b2-4009-f85b-65ec-6c2c7bbc4fa0@redhat.com>
References: <20200429093634.1514902-1-vkuznets@redhat.com> <20200429093634.1514902-7-vkuznets@redhat.com> <ee587bd6-a06f-8a38-9182-94218f7d08bb@redhat.com> <87blnah36e.fsf@vitty.brq.redhat.com> <465678b2-4009-f85b-65ec-6c2c7bbc4fa0@redhat.com>
Date:   Wed, 29 Apr 2020 16:34:27 +0200
Message-ID: <871ro6gy30.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 29/04/20 14:44, Vitaly Kuznetsov wrote:
>>>> +			token = __this_cpu_read(apf_reason.token);
>>>> +			/*
>>>> +			 * Make sure we read 'token' before we reset
>>>> +			 * 'reason' or it can get lost.
>>>> +			 */
>>>> +			mb();
>>>> +			__this_cpu_write(apf_reason.reason, 0);
>>>> +			kvm_async_pf_task_wake(token);
>>>> +		}
>>> If tokens cannot be zero, could we avoid using reason for the page ready
>>> interrupt (and ultimately retire "reason" completely)?
>> Yes, we can switch to using 'token' exclusively but personally I'm not
>> sure it is worth it. We'll still have to have a hole and reason + token
>> is only u64. Keeping 'reason' in place allows us to easily come up with
>> any other type of notification through this mecanism (if the reson is
>> ... then 'token' means ...).
>
> If we need a "reason" field I'd rather make it separate from the page
> not ready reason, because as we differentiate the delivery mechanism it
> is cleaner to keep them separate.
>
> For example, if the reason is present but separate, the memory barrier
> is not necessary anymore, because apf_reason.token cannot be written
> before the ack MSR is written.  And with #VE there will be already a
> hardware-provided mechanism to avoid reentrancy.

Ok, makes sense. I'll probably use your original idea and use 'token'
for 'page ready' notification exclusively for now. In case of need we
can always extend 'struct kvm_vcpu_pv_apf_data' with the information we
need so we can avoid adding 'reason2' for now.

-- 
Vitaly

