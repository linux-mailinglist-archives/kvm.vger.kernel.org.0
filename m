Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5363B47A1EA
	for <lists+kvm@lfdr.de>; Sun, 19 Dec 2021 20:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236442AbhLSTY3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Dec 2021 14:24:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236385AbhLSTY3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Dec 2021 14:24:29 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC87C061574;
        Sun, 19 Dec 2021 11:24:28 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id b13so1306039edd.8;
        Sun, 19 Dec 2021 11:24:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pkPP4iGTlDRZ+kDc6mJgYTbPlXlrZEAvJ9YKfJfOh+c=;
        b=SbWLQq+gvU7j0NgEfZ0+A7Ff48++o1ViPctGvPejpB5i+4v98uGraFgqIwcN7Wylh5
         6CrNVfiJip39etYOgIOPXOj43qqsizMFGkvMVKSB0G1lQEvvBQ+VbEijR8LdiQMsSlKs
         Iro83rS1xDPGPJPptqtTuswIxnP0dX/2m4a5y5g59BOFhJ3CKyR+0IPCbUEj7hOKT91W
         tqDZCg9tlyynfHBHBzqmPHej1GMjcvfrNMSyNoRvwU4DJhvUxSKz4RR5mJaf+wEgeXfZ
         X5l628OUPi5Y9QfMNP5E+2lXWUN80EHmUka0sfb9D7w/7/GZ7mgjBmFWedtNW/20Se5D
         KtDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pkPP4iGTlDRZ+kDc6mJgYTbPlXlrZEAvJ9YKfJfOh+c=;
        b=EFJ40pF2qLpZa8O+e+tcnA7Mo8953f9+iyEPs2Xgovmg5SUgPevmpem3JU4tt2yJIG
         GTVM9Y+Tbd6qWojzWz8oOEc4t1G8kOumwyADuz+jiplCkT4rUpwdmgNem1ZmLjg0wCEF
         L3WxpyE6tu7yc5nU8AG8aN5JgHfIzrAhCVeBpTQCF8+GIDWIvpt/41gWzIe5+VrIOPXd
         3KFj5pu8xZErvXtIB5By6lCh5wrMntZCtOiYbHmr3jbHwdEAmVFz5xP1ZIOZOvNmW+9k
         LlDKquMNz3L15AfV/poaa2hps7jU+5i7PJK+B9oliYZ45B7uYpWbgwurPuowANuxxxqV
         eRUA==
X-Gm-Message-State: AOAM530q4rnURnHxSFRcEi3tOWqTuQDldjBYTCkv/y5c55ZMdE5nW5Ot
        UAHZrPTDR2HAH/Xwk9FYMcvKZiYBfRI=
X-Google-Smtp-Source: ABdhPJxpBEqyMSRaAXBbgedrP8Kho8c5RRjOq3U0R1tLuCxnaVXBD3G3bGS0eeYkGTfWh4W5PWtwYQ==
X-Received: by 2002:a05:6402:254b:: with SMTP id l11mr12812265edb.225.1639941867330;
        Sun, 19 Dec 2021 11:24:27 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id c13sm4637209ejj.144.2021.12.19.11.24.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Dec 2021 11:24:26 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <34c091cb-1eed-d15f-a61c-30518d322a65@redhat.com>
Date:   Sun, 19 Dec 2021 20:24:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 0/2] KVM: x86: Fix MSR_IA32_PERF_CAPABILITIES writes
 check and vmx_pmu_msrs_test
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, oliver.sang@intel.com,
        Like Xu <like.xu@linux.intel.com>, linux-kernel@vger.kernel.org
References: <20211216165213.338923-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211216165213.338923-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/16/21 17:52, Vitaly Kuznetsov wrote:
> This is a continuation of "KVM: selftests: Avoid KVM_SET_CPUID2 after
> KVM_RUN in vmx_pmu_msrs_test" work. Instead of fixing the immediate issue,
> drop incorrect check in KVM which was making the result of host initiated
> writes to MSR_IA32_PERF_CAPABILITIES dependent on guest visible CPUIDs and
> the corresponding tests in vmx_pmu_msrs_test, this will also make the issue
> reported by kernel test robot to go away.
> 
> Vitaly Kuznetsov (2):
>    KVM: selftests: vmx_pmu_msrs_test: Drop tests mangling guest visible
>      CPUIDs
>    KVM: x86: Drop guest CPUID check for host initiated writes to
>      MSR_IA32_PERF_CAPABILITIES
> 
>   arch/x86/kvm/x86.c                              |  2 +-
>   .../selftests/kvm/x86_64/vmx_pmu_msrs_test.c    | 17 -----------------
>   2 files changed, 1 insertion(+), 18 deletions(-)
> 

Queued, thanks,

Paolo
