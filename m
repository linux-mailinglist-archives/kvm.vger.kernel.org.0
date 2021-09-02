Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC9EB3FF512
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 22:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344801AbhIBUoa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 16:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344631AbhIBUo3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 16:44:29 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF817C061757
        for <kvm@vger.kernel.org>; Thu,  2 Sep 2021 13:43:30 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id mj9-20020a17090b368900b001965618d019so2344744pjb.4
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 13:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=p+yuVJmEDLdMa0DmcBrLMHfy6agkaRopOhr58pW7MG0=;
        b=vYyJOnxuYUr+rVmUomYhYa1NvySadhA8ChpY8vSebSK40lSdX9B/LuLB6HfL/5gEtj
         Qrc9n1vHQbAmDlnOIp9PVI8Hrx4p3oycy7PtPn8FqDi1pV3ZKNMwyYWRxQHUfrgdNGYY
         AJpo3zkXoEOFiAtmQ8CwE3cY1gFoHTNWue/cGX6FBzrZwowE/2p/8uwky/JSCqg00ymP
         8TclXFuyTFK3eU0XVj33sSkTByhoPDGKmOHD7AhpNJlFayfRcfkKDEs4JjdMkFPPlaZj
         Rfx6WghZTOqPO3pVMFuL/kIeeHCzD6YTAbcV/Hivk2OPDV8/+oHHEvyyUD3t13k7AAim
         Xqzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=p+yuVJmEDLdMa0DmcBrLMHfy6agkaRopOhr58pW7MG0=;
        b=DXESxMJi2S3oNYXtK/RRTQFkahZlsDQZ+zgiOdCfl7ymfdhkYNkKNMF6zrUW8efQao
         jYgZ+EQGfk1FFdMQVY1YyorCSkFJZdMOmXklVw+MTyHa/k/7DFLUCZa4LgEs67wzDxOu
         rZ/o8Qd1dE7TQ8Hhy38dqEospC5WvFneTZUyQ9ON/oil1vFib3SwdoLPvm6hlkfEvehp
         BYedMz+ohC+QYxD59DskTBWk67q3g9U7GL/BsZVTOokd8l6VvgwNCkCfksEz877x4BI6
         TKQuyCJwBpBCDKVfPediCPlUbPQ3/M5Pp10BZRR3WHG/gwhiUqOVvJbkyc4dB3KZoCNQ
         Cx1w==
X-Gm-Message-State: AOAM532Wwk1wIN4FV8X4X23dkJOJz4VVg9Xb0gAaFQKZpfQtzuscUkiQ
        5ODhI8YofgZQNsIITw80AhRZiw==
X-Google-Smtp-Source: ABdhPJxfHCj0VhB1q85OqR3pcVQs6lqkmK+oRcNLc/XsqRlCQywRkuJy4gbI1paKAUY6+nl0NdCxnQ==
X-Received: by 2002:a17:902:650b:b0:137:3940:ec24 with SMTP id b11-20020a170902650b00b001373940ec24mr4569727plk.36.1630615410089;
        Thu, 02 Sep 2021 13:43:30 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id i14sm3024750pfd.112.2021.09.02.13.43.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 13:43:29 -0700 (PDT)
Date:   Thu, 2 Sep 2021 20:43:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH V2] KVM: X86: Move PTE present check from loop body to
 __shadow_walk_next()
Message-ID: <YTE3bRcZv2BiVxzH@google.com>
References: <YRVGY1ZK8wl9ybBH@google.com>
 <20210813031629.78670-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813031629.78670-1-jiangshanlai@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 13, 2021, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> So far, the loop bodies already ensure the PTE is present before calling
> __shadow_walk_next():  Some loop bodies simply exit with a !PRESENT
> directly and some other loop bodies, i.e. FNAME(fetch) and __direct_map()
> do not currently terminate their walks with a !PRESENT, but they get away
> with it because they install present non-leaf SPTEs in the loop itself.
> 
> But checking pte present in __shadow_walk_next() is a more prudent way of
> programing and loop bodies will not need to always check it. It allows us
> removing unneded is_shadow_present_pte() in the loop bodies.
           ^^^^^^^
	   unneeded

> 
> Terminating on !is_shadow_present_pte() is 100% the correct behavior, as
> walking past a !PRESENT SPTE would lead to attempting to read a the next
> level SPTE from a garbage iter->shadow_addr.  Even some paths that do _not_
> currently have a !is_shadow_present_pte() in the loop body is Ok since
> they will install present non-leaf SPTEs and the additinal present check
                                                   ^^^^^^^^^
						   additional
> is just an NOP.
> 
> The checking result in __shadow_walk_next() will be propagated to
> shadow_walk_okay() for being used in any for(;;) loop.
> 
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---

Nits aside,

Reviewed-by: Sean Christopherson <seanjc@google.com>
