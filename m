Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10B3034960A
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 16:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbhCYPtz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 11:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbhCYPtW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 11:49:22 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FA58C06175F
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 08:49:22 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id m11so2459960pfc.11
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 08:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+lt5248YpMtf4xb83RL4Cd0DB6PM3CB7sU5dXZjCKCg=;
        b=H7MhmTlD65xIev+aJ32j6Bto7F/9TwLWCXxVg0nspUvRLHREsXHuICULh01gli1BuV
         Pa8ULuYRVVIs68flsZwdtqVHvVAHyCKsUGAMvWsI5sm5K/XCE9qQb2JKW1t83ORYZjnt
         6WOVccT0+PoHp5as8mGLacMQar3FDl7RQ5GZ2p3O40OCzY+yhRmTu5jWo0peD4ZN22qK
         fcM0oHqFLDsJQKOHuYLULG2QJzxIDf/4jfJnrIX2xq/ZvpwUMRq8ZUb48x7QN5ysvCdU
         sBoulpcmnapJVCuqsIKC9oiospjjecMUWhgLQtcha9viPRlwP9hUv/72uJu7rHzq0wgd
         9k5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+lt5248YpMtf4xb83RL4Cd0DB6PM3CB7sU5dXZjCKCg=;
        b=J9jilc8PMRC5rlVngS6BAXdYJWoG2jK/p3umBENBDmyt195oE1Zr8wlMwZV6kXTuEr
         BoFZdEUY0ecW53+DQYSr2jeIiYUAOngr+4TBWooTsHLVyanTIG6jS59MpXQmcVsW1Jj1
         C5uDz40cRkEAa7g0tSpxymOZEIe0z1wpbti8jftlGFS3FpjMXvmsei2G6oCH7YyqMscv
         PfbNOjhiBmV/cwi0is2FB/4PLvcsfnHzua5UhvwwI6FVN5/3ptwlDWkv0c7u+rqU6hDe
         D+h7/E8x1M1en+c51uc7NOpMSdbVo9SBv2BeNYuqkbLZt+9vGHWKr5PjmKFu1bMhQwR7
         Jdtw==
X-Gm-Message-State: AOAM531kBPZ9+/2Z0y4tJSUg5ThfDAhu4B9XzJM2dH1lGkfSf/xuYrDf
        82pMKCX49GVbH7gw0VpdmrXS7g==
X-Google-Smtp-Source: ABdhPJy1Q9nAZXnJoWdjU++34Eac5UuDfoe2pmwSVJgVSNuVgXhvD3caBy53fVKVh3CaPMM+I5CUqQ==
X-Received: by 2002:a63:3689:: with SMTP id d131mr5251886pga.261.1616687361920;
        Thu, 25 Mar 2021 08:49:21 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id x19sm6334521pfi.220.2021.03.25.08.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 08:49:21 -0700 (PDT)
Date:   Thu, 25 Mar 2021 15:49:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Haiwei Li <lihaiwei.kernel@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Subject: Re: [PATCH] KVM: VMX: Check the corresponding bits according to the
 intel sdm
Message-ID: <YFyw/VRhRCZlqc1X@google.com>
References: <20210323023726.28343-1-lihaiwei.kernel@gmail.com>
 <CAB5KdOZq+2ETburoMv6Vnnj3MFAuvwnSBsSmiBO=nH1Ajdp5_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB5KdOZq+2ETburoMv6Vnnj3MFAuvwnSBsSmiBO=nH1Ajdp5_g@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 25, 2021, Haiwei Li wrote:
> On Tue, Mar 23, 2021 at 10:37 AM <lihaiwei.kernel@gmail.com> wrote:
> >
> > From: Haiwei Li <lihaiwei@tencent.com>
> >
> > According to IA-32 SDM Vol.3D "A.1 BASIC VMX INFORMATION", two inspections
> > are missing.
> > * Bit 31 is always 0. Earlier versions of this manual specified that the
> > VMCS revision identifier was a 32-bit field in bits 31:0 of this MSR. For
> > all processors produced prior to this change, bit 31 of this MSR was read
> > as 0.
> > * The values of bits 47:45 and bits 63:57 are reserved and are read as 0.
> >
> > Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 32cf828..0d6d13c 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -2577,6 +2577,20 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
> >
> >         rdmsr(MSR_IA32_VMX_BASIC, vmx_msr_low, vmx_msr_high);
> >
> > +       /*
> > +        * IA-32 SDM Vol 3D: Bit 31 is always 0.
> > +        * For all earlier processors, bit 31 of this MSR was read as 0.
> > +        */
> > +       if (vmx_msr_low & (1u<<31))
> > +               return -EIO;
> 
> Drop this code as Jim said.
> 
> > +
> > +       /*
> > +        * IA-32 SDM Vol 3D: bits 47:45 and bits 63:57 are reserved and are read
> > +        * as 0.
> > +        */
> > +       if (vmx_msr_high & 0xfe00e000)
> > +               return -EIO;
> 
> Is this ok? Can we pick up the part? :)

No.  "Reserved and are read as 0" does not guarantee the bits will always be
reserved.  There are very few bits used for feature enumeration in x86 that are
guaranteed to be '0' for all eternity.

The whole point of reserving bits in registers is so that the CPU vendor, Intel
in this case, can introduce new features and enumerate them to software without
colliding with existing features or breaking software.  E.g. if Intel adds a new
feature and uses any of these bits to enumerate the feature, this check would
prevent KVM from loading on CPUs that support the feature.
