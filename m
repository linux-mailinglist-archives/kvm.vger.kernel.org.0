Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC072F1F1F
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 20:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403893AbhAKTVS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 14:21:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403886AbhAKTVR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 14:21:17 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48CC0C06138F
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 11:20:19 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id a188so513119pfa.11
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 11:20:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=T6LEBgdwODFxDkFGdfQwYYukyFVNGGHUBERAEjM8G9o=;
        b=qKxEwtsJmk1JwvCzvExpmKznnbtwcP6URIhC50e2AQEjvcFjlV8XZYp/wK/OjVNQ8s
         H9cLYE+09nxTtmHoyr8NO7MnUM3PInUa33gfKu/ll2H0o/ptdRN2YSteiutTiamA/ETN
         IcGYgDfhXkMqJWoZ9P5ZpUUhWVSM8egD+ySTVngv1Nyqef9NzKA78Cqgz3216pMF7ix8
         7nWFoL8cqv01BEt689pZ78bFTUPi1jdm0ftzEELOZ/9YoA7kTB8eqCqQZjeVMWKyXOg4
         UWizNOWNtNiKuQ1NQLiwsGkHZuouCL2+rpkjXxr7XiUWINlY0QG3o16q1uRLMR02jvuK
         VQAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=T6LEBgdwODFxDkFGdfQwYYukyFVNGGHUBERAEjM8G9o=;
        b=CJAnAHSOcjFv6rNuzoAwMTIqv5TcXJVAYb7t1wBOSRS3gABs6VY43bi89mtbYScqwe
         /nLUUwBvaGsHR/FWnbax8jSp4ULrH4sQTUQjZycI/EuEEHi2LgmLN/Ol21aHQZmqQRk0
         egcVm35vqxdQnAXEPVaJkCH4hX3HNrUoKPr2X9gC59V1CTI8yvftclVwxEiAdSXEQvoU
         9yGrhYDDDs3QoQJyM8LjvQ3XMHl3Pc1dSzNv299SqmYjkpLA3k6HeXjZMqWEEIRqJ4zN
         6BaBFL5cJ54zu4mQn0JOAe+7yZdj81ox3ilgA8O9ua9o2sn6tpKtxgKxaRuASGQQlP/U
         Z0xw==
X-Gm-Message-State: AOAM532FrPEC2/Vxu7cpZSf0wQA3z9iU01xVNUSU05ECL/4ADBOgsBm+
        9qSn4GLEsCIo3BxDh98/J08PbQ==
X-Google-Smtp-Source: ABdhPJwY447dx55svXwKP7oEkJV44RRtkCm3pwpUKpl+wg7X7GjC5q83Ki2XsRb+A+muL1YWiAMUPw==
X-Received: by 2002:a62:e314:0:b029:19e:4cc:dc6f with SMTP id g20-20020a62e3140000b029019e04ccdc6fmr813898pfh.33.1610392818594;
        Mon, 11 Jan 2021 11:20:18 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id g30sm356091pfr.152.2021.01.11.11.20.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 11:20:17 -0800 (PST)
Date:   Mon, 11 Jan 2021 11:20:11 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Kai Huang <kai.huang@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, jarkko@kernel.org,
        luto@kernel.org, haitao.huang@intel.com, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH 04/23] x86/cpufeatures: Add SGX1 and SGX2 sub-features
Message-ID: <X/yk6zcJTLXJwIrJ@google.com>
References: <20210107120946.ef5bae4961d0be91eff56d6b@intel.com>
 <20210107064125.GB14697@zn.tnic>
 <20210108150018.7a8c2e2fb442c9c68b0aa624@intel.com>
 <a0f75623-b0ce-bf19-4678-0f3e94a3a828@intel.com>
 <20210108200350.7ba93b8cd19978fe27da74af@intel.com>
 <20210108071722.GA4042@zn.tnic>
 <X/jxCOLG+HUO4QlZ@google.com>
 <20210109011939.GL4042@zn.tnic>
 <X/yQyUx4+veuSO0e@google.com>
 <20210111190901.GG25645@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111190901.GG25645@zn.tnic>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 11, 2021, Borislav Petkov wrote:
> On Mon, Jan 11, 2021 at 09:54:17AM -0800, Sean Christopherson wrote:
> > It would be possible for KVM to break the dependency on X86_FEATURE_* bit
> > offsets by defining a translation layer, but I strongly feel that adding manual
> > translations will do more harm than good as it increases the odds of us botching
> > a translation or using the wrong feature flag, creates potential namespace
> > conflicts, etc...
> 
> Ok, lemme see if we might encounter more issues down the road...
> 
> +enum kvm_only_cpuid_leafs {
> +       CPUID_12_EAX     = NCAPINTS,
> +       NR_KVM_CPU_CAPS,
> +
> +       NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
> +};
> +
> 
> What happens when we decide to allocate a separate leaf for CPUID_12_EAX
> down the road?

Well, mechanically, that would generate a build failure if the kernel does the
obvious things and names the 'enum cpuid_leafs' entry CPUID_12_EAX.  That would
be an obvious clue that KVM should be updated.

If the kernel named the enum entry something different, and we botched the code
review, KVM would continue to work, but would unnecessarily copy the bits it
cares about to its own word.   E.g. the boot_cpu_has() checks and translation to
__X86_FEATURE_* would still be valid.  As far as failure modes go, that's not
terrible.

> You do it already here
> 
> Subject: [PATCH 04/13] x86/cpufeatures: Assign dedicated feature word for AMD mem encryption
> 
> for the AMD leaf.
> 
> I'm thinking this way around - from scattered to a hw one - should be ok
> because that should work easily. The other way around, taking a hw leaf
> and scattering it around x86_capability[] array elems would probably be
> nasty but with your change that should work too.
> 
> Yah, I'm just hypothesizing here - I don't think this "other way around"
> will ever happen...
> 
> Hmm, yap, I can cautiously say that with your change we should be ok...
> 
> Thx.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
