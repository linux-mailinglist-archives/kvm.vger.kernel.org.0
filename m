Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 884AB406633
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 05:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbhIJDmj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 23:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbhIJDmi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 23:42:38 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81CF0C061575
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 20:41:28 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id bi4so1095389oib.9
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 20:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AcDaWUAinO2fEsf4ZPvLFB5Mx25ltgwZ7j4hlM6IIoM=;
        b=G59xvSv/rp+s9VhZYcfvC7HQvDS0+1Y/31lt72rGg4SuU/3q7Bur6+CZT0oX9BCHHd
         pf25q9r0pJpU7IZYtD45LxPTuZ7lt/+7kub6CoSg9zklHVO14+S7uSpfFltQBvw4eLda
         8lFybnYaePz40XR9CFc+EAGr7DMGGnekQ+7B4JJVAbtpRqVdHwwqHHxKTtPtxEa7nmOJ
         gn6q36V9etefm6vpc8MR1hhLSUSfIVf4sVgvI8kVOp4VDzhqKL0p9tvVBUxdM9Hm8oWq
         W/ZyP2CYNdmexJXmP/Mtd7hliSmyQGlSFekxvfGhpoC0l2TuD4H/jNfkIlj/yZgCQLQf
         5eOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AcDaWUAinO2fEsf4ZPvLFB5Mx25ltgwZ7j4hlM6IIoM=;
        b=NOrY+adbpK8DvOtakEJRyWU2nYJcYVYpTDp9gNTw9R96Sj8mm/+XeagHAYN9aiaCRx
         0Df4cid2OGLJOR0jEb3VCUmTkUpJFy+PmTRlbiMQSGwT1uLMRhkOdYsI8HEI41K6IZ1U
         qEW3ArbxZDTis3lmL8UZKDy66uR8o5QDchgoEih9B7R/NgDXsvQuhPmB8qn41PWsfDKp
         Dh3TezoE9FnxETi8J2a7kc+wfaiMXbU6OtJgNR2vzYl4TK0P1iADQR+xhOQyKsHzc8IA
         WjdVH83dSZD43a84AjaEUHSSSsa5jCyLqQAwPOn/FTYgqtIj4JVym3i12WHgb1n6yBrC
         eFJg==
X-Gm-Message-State: AOAM5306Imfi9TEx5CM8bcNQGW8KcC6EwH9rKjKI3+jf+AtofIb9OJp8
        Jv9oiu+MoTq3J2FfXjOFznCWt3AHsvtX55F9MQ4QBQ==
X-Google-Smtp-Source: ABdhPJxvqKgvT0iHOJw9pusSa94n3g4TIFRcc5YNy3WemyPlpTzR+73ed/PuZ8xeXXe2eHPgkUHuLRU2VwFFv/+rplk=
X-Received: by 2002:a05:6808:2026:: with SMTP id q38mr2590770oiw.15.1631245287533;
 Thu, 09 Sep 2021 20:41:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210902181751.252227-1-pgonda@google.com> <20210902181751.252227-2-pgonda@google.com>
 <YTqirwnu0rOcfDCq@google.com> <CAA03e5Ek=puWCXc+cTi-XNe02RXJLY7Y6=cq1g-AyxEan_RG2A@mail.gmail.com>
 <YTq3cRq5tYbopgSd@google.com>
In-Reply-To: <YTq3cRq5tYbopgSd@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Thu, 9 Sep 2021 20:41:16 -0700
Message-ID: <CAA03e5EeBf254ENNnky41W3J2f0v2Laiq4QyeF6pOdGPOCn5Xw@mail.gmail.com>
Subject: Re: [PATCH 1/3 V7] KVM, SEV: Add support for SEV intra host migration
To:     Sean Christopherson <seanjc@google.com>
Cc:     Peter Gonda <pgonda@google.com>, kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 9, 2021 at 6:40 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Sep 09, 2021, Marc Orr wrote:
> > > > +int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
> > > > +{
> > > > +     struct kvm_sev_info *dst_sev = &to_kvm_svm(kvm)->sev_info;
> > > > +     struct file *source_kvm_file;
> > > > +     struct kvm *source_kvm;
> > > > +     int ret;
> > > > +
> > > > +     ret = svm_sev_lock_for_migration(kvm);
> > > > +     if (ret)
> > > > +             return ret;
> > > > +
> > > > +     if (!sev_guest(kvm) || sev_es_guest(kvm)) {
> > > > +             ret = -EINVAL;
> > > > +             pr_warn_ratelimited("VM must be SEV enabled to migrate to.\n");
> > >
> > > Linux generally doesn't log user errors to dmesg.  They can be helpful during
> > > development, but aren't actionable and thus are of limited use in production.
> >
> > Ha. I had suggested adding the logs when I reviewed these patches
> > (maybe before Peter posted them publicly). My rationale is that if I'm
> > looking at a crash in production, and all I have is a stack trace and
> > the error code, then I can narrow the failure down to this function,
> > but once the function starts returning the same error code in multiple
> > places now it's non-trivial for me to deduce exactly which condition
> > caused the crash. Having these logs makes it trivial. However, if this
> > is not the preferred Linux style then so be it.
>
> I don't necessarily disagree, but none of these errors conditions should so much
> as sniff production.  E.g. if userspace invokes this on a !KVM fd or on a non-SEV
> source, or before guest_state_protected=true, then userspace has bigger problems.
> Ditto if the dest isn't actual KVM VM or doesn't meet whatever SEV-enabled/disabled
> criteria we end up with.
>
> The mismatch in online_vcpus is the only one where I could reasonablly see a bug
> escaping to production, e.g. due to an orchestration layer mixup.
>
> For all of these conditions, userspace _must_ be aware of the conditions for success,
> and except for guest_state_protected=true, userspace has access to what state it
> sent into KVM, e.g. it shouldn't be difficult for userspace dump the relevant bits
> from the src and dst without any help from the kernel.
>
> If userspace really needs kernel help to differentiate what's up, I'd rather use
> more unique errors for online_cpus and guest_state_protected, e.g. -E2BIG isn't
> too big of a strecth for the online_cpus mismatch.

SGTM, thanks.
