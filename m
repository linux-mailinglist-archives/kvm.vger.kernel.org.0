Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C963C27C6
	for <lists+kvm@lfdr.de>; Fri,  9 Jul 2021 18:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbhGIQwa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jul 2021 12:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbhGIQw3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jul 2021 12:52:29 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58C46C0613DD
        for <kvm@vger.kernel.org>; Fri,  9 Jul 2021 09:49:45 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id cs1-20020a17090af501b0290170856e1a8aso8570563pjb.3
        for <kvm@vger.kernel.org>; Fri, 09 Jul 2021 09:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=y8ksef0vKPdeGZiNhS+5SAqzB66QJi7/d7HDlmfKEi0=;
        b=FcsaLTHBk7svPb76TOzEFx6WM9ZjHU1kpCMOBH2/zRIGGeIrdUHC+MC6r7To6OMsTg
         TLoPCKGbLNt9Ifig3FcGfc9HtaOOWRd1Gk+erZ/U1A4K+10CshBvNH9Zgf4/GZ6j3mGc
         kIK3MqKa0bayr1N3tvspTxbXqq1ODv9FIW845O1E5JFnKBjJXr93YOUMaXsCWKvcdAOx
         T4ZqvW+tmSdkL6IYQEu+sT912VPb2Tw8kpq2L7blv+L4ZClgMDlidsEf8DvNknuxR+v4
         5bhwjGU6qIJdMOC5xuRPkJTKGYdhIzDV/VDr3gZGHrC2vEXm7yb1cm+f57iqoed28F3K
         2zAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=y8ksef0vKPdeGZiNhS+5SAqzB66QJi7/d7HDlmfKEi0=;
        b=E/PLJaiMPQHuX5VtGodtcpP3D3vQJU00A+Rh1U7RFXoeChcFMIiJqY9ZtpXvGPZbsu
         Kprt52DkWz70JLEl73CVdt9BK2NbS8haIiSZm8/U/kGXczfuPXce4gxTZdFnESL4/ENi
         SVTfOsFzeiymfO5/qfd4X8Tii1CN8L9xxD4G/A+cwl+YbBDTxZARF10Y6L/Nr1lb+CC1
         LezElFpjFZbd4+9nkrfeq4LBbmBic6FQeJDTyLZqEufJRenN23LOyEtU+DZ2i7aQkt+D
         XShRDlzeap/IVkvTwnMp4pFmx27h2FjHcbOAM5A0sauyfTA70IH8PshOFPNt/gARfCHs
         4Q7g==
X-Gm-Message-State: AOAM531X78Br1N2wqIfDhIMbS6OYTYLwORca4Qn3Wp9/YDps7egvdagg
        YjK1uHXQnAYXyQ60P8NebJ3tKw==
X-Google-Smtp-Source: ABdhPJxLFKisA5KIw7gy1VEKuu4c2i/gr9LvfhmEAFUYyLq5nFWmE+7L34oKiMBaR47r9PExUwk4Eg==
X-Received: by 2002:a17:902:fe0a:b029:11d:81c9:3adf with SMTP id g10-20020a170902fe0ab029011d81c93adfmr31730627plj.0.1625849384437;
        Fri, 09 Jul 2021 09:49:44 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id i27sm7936474pgl.78.2021.07.09.09.49.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 09:49:43 -0700 (PDT)
Date:   Fri, 9 Jul 2021 16:49:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: X86: Also reload the debug registers before
 kvm_x86->run() when the host is using them
Message-ID: <YOh+JBWBDtFQHNMW@google.com>
References: <20210628172632.81029-1-jiangshanlai@gmail.com>
 <46e0aaf1-b7cd-288f-e4be-ac59aa04908f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46e0aaf1-b7cd-288f-e4be-ac59aa04908f@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 08, 2021, Paolo Bonzini wrote:
> On 28/06/21 19:26, Lai Jiangshan wrote:
> > From: Lai Jiangshan <laijs@linux.alibaba.com>
> > 
> > When the host is using debug registers but the guest is not using them
> > nor is the guest in guest-debug state, the kvm code does not reset
> > the host debug registers before kvm_x86->run().  Rather, it relies on
> > the hardware vmentry instruction to automatically reset the dr7 registers
> > which ensures that the host breakpoints do not affect the guest.
> > 
> > But there are still problems:
> > 	o The addresses of the host breakpoints can leak into the guest
> > 	  and the guest may use these information to attack the host.
> 
> I don't think this is true, because DRn reads would exit (if they don't,
> switch_db_regs would be nonzero).  But otherwise it makes sense to do at
> least the DR7 write, and we might as well do all of them.
> 
> > 	o It violates the non-instrumentable nature around VM entry and
> > 	  exit.  For example, when a host breakpoint is set on
> > 	  vcpu->arch.cr2, #DB will hit aftr kvm_guest_enter_irqoff().
> > 
> > Beside the problems, the logic is not consistent either. When the guest
> > debug registers are active, the host breakpoints are reset before
> > kvm_x86->run(). But when the guest debug registers are inactive, the
> > host breakpoints are delayed to be disabled.  The host tracing tools may
> > see different results depending on there is any guest running or not.
> 
> More precisely, the host tracing tools may see different results depending
> on what the guest is doing.
> 
> Queued (with fixed commit message), thanks!
> 
> Paolo
> 
> > To fix the problems, we also reload the debug registers before
> > kvm_x86->run() when the host is using them whenever the guest is using
> > them or not.
> > 
> > Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> > ---
> >   arch/x86/kvm/x86.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index b594275d49b5..cce316655d3c 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -9320,7 +9320,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
> >   	if (test_thread_flag(TIF_NEED_FPU_LOAD))
> >   		switch_fpu_return();
> > -	if (unlikely(vcpu->arch.switch_db_regs)) {
> > +	if (unlikely(vcpu->arch.switch_db_regs || hw_breakpoint_active())) {
> >   		set_debugreg(0, 7);

I would prefer zero only dr7, e.g.

	if (unlikely(vcpu->arch.switch_db_regs)) {
		...
	} else if (hw_breakpoint_active()) {
		set_debugreg(0, 7);
	}

Stuffing all DRs isn't a bug because hw_breakpoint_restore() will restore all DRs,
but loading stale state into DRs is weird.

> >   		set_debugreg(vcpu->arch.eff_db[0], 0);
> >   		set_debugreg(vcpu->arch.eff_db[1], 1);
> > 
> 
