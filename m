Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A19D32330D0
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 13:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgG3LQR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 07:16:17 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:29543 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726367AbgG3LQQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jul 2020 07:16:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596107775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i6M54uk3wxSqMByimlcSdiyFDQobGVGgtyqtJxIsLh8=;
        b=JFZZfdlhjHXOWnzF5JaK9iuZLO29PMlXuZzChzzQPzk7QJw94HwD+5zWUX2GvJlBHlWnPJ
        R91jg7DtUCDgZc7Rg6JfnH8YzEBJGCkaBtoeYzq288OcQCOgpON6g5QOpuXNLQ09hi6lPY
        TUutwD54nLb/HA9AFO40DYRRjezRqs0=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-254-uo8S23o_PXKYJAS6JvseqQ-1; Thu, 30 Jul 2020 07:16:13 -0400
X-MC-Unique: uo8S23o_PXKYJAS6JvseqQ-1
Received: by mail-ej1-f71.google.com with SMTP id e7so9700262ejj.10
        for <kvm@vger.kernel.org>; Thu, 30 Jul 2020 04:16:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=i6M54uk3wxSqMByimlcSdiyFDQobGVGgtyqtJxIsLh8=;
        b=sJJA4fZa/IXVQ5+blfqLUGUYOEWn9mBwDN1WqsSPvj/eFv07b5lXtlKGF2wFpQZ+3z
         b0b5vRJW0eePF3FT59GHUA4PiKrDZfVza6p/RN0/z46XDjQqlZNuUO0CKnVJDrVki0HB
         oOEEj9ZHOYXDNA8STcsOSH+/uJyWfmgvbEV2plyqSzLk8PhK9j9Qj8w5Eq0UoWRhdp5R
         LnnNE8aN+x+OBaJS70Zp/0m/+gunVyRm2ckJ1sBdhqcRRpnIh97rE8muVMiOVfHQEQvF
         ImPkUFz56okP3P7xFG9H5Y6S5zzPpipFquyajm2mkKY0vsUVQuXbARikseRi0DHHYdaa
         qy6A==
X-Gm-Message-State: AOAM533U6NYpyy9/MGvTFweudbGGHgZ0WN6ULFqq+CF/7XxdnuAc44SC
        qyxM8NZ0Bwp9E7pk9LjKbXmx9NhlVu2qjfv72rMyqJbHwQmn0mBk5AhQ+U7GPD9eEQsvKjZFXvz
        JOFP7TlPFG9GA
X-Received: by 2002:a17:906:8782:: with SMTP id za2mr1998828ejb.419.1596107771886;
        Thu, 30 Jul 2020 04:16:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwWZycTltIDSKNoeknahH26vkjSn5+zXLiJ8OL45eqL5qMszYqVuD9fPffkhz0Wugn3GjdTpA==
X-Received: by 2002:a17:906:8782:: with SMTP id za2mr1998815ejb.419.1596107771693;
        Thu, 30 Jul 2020 04:16:11 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id cc9sm5811982edb.14.2020.07.30.04.16.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 04:16:10 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v2 3/3] KVM: SVM: Fix disable pause loop exit/pause filtering capability on SVM
In-Reply-To: <CANRm+Cx-VM=QGcDNG0oRq7YX+2wmmw8yDjESrJGxTeEWkUUv0A@mail.gmail.com>
References: <1595929506-9203-1-git-send-email-wanpengli@tencent.com> <1595929506-9203-3-git-send-email-wanpengli@tencent.com> <87k0ymldg9.fsf@vitty.brq.redhat.com> <CANRm+Cx-VM=QGcDNG0oRq7YX+2wmmw8yDjESrJGxTeEWkUUv0A@mail.gmail.com>
Date:   Thu, 30 Jul 2020 13:16:09 +0200
Message-ID: <875za5l0cm.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wanpeng Li <kernellwp@gmail.com> writes:

> On Wed, 29 Jul 2020 at 20:21, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>>
>> Wanpeng Li <kernellwp@gmail.com> writes:
>>
>> > From: Wanpeng Li <wanpengli@tencent.com>
>> >
>> > Commit 8566ac8b (KVM: SVM: Implement pause loop exit logic in SVM) drops
>> > disable pause loop exit/pause filtering capability completely, I guess it
>> > is a merge fault by Radim since disable vmexits capabilities and pause
>> > loop exit for SVM patchsets are merged at the same time. This patch
>> > reintroduces the disable pause loop exit/pause filtering capability
>> > support.
>> >
>> > We can observe 2.9% hackbench improvement for a 92 vCPUs guest on AMD
>> > Rome Server.
>> >
>> > Reported-by: Haiwei Li <lihaiwei@tencent.com>
>> > Tested-by: Haiwei Li <lihaiwei@tencent.com>
>> > Fixes: 8566ac8b (KVM: SVM: Implement pause loop exit logic in SVM)
>> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
>> > ---
>> >  arch/x86/kvm/svm/svm.c | 9 ++++++---
>> >  1 file changed, 6 insertions(+), 3 deletions(-)
>> >
>> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> > index c0da4dd..c20f127 100644
>> > --- a/arch/x86/kvm/svm/svm.c
>> > +++ b/arch/x86/kvm/svm/svm.c
>> > @@ -1090,7 +1090,7 @@ static void init_vmcb(struct vcpu_svm *svm)
>> >       svm->nested.vmcb = 0;
>> >       svm->vcpu.arch.hflags = 0;
>> >
>> > -     if (pause_filter_count) {
>> > +     if (pause_filter_count && !kvm_pause_in_guest(svm->vcpu.kvm)) {
>> >               control->pause_filter_count = pause_filter_count;
>> >               if (pause_filter_thresh)
>> >                       control->pause_filter_thresh = pause_filter_thresh;
>> > @@ -2693,7 +2693,7 @@ static int pause_interception(struct vcpu_svm *svm)
>> >       struct kvm_vcpu *vcpu = &svm->vcpu;
>> >       bool in_kernel = (svm_get_cpl(vcpu) == 0);
>> >
>> > -     if (pause_filter_thresh)
>> > +     if (!kvm_pause_in_guest(vcpu->kvm))
>> >               grow_ple_window(vcpu);
>> >
>> >       kvm_vcpu_on_spin(vcpu, in_kernel);
>> > @@ -3780,7 +3780,7 @@ static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
>> >
>> >  static void svm_sched_in(struct kvm_vcpu *vcpu, int cpu)
>> >  {
>> > -     if (pause_filter_thresh)
>> > +     if (!kvm_pause_in_guest(vcpu->kvm))
>> >               shrink_ple_window(vcpu);
>> >  }
>> >
>> > @@ -3958,6 +3958,9 @@ static void svm_vm_destroy(struct kvm *kvm)
>> >
>> >  static int svm_vm_init(struct kvm *kvm)
>> >  {
>> > +     if (!pause_filter_thresh)
>> > +             kvm->arch.pause_in_guest = true;
>>
>> Would it make sense to do
>>
>>         if (!pause_filter_count || !pause_filter_thresh)
>>                 kvm->arch.pause_in_guest = true;
>>
>> here and simplify the condition in init_vmcb()?
>
> kvm->arch.pause_in_guest can also be true when userspace sets the
> KVM_CAP_X86_DISABLE_EXITS capability, so we can't simplify the
> condition in init_vmcb().
>

I meant we simplify it to

if (!kvm_pause_in_guest(svm->vcpu.kvm))

as "!pause_filter_count" gets included.

-- 
Vitaly

