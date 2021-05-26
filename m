Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03B20391CC7
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 18:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232721AbhEZQQv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 12:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbhEZQQs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 12:16:48 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8543C061574
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 09:15:15 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id b15-20020a17090a550fb029015dad75163dso653065pji.0
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 09:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LsTUhRIzMiGOPzu0wFBll6Sat6SdwoouWOQTfFNCCKs=;
        b=p33nyeJc82PGLNl739Gh4fhMojxiK0bsEN2zqawr7ymRxW2hxaeAkS8oJmt/tsT6cr
         4ivme2D3PV8ypCy78qOGLFVChmiRD3W02Y80AezHnDakj39ONJxs6zOftjnalxe6tDfZ
         PNgcVysUZ34l16KJ8RhXIzntn6jePdduSyYWUUlSPL/fj79tE/6IfJNEf4+/EsyOUw22
         EiQSAfOe03HamheqsEPXl1Gah/SnmYXGiS6HL3ouoyDA8foIr+LhvILcpcUq5BD8jEvR
         1nJaUua8iCAFnIA4Esba6kEkLBIanDeEkCJ2U6UF+WgzKFnupjCFq8Jv46HTUGwLVqEf
         e1nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LsTUhRIzMiGOPzu0wFBll6Sat6SdwoouWOQTfFNCCKs=;
        b=SfOKRINKufiiKbmO3gL5q5iJ7KjWQndyF5l92gZz7oGCrJYNiis2GbwjzB1LDSDH+Q
         qbN3f8L3R1B6pvc/Uq4PrjUOQp7FHDOS5wJKyLEsaHICZhcdrePbXcxqyBkucyNlhu0d
         phh0qv9yFhj5LUUQluv3Ujh6kn0z7ruafhIEJoCkWJ/pLN8GODbiA4RKS2DUxSkVyqd6
         1oSQ3u1dChPuIO1woIioI0mTNqyJjlCG8HvAU3aJNJ0NI5WayDzMlGe+vis7v2ui+GHr
         XMOowPXDAflFVxHhQbvcQfSTWmlilkvc/tHHzRDuM+X0R13A3vbncW/q+fsu56JH6nsJ
         uPJw==
X-Gm-Message-State: AOAM531HhgDVhLyMLxNq0rdb7PuZ1w61/TEKJjGC+A+0XmfSmMEpntUv
        r6su1mZCWG6t8FZpc3UscdFKVQ==
X-Google-Smtp-Source: ABdhPJzj3FFsZjfje8nItMsxch1wg8M2VHKC44nbewwE2q+8XaVXKKJ6poNvfcuhRfoPX6yPJkhyFQ==
X-Received: by 2002:a17:90a:542:: with SMTP id h2mr4604354pjf.82.1622045714986;
        Wed, 26 May 2021 09:15:14 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id mp21sm4736323pjb.50.2021.05.26.09.15.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 09:15:14 -0700 (PDT)
Date:   Wed, 26 May 2021 16:15:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Masanori Misono <m.misono760@gmail.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Rohit Jain <rohit.k.jain@oracle.com>,
        Ingo Molnar <mingo@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 0/1] Make vCPUs that are HLT state candidates for
 load balancing
Message-ID: <YK50DvnogyiMTjhn@google.com>
References: <20210526133727.42339-1-m.misono760@gmail.com>
 <YK5gFUjh6MX6+vx3@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YK5gFUjh6MX6+vx3@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 26, 2021, Peter Zijlstra wrote:
> On Wed, May 26, 2021 at 10:37:26PM +0900, Masanori Misono wrote:
> > Hi,
> > 
> > I observed performance degradation when running some parallel programs on a
> > VM that has (1) KVM_FEATURE_PV_UNHALT, (2) KVM_FEATURE_STEAL_TIME, and (3)
> > multi-core architecture. The benchmark results are shown at the bottom. An
> > example of libvirt XML for creating such VM is
> > 
> > ```
> > [...]
> >   <vcpu placement='static'>8</vcpu>
> >   <cpu mode='host-model'>
> >     <topology sockets='1' cores='8' threads='1'/>
> >   </cpu>
> >   <qemu:commandline>
> >     <qemu:arg value='-cpu'/>
> >     <qemu:arg value='host,l3-cache=on,+kvm-pv-unhalt,+kvm-steal-time'/>
> >   </qemu:commandline>
> > [...]
> > ```
> > 
> > I investigate the cause and found that the problem occurs in the following
> > ways:
> > 
> > - vCPU1 schedules thread A, and vCPU2 schedules thread B. vCPU1 and vCPU2
> >   share LLC.
> > - Thread A tries to acquire a lock but fails, resulting in a sleep state
> >   (via futex.)
> > - vCPU1 becomes idle because there are no runnable threads and does HLT,
> >   which leads to HLT VMEXIT (if idle=halt, and KVM doesn't disable HLT
> >   VMEXIT using KVM_CAP_X86_DISABLE_EXITS).
> > - KVM sets vCPU1's st->preempted as 1 in kvm_steal_time_set_preempted().
> > - Thread C wakes on vCPU2. vCPU2 tries to do load balancing in
> >   select_idle_core(). Although vCPU1 is idle, vCPU1 is not a candidate for
> >   load balancing because is_vcpu_preempted(vCPU1) is true, hence
> >   available_idle_cpu(vPCU1) is false.
> > - As a result, both thread B and thread C stay in the vCPU2's runqueue, and
> >   vCPU1 is not utilized.

If a patch ever gets merged, please put this analysis (or at least a summary of
the problem) in the changelog.  From the patch itself, I thought "and the vCPU
becomes a candidate for CFS load balancing" was referring to CFS in the host,
which was obviously confusing.

> > The patch changes kvm_arch_cpu_put() so that it does not set st->preempted
> > as 1 when a vCPU does HLT VMEXIT. As a result, is_vcpu_preempted(vCPU)
> > becomes 0, and the vCPU becomes a candidate for CFS load balancing.
> 
> I'm conficted on this; the vcpu stops running, the pcpu can go do
> anything, it might start the next task. There is no saying how quickly
> the vcpu task can return to running.

Ya, the vCPU _is_ preempted after all.

> I'm guessing your setup doesn't actually overload the system; and when
> it doesn't have the vcpu thread to run, the pcpu actually goes idle too.
> But for those 1:1 cases we already have knobs to disable much of this
> IIRC.
> 
> So I'm tempted to say things are working as expected and you're just not
> configured right.

That does seem to be the case.  

> > I created a VM with 48 vCPU, and each vCPU is pinned to the corresponding pCPU.

If vCPUs are pinned and you want to eke out performance, then I think the correct
answer is to ensure nothing else can run on those pCPUs, and/or configure KVM to
not intercept HLT.
