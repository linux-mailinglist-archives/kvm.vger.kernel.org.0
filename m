Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A47347868
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 13:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232697AbhCXMYO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 08:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231566AbhCXMYI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 08:24:08 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F014C061763;
        Wed, 24 Mar 2021 05:24:08 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id m7so17313774qtq.11;
        Wed, 24 Mar 2021 05:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IyefHO45u1U79eOxkhQZcovymc+b6GZnAZonAFNEudY=;
        b=AzcC0/z9nhIrk7tsnxoiGx6Hxh4wxkyl2LZXY5sa6IuPIwog/g1PdI1vnvtyNk2SnV
         BHccAXRGdxDs1W4vxoWeyifTRi1eJdgUR4PfpCKwpjNi5vXOO1dnQL34fOi9ZVnKYRak
         HGOthOxMBa3sXkN1OrI2FN8ZA5ifdTzj+qXJfOWIQbd/W6bQdvzDxLuNxEPu2tQoV/Uz
         I1WzxpXe0B3sF7wUhtiCoQ8UBX2xyLOiVPfH902YJP7rBTFtpFaruvrgzxiohFaP3ZgD
         fgemh8hkgiXLCsPMrZ6LJr+/HT08PsVXHuNDcDErfEtmAFuV58QKlpgb6+BDNyXNLLo5
         UbGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IyefHO45u1U79eOxkhQZcovymc+b6GZnAZonAFNEudY=;
        b=ZyYrbJ/WcyJIX7XYshSIOjDLoCYxXMs+t6w3WfWJmSD8j4J7s0xMz2LPX5r5McY0Zn
         oh24/2jl6HbMIBayGpw6/ih8jgD0lVMxhR5+sv0gvvuG6YfAxVAM7/2fU4PIZxBHOmpG
         4LgrqEZGHeP/sLR/GWe3fxzH4oWnPvwFD4qMEvLEU8MSeSvyXUzOEhCf+aV6h2ZnGv+Z
         jYcfmvhZX2ICDtH0hZmvQDntq6pfNwKK55Pr7K+AavX3Mm6h5EL3LXzzqsK4eWy+ySU2
         BvJf+S6CZ6GPi540kr8yYFi0Y5d/E2SJrmOkPtN08UwUfu7btYsB28yqiPu1TAUOsrzD
         SlZQ==
X-Gm-Message-State: AOAM531F5SWygw+GaCWxSwKAF9BYRPfzzHuCndknErgYzPGvKGfvUbrp
        BhXKy4Sw/Dkk6NbTAJtkVj0DYse7jAcjrt2CIziPFitjpw==
X-Google-Smtp-Source: ABdhPJxxqv4PH7lOqzrXhUUrR/+RU3+KtNx7idK4wtFJIGRdxxQMRcQ3sHfZAOIRYkmdWtfykAd33CuVcTuirXpo/LQ=
X-Received: by 2002:ac8:4ccc:: with SMTP id l12mr2595220qtv.137.1616588647824;
 Wed, 24 Mar 2021 05:24:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210323084515.1346540-1-vkuznets@redhat.com>
In-Reply-To: <20210323084515.1346540-1-vkuznets@redhat.com>
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
Date:   Wed, 24 Mar 2021 20:23:30 +0800
Message-ID: <CAB5KdOZb1pfKC8GkFSWQxBxz_KLvmSxqbnLL7qRjgfV19jiNvA@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/vPMU: Forbid writing to MSR_F15H_PERF MSRs when
 guest doesn't have X86_FEATURE_PERFCTR_CORE
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Wei Huang <wei.huang2@amd.com>, Joerg Roedel <joro@8bytes.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 23, 2021 at 4:48 PM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> MSR_F15H_PERF_CTL0-5, MSR_F15H_PERF_CTR0-5 MSRs are only available when
> X86_FEATURE_PERFCTR_CORE CPUID bit was exposed to the guest. KVM, however,
> allows these MSRs unconditionally because kvm_pmu_is_valid_msr() ->
> amd_msr_idx_to_pmc() check always passes and because kvm_pmu_set_msr() ->
> amd_pmu_set_msr() doesn't fail.

I have tested on AMD EPYC platform with perfctr_core(`cat
/proc/cpuinfo | grep perfctr_core`).
I started a vm without `perfctr-core`(-cpu host,-perfctr-core).

Before patch :

$ rdmsr 0xc0010200
0
$ wrmsr 0xc0010200 1
$ rdmsr 0xc0010200
1

After patch:

# rdmsr 0xc0010200
0
# wrmsr 0xc0010200 1
wrmsr: CPU 0 cannot set MSR 0xc0010200 to 0x0000000000000001
# rdmsr 0xc0010200
0

So,

Tested-by: Haiwei Li <lihaiwei@tencent.com>
