Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD2768875F
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 20:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233132AbjBBTMD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 14:12:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232605AbjBBTMC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 14:12:02 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FAAF69B21
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 11:12:00 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id ha3-20020a17090af3c300b00230222051a6so2770604pjb.2
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 11:12:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=K7OHh0J0Ql5aSy3qyWjVTPkkQu7eVgUi1CxOXIrtf7k=;
        b=GkTDlC74VN0LYx7i34Xq23OMwfRBaJK4X8ce7obW5kvsJ2xcXG4/t3iDcGXDxZQOdY
         dFs6xRtZIsBhTJkpi6sFtWiSsg33hfd8rjkmZvR8NbgGuiWa4r7GN9ouckV7/YXaKFK8
         HpAy4Ta1RRjLF2i/tIe/DaMYbFlfJZcedLPNUKDOEYZqiSgBE5I2Olx5IiVn5VI8BxDN
         fyilcgYTrAOudhpM4VernjxFkUUpFx1tz3vJkf02WQaLbMJNvmZqITaGCgYBFd4gJGki
         PfyYiXPRzKh0DfC0+Vcexl4ccmD/qpOkjYzRYOvH/8f39/UCd0XpqUbAniPW3ZrVregs
         N8VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K7OHh0J0Ql5aSy3qyWjVTPkkQu7eVgUi1CxOXIrtf7k=;
        b=d1fprMnYiw/hAbS6jipIeufLiOLUtoH7lKTIHERseU6eK46XMbYwqdEWlbChFVfDmc
         6GgB8luhbnWS+0dDl03a4zqbIUv7J2XarZa+SaQmVTgnHqE3/TnrP/NTIk/ahms3Gfgl
         9DXckjsZ+x9AwAuBlNLtYGnGdI74OtR9M59kPPAv3eWMrnAlDXgr5bNUYj4LBZMkTFUH
         q7tu+FWX4ZQtZaBaxvM1LSpRHycMJ1jj/TM/HLZ/Co/IA/3SPScmFZNqUpToRxqwckfk
         b2F5o6HVJ/ZtMqCr4KiNXrw74WfpPYIgtTgrQM298b5hfMPQmG2vhImu9J8N8BXORCx5
         YA3A==
X-Gm-Message-State: AO0yUKXdZeSXJwi5SpYQXpzrftwZNV/z9AX+hQkzCB0NeeXRgBn+Ibz4
        Fy4N2cWXnn4nFn9R732sir+AsA==
X-Google-Smtp-Source: AK7set/eUA6CqqdqvgAdf3irvd3yLDq36g0kqfoojL5H7Im2SgQ1uTFFpnQZLV7icKRe5ALSrIYqNA==
X-Received: by 2002:a17:902:7406:b0:198:af4f:de07 with SMTP id g6-20020a170902740600b00198af4fde07mr74828pll.7.1675365120010;
        Thu, 02 Feb 2023 11:12:00 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id l19-20020a637013000000b004d2f5bb9339sm149004pgc.15.2023.02.02.11.11.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 11:11:59 -0800 (PST)
Date:   Thu, 2 Feb 2023 19:11:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Weijiang <weijiang.yang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: x86/pmu: Disallow legacy LBRs if architectural LBRs
 are available
Message-ID: <Y9wK/LkBYusOv1DO@google.com>
References: <20230128001427.2548858-1-seanjc@google.com>
 <f106a06e-ae6f-2c79-df87-721817aacc02@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f106a06e-ae6f-2c79-df87-721817aacc02@gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 31, 2023, Like Xu wrote:
> On 28/1/2023 8:14 am, Sean Christopherson wrote:
> > Disallow enabling LBR support if the CPU supports architectural LBRs.
> > Traditional LBR support is absent on CPU models that have architectural
> > LBRs, and KVM doesn't yet support arch LBRs, i.e. KVM will pass through
> > non-existent MSRs if userspace enables LBRs for the guest.
> 
> True, we have call_trace due to MSR_ARCH_LBR_FROM_0 (0x1500) for example.
> 
> > 
> > Cc: stable@vger.kernel.org
> > Cc: Yang Weijiang <weijiang.yang@intel.com>
> > Cc: Like Xu <like.xu.linux@gmail.com>
> 
> Tested-by: Like Xu <likexu@tencent.com>
> 
> > Reported-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> Fixes: 145dfad998ea ("KVM: VMX: Advertise PMU LBRs if and only if perf
> supports LBRs")

If we want a fixes, I'd argue this is more appropriate:

  Fixes: be635e34c284 ("KVM: vmx/pmu: Expose LBR_FMT in the MSR_IA32_PERF_CAPABILITIES")

Though I'd prefer not to blame KVM, there's not much we could have done in KVM
to know that Intel would effectively break backwards compatibility.

> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> > 
> > Am I missing something that would prevent this scenario?
> > 
> >   arch/x86/kvm/vmx/vmx.c | 8 +++++---
> >   1 file changed, 5 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 8f0f67c75f35..77ee6b4a5ec4 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -7761,9 +7761,11 @@ static u64 vmx_get_perf_capabilities(void)
> >   	if (boot_cpu_has(X86_FEATURE_PDCM))
> >   		rdmsrl(MSR_IA32_PERF_CAPABILITIES, host_perf_cap);
> > -	x86_perf_get_lbr(&lbr);
> > -	if (lbr.nr)
> > -		perf_cap |= host_perf_cap & PMU_CAP_LBR_FMT;
> > +	if (!cpu_feature_enabled(X86_FEATURE_ARCH_LBR)) {
> 
> To avoid changing this again in the Arch lbr enabling part, how about:
> 
> 	x86_perf_get_lbr(&lbr);
> 	if (lbr.nr && cpu_feature_enabled(X86_FEATURE_ARCH_LBR) ==
> 	    kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
> 		perf_cap |= host_perf_cap & PMU_CAP_LBR_FMT;
> 
> ?

I'd rather force arch LBR enabling to explicitly update this code.  And I'd prefer
that KVM explicitly clear PMU_CAP_LBR_FMT when KVM can't use arch LBRs for whatever
reason, both for documentation purposes and to avoid ordering dependencies between
consuming vmx_get_perf_capabilities() and updating kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR).
