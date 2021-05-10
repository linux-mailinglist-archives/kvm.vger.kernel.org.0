Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DEE537951B
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 19:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232319AbhEJRM3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 13:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232050AbhEJRM1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 13:12:27 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B8A5C06175F
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 10:11:19 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id x15so2672741oic.13
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 10:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3xeomlUIis1r7ldXQ1GiBL7DcdGpRnwUk/UQ0i25shc=;
        b=EKzljt3/RL5j8/XR+AO8qSW6ThHGaYBNZiyapN9S8ihCavdDCWHnTrNqt7q/tSO4RJ
         qXzYzg97WfEZo533L3VvCvdFtyUN7Y15XTuAWK7qgE/upwoN8sx5SlKEY+fjwsT9jnpI
         6J4SPneXMzh29n/UbXVPq5tfevEQEkVLsl/qlxJk4K+yH6u+FcpEY0tMFnoiH+V/UOcm
         DVOeaawS8FIH+gQ5Xj31KHh0VoZiSAbRmavErndIrV0c30VRVR34qs/tV7uFlpQ+uQu9
         0HOlFNnjZLwYs0mbfbkM/RB7kX/k9L1Ed6vaJgqNvLv5VuA4T9YASMiJfwPBDj1oLErl
         024A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3xeomlUIis1r7ldXQ1GiBL7DcdGpRnwUk/UQ0i25shc=;
        b=YaXtA27DCqD3/fcjNoj+iOYa4/PF8t7BdsFIhWEjlhwHLFHXsxGmC2em8fUmBzTU/5
         YuF2jgmcRNwFyEqwUejN4XVb8cFFo1w98iQJpOmMT2SQE5ZvgVyOuY9pibvYBhzKFN48
         yMGxnRbPt/6taxbNpscBWqhWQU0krQrHSPhjjcAKEpsOUfP6Mr8S2BPOH2zmt1+W2feA
         IgGcQcICt8DbMVfPWmacNIlQUtJ7pVq+v6ZbOBRqVbur9VYh6Ls0FrBPKK+CGxoSutRp
         1CzTe6CnvVakQb2x0QC8bNUI1idMVdXwZsSBz3Hi9SpnEj/wrgimgAgNbkRLWDwajbkI
         WW3g==
X-Gm-Message-State: AOAM530PTxl+tagcloBk47Sm36/jROgvYwZdp2t5v9SR1NiKbM2NKtNT
        tAkRZ6UuAmOvr0O6SQ1SAzFZ5rTdGh/W0re9mgi6Ng==
X-Google-Smtp-Source: ABdhPJysi+behXoh+5OH+Icd7g7VLJKCRJLkbli2IQUl7jpIQVA8oIm+1+uLVabGGI4KBSW3Ysb5bTE1XwvOKcyl2E4=
X-Received: by 2002:aca:280a:: with SMTP id 10mr110930oix.13.1620666678386;
 Mon, 10 May 2021 10:11:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210504171734.1434054-1-seanjc@google.com> <20210504171734.1434054-15-seanjc@google.com>
 <7e75b44c0477a7fb87f83962e4ea2ed7337c37e5.camel@redhat.com> <YJlkT0kJ241gYgVw@google.com>
In-Reply-To: <YJlkT0kJ241gYgVw@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 10 May 2021 10:11:07 -0700
Message-ID: <CALMp9eSzy6gEvZe2s-MGe3cM047iKNoGidHDkm63=01sfgSyjg@mail.gmail.com>
Subject: Re: [PATCH 14/15] KVM: x86: Tie Intel and AMD behavior for
 MSR_TSC_AUX to guest CPU model
To:     Sean Christopherson <seanjc@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 10, 2021 at 9:50 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, May 10, 2021, Maxim Levitsky wrote:
> > On Tue, 2021-05-04 at 10:17 -0700, Sean Christopherson wrote:
> > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > index de921935e8de..6c7c6a303cc5 100644
> > > --- a/arch/x86/kvm/svm/svm.c
> > > +++ b/arch/x86/kvm/svm/svm.c
> > > @@ -2663,12 +2663,6 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> > >                     msr_info->data |= (u64)svm->sysenter_esp_hi << 32;
> > >             break;
> > >     case MSR_TSC_AUX:
> > > -           if (tsc_aux_uret_slot < 0)
> > > -                   return 1;
> > > -           if (!msr_info->host_initiated &&
> > Not related to this patch, but I do wonder why do we need
> > to always allow writing this msr if done by the host,
> > since if neither RDTSPC nor RDPID are supported, the guest
> > won't be able to read this msr at all.
>
> It's an ordering thing and not specific to MSR_TSC_AUX.  Exempting host userspace
> from guest CPUID checks allows userspace to set MSR state, e.g. during migration,
> before setting the guest CPUID model.

I thought the rule was that if an MSR was enumerated by
KVM_GET_MSR_INDEX_LIST, then KVM had to accept legal writes from the
host. The only "ordering thing" is that KVM_GET_MSR_INDEX_LIST is a
device ioctl, so it can't take guest CPUID information into account.

> > > -               !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) &&
> > > -               !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
> > > -                   return 1;
> > >             msr_info->data = svm->tsc_aux;
> > >             break;
> > >     /*
