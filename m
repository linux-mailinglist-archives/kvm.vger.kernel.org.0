Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 037FF553895
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 19:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351837AbiFURJo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 13:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352201AbiFURJm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 13:09:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 037EE27B11
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 10:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655831378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5kAhXV5ceZVd9SW+rj4Nij9cH0l8kTqdMQa24MeO028=;
        b=a6tE37yWZvfapKGwM2BaMX2wmLDc/0oRNaiFLfpkIPBaE28KIL3qkVBsKp12PsdhlGq3lU
        90rGrxpHNMpJtKmJGx01KxV673oZSZxnGc1x/jUY1y21hLwzhkAS/W4B72R4F6JP5UkGOd
        XduCukErzoY0VrzFq7HyPIoPGjxx9Fo=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-427-f6R0vqI5NEuliIefHVJ-NQ-1; Tue, 21 Jun 2022 13:09:37 -0400
X-MC-Unique: f6R0vqI5NEuliIefHVJ-NQ-1
Received: by mail-il1-f199.google.com with SMTP id l2-20020a056e0212e200b002d9258029c4so2093595iln.22
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 10:09:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5kAhXV5ceZVd9SW+rj4Nij9cH0l8kTqdMQa24MeO028=;
        b=AXpA9TZGEG7+tfaSgQF34BOJK062GyzdyQ64PjxMo44e3lXWfNnKYi5sBtVoB2lV5H
         udJtkIFYH6/VWD6Vk4Q9DKF1rj5x87aQ5CcILd+7ZsPo6k/n0mlajTxYW4Sdu0cqpJ1E
         2HMIjh8Xt9mMaT+u8gd/9UADYFycjy3NTkLNRZK8B/WAxXdzmpAZFZpBjU62j48gjp6Y
         qbL8/gAbKPaMOqj8BWGGoQVtA4vp6Ud7sG0e/BAG5sGYA4rBA18lsjaVlZOB4o2+v6s3
         EXy6KwT/Qq6pAoX+zFDkSrHAxDo0Pr1GB2UN/DwNafRyZ+Fx3AR4nA/Hmt8LXd1zaStl
         77CA==
X-Gm-Message-State: AJIora+QrWYXWPFKs0l84VWHEx0Dup4HtJoStlW9WJ4S8eABCcuLq/UV
        3G3fPZsitLSz6BR1Jvsh50djYw5Y5B0iopsoMBwOriT2gnPY6fVidiIi5LZZNpQGMu6cNrHP0vo
        u4ZsXM1JBAZrj
X-Received: by 2002:a05:6638:240a:b0:332:783:156b with SMTP id z10-20020a056638240a00b003320783156bmr16359095jat.306.1655831376643;
        Tue, 21 Jun 2022 10:09:36 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sEoM/q2ZzHHdyf2r5gcqetk1jTonW7PHJFLpLSAjDLzc2r35SkR603oJ4EMetLtOp4Z+ydng==
X-Received: by 2002:a05:6638:240a:b0:332:783:156b with SMTP id z10-20020a056638240a00b003320783156bmr16359088jat.306.1655831376427;
        Tue, 21 Jun 2022 10:09:36 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id o33-20020a027421000000b00331a211407fsm7406362jac.93.2022.06.21.10.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 10:09:35 -0700 (PDT)
Date:   Tue, 21 Jun 2022 13:09:34 -0400
From:   Peter Xu <peterx@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH RFC 1/4] mm/gup: Add FOLL_INTERRUPTIBLE
Message-ID: <YrH7ToN8fDB0PbW3@xz-m1.local>
References: <20220617014147.7299-1-peterx@redhat.com>
 <20220617014147.7299-2-peterx@redhat.com>
 <212f8b31-e470-d62c-0090-537d0d60add9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <212f8b31-e470-d62c-0090-537d0d60add9@redhat.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 21, 2022 at 10:23:32AM +0200, David Hildenbrand wrote:
> On 17.06.22 03:41, Peter Xu wrote:
> > We have had FAULT_FLAG_INTERRUPTIBLE but it was never applied to GUPs.  One
> > issue with it is that not all GUP paths are able to handle signal delivers
> > besides SIGKILL.
> > 
> > That's not ideal for the GUP users who are actually able to handle these
> > cases, like KVM.
> > 
> > KVM uses GUP extensively on faulting guest pages, during which we've got
> > existing infrastructures to retry a page fault at a later time.  Allowing
> > the GUP to be interrupted by generic signals can make KVM related threads
> > to be more responsive.  For examples:
> > 
> >   (1) SIGUSR1: which QEMU/KVM uses to deliver an inter-process IPI,
> >       e.g. when the admin issues a vm_stop QMP command, SIGUSR1 can be
> >       generated to kick the vcpus out of kernel context immediately,
> > 
> >   (2) SIGINT: which can be used with interactive hypervisor users to stop a
> >       virtual machine with Ctrl-C without any delays/hangs,
> > 
> >   (3) SIGTRAP: which grants GDB capability even during page faults that are
> >       stuck for a long time.
> > 
> > Normally hypervisor will be able to receive these signals properly, but not
> > if we're stuck in a GUP for a long time for whatever reason.  It happens
> > easily with a stucked postcopy migration when e.g. a network temp failure
> > happens, then some vcpu threads can hang death waiting for the pages.  With
> > the new FOLL_INTERRUPTIBLE, we can allow GUP users like KVM to selectively
> > enable the ability to trap these signals.
> 
> This makes sense to me. I assume relevant callers will detect "GUP
> failed" but also "well, there is a signal to handle" and cleanly back
> off, correct?

Correct, via an -EINTR.

One thing to mention is that the gup user behavior will be the same as
before if the caller didn't explicilty pass in FOLL_INTERRUPTIBLE with the
gup call.  So after the whole series applied only kvm (and only some path
of kvm, not all GUP; I only touched up the x86 slow page fault path) to
handle this, but that'll be far enough to cover 99.99% use cases that I
wanted to take care of.

E.g., some kvm request to gup on some guest apic page may not still be able
to respond to a SIGUSR1 but that's very very rare, and we can always add
more users of FOLL_INTERRUPTIBLE when the code is ready to benefit from the
fast respondings.

Thanks,

-- 
Peter Xu

