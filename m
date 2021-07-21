Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9E83D1794
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 22:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhGUT3D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 15:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240343AbhGUT3B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jul 2021 15:29:01 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F18C3C061757
        for <kvm@vger.kernel.org>; Wed, 21 Jul 2021 13:09:37 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id nt18-20020a17090b2492b02901765d605e14so1008432pjb.5
        for <kvm@vger.kernel.org>; Wed, 21 Jul 2021 13:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oM+Zz2MkzME3H9DquvEm8RUpKo7Whxr3cjfyw8H5FJw=;
        b=Fa72YtYX6wm5mklDeZx/CmpLqOe3xyeUmm/EmFn8RGnRKSJuzaIaj9B6/Mdzu1Qjvj
         hXa3UcbjV+KFv7zwlPe5MMOM5CAgcd5uZlc08MGDdy61oyuX9CquyW7fE51bHCbmhhcl
         +TMdq4XOai+h1J7XOx11PZhXcVD20wfIuHS5TmAgT7922Lygki/0z9WrZA8yJHEIa2hU
         O3QmMPtucbUDrv2j34ARsToLa+7kk1nxMsHC11G2mo4irGjSwikwhs53e+cEO+i12chK
         UwDlSXk/KbPZMcfqIg74AQUx2jBlmrj176ToSjnFupuIGeKwJJI3MFc/EDCiOYW4Hjdv
         4H7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oM+Zz2MkzME3H9DquvEm8RUpKo7Whxr3cjfyw8H5FJw=;
        b=odnr9C8preaMI3YBM9aTes3qujuA7j9esTWlf3vVyOhFYQQnpYkd4eCGftveq3M+pq
         EXs8CHus2rwuksdxPiozqfBAjufjFi9+xNmFhRD7WCRLVqja6jKQRn093mT8aX8anYpk
         /doikeR/xAOIibBU3WwjGWIiI6V5Qel+Cej+H0mofAQxwZ8N1AdbK0lj3ly7vRI1Ofbr
         5snvD/Swws2c0rQOA2WeSmQy2OwMHMaKeutKIT5hAKr0X5dcp9RHAej50RvQMrOGcdwd
         B1kqkIKyBFr0SgxlGN2Q4Uqm2I6NT9ZbfrgRgBMCxiNYA0sdi/zC0PH0Ad6ruu5qvMuS
         5JjA==
X-Gm-Message-State: AOAM533tcMQIoH7ggwCbLAoIDa/ebSSwtFv3q6HdD0zFe5OVhYvAoMG2
        CoPtDY0biWJXSXpl9BKnmUYKZw==
X-Google-Smtp-Source: ABdhPJxjnEPHqumuzjvhd73k5BsigM0nlU/a6rTf9GU7FzvwN5enj3EaEjeWoiW8Xxxo/nvklrujkQ==
X-Received: by 2002:a05:6a00:1786:b029:32c:c315:7348 with SMTP id s6-20020a056a001786b029032cc3157348mr38507563pfg.42.1626898177298;
        Wed, 21 Jul 2021 13:09:37 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id w16sm31310000pgi.41.2021.07.21.13.09.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 13:09:36 -0700 (PDT)
Date:   Wed, 21 Jul 2021 20:09:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Gonda <pgonda@google.com>,
        kvm list <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH] KVM: SVM: Do not terminate SEV-ES guests on GHCB
 validation failure
Message-ID: <YPh+/V2CbfVM9mXc@google.com>
References: <f8811b3768c4306af7fb2732b6b3755489832c55.1621020158.git.thomas.lendacky@amd.com>
 <CAMkAt6qJqTvM0PX+ja3rLP3toY-Rr4pSUbiFKL1GwzYZPG6f8g@mail.gmail.com>
 <324d9228-03e9-0fe2-59c0-5e41e449211b@amd.com>
 <YKa1jduPK9JyjWbx@google.com>
 <468cee77-aa0a-cf4a-39cf-71b5bfb3575e@amd.com>
 <YK/VUPi+zFO6wFXB@google.com>
 <8735s7sv8e.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8735s7sv8e.fsf@vitty.brq.redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 21, 2021, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Thu, May 20, 2021, Tom Lendacky wrote:
> >> On 5/20/21 2:16 PM, Sean Christopherson wrote:
> >> > On Mon, May 17, 2021, Tom Lendacky wrote:
> >> >> On 5/14/21 6:06 PM, Peter Gonda wrote:
> >> >>> On Fri, May 14, 2021 at 1:22 PM Tom Lendacky <thomas.lendacky@amd.com> wrote:
> >> >>>>
> >> >>>> Currently, an SEV-ES guest is terminated if the validation of the VMGEXIT
> >> >>>> exit code and parameters fail. Since the VMGEXIT instruction can be issued
> >> >>>> from userspace, even though userspace (likely) can't update the GHCB,
> >> >>>> don't allow userspace to be able to kill the guest.
> >> >>>>
> >> >>>> Return a #GP request through the GHCB when validation fails, rather than
> >> >>>> terminating the guest.
> >> >>>
> >> >>> Is this a gap in the spec? I don't see anything that details what
> >> >>> should happen if the correct fields for NAE are not set in the first
> >> >>> couple paragraphs of section 4 'GHCB Protocol'.
> >> >>
> >> >> No, I don't think the spec needs to spell out everything like this. The
> >> >> hypervisor is free to determine its course of action in this case.
> >> > 
> >> > The hypervisor can decide whether to inject/return an error or kill the guest,
> >> > but what errors can be returned and how they're returned absolutely needs to be
> >> > ABI between guest and host, and to make the ABI vendor agnostic the GHCB spec
> >> > is the logical place to define said ABI.
> >> 
> >> For now, that is all we have for versions 1 and 2 of the spec. We can
> >> certainly extend it in future versions if that is desired.
> >> 
> >> I would suggest starting a thread on what we would like to see in the next
> >> version of the GHCB spec on the amd-sev-snp mailing list:
> >> 
> >> 	amd-sev-snp@lists.suse.com
> >
> > Will do, but in the meantime, I don't think we should merge a fix of any kind
> > until there is consensus on what the VMM behavior will be.  IMO, fixing this in
> > upstream is not urgent; I highly doubt anyone is deploying SEV-ES in production
> > using a bleeding edge KVM.
> 
> Sorry for resurrecting this old thread but were there any deveopments
> here? I may have missed something but last time I've checked a single
> "rep; vmmcall" from userspace was still crashing the guest.

I don't think it went anywhere, I completely forgot about this.  I'll bump this
back to the top of my todo list, unless someone else wants the honors :-)

> The issue, however, doesn't seem to reproduce with Vmware ESXi which probably
> means they're just skipping the instruction and not even injecting #GP
> (AFAIR, I don't have an environment to re-test handy).
