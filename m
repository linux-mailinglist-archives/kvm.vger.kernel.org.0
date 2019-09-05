Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A56CEAA373
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2019 14:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389527AbfIEMqG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Sep 2019 08:46:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39412 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731418AbfIEMqF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Sep 2019 08:46:05 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EEE1B81DE3
        for <kvm@vger.kernel.org>; Thu,  5 Sep 2019 12:46:04 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id v4so393450wmh.9
        for <kvm@vger.kernel.org>; Thu, 05 Sep 2019 05:46:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=cqNmM0Hwlmyj9h/MG6Wvpgg7kXXsJp+5V5Vxs9mhcqU=;
        b=UPSjVX0pHRIhCjTIT0VuwnlytQriDTf98gdH974Tc9ycNqz6JZE9CaN75UAyVkLvWU
         xFdgHclJCHVBjpSkOgZeYP3ywywdYK59ywGgIuwDln9kKmPV6iv7dV/GpY1Q+CQVELy+
         LtzdTQnbq3bOvGfuMyv7CTzH9ZBgaK/e2C7I2kQEnoFfwSA98QO0HKnZ+PIYi47vM130
         pu2UEzJFrhLbcz7XwkZhVY4aO42n+TmAVfcdd/l/1LI3wo1OF5e2saQeuxvgQM6pBxj8
         RsIq/YUS1vGHYqTrn2Q0At3FKG8+ydgWkCfqyN0Pio5LNu2B2gsyWeaWQ6SuTR0ocXx/
         3JKw==
X-Gm-Message-State: APjAAAWh/jMn08ka1amt+o1Ruf39IgYU1HAFmBzDM1tlqX89WiJZ9jcb
        LbYohmh5/r2x1x5+JT9tjMK4KN5k/QOVn4V44gcteva7Nwqs7AuiPrhTftpkkzIgyIuuYud1guG
        AK87NcViJKtB4
X-Received: by 2002:a1c:4c14:: with SMTP id z20mr2107252wmf.28.1567687563648;
        Thu, 05 Sep 2019 05:46:03 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzgtgVR58GvkPJGffN4yMMmTnq2ROMqNATyP3acVJ3IWAV928JpOT2ZB2k3lytPDOM6Bd3rjA==
X-Received: by 2002:a1c:4c14:: with SMTP id z20mr2107237wmf.28.1567687563438;
        Thu, 05 Sep 2019 05:46:03 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id n1sm2673924wrg.67.2019.09.05.05.46.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2019 05:46:02 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, Janakarajan.Natarajan@amd.com,
        Jim Mattson <jmattson@google.com>
Subject: Re: [Patch] KVM: SVM: Fix svm_xsaves_supported
In-Reply-To: <CAAAPnDFwMWcbnQt7-dWety5UXU3sJSwd8=j5SFqJHK0PEmkFsg@mail.gmail.com>
References: <20190904001422.11809-1-aaronlewis@google.com> <87o900j98f.fsf@vitty.brq.redhat.com> <CAAAPnDFwMWcbnQt7-dWety5UXU3sJSwd8=j5SFqJHK0PEmkFsg@mail.gmail.com>
Date:   Thu, 05 Sep 2019 14:46:01 +0200
Message-ID: <87lfv2kj1y.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Aaron Lewis <aaronlewis@google.com> writes:

> On Wed, Sep 4, 2019 at 9:51 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>>
>> Aaron Lewis <aaronlewis@google.com> writes:
>>
>> > AMD allows guests to execute XSAVES/XRSTORS if supported by the host.  This is different than Intel as they have an additional control bit that determines if XSAVES/XRSTORS can be used by the guest. Intel also has intercept bits that might prevent the guest from intercepting the instruction as well. AMD has none of that, not even an Intercept mechanism.  AMD simply allows XSAVES/XRSTORS to be executed by the guest if also supported by the host.
>> >
>>
>> WARNING: Possible unwrapped commit description (prefer a maximum 75 chars per line)
>>
>> > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
>> > ---
>> >  arch/x86/kvm/svm.c | 2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> >
>> > diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
>> > index 1f220a85514f..b681a89f4f7e 100644
>> > --- a/arch/x86/kvm/svm.c
>> > +++ b/arch/x86/kvm/svm.c
>> > @@ -5985,7 +5985,7 @@ static bool svm_mpx_supported(void)
>> >
>> >  static bool svm_xsaves_supported(void)
>> >  {
>> > -     return false;
>> > +     return boot_cpu_has(X86_FEATURE_XSAVES);
>> >  }
>> >
>> >  static bool svm_umip_emulated(void)
>>
>> I had a similar patch in my stash when I tried to debug Hyper-V 2016
>> not being able to boot on KVM. I may have forgotten some important
>> details, but if I'm not mistaken XSAVES comes paired with MSR_IA32_XSS
>> and some OSes may actually try to write there, in particular I've
>> observed Hyper-V 2016 trying to write '0'. Currently, we only support
>> MSR_IA32_XSS in vmx code, this will need to be extended to SVM.
>>
>> Currently, VMX code only supports writing '0' to MSR_IA32_XSS:
>>
>>         case MSR_IA32_XSS:
>>                 if (!vmx_xsaves_supported() ||
>>                     (!msr_info->host_initiated &&
>>                      !(guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
>>                        guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))))
>>                         return 1;
>>                 /*
>>                  * The only supported bit as of Skylake is bit 8, but
>>                  * it is not supported on KVM.
>>                  */
>>                 if (data != 0)
>>                         return 1;
>>
>>
>> we will probably need the same limitation for SVM, however, I'd vote for
>> creating separate kvm_x86_ops->set_xss() implementations.
>>
>> --
>> Vitaly
>
> Fixed the unwrapped description in v2.
>
> As for extending VMX behavior to SVM for MSR_IA_32_XSS; I will do this
> in a follow up patch.  Thanks for calling this out.

Doing this in a separate patch is fine, however, I think this patch
should come before we start announcing XSAVES support on AMD: both
MSR_IA_32_XSS and XSAVES/XRSTORS instructions are enumerated by
CPUID.(EAX=0DH, ECX=1).EAX[bit 3] so an unprepared guest may try
accessing MSR_IA_32_XSS and get #GP.

-- 
Vitaly
