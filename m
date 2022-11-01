Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F96D614DF8
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 16:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbiKAPMg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 11:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231512AbiKAPML (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 11:12:11 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB09E1DDC5
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 08:07:11 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id f9so13674425pgj.2
        for <kvm@vger.kernel.org>; Tue, 01 Nov 2022 08:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vPXQ+b7KQacCHGpWN4th0/JOQHwmd1KCWRlOofk2ZBg=;
        b=nidC8itiFTkv2WQFfPes983ZsXwKh2ubCWvzc9Ae8gh4PnE55375rF91g4Mako2lLY
         vQOS0AyaUj5JX8z3cSPPa6YCyQTtAxx0NhzCrYKJsJizqCNRm3/cQB2rrs2S4OTFZ166
         DhbLJdD3vNFEyxgR9FfNtee3oIq5iSQPNjuwT7JmHtsZ4b7jIob/8szyTQ5Ixdo3v5wY
         A9UkbgrNFYVs/FXNXWJlps3WzfJqtPPlhrk/r3S+cWJ92kuQLrWwcQhx1NEj7DHA5D7P
         D9bAFWswFXCzFg9imQclW7MlpAd8ZGF3eFssevW3qqX/bXb61sZ6ZqgibBdHigKsBa4E
         qgxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vPXQ+b7KQacCHGpWN4th0/JOQHwmd1KCWRlOofk2ZBg=;
        b=eyuOy0g/bIuZjLdkVBhGJoK7+Ie8szRAiT3GYqq+ZZZD5nxOF43s8RJPDh5CKvNJ1j
         dclJCqCmhFSDOLiGp34z10juQE5wgnEDpK1nDmwqcYA1S+MNjBKLyf6I9D3CtsBb9ZDP
         Vwe94k+N3kOCZbPBvDb86R8dpb4+yrKRqB9Zu4zsbmuZ9X5P7DSR8SkHDq9mGONKvaNJ
         mBbfFcsNeKn13iPYlPiYVZBdNRkYG1yibt9xU5c4mrPZYihR7I+o+m/llmsvv1/O66/K
         vFoXgLVlleh/9qdHd5yCJ1+TcOg4pBRfrIny4O6B+u5bTyG0W/4+3C4uwooV43tPPPy9
         qpbw==
X-Gm-Message-State: ACrzQf19ntQ/bKXr2G2CrWVbULF561kZZVOnORoQYbI4pZrwZmIhJvFT
        j4JdPHFlgBQGhQlfjLXAM4K49g==
X-Google-Smtp-Source: AMsMyM40O+r9FX0X3B+5IzE6Ad4RNdBrgK+TgYG4QyS1grtHpON24DREpm6itWdVV7ZUFbd8H21InQ==
X-Received: by 2002:a63:4204:0:b0:442:ee11:4894 with SMTP id p4-20020a634204000000b00442ee114894mr150254pga.595.1667315231223;
        Tue, 01 Nov 2022 08:07:11 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u1-20020a17090a3fc100b0020dc318a43esm6112872pjm.25.2022.11.01.08.07.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 08:07:10 -0700 (PDT)
Date:   Tue, 1 Nov 2022 15:07:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jiaxi Chen <jiaxi.chen@linux.intel.com>
Cc:     Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com,
        ndesaulniers@google.com, alexandre.belloni@bootlin.com,
        peterz@infradead.org, jpoimboe@kernel.org,
        chang.seok.bae@intel.com, pawan.kumar.gupta@linux.intel.com,
        babu.moger@amd.com, jmattson@google.com, sandipan.das@amd.com,
        tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        fenghua.yu@intel.com, keescook@chromium.org,
        jane.malalane@citrix.com, nathan@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] x86: KVM: Enable CMPccXADD CPUID and expose it to
 guest
Message-ID: <Y2E2G9Q2wKJnc8dx@google.com>
References: <20221019084734.3590760-1-jiaxi.chen@linux.intel.com>
 <20221019084734.3590760-2-jiaxi.chen@linux.intel.com>
 <Y1AUhlwWjIkKfZHA@google.com>
 <cce514da-32b4-3b84-cfad-67a05705bc9f@linux.intel.com>
 <Y1lrGgyIcgweVGup@zn.tnic>
 <ad24c33d-8f07-4d73-136f-ad16bb2b1981@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad24c33d-8f07-4d73-136f-ad16bb2b1981@linux.intel.com>
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

On Tue, Nov 01, 2022, Jiaxi Chen wrote:
> 
> 
> On 10/27/2022 1:15 AM, Borislav Petkov wrote:
> > On Wed, Oct 26, 2022 at 11:40:31AM +0800, Jiaxi Chen wrote:
> >>> What do you think about moving CPUID_7_1_EAX to be a KVM-only leaf too?  AFAICT,
> >>> KVM passthrough is the only reason the existing features are defined.
> > 
> > Yap, looking at the patches which added those 2 feature flags upstream,
> > they don't look like some particular use was the goal but rather to
> > expose it to guests. Besides, AVX512 apps do their own CPUID detection.
> > 
> >> Since CPUID_7_1_EAX has only 5 features now, it is a big waste,       
> >> should we move it to KVM-only leaf as Sean suggested. What's your     
> >> opinion about this?                                                   
> > 
> > Yes, pls do.
> > 
> > And when you do, make sure to undo what
> > 
> >   b302e4b176d0 ("x86/cpufeatures: Enumerate the new AVX512 BFLOAT16 instructions")
> > 
> > added.
> > 
> > Thx.
> > 
> Hi Sean and Boris,
> 
> Just realized moving CPUID_7_1_EAX to kvm-only leaf will not save space
> in enum cpuid_leafs[]. CPUID_7_1_EAX is indeed removed, but someone
> else, ie. CPUID_DUMMY needs to take the place, otherwise the cpuid_leafs
> array would be deranged. Therefore, the length of x86 cpuid leaves is
> not decreased.

The order of "enum cpuid_leafs" is completely arbitrary.

After replacing CPUID_7_1_EAX with CPUID_DUMMY, replace CPUID_DUMMY with the last
leaf, which is currently CPUID_8000_001F_EAX, and update the #defines accordingly.
Alternatively, Boris may prefer skipping the intermediate CPUID_DUMMY step and
just replace CPUID_7_1_EAX with CPUID_8000_001F_EAX straightaway.
