Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78CD7383C55
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 20:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237207AbhEQSgC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 14:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237050AbhEQSgB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 May 2021 14:36:01 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2762AC061573
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 11:34:45 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id b21so3686186plz.0
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 11:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bzvl/cyI6Vow+Fou3NqkXda8XWse6PpXRNaY31CBjZU=;
        b=uXaQuk1ku0CrWVjOMU4k4deRZE8OOKuwRLCyNjyg+v7qPW/KrVncQ7ybChG9+D+bx7
         PuBTTAi3SPDbT3STpXVq1Ubmq0ModxFtsymoP1K/zrzMi4d325lLsC1Erjpmy85wDx7h
         Sc6CsNX7pW5uQ8vG1iyxGsAKEIlqbVnr3Zhk2xwsHLinIzBNskD214vo3q8T7qDuBNcS
         aMEQ4E5WVRGoqy0QBPnXCiogGShmcivVjmK+bIxSvecHoPKadjGHKL+OkLgbV4ElIFzi
         DO+nJ+KnGmC3wX8UjQor3DdvJ4eW2mEFWwPGfwZ5qkp89ng6u1b7kZLVyyUHRVca2/4G
         I3oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bzvl/cyI6Vow+Fou3NqkXda8XWse6PpXRNaY31CBjZU=;
        b=tk+6IX/lWibx5poxXAet3wtuulg7Y8MT9QlyYMgyhziHkVmsGEUx1FUpYrt8JPoi7k
         PEICKT8xMiAI0ZBXqiM38cxReT1oLrqdViR1OeDPg8lq6DelnEoKR1fuNRbYIOk4SDcw
         V4xfaUdd1OmmNlAa7VAB8+ZWZwUWpD+NxIrAeMY2gXHiOHnL3FhIYrlYd4Ci/7BWpf29
         XjcRdkKcuWC4HO0T1iXYzh3n4SGa1UUVbH9WoPf4EFuyNOnPeeCUlDum/XarefxS0/sm
         AkHlwn6y/hJB6lN7fByqEUO0fLDRq9ubWwEg89VvZ2E7sVOsEWT2DZjGggRI/vJMDt1f
         td8Q==
X-Gm-Message-State: AOAM532c6OTESpoS3XVLCqaUKMPygkadgXvYJYwNDcAXbNFeOVzz8/27
        M6uk2oFCX9vdiMFURbNpVxfhVQ==
X-Google-Smtp-Source: ABdhPJzOuuaprPntwecuzo2ZpnXzkx8fj6a6DdNi1LG7EL8cdvGS96KWq0ZX0xTFX/RMOWE+AlgewA==
X-Received: by 2002:a17:902:dacf:b029:ee:ac0e:d0fe with SMTP id q15-20020a170902dacfb02900eeac0ed0femr1460779plx.30.1621276484513;
        Mon, 17 May 2021 11:34:44 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id h19sm10926752pgm.40.2021.05.17.11.34.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 11:34:43 -0700 (PDT)
Date:   Mon, 17 May 2021 18:34:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jon Kohler <jon@nutanix.com>, Babu Moger <babu.moger@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Yu-cheng Yu <yu-cheng.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Petteri Aimonen <jpa@git.mail.kapsi.fi>,
        Kan Liang <kan.liang@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>,
        Benjamin Thiel <b.thiel@posteo.de>,
        Fan Yang <Fan_Yang@sjtu.edu.cn>,
        Juergen Gross <jgross@suse.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: add hint to skip hidden rdpkru under
 kvm_load_host_xsave_state
Message-ID: <YKK3QLr2OsUdrX5D@google.com>
References: <20210507164456.1033-1-jon@nutanix.com>
 <CALCETrW0_vwpbVVpc+85MvoGqg3qJA+FV=9tmUiZz6an7dQrGg@mail.gmail.com>
 <5e01d18b-123c-b91f-c7b4-7ec583dd1ec6@redhat.com>
 <YKKqQZH7bX+7PDjX@google.com>
 <4e6f7056-6b66-46b9-9eac-922ae1c7b526@www.fastmail.com>
 <342a8ba9-037e-b841-f9b1-cb62e46c0db8@intel.com>
 <YKKwSLnkzc77HcnG@google.com>
 <CALMp9eS80a+Oy6spKT3cG7DCTW6jVwhyBuZ_t0SND=80Lg1XWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eS80a+Oy6spKT3cG7DCTW6jVwhyBuZ_t0SND=80Lg1XWA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 17, 2021, Jim Mattson wrote:
> On Mon, May 17, 2021 at 11:05 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Mon, May 17, 2021, Dave Hansen wrote:
> > > On 5/17/21 10:49 AM, Andy Lutomirski wrote:
> > > >> The least awful solution would be to have the NMI handler restore
> > > >> the host's PKRU.  The NMI handler would need to save/restore the
> > > >> register, a la CR2, but the whole thing could be optimized to run
> > > >> if and only if the NMI lands in the window where the guest's PKRU
> > > >> is loaded.
> > > >
> > > > Or set a flag causing nmi_uaccess_ok() to return false.
> > >
> > > Oh, that doesn't sound too bad.  The VMENTER/EXIT paths are also
> > > essentially a context switch.
> >
> > I like that idea, too.
> >
> > The flag might also be useful to fix the issue where the NMI handler activates
> > PEBS after KVM disables it.  Jim?
> 
> The issue is actually that the NMI handler *clears* IA32_PEBS_ENABLE
> bits after giving out the host value of the MSR to KVM. If we were to
> block the NMI handler from modifying IA32_PEBS_ENABLE until after the
> next VM-exit, that could solve this issue. I don't know if it makes
> sense to piggyback on nmi_uaccess(), though.

I wasn't thinking about using nmi_uaccess_okay(), but rather whatever flag is
added so that can KVM can inform the NMI handler that KVM is in the middle of
its version of a context switch.

> > > Will widening the window where nmi_uaccess_okay()==false anger any of
> > > the perf folks?  It looks like perf knows how to handle it nicely.
