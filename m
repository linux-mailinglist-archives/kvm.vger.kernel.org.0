Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5C11BDD5B
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 15:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgD2NTV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 09:19:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54469 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726654AbgD2NTU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Apr 2020 09:19:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588166359;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FMUg5MJ5HqN8GWTN2ovWwUAWTwS0eJhOjZ8gpBfrDns=;
        b=RrrZXR8wZ1cHGYdT0jNezHGRyAljVUlTPoDetJovr+6Xpa7YcQD6eJRWx7/ggXyW61hssK
        Xt4noYrU4JiW63arr6nrXfEhCFLGBGXuHeJb0wHKhOmmZxTtV3Rq1VwImfoe3WQGvmXcuI
        oGe5VfY1mpx83BoyyVNBOjKRIYOgcf8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-VIjwa6FAMniWwBl1ABc65w-1; Wed, 29 Apr 2020 09:19:17 -0400
X-MC-Unique: VIjwa6FAMniWwBl1ABc65w-1
Received: by mail-wm1-f72.google.com with SMTP id d134so2611007wmd.0
        for <kvm@vger.kernel.org>; Wed, 29 Apr 2020 06:19:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FMUg5MJ5HqN8GWTN2ovWwUAWTwS0eJhOjZ8gpBfrDns=;
        b=mn6255+z9rQV3/1UkPTuTGQ3YGnqngx5ZBd2j5sn2yyKw+xTkrJJoCPGooCPe2bfMU
         JVco2Zt3BWMvFMe2nDbwpAdE5Wa2HAv4XCcL3UrA7kk/MdFJWgV5OWHClTrgwJiXWO2U
         7Yroa07qGeuNYannpw8LiHf/5Zh7nW0XWnfaIxV5YKJbtEhCec1tUELvGdNsdiIeQHVe
         9v3tBXUv8pakHn7xkaq++pQXPab7NkzzFYggUCB/jZjuJ+k9hpN5eG4uwiulO7PI3dnG
         0lS8VmI7VNepBqpOIzkOn5+RPSHWBrk5Goo6gjJTkWRvsBQUeO6iTsIv0gtPmI8CuRbJ
         SXDA==
X-Gm-Message-State: AGi0PuYOqih/LAuSJDoTO1IQXnV3fA1KbVxaiJ6Jwx+4RY/beI356xlx
        VyupTBgL527qSQCW58DG7FMsqto2FVx79kxqa/8p8+tFg7vmbyogKX+d7xD4ZOdiN9BDVwfe+mb
        9/nNj6MAoYwFp
X-Received: by 2002:adf:f508:: with SMTP id q8mr42083747wro.117.1588166356415;
        Wed, 29 Apr 2020 06:19:16 -0700 (PDT)
X-Google-Smtp-Source: APiQypIVI9BskJLOYHDtLBpbqq6zGNziM2FPZCXQ+TipPyQlqk+qNl4/NDGod3hfECoQdadSu7g7fw==
X-Received: by 2002:adf:f508:: with SMTP id q8mr42083717wro.117.1588166356187;
        Wed, 29 Apr 2020 06:19:16 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id i74sm12241193wri.49.2020.04.29.06.19.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2020 06:19:15 -0700 (PDT)
Subject: Re: [PATCH RFC 6/6] KVM: x86: Switch KVM guest to using interrupts
 for page ready APF delivery
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        kvm@vger.kernel.org
References: <20200429093634.1514902-1-vkuznets@redhat.com>
 <20200429093634.1514902-7-vkuznets@redhat.com>
 <ee587bd6-a06f-8a38-9182-94218f7d08bb@redhat.com>
 <87blnah36e.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <465678b2-4009-f85b-65ec-6c2c7bbc4fa0@redhat.com>
Date:   Wed, 29 Apr 2020 15:19:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <87blnah36e.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/04/20 14:44, Vitaly Kuznetsov wrote:
>>> +			token = __this_cpu_read(apf_reason.token);
>>> +			/*
>>> +			 * Make sure we read 'token' before we reset
>>> +			 * 'reason' or it can get lost.
>>> +			 */
>>> +			mb();
>>> +			__this_cpu_write(apf_reason.reason, 0);
>>> +			kvm_async_pf_task_wake(token);
>>> +		}
>> If tokens cannot be zero, could we avoid using reason for the page ready
>> interrupt (and ultimately retire "reason" completely)?
> Yes, we can switch to using 'token' exclusively but personally I'm not
> sure it is worth it. We'll still have to have a hole and reason + token
> is only u64. Keeping 'reason' in place allows us to easily come up with
> any other type of notification through this mecanism (if the reson is
> ... then 'token' means ...).

If we need a "reason" field I'd rather make it separate from the page
not ready reason, because as we differentiate the delivery mechanism it
is cleaner to keep them separate.

For example, if the reason is present but separate, the memory barrier
is not necessary anymore, because apf_reason.token cannot be written
before the ack MSR is written.  And with #VE there will be already a
hardware-provided mechanism to avoid reentrancy.

Thanks,

Paolo

