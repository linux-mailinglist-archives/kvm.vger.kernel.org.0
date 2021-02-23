Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE53E323429
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 00:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232397AbhBWXXA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 18:23:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233935AbhBWXOq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Feb 2021 18:14:46 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 794B7C061574
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 15:14:06 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id e45so355319ote.9
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 15:14:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w5LHMVXfGGl3hxeLafXJooEHPX5Ay/rdElBayKDuOUg=;
        b=be8bS/Vt5TH1uycrmc7J6eu5kop7HbA4Mg3Tp5SitIgNFwgJaZF1x5YtvXbzLvJi8i
         TnNp5xCUyS42XEY12WUu445YR25j8jdIUIE1LxG+OsEIpaTrsjUDP+0hVoL+cQj0xPFC
         nJgfz57W/gqmXm5lwlUhp9sKiC/x31UGG3VMQkn6JOuKj8ySHDEHl6/LtHVJhRBjiXrd
         ddoZGYVvpMFCctHaza8hxdzbRHpufXtAPFeXQ/DAYXFnhryqv6PVQJs071HPdsoVbcrT
         AeFeK3DhErHcxByhMSakJphk3FA77s5i+DdIi+mF64mBWB3YERoHEpdlJxLkv8iZq427
         xo+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w5LHMVXfGGl3hxeLafXJooEHPX5Ay/rdElBayKDuOUg=;
        b=EjmQYlFQffsX/SpN0jkUO2TdkMt27FuJWtHWH7FkUxEm+muQH6TBXp6A1w68V9DIxk
         xN3oWsTTDnMJc+S8SmiSG2H/Xgim782P0HQe0TzArFYCxxjAzOAHxJyjqR6dgYV/gdKm
         2ImdKXcIWqkZIouO1it1WpdQ/ILCCsCKG0gQCdkYQWlLyy/ptzTUPhELAf+ex2NMMYqu
         DHnUve+cfy5KPW/LQeo2lKX0W47N0+Mq2ov0JQ60PduEKQkeS+hzl7CvpBGYGL8H9TZ1
         opVw0wnwIRtSZYWAVGXqwZ9tHn2zBZgDSBtGf2d6+Mdp+ylYZEt8wwE87oOiEMBeK6ZE
         Mg7w==
X-Gm-Message-State: AOAM533niz5ogQpvKz/omqO750r2KHnkwTkkQNMNWw6rLallCh6eBxLE
        LCg9MWAlUhPD8HzTJLhdzSrUFHsknqH/O5SqCJZzig==
X-Google-Smtp-Source: ABdhPJwqkBSojVrg37c64FQ7AF0usw/0mWmYXkLKHIBzSFq8pC/Q258uyFr1Fz2VZNEkCVh4oliJSDNCz1GP1hkCMwY=
X-Received: by 2002:a05:6830:902:: with SMTP id v2mr22285371ott.56.1614122045232;
 Tue, 23 Feb 2021 15:14:05 -0800 (PST)
MIME-Version: 1.0
References: <20210219144632.2288189-1-david.edmondson@oracle.com>
 <20210219144632.2288189-2-david.edmondson@oracle.com> <YDWG51Io0VJEBHGg@google.com>
In-Reply-To: <YDWG51Io0VJEBHGg@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 23 Feb 2021 15:13:54 -0800
Message-ID: <CALMp9eQ5HQqRRBu0HJbuTOJwKSUA950JWSHrLkXz7cHWKt+ymg@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] KVM: x86: dump_vmcs should not assume
 GUEST_IA32_EFER is valid
To:     Sean Christopherson <seanjc@google.com>
Cc:     David Edmondson <david.edmondson@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 23, 2021 at 2:51 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Feb 19, 2021, David Edmondson wrote:
> > If the VM entry/exit controls for loading/saving MSR_EFER are either
> > not available (an older processor or explicitly disabled) or not
> > used (host and guest values are the same), reading GUEST_IA32_EFER
> > from the VMCS returns an inaccurate value.
> >
> > Because of this, in dump_vmcs() don't use GUEST_IA32_EFER to decide
> > whether to print the PDPTRs - do so if the EPT is in use and CR4.PAE
> > is set.
>
> This isn't necessarily correct either.  In a way, it's less correct as PDPTRs
> are more likely to be printed when they shouldn't, assuming most guests are
> 64-bit guests.  It's annoying to calculate the effective guest EFER, but so
> awful that it's worth risking confusion over PDTPRs.

I still prefer a dump_vmcs that always dumps every VMCS field. But if
you really want to skip printing the PDPTEs when they're irrelevant,
can't you just use the "IA-32e mode guest" VM-entry control as a proxy
for EFER.LMA?
