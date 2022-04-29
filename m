Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C470951578D
	for <lists+kvm@lfdr.de>; Sat, 30 Apr 2022 00:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354986AbiD2WDU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 18:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244304AbiD2WDQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 18:03:16 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 362CBDC58E
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 14:59:57 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id x23so2693674pff.9
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 14:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ipQeVTmYrR7J31cQHX7IyApntWC5EPbZtm8uKJtALEY=;
        b=DgAvPjdxcMUrOzD8ptWC1c0XZR7ZHvJ5Nc4WFiRa85U+fhOqQgc2yRsltnyvAq82zB
         MaIufUM7McJ2+j7gb9byJX9iE0SsP4OU0GvSFKyuouCSRC0amigu9f0EuGktNdRuh6Zu
         lBiPXAQukG3a33+LnJMx4oC+9aBmL8eaeLo1386+/cY1oxbiYWFgfdFa8SnURnLHUMJe
         Fd3faWJ55STz4oXXabd5O4GSQZa67wwU2zWxycULZHBcnWDgnBYD9V6IxwmkPjZc2YN7
         YTRhib8EB/vvVfkBWKk3zP257kArfbVm5MJLaGkb+To6bbteyWLXUm4fp3zWCGNaQnl1
         cOog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ipQeVTmYrR7J31cQHX7IyApntWC5EPbZtm8uKJtALEY=;
        b=n8H8KVBIFcoTmt+o6b/S1S5qJ2urB8U61G2GN6yHJyeKQplvJteydwRg42KzGj3nVv
         ct0uecq5DKUQ95eAZ2xZ4fTsIBAQe8Oi/5V6gimGtQ6fevT9/udPCN0jGS4K+2t1RgYK
         lVfAKFbqRCNwDR+3K5ZW2LZonGzVNSlunyO3ZajRHXt/3Rqe5co0mC4loQC7CSLtBKpV
         qQpCXW6sSyEVzS3H1GQA65Sj2aemqOOY/Dod8vkp2JS2GfPgc76JVMglu85WrdQJwOoL
         V8tDZKq1SzFF8e8Ymkydd6UEziePRyB51amlbTOInnpJL3XdJ8ytM19exHN5wHy/pm6n
         gxXg==
X-Gm-Message-State: AOAM531RBDzhnqyRL0zAyLHC0cuyoVFCJRrmHp8+Dje2m9K7gIPMWixb
        TXGciYrYcw+HPpQBgxZJd8oBgg==
X-Google-Smtp-Source: ABdhPJwevh1jhaxMl24AY5CqZkKSgRMpzE7Lc2pGWccFn4KXxc4IIdCFMsxVOSgLKgI9K3xsxH3NUA==
X-Received: by 2002:a65:6e88:0:b0:382:3851:50c8 with SMTP id bm8-20020a656e88000000b00382385150c8mr1062915pgb.270.1651269596278;
        Fri, 29 Apr 2022 14:59:56 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x7-20020a1709028ec700b0015e8d4eb205sm79283plo.79.2022.04.29.14.59.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 14:59:55 -0700 (PDT)
Date:   Fri, 29 Apr 2022 21:59:52 +0000
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
Message-ID: <Ymxf2Jnmz5y4CHFN@google.com>
References: <20220422162103.32736-1-jon@nutanix.com>
 <YmwZYEGtJn3qs0j4@zn.tnic>
 <645E4ED5-F6EE-4F8F-A990-81F19ED82BFA@nutanix.com>
 <Ymw9UZDpXym2vXJs@zn.tnic>
 <YmxKqpWFvdUv+GwJ@google.com>
 <YmxRnwSUBIkOIjLA@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YmxRnwSUBIkOIjLA@zn.tnic>
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
> On Fri, Apr 29, 2022 at 08:29:30PM +0000, Sean Christopherson wrote:
> > That's why there's a bunch of hand-waving.
> 
> Well, I'm still not sure what this patch is trying to fix but both your
> latest replies do sound clearer...
> 
> > Can you clarify what "this" is?  Does "this" mean "this patch", or does it mean
> 
> This patch.
> 
> > "this IBPB when switching vCPUs"?  Because if it means the latter, then I think
> > you're in violent agreement; the IBPB when switching vCPUs is pointless and
> > unnecessary.
> 
> Ok, let's concentrate on the bug first - whether a second IBPB - so to
> speak - is needed. Doing some git archeology points to:
> 
>   15d45071523d ("KVM/x86: Add IBPB support")
> 
> which - and I'm surprised - goes to great lengths to explain what
> those IBPB calls in KVM protect against. From that commit message, for
> example:
> 
> "    * Mitigate attacks from guest/ring3->host/ring3.
>       These would require a IBPB during context switch in host, or after
>       VMEXIT."

Except that snippet changelog doesn't actually state what KVM does, it states what
a hypervsior _could_ do to protect the host from the guest via IBPB.

> so with my very limited virt understanding, when you vmexit, you don't
> do switch_mm(), right?

Correct, but KVM also doesn't do IBPB on VM-Exit (or VM-Entry), nor does KVM do
IBPB before exiting to userspace.  The IBPB we want to whack is issued only when
KVM is switching vCPUs.

> If so, you need to do a barrier. Regardless of conditional IBPB or not
> as you want to protect the host from a malicious guest.
> 
> In general, the whole mitigation strategies are enumerated in
> 
> Documentation/admin-guide/hw-vuln/spectre.rst
> 
> There's also a "3. VM mitigation" section.
> 
> And so on...
> 
> Bottomline is this: at the time, we went to great lengths to document
> what the attacks are and how we are protecting against them.

Except that _none_ of that documentation explains why the hell KVM does IBPB when
switching betwen vCPUs.  The only item is this snippet from the changelog:

    * Mitigate guests from being attacked by other guests.
      - This is addressed by issing IBPB when we do a guest switch.

And that's the one that I pointed out in v1 as being flawed/wrong, and how Jon
ended up with this patch.

  : But stepping back, why does KVM do its own IBPB in the first place?  The goal is
  : to prevent one vCPU from attacking the next vCPU run on the same pCPU.  But unless
  : userspace is running multiple VMs in the same process/mm_struct, switching vCPUs,
  : i.e. switching tasks, will also switch mm_structs and thus do IPBP via cond_mitigation.
  :
  : If userspace runs multiple VMs in the same process, enables cond_ipbp, _and_ sets
  : TIF_SPEC_IB, then it's being stupid and isn't getting full protection in any case,
  : e.g. if userspace is handling an exit-to-userspace condition for two vCPUs from
  : different VMs, then the kernel could switch between those two vCPUs' tasks without
  : bouncing through KVM and thus without doing KVM's IBPB.
  :
  : I can kinda see doing this for always_ibpb, e.g. if userspace is unaware of spectre
  : and is naively running multiple VMs in the same process.
  :
  : What am I missing?
