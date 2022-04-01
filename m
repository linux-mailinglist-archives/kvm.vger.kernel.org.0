Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7B4A4EE504
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 02:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243243AbiDAAKY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 20:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbiDAAKW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 20:10:22 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560E653711
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 17:08:31 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id y10so1079805pfa.7
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 17:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IZ4FH1HFMQ9mXITlQE0Gyv9mvEtQBeiej3Vyh2T9nz8=;
        b=cFHEz6HMbQjlw8QC5Ye/EripQGXjLY/aGNbFm3K+FOm+j4YZUbng5ke4HA/SxB5jLF
         ncnIwXd/sAhuh03We3N1yX5wayto//QxBoS3cVfBFjq0X6Wiar2joHgM8qMOrtkHF0fD
         gQPkeZW4PZ3TH6pFBewGBUvfph6pIHzw0vIH+jUEUx8oFRWTMBuaUHzVFFxBxC/HOTJK
         GOaKN6Q9OfUFSNzPF8U6xzuagBsoJWlMwK5fX+Bd5uZ0UswoW3lOYK50dXQCNVjmJ4ZL
         wZ/eTQ1br8kt8s7GLFC9ZMxir7UT3yeIkzONj5PAAElV9m2hLqT5+9HmVZIqR+asGLxz
         S1JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IZ4FH1HFMQ9mXITlQE0Gyv9mvEtQBeiej3Vyh2T9nz8=;
        b=mp53f9WENli3UdYeiOpXTCRFiPORwGdqEgDn1p1uRYmhSiSoI0cwrJsnEaa4p2uYRl
         jvxAwV0OiTi5ODrtCk2gkGc6mjTWrFV+fzXMqBORB7T3514xlwYoorHZ4/A1ZqihBtrs
         IL7LTvrhqGX+7dKzKvzjEhFc6xYQPdh6kxVlBiUH+JkQ4+jLbQWA40Ece5sWRjPTDjDN
         jQT+Q2kS+Yy0sLy3tfp++M3klKahTh8xXAyd4KvaU5vnpxi04AKENnWZJWuu2FndUH5c
         26s0r882mv2FFYRGSuce1Ol0wbrif+ScYYQUTKn4vl3TW/N/LW5bhWyYZAFgyw5ASPq5
         NxhA==
X-Gm-Message-State: AOAM530e9pz2sryFS/1kd4oOslltco3g4EhLwua+QjTVqw4G3AT44CXq
        YzwDVnHg93NE8cZlt+Igj2HnAA==
X-Google-Smtp-Source: ABdhPJw3GqF7SeihbZVezx4oNqsissdHDweCnVsBd+zuEy2qgYzJntFKa1xOSuan68dUA1OXwY5yEw==
X-Received: by 2002:a63:35c3:0:b0:380:6a04:cecc with SMTP id c186-20020a6335c3000000b003806a04ceccmr12903672pga.455.1648771710570;
        Thu, 31 Mar 2022 17:08:30 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id ot17-20020a17090b3b5100b001c746bfba10sm11861087pjb.35.2022.03.31.17.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 17:08:29 -0700 (PDT)
Date:   Fri, 1 Apr 2022 00:08:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jon Grimm <Jon.Grimm@amd.com>,
        David Kaplan <David.Kaplan@amd.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Liam Merwick <liam.merwick@oracle.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] KVM: nSVM: Don't forget about L1-injected events
Message-ID: <YkZCeoDhMg1wOU1f@google.com>
References: <cover.1646944472.git.maciej.szmigiero@oracle.com>
 <a28577564a7583c32f0029f2307f63ca8869cf22.1646944472.git.maciej.szmigiero@oracle.com>
 <YkTSul0CbYi/ae0t@google.com>
 <8f9ae64a-dc64-6f46-8cd4-ffd2648a9372@maciej.szmigiero.name>
 <YkTlxCV9wmA3fTlN@google.com>
 <f4cdaf45-c869-f3bb-2ba2-3c0a4da12a6d@maciej.szmigiero.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4cdaf45-c869-f3bb-2ba2-3c0a4da12a6d@maciej.szmigiero.name>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 01, 2022, Maciej S. Szmigiero wrote:
> On 31.03.2022 01:20, Sean Christopherson wrote:
> > Re-executing the INTn is wrong, the instruction has already completed decode and
> > execution.  E.g. if there's there's a code breakpoint on the INTn, rewinding will
> > cause a spurious #DB.
> > 
> > KVM's INT3 shenanigans are bonkers, but I guess there's no better option given
> > that the APM says "Software interrupts cannot be properly injected if the processor
> > does not support the NextRIP field.".  What a mess.
> 
> Note that KVM currently always tries to re-execute the current instruction
> when asked to re-inject a #BP or a #OF, even when nrips are enabled.

Yep, and my vote is to fix that.

> Also, #BP (and #OF, too) is returned as type SVM_EXITINTINFO_TYPE_EXEPT,
> not as SVM_EXITINTINFO_TYPE_SOFT (soft interrupt), so it should be
> re-injected accordingly.

Ahhh, SVM doesn't differentiate between software exceptions and hardware exceptions.
Finally found the relevant section in the APM:

  Despite the instruction name, the events raised by the INT1 (also known as ICEBP),
  INT3 and INTO instructions (opcodes F1h, CCh and CEh) are considered exceptions for
  the purposes of EXITINTINFO, not software interrupts. Only events raised by the INTn
  instruction (opcode CDh) are considered software interrupts.

VMX has separate identifiers for software interrupts and for software exceptions,
where as SVM unconditionally treats #BP and #OF as soft:

  Injecting an exception (TYPE = 3) with vectors 3 or 4 behaves like a trap raised by
  INT3 and INTO instructions

Now I'm curious why Intel doesn't do the same...

> > Anyways, for the common nrips=true case, I strongly prefer that we properly fix
> > the non-nested case and re-inject software interrupts, which should in turn
> > naturally fix this nested case.
> 
> This would also need making the #BP or #OF current instruction
> re-execution conditional on (at least) nrips support.
> 
> I am not sure, however, whether this won't introduce any regressions.
> That's why this patch set changed the behavior here only for the
> L1 -> L2 case.
> 
> Another issue is whether a L1 hypervisor can legally inject a #VC
> into its L2 (since these are never re-injected).

I would expect to work, and it's easy to find out.  I know VMX allows injecting
non-existent exceptions, but the APM is vague as usual and says VMRUN will fail...

  If the VMM attempts to inject an event that is impossible for the guest mode

> We still need L1 -> L2 event injection detection to restore the NextRIP
> field when re-injecting an event that uses it.

You lost me on this one.  KVM L0 is only (and always!) responsible for saving the
relevant info into vmcb12, why does it need to detect where the vectoring exception
came from?

> > And for nrips=false, my vote is to either punt
> > and document it as a "KVM erratum", or straight up make nested require nrips.
> 
> A quick Internet search shows that the first CPUs with NextRIP were the
> second-generation Family 10h CPUs (Phenom II, Athlon II, etc.).
> They started being released in early 2009, so we probably don't need to
> worry about the non-nrips case too much.
> 
> For the nested case, orthodox reading of the aforementioned APM sentence
> would mean that a L1 hypervisor is not allowed either to make use of such
> event injection in the non-nrips case.

Heh, my reading of it is that it's not disallowed, it just won't work correctly,
i.e. the INTn won't be skipped.
