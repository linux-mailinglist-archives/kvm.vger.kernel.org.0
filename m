Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1B03F5FEB
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 16:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237654AbhHXOMB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 10:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232311AbhHXOL6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 10:11:58 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E76C061757
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 07:11:14 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id t42so15915787pfg.12
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 07:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YmLwTeFT+SxrtBDHPBlPpTooAeMLXJ6OjqZTL8UUNLs=;
        b=I9NZiJ1mM99W5a+Rj8XRIr7s3/bH+LCbc2cMe4RQvNyEG7Y6litHc20xpr75dBtISa
         kTS75RUDWc9R4tslWVGsZYjr7tWxI7F7lVhfXN+w83+i4hLncRmApmshgZHRS8VBIASz
         JgO0+bxHdm+kKqInFXjRY8CYDXVk/E7MFO+2mKTVD2YNOfcxs35/rVsTkLo3qNbVxl+y
         jJInUuwcnaldaK3ai3I+ZZ1Fj8bfdkHZjCroeg5eR4KRLRnJOFPYcfNLpz5A2rktxgAc
         UqexHcwCIye8OLocmxGiFFcrLjPvRM6qrNUBkzD0qcZodnN9Elg+jeIRJ0D6K9HbYxTb
         ri1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YmLwTeFT+SxrtBDHPBlPpTooAeMLXJ6OjqZTL8UUNLs=;
        b=qrHIiRk4hWgRKCrB+IuUKBU3Bx1k0VRkGUcOPgo72bzhQhSQALYvxnJqBh26TKwNrm
         V+/4IElaaosZFRUxbm0G587BHWlQoLWDJOPLSk0jaFZYUsmlQrimdOCD/51RAFWrc8t6
         p6MFxI2TrEMnEvDIaLMFQ24ZvPQAxkha0TX2latZU4uDA1IZKHIUWF+oUeRoEJY/V173
         foBNgmPxAOgowY+1fxmhFRlena+frJBVbdytGpTfQVyVoOAI2Y9ANfraNpPFosoK4EEd
         ul9Jd80LXzl1/pkQQOAOzdrwC2vn1RIhO3rA5zcLT2n1jqJ3FKWvMo12Ky3h/IlD1eAL
         q7fw==
X-Gm-Message-State: AOAM531wS+Lj/0MCGgNgrGYvr7vhIaRPVWTG65aWrIaVjlBTvIq88SoO
        bwcz28BS4NlBlL/M95eY7fF57g==
X-Google-Smtp-Source: ABdhPJz7RfF2QLwXvYlzePFOBGFnKOn7bmELvMtuWl6us8IT/ixsx9jdZRZh8RGN0l8N5PO4mwjiZA==
X-Received: by 2002:a63:770f:: with SMTP id s15mr37114375pgc.137.1629814274047;
        Tue, 24 Aug 2021 07:11:14 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y12sm23658595pgk.7.2021.08.24.07.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 07:11:13 -0700 (PDT)
Date:   Tue, 24 Aug 2021 14:11:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Artem Kashkanov <artem.kashkanov@intel.com>
Subject: Re: [PATCH 2/3] KVM: x86: Register Processor Trace interrupt hook
 iff PT enabled in guest
Message-ID: <YST9+5K5Kv9J9ojY@google.com>
References: <20210823193709.55886-1-seanjc@google.com>
 <20210823193709.55886-3-seanjc@google.com>
 <87v93vi9nb.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v93vi9nb.fsf@ashishki-desk.ger.corp.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 24, 2021, Alexander Shishkin wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> > index 0e4f2b1fa9fb..b06dbbd7eeeb 100644
> > --- a/arch/x86/kvm/pmu.h
> > +++ b/arch/x86/kvm/pmu.h
> > @@ -41,6 +41,7 @@ struct kvm_pmu_ops {
> >  	void (*reset)(struct kvm_vcpu *vcpu);
> >  	void (*deliver_pmi)(struct kvm_vcpu *vcpu);
> >  	void (*cleanup)(struct kvm_vcpu *vcpu);
> > +	void (*handle_intel_pt_intr)(void);
> 
> What's this one for?

Doh, the remnants of one of my explorations trying to figure out the least gross
way to conditionally register the handling.  I'll get it removed.

Good eyeballs, thanks!
