Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23BB334CD2E
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 11:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbhC2JkU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 05:40:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43092 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231784AbhC2Jj6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Mar 2021 05:39:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617010797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XH1p60GLm1qMEaeWBYCic3Rl4rfDvGvY/I2BlpVV/RY=;
        b=gGZ8iOoaQFBq8fDw2J88AJqJST0eHpelW8M+IBIpNDB7yMjBu3qejyvsTN4JxTav9AlhWr
        Za2CggjNtvbJitXMq361DbbhGWSc0Bl9dsrK0M74BMOX62t0mvUdQYl7ARxoYOKdGjiVgC
        uuaxv+RaNQPUjf2CH5QHxuUiPtc22S0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-iSunCkH0O-KAw27O7j8wGQ-1; Mon, 29 Mar 2021 05:39:55 -0400
X-MC-Unique: iSunCkH0O-KAw27O7j8wGQ-1
Received: by mail-wm1-f70.google.com with SMTP id c9so1410258wme.5
        for <kvm@vger.kernel.org>; Mon, 29 Mar 2021 02:39:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XH1p60GLm1qMEaeWBYCic3Rl4rfDvGvY/I2BlpVV/RY=;
        b=hI6zQlb6X/8DqGlOh76b4SXFJAYrDBx6Dc5/4jpXpAyttx8NER99KBjfzL4eH7y0yx
         2lo/wsrO5zGiJ5bUV56Qaaa4z5hB0bX4fMGuUgxn2WhknTOqRLOu+8GsmkZ8mLlpzLfy
         ncWGz6pZFVJu3tUxiIfQEjt5iC1NK0rD9j2KH1GLjjC+iLOybbWG34Gax4I8WTdT6vT7
         oIRpgkxmgxxT4Dtz18J5XE/MrA00HACdAtxVxbRLjUOSF81yuLOFY6cCmVVNuH+ZBYWl
         iCa18b305r8SP+lrUSJfPppKJBSROKoiZQb7WV4Jk2PvNvUa/QwBb4R7wAp+kusqUb2V
         XEOA==
X-Gm-Message-State: AOAM53254gIP9CvRpld4XZzvEGwVwINePBgTuT/ijZtaQV69i4w61/D4
        YEYey1WDUJO9qKle+JkAbJ/8h7qZ2JAavZT2K5He7YuFVyrFnE4tHhLAwkcq7qgDc2Kjj+AquuG
        AOK9fc29kIuv+
X-Received: by 2002:a05:600c:203:: with SMTP id 3mr23780397wmi.88.1617010794684;
        Mon, 29 Mar 2021 02:39:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxdSnNJS7HC+pi2XoA8apSkQkFQkiLJqju8IpJxHu6Mftlx0OI7Nd1JagHG7r7oN3w6uh/2pw==
X-Received: by 2002:a05:600c:203:: with SMTP id 3mr23780386wmi.88.1617010794459;
        Mon, 29 Mar 2021 02:39:54 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id j13sm28646969wrt.29.2021.03.29.02.39.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Mar 2021 02:39:53 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86/vPMU: Forbid writing to MSR_F15H_PERF MSRs when
 guest doesn't have X86_FEATURE_PERFCTR_CORE
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Wei Huang <wei.huang2@amd.com>, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org
References: <20210323084515.1346540-1-vkuznets@redhat.com>
 <a40090f1-23a1-fca0-3105-b5e48ee5c86e@redhat.com>
 <874kgubau4.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d7310ec0-4c4c-0d1c-5725-5377b539344a@redhat.com>
Date:   Mon, 29 Mar 2021 11:39:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <874kgubau4.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/03/21 10:52, Vitaly Kuznetsov wrote:
> Paolo Bonzini <pbonzini@redhat.com> writes:
> 
>> On 23/03/21 09:45, Vitaly Kuznetsov wrote:
>>> MSR_F15H_PERF_CTL0-5, MSR_F15H_PERF_CTR0-5 MSRs are only available when
>>> X86_FEATURE_PERFCTR_CORE CPUID bit was exposed to the guest. KVM, however,
>>> allows these MSRs unconditionally because kvm_pmu_is_valid_msr() ->
>>> amd_msr_idx_to_pmc() check always passes and because kvm_pmu_set_msr() ->
>>> amd_pmu_set_msr() doesn't fail.
>>>
>>> In case of a counter (CTRn), no big harm is done as we only increase
>>> internal PMC's value but in case of an eventsel (CTLn), we go deep into
>>> perf internals with a non-existing counter.
>>>
>>> Note, kvm_get_msr_common() just returns '0' when these MSRs don't exist
>>> and this also seems to contradict architectural behavior which is #GP
>>> (I did check one old Opteron host) but changing this status quo is a bit
>>> scarier.
>>
>> Hmm, since these do have a cpuid bit it may not be that scary.
> 
> Well, if you're not scared I can send a patch)

Go ahead.

Paolo

