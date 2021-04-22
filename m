Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A8B36844C
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 17:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236696AbhDVP7Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 11:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236693AbhDVP7V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 11:59:21 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C536BC06138C
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 08:58:46 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id c3so13216747pfo.3
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 08:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=44uFSIKvqnC7V+9ZchehMmm34h8scMBiFWmZbyka+5I=;
        b=cMiEjZ1B9JMl8QATUXKRwJxkhvh5LCCEJA1EPShkG5o7xzgME4hzquSiFFSCVuKw2B
         JwqtwHPEYESxOMlFUI13tzjNMcegmUV0xlrg7yIb5Lufn8Xs7oHPzAVXKxjmZ5dCaIaE
         WxOPyIfhTTJOjVnJBqbDuuJgKDln1FmrMMl47T1/auyzw7U/kpQP59IyvNwBc9yG9R7t
         +pHBoVsBV4aBkuFKMOXvL0zjFOIiAWYMizug6eGhWegiGoawjtuixtlUfUmXdU3kyJV9
         CWOPOpkD6ro5l8Ipa0biA6w1HVaySW3pP9NchcMgAXZnHRsiz9ZRoH3FA7TtCV514owb
         /Dgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=44uFSIKvqnC7V+9ZchehMmm34h8scMBiFWmZbyka+5I=;
        b=uBGf36aE4nSXytFAYLqoOSxzpORHaPQ78JGLxeEB5QbvnxdANIUVgQyNic5rCa6zWM
         girjo5g67pSakUqiLsobdBiJ8ZeXVMNGOZr0BBaBfnPYm5XqSNrK2uNuG3uJAQanQU03
         ZiOvHx3NUZzml+ut4Pg8lmnvME11hpxDSl4UVo2LNkXUbElWd2CunCLN52A7vWBikFsd
         HFvhMawPtv+HexTb1OhhVUeJhXNMimpe5h2NVKEmdQm420DuLsExmmnTmviPgUcV5Mqk
         Owqy4TjwJi79Ijj8/tRECkgmF7fJqFoGRiezsVV49ExghwJCAa5T3KGs1GaqN5v+lkPT
         zgyw==
X-Gm-Message-State: AOAM5314UCXnY4x5UVtxxP1bTeMfZoNlTuV+hZ4ya6zgO06nDMraA5jr
        Yi820V0NmZCZd/J4aL920FzyUw==
X-Google-Smtp-Source: ABdhPJxhKU670JBxP1/tcRbCpUbeXzYl86y/mGbDNHJh9ApJICeW/4m3bDFRQbbY/jHbJnkmJZQJdw==
X-Received: by 2002:a65:45cf:: with SMTP id m15mr4170458pgr.7.1619107126146;
        Thu, 22 Apr 2021 08:58:46 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id n11sm2818575pff.96.2021.04.22.08.58.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 08:58:45 -0700 (PDT)
Date:   Thu, 22 Apr 2021 15:58:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Kenta Ishiguro <kentaishiguro@sslab.ics.keio.ac.jp>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        kvm <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Pierre-Louis Aublin <pl@sslab.ics.keio.ac.jp>,
        =?utf-8?B?5rKz6YeO5YGl5LqM?= <kono@sslab.ics.keio.ac.jp>
Subject: Re: [RFC PATCH 0/2] Mitigating Excessive Pause-Loop Exiting in
 VM-Agnostic KVM
Message-ID: <YIGdMZIVHVp3y/J0@google.com>
References: <20210421150831.60133-1-kentaishiguro@sslab.ics.keio.ac.jp>
 <YIBQmMih1sNb5/rg@google.com>
 <CANRm+CxMf=kwDRQE-BNbhgCARuV3fuKpDbEV2oWTeKuGhUYd+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANRm+CxMf=kwDRQE-BNbhgCARuV3fuKpDbEV2oWTeKuGhUYd+w@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 22, 2021, Wanpeng Li wrote:
> On Thu, 22 Apr 2021 at 09:45, Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Thu, Apr 22, 2021, Kenta Ishiguro wrote:
> > > To solve problems (2) and (3), patch 2 monitors IPI communication between
> > > vCPUs and leverages the relationship between vCPUs to select boost
> > > candidates.  The "[PATCH] KVM: Boost vCPU candidiate in user mode which is
> > > delivering interrupt" patch
> > > (https://lore.kernel.org/kvm/CANRm+Cy-78UnrkX8nh5WdHut2WW5NU=UL84FRJnUNjsAPK+Uww@mail.gmail.com/T/)
> > > seems to be effective for (2) while it only uses the IPI receiver
> > > information.
> >
> > On the IPI side of thing, I like the idea of explicitly tracking the IPIs,
> > especially if we can simplify the implementation, e.g. by losing the receiver
> > info and making ipi_received a bool.  Maybe temporarily table Wanpeng's patch
> > while this approach is analyzed?
> 
> Hi all,
> 
> I evaluate my patch

Thanks for doing the testing, much appreciated!

> (https://lore.kernel.org/kvm/1618542490-14756-1-git-send-email-wanpengli@tencent.com),
> Kenta's patch 2 and Sean's suggestion. The testing environment is
> pbzip2 in 96 vCPUs VM in over-subscribe scenario (The host machine is
> 2 socket, 48 cores, 96 HTs Intel CLX box).

Are the vCPUs affined in any way?  How many VMs are running?  Are there other
workloads in the host?  Not criticising, just asking so that others can reproduce
your setup.

> Note: the Kenta's scheduler hacking is not applied. The score of my patch is
> the most stable and the best performance.

On the other hand, Kenta's approach has the advantage of working for both Intel
and AMD.  But I'm also not very familiar with AMD's AVIC, so I don't know if it's
feasible to implement a performant equivalent in svm_dy_apicv_has_pending_interrupt().

Kenda's patch is also flawed as it doesn't scale to 96 vCPUs; vCPUs 64-95 will
never get boosted.

> Wanpeng's patch
> 
> The average: vanilla -> boost: 69.124 -> 61.975, 10.3%
> 
> * Wall Clock: 61.695359 seconds
> * Wall Clock: 63.343579 seconds
> * Wall Clock: 61.567513 seconds
> * Wall Clock: 62.144722 seconds
> * Wall Clock: 61.091442 seconds
> * Wall Clock: 62.085912 seconds
> * Wall Clock: 61.311954 seconds
> 
> Kenta' patch
> 
> The average: vanilla -> boost: 69.148 -> 64.567, 6.6%
> 
> * Wall Clock:  66.288113 seconds
> * Wall Clock:  61.228642 seconds
> * Wall Clock:  62.100524 seconds
> * Wall Clock:  68.355473 seconds
> * Wall Clock:  64.864608 seconds
> 
> Sean's suggestion:
> 
> The average: vanilla -> boost: 69.148 -> 66.505, 3.8%
> 
> * Wall Clock: 60.583562 seconds
> * Wall Clock: 58.533960 seconds
> * Wall Clock: 70.103489 seconds
> * Wall Clock: 74.279028 seconds
> * Wall Clock: 69.024194 seconds
