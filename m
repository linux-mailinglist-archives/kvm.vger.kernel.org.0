Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78DC923F42A
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 23:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbgHGVRE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Aug 2020 17:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgHGVRD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Aug 2020 17:17:03 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54CD7C061756
        for <kvm@vger.kernel.org>; Fri,  7 Aug 2020 14:17:03 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id v13so3138928oiv.13
        for <kvm@vger.kernel.org>; Fri, 07 Aug 2020 14:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PKTArVgsPnnr+J9JiE3Av6UPFg/Rwlqj/o6TofHqUEY=;
        b=wQY6H2HojUNcFH4L0QCxsCO3jjOW1FHacSDn3NbgXkTi7Ue5j+dISk+dfGNnOMgDNJ
         Fqm6klZ9iapX/WpTJzkwEXI7BMlQhXMpRdwKiNH9ngfhlfpAT2GJ4bW+nE9Vn6QQVgC1
         IRFaFL9JnPiK8B9bTzdFC6waHbqbXxGma83jXlHK3r8cOGNKhi/37M6w9nXBUmvZB7Au
         lC13e5QDk0Wi+/YwU/Za2RLlMR3G4ABCm0c/QnBXg8CHY0VPw0O/itjnteuSEvMPOXye
         0/NwLyMyN7/1uHyyI1XpyrII9mFVG4JFi5H5FmMysxDHdUZtmev0yRwu1jasc8CztdgN
         Gh9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PKTArVgsPnnr+J9JiE3Av6UPFg/Rwlqj/o6TofHqUEY=;
        b=QYudoP2ExTTXIqLtIjt6eB9OqXsEsTjV/orkVMjI0hU9GiuLIAcwMGWiRqlnUOL6RE
         ReskCs7wQw7hTBewhjJYQ6IVUXOTLyf8yXsag2y0kFruehdyOy8xtDhk3sV4ithYIjb/
         tQEiVmdIyFjWUCYbGxeBkHor8M7yih7nwkMh8Ft9/9mvGBdBdiCFj3Chpx/obZpt6PhD
         xIpesV3vAf9+A+tGKBSZHjXVsEfvgU0cosYNwfyegidrFfSSGgKdkjwBvPnzNStZivIf
         LbEuW8J+fN5YWpXKOdvb58KIhBmf7KHS8H9u38b0RJaoL211rwcAHyaxBcMie370/T2l
         2L3w==
X-Gm-Message-State: AOAM531lmZdjSrOoSndesse2jgw7w7a7koiXduCou7+eZhcWA2MM1uzb
        DR340RueaulfkcwKn/YI8AbeXTRS3PmN3pAgAScDHQ==
X-Google-Smtp-Source: ABdhPJzf80SklHSfSuQhfjZldHzHeqA9kxowqCACntQZwPTpln/vjPLuli55ImnxOdwZcC0Xeix5RVazcDnkd6/i0fI=
X-Received: by 2002:aca:670b:: with SMTP id z11mr12304394oix.6.1596835022052;
 Fri, 07 Aug 2020 14:17:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200804042043.3592620-1-aaronlewis@google.com>
 <20200804042043.3592620-2-aaronlewis@google.com> <183f3ebd-0872-8758-6770-a5769a87011d@amazon.com>
In-Reply-To: <183f3ebd-0872-8758-6770-a5769a87011d@amazon.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 7 Aug 2020 14:16:50 -0700
Message-ID: <CALMp9eRgkENN94x7fpuFcRa-X_9tL0Vp0m453rwJdJ-_6qsy5w@mail.gmail.com>
Subject: Re: [PATCH 1/6] KVM: x86: Add ioctl for accepting a userspace
 provided MSR list
