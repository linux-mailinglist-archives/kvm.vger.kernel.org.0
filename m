Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D923FD9816
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 19:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436486AbfJPRB1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 13:01:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39112 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406557AbfJPRB1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 13:01:27 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 714A584A5
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 17:01:26 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id i10so11994027wrb.20
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 10:01:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=upYwB/N4xOr/Zf5KHa95URT+5bIQEUVNJJQrCk7v8M8=;
        b=brj5r2eg+Sji3ujfd12/GAaIFVOPjWzoM2a1Wy36zCTdOGvOopMuAuM8Gl3fz21sAY
         3+wKo9VF3FtsC+sSbPBhpHoJqa5AHsSrIsDQ4IEAhDdqQXmLt0Z5c9JuLtI0Qbpxuis5
         Qzi9XYPCPfabANLxydAG9NJIF/k17efupvifULtJNHU98q7HehRjij+IEJWZVDmRa8Pc
         ZR4cNJ4P4aFDbH0OOkeyKgRlZty/2MbpPSqQRP/4GmWc4oTL+qBzVEMUEwlhInivHoKv
         WIu8BU4GUrkCJZC4tYYHLUO2OOKOIIMtsNW8I6wki9oukRsFNG2CvqwJMrjvGeFghnJh
         LMQA==
X-Gm-Message-State: APjAAAWO+gZ/wCU2ff95pTR9u17v2ocQEi9LMBnOpvZgQVQj0zDXRkMD
        VqkFfG3iEDI9DqyUVkJlYkW4aknmOm1FcvNs6dPxaLYn2ZNIIq4OMWoUj39/srOnfuPTF3qT+I5
        ZVPe9aWR+ga3p
X-Received: by 2002:adf:e488:: with SMTP id i8mr3608237wrm.302.1571245285030;
        Wed, 16 Oct 2019 10:01:25 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzGJ1RJa5XRkUof+e00QM01ARDkvGSCrkuV55PLQw4Jq3hOnJV0Ei3CilXy8Sl4JrmzhL4Nuw==
X-Received: by 2002:adf:e488:: with SMTP id i8mr3608206wrm.302.1571245284676;
        Wed, 16 Oct 2019 10:01:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d001:591b:c73b:6c41? ([2001:b07:6468:f312:d001:591b:c73b:6c41])
        by smtp.gmail.com with ESMTPSA id v6sm4038429wma.24.2019.10.16.10.01.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Oct 2019 10:01:24 -0700 (PDT)
Subject: Re: [PATCH 12/14] KVM: retpolines: x86: eliminate retpoline from
 vmx.c exit handlers
To:     Andrea Arcangeli <aarcange@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20190928172323.14663-1-aarcange@redhat.com>
 <20190928172323.14663-13-aarcange@redhat.com>
 <933ca564-973d-645e-fe9c-9afb64edba5b@redhat.com>
 <20191015164952.GE331@redhat.com>
 <870aaaf3-7a52-f91a-c5f3-fd3c7276a5d9@redhat.com>
 <20191015203516.GF331@redhat.com>
 <f375049a-6a45-c0df-a377-66418c8eb7e8@redhat.com>
 <20191015234229.GC6487@redhat.com>
 <27cc0d6b-6bd7-fcaf-10b4-37bb566871f8@redhat.com>
 <20191016165057.GJ6487@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <0e290a9d-9d26-d24a-ba01-9fda4826a5ac@redhat.com>
Date:   Wed, 16 Oct 2019 19:01:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191016165057.GJ6487@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/10/19 18:50, Andrea Arcangeli wrote:
>> It still doesn't add up.  0.3ms / 5 is 1/15000th of a second; 43us is
>> 1/25000th of a second.  Do you have multiple vCPU perhaps?
> 
> Why would I run any test on UP guests? Rather then spending time doing
> the math on my results, it's probably quicker that you run it yourself:

I don't know, but if you don't say how many vCPUs you have, I cannot do
the math and review the patch.

>> The number of vmexits doesn't count (for HLT).  What counts is how long
>> they take to be serviced, and as long as it's 1us or more the
>> optimization is pointless.
>
> Please note the single_task_running() check which immediately breaks
> the kvm_vcpu_check_block() loop if there's even a single other task
> that can be scheduled in the runqueue of the host CPU.
> 
> What happen when the host is not idle is quoted below:
> 
>          w/o optimization                   with optimization
>          ----------------------             -------------------------
> 0us      vmexit                             vmexit
> 500ns    retpoline                          call vmexit handler directly
> 600ns    retpoline                          kvm_vcpu_check_block()
> 700ns    retpoline                          schedule()
> 800ns    kvm_vcpu_check_block()
> 900ns    schedule()
> ...
> 
> Disclaimer: the numbers on the left are arbitrary and I just cut and
> pasted them from yours, no idea how far off they are.

Yes, of course.  But the idea is the same: yes, because of the retpoline
you run the guest for perhaps 300ns more before schedule()ing, but does
that really matter?  300ns * 20000 times/second is a 0.6% performance
impact, and 300ns is already very generous.  I am not sure it would be
measurable at all.

Paolo

> To be clear, I would find it very reasonable to be requested to proof
> the benefit of the HLT optimization with benchmarks specifics for that
> single one liner, but until then, the idea that we can drop the
> retpoline optimization from the HLT vmexit by just thinking about it,
> still doesn't make sense to me, because by thinking about it I come to
> the opposite conclusion.
> 
> The lack of single_task_running() in the guest driver is also why the
> guest cpuidle haltpoll risks to waste some CPU with host overcommit or
> with the host loaded at full capacity and why we may not assume it to
> be universally enabled.
> 
> Thanks,
> Andrea
> 

