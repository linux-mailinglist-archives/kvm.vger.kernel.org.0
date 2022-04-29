Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 182615158EE
	for <lists+kvm@lfdr.de>; Sat, 30 Apr 2022 01:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381612AbiD2X07 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 19:26:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381563AbiD2X06 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 19:26:58 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA48CB015
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 16:23:37 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id gj17-20020a17090b109100b001d8b390f77bso11782154pjb.1
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 16:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=TgWk1OrzhJm8KIPseeZpTJ3sK4pPkWoy9iKngLNbReg=;
        b=gpny65B3540owtoHo6pIiVHUycEUlDOB9gpLH8hucOPahQYLUb/tjUSt6eH0w3zTqk
         EG6ZvoDr0DuYxBlWpMKXqUCzDu7Tj/q6vSjqpGMrFnkxt02eWpTH7OjwvjjF0yED5qhs
         NcQz529vZ7+jXOzTypJDfOVxRAGtPZA74vu2MXSvcM5PoJ4DaHOBJogsftOMPAFFZBWI
         axrUt2P9uuneNICvmmJFg30PZiBDDrA3VpXeKzaThLwIC5KcxQPzbvzSZYryHn4e8bf5
         ODv0fgSDSA8AraCPnjSA7BRDBYgy3eV1Uu9CpUZl2OJMxvhlqAzJuzjmZDnWRnizePdz
         CwjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=TgWk1OrzhJm8KIPseeZpTJ3sK4pPkWoy9iKngLNbReg=;
        b=QPu2Bjc3k1QcOXi0G/8EpX2qyAPVfqfW2RcMksXZOQ1CXqMtul7C/7lexXUGJ1kZq1
         5cOhuTqL5KSBrVCByMiry2tv9pQlnOaTI10YhlNA017Odt8Uen/+ANWxz4ANwbEVe1U0
         ggU5zHSl9uzWZPoccLfQGfr4badKvCX7euh1WAmBxxPTZPwlEtgy+1UuHPdDzgGDPFXX
         3urgcYw6s7ZJD9URUUfAyheXnpj8gth5HJerOnMKrVB8C74d6eZKmvlRr2YRr5m7gC/B
         1EuU9DDT1zgte5atImt79yu1vPWsApRGs/0VJFrFZZmTmXRjiSsidk4VXFYkdyuV32R1
         VOAA==
X-Gm-Message-State: AOAM533k4qcoflqAdnB5zXvdpkVO5vgAdmtLbg4Tur/fV2CGRhyRr1Kg
        SGp9aOkddkUO19yweFkXRFvF+Q==
X-Google-Smtp-Source: ABdhPJz/n9yRO2rPhWkXnmDIx9sJW11Bkd/kppGz2Ol+fVzRbbysIxReW+qaosFI12Kp+4M5dPylfw==
X-Received: by 2002:a17:902:6ac9:b0:156:a6ae:8806 with SMTP id i9-20020a1709026ac900b00156a6ae8806mr1323364plt.148.1651274616370;
        Fri, 29 Apr 2022 16:23:36 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 64-20020a17090a0fc600b001cd4989fedesm15192657pjz.42.2022.04.29.16.23.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 16:23:35 -0700 (PDT)
Date:   Fri, 29 Apr 2022 23:23:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jon Kohler <jon@nutanix.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Balbir Singh <sblbir@amazon.com>,
        Kim Phillips <kim.phillips@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v3] x86/speculation, KVM: only IBPB for
 switch_mm_always_ibpb on vCPU load
Message-ID: <YmxzdAbzJkvjXSAU@google.com>
References: <20220422162103.32736-1-jon@nutanix.com>
 <YmwZYEGtJn3qs0j4@zn.tnic>
 <645E4ED5-F6EE-4F8F-A990-81F19ED82BFA@nutanix.com>
 <Ymw9UZDpXym2vXJs@zn.tnic>
 <YmxKqpWFvdUv+GwJ@google.com>
 <YmxRnwSUBIkOIjLA@zn.tnic>
 <Ymxf2Jnmz5y4CHFN@google.com>
 <YmxlHBsxcIy8uYaB@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YmxlHBsxcIy8uYaB@zn.tnic>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 30, 2022, Borislav Petkov wrote:
> On Fri, Apr 29, 2022 at 09:59:52PM +0000, Sean Christopherson wrote:
> > Correct, but KVM also doesn't do IBPB on VM-Exit (or VM-Entry),
> 
> Why doesn't it do that? Not needed?

The host kernel is protected via RETPOLINE and by flushing the RSB immediately
after VM-Exit.

> > nor does KVM do IBPB before exiting to userspace.
> 
> Same question.

I don't know definitively.  My guess is that IBPB is far too costly to do on every
exit, and so the onus was put on userspace to recompile with RETPOLINE.  What I
don't know is why it wasn't implemented as an opt-out feature.

> > The IBPB we want to whack is issued only when KVM is switching vCPUs.
> 
> Then please document it properly as I've already requested.

I'll write up the bits I have my head wrapped around.

> > Except that _none_ of that documentation explains why the hell KVM
> > does IBPB when switching betwen vCPUs.
> 
> Probably because the folks involved in those patches weren't the hell
> mainly virt people. Although I see a bunch of virt people on CC on that
> patch.
> 
> >   : But stepping back, why does KVM do its own IBPB in the first place?  The goal is
> >   : to prevent one vCPU from attacking the next vCPU run on the same pCPU.  But unless
> >   : userspace is running multiple VMs in the same process/mm_struct, switching vCPUs,
> >   : i.e. switching tasks, will also switch mm_structs and thus do IPBP via cond_mitigation.
> >   :
> >   : If userspace runs multiple VMs in the same process,
> 
> This keeps popping up. Who does that? Can I get a real-life example to
> such VM-based containers or what the hell that is, pls?

I don't know of any actual examples.  But, it's trivially easy to create multiple
VMs in a single process, and so proving the negative that no one runs multiple VMs
in a single address space is essentially impossible.

The container thing is just one scenario I can think of where userspace might
actually benefit from sharing an address space, e.g. it would allow backing the
image for large number of VMs with a single set of read-only VMAs.

> > enables cond_ipbp, _and_ sets
> >   : TIF_SPEC_IB, then it's being stupid and isn't getting full protection in any case,
> >   : e.g. if userspace is handling an exit-to-userspace condition for two vCPUs from
> >   : different VMs, then the kernel could switch between those two vCPUs' tasks without
> >   : bouncing through KVM and thus without doing KVM's IBPB.
> >   :
> >   : I can kinda see doing this for always_ibpb, e.g. if userspace is unaware of spectre
> >   : and is naively running multiple VMs in the same process.
> 
> So this needs a clearer definition: what protection are we even talking
> about when the address spaces of processes are shared? My naïve
> thinking would be: none. They're sharing address space - branch pred.
> poisoning between the two is the least of their worries.

I truly have no idea, which is part of the reason I brought it up in the first
place.  I'd have happily just whacked KVM's IBPB entirely, but it seemed prudent
to preserve the existing behavior if someone went out of their way to enable
switch_mm_always_ibpb.

> So to cut to the chase: it sounds to me like you don't want to do IBPB
> at all on vCPU switch.

Yes, or do it iff switch_mm_always_ibpb is enabled to maintain "compability".

> And the process switch case is taken care of by switch_mm().

Yep.
