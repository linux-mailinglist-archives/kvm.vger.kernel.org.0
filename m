Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EDCD3B200F
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 20:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbhFWSON (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 14:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhFWSOM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 14:14:12 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C27C061574
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 11:11:55 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id 14so4267520oir.11
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 11:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k7O/1D2MABRKTWEnJ4gsRDyfVcuNtzDzmQ12E1aStS8=;
        b=O2lFQDP85iiyxpQsmL3RsHJsuO2o54nS0Y+LaeWF/gpizYfeoWcc7tmzg7oR9yqb2s
         SVqEf6eJqLmPHl9bLJRA3Qzl1gC6p776tGoPb1kz+pYOtpnSTIzEaorVf+t41j3tsxi2
         dDu4WXRGgc3Vw+hkAR2DaJUvuB5kbGLP1VDpsynVMvwr/2jignw81smHX9qCBHrI+Pjw
         C38w/CwaYOGs1RBDjQ0PaqsH9Q4UocEBh4cscpNPXNM58p+1ttQ5g6Vn6VPuPUi7UJ+s
         O2g/sA1An/sWmWHcQilH4YRrqfwoSOPuNRYekg1JQMNDrdb7Oza3mVuoYOG82ZvLxE2G
         4NuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k7O/1D2MABRKTWEnJ4gsRDyfVcuNtzDzmQ12E1aStS8=;
        b=dyiKaCdmU7uXKuXoITOF6ZeAGOznrUV4WQCB8YMOiYdpvToIGmzb3BOkESHLUAviM5
         FEk4YZ3TNqRY+2x0VOf3zvSTw7kt/P8ONOWnNpNwZ+6FRQAjbUp+wZe7aS0l/BzCtL/S
         0MQGipH3xms4VEr9BblF8P6SSlj3y6qHEkSXzJ0O9yE8ktZ8k4aZYQ57cKrEVjUGAxFk
         2q4BiAjpHPb7omV8eWdnjjm+U7x2IonAhylmeaQFi88wG4VPf6mjjp5tFDEXmUHryznX
         YkRFXfQYk6N37QPplBtqmHVB8XyaCidwxs1y5jrPPGNaXmTV5S/QofZk5/ATLaNhc6d6
         xilQ==
X-Gm-Message-State: AOAM53003wLq0cFCiOHxX/nVRJ0UKXLAVOMJDLgz4qEXAZWISa89aDGi
        Uk8MvSJbsifDpkycDqWVW7d1Zs+fo+u6Qsphh1xZhg==
X-Google-Smtp-Source: ABdhPJxJCcpmCbfs9B6a7LnsucauuSHO0LXTdfFLhRhcJMlFStXC3aLC9TE5ynTw5kMX8wUvBz41Eqq5xHS39sXfi6U=
X-Received: by 2002:a54:4586:: with SMTP id z6mr4217883oib.6.1624471914212;
 Wed, 23 Jun 2021 11:11:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com> <20210622175739.3610207-8-seanjc@google.com>
 <f031b6bc-c98d-8e46-34ac-79e540674a55@redhat.com> <CALMp9eSpEJrr6mNoLcGgV8Pa2abQUkPA1uwNBMJZWexBArB3gg@mail.gmail.com>
 <6f25273e-ad80-4d99-91df-1dd0c847af39@redhat.com>
In-Reply-To: <6f25273e-ad80-4d99-91df-1dd0c847af39@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 23 Jun 2021 11:11:43 -0700
Message-ID: <CALMp9eTzJb0gnRzK_2MQyeO2kmrKJwyYYHE5eYEai+_LPg8HrQ@mail.gmail.com>
Subject: Re: [PATCH 07/54] KVM: x86: Alert userspace that KVM_SET_CPUID{,2}
 after KVM_RUN is broken
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 23, 2021 at 10:11 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 23/06/21 19:00, Jim Mattson wrote:
> > On Wed, Jun 23, 2021 at 7:16 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >>
> >> On 22/06/21 19:56, Sean Christopherson wrote:
> >>> +     /*
> >>> +      * KVM does not correctly handle changing guest CPUID after KVM_RUN, as
> >>> +      * MAXPHYADDR, GBPAGES support, AMD reserved bit behavior, etc.. aren't
> >>> +      * tracked in kvm_mmu_page_role.  As a result, KVM may miss guest page
> >>> +      * faults due to reusing SPs/SPTEs.  Alert userspace, but otherwise
> >>> +      * sweep the problem under the rug.
> >>> +      *
> >>> +      * KVM's horrific CPUID ABI makes the problem all but impossible to
> >>> +      * solve, as correctly handling multiple vCPU models (with respect to
> >>> +      * paging and physical address properties) in a single VM would require
> >>> +      * tracking all relevant CPUID information in kvm_mmu_page_role.  That
> >>> +      * is very undesirable as it would double the memory requirements for
> >>> +      * gfn_track (see struct kvm_mmu_page_role comments), and in practice
> >>> +      * no sane VMM mucks with the core vCPU model on the fly.
> >>> +      */
> >>> +     if (vcpu->arch.last_vmentry_cpu != -1)
> >>> +             pr_warn_ratelimited("KVM: KVM_SET_CPUID{,2} after KVM_RUN may cause guest instability\n");
> >>
> >> Let's make this even stronger and promise to break it in 5.16.
> >>
> >> Paolo
> >
> > Doesn't this fall squarely into kvm's philosophy of "we should let
> > userspace shoot itself in the foot wherever possible"? I thought we
> > only stepped in when host stability was an issue.
> >
> > I'm actually delighted if this is a sign that we're rethinking that
> > philosophy. I'd just like to hear someone say it.
>
> Nah, that's not the philosophy.  The philosophy is that covering all
> possible ways for userspace to shoot itself in the foot is impossible.
>
> However, here we're talking about 2 lines of code (thanks also to your
> patches that add last_vmentry_cpu for completely unrelated reasons) to
> remove a whole set of bullet/foot encounters.

What about the problems that arise when we have different CPUID tables
for different vCPUs in the same VM? Can we just replace this
hole-in-foot inducing ioctl with a KVM_VM_SET_CPUID ioctl on the VM
level that has to be called before any vCPUs are created?
