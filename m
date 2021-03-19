Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D810934187D
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 10:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbhCSJfo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 05:35:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40969 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229634AbhCSJfe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Mar 2021 05:35:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616146533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=v0qSmwIT5N+CbjMy2lvgAIyfnAl4gMgwXlTqcR5dsag=;
        b=bezFqpcagTONGEyC9kqGieFtN94L2rIh9NIj4Z/JF6c8jERdESjwrsYwowsSV9hwHpazfv
        5+uOUBCB20ICbi7WsRIwH+Hq6CLc7z60vj0ig65BNi/7AvmvKulUZgdGqUFGT0P1cJtctX
        Sa5IIqkz+RrliegGr5i45qAYfRwr8Dk=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-546-hDymj2bIPoaXUBe-fKj7nQ-1; Fri, 19 Mar 2021 05:35:31 -0400
X-MC-Unique: hDymj2bIPoaXUBe-fKj7nQ-1
Received: by mail-ej1-f72.google.com with SMTP id en21so17972745ejc.2
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 02:35:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=v0qSmwIT5N+CbjMy2lvgAIyfnAl4gMgwXlTqcR5dsag=;
        b=ZnIGhlQnpq+MlL6WQX/mKMxkQSdaa/MtkswAl7NrVEDYrR/0JlLQat+zqmgNfY7XQF
         2a1FiCEtBD1llN1S03esg81/eXJJbvmv7sSiwVzGv7VciVnXF1EH3S9Rt+DqPcRuHV5/
         hV6e9/WE5d0FgZMUoZpY0s66qphYlMMNchoys3cQzVrqrFePhGsnNMGqPGOqDm/MBe2i
         Q7mUWFHjdZ7dej+r/evVBjfWByqO0sNLK81YRsyBSIuzOOAZ4Da06oVzMZPWoBGLa0wx
         ZASX6a2iMWm3BQeFbX472Dw8T/uq9E+k5XPbGoCyeZ/8jJrbZKMP0R0N2dgeSDBCZq7D
         IMxw==
X-Gm-Message-State: AOAM532G5TpIcY3wCW8n6RlWVKFKxxn7Kcqrv88iLil5l5vTlF3kG1J7
        R8VD+voNv6FauX+yjPHfhvk6PwyQYrPsLgvJhXznWziiI1S0a6O50Wu4F1ukn/lMDnllyKDap/9
        eYSNUr8ph20l+
X-Received: by 2002:a17:907:3e9e:: with SMTP id hs30mr3328232ejc.66.1616146530576;
        Fri, 19 Mar 2021 02:35:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw5JS4NgKbP2/KFgVMB0LU0zJpx5iQ2opWHV1CnrZu6Fttiu0mu/Qis3+kFVpCLudDWFXHy1g==
X-Received: by 2002:a17:907:3e9e:: with SMTP id hs30mr3328219ejc.66.1616146530446;
        Fri, 19 Mar 2021 02:35:30 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id eo22sm3367524ejc.0.2021.03.19.02.35.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 02:35:30 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 6/4] selftests: kvm: Add basic Hyper-V clocksources
 tests
In-Reply-To: <20210318175515.GA40821@fuller.cnet>
References: <20210316143736.964151-1-vkuznets@redhat.com>
 <20210318140949.1065740-1-vkuznets@redhat.com>
 <20210318165756.GA36190@fuller.cnet>
 <4882dc8f-30bf-f049-f770-24811bb96b54@redhat.com>
 <20210318175515.GA40821@fuller.cnet>
Date:   Fri, 19 Mar 2021 10:35:29 +0100
Message-ID: <87pmzv5vvi.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Marcelo Tosatti <mtosatti@redhat.com> writes:

> On Thu, Mar 18, 2021 at 06:50:35PM +0100, Paolo Bonzini wrote:
>> On 18/03/21 17:57, Marcelo Tosatti wrote:
>> > I think this should be monotonically increasing:
>> > 
>> > 1.	r1 = rdtsc();
>> > 2.	t1 = rdmsr(HV_X64_MSR_TIME_REF_COUNT);
>> > 3.	nop_loop();
>> > 4.	r2 = rdtsc();
>> > 5.	t2 = rdmsr(HV_X64_MSR_TIME_REF_COUNT);	
>> > 
>> > > 
>> > > +	/* 1% tolerance */
>> > > +	GUEST_ASSERT(delta_ns * 100 < (t2 - t1) * 100);
>> > > +}
>> > 
>> > Doesnt an unbounded schedule-out/schedule-in (which resembles
>> > overloaded host) of the qemu-kvm vcpu in any of the points 1,2,3,4,5
>> > break the assertion above?
>> 
>> 
>> Yes, there's a window of a handful of instructions (at least on
>> non-preemptible kernels).  If anyone ever hits it, we can run the test 100
>> times and check that it passes at least 95 or 99 of them.
>> 
>> Paolo
>
> Yep, sounds like a good solution.
>
> However this makes me wonder on the validity of the test: what its
> trying to verify, again? (i would check the monotonicity that 
> is r1 <= t1 <= r2 <= t2 as well, without the nop_loop in between).

This particular place tests that Reference TSC
(HV_X64_MSR_TIME_REF_COUNT) is a 1Ghz clock. We test it against raw
TSC. TSC frequency is known to us (HV_X64_MSR_TSC_FREQUENCY) so we can
compare the delta after nop_loop().

We can't directly compare r1 and t1 (and r2 and t2) here because we
don't know the base precisely. We could've probably reset TSC to 0 and
kvmclock (which converts to Reference TSC) to 0 and compare after. For
now, we just check that Reference TSC is ticking as it should.

-- 
Vitaly

