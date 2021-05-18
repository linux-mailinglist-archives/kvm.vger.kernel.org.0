Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61F69388259
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 23:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352592AbhERVqt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 17:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352584AbhERVqo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 17:46:44 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2262C061761
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 14:45:25 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id ne24-20020a17090b3758b029015f2dafecb0so1132646pjb.4
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 14:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=e6Ky8FSnCJHr/QPEwD662+2XvmZZM+O0/N7kW1RUbKo=;
        b=MgmLWO7U+JSM/fWkCkv8IxSSZ6BSVltOhsXt1n/EsjTSBhAxIZ1ut+LmZPgbeAeXL2
         29N9Fs23fE8Kq/SL3v2li2NyKZwFWeWn2XXaD9h+14vpamWjNLTFTt8HmvCK01SDobJq
         QzBQj5fSb/yjJNA54uLscj2Psg5wrKrRzs7zZpTvYTuN2/cmruFHN25FG38O+em7Xbpb
         GKgtML69EOk9CjhTexwuEEn6aRluWsEqLnNKF9Rnc1crojMMGiRL8NhOY0MBmTDlYUBX
         a8ejWdL2QaEju1afR6XtwLkdvsbddk4J1k8xKrQD2aCsh9P377Eo5E0J9wkYKKiMRI1V
         wQzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=e6Ky8FSnCJHr/QPEwD662+2XvmZZM+O0/N7kW1RUbKo=;
        b=CweJW04kWiNgFnWI1Lp/B47OckpcWG8QTm2W46P4cpzOQTtQWXw2373lo8yRZf4V3K
         LlW0PAiw5Gupdv3/ihmBWwAdBxF33VUqpxkvQ3YRoGlA3lOCzqog7SWKuBY4lp2B4K9S
         bCc74MS84eBJA9SlTCVFW4xO6fFadMxNSi3dWONKBvDwone8Ym8pQXlbefBWh0D+uypE
         qajOPpbt5VVThJMERAyvwVek3PTVThYRQ/Sbef+J3QjAt4Jm8exu+jHlbNigsnCj6tA7
         uOz4F7jpAdWsLvTL6U52WHmIJYTYCbP0mRTuCrmepQFZEh3kHuupgWYalb9/SD5oaCqW
         pZ1A==
X-Gm-Message-State: AOAM5330Syr1toL75vyCHNi1y2gpboYY69ZYncB/XzJqygxXwgldE3Qg
        1sE4NrnZZzan70Y1gUfC37+STA==
X-Google-Smtp-Source: ABdhPJz11x7jpg7AeE/0pRoRMmEt1u44uhTKMeB+9iCSS9M+42JMdBJMCXKu6Z7lGxMEZ2QbJy6V9w==
X-Received: by 2002:a17:90a:5310:: with SMTP id x16mr7215945pjh.169.1621374325126;
        Tue, 18 May 2021 14:45:25 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id t1sm13359312pjo.33.2021.05.18.14.45.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 14:45:24 -0700 (PDT)
Date:   Tue, 18 May 2021 21:45:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 35/43] KVM: x86: Move setting of sregs during vCPU
 RESET/INIT to common x86
Message-ID: <YKQ1cO7XRJteY/AX@google.com>
References: <20210424004645.3950558-1-seanjc@google.com>
 <20210424004645.3950558-36-seanjc@google.com>
 <CAAeT=Fx08jBjXoduko_O3v+q67a2fx6byU6z6gM=fBmSWFkt8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeT=Fx08jBjXoduko_O3v+q67a2fx6byU6z6gM=fBmSWFkt8g@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 17, 2021, Reiji Watanabe wrote:
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -1204,12 +1204,6 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
> >         init_sys_seg(&save->ldtr, SEG_TYPE_LDT);
> >         init_sys_seg(&save->tr, SEG_TYPE_BUSY_TSS16);
> >
> > -       svm_set_cr0(vcpu, X86_CR0_NW | X86_CR0_CD | X86_CR0_ET);
> > -       svm_set_cr4(vcpu, 0);
> > -       svm_set_efer(vcpu, 0);
> > -       kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);
> > -       vcpu->arch.regs[VCPU_REGS_RIP] = 0x0000fff0;
> 
> Reviewed-by: Reiji Watanabe <reijiw@google.com>
> 
> Those your vCPU RESET/INIT changes look great.
> 
> I think the change in init_vmcb() basically assumes that the
> function is called from kvm_vcpu_reset(via svm_vcpu_reset()).
> Although shutdown_interception() directly calls init_mcb(),
> I would think the change doesn't matter for the shutdown
> interception case.
> 
> IMHO it would be a bit misleading that a function named 'init_vmcb',
> which is called from other than kvm_vcpu_reset (svm_vcpu_reset()),
> only partially resets the vmcb (probably just to me though).

It's not just you, that code is funky.  If I could go back in time, I would lobby
to not automatically init the VMCB and instead put the vCPU into
KVM_MP_STATE_UNINITIALIZED and force userspace to explicitly INIT or RESET the
vCPU.  Even better would be to add KVM_MP_STATE_SHUTDOWN, since technically NMI
can break shutdown (and SMI on Intel CPUs).

Anyways, that ship has sailed, but we might be able to get away with replacing
init_vmcb() with kvm_vcpu_reset(vcpu, true), i.e. effecting a full INIT.  That
would ensure the VMCB is consistent with KVM's software model, which I'm guessing
is not true with the direct init_vmcb() call.  It would also have some connection
to reality since there exist bare metal platforms that automatically INIT the CPU
if it hits shutdown (maybe only for the BSP?).

Side topic, the NMI thing got me looking through init_vmcb() to see how it
handles the IDT and GDT, and surprise, surprise, it fails to zero IDTR.base and
GDTR.base.  I'll add a patch to fix that, and maybe try to consolidate the VMX
and SVM segmentation logic.

> So, I personally think it would be better if its name or comment
> can give some more specific information about the assumption.
> 
> BTW, it looks like two lines of "vcpu->arch.hflags = 0;"
> can be also removed from the init_vmcb() as well.

Ya, I'll add that to the pile.

Thanks!
