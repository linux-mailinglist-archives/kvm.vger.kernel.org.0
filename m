Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 551063934AC
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 19:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236914AbhE0RYJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 13:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236757AbhE0RYE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 May 2021 13:24:04 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B577C061574
        for <kvm@vger.kernel.org>; Thu, 27 May 2021 10:22:30 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id l70so456838pga.1
        for <kvm@vger.kernel.org>; Thu, 27 May 2021 10:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+RzIY58jABtEHA+lH8aprc5omocLM+qqwqn4cJd2lgw=;
        b=MVCNdBs+rCz8MZ8O3bdDcK73UDCycWcsVCMv/8tEmzPhorqXH80SuH/sb/Zrj88SMw
         UypGHQ3vFE6seguYuUmKD40/d7mM8y2T9ZGnuw3AwgQh1lFNJehbjNXjHGbK/aSZwQPL
         CwQFE7w3hAYjyExtYdtAez998WAND/NuAoyd00IpEQEFfXnDcbWbPrQ2aGca2i+x1j0n
         2OVqbcWGoA8jERU2xh7ylLWmyOzDoMETb3iwN3Q2ZGN8zekYPddYZ52AOlcgGNx2uuZM
         +W9ibA0pUZ0YkBuQijqGTrrysgS/nqDikVUmeY9WYIacRHtr48qN+UXvslycYwgMEkZZ
         umvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+RzIY58jABtEHA+lH8aprc5omocLM+qqwqn4cJd2lgw=;
        b=XZJK1xz8K/YlbGawBKh8k34HfFnr8+Ac9Yx8py65Vmbpnk1VDZVmtsDY4QMp648MoX
         bY/7RLA95a0I1ABcO9Qk2AOJ5EcmHLVlTfkWgiipmSWps1cQKmKbSshOjlv0LyGbHwuL
         +2KrI5PV0FD2LBFr4a7QC8yL573Ba3KI6+G6bIn7A4EFX/z9sr2edwzA2h3fKumlUZ/0
         rC4hxFOfcTFNAC3Rd2LXmamUjMlQIMV7VZ8YRNRyJfHnJR8bMkyh64yeHGiF+gfTdSaz
         7o1V4RPUWpimyOm4BXGUSMh5nfSyKGM7UF6g0UwwjC570cgB6fbvrgTHGYil45ljpoPf
         Yq4Q==
X-Gm-Message-State: AOAM531HzpTe56TKhkKsSJVrhIgSivVJa/hIZ9I1LBXnNERYibj6gzps
        gi6/84IBwb+Baa/3s2dimgb6Mw==
X-Google-Smtp-Source: ABdhPJxWt+t/DpJOnQug1cYP7cIT1Vdb3VAdQ2y22nKG0B57J/KpfYmB6Kwa4G3SRAUppFnmVVOJXA==
X-Received: by 2002:a62:6491:0:b029:28e:8c90:6b16 with SMTP id y139-20020a6264910000b029028e8c906b16mr4583655pfb.24.1622136149533;
        Thu, 27 May 2021 10:22:29 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id i2sm2390109pjj.25.2021.05.27.10.22.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 10:22:28 -0700 (PDT)
Date:   Thu, 27 May 2021 17:22:24 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Peter Gonda <pgonda@google.com>, kvm list <kvm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH] KVM: SVM: Do not terminate SEV-ES guests on GHCB
 validation failure
Message-ID: <YK/VUPi+zFO6wFXB@google.com>
References: <f8811b3768c4306af7fb2732b6b3755489832c55.1621020158.git.thomas.lendacky@amd.com>
 <CAMkAt6qJqTvM0PX+ja3rLP3toY-Rr4pSUbiFKL1GwzYZPG6f8g@mail.gmail.com>
 <324d9228-03e9-0fe2-59c0-5e41e449211b@amd.com>
 <YKa1jduPK9JyjWbx@google.com>
 <468cee77-aa0a-cf4a-39cf-71b5bfb3575e@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <468cee77-aa0a-cf4a-39cf-71b5bfb3575e@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 20, 2021, Tom Lendacky wrote:
> On 5/20/21 2:16 PM, Sean Christopherson wrote:
> > On Mon, May 17, 2021, Tom Lendacky wrote:
> >> On 5/14/21 6:06 PM, Peter Gonda wrote:
> >>> On Fri, May 14, 2021 at 1:22 PM Tom Lendacky <thomas.lendacky@amd.com> wrote:
> >>>>
> >>>> Currently, an SEV-ES guest is terminated if the validation of the VMGEXIT
> >>>> exit code and parameters fail. Since the VMGEXIT instruction can be issued
> >>>> from userspace, even though userspace (likely) can't update the GHCB,
> >>>> don't allow userspace to be able to kill the guest.
> >>>>
> >>>> Return a #GP request through the GHCB when validation fails, rather than
> >>>> terminating the guest.
> >>>
> >>> Is this a gap in the spec? I don't see anything that details what
> >>> should happen if the correct fields for NAE are not set in the first
> >>> couple paragraphs of section 4 'GHCB Protocol'.
> >>
> >> No, I don't think the spec needs to spell out everything like this. The
> >> hypervisor is free to determine its course of action in this case.
> > 
> > The hypervisor can decide whether to inject/return an error or kill the guest,
> > but what errors can be returned and how they're returned absolutely needs to be
> > ABI between guest and host, and to make the ABI vendor agnostic the GHCB spec
> > is the logical place to define said ABI.
> 
> For now, that is all we have for versions 1 and 2 of the spec. We can
> certainly extend it in future versions if that is desired.
> 
> I would suggest starting a thread on what we would like to see in the next
> version of the GHCB spec on the amd-sev-snp mailing list:
> 
> 	amd-sev-snp@lists.suse.com

Will do, but in the meantime, I don't think we should merge a fix of any kind
until there is consensus on what the VMM behavior will be.  IMO, fixing this in
upstream is not urgent; I highly doubt anyone is deploying SEV-ES in production
using a bleeding edge KVM.

> > For example, "injecting" #GP if the guest botched the GHCB on #VMGEXIT(CPUID) is
> > completely nonsensical.  As is, a Linux guest appears to blindly forward the #GP,
> > which means if something does go awry KVM has just made debugging the guest that
> > much harder, e.g. imagine the confusion that will ensue if the end result is a
> > SIGBUS to userspace on CPUID.
> 
> I see the point you're making, but I would also say that we probably
> wouldn't even boot successfully if the kernel can't handle, e.g., a CPUID
> #VC properly. 

I agree that GHCB bugs in the guest will be fatal, but that doesn't give the VMM
carte blanche to do whatever it wants given bad input.

> A lot of what could go wrong with required inputs, not the values, but the
> required state being communicated, should have already been ironed out during
> development of whichever OS is providing the SEV-ES support.

Yes, but better  on the kernel never having a regression is a losing proposition.
And it doesn't even necessarily require a regression, e.g. an existing memory
corruption bug elsewhere in the guest kernel (that escaped qualification) could
corrupt the GHCB.  If the GHCB is corrupted at runtime, the guest needs
well-defined semantics from the VMM so that the guest at least has a chance of
sanely handling the error.  Handling in this case would mean an oops/panic, but
that's far, far better than a random pseudo-#GP that might not even be immediately
logged as a failure.
