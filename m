Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 876DB391B6E
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 17:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235367AbhEZPQk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 11:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235223AbhEZPQk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 11:16:40 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 811ABC061574
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 08:15:08 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 27so1219702pgy.3
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 08:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gyPqMlWx0UGmus8UTSY9WUsK8ZBsk5nqFBqX0s/G7yY=;
        b=p/Ou/fdmAh55byEwBF8c18CI5ZSzs8YfUQ6WzubkB1roSNmpO8jAtO0ruzU2WRzTZb
         OTPta8JD+/cVxf1qamokAXWgTI6siNRm3yG706F4Ba9GBdDI+dtUZgeb7P92tW/+arGh
         OlIsi9Ir/+WIeXYP/th89Jf8VfoNsY5trO+Q2Z6njeDAHeWdNhiNBNEg+rWcjE2Q1aFi
         PCWZj7FdC94BdPguA+h3UmiUk0/gCNBoc7yhftUXDjrNZJTq0S5avzbwYyGPzvEmuQFS
         i6TlRmDo72KHfPLNA0bfq7AyEB1YP+U0XHK8SQtK5XPBGdihpoHSoAYKhNa20YnLVRa0
         Qm+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gyPqMlWx0UGmus8UTSY9WUsK8ZBsk5nqFBqX0s/G7yY=;
        b=tb+9kz5j53jwHQgkX79woT9rEe+u4cwtkQ/HCL6eH+GyyCHgUzyCGPE8swVIhNLs+Q
         Zz/kLlAX8GYJhdZ6w6KKBaTDvNy360hnNuAKdj7yymudZxNV28QmgS7TCedKxO3U8MXK
         mHnJntG/6cYfvqMSAhHBcCecvH3eMpSmYC4pceyTvIwaA7+a4DFi6zxRJG+zL1cqlcRp
         FJC0tMpYXqWNsEyOWaXdesMnUuobArPMktKg9nAM+kZushB/ra5GLEzL4lKYhIh+TB+z
         4rL2+T6Iu0e3j8g3YLVtna1TrWSgNsF84KZz6q+1KC8cs9YCQRNJctmbeYbmHW8fkOLe
         vnPA==
X-Gm-Message-State: AOAM531tzHStGfzFr0wvCXBG3ezPjJMyAK9BgO8wBAAsDGHbKYe2jwda
        Kv2ce8uOcRe8JGiFYhHGmwvATg==
X-Google-Smtp-Source: ABdhPJxc7QcsdxpS5IJfjnCaFHxER5bNMrdafpqQ+D5Uiod1DLIdizne556iLrpewx1qXxweLHIIHA==
X-Received: by 2002:a63:e14:: with SMTP id d20mr26047737pgl.35.1622042107988;
        Wed, 26 May 2021 08:15:07 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id 184sm15445516pfv.38.2021.05.26.08.15.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 08:15:07 -0700 (PDT)
Date:   Wed, 26 May 2021 15:15:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/43] KVM: x86: Open code necessary bits of
 kvm_lapic_set_base() at vCPU RESET
Message-ID: <YK5l9/73AHeuVw0q@google.com>
References: <20210424004645.3950558-1-seanjc@google.com>
 <20210424004645.3950558-18-seanjc@google.com>
 <CAAeT=Fw2zfvTkvCSuRqo6K1+L7LaPOpsSHHU1oGbUnUSDtELVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeT=Fw2zfvTkvCSuRqo6K1+L7LaPOpsSHHU1oGbUnUSDtELVQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 26, 2021, Reiji Watanabe wrote:
> On Fri, Apr 23, 2021 at 5:51 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > Stuff vcpu->arch.apic_base and apic->base_address directly during APIC
> > reset, as opposed to bouncing through kvm_set_apic_base() while fudging
> > the ENABLE bit during creation to avoid the other, unwanted side effects.
> >
> > This is a step towards consolidating the APIC RESET logic across x86,
> > VMX, and SVM.
> >
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/lapic.c | 15 ++++++---------
> >  1 file changed, 6 insertions(+), 9 deletions(-)
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index b088f6984b37..b1366df46d1d 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -2305,7 +2305,6 @@ EXPORT_SYMBOL_GPL(kvm_apic_update_apicv);
> >  void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
> >  {
> >         struct kvm_lapic *apic = vcpu->arch.apic;
> > -       u64 msr_val;
> >         int i;
> >
> >         if (!apic)
> > @@ -2315,10 +2314,13 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
> >         hrtimer_cancel(&apic->lapic_timer.timer);
> >
> >         if (!init_event) {
> > -               msr_val = APIC_DEFAULT_PHYS_BASE | MSR_IA32_APICBASE_ENABLE;
> > +               vcpu->arch.apic_base = APIC_DEFAULT_PHYS_BASE |
> > +                                      MSR_IA32_APICBASE_ENABLE;
> >                 if (kvm_vcpu_is_reset_bsp(vcpu))
> > -                       msr_val |= MSR_IA32_APICBASE_BSP;
> > -               kvm_lapic_set_base(vcpu, msr_val);
> > +                       vcpu->arch.apic_base |= MSR_IA32_APICBASE_BSP;
> > +
> > +               apic->base_address = MSR_IA32_APICBASE_ENABLE;
> 
> I think you wanted to make the code above set apic->base_address
> to APIC_DEFAULT_PHYS_BASE (not MSR_IA32_APICBASE_ENABLE).

Indeed!  It also means I need to double check that I'm testing a guest without
x2apic enabled.  Thanks much!