To:     Alexander Graf <graf@amazon.com>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 7, 2020 at 9:12 AM Alexander Graf <graf@amazon.com> wrote:
>
>
>
> On 04.08.20 06:20, Aaron Lewis wrote:
> > CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> >
> >
> >
> > Add KVM_SET_EXIT_MSRS ioctl to allow userspace to pass in a list of MSRs
> > that force an exit to userspace when rdmsr or wrmsr are used by the
> > guest.
> >
> > KVM_SET_EXIT_MSRS will need to be called before any vCPUs are
> > created to protect the 'user_exit_msrs' list from being mutated while
> > vCPUs are running.
> >
> > Add KVM_CAP_SET_MSR_EXITS to identify the feature exists.
> >
> > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> > Reviewed-by: Oliver Upton <oupton@google.com>
> > ---
> >   Documentation/virt/kvm/api.rst  | 24 +++++++++++++++++++
> >   arch/x86/include/asm/kvm_host.h |  2 ++
> >   arch/x86/kvm/x86.c              | 41 +++++++++++++++++++++++++++++++++
> >   include/uapi/linux/kvm.h        |  2 ++
> >   4 files changed, 69 insertions(+)
> >
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index 320788f81a05..7d8167c165aa 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -1006,6 +1006,30 @@ such as migration.
> >   :Parameters: struct kvm_vcpu_event (out)
> >   :Returns: 0 on success, -1 on error
> >
> > +4.32 KVM_SET_EXIT_MSRS
> > +------------------
> > +
> > +:Capability: KVM_CAP_SET_MSR_EXITS
> > +:Architectures: x86
> > +:Type: vm ioctl
> > +:Parameters: struct kvm_msr_list (in)
> > +:Returns: 0 on success, -1 on error
> > +
> > +Sets the userspace MSR list which is used to track which MSRs KVM should send
> > +to userspace to be serviced when the guest executes rdmsr or wrmsr.
>
> Unfortunately this doesn't solve the whole "ignore_msrs" mess that we
> have today. How can I just say "tell user space about unhandled MSRs"?
> And if I add that on top of this mechanism, how do we not make the list
> of MSRs that are handled in-kernel an ABI?

Jumping in for Aaron, who is out this afternoon...

This patch doesn't attempt to solve your problem, "tell user space
about unhandled MSRs." It attempts to solve our problem, "tell user
space about a specific set of MSRs, even if kvm learns to handle them
in the future." This is, in fact, what we really wanted to do when
Peter Hornyack implemented the "tell user space about unhandled MSRs"
changes in 2015. We just didn't realize it at the time.

Though your proposal does partially solve our problem, it's a lot
easier to specify a small set of MSRs by inclusion than it is by
exclusion. (Where your proposal falls short of our needs is when
userspace wants to handle an MSR that kvm would not typically
intercept at all.)

> > +
> > +This ioctl needs to be called before vCPUs are setup otherwise the list of MSRs
> > +will not be accepted and an EINVAL error will be returned.  Also, if a list of
> > +MSRs has already been supplied, and this ioctl is called again an EEXIST error
> > +will be returned.
> > +
> > +::
> > +
> > +  struct kvm_msr_list {
> > +  __u32 nmsrs;
> > +  __u32 indices[0];
> > +};
> > +
> >   X86:
> >   ^^^^
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index be5363b21540..510055471dd0 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1004,6 +1004,8 @@ struct kvm_arch {
> >
> >          struct kvm_pmu_event_filter *pmu_event_filter;
> >          struct task_struct *nx_lpage_recovery_thread;
> > +
> > +       struct kvm_msr_list *user_exit_msrs;
> >   };
> >
> >   struct kvm_vm_stat {
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 88c593f83b28..46a0fb9e0869 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -3419,6 +3419,42 @@ static inline bool kvm_can_mwait_in_guest(void)
> >                  boot_cpu_has(X86_FEATURE_ARAT);
> >   }
> >
> > +static int kvm_vm_ioctl_set_exit_msrs(struct kvm *kvm,
> > +                                     struct kvm_msr_list __user *user_msr_list)
> > +{
> > +       struct kvm_msr_list *msr_list, hdr;
> > +       size_t indices_size;
> > +
> > +       if (kvm->arch.user_exit_msrs != NULL)
> > +               return -EEXIST;
> > +
> > +       if (kvm->created_vcpus)
> > +               return -EINVAL;
>
> What if we need to change the set of user space handled MSRs
> dynamically, for example because a feature has been enabled through a
> previous MSR?

It's never been an issue for us, and this approach avoids the
messiness of having to back out the old changes to the MSR permissions
bitmaps, which is fraught. It can be done, but I would question the
ROI on the additional complexity. In any case, I think a VCPU ioctl
would be more appropriate than a VM ioctl if dynamic modifications
were allowed. For instance, in your example, the previous MSR write
that enabled a feature requiring a new user space MSR exit would
likely apply only to the VCPU on which that previous MSR write
happened.

> > +
> > +       if (copy_from_user(&hdr, user_msr_list, sizeof(hdr)))
> > +               return -EFAULT;
> > +
> > +       if (hdr.nmsrs >= MAX_IO_MSRS)
>
> This constant is not defined inside the scope of this patch. Is your
> patchset fully bisectable? Please make sure that every patch builds
> successfully on its own :).

I can't vouch for this patchset being fully bisectable, but this
particular constant was moved to x86.c ~13 years ago, in commit
313a3dc75da20 ("KVM: Portability: split kvm_vcpu_ioctl"). It should
not cause any build issues. :)
