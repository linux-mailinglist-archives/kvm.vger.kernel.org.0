Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 745762EC6CA
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 00:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbhAFXUa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 18:20:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726844AbhAFXU3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jan 2021 18:20:29 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2EFC061786
        for <kvm@vger.kernel.org>; Wed,  6 Jan 2021 15:19:49 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id s21so2583689pfu.13
        for <kvm@vger.kernel.org>; Wed, 06 Jan 2021 15:19:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GUGg9IhCtL0gr/8gjUjjB5K3odEWNLhuwGbE7MQTjas=;
        b=R2hswFnBd7zHpuV0YxW61mzA69Spdk86lNxwaZEjXBIQWnMpyQlhyI3OJxtkJWfu/E
         09a3zFW9yelQl0mAICSqnqQ+f+yfq9wPPSqawRweG8AuLomTFSrIHHJddD7RunPWbyMV
         oD12soh2wICcNPwaO6NT9sU83tetm1A7OCMxyloj/fFw2pPOKQgZ/NPLxQXueuWGAlrU
         1zVm1bYqndKDZ/0MzwkNd78HmAG+CTHmx1a246mWMeGfWBGxpQJAbbbg83Yfc/1kEsE0
         Y1Pp5DOIWdAcOMsegl6bW4oiREkIGkFM5WhAZ9a5gZKButUdRw5uTl4nNW8O2MRsyBIf
         U+ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GUGg9IhCtL0gr/8gjUjjB5K3odEWNLhuwGbE7MQTjas=;
        b=uJ2EOulssiYYErjoVhX8s94twfAY6a+E466ZIY6UbyT0Ugl1/cpwWxkacQcRUD3Kr/
         1yXWKGIDH6hOwv7KS7zFx42R2Be8A230fv0mcG7g0xHRhc+ecb/RAKH0mXCJwaM9bO6F
         Np6gankZ7+2HqNO1NIdyoj9KPyKjKcT99T4VlnOJO0ZjTWIvChwQRKHGAGicQSttpPXI
         T0lgV9ofsRMsFEbc662ftVWhNKP0MmSW1UK0hWRRT8GP4Er/wjPvHg1pvtmpVHkGfLWz
         Hy3DO/kuJ8mqoWTUwCtsFAcSoPEFiRA+mLHCXsSppYP7EAJ+BcVtWTlnfpdY3Wg3q65S
         pFNA==
X-Gm-Message-State: AOAM530YcVr2EQauxt2TWgRkNhlSdQUXev0OokA4E5bakHVFz2VRc+/w
        HOkUucM+8yocxSQKNjwB70xD3A==
X-Google-Smtp-Source: ABdhPJx4BPzoGJKxdykGrOsebQ81mSDyKfV8l0uNGLy9XJYTsWDmRnzquJn5/9nGSENZMx9J2tH/bw==
X-Received: by 2002:a63:c908:: with SMTP id o8mr6727123pgg.124.1609975188473;
        Wed, 06 Jan 2021 15:19:48 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id z16sm3914411pgj.51.2021.01.06.15.19.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 15:19:47 -0800 (PST)
Date:   Wed, 6 Jan 2021 15:19:41 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, jarkko@kernel.org,
        luto@kernel.org, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH 04/23] x86/cpufeatures: Add SGX1 and SGX2 sub-features
Message-ID: <X/ZFjUO83lDdQBPL@google.com>
References: <cover.1609890536.git.kai.huang@intel.com>
 <381b25a0dc0ed3e4579d50efb3634329132a2c02.1609890536.git.kai.huang@intel.com>
 <6d28e858-a5c0-6ce8-8c0d-2fdfbea3734b@intel.com>
 <20210107111206.c8207e64540a8361c04259b7@intel.com>
 <b3e11134-cd8e-2b51-1363-58898832ba38@intel.com>
 <20210107115637.c1e0bf2c823f933943ee813b@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107115637.c1e0bf2c823f933943ee813b@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 07, 2021, Kai Huang wrote:
> On Wed, 6 Jan 2021 14:21:39 -0800 Dave Hansen wrote:
> > On 1/6/21 2:12 PM, Kai Huang wrote:
> > > On Wed, 6 Jan 2021 11:39:46 -0800 Dave Hansen wrote:
> > >> On 1/5/21 5:55 PM, Kai Huang wrote:
> > >>> --- a/arch/x86/kernel/cpu/feat_ctl.c
> > >>> +++ b/arch/x86/kernel/cpu/feat_ctl.c
> > >>> @@ -97,6 +97,8 @@ static void clear_sgx_caps(void)
> > >>>  {
> > >>>  	setup_clear_cpu_cap(X86_FEATURE_SGX);
> > >>>  	setup_clear_cpu_cap(X86_FEATURE_SGX_LC);
> > >>> +	setup_clear_cpu_cap(X86_FEATURE_SGX1);
> > >>> +	setup_clear_cpu_cap(X86_FEATURE_SGX2);
> > >>>  }
> > >> Logically, I think you want this *after* the "Allow SGX virtualization
> > >> without Launch Control support" patch.  As it stands, this will totally
> > >> disable SGX (including virtualization) if launch control is unavailable.
> > >>
> > > To me it is better to be here, since clear_sgx_caps(), which disables SGX
> > > totally, should logically clear all SGX feature bits, no matter later patch's
> > > behavior. So when new SGX bits are introduced, clear_sgx_caps() should clear
> > > them too. Otherwise the logic of this patch (adding new SGX feature bits) is
> > > not complete IMHO.
> > > 
> > > And actually in later patch "Allow SGX virtualization without Launch Control
> > > support", a new clear_sgx_lc() is added, and is called when LC is not
> > > available but SGX virtualization is enabled, to make sure only SGX_LC bit is
> > > cleared in this case. I don't quite understand why we need to clear SGX1 and
> > > SGX2 in clear_sgx_caps() after the later patch.
> > 
> > I was talking about patch ordering.  It could be argued that this goes
> > after the content of patch 05/23.  Please _consider_ changing the ordering.
> > 
> > If that doesn't work for some reason, please at least call out in the
> > changelog that it leaves a temporarily funky situation.
> > 
> 
> The later patch currently uses SGX1 bit, which is the reason that this patch
> needs be before later patch.
> 
> Sean,
> 
> I think it is OK to remove SGX1 bit check in later patch, since I have
> never seen a machine with SGX bit in CPUID, but w/o SGX1.

The SGX1 check is "needed" to handle the case where SGX is supported but was
soft-disabled, e.g. because software disable a machine check bank by writing an
MCi_CTL MSR.

> If we remove SGX1 bit check in later, we can put this patch after the later
> patch.
> 
> Do you have comment here? If you are OK, I'll remove SGX1 bit check in later
> patch and reorder the patch.

Hmm, I'm not sure why the SGX driver was merged without explicitly checking for
SGX1 support.  I'm pretty sure we had an explicit SGX1 check in the driver path
at some point.  My guess is that the SGX1 change ended up in the KVM series
through a mishandled rebase.

Moving the check later won't break anything that's not already broken.  But,
arguably checking SGX1 is a bug fix of sorts, e.g. to guard against broken
firmware, and should go in as a standalone patch destined for stable.  The
kernel can't prevent SGX from being soft-disabled after boot, but IMO it should
cleanly handle the case where SGX was soft-disabled _before_ boot.
