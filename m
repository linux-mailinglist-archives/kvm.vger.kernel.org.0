Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 636F35F32E2
	for <lists+kvm@lfdr.de>; Mon,  3 Oct 2022 17:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbiJCPrk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 11:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiJCPrd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 11:47:33 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B314331ED9
        for <kvm@vger.kernel.org>; Mon,  3 Oct 2022 08:47:31 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id q9so9990859pgq.8
        for <kvm@vger.kernel.org>; Mon, 03 Oct 2022 08:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=8DydcZk1u0xB1c+8RaosfYF4xcLu+b5YE36qeyQVzwg=;
        b=MWeYoPc1MT+Zh6TDC++oipZLPGWaGX7sho1om+CA6if9CGeO4XhqtOOzoT+1qAIr1k
         7h379rag4jGR5OOWqd9YNfGNS2IPSQpV0lwALCkQmTNOJBJCXpFbMChWirjlEhmp0kHC
         OYILiPeSHJxkvOmpg6rTY+oVqAFG0U69/WEEUOAvCKcJP9V8XmHoObiZ/3D8WKBC9Yd5
         hyOtD80f2AzLqB3yzVNvfRZIJAk0BUwhSOH5jx1SHhZlQZrPsJjd8jFRghEU/2+Qkxew
         ufUO65Q5D/17rnA/h3wHD0yX7mlG/4Ocz+aOi5/+s/pBgD2SHXwZcI10PaFqtRlvO2uz
         fLzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=8DydcZk1u0xB1c+8RaosfYF4xcLu+b5YE36qeyQVzwg=;
        b=2aiQLOsEVugB2UxKgzT3MFW4Vtbb96oUUnvOG2PpcOOAu85EGSwGl3VzQH4QuwnIXC
         FybydZImo7TFetZ7sjDUR3N8mZfKyGQwC7vKv7KXhtjSOVyZy8OOh73zqa71P3xasuYQ
         vFEhK0VTJUlMT9rjl2uJky+Q7weDnsxCFFlzKA6p2ZbwSM2zxccGXwkDw3zWpwp/EiZd
         2QhLPgKAbcePMuqpNMuO21d4W4zakg3VIMyE6OaYhBpBwrlZfdCG//c8T2QoWebnNElG
         HcVBZGCHTP/fPIMKW+H4cgNFuT2XwdFBm4NoAF6vnR+zppiwOKEKVuRzJGURTyMUyaBm
         G9hQ==
X-Gm-Message-State: ACrzQf1eDmMuQDEu0LO6CMUJtCsStHKSQMPaGA5gV0dkbFKRGmfT3vdK
        pB/hIwVUVWDWjllao8Brjm3xbw==
X-Google-Smtp-Source: AMsMyM52dARElRANgpzevE3YdMwr8PFlAPyQOLwPouPXpqstlH2f32r1yLtIU993s71u+zmhNCU+kA==
X-Received: by 2002:a63:4042:0:b0:43b:ddc8:235 with SMTP id n63-20020a634042000000b0043bddc80235mr19773380pga.498.1664812050292;
        Mon, 03 Oct 2022 08:47:30 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f4-20020a170902ce8400b00178b77b7e71sm7444647plg.188.2022.10.03.08.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 08:47:29 -0700 (PDT)
Date:   Mon, 3 Oct 2022 15:47:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 30/39] KVM: selftests: Hyper-V PV TLB flush selftest
Message-ID: <YzsEDt3f/+a0FuBS@google.com>
References: <20220921152436.3673454-1-vkuznets@redhat.com>
 <20220921152436.3673454-31-vkuznets@redhat.com>
 <YyuVtrpQwZGHs4ez@google.com>
 <87wn9h9i3w.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wn9h9i3w.fsf@redhat.com>
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

On Mon, Oct 03, 2022, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> > Anyways, why not do e.g. usleep(1)?  
> 
> I was under the impression that all these 'sleep' functions result in a
> syscall (and I do see TRIPLE_FAULT when I swap my rep_nop() with usleep())
> and here we need to wait in the guest (sender) ...

Oh, duh, guest code.

> > And if you really need a udelay() and not a
> > usleep(), IMO it's worth adding exactly that instead of throwing NOPs at the CPU.
> > E.g. aarch64 KVM selftests already implements udelay(), so adding an x86 variant
> > would move us one step closer to being able to use it in common tests.
> 
> ... so yes, I think we need a delay. The problem with implementing
> udelay() is that TSC frequency is unknown. We can get it from kvmclock
> but setting up kvmclock pages for all selftests looks like an
> overkill. Hyper-V emulation gives us HV_X64_MSR_TSC_FREQUENCY but that's
> not generic enough. Alternatively, we can use KVM_GET_TSC_KHZ when
> creating a vCPU but we'll need to pass the value to guest code somehow.
> AFAIR, we can use CPUID.0x15 and/or MSR_PLATFORM_INFO (0xce) or even
> introduce a PV MSR for our purposes -- or am I missing an obvious "easy"
> solution?

I don't think you're missing anything.  Getting the value into the guest is the
biggest issue.

Vishal is solving a similar problem where the guest needs to know the "native"
hypercall.  We can piggyback that hook to do KVM_GET_TSC_KHZ there during VM
creation, and then simply define udelay()'s behavior to always operate on the
"default" frequency.  I.e. if a test wants to change the frequency _and_ use
udelay() _and_ cares about the precision of udelay(), then that test can go write
its own code.

> I'm thinking about being lazy here and implemnting a Hyper-V specific
> udelay through HV_X64_MSR_TSC_FREQUENCY (unless you object, of course)
> to avoid bloating this series beyond 46 patches it already has.

I'm totally fine being even lazier here and just using a loop of nops, but with a
different function name and a TODO (I completely forgot this was guest code when
making the usleep() suggestion).  Then we can clean up the TODO via udelay() in a
follow-up series.
