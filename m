Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D32C48B72F
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 20:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350612AbiAKTS1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 14:18:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350618AbiAKTRg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 14:17:36 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1637EC06118A
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 11:16:59 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id a12-20020a0568301dcc00b005919e149b4cso1684469otj.8
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 11:16:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RmmeEOXgL4aczt2lYfVEJ81JJyR5GHuXnUEqtqtBYAw=;
        b=cOATJM7qKaMwa1rfMreaSBRrwDDzMO7PjOtbZd5NEoxEnpoVYSyEoZ9YYXqeYIXSvr
         YE9v8N/iag490QDHMRj+L/DdGLjpFJHDqQCT7vnsL3SeJdwkX63Af178WulVTiUohxbi
         2Z/g/UTUnmDWrvpF1A4BuycMUQiQMZtfEfDMEJMhly8ysY21Lwy1FYkVyAAHc2Y+CloD
         QUqxx8+pjJdctbF3pQ+CoqO2LSEEj2OAsTt02lMfMbyq/L2h4o6KshlrJhMnTMxz7HRI
         kj1j8PJ6vmHhfhTs5wV82Z3hYb9FrcuJ2q8JzsdRPEiJYoahPTsWOV6v37b2pmdg3f9Q
         Qtpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RmmeEOXgL4aczt2lYfVEJ81JJyR5GHuXnUEqtqtBYAw=;
        b=E3hwxML0Q7gp4CSLkRmpncoKtpwe3XmB/dPjNoRauJQkLdAcYxYZHtzBmv2ACH/FOz
         pM0hGnzDhnzO/lIqOO1c8CL2vQtUvmatAdn8vPdGBOjJMoPL14gj5aZsiBnVj+xq9TYN
         bCU2SoHrV3qHL22SUCs517OGihJWLPPlMYLmpu0N8xVi2SzlAQR7gf7Hr732sIpzBWFY
         fbysKt0d4q3SoB796RAcJyBQjtrkrblmKhXRx9hRGCOFu7NV/MgB2QPkhcf9yO0kNO/q
         t2BLiPPmuCGujcJDTnqPiCu4qhyw/vqDPNBSLnx1AHLkzoncU0X8nl13t/h4YGUmWvIg
         1xBA==
X-Gm-Message-State: AOAM530aG9fB7Pbgw/QzWqZ51RP//H0kOlis0xCyNlv2RnAYMGb1W1mx
        g2vInIZ81SgBd2Ja7OTQvBD20kx46AQbdjuFsM0M8w==
X-Google-Smtp-Source: ABdhPJyFhnhDMW2ISK4zn+lMszvCQjj7MkaLiyC7O4OUsyaW0HdldRqbQFmZ06I5CZ/gdojGHnnTpqjIXgdkiahuGYk=
X-Received: by 2002:a05:6830:441f:: with SMTP id q31mr4578699otv.14.1641928618059;
 Tue, 11 Jan 2022 11:16:58 -0800 (PST)
MIME-Version: 1.0
References: <20220104194918.373612-1-rananta@google.com> <20220104194918.373612-2-rananta@google.com>
 <CAAeT=Fxyct=WLUvfbpROKwB9huyt+QdJnKTaj8c5NKk+UY51WQ@mail.gmail.com>
 <CAJHc60za+E-zEO5v2QeKuifoXznPnt5n--g1dAN5jgsuq+SxrA@mail.gmail.com>
 <CALMp9eQDzqoJMck=_agEZNU9FJY9LB=iW-8hkrRc20NtqN=gDA@mail.gmail.com>
 <CAJHc60xZ9emY9Rs9ZbV+AH-Mjmkyg4JZU7V16TF48C-HJn+n4A@mail.gmail.com>
 <CALMp9eTPJZDtMiHZ5XRiYw2NR9EBKSfcP5CYddzyd2cgWsJ9hw@mail.gmail.com> <CAJHc60xD2U36pM4+Dq3yZw6Cokk-16X83JHMPXj4aFnxOJ3BUQ@mail.gmail.com>
In-Reply-To: <CAJHc60xD2U36pM4+Dq3yZw6Cokk-16X83JHMPXj4aFnxOJ3BUQ@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 11 Jan 2022 11:16:46 -0800
Message-ID: <CALMp9eR+evJ+w9VTSvR2KHciQDgTsnS=bh=1OUL4yy8gG6O51A@mail.gmail.com>
Subject: Re: [RFC PATCH v3 01/11] KVM: Capture VM start
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Reiji Watanabe <reijiw@google.com>, Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 11, 2022 at 10:52 AM Raghavendra Rao Ananta
<rananta@google.com> wrote:
>
> On Mon, Jan 10, 2022 at 3:57 PM Jim Mattson <jmattson@google.com> wrote:
> >
> > On Mon, Jan 10, 2022 at 3:07 PM Raghavendra Rao Ananta
> > <rananta@google.com> wrote:
> > >
> > > On Fri, Jan 7, 2022 at 4:05 PM Jim Mattson <jmattson@google.com> wrote:
> > > >
> > > > On Fri, Jan 7, 2022 at 3:43 PM Raghavendra Rao Ananta
> > > > <rananta@google.com> wrote:
> > > > >
> > > > > Hi Reiji,
> > > > >
> > > > > On Thu, Jan 6, 2022 at 10:07 PM Reiji Watanabe <reijiw@google.com> wrote:
> > > > > >
> > > > > > Hi Raghu,
> > > > > >
> > > > > > On Tue, Jan 4, 2022 at 11:49 AM Raghavendra Rao Ananta
> > > > > > <rananta@google.com> wrote:
> > > > > > >
> > > > > > > Capture the start of the KVM VM, which is basically the
> > > > > > > start of any vCPU run. This state of the VM is helpful
> > > > > > > in the upcoming patches to prevent user-space from
> > > > > > > configuring certain VM features after the VM has started
> > > > > > > running.
> > > >
> > > > What about live migration, where the VM has already technically been
> > > > started before the first call to KVM_RUN?
> > >
> > > My understanding is that a new 'struct kvm' is created on the target
> > > machine and this flag should be reset, which would allow the VMM to
> > > restore the firmware registers. However, we would be running KVM_RUN
> > > for the first time on the target machine, thus setting the flag.
> > > So, you are right; It's more of a resume operation from the guest's
> > > point of view. I guess the name of the variable is what's confusing
> > > here.
> >
> > I was actually thinking that live migration gives userspace an easy
> > way to circumvent your restriction. You said, "This state of the VM is
> > helpful in the upcoming patches to prevent user-space from configuring
> > certain VM features after the VM has started running." However, if you
> > don't ensure that these VM features are configured the same way on the
> > target machine as they were on the source machine, you have not
> > actually accomplished your stated goal.
> >
> Isn't that up to the VMM to save/restore and validate the registers
> across migrations?

Yes, just as it is up to userspace not to make bad configuration
changes after the first VMRUN.

> Perhaps I have to re-word my intentions for the patch- userspace
> should be able to configure the registers before issuing the first
> KVM_RUN.

Perhaps it would help if you explained *why* you are doing this. It
sounds like you are either trying to protect against a malicious
userspace, or you are trying to keep userspace from doing something
stupid. In general, kvm only enforces constraints that are necessary
to protect the host. If that's what you're doing, I don't understand
why live migration doesn't provide an end-run around your protections.
