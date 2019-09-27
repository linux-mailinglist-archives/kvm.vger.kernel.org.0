Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82B5AC07C1
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 16:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727273AbfI0Okv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 10:40:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57912 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727079AbfI0Okv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 10:40:51 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E1697793EC
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 14:40:50 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id t11so1119842wrq.19
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 07:40:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Pk1evKePNSA6NDO9ImZg8fJkum1wFeLbxRXQAsyLU8I=;
        b=mru8ho8MXKWWU3F6wEMojlsmsWJwUlkaczM/6E0YZ53ShTJBncnNDTQ67GJtg68x7j
         g+Fkbt7EDILBJeIjOjNK0kU6GkqqZBPfNz8Bmk3pQ4d1yt5rQ8IpRx91stYMFCpJWVwO
         Wh0AEkpysFDh+3TtiPmst/GOIRWLoIiu7hMtFwrw2WUTNkcQDy4C/rEDp5u8VSYZloWI
         uq7yYmyYhKKkURU4jU2WEgNVjamdZyzsMyLiW4YdkU00eTM1lF5ZgBZiGu5CAqp/5vmY
         IunbymjQ0YMwTKZ78WIhsvMKM5K7gxPXVv8WR2W6Obd3mr+Ojq04x1oazFmdvtPRZUpo
         HyYQ==
X-Gm-Message-State: APjAAAWp2L3noyOIVgfTuTmogOVwpFF7rcQbq+yzNkVk+wjqALdPdToD
        GQi1kqYiS6twOcf46PW2FGdjH7PfxYzzFiKh4gXA/jVsxbSicujNg2nL/om2zi+ov+8T+AXiWoz
        wEdWe0aXb3m/2
X-Received: by 2002:adf:df91:: with SMTP id z17mr3241711wrl.116.1569595249649;
        Fri, 27 Sep 2019 07:40:49 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyJk3X4agZrlTnSc1wUSofn/5yvWhKuNCrfb3xY2WvSbOcZPJ2hnwwJrnbR3KBwefDNUxA2xA==
X-Received: by 2002:adf:df91:: with SMTP id z17mr3241694wrl.116.1569595249403;
        Fri, 27 Sep 2019 07:40:49 -0700 (PDT)
Received: from vitty.brq.redhat.com ([95.82.135.182])
        by smtp.gmail.com with ESMTPSA id w12sm5676906wrg.47.2019.09.27.07.40.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2019 07:40:48 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Eric Hankland <ehankland@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [PATCH] kvm: x86: Add Intel PMU MSRs to msrs_to_save[]
In-Reply-To: <6e6f46fe-6e11-c5e3-d80c-327f77b91907@redhat.com>
References: <20190821182004.102768-1-jmattson@google.com> <CALMp9eTtA5ZXJyWcOpe-pQ66X3sTgCR4-BHec_R3e1-j1FZyZw@mail.gmail.com> <8907173e-9f27-6769-09fc-0b82c22d6352@oracle.com> <CALMp9eSkognb2hJSuENK+5PSgE8sYzQP=4ioERge6ZaFg1=PEA@mail.gmail.com> <cb7c570c-389c-2e96-ba46-555218ba60ed@oracle.com> <CALMp9eQULvr5wKt1Aw3MR+tbeNgvA_4p__6n1YTkWjMHCaEmLw@mail.gmail.com> <CALMp9eS1fUVcnVHhty60fUgk3-NuvELMOUFqQmqPLE-Nqy0dFQ@mail.gmail.com> <56e7fad0-d577-41db-0b81-363975dc2ca7@redhat.com> <87ftkh6e19.fsf@vitty.brq.redhat.com> <6e6f46fe-6e11-c5e3-d80c-327f77b91907@redhat.com>
Date:   Fri, 27 Sep 2019 16:40:47 +0200
Message-ID: <87d0fl6bv4.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 27/09/19 15:53, Vitaly Kuznetsov wrote:
>> Paolo Bonzini <pbonzini@redhat.com> writes:
>> 
>>> Queued, thanks.
>> 
>> I'm sorry for late feedback but this commit seems to be causing
>> selftests failures for me, e.g.:
>> 
>> # ./x86_64/state_test 
>> Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
>> Guest physical address width detected: 46
>> ==== Test Assertion Failure ====
>>   lib/x86_64/processor.c:1089: r == nmsrs
>>   pid=14431 tid=14431 - Argument list too long
>>      1	0x000000000040a55f: vcpu_save_state at processor.c:1088 (discriminator 3)
>>      2	0x00000000004010e3: main at state_test.c:171 (discriminator 4)
>>      3	0x00007f881eb453d4: ?? ??:0
>>      4	0x0000000000401287: _start at ??:?
>>   Unexpected result from KVM_GET_MSRS, r: 36 (failed at 194)
>> 
>> Is this something known already or should I investigate?
>
> No, I didn't know about it, it works here.
>

Ok, this is a bit weird :-) '194' is 'MSR_ARCH_PERFMON_EVENTSEL0 +
14'. In intel_pmu_refresh() nr_arch_gp_counters is set to '8', however,
rdmsr_safe() for this MSR passes in kvm_init_msr_list() (but it fails
for 0x18e..0x193!) so it stay in the list. get_gp_pmc(), however, checks
it against nr_arch_gp_counters and returns a failure.

Oh, btw, this is Intel(R) Xeon(R) CPU E5-2603 v3

So apparently rdmsr_safe() check in kvm_init_msr_list() is not enough,
for PMU MSRs we need to do extra.

-- 
Vitaly
