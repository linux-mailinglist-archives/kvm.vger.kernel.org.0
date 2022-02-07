Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57C184ACD0E
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 02:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235823AbiBHBFK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 20:05:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343741AbiBGXxb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 18:53:31 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0676C0612A4
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 15:53:30 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id g8so5930748pfq.9
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 15:53:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Dexw4mp88eho1hqWPLMgXA0V6dq/NOSshXT4P+meRXI=;
        b=I5tbVd2tNRwEgyv1OaBRfTc0g38c7M8Uvsss+AWjzCTWD7GPF/2/a4fc+2QjbgPw+s
         zVIC/jUvUMoaybysLG+yUXMp0YXxZxpS73gAIiOKOptsX4M/AJS7xVXvSDaREWoFtK7r
         S//J2YHVt8vV0k7hhWfB2g9rvTPTmG1RMaTGXSadAV0JQrV4HPNtFG3Ms0KvfoeMiyoT
         BEVjmOEZvFoQyHEvULInwQL2z5RWYRs//wuIeNnwjpxAkaBaDx0cDRTqnK+7IkAAzjRC
         alRg+EZmzsHtpYroe8e+vGm4xUB0MB3da2u+YbGfPEXYjQGk1QN1tLvtiCgjUOpQ4H6F
         FGqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Dexw4mp88eho1hqWPLMgXA0V6dq/NOSshXT4P+meRXI=;
        b=ASX76PBz78c0gtY2P6sg2QVdIFUzAkWvi0IihA1LkOgLjZI7QYtfehPnSsTExvuWq6
         fPw+AG/6cb/5yIbnsEURa9EM2yN6Vk3bE8b/zBOI6oPNmxoZUC4Y0iCAvqcN3teFu5na
         U658hdCJYdgi4tvqYRgst/rMcd0MVTQDn1Wd44WgCOPVq4pd+ytmGR/7FIn8+QeCSHaC
         OiQpNkXWZLLzpTTPZpCTTZTD+rCvdiLOslwyNRCCNi+HWyDB4SLVAfZd4FsluneesSXd
         mhC7KnlYjTQ3fBPcRs//9TPIn5LSV4Ou70XEhmxrS0W7YTr3a2QUdQjj9KxRg6uWXm9W
         IQzw==
X-Gm-Message-State: AOAM532loDCdDQjwbaRbEJSWDNveaHMa2D5TpqlDzjdvZw4AJqgtW14U
        QmTPIIc7BJz+QQ67DhPcAZPtAP9x6kxKUjVaQGPJQQ==
X-Google-Smtp-Source: ABdhPJxWliv+yfnKc0HU0BceLJDPP06+fnjL+v5N68nTmEu4T/ZBxC+x0b5KHflpht3+4et0fqJ5bUl2AlIlOLTNOkk=
X-Received: by 2002:a65:5943:: with SMTP id g3mr1447475pgu.3.1644278010062;
 Mon, 07 Feb 2022 15:53:30 -0800 (PST)
MIME-Version: 1.0
References: <20220204115718.14934-1-pbonzini@redhat.com> <YgGmgMMR0dBmjW86@google.com>
 <YgGq31edopd6RMts@google.com>
In-Reply-To: <YgGq31edopd6RMts@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 7 Feb 2022 15:53:03 -0800
Message-ID: <CALzav=d05sMd=ARkV+GMf9SkxKcg9c9n5ttb274M2fZrP27PDA@mail.gmail.com>
Subject: Re: [PATCH 00/23] KVM: MMU: MMU role refactoring
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 7, 2022 at 3:27 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Feb 07, 2022, David Matlack wrote:
> > On Fri, Feb 04, 2022 at 06:56:55AM -0500, Paolo Bonzini wrote:
> > > The TDP MMU has a performance regression compared to the legacy
> > > MMU when CR0 changes often.  This was reported for the grsecurity
> > > kernel, which uses CR0.WP to implement kernel W^X.  In that case,
> > > each change to CR0.WP unloads the MMU and causes a lot of unnecessary
> > > work.  When running nested, this can even cause the L1 to hardly
> > > make progress, as the L0 hypervisor it is overwhelmed by the amount
> > > of MMU work that is needed.
> > >
> > > The root cause of the issue is that the "MMU role" in KVM is a mess
> > > that mixes the CPU setup (CR0/CR4/EFER, SMM, guest mode, etc.)
> > > and the shadow page table format.  Whenever something is different
> > > between the MMU and the CPU, it is stored as an extra field in struct
> > > kvm_mmu---and for extra bonus complication, sometimes the same thing
> > > is stored in both the role and an extra field.
> > >
> > > So, this is the "no functional change intended" part of the changes
> > > required to fix the performance regression.  It separates neatly
> > > the shadow page table format ("MMU role") from the guest page table
> > > format ("CPU role"), and removes the duplicate fields.
> >
> > What do you think about calling this the guest_role instead of cpu_role?
> > There is a bit of a precedent for using "guest" instead of "cpu" already
> > for this type of concept (e.g. guest_walker), and I find it more
> > intuitive.
>
> Haven't looked at the series yet, but I'd prefer not to use guest_role, it's
> too similar to is_guest_mode() and kvm_mmu_role.guest_mode.  E.g. we'd end up with
>
>   static union kvm_mmu_role kvm_calc_guest_role(struct kvm_vcpu *vcpu,
>                                               const struct kvm_mmu_role_regs *regs)
>   {
>         union kvm_mmu_role role = {0};
>
>         role.base.access = ACC_ALL;
>         role.base.smm = is_smm(vcpu);
>         role.base.guest_mode = is_guest_mode(vcpu);
>         role.base.direct = !____is_cr0_pg(regs);
>
>         ...
>   }
>
> and possibly
>
>         if (guest_role.guest_mode)
>                 ...
>
> which would be quite messy.  Maybe vcpu_role if cpu_role isn't intuitive?

I agree it's a little odd. But actually it's somewhat intuitive (the
guest is in guest-mode, i.e. we're running a nested guest).

Ok I'm stretching a little bit :). But if the trade-off is just
"guest_role.guest_mode" requires a clarifying comment, but the rest of
the code gets more readable (cpu_role is used a lot more than
role.guest_mode), it still might be worth it.
