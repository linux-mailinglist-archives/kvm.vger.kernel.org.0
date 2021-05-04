Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3D00373214
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 23:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232935AbhEDVyq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 17:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbhEDVyq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 17:54:46 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D97E9C061574
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 14:53:50 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id b21so38326plz.0
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 14:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FsMJe2qKChbQLfpmmI2er2bhYru7z7dSUmbB+MQYcyA=;
        b=PGoh0QzzOP4PWKgVUJgFGMnPDB9z/qJcSqqffhmjm4s/x5sxxsSaZAmxrbq5mKPW4L
         JmwSJzcfYvkb2ch2/dsk3/8nY2UDwC9PdQ26CCxFkFv57DMlvSQrrD/UvcxslTN2srD0
         qGLVKOzczAmBiJcYf0KMNxFZQJwILjDiYjEpZ2zk/PkkZD7nFWsJ5xBz46AbGBP/css+
         T0mGQvtT0ZTewdlOK9YMnvEXz6arFOAiJR8e9xEgf6yaiDWKXp0YwZCwt/JTFGZvXzma
         nuYBxQeGtkjs8jusd/8gTRL5dyKI+gSypuoeSuS/sqVNEY0XqPxrlJLSsq6Fp48gEn9r
         eg0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FsMJe2qKChbQLfpmmI2er2bhYru7z7dSUmbB+MQYcyA=;
        b=fOYuvubISPnLS42y6V6vpf26RPp8hQh+Uh7qFGQwJnTiHtF63EzwbtozYpXgr0w7VU
         c/wVL0D8yMkTTjk+NhenGIBTDg+kV25CujHqYZIIAOb3NXXmoDtED2U6CSMEL42ZNNlt
         13s0EnD6KE9pPjZjZxfGNiShVEPMFI6Py1GWhrI8O+KmBzvSkSqmOUfzo9knhnTJIBsY
         2+D71Im7Ppm56WFPJE7AsV/f22EIrTSGxk+RUqcZt6lF2nqOXsphiWBEapcsQDEILhq2
         nuwIL9e9sa5PGlPhkhcc9CXgMkDCY5jjXMPfxLj9+RbkA62A7GTVdbnfXtAFqUEuE3PA
         m4UA==
X-Gm-Message-State: AOAM531aVZog2o99CzaszFtTGta9jJ0cViPpFgSbOIHi58mrfH6s4OZG
        SAHcBsl6biTmFDCkxW8iwL1PZA==
X-Google-Smtp-Source: ABdhPJyIfszxo0bx3Jkguq3ZGyfAq1tH8gsNHrt6Rmn0FlLPMa9UdSaaKIKxu3FAamS9VYMkfrvs8g==
X-Received: by 2002:a17:902:9a84:b029:ec:7fd5:193e with SMTP id w4-20020a1709029a84b02900ec7fd5193emr28456943plp.62.1620165230295;
        Tue, 04 May 2021 14:53:50 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id i126sm12898036pfc.20.2021.05.04.14.53.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 14:53:49 -0700 (PDT)
Date:   Tue, 4 May 2021 21:53:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH 03/15] KVM: SVM: Inject #UD on RDTSCP when it should be
 disabled in the guest
Message-ID: <YJHCadSIQ/cK/RAw@google.com>
References: <20210504171734.1434054-1-seanjc@google.com>
 <20210504171734.1434054-4-seanjc@google.com>
 <CALMp9eSvXRJm-KxCGKOkgPO=4wJPBi5wDFLbCCX91UtvGJ1qBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eSvXRJm-KxCGKOkgPO=4wJPBi5wDFLbCCX91UtvGJ1qBg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 04, 2021, Jim Mattson wrote:
> On Tue, May 4, 2021 at 10:17 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > Intercept RDTSCP to inject #UD if RDTSC is disabled in the guest.
> >
> > Note, SVM does not support intercepting RDPID.  Unlike VMX's
> > ENABLE_RDTSCP control, RDTSCP interception does not apply to RDPID.  This
> > is a benign virtualization hole as the host kernel (incorrectly) sets
> > MSR_TSC_AUX if RDTSCP is supported, and KVM loads the guest's MSR_TSC_AUX
> > into hardware if RDTSCP is supported in the host, i.e. KVM will not leak
> > the host's MSR_TSC_AUX to the guest.
> >
> > But, when the kernel bug is fixed, KVM will start leaking the host's
> > MSR_TSC_AUX if RDPID is supported in hardware, but RDTSCP isn't available
> > for whatever reason.  This leak will be remedied in a future commit.
> >
> > Fixes: 46896c73c1a4 ("KVM: svm: add support for RDTSCP")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> ...
> > @@ -4007,8 +4017,7 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> >         svm->nrips_enabled = kvm_cpu_cap_has(X86_FEATURE_NRIPS) &&
> >                              guest_cpuid_has(vcpu, X86_FEATURE_NRIPS);
> >
> > -       /* Check again if INVPCID interception if required */
> > -       svm_check_invpcid(svm);
> > +       svm_recalc_instruction_intercepts(vcpu, svm);
> 
> Does the right thing happen here if the vCPU is in guest mode when
> userspace decides to toggle the CPUID.80000001H:EDX.RDTSCP bit on or
> off?

I hate our terminology.  By "guest mode", do you mean running the vCPU, or do
you specifically mean running in L2?
