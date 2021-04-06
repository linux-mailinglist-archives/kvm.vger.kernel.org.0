Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C137835576A
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 17:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbhDFPLs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 11:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241150AbhDFPLr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 11:11:47 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D831C06175F
        for <kvm@vger.kernel.org>; Tue,  6 Apr 2021 08:11:39 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id s11so10642792pfm.1
        for <kvm@vger.kernel.org>; Tue, 06 Apr 2021 08:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wMg1tXo5GvHCGxwhu8OpzGcHgBM3RWJCydSk6NMOEDA=;
        b=lQ+a9APS5AQlbbgHxBC5O48i5WwOH3t4pPGoOaG0U4ShcakCjIsOZlN8WwqQ42U9Nl
         JUh5cWmm4FlbKBS7ZMHp5rmwIK+HvVD8gYudjaVLQDc6eahkVwjA3l2g4AtBJnt/GvGI
         6Ott5YFVpUR2P2xiFDk1LRipYxhtktoNn7J9HX3HyvZgY2BKDVMNzkmbVx6Q02NZZ1dt
         MXVMbRyVx2swtq4jwmACZwppxBsIFzX4AUgqabdamawz9trDfXz4CCHeO769Tv5WnCwj
         v/hYDDK/lEfreugbDKEH8PgKnhOVsWAXY5VspwlbPN8EGmPIjTzinjgQfB4Tt9TqtZ+l
         8EVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wMg1tXo5GvHCGxwhu8OpzGcHgBM3RWJCydSk6NMOEDA=;
        b=afryIRzo0dR0obnYvqHY/ZWejPCraZdDYqorU18lxIt7D3tDPPGhTQ/a0R2D7FX3HV
         NSkADKYxrC8i90BJPdRnUt40ehzSI1073kvt7Bd92BTBTtAB0UEBVV0pFlxUrpRe2xAe
         pvHXLBFPaMF+kwYO/r36BtwcNNgJcn8JiXEMvZVMwBUvSPu3y+gV5NW8+K3NC92hXHim
         vbQBVPZKJhVQVD2Bma3RTAfh+Gi0wzkZLYkz4Uz9+zfUGgH8zHDitGWz/UrYkrmQ2dnO
         B/UByge7yRwvq59xlQW3yFGmYZAlOgz4wQB+3OfRaFkNCfYcgROeXQZOtH9A8AM+KBjY
         UcaA==
X-Gm-Message-State: AOAM531k68WrmiTVVwtJ0k17yZ87Sy40bjr1c7QVlZ2JKSffzXZGCB0v
        Cam8UcUJXD8okrfnEeBcfSRI5g==
X-Google-Smtp-Source: ABdhPJxZN10dqOxUDE5yq5Wyrimzq5bW7D/DDvbtu3+EqSK2qvD+9Tv2uh+u84Yon5Nj4QEJCUOvaQ==
X-Received: by 2002:a05:6a00:1ad4:b029:216:aa9d:dcea with SMTP id f20-20020a056a001ad4b0290216aa9ddceamr27645348pfv.47.1617721898770;
        Tue, 06 Apr 2021 08:11:38 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id t1sm2839175pjo.45.2021.04.06.08.11.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 08:11:37 -0700 (PDT)
Date:   Tue, 6 Apr 2021 15:11:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     Steve Rutherford <srutherford@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Will Deacon <will@kernel.org>, maz@kernel.org,
        Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v11 08/13] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS
 hypercall
Message-ID: <YGx6JqTVO97GUzn7@google.com>
References: <cover.1617302792.git.ashish.kalra@amd.com>
 <4da0d40c309a21ba3952d06f346b6411930729c9.1617302792.git.ashish.kalra@amd.com>
 <CABayD+fF7+sn444rMuE_SNwN-SYSPwJr1mrW3qRYw4H7ryi-aw@mail.gmail.com>
 <20210406062248.GA22937@ashkalra_ubuntu_server>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406062248.GA22937@ashkalra_ubuntu_server>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 06, 2021, Ashish Kalra wrote:
> On Mon, Apr 05, 2021 at 01:42:42PM -0700, Steve Rutherford wrote:
> > On Mon, Apr 5, 2021 at 7:28 AM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index f7d12fca397b..ef5c77d59651 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -8273,6 +8273,18 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> > >                 kvm_sched_yield(vcpu->kvm, a0);
> > >                 ret = 0;
> > >                 break;
> > > +       case KVM_HC_PAGE_ENC_STATUS: {
> > > +               int r;
> > > +
> > > +               ret = -KVM_ENOSYS;
> > > +               if (kvm_x86_ops.page_enc_status_hc) {
> > > +                       r = kvm_x86_ops.page_enc_status_hc(vcpu, a0, a1, a2);
> > > +                       if (r >= 0)
> > > +                               return r;
> > > +                       ret = r;
> > Style nit: Why not just set ret, and return ret if ret >=0?
> > 
> 
> But ret is "unsigned long", if i set ret and return, then i will return to guest
> even in case of error above ?

As proposed, svm_page_enc_status_hc() already hooks complete_userspace_io(), so
this could be hoisted out of the switch statement.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 16fb39503296..794dde3adfab 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8261,6 +8261,10 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
                goto out;
        }

+       /* comment goes here */
+       if (nr == KVM_HC_PAGE_ENC_STATUS && kvm_x86_ops.page_enc_status_hc)
+               return static_call(kvm_x86_page_enc_status_hc(vcpu, a0, a1, a2));
+
        ret = -KVM_ENOSYS;

        switch (nr) {

