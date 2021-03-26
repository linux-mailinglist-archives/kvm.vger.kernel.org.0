Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B24DF349E20
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 01:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbhCZAkq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 20:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbhCZAkd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 20:40:33 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FCA2C06174A;
        Thu, 25 Mar 2021 17:40:30 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id 1so2534046qtb.0;
        Thu, 25 Mar 2021 17:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WudPpAp2zodSuwqYyO3R50R/8DSntKfLN/wH7uYSYrM=;
        b=Vn0/vMYaXMe4R2XpupDYgbUI/t7lV9nXGuYlJoSC+dKymcCPiqM9rgCQOKQ9RTxykZ
         jlHhgZdCnCYFfa7lkUGZKHhQeeLn0D5tPJUvM7RsykxlwbhizYawUTci8sAmPalZmKJR
         fTQqFPWmEbqkQUcgjcGclbf4y3S943k7/o1/mojMBgPHGBRW9eCRKUEN+8NPXGjbJV8G
         +CzWvTBSst/kjYaWzvZGy4UVC4huLEGjeFoEBLNxfY3a0gvbYO/mHMvEsOy0ElCTj64A
         lfYtc/9BFTHCwJ//X0KMU535ukgBGASMOY+0xsvg3kWdu87FSjbA9tO+ljQjfQ9d2BFF
         p9zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WudPpAp2zodSuwqYyO3R50R/8DSntKfLN/wH7uYSYrM=;
        b=ij0ivtTy/AgEsgrb61nDpQRgV/g5tFQaMSVL8/YYI51OvyHQyXNSn5OTi/xHla+7u5
         +b5z+T6h2SEUcJcT/5yYJTrJ+W6j7/mYGqFsN7boLL0ffJAlE4lY+Fsp7vfZRG77o+J+
         GfnZ8+iqDLz9QftToyje3TM4nHyUikbFM2HVv1okaWiziK/7PVxN+DFKlTl8aFM79t2L
         gzgnbTVEa+nQA5MJE6r3oo2UB30qRoa9KA9Ya0jhVqmw0I7wiQPr820Ug/tjIFONvhdO
         xUOfZCHnFUhGhZ5Iqbg05NzY2tgzGubV6v/SRn/FqAPW6vx9trZp0DcFLZLn5Yqc+NMv
         TS2Q==
X-Gm-Message-State: AOAM533KP4o7ExnGkqwLyEijtnTSoXN4PoZWcLzosQpIc4B95vmfzZ9x
        8Lj0+v2Yk68RN8HA7ussoxjre5sCjXzQ+X+L4g==
X-Google-Smtp-Source: ABdhPJxRCD7nd51OEfyYS8niDY3sOe6LstmYPCFWeARW1SukhlDnBXKn6l7EiJnsSp+ZNR0r4+9HHBrg8XfmWJzupI8=
X-Received: by 2002:aed:2ee7:: with SMTP id k94mr10029267qtd.135.1616719229894;
 Thu, 25 Mar 2021 17:40:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210323023726.28343-1-lihaiwei.kernel@gmail.com>
 <CAB5KdOZq+2ETburoMv6Vnnj3MFAuvwnSBsSmiBO=nH1Ajdp5_g@mail.gmail.com> <YFyw/VRhRCZlqc1X@google.com>
In-Reply-To: <YFyw/VRhRCZlqc1X@google.com>
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
Date:   Fri, 26 Mar 2021 08:39:50 +0800
Message-ID: <CAB5KdOZHdQeTiYWKebLZG0XgPsybHs1EMqM7=zQ+JoNK1QpkNQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: VMX: Check the corresponding bits according to the
 intel sdm
To:     Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 25, 2021 at 11:49 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Mar 25, 2021, Haiwei Li wrote:
> > On Tue, Mar 23, 2021 at 10:37 AM <lihaiwei.kernel@gmail.com> wrote:
> > >
> > > From: Haiwei Li <lihaiwei@tencent.com>
> > >
> > > According to IA-32 SDM Vol.3D "A.1 BASIC VMX INFORMATION", two inspections
> > > are missing.
> > > * Bit 31 is always 0. Earlier versions of this manual specified that the
> > > VMCS revision identifier was a 32-bit field in bits 31:0 of this MSR. For
> > > all processors produced prior to this change, bit 31 of this MSR was read
> > > as 0.
> > > * The values of bits 47:45 and bits 63:57 are reserved and are read as 0.
> > >
> > > Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
> > > ---
> > >  arch/x86/kvm/vmx/vmx.c | 14 ++++++++++++++
> > >  1 file changed, 14 insertions(+)
> > >
> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > index 32cf828..0d6d13c 100644
> > > --- a/arch/x86/kvm/vmx/vmx.c
> > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > @@ -2577,6 +2577,20 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
> > >
> > >         rdmsr(MSR_IA32_VMX_BASIC, vmx_msr_low, vmx_msr_high);
> > >
> > > +       /*
> > > +        * IA-32 SDM Vol 3D: Bit 31 is always 0.
> > > +        * For all earlier processors, bit 31 of this MSR was read as 0.
> > > +        */
> > > +       if (vmx_msr_low & (1u<<31))
> > > +               return -EIO;
> >
> > Drop this code as Jim said.
> >
> > > +
> > > +       /*
> > > +        * IA-32 SDM Vol 3D: bits 47:45 and bits 63:57 are reserved and are read
> > > +        * as 0.
> > > +        */
> > > +       if (vmx_msr_high & 0xfe00e000)
> > > +               return -EIO;
> >
> > Is this ok? Can we pick up the part? :)
>
> No.  "Reserved and are read as 0" does not guarantee the bits will always be
> reserved.  There are very few bits used for feature enumeration in x86 that are
> guaranteed to be '0' for all eternity.
>
> The whole point of reserving bits in registers is so that the CPU vendor, Intel
> in this case, can introduce new features and enumerate them to software without
> colliding with existing features or breaking software.  E.g. if Intel adds a new
> feature and uses any of these bits to enumerate the feature, this check would
> prevent KVM from loading on CPUs that support the feature.

Got it, only explicit restrictions should be checked. Thanks.

--
Haiwei Li
