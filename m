Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65E736748EF
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 02:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbjATBkX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 20:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjATBkV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 20:40:21 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 524CC55BD
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 17:40:19 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id d3so4033305plr.10
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 17:40:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Lg0CzDuQy4V1JV2pIlemk74MHa85PjPJTHngrqfHjrE=;
        b=ImZO6fhqVqvCqs7rXFaCOuWNTnnC9RvQXYi9jvRLJEucdXDUti7JkfHu8O7Jl0o1GR
         +2I8c9hfOjkyjtdGDJYnmeqRq+CZCntKqF/JgZKW3QCMWkTkodvRvyA6NehFi/fNR3JR
         q5vS5fZwKy7YcH0ChMeMVdcGr2HFhMgWJGSw7hGGFEgmghvWJ4WYsqA5bnIfUDAJCoDP
         FwTqdndfEXhPnjjsPP00SboMIZGbc8abyDGrB7OwQri1BMYBF6e1DCtOrs+y4cyJKnkf
         g7z3MLrTGb9cTVHMZQkXmHC6qF610iMQCpr0zmjZ3iQ16ASnhWUzl5F9fg94FHRmVKaR
         DpJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lg0CzDuQy4V1JV2pIlemk74MHa85PjPJTHngrqfHjrE=;
        b=dC3qyo5x5FeAmN5REl5RcXCHGdoJ2W97tQTb80aLOeYts+imS8Pf8fqhEzzViwK+oS
         r3+pHUnlv/j+PVSLocjnB4PkhKriwXZVvRq0x/aH9po1GGHKxyCmo+w0EcX8VBdhErJS
         u0IC+f6JPn/kH2Rq6NjDm7OAKKT6cTmWuh0eIzhaDW+9GyEMoa5TmnZuTzZtegg6gkPV
         eXr9wuHYRxKtui7A42xde6Qt2054O3illDjhkGBVCmdIqgJAcnVGWs37wS9q4RUV696+
         idWJmH/gQr8gaX/cFb+RWoutRXxMuOHzfG4bPhRQr6KVqH25SbqDjNsPf/zfbfll8XL0
         YKWQ==
X-Gm-Message-State: AFqh2koXEiFgcd42jyN0laRPlE522hY4flnEiVNTqxNALWjQ75V0sFhW
        ZHY/e0vgl4bNbiRI7asxKQcrmQ==
X-Google-Smtp-Source: AMrXdXvcVM2ifx1QliZxHIX+7OmGHQVLmRwBNhn73tk9W4ClFQY0b1V9fyA2FC+YR1J/ddz+yLlbqQ==
X-Received: by 2002:a17:902:eb45:b0:189:6624:58c0 with SMTP id i5-20020a170902eb4500b00189662458c0mr10964pli.3.1674178818663;
        Thu, 19 Jan 2023 17:40:18 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 35-20020a631563000000b0044ed37dbca8sm21340893pgv.2.2023.01.19.17.40.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 17:40:18 -0800 (PST)
Date:   Fri, 20 Jan 2023 01:40:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Kim Phillips <kim.phillips@amd.com>, x86@kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/7] x86/cpu, kvm: Support AMD Automatic IBRS
Message-ID: <Y8nw/XLTpKhKbbdX@google.com>
References: <20230116230159.1511393-1-kim.phillips@amd.com>
 <Y8aMiH74WFmVM5Rk@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8aMiH74WFmVM5Rk@zn.tnic>
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

On Tue, Jan 17, 2023, Borislav Petkov wrote:
> On Mon, Jan 16, 2023 at 05:01:52PM -0600, Kim Phillips wrote:
> 
> > Kim Phillips (7):
> >   x86/cpu, kvm: Add support for cpuid leaf 80000021/EAX (FeatureExt2Eax)
> >   x86/cpu, kvm: Add the NO_NESTED_DATA_BP feature
> >   x86/cpu, kvm: Move the LFENCE_RDTSC / LFENCE always serializing
> >     feature
> >   x86/cpu, kvm: Add the Null Selector Clears Base feature
> >   x86/cpu, kvm: Add the SMM_CTL MSR not present feature
> >   x86/cpu: Support AMD Automatic IBRS
> >   x86/cpu, kvm: Propagate the AMD Automatic IBRS feature to the guest
> > 
> >  Documentation/admin-guide/hw-vuln/spectre.rst |  6 ++--
> >  .../admin-guide/kernel-parameters.txt         |  6 ++--
> >  arch/x86/include/asm/cpufeature.h             |  7 +++--
> >  arch/x86/include/asm/cpufeatures.h            | 11 +++++--
> >  arch/x86/include/asm/disabled-features.h      |  3 +-
> >  arch/x86/include/asm/msr-index.h              |  2 ++
> >  arch/x86/include/asm/required-features.h      |  3 +-
> >  arch/x86/kernel/cpu/amd.c                     |  2 +-
> >  arch/x86/kernel/cpu/bugs.c                    | 20 ++++++++-----
> >  arch/x86/kernel/cpu/common.c                  | 22 +++++++++-----
> >  arch/x86/kvm/cpuid.c                          | 30 +++++++------------
> >  arch/x86/kvm/reverse_cpuid.h                  |  1 +
> >  arch/x86/kvm/svm/svm.c                        |  3 ++
> >  arch/x86/kvm/x86.c                            |  3 ++
> >  14 files changed, 71 insertions(+), 48 deletions(-)
> 
> KVM folks,
> 
> I'm going to route this through the tip tree, along with the KVM bits.
> 
> Holler if we should do something else to avoid any potential conflicts.

Sorry, completely missed this.

There will be a minor conflict in KVM's reverse_cpuid, but it's trivial to resolve.
I don't anticipate any other conflicts, so taking this through tip does seem like
the best option.

If possible, a new version to fix the bisection issues in patches 2 and 3 would
be nice, but again it's not a big deal.  The breakage is very, very minor.
