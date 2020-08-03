Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 453C523A6FA
	for <lists+kvm@lfdr.de>; Mon,  3 Aug 2020 14:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbgHCM4i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Aug 2020 08:56:38 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:20139 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729713AbgHCM4X (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Aug 2020 08:56:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596459382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j08PD5TKmptgvWzFXs3mBZWsz6N4iiWTg8v49XuWVeU=;
        b=GKdz7Ghr9YShd9AGoU4Cb4IoDWihBHvRqGUTgFFiiJNBGtckEbvBL324XpbNOudf37NTss
        R60lFdKZIQfwHmRF8GzSKv5p77Acc6c5lQi989cCnkQq3b0EVQcCiv3O3bQhZZ3PVc8SFG
        Rvi1nrBbsSUI0HCwwuxfwQO2RA5YWg0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-eT7CheHBPY6YfrjEyBZDSQ-1; Mon, 03 Aug 2020 08:56:20 -0400
X-MC-Unique: eT7CheHBPY6YfrjEyBZDSQ-1
Received: by mail-wr1-f69.google.com with SMTP id j2so9030414wrr.14
        for <kvm@vger.kernel.org>; Mon, 03 Aug 2020 05:56:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j08PD5TKmptgvWzFXs3mBZWsz6N4iiWTg8v49XuWVeU=;
        b=RF55NJWrLDfqTCMltS4VjwAh0gaMSNxRXJ6AuPcV5CL1hnPvg9Fhd72XA4Gn79J6nt
         NmZCaRswM7yvqtSXf/z/J+JDmvFc5tbxsuwv2tR/uNX4Vqb56c6TX2dJiiE56UTdsSeQ
         4MSaDlGqmMWny72mnbx76avvtcy8ONHeKfIKsMCXdmvTsli8JjRkX+D9vqa8NpQrgmzp
         Vr/0RElYfgDCEzUfjxvE6fYPgbIdittkWWkUK2fJfU/pNInSmEvbJqnuv3KOgGc1V88C
         HNnG4nsMt24kD35PNj8k0kZ+yPzk9hVTWmILvONuWeqkbX/H+SwACxqTcTJFW0tzjNyJ
         9VJA==
X-Gm-Message-State: AOAM532oQ5SfDPgCT/bBLaYK1xLfTWdZV2933lEQ+RIK6zoF1RySho45
        2nMF/mt0eZKlIC+ylJi3FPco48UXUNwsTAKhzFGB0RGBBZ4lnciH2nbKpgEOe0r67+P9SoiMe3a
        8OvIMCw0V7XeJ
X-Received: by 2002:a05:600c:224e:: with SMTP id a14mr35962wmm.80.1596459379611;
        Mon, 03 Aug 2020 05:56:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxpW1uePH536qqOxGNXww+3gN09vvUWEp1fYIiGFThtlO3NOlBdsdybu1o6t4YT+t/ZuhUTSg==
X-Received: by 2002:a05:600c:224e:: with SMTP id a14mr35945wmm.80.1596459379370;
        Mon, 03 Aug 2020 05:56:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7841:78cc:18c6:1e20? ([2001:b07:6468:f312:7841:78cc:18c6:1e20])
        by smtp.gmail.com with ESMTPSA id o125sm7749016wma.27.2020.08.03.05.56.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2020 05:56:18 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: tscdeadline timer testing when apic
 is hw disabled
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <kernellwp@gmail.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1596441715-14959-1-git-send-email-wanpengli@tencent.com>
 <87wo2fq4up.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <aa3131be-5421-5a06-c582-232d6b34fe38@redhat.com>
Date:   Mon, 3 Aug 2020 14:56:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <87wo2fq4up.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/08/20 14:41, Vitaly Kuznetsov wrote:
>> -    report(tdt_count == 1, "tsc deadline timer");
>> -    report(rdmsr(MSR_IA32_TSCDEADLINE) == 0, "tsc deadline timer clearing");
>> +    if (apic_enabled) {
>> +        report(tdt_count == 1, "tsc deadline timer");
>> +        report(rdmsr(MSR_IA32_TSCDEADLINE) == 0, "tsc deadline timer clearing");
>> +    } else
>> +        report(rdmsr(MSR_IA32_TSCDEADLINE) == 0, "tsc deadline timer is not set");
> I'd suggest we also check that the timer didn't fire, e.g.
> 
> report(tdt_count == 0, "tsc deadline timer didn't fire");
> 
> as a bonus, we'd get another reason to use braces for both branches of
> the 'if' (which is a good thing regardless).
> 

Agreed, and KVM also needs to return 0 if the APIC is hardware-disabled
I think?

Paolo

