Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29F39242E85
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 20:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbgHLScv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Aug 2020 14:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbgHLScv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Aug 2020 14:32:51 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F6BC061383
        for <kvm@vger.kernel.org>; Wed, 12 Aug 2020 11:32:51 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id k12so2780099otr.1
        for <kvm@vger.kernel.org>; Wed, 12 Aug 2020 11:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Iq5zcoPvcN7T8KSX0uQQrVJaYxTlpMSMBxtNsvh1wuM=;
        b=QM7a50twcijnq4/3ZW/O+9xjvW93ebFFEyQqVRJLyIZ1P87M+G7Is4tYI1VD0ikr6u
         0mA8d7XC8wnH+xFw6v9UgSTx6AFTQ6x+Cj0HVkaFzv1gMKXdZD/UtV/qIhPQMljzkyib
         r3+JIXdmwd0Ii9KO7oHfZWDxU40LNTbU8dIRmN49HnESDLoEHeGphhMZz2a628D21ah+
         WtyTpWSDy8tRo5VWoi6aAcTbDWBqBTVDiDu+5yVSC3o8utQb08yOAmDEKl1NiIVD81uC
         3yaWwt2pGL3Exg+IJUwVHKZ41zPInA3Jj0/c1/smWfrWzTh3n8OB6be1rdzqp1HnCCbp
         M0GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Iq5zcoPvcN7T8KSX0uQQrVJaYxTlpMSMBxtNsvh1wuM=;
        b=jVwQBq8HHB8CdbZRLYtOTvnXC5dpkGRWf1xWeiKwNo81QYkAINHxR4auVozDamKpLO
         b9HXlz5fdWTKjDLE1G2AiWB65HxPNDjdBPiqgkxljblw7jv+gYeszoffpnJZq89rveZL
         aNCs2G2VB+Yh0eVKYNQikWn2wfduxvUFinhQCQkrd30nS+1YMprYq5DWgpRE7FQaJCKk
         XMyiiWV3tsuw0knf8rprfeewwZnM5csxkMZTRDVWWAD6PsRPl38rrKK0N0gq0FIr8kgo
         2KtZ6d6XoVkjuBqXIWKEMiF4vxwwee1/rdW6YhYrye7eYkN6Opjs5IOqWhFEPZkvJkdx
         04+w==
X-Gm-Message-State: AOAM531T/ViwWHm+ONNw5H1BG9UJONcxByswWfMoFSMpbeAuiDNiMcaE
        YOngTHYxCvOds217kLv29kk/15LTPqsH7l6Ye470Aw==
X-Google-Smtp-Source: ABdhPJz+lzTrWF2UOOoonvsdqjLKtgHh00A7xdKG2eO+qCNz+TiDu0I0jrDoHcVDQ8HHjErxXT8Rxhr9INaoK8a+Jns=
X-Received: by 2002:a9d:ae9:: with SMTP id 96mr889573otq.241.1597257169977;
 Wed, 12 Aug 2020 11:32:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200807084841.7112-1-chenyi.qiang@intel.com> <20200807084841.7112-8-chenyi.qiang@intel.com>
 <CALMp9eTAo3WO5Vk_LptTDZLzymJ_96=UhRipyzTXXLxWJRGdXg@mail.gmail.com> <20200812150017.GB6602@linux.intel.com>
In-Reply-To: <20200812150017.GB6602@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 12 Aug 2020 11:32:38 -0700
Message-ID: <CALMp9eTTZz+Wm-5onY2CF6VGHwtbaYtD9RZLyHZTUM2R4E6vbA@mail.gmail.com>
Subject: Re: [RFC 7/7] KVM: VMX: Enable PKS for nested VM
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 12, 2020 at 8:00 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Mon, Aug 10, 2020 at 05:05:36PM -0700, Jim Mattson wrote:
> > On Fri, Aug 7, 2020 at 1:47 AM Chenyi Qiang <chenyi.qiang@intel.com> wrote:
> > >
> > > PKS MSR passes through guest directly. Configure the MSR to match the
> > > L0/L1 settings so that nested VM runs PKS properly.
> > >
> > > Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> > > ---
> > >  arch/x86/kvm/vmx/nested.c | 32 ++++++++++++++++++++++++++++++++
> > >  arch/x86/kvm/vmx/vmcs12.c |  2 ++
> > >  arch/x86/kvm/vmx/vmcs12.h |  6 +++++-
> > >  arch/x86/kvm/vmx/vmx.c    | 10 ++++++++++
> > >  arch/x86/kvm/vmx/vmx.h    |  1 +
> > >  5 files changed, 50 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > > index df2c2e733549..1f9823d21ecd 100644
> > > --- a/arch/x86/kvm/vmx/nested.c
> > > +++ b/arch/x86/kvm/vmx/nested.c
> > > @@ -647,6 +647,12 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
> > >                                         MSR_IA32_PRED_CMD,
> > >                                         MSR_TYPE_W);
> > >
> > > +       if (!msr_write_intercepted_l01(vcpu, MSR_IA32_PKRS))
> > > +               nested_vmx_disable_intercept_for_msr(
> > > +                                       msr_bitmap_l1, msr_bitmap_l0,
> > > +                                       MSR_IA32_PKRS,
> > > +                                       MSR_TYPE_R | MSR_TYPE_W);
> >
> > What if L1 intercepts only *reads* of MSR_IA32_PKRS?
>
> nested_vmx_disable_intercept_for_msr() handles merging L1's desires, the
> (MSR_TYPE_R | MSR_TYPE_W) param is effectively L0's desire for L2.

I should know better than to assume that a function in kvm actually
does anything like what its name implies, but I never seem to learn.
:-(

Thanks!
