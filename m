Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48B323C7845
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 22:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235139AbhGMU7J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 16:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234290AbhGMU7I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 16:59:08 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A07F0C0613E9
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 13:56:17 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id j3so63966plx.7
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 13:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LMLZw+7kP17xj8iob4CnXRS8mLPc06HVwcScbSpgmog=;
        b=DbhUnemaxXAYoclSgYPqjmzCgDcfvbTt0Fp2D3iAma0zwBxS/PVN+wOVRPnC4yPEXP
         56fAdE8DeC5XAmFGZI1M6jOscQOIWAOLas285nt9xvjZiSVQsc5VDJtd9ZQHTOk5EVvx
         9Z6DqQtUPkBOCvJd+rRYaB0zDlhvhs8VX82lgwiPf6AYDwItMgV6UFfcd9tmSMQuI85f
         92mxF8FyStxwL5H2rKfLi7cakA6gtrS9QZU11Ty6YAj4rXYy1YX0fzHhNSN8xukw81EC
         sZ1dBuH25Jl8vnQek1/rexfaZYFIKrcC34oedX3HJOdABtebYdwYWXEIfeMuMY0SdkA8
         v6ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LMLZw+7kP17xj8iob4CnXRS8mLPc06HVwcScbSpgmog=;
        b=plhiNG5Q8jYHDhybxU/nMaVhJnI3uzbusCVgkPdcbUHQUEVjt4xHcoWaT1dRSUSTn4
         NX/I+tqv5XGbdP69tjr/Awn+SCDyJo1y5gCgc/LG51ux6EBKtasF4e7Adb7CNpm3lrZP
         z92NALMkYSVu2iYG2v5f/ZowOlcBnI3wFGDZ6Ja2gOW6tvwWhfXmM4dinpJ7zVZEOq9s
         9m2zKJ/Jddwp2xJRT9LrF5hxOgC8s1hz7Z/Zl1Zndm5NHyadUvvs7S0UQFjUMcGM4X2k
         IuIcp3AzOQglu0Ka1+VkiiUICukXRr/YHr8GFDLhLGiDIRu1cZ7vHyUC8gqs09k+bA91
         NeqQ==
X-Gm-Message-State: AOAM530mKuBpi6W0il9sbMAEwFsAYYixT4SczmikHoHXrUKfl2AHdWfV
        ow+Hk2l8DOKIUyrK9q0ihPbqBA==
X-Google-Smtp-Source: ABdhPJwppbUt2eHS1spdEOKVMbf1fSzhtbIwYnWe8xIFSfLd75nFK+mE2w4E+UrVxpXtbpNpKe9XHg==
X-Received: by 2002:a17:90a:510b:: with SMTP id t11mr135413pjh.178.1626209776872;
        Tue, 13 Jul 2021 13:56:16 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j21sm57759pjz.26.2021.07.13.13.56.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jul 2021 13:56:16 -0700 (PDT)
Date:   Tue, 13 Jul 2021 20:56:12 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [RFC PATCH v2 60/69] KVM: VMX: Add macro framework to read/write
 VMCS for VMs and TDs
Message-ID: <YO397L2OQXFBZN5q@google.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <5735bf9268130a70b49bc32ff4b68ffc53ee788c.1625186503.git.isaku.yamahata@intel.com>
 <71ee8575-bd72-f51e-38c5-4e8411b8aedd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71ee8575-bd72-f51e-38c5-4e8411b8aedd@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 06, 2021, Paolo Bonzini wrote:
> On 03/07/21 00:05, isaku.yamahata@intel.com wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > Add a macro framework to hide VMX vs. TDX details of VMREAD and VMWRITE
> > so the VMX and TDX can shared common flows, e.g. accessing DTs.
> > 
> > Note, the TDX paths are dead code at this time.  There is no great way
> > to deal with the chicken-and-egg scenario of having things in place for
> > TDX without first having TDX.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >   arch/x86/kvm/vmx/common.h | 41 +++++++++++++++++++++++++++++++++++++++
> >   1 file changed, 41 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
> > index 9e5865b05d47..aa6a569b87d1 100644
> > --- a/arch/x86/kvm/vmx/common.h
> > +++ b/arch/x86/kvm/vmx/common.h
> > @@ -11,6 +11,47 @@
> >   #include "vmcs.h"
> >   #include "vmx.h"
> >   #include "x86.h"
> > +#include "tdx.h"
> > +
> > +#ifdef CONFIG_KVM_INTEL_TDX
> 
> Is this #ifdef needed at all if tdx.h properly stubs is_td_vcpu (to return
> false) and possibly declares a dummy version of td_vmcs_read/td_vmcs_write?

IIRC, it requires dummy versions of is_debug_td() and all the ##bits variants of
td_vmcs_read/write().  I'm not sure if I ever actually tried that, e.g. to see
if the compiler completely elided the TDX crud when CONFIG_KVM_INTEL_TDX=n.
