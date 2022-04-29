Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 380E75155A1
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 22:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380761AbiD2UdE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 16:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380843AbiD2Uc4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 16:32:56 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54020D76E8
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 13:29:35 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id iq10so8057885pjb.0
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 13:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=WbX1fT1P8676LYFVWwwEMd2ZHtmSK7UfBZ60pY9/zR8=;
        b=GlmreAAAsU5cuVMz+TYYpnjCf8pfVWI9KZiaEKN7VrQ8rb9z9E8423HiuTnF/cMtpv
         9hLaFaS+ZRjx9e/r8AW9M8iRNETHD3+mwfBGc4fgKhDtdAUuMdT9FetdA7Sx9LYMmzJ5
         zrCy+KxtXIE4eaf48AJKDkjaRhI0ySANhDl6yfagfYCybcL1WDrdGLYIsDXf0LaNHvF6
         m3UppbmTSVQSOSB+MhGCQtTdGA0uzbdNwXVtUfvgIX3rakktgqFOPH3rE415JsvwMDAc
         H+ZsFr5fEWHXEZ69hNXKsiCItPf+IcHdHyAYFH8hZCG4V31nT/oE+kbiYcBRstU0XO9a
         6rRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=WbX1fT1P8676LYFVWwwEMd2ZHtmSK7UfBZ60pY9/zR8=;
        b=dsBKzeQiQfV8tyZNABTZIq5YfQWeQ/ywwuQAlCw8j6IAIYtAR6PwNR2c4eoOcFqaGg
         chpidgqW0o0NEmliM20SSqwX3ibw1ZWffeD8IAYfM4KeM4fOcM7Qh/7V+x9KmfmQYYUn
         3qb2pIN3WwOouuI0b5C2i4h2TENcwu7fq3UMoVDp7ZX1D4W7D++QcebGqhtiEnOa0DOL
         Hej7mFcwrG8T8+5pHQdjD1AvanAbNkoMJQJhbh0XmoLMLRByV7TuWwkWpm20ZoQGGq8s
         RAumZBjDlIzyD0l2yJVwMATe5HW7XNcnChuLmfdmAH0MOZ/fSdCMuaoSPN4ZlCA6fiN7
         DuJQ==
X-Gm-Message-State: AOAM531fYuZoeJGeGWAr80swW10CoMDMm+w1Cq5/ZSdGVa/A19wO31hT
        7+ZNkYSHSwgYLU1FXFM0EBIbBQ==
X-Google-Smtp-Source: ABdhPJxd50fZiQm16sYqW7TreYMIUDuc48GCGB75aI9JPVG/bmt8ro6PEuts+QQ/13pI3Rnk9xEuqA==
X-Received: by 2002:a17:902:b208:b0:14f:14e8:1e49 with SMTP id t8-20020a170902b20800b0014f14e81e49mr824906plr.35.1651264174676;
        Fri, 29 Apr 2022 13:29:34 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h10-20020a170902f70a00b0015e8d4eb287sm16870plo.209.2022.04.29.13.29.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 13:29:34 -0700 (PDT)
Date:   Fri, 29 Apr 2022 20:29:30 +0000
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
Message-ID: <YmxKqpWFvdUv+GwJ@google.com>
References: <20220422162103.32736-1-jon@nutanix.com>
 <YmwZYEGtJn3qs0j4@zn.tnic>
 <645E4ED5-F6EE-4F8F-A990-81F19ED82BFA@nutanix.com>
 <Ymw9UZDpXym2vXJs@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Ymw9UZDpXym2vXJs@zn.tnic>
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

On Fri, Apr 29, 2022, Borislav Petkov wrote:
> On Fri, Apr 29, 2022 at 05:31:16PM +0000, Jon Kohler wrote:
> > Selftests IIUC, but there may be other VMMs that do funny stuff. Said
> > another way, I don’t think we actively restrict user space from doing
> > this as far as I know.
> 
> "selftests", "there may be"?!
> 
> This doesn't sound like a real-life use case to me and we don't do
> changes just because. Sorry.
> 
> > The paranoid aspect here is KVM is issuing an *additional* IBPB on
> > top of what already happens in switch_mm(). 
> 
> Yeah, I know how that works.
> 
> > IMHO KVM side IBPB for most use cases isn’t really necessarily but 
> > the general concept is that you want to protect vCPU from guest A
> > from guest B, so you issue a prediction barrier on vCPU switch.
> > 
> > *however* that protection already happens in switch_mm(), because
> > guest A and B are likely to use different mm_struct, so the only point
> > of having this support in KVM seems to be to “kill it with fire” for 
> > paranoid users who might be doing some tomfoolery that would 
> > somehow bypass switch_mm() protection (such as somehow 
> > sharing a struct).
> 
> Yeah, no, this all sounds like something highly hypothetical or there's
> a use case of which you don't want to talk about publicly.

What Jon is trying to do is eliminate IBPB that already exists in KVM.  The catch
is that, in theory, someone not-Jon could be running multiple VMs in a single
address space, e.g. VM-based containers.  So if we simply delete the IBPB, then
we could theoretically and silently break a user.  That's why there's a bunch of
hand-waving.

> Either way, from what I'm reading I'm not in the least convinced that
> this is needed.

Can you clarify what "this" is?  Does "this" mean "this patch", or does it mean
"this IBPB when switching vCPUs"?  Because if it means the latter, then I think
you're in violent agreement; the IBPB when switching vCPUs is pointless and
unnecessary.
