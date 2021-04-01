Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99BDA351974
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235786AbhDARxm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 13:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237114AbhDARu3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 13:50:29 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39BA3C02FEB0
        for <kvm@vger.kernel.org>; Thu,  1 Apr 2021 09:23:04 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id g10so1266272plt.8
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 09:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tD+X9BuSKumVuODrS7ew+s56RfGVj55Vw8zUed5E1dQ=;
        b=b0yftv4xYST/PHsMhQ7VQUcEa/nNBbEpF+RJLTdGj1yGdsIIOhVvznJPXhAKOgcgrx
         HAGvwGO2hi88fQRtPCWLs1BpGDqSQ0qcLXjLzO8MlBG4jHriu3rrZlvA42wE8LNuX/Fr
         4xdWlPmu2lcnYh2YC1ciLz4MPciden90dX/kioMhjaC/j8B/Dk7gjgOAzVq6bFsrKOvA
         Rw45Ihhg7JDLF03Vng8Sk5QgEspPdJUA5DyyG67THT7pHBSQ46icHHGjcqhSzxPetv6O
         3aXmunw+MHJIZS4VOWhQtBE9wh/bHozCc3KsuxBOZuV+qaR12u7c0dntFbqU1PF18eKr
         WgpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tD+X9BuSKumVuODrS7ew+s56RfGVj55Vw8zUed5E1dQ=;
        b=nl/JOQYrPCvNNW/DZQEZVFtOAIexfsqEevYWUvCXprsOoDBCxuaSGRO/u0s0WabZMG
         MdG6T5eZO1Aodx4PEdUb3YlfEDCHkI0K4M3k4NJO2AA87o1YyIHzMNSrN0wOrzrH6coP
         /RtWcVabbYR60Jqk84/3DM2SrIL5QoXuNJH6jc9uaCkWw6AdbfjMSGpJBB7nwt2rPoIv
         DvpHbDeqQunz2ZfwHPeVdVa6+i/9GwORh0+Iqg2pgMZFVBTR4NLXOFMZDmm2hJNXkQFF
         BxV2EtKOA/R1dm9/m3iDhhe/uM2TLkdS+CSPiDcMPtMJ3TCNt57SK5yWRcs9EO8Yx3dh
         zA3w==
X-Gm-Message-State: AOAM5325h6CEWeEH809pl90OCg4aGw9WWK4rjMkheNlNdT0r86OSi0Wh
        G5z9rFmqDqvf38C/X4y515aVig==
X-Google-Smtp-Source: ABdhPJxA+80V8X8+S9LBr6ks6kcnWa3Io5Z5gpYddSyqtvTMFfjHXGTv/ayoHfoc+ROuWFYuNUqIUg==
X-Received: by 2002:a17:90a:4005:: with SMTP id u5mr9648330pjc.6.1617294183436;
        Thu, 01 Apr 2021 09:23:03 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id x3sm5781480pfn.181.2021.04.01.09.23.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 09:23:02 -0700 (PDT)
Date:   Thu, 1 Apr 2021 16:22:59 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Yang Li <yang.lee@linux.alibaba.com>, pbonzini@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Fix potential memory access error
Message-ID: <YGXzY5h1eCQj6aU0@google.com>
References: <1617182122-112315-1-git-send-email-yang.lee@linux.alibaba.com>
 <YGS6XS87HYJdVPFQ@google.com>
 <87mtuis77m.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mtuis77m.fsf@vitty.brq.redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 01, 2021, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Wed, Mar 31, 2021, Yang Li wrote:
> >> Using __set_bit() to set a bit in an integer is not a good idea, since
> >> the function expects an unsigned long as argument, which can be 64bit wide.
> >> Coverity reports this problem as
> >> 
> >> High:Out-of-bounds access(INCOMPATIBLE_CAST)
> >> CWE119: Out-of-bounds access to a scalar
> >> Pointer "&vcpu->arch.regs_avail" points to an object whose effective
> >> type is "unsigned int" (32 bits, unsigned) but is dereferenced as a
> >> wider "unsigned long" (64 bits, unsigned). This may lead to memory
> >> corruption.
> >> 
> >> /home/heyuan.shy/git-repo/linux/arch/x86/kvm/kvm_cache_regs.h:
> >> kvm_register_is_available
> >> 
> >> Just use BIT instead.
> >
> > Meh, we're hosed either way.  Using BIT() will either result in undefined
> > behavior due to SHL shifting beyond the size of a u64, or setting random bits
> > if the truncated shift ends up being less than 63.
> >
> 
> A stupid question: why can't we just make 'regs_avail'/'regs_dirty'
> 'unsigned long' and drop a bunch of '(unsigned long *)' casts? 

It wouldn't break anything, but it would create a weird situation where x86-64
has more bits for tracking registers than i386.  Obviously not the end of the
world, but it's also not clearly an improvement across the board.

We could do something like:

  	DECLARE_BITMAP(regs_avail, NR_VCPU_TRACKED_REGS);
	DECLARE_BITMAP(regs_dirty, NR_VCPU_TRACKED_REGS);

but that would complicate the vendor code, e.g. vmx_register_cache_reset().

The casting crud is quite contained, and likely isn't going to expand anytime
soon.  So, at least for me, this is one of the few cases where I'm content to
let sleeping dogs lie. :-)
