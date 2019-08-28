Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C95BF9FBC4
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 09:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfH1HaX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 03:30:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40838 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726273AbfH1HaX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 03:30:23 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 883C1C04959E
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2019 07:30:22 +0000 (UTC)
Received: by mail-wm1-f72.google.com with SMTP id g5so1620437wmh.1
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2019 00:30:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ueqkpbyP1ubtGaLxgAbGdw9aVC+mMhLE/TY03oCkmFY=;
        b=d1dpwhWHKFxSmpkBcP/Rc+1I0GzCTKxMW6Mn7An8sd0aGvukwbTS3r2DiDF5eDjEoh
         HCmc+7ckfX4AjMISDHgn6rr0LVfs2QR5/mCD5G1oSEQa2esD6ZPLeMbIhdA9S9S0WE3i
         9BcOfB0PGjo58UYw2qcWi8EE9mldnTBNG0dHCDRTQ119e/JMnMtDBfapwp/z3733FXMX
         SEA/YdxwnnorL80jpdkcRygRbPb0fJ8ZoTDIl3p+sKgMkCfOI3r4uPijzII3003cJYts
         K5Lj+BDqaP9Uciq1qONIcBfuIELB87a+4Kec0xkk3R8y3IQaqaFgrjgLHG4mG4OBGpcm
         CvoA==
X-Gm-Message-State: APjAAAXXoXvjfhMQZA0aItVvNUGG3IHSdCo4op4RdGTllwnZriLI54ob
        PxPSBZCQrZ9xl68Iu9ZYskgjq3poFnDqQLjf+48v6y8rV/Q3O6UxRDNkEDPYAKhbnN5jUplx9f2
        R/syQ5nGPBL4r
X-Received: by 2002:a1c:a383:: with SMTP id m125mr2993617wme.57.1566977420356;
        Wed, 28 Aug 2019 00:30:20 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwq3WXDR8/8BaKVCYWFgg9755Ezm/7Lys3X0fvMndwJ41MWuRxZIS+ZlMXkDXS9hnPrnMvG+w==
X-Received: by 2002:a1c:a383:: with SMTP id m125mr2993570wme.57.1566977419919;
        Wed, 28 Aug 2019 00:30:19 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id z25sm1854857wml.5.2019.08.28.00.30.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 00:30:19 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Roman Kagan <rkagan@virtuozzo.com>
Subject: Re: [PATCH 3/3] KVM: x86: announce KVM_CAP_HYPERV_ENLIGHTENED_VMCS support only when it is available
In-Reply-To: <20190827195224.GI27459@linux.intel.com>
References: <20190827160404.14098-1-vkuznets@redhat.com> <20190827160404.14098-4-vkuznets@redhat.com> <CALMp9eRyabQA8v5cJ1AwmtFdNFvWQz2jQ+iGTRQjow7r4FV3xA@mail.gmail.com> <20190827195224.GI27459@linux.intel.com>
Date:   Wed, 28 Aug 2019 09:30:18 +0200
Message-ID: <878srdlpbp.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Tue, Aug 27, 2019 at 09:54:39AM -0700, Jim Mattson wrote:
>> On Tue, Aug 27, 2019 at 9:04 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>> >
>> > It was discovered that after commit 65efa61dc0d5 ("selftests: kvm: provide
>> > common function to enable eVMCS") hyperv_cpuid selftest is failing on AMD.
>> > The reason is that the commit changed _vcpu_ioctl() to vcpu_ioctl() in the
>> > test and this one can't fail.
>> >
>> > Instead of fixing the test is seems to make more sense to not announce
>> > KVM_CAP_HYPERV_ENLIGHTENED_VMCS support if it is definitely missing
>> > (on svm and in case kvm_intel.nested=0).
>> >
>> > Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> > ---
>> >  arch/x86/kvm/x86.c | 3 ++-
>> >  1 file changed, 2 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> > index d1cd0fcff9e7..ef2e8b138300 100644
>> > --- a/arch/x86/kvm/x86.c
>> > +++ b/arch/x86/kvm/x86.c
>> > @@ -3106,7 +3106,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>> >         case KVM_CAP_HYPERV_EVENTFD:
>> >         case KVM_CAP_HYPERV_TLBFLUSH:
>> >         case KVM_CAP_HYPERV_SEND_IPI:
>> > -       case KVM_CAP_HYPERV_ENLIGHTENED_VMCS:
>> >         case KVM_CAP_HYPERV_CPUID:
>> >         case KVM_CAP_PCI_SEGMENT:
>> >         case KVM_CAP_DEBUGREGS:
>> > @@ -3183,6 +3182,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>> >                 r = kvm_x86_ops->get_nested_state ?
>> >                         kvm_x86_ops->get_nested_state(NULL, NULL, 0) : 0;
>> >                 break;
>> > +       case KVM_CAP_HYPERV_ENLIGHTENED_VMCS:
>> > +               r = kvm_x86_ops->nested_enable_evmcs != NULL;
>> 
>> You should probably have an explicit break here, in case someone later
>> adds another case below.
>
> Yep, this will trigger a warning on compilers with -Wimplicit-fallthrough.

I always forget there's more than checkpatch.pl :-) Thanks you your
reviews guys, I'm going to send v2 of this patchset without PATCH1 which
was already queued by Radim.

-- 
Vitaly
