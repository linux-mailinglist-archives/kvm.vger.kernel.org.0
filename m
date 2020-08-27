Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B75E254CFB
	for <lists+kvm@lfdr.de>; Thu, 27 Aug 2020 20:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgH0SZh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Aug 2020 14:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbgH0SZh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Aug 2020 14:25:37 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E47C06121B
        for <kvm@vger.kernel.org>; Thu, 27 Aug 2020 11:25:37 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id e6so5446064oii.4
        for <kvm@vger.kernel.org>; Thu, 27 Aug 2020 11:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gs0r/qLqNENIPIXNSy2JKQmS4bv6DjmNng0VSEeWxcY=;
        b=Yjq8DqIPvwRF1E9Tr12e/y+mTnyhCpVETyEZh1fq/yZGhcgQPT6Tyy05F2WWlmnUC6
         dfRnq6kYRM1bJlsf7G8zIQjSa1l+/9dq1QUzy+rRrArCwjrFRzFGXdXNT1s4RqnZrvBG
         fCp8l1Zt4JFqK7OSoQc0KL29gj3eafs0XRL+2MYhejL2Qzf0tHo6kyFGelGZste+olQA
         aeMQ+XYFNXBGgdnJTMWjA7l02SiGVMUXUUWdiUIhH+078YbZD42rlFX34bwocJASQLVn
         Tns2Mc1c1xJ1+cux3uB1404kK/KDAdlN7SdWoJWh3bTIDlSqFLxs7CrzletDnTvusf+5
         l53Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gs0r/qLqNENIPIXNSy2JKQmS4bv6DjmNng0VSEeWxcY=;
        b=SYEQxXaSnDFTlAUYiHQR/B7M/ahutHw6Ixq/z3aCFWusPbwzAkKeP9uHfB8gVuQH1e
         tAAiibRroWmxZoHjC21CjWq4Hxgdii1LTbPOo5ONHBylCRz/dsJKIRZQKDk2kv3wf8pP
         Qju4WzMfJkcHHjxOMzNWffPquOoDtgGPfX5OrzOxVR2TdYgzp6yVrsBE7uBvl8M+f22M
         ThMfEuTSGra16TIKl0Iscp5YWY5iOQ40X+vIr+FdJIBrLTivqAWWrPDSdZ54rO6O+98m
         22WszulnM0Qx+i4FihKuap9nTJj1jHuPeAaDe6MkCfgN4NUpqquITc4tAvVGwBsivldn
         B4uA==
X-Gm-Message-State: AOAM530FyvybxbJ7l6tB3Lqs17e7R5rB/sMyDdr22xGE7cvPaNpK5Gz3
        CjsXRIEjRZcBYkV0YNtxj0QzJGE3Rjlss0b0WeIApw==
X-Google-Smtp-Source: ABdhPJyki3MAfYcG3wS6NQGrmmLx/zt7ChQXHSU1crErA4qk+WA5f7w/hTN++agIsMk2QIir4G0Mgl+njaE7EkxXApY=
X-Received: by 2002:aca:670b:: with SMTP id z11mr130883oix.6.1598552736210;
 Thu, 27 Aug 2020 11:25:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200713162206.1930767-1-vkuznets@redhat.com> <CALMp9eR+DYVH0UZvbNKUNArzPdf1mvAoxakzj++szaVCD0Fcpw@mail.gmail.com>
In-Reply-To: <CALMp9eR+DYVH0UZvbNKUNArzPdf1mvAoxakzj++szaVCD0Fcpw@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 27 Aug 2020 11:25:25 -0700
Message-ID: <CALMp9eRGStwpYbeHbxo79zF9EyQ=35wwhNt03rjMHMDD9a5G0A@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: nVMX: fix the layout of struct kvm_vmx_nested_state_hdr
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Peter Shier <pshier@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 13, 2020 at 11:23 AM Jim Mattson <jmattson@google.com> wrote:
>
> On Mon, Jul 13, 2020 at 9:22 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> >
> > Before commit 850448f35aaf ("KVM: nVMX: Fix VMX preemption timer
> > migration") struct kvm_vmx_nested_state_hdr looked like:
> >
> > struct kvm_vmx_nested_state_hdr {
> >         __u64 vmxon_pa;
> >         __u64 vmcs12_pa;
> >         struct {
> >                 __u16 flags;
> >         } smm;
> > }
> >
> > The ABI got broken by the above mentioned commit and an attempt
> > to fix that was made in commit 83d31e5271ac ("KVM: nVMX: fixes for
> > preemption timer migration") which made the structure look like:
> >
> > struct kvm_vmx_nested_state_hdr {
> >         __u64 vmxon_pa;
> >         __u64 vmcs12_pa;
> >         struct {
> >                 __u16 flags;
> >         } smm;
> >         __u32 flags;
> >         __u64 preemption_timer_deadline;
> > };
> >
> > The problem with this layout is that before both changes compilers were
> > allocating 24 bytes for this and although smm.flags is padded to 8 bytes,
> > it is initialized as a 2 byte value. Chances are that legacy userspaces
> > using old layout will be passing uninitialized bytes which will slip into
> > what is now known as 'flags'.
> >
> > Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Fixes: 850448f35aaf ("KVM: nVMX: Fix VMX preemption timer migration")
> > Fixes: 83d31e5271ac ("KVM: nVMX: fixes for preemption timer migration")
> > Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>
> Oops!
>
> Reviewed-by: Jim Mattson <jmattson@google.com>

Whatever happened to this?
