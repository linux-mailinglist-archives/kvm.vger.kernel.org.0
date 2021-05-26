Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0686E392147
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 22:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234732AbhEZUKu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 16:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233486AbhEZUKs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 16:10:48 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327E3C06175F
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 13:09:17 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id z24so2380155ioi.3
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 13:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vFDYuBmh7yjJdj9CItzBZCqIL81Dc5QxJ2wo0EOE5jA=;
        b=eSdmwcymhc7rdEp+teYEOB16ky0YRohcKnfTC1vyL86VHp2vg3ykTARcUlGBXFbERN
         bFAuI0leHXnFoB5GsT5DUA+5stgu/OTpXblQsuOceye4b2Cdzbt0DwcVax95Xc5YcuNZ
         7uxH9vue10owHgSPud9NNCdktGdd2w/ymV1nXIGmTdVO+rTwNYAQ8qS2obswcWA9SOlz
         sFYoo8QJ6yQrhxmHntLi0c3MxMHwTD6qnseeUkgpUw1E0wkaR/t7nDhaF16a3qZjRCQq
         qMoFfQCrFTP/UjF1KcugAZSM2D7UkAYrsmoR4GO/Iz6qjk/hOrVOqqR5dmRvYLvDLk1c
         GwAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vFDYuBmh7yjJdj9CItzBZCqIL81Dc5QxJ2wo0EOE5jA=;
        b=QuGMWAZXLANb/pOKItKDGOQb3ChYywoFdr1zIt2bkjgnXUv9ClTsky/G6PPFtVuD6X
         mGX/0rwUkh9nJPuIs2ap8nnI6pldzDrVKRQ9BTtt6/5NZU2mH4CdRloXdjANWS+Ecgkq
         a3+8H/ry5wbiOfBHVSl76Xk+hBZsNWAmPAY6/sm9/+yTOprcZohQD9tLBzlHs/309iDV
         vCgiFz4VGYnKbBdeBOblVuz1EC3xCGFT62gW6FomatHVCj6tW2xIm9IVn5sOPC/yrm/C
         gFF72KzvC/skJ2JZw7soqmVSG7swm16B8N1x5gDP4bZnbFBjaXLbvDIu+Uohv4HQQUad
         6MGg==
X-Gm-Message-State: AOAM5324PtO6BFEHxgJ3L5W0UuqTsdNd47S45ML+ZarQ6bbTqV8sykWy
        64V3MVp4qJnJrwOAM2nS5PN7MtwL3x6dwQF3lw6BLg==
X-Google-Smtp-Source: ABdhPJxKrCQ/dX9bWJ+BgPNFhovSjFU1bGvGRRjO7GrW6LMZLB4Zicb8G+rTOo4MGC/QtfnXpk780gwfFH3QfBlM5i4=
X-Received: by 2002:a05:6638:124b:: with SMTP id o11mr4875459jas.4.1622059755162;
 Wed, 26 May 2021 13:09:15 -0700 (PDT)
MIME-Version: 1.0
References: <CANgfPd_Pq2MkRUZiJynh7zkNuKE5oFGRjKeCjmgYP4vwvfMc1g@mail.gmail.com>
 <35fe7a86-d808-00e9-a6aa-e77b731bd4bf@redhat.com> <2fd417c59f40bd10a3446f9ed4be434e17e9a64f.camel@redhat.com>
 <YK5s5SUQh69a19/F@google.com> <927cbe06-7183-1153-95ea-f97eb4ff12f6@redhat.com>
In-Reply-To: <927cbe06-7183-1153-95ea-f97eb4ff12f6@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 26 May 2021 13:09:03 -0700
Message-ID: <CANgfPd-wcyP_nNNSuXMcZ0S+fmkcOEpQaPTS_5EUmDsEVguSCw@mail.gmail.com>
Subject: Re: Writable module parameters in KVM
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Junaid Shahid <junaids@google.com>,
        Peter Xu <peterx@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 26, 2021 at 9:30 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 26/05/21 17:44, Sean Christopherson wrote:
> >> Sure, making them writable is okay.
> >
> > making a param writable (new or existing) must come with strong
> > justification for taking on the extra complexity.
>
> I agree.  It's the same for every change, and it's the reason why most
> parameters are read-only: no justification for the extra complexity.
> But if somebody has a usecase, it can be considered.
>
> > Making 'npt' writable is probably feasible ('ept' would be beyond messy), but I
> > strongly prefer to keep it read-only.  The direct impacts on the MMU and SVM
> > aren't too bad, but NPT is required for SEV and VLS, affects kvm_cpu_caps, etc...
> > And, no offense to win98, there's isn't a strong use case because outside of
> > personal usage, the host admin/VMM doesn't know that the guest will be running a
> > broken kernel.
>
> Making 'npt' writable would be beyond messy too; allowing select VMs to
> disable EPT/NPT might be simpler, but not that much.  I can't say
> offhand if the code would be ugly or not.

Thanks for the guidance all. We'll probably send out more writable
module params in the future in that case, and will add a Documentation
file whenever we send out the first one.

I don't know if there's a great way to formally encode this
distinction, but I see two major classes of writable params in terms
of complexity:
1. parameters that are captured on VM creation and follow the life of
the VM e.g. the TDP MMU
2. parameters which have an effect on all VMs on the system when
changed e.g. internally we have sysctls to change NX reclaim
parameters

I think class 1 is substantially easier to reason about from a code
perspective, but might be more confusing to userspace, as the current
value of the parameter has no bearing on the value captured by the VM.
Class 2 will probably be more complex to implement, require
synchronization, and need a better justification.

>
> Paolo
>
