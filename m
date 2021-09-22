Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56F21414FA3
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 20:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237006AbhIVSPU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 14:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236943AbhIVSPQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 14:15:16 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76229C061574
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 11:13:45 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id h3so3580212pgb.7
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 11:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rEfGQnKC2Rk4coZrfgQQApFk3zR3RiS6MSMlv3roo5E=;
        b=sdhaf5RnXeZyrzFn+kWJ+zD2MERo/LcZvz+lnC05HI6sgGdFeggPNpkiEuFfzG93Ks
         dpvXmguIGDD+QE2+Rq/NLT54k5UI0awKo7Ccrhq7GeIQV8Gpyw2UNKc34pQnfqSpzAOX
         TtSlCKkmNj0xRcvWKRXpptD6NGcYfbjvlbee/xR2rTXL8jtg/Kq5dOlDgi1N8GfANvuf
         m68Spmgs/aENcmyXomWhmrQRJfimEfPD/e1PhyMJbmKn2FTgOJf7336FiX14i9sAI5xy
         8QHgqiS+HlHlEc9hP2Ir1WNeUsmgea0MGXcOhPeVLm7SQWq0rjKJd67WBVtPvjhHmGt9
         IBeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rEfGQnKC2Rk4coZrfgQQApFk3zR3RiS6MSMlv3roo5E=;
        b=h2Hkl/DnLQiswOvvGkgDCi1ikT24Wt8F6N3bQDDlku4i+nnzwYYsQqlpMKM+RDJMy+
         WX3S+rWKSIrBt9QG0n4fxyEhXhMDBgt6sWWHtG23e18GidYBkNx1Jw5q86h1q02Zw08e
         QvZ1WvgNfnPKV0uR29mCEZMwIXowle4s56K/QOFQjWZNjuaCydczgWXnytJ4xpGdmUUc
         sGGc/x6QPiHGgD0K4+5KxenS0L05bfK4qE+RROK05j9KHrk7nVZdV7CveK18XhDmEaSi
         cPi/il1Rwm54Hb4Lr0U/LoHjisnrcsMkruEIQN2j6ZpCdT2syznTIT+Qo62qdYW/ykG3
         ZL/Q==
X-Gm-Message-State: AOAM532GNovb05FpoKF1eDQWCyAF4OEABrSQUu/buHAX/LZv6+b4OJmB
        VjIv92TwcX7Ypum10o6hSyUYGQ==
X-Google-Smtp-Source: ABdhPJzCQmCaSOsJPoQjkK7m7fOPC+A+61MDYsLb7ksgDBveJSxAp8dnM8KJ5912bQZPJ8qftXiMRg==
X-Received: by 2002:aa7:9f8a:0:b0:43c:39be:23fb with SMTP id z10-20020aa79f8a000000b0043c39be23fbmr172220pfr.57.1632334424775;
        Wed, 22 Sep 2021 11:13:44 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id ga24sm6331417pjb.41.2021.09.22.11.13.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 11:13:44 -0700 (PDT)
Date:   Wed, 22 Sep 2021 18:13:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Jing Zhang <jingzhangos@google.com>,
        KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        Will Deacon <will@kernel.org>,
        David Matlack <dmatlack@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>,
        Ben Gardon <bgardon@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Venkatesh Srinivas <venkateshs@google.com>
Subject: Re: [PATCH v1 3/3] KVM: arm64: Add histogram stats for handling time
 of arch specific exit reasons
Message-ID: <YUtyVEpMBityBBNl@google.com>
References: <20210922010851.2312845-1-jingzhangos@google.com>
 <20210922010851.2312845-3-jingzhangos@google.com>
 <87czp0voqg.wl-maz@kernel.org>
 <d16ecbd2-2bc9-2691-a21d-aef4e6f007b9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d16ecbd2-2bc9-2691-a21d-aef4e6f007b9@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Google folks

On Wed, Sep 22, 2021, Paolo Bonzini wrote:
> On 22/09/21 13:22, Marc Zyngier wrote:
> > Frankly, this is a job for BPF and the tracing subsystem, not for some
> > hardcoded syndrome accounting. It would allow to extract meaningful
> > information, prevent bloat, and crucially make it optional. Even empty
> > trace points like the ones used in the scheduler would be infinitely
> > better than this (load your own module that hooks into these trace
> > points, expose the data you want, any way you want).
> 
> I agree.  I had left out for later the similar series you had for x86, but I
> felt the same as Marc; even just counting the number of occurrences of each
> exit reason is a nontrivial amount of memory to spend on each vCPU.

That depends on the use case, environment, etc...  E.g. if the VM is assigned a
_minimum_ of 4gb per vCPU, then burning even tens of kilobytes of memory per vCPU
is trivial, or at least completely acceptable.

I do 100% agree this should be optional, be it through an ioctl(), module/kernel
param, Kconfig, whatever.  The changelogs are also sorely lacking the motivation
for having dedicated stats; we'll do our best to remedy that for future work.

Stepping back a bit, this is one piece of the larger issue of how to modernize
KVM for hyperscale usage.  BPF and tracing are great when the debugger has root
access to the machine and can rerun the failing workload at will.  They're useless
for identifying trends across large numbers of machines, triaging failures after
the fact, debugging performance issues with workloads that the debugger doesn't
have direct access to, etc...

Logging is a similar story, e.g. using _ratelimited() printk to aid debug works
well when there are a very limited number of VMs and there is a human that can
react to arbitrary kernel messages, but it's basically useless when there are 10s
or 100s of VMs and taking action on a kernel message requires a prior knowledge
of the message.

I'm certainly not expecting other people to solve our challenges, and I fully
appreciate that there are many KVM users that don't care at all about scalability,
but I'm hoping we can get the community at large, and especially maintainers and
reviewers, to also consider at-scale use cases when designing, implementing,
reviewing, etc...
