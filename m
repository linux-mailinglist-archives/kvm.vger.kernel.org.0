Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 354DA3F2E68
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 16:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240948AbhHTOvZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 10:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240925AbhHTOvY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 10:51:24 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA6AC061756
        for <kvm@vger.kernel.org>; Fri, 20 Aug 2021 07:50:46 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id w8so9412699pgf.5
        for <kvm@vger.kernel.org>; Fri, 20 Aug 2021 07:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JGuj1VwD0W0DzU9vP04cQlmRF+lXog9aAVn3JecGAeQ=;
        b=RR1lilCvXWY2ei1/zxEkDhnMybfRnhBQOWM9qAnQKXFZ2v2sCEgE8DzPgCM1fKhN5H
         STsNMm/YX7+lpJnsUbktiONRrpL+Wr4EHjg/7Z1+EfV7gBCqO2cZ7hbqpmKmhIBLLUPh
         Z8wE+NS1ikXdLgy3nwfujgpyMLw7K+n4o1SqRaqaZIbQqWvsA+kw36HQ/1Si0x78QEM8
         05j9nhn1e+Ty7u1lX27j1oeC61eicOJuWvm5GqgzDB1AHuvFqvsqmHnmUK2FLOu/s+f5
         qyrhQkKE6kIFg+e0iAlb4IX7SN6Fly66xEdgsONLbUrlEmtSTosX3xA6A4Nt0/nETTep
         S8pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JGuj1VwD0W0DzU9vP04cQlmRF+lXog9aAVn3JecGAeQ=;
        b=KQvJLrshKnURxhWD1huZ6wSXrsTWMt1HUWm1YQRwYvyJ9QXtevfRSxxIlpoaBrZLCj
         pP4X/Uv5O1wWM5TfRD3onD24gyckiG7lJ/r5z5YN+BYZm6nTLLUGDp/4S1mwfzKJOrY0
         hdW8s8DyLKsLBTZCN0cuKnNsUEU6G3J8GuwZQghV9ObNvxXbpUk/1m1WgwOKmNlc1GlL
         TvYYir7G1VTlV1KK8YLuwW4Rp1wAa+BCOUAHXa4N20VEbEZTkoghVcIxOz6yeEAwka2J
         9pciCW7wHWnGlp0/h1V7KRd3jQlOlAUEhpB9k91DXHlZUoDmZyDxQNjoNexMtpWLgyl9
         OUHA==
X-Gm-Message-State: AOAM532i6/RXI+UGmBM1H4E5q7dKFmMn+NNCY5s9GGgCrhSPIwuwTzDj
        3XLybg3E7LaGq4F/ww3PcdL2lg==
X-Google-Smtp-Source: ABdhPJyEx3dnS6ofqod/ujgRqTLIZJ1PZiU9m3YtE6sLUF44vp5o8uI243eQ9JwfQJUeEFs6w4uJaw==
X-Received: by 2002:a05:6a00:1712:b0:3e2:fb85:79f5 with SMTP id h18-20020a056a00171200b003e2fb8579f5mr12414289pfc.27.1629471045996;
        Fri, 20 Aug 2021 07:50:45 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t38sm7330306pfg.207.2021.08.20.07.50.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 07:50:45 -0700 (PDT)
Date:   Fri, 20 Aug 2021 14:50:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Orr <marcorr@google.com>
Cc:     Peter Gonda <pgonda@google.com>, kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 V4] KVM, SEV: Add support for SEV intra host migration
Message-ID: <YR/BPwnj6Nudgu1r@google.com>
References: <20210819154910.1064090-1-pgonda@google.com>
 <20210819154910.1064090-2-pgonda@google.com>
 <CAA03e5Gh0kJYHP1R3F7uh6x83LBFPp=af2xt7q3epgg+8XW53g@mail.gmail.com>
 <CAMkAt6oJcW3MHP3fod9RnRHCEYp-whdEtBTyfuqgFgATKa=3Hg@mail.gmail.com>
 <YR7iD6kdTUpWwwRn@google.com>
 <CAA03e5FAXDVSwMAQO57gztYmB2K8K8fNrHwsX_N3Hbgwch8pBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA03e5FAXDVSwMAQO57gztYmB2K8K8fNrHwsX_N3Hbgwch8pBw@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 19, 2021, Marc Orr wrote:
> On Thu, Aug 19, 2021 at 3:58 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Thu, Aug 19, 2021, Peter Gonda wrote:
> > > Marc I think that only having the spin lock could result in
> > > deadlocking. If userspace double migrated 2 VMs, A and B for
> > > discussion, A could grab VM_A.spin_lock then VM_A.kvm_mutex. Meanwhile
> > > B could grab VM_B.spin_lock and VM_B.kvm_mutex. Then A attempts to
> > > grab VM_B.spin_lock and we have a deadlock. If the same happens with
> > > the proposed scheme when A attempts to lock B, VM_B.spin_lock will be
> > > open but the bool will mark the VM under migration so A will unlock
> > > and bail. Sean originally proposed a global spin lock but I thought a
> > > per kvm_sev_info struct would also be safe.
> >
> > Close.  The issue is taking kvm->lock from both VM_A and VM_B.  If userspace
> > double migrates we'll end up with lock ordering A->B and B-A, so we need a way
> > to guarantee one of those wins.  My proposed solution is to use a flag as a sort
> > of one-off "try lock" to detect a mean userspace.
> 
> Got it now. Thanks to you both, for the explanation. By the way, just
> to make sure I completely follow, I assume that if a "double
> migration" occurs, then user space is mis-behaving -- correct?

Yep.

> But presumably, we need to reason about how to respond to such mis-behavior
> so that buggy or malicious user-space code cannot stumble over/exploit this
> scenario?

That's what the anti-deadlock flag is for. :-)  With that in place, there's no
meaningful difference between say a bad userspace doing double migrate and a bad
userspace migrating from garbage, e.g. passing in a bogus fd.
