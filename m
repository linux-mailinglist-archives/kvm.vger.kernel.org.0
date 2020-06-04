Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573A41EE8DC
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 18:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729979AbgFDQtu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 12:49:50 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:55783 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729115AbgFDQtt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Jun 2020 12:49:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591289388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oSloQZeBlmDu003tkw98+MiGlwjq8F4b7bZsC7a+EE8=;
        b=ZukNzRkE+/Id7oKoUo9EfaSGS80I5HbqFoA8tCIgbqE3Kq27Xa48zL2KivKexaeOJQzyiy
        6UXHEihlECkPnI4jY9yz9imACFBpO2N4YkMDn7KJRf+9MfQiaE/xoxQSPeXhorld580bRa
        ZuMhaM64EWV44j5Bh1CqKxl9hA74DQo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-56-sdsV3r7oNKKpIRn7OqTlJg-1; Thu, 04 Jun 2020 12:49:46 -0400
X-MC-Unique: sdsV3r7oNKKpIRn7OqTlJg-1
Received: by mail-wr1-f69.google.com with SMTP id w4so2660304wrl.13
        for <kvm@vger.kernel.org>; Thu, 04 Jun 2020 09:49:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oSloQZeBlmDu003tkw98+MiGlwjq8F4b7bZsC7a+EE8=;
        b=Yrt8wb0zocgiKE7qKZiyerxOX2dh045HErTW7Ja04U5uyhru5DA1ijfY4jz5wIzfxT
         OK+l1BLsrSol2ZqmNrmvkFOkggvJ7LtLJRblvlyPQuGMQWm8DTZKuw7noIqB8AubO5IW
         KRmtAI9p3j/BzLenR+p9C9neitb1GrQFjlNU53UCoFrOCIBvq+N7L3RWJKA5/xclPHMI
         WzyP5S3MlUq9vhbRaNEERBEq94cDkrWMsDJlZCigOwjhA4zrUxmc3OAekvCEtclclmy1
         hSzFpzCTU4DGqlbY8Mb7ZalWdOn6ItB/G3WhrLekR5UF6bqDQopUTkYoIAr5WXlrGfzC
         IUJg==
X-Gm-Message-State: AOAM530Ohz60g3rIkzel1XQZz/nvtA4tapWaBxgRDT957yo2kI644KPB
        Ugm850D376htHQsIPAjMd+6TyBaOqxh5M3fYm0WZKXBujwN283lMHqMj0+3a3h0ripyyoFBQ6Lr
        l5HAl3Z3Q8Ghl
X-Received: by 2002:a1c:230a:: with SMTP id j10mr4793483wmj.124.1591289385469;
        Thu, 04 Jun 2020 09:49:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwE7rQk5s9bJwM1Naq3r1F2RgivXWUzdGerP9kYwoNx+OOi8MvDJjnups/+JhoUTzbmaitu8A==
X-Received: by 2002:a1c:230a:: with SMTP id j10mr4793461wmj.124.1591289385262;
        Thu, 04 Jun 2020 09:49:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:a0c0:5d2e:1d35:17bb? ([2001:b07:6468:f312:a0c0:5d2e:1d35:17bb])
        by smtp.gmail.com with ESMTPSA id t7sm8832001wrq.41.2020.06.04.09.49.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2020 09:49:44 -0700 (PDT)
Subject: Re: [PATCH] KVM: VMX: Always treat MSR_IA32_PERF_CAPABILITIES as a
 valid PMU MSR
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        "Xu, Like" <like.xu@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Like Xu <like.xu@linux.intel.com>
References: <20200603203303.28545-1-sean.j.christopherson@intel.com>
 <46f57aa8-e278-b4fd-7ac8-523836308051@intel.com>
 <20200604151638.GD30223@linux.intel.com>
 <f7a234a7-664b-9160-f467-48b807d47c8b@redhat.com>
 <CALMp9eQoKJg36AabLErekJ-U10-DkRHW=dn14q0bxQHh7XrGMQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <285863c6-ef4b-a6f0-d223-ebc7cc515f84@redhat.com>
Date:   Thu, 4 Jun 2020 18:49:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eQoKJg36AabLErekJ-U10-DkRHW=dn14q0bxQHh7XrGMQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/06/20 18:44, Jim Mattson wrote:
>>> I don't know if I would call it a "good assumption" so much as a "necessary
>>> assumption".  KVM_{GET,SET}_MSRS are allowed, and must function correctly,
>>> if they're called prior to KVM_SET_CPUID{2}.
>> Generally speaking this is not the case for the PMU; get_gp_pmc for
>> example depends on pmu->nr_arch_gp_counters which is initialized based
>> on CPUID leaf 0xA.
>>
>> The assumption that this patch fixes is that you can blindly take the
>> output of KVM_GET_MSR_INDEX_LIST and pass it to KVM_{GET,SET}_MSRS.
> 
> Is that an assumption or an invariant?

Both, I guess (a valid assumption for userspace, an invariant to be
respected for the kernel code).

The part where we don't fare to well, is that a bunch of MSRs that need
save/restore are _not_ included in KVM_GET_MSR_INDEX_LIST (and the PMU
is the biggest if not the only offender there).

Paolo

