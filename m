Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD2E11B5891
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 11:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgDWJwj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 05:52:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59186 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725884AbgDWJwj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 05:52:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587635557;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wfTWHpfgM90dhku3gSYt8YyCxLtENM52kAFB9Xkdy/Y=;
        b=fNs81Mai4744UWS79xKxj69yXxiVs1ju/Y8y1KnFbQRjNI7OP6gSi8Qk6apGMtb1Vspoji
        61W6ktoENzQU2Cte5h4D1sZ2+KPApnam+A4+9rknBEApzjD04SyYynKBZCxmuOmM8fJ2Gk
        ZBsFq0uF1iA8RMUWbjUsDs6WW8za9Kg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-498-eMszxs8YMH-hM-7acwTXhQ-1; Thu, 23 Apr 2020 05:52:35 -0400
X-MC-Unique: eMszxs8YMH-hM-7acwTXhQ-1
Received: by mail-wr1-f72.google.com with SMTP id r17so2586092wrg.19
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 02:52:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wfTWHpfgM90dhku3gSYt8YyCxLtENM52kAFB9Xkdy/Y=;
        b=bC+gn5lBfrouB/WSTEP5VWUUg408zxbCPCcm5vQGHrBuXchk3/j1BaMSTlm7UMN6we
         N63668cyIYohE3wYtyEOjj0OM6DrI1AkOV6ENnoJwqj6Q3Gp7J1ofs1reuR8OtvzrheU
         as19A67J963Ksf3MSijnE2Zl8ytm7et5dVkqRatarQKc889MZzf+uDcWv1qMVjcHzw3f
         P6YvkFJkuh8wJAN669QoS7X1SaomZRFwRxlgxUAF3MDj6uKYCn4RtJPisMLf/O2SWSz0
         0XY4LqQvMgMIm3q1j+L3h/bV/IXce9kMvKepsmWBKgkJk76BOQPb/sctFxIsAI2YPLCh
         S77Q==
X-Gm-Message-State: AGi0PuYeI3EKAQmBNQXxL3nj8/d/HT/m+fOPB5mV9QIs40fwmEoHuR00
        QoKiaRA4Wwfen28TkNCV0HhjDZ2EfmURsj1ZzESinu3Sr+4yQSZcWdiAhZry9rZuoLqn5hRwuYV
        Wtem3cVLoj9aK
X-Received: by 2002:adf:edc6:: with SMTP id v6mr3935896wro.8.1587635554376;
        Thu, 23 Apr 2020 02:52:34 -0700 (PDT)
X-Google-Smtp-Source: APiQypKfAiNuOF9QP8LaFJne9ECJ8ndLYf/hYMVlrB3b8SbuEYpG21/xow0J3Jf8cXJSSsfo5rTEWg==
X-Received: by 2002:adf:edc6:: with SMTP id v6mr3935877wro.8.1587635554166;
        Thu, 23 Apr 2020 02:52:34 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id x13sm3119979wmc.5.2020.04.23.02.52.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2020 02:52:33 -0700 (PDT)
Subject: Re: [PATCH v2 1/5] KVM: LAPIC: Introduce interrupt delivery fastpath
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
References: <1587632507-18997-1-git-send-email-wanpengli@tencent.com>
 <1587632507-18997-2-git-send-email-wanpengli@tencent.com>
 <09cba36c-61d8-e660-295d-af54ceb36036@redhat.com>
 <CANRm+Cybksev1jJK7Fuog43G9zBCqmtLTYGvqAdCwpw3f6z0yA@mail.gmail.com>
 <8a29181c-c6bb-fe36-51ac-49d764819393@redhat.com>
 <CANRm+CzFgbuYY6t8E0OihXMzRV8ePjnoZPUPXxGcexbL8gKfEA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0c77ae96-09ec-985b-a8d7-a4ba7e80b18f@redhat.com>
Date:   Thu, 23 Apr 2020 11:52:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CANRm+CzFgbuYY6t8E0OihXMzRV8ePjnoZPUPXxGcexbL8gKfEA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/04/20 11:44, Wanpeng Li wrote:
>>>> Would it help to make the above
>>>> 
>>>>         if (vcpu != kvm_get_running_vcpu() &&
>>>>             !kvm_vcpu_trigger_posted_interrupt(vcpu, false))
>>>>                 kvm_vcpu_kick(vcpu);
>>>> 
>>>> ?  If that is enough for the APICv case, it's good enough.
>>>
>>> We will not exit from vmx_vcpu_run to vcpu_enter_guest, so it will not
>>> help, right?
>>
>> Oh indeed---the call to sync_pir_to_irr is in vcpu_enter_guest.  You can
>> add it to patch 3 right before "goto cont_run", since AMD does not need it.
>
> Just move kvm_x86_ops.sync_pir_to_irr(vcpu)? How about the set pir/on
> part for APICv and non-APICv part in fast_deliver_interrupt()?

That should be handled by deliver_posted_interrupt with no performance
penalty, if you add "vcpu != kvm_get_running_vcpu()" before it calls
kvm_vcpu_trigger_posted_interrupt.

Paolo

