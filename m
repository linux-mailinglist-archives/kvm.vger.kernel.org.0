Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91D052F402F
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 01:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733132AbhALXSE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 18:18:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728427AbhALXSD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 18:18:03 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42437C061575
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 15:17:23 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id w1so2166994pjc.0
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 15:17:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Yi311W2mEPcoUeeXQ6K1FVZjGfDJ1DzLXppBk3GV5Ss=;
        b=RuG09I9iqag6FBvfI3cDukXJCSjkxHc4/RpZXp3kCvFZdEE3wMzml3SKx4vNREH1Hv
         VPFbCoOG8Sn7WTeX6ncDzSqu/Lb6ZWuA33CROIA51tQOKh10JfJy/Y6W3UXPY763wEKk
         sgd28dr4GIDeTdBWhEK8c2e2WSmtzJxnJP2hlEt7LFNmcd9XlMBNZd50c2rfEPSxupV2
         YLHwtjXcIhMLnC8G/QU3KyAxQJzbOlH6Og0p8sM5XBJacz4BA2g4GANxuM1MYHm34x0F
         WtgFAMiFHlCK2A0wYooEmJvIH3fcSHg8X4OXX+UzYlVWMI+4+0aHyY3DpfDH7Gy2OKy1
         acjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Yi311W2mEPcoUeeXQ6K1FVZjGfDJ1DzLXppBk3GV5Ss=;
        b=HzQz1rXeaux5nL/sFiR8daqe7QQrC77366aR8o59IBoHpFlHlIB2OHceHwYdiu36hs
         O+pc4cfTuEWkoJC+iQJKXFP0kPzjWtHIAGRDFaiyYogMzIddqeJlVW1fF6XPDwDU3C7C
         a62Br76sZzoTnWfZnGmevT8kDVlR/gL81J0ACUi8uIg3e4q3aVc+I/IWgiFzSsHku2yb
         Qy2ykKUbzoeL272U+Bu+eNoMeHfn1qOm5y57y6671TQYJtCe6+9+nzIcH6H0M2PbOEzS
         kjgnDl5AhzKzm2jt24+oCM/Sh1ZRIAY7Aak+RGaPBIH2FTOvE/lz02tNyqieKpwDI4aK
         AsEw==
X-Gm-Message-State: AOAM531Ke6BpEL4y7/PGOmNUOXq9UboD1FT2HX8qvGc6blwpdKWLpKbW
        dCL9veg8/I/feyn+eyZqWxA7vw==
X-Google-Smtp-Source: ABdhPJwap99ShubOOWt2zGEZ0I85k5Xp/UWL4WuRCBPZj/Skqhv8Wf85O//1dP4RTFWZFU2e82bSqw==
X-Received: by 2002:a17:902:9896:b029:dc:3306:8aa7 with SMTP id s22-20020a1709029896b02900dc33068aa7mr1478741plp.6.1610493442542;
        Tue, 12 Jan 2021 15:17:22 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id f9sm190920pfa.41.2021.01.12.15.17.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 15:17:21 -0800 (PST)
Date:   Tue, 12 Jan 2021 15:17:15 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, jarkko@kernel.org,
        luto@kernel.org, haitao.huang@intel.com, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH 04/23] x86/cpufeatures: Add SGX1 and SGX2 sub-features
Message-ID: <X/4t+6JcyTGVEG2e@google.com>
References: <20210108071722.GA4042@zn.tnic>
 <X/jxCOLG+HUO4QlZ@google.com>
 <20210109011939.GL4042@zn.tnic>
 <X/yQyUx4+veuSO0e@google.com>
 <20210111190901.GG25645@zn.tnic>
 <X/yk6zcJTLXJwIrJ@google.com>
 <20210112121359.GC13086@zn.tnic>
 <X/3ZSKDWoPcCsV/w@google.com>
 <20210112175102.GJ13086@zn.tnic>
 <dea875ea60cdef68fa8fe5b8f8cf3e8ed6a5df2e.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dea875ea60cdef68fa8fe5b8f8cf3e8ed6a5df2e.camel@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 13, 2021, Kai Huang wrote:
> On Tue, 2021-01-12 at 18:51 +0100, Borislav Petkov wrote:
> > On Tue, Jan 12, 2021 at 09:15:52AM -0800, Sean Christopherson wrote:
> > > We want the boot_cpu_data.x86_capability memcpy() so that KVM doesn't advertise
> > > support for features that are intentionally disabled in the kernel, e.g. via
> > > kernel params.  Except for a few special cases, e.g. LA57, KVM doesn't enable
> > > features in the guest if they're disabled in the host, even if the features are
> > > supported in hardware.
> > > 
> > > For some features, e.g. SMEP and SMAP, honoring boot_cpu_data is mostly about
> > > respecting the kernel's wishes, i.e. barring hardware bugs, enabling such
> > > features in the guest won't break anything.  But for other features, e.g. XSAVE
> > > based features, enabling them in the guest without proper support in the host
> > > will corrupt guest and/or host state.
> > 
> > Ah ok, that is an important point.
> > 
> > > So it's really the CPUID read that is (mostly) superfluous.
> > 
> > Yeah, but that is cheap, as we established.
> > 
> > Ok then, I don't see anything that might be a problem and I guess we can
> > try that handling of scattered bits in kvm and see how far we'll get.
> 
> Hi Sean, Boris,
> 
> Thanks for all  your feedback.
> 
> Sean,
> 
> Do you want to send me your patch (so that with your SoB), or do you want me to copy
> & paste the code you posted in this series, plus Suggested-by you? Or how do you want
> to proceed?
> 
> Also to me it is better to separate X86_FEATURE_SGX1/2 with rest of KVM changes?

Hmm, I'll split the changes into two proper patches and send them to you off list.

> And do you think adding a dedicated, i.e. kvm_scattered_cpu_caps[], instead of using
> existing kvm_cpu_cap[NCAPINTS] would be helpful to solve the problem caused by adding
> new leaf to x86 core (see my another reply in this thread)?

Probably not, because then we'd have to add new helpers to deal with the new
array, or change all the helpers to take the array as a pointer.  Blasting past
NCAPINTS is a little evil, but it does slot in nicely to the existing code.
