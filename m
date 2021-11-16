Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B27A94529D5
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 06:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234762AbhKPFiH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 00:38:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234709AbhKPFhS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 00:37:18 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D912CC0E2F4E;
        Mon, 15 Nov 2021 18:48:12 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id n66so39067821oia.9;
        Mon, 15 Nov 2021 18:48:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hfMb5y0GzzhTB60N0Kj7z32jqLhXBZn0xl39155kNAc=;
        b=DfPJ9U1c+k7DvGyN4MTbwNHzK02ia8LBMwZoZSXw93196g9e3Q5hIem5rkWAH6pjO6
         grIzhobwB/qo800e2c2Ojo+LEplQZ7N6lTIpK37/we5Bqx6HriiEOWit6eWqVElKlCUs
         9ZhyS4uR5K4uLtPT0ufhHCTNRc0HvnTKnay5laUZ7RdIQFzRWSljFOHvFf+bBQfKHfpD
         au3JCJJc0qpCzcjEOFSUtpTWMp+Htb02y7OZCSK+seJESb4t+SDygiJTReqCLWt4MZE3
         tk5tcRzf2DRROzuq+9uBrWiMVXVN9dOLzk8zNocp91F9f0OeHatRE5Joli9MT6BmcAxM
         JM4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hfMb5y0GzzhTB60N0Kj7z32jqLhXBZn0xl39155kNAc=;
        b=Gp8400I4pOiTOHc58qrPPO3euFF675BR8c4H0C659vRFLoYOv7upLzmYA8sO0sYCen
         as2H7cJrCnTeqcYKW7cL/eGRWj68Be1X4yYCyoRtZImBiHPeGCKcdvCVEDKkNA2n3YCp
         GXBO/fmso640SzgHVdZXLwdnLGVBxbDtDL8Hoyjgf9fse48uFFfPtgsKTUqHbZFvdyKt
         pk/LGYO0neYaORnr1MFVyesjy2QuO1NCEpDPtm3ZOLVQf1oYkVQmiXSlmetSmji4id/o
         rOvoaGhbRBcSq0UFf22GmcP7lXWxcic/Piqv2kgYgFtD1uTQrlB0iaXrEB3xWoxceK4u
         Bx5w==
X-Gm-Message-State: AOAM530aLNtNmDU9/BSNFDbBpEnD5MJhJHLM20htZwPs/WtGiEl+KMGi
        j4ASDTPW+wzoWtyMF9LzGxWl0NnkxO0Jpo6mPz8=
X-Google-Smtp-Source: ABdhPJzbT6tHttClxwvEQe9FsDLhPK4ZSG0AGiNdCqPu47uV8ZIOzi2y0MDsJ3tt3xY20lBKbg6GS3p12R1KDbDZVbo=
X-Received: by 2002:a05:6808:5c1:: with SMTP id d1mr50458180oij.141.1637030892281;
 Mon, 15 Nov 2021 18:48:12 -0800 (PST)
MIME-Version: 1.0
References: <20211108095931.618865-1-huangkele@bytedance.com>
 <a991bbb4-b507-a2f6-ec0f-fce23d4379ce@redhat.com> <f93612f54a5cde53fd9342f703ccbaf3c9edbc9c.camel@redhat.com>
In-Reply-To: <f93612f54a5cde53fd9342f703ccbaf3c9edbc9c.camel@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 16 Nov 2021 10:48:01 +0800
Message-ID: <CANRm+Cze_b0PJzOGB4-tPdrz-iHcJj-o7QL1t1Pf1083nJDQKQ@mail.gmail.com>
Subject: Re: [RFC] KVM: x86: SVM: don't expose PV_SEND_IPI feature with AVIC
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Kele Huang <huangkele@bytedance.com>, chaiwen.cc@bytedance.com,
        xieyongji@bytedance.com, dengliang.1214@bytedance.com,
        zhenwei pi <pizhenwei@bytedance.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 8 Nov 2021 at 22:09, Maxim Levitsky <mlevitsk@redhat.com> wrote:
>
> On Mon, 2021-11-08 at 11:30 +0100, Paolo Bonzini wrote:
> > On 11/8/21 10:59, Kele Huang wrote:
> > > Currently, AVIC is disabled if x2apic feature is exposed to guest
> > > or in-kernel PIT is in re-injection mode.
> > >
> > > We can enable AVIC with options:
> > >
> > >    Kmod args:
> > >    modprobe kvm_amd avic=1 nested=0 npt=1
> > >    QEMU args:
> > >    ... -cpu host,-x2apic -global kvm-pit.lost_tick_policy=discard ...
> > >
> > > When LAPIC works in xapic mode, both AVIC and PV_SEND_IPI feature
> > > can accelerate IPI operations for guest. However, the relationship
> > > between AVIC and PV_SEND_IPI feature is not sorted out.
> > >
> > > In logical, AVIC accelerates most of frequently IPI operations
> > > without VMM intervention, while the re-hooking of apic->send_IPI_xxx
> > > from PV_SEND_IPI feature masks out it. People can get confused
> > > if AVIC is enabled while getting lots of hypercall kvm_exits
> > > from IPI.
> > >
> > > In performance, benchmark tool
> > > https://lore.kernel.org/kvm/20171219085010.4081-1-ynorov@caviumnetworks.com/
> > > shows below results:
> > >
> > >    Test env:
> > >    CPU: AMD EPYC 7742 64-Core Processor
> > >    2 vCPUs pinned 1:1
> > >    idle=poll
> > >
> > >    Test result (average ns per IPI of lots of running):
> > >    PV_SEND_IPI      : 1860
> > >    AVIC             : 1390
> > >
> > > Besides, disscussions in https://lkml.org/lkml/2021/10/20/423
> > > do have some solid performance test results to this.
> > >
> > > This patch fixes this by masking out PV_SEND_IPI feature when
> > > AVIC is enabled in setting up of guest vCPUs' CPUID.
> > >
> > > Signed-off-by: Kele Huang <huangkele@bytedance.com>
> >
> > AVIC can change across migration.  I think we should instead use a new
> > KVM_HINTS_* bit (KVM_HINTS_ACCELERATED_LAPIC or something like that).
> > The KVM_HINTS_* bits are intended to be changeable across migration,
> > even though we don't have for now anything equivalent to the Hyper-V
> > reenlightenment interrupt.
>
> Note that the same issue exists with HyperV. It also has PV APIC,
> which is harmful when AVIC is enabled (that is guest uses it instead
> of using AVIC, negating AVIC benefits).
>
> Also note that Intel recently posted IPI virtualizaion, which
> will make this issue relevant to APICv too soon.

The recently posted Intel IPI virtualization will accelerate unicast
ipi but not broadcast ipis, AMD AVIC accelerates unicast ipi well but
accelerates broadcast ipis worse than pv ipis. Could we just handle
unicast ipi here?

    Wanpeng
