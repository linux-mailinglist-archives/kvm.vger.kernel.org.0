Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF75E3E1CEC
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 21:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238662AbhHETnU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 15:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbhHETnT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Aug 2021 15:43:19 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D79FEC061765
        for <kvm@vger.kernel.org>; Thu,  5 Aug 2021 12:43:04 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id c24so9991092lfi.11
        for <kvm@vger.kernel.org>; Thu, 05 Aug 2021 12:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e+ShchKoXJ5rpWNwI2utssqiWL+MXARNqEb8ZW+Us6o=;
        b=RU5+5gvUiGNAF8RGeG6xZ8DV/G300KTFXqDzTX9vfbZMgQaaeM1riCQapdTkEH0Bi3
         1q55XAD1MjRaJKHhKrDHGv89t4obkQdlGI2FYrRwIcGvfJgJ9oORpcPt/+WOwgQRoWpE
         Jx/9zzaevvYoAPDYTrBsMErXVnD3i5ughdwWZT1TO4Lpr3/HewizzMi8DeUvRLnXeJes
         8jk6VLPSTnPJ4NGbZ932fhnqZchipXaN4SYjRTd/psn+bhPBSsqpehShetyi14OZOdXx
         UvevwZOh1utPk9nGqu9bJtRRySiWMQs6W8kMUCrU8+dRPlnL4t/0r9plP7cSZjFwjQcx
         6uSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e+ShchKoXJ5rpWNwI2utssqiWL+MXARNqEb8ZW+Us6o=;
        b=IJXsyEBauYVLjOniLidiufk/ooNOkOF8vIM9nnYVVHCNANKpBOgpS7udEMvYgJgzAq
         Qy7PIdqBUG0p20fNyA9wRS052oJzXhFv3729MHRDoKe2NI/tdt4UnnA2LEDN4buqNEiK
         gb9Tky/6noinpOREibu2AMVdJvISzcMeUoclxHPUmm4lNbhvIHMZTgnGaWt8I3j9PS2z
         6MhMrQphW76t7HGjm2nHE5eWZpJaUMsI286yKq7Vm4/i4px0qhgbj4NzP4lG3s85Dqcp
         Kw/QZ9QGA+X7NnFJUAwIV6GBjSiWI5sIsGW/XRLt2NOHq9NPWAr2y+lQflPNjKMdtCO3
         OAZQ==
X-Gm-Message-State: AOAM532JM/zKcdZGnM55WfU4sSG900LBBKgafJZLeCTOnsp/WGW+Hoos
        YMpzrqTOtbKLguOdmDa6fQzlD/ec2i3bMl4GIL4=
X-Google-Smtp-Source: ABdhPJwx+VlOnM11q0yv4UYGoZImxBKMvt7gwtzkafrKt8ZPxg6VkBT29T5gD2fslkJSR/soot3gDdrV3e0JTVd44es=
X-Received: by 2002:a05:6512:3b20:: with SMTP id f32mr5024335lfv.279.1628192583222;
 Thu, 05 Aug 2021 12:43:03 -0700 (PDT)
MIME-Version: 1.0
References: <CA+-xGqOdu1rjhkG0FhxfzF1N1Uiq+z0b3MBJ=sjuVStHP5TBKg@mail.gmail.com>
 <d95d40428ec07ee07e7c583a383d5f324f89686a.camel@redhat.com>
 <YOxYM+8qCIyV+rTJ@google.com> <CA+-xGqOSd0yhU4fEcobf3tW0mLb0TmLGycTwXNVUteyvvnXjdw@mail.gmail.com>
 <YO8jPvScgCmtj0JP@google.com> <CA+-xGqOkH-hU1guGx=t-qtjsRdO92oX+8HhcO1eXnCigMc+NPw@mail.gmail.com>
 <YPC1lgV5dZC0CyG0@google.com> <CA+-xGqN75O37cr9uh++dyPj57tKcYm0fD=+-GBErki8nGNcemQ@mail.gmail.com>
 <YPiLBLA2IjwovNCP@google.com> <CA+-xGqP7=m47cLD65DhTumOF8+sWZvc81gh+04aKMS56WWkVtA@mail.gmail.com>
 <YQG3jg9kSqfzmbPB@google.com>
In-Reply-To: <YQG3jg9kSqfzmbPB@google.com>
From:   harry harry <hiharryharryharry@gmail.com>
Date:   Thu, 5 Aug 2021 14:42:51 -0500
Message-ID: <CA+-xGqN68MY9Zt0z9ST7GF8=YB=kvMLxGPZpBeGq3knLf9itcw@mail.gmail.com>
Subject: Re: About two-dimensional page translation (e.g., Intel EPT) and
 shadow page table in Linux QEMU/KVM
To:     Sean Christopherson <seanjc@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, stefanha@redhat.com,
        mathieu.tarral@protonmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean, understood with many thanks!

Good luck,
Harry

On Wed, Jul 28, 2021 at 3:01 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Jul 28, 2021, harry harry wrote:
> > Sean, sorry for the late reply. Thanks for your careful explanations.
> >
> > > For emulation of any instruction/flow that starts with a guest virtual address.
> > > On Intel CPUs, that includes quite literally any "full" instruction emulation,
> > > since KVM needs to translate CS:RIP to a guest physical address in order to fetch
> > > the guest's code stream.  KVM can't avoid "full" emulation unless the guest is
> > > heavily enlightened, e.g. to avoid string I/O, among many other things.
> >
> > Do you mean the emulated MMU is needed when it *only* wants to
> > translate GVAs to GPAs in the guest level?
>
> Not quite, though gva_to_gpa() is the main use.  The emulated MMU is also used to
> inject guest #PF and to load/store guest PDTPRs.
>
> > In such cases, the hardware MMU cannot be used because hardware MMU
> > can only translate GVAs to HPAs, right?
>
> Sort of.  The hardware MMU does translate GVA to GPA, but the GPA value is not
> visible to software (unless the GPA->HPA translation faults).  That's also true
> for VA to PA (and GVA to HPA).  Irrespective of virtualization, x86 ISA doesn't
> provide an instruction to retrive the PA for a given VA.
>
> If such an instruction did exist, and it was to be usable for a VMM to do a
> GVA->GPA translation, the magic instruction would need to take all MMU params as
> operands, e.g. CR0, CR3, CR4, and EFER.  When KVM is active (not the guest), the
> hardware MMU is loaded with the host MMU configuration, not the guest.  In both
> VMX and SVM, vCPU state is mostly ephemeral in the sense that it ceases to exist
> in hardware when the vCPU exits to the host.  Some state is retained in hardware,
> e.g. TLB and cache entries, but those are associated with select properties of
> the vCPU, e.g. EPTP, CR3, etc..., not with the vCPU itself, i.e. not with the
> VMCS (VMX) / VMCB (SVM).
