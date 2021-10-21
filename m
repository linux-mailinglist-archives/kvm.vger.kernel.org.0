Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5230D4364CA
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 16:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbhJUOyn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 10:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbhJUOyl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 10:54:41 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CCE3C0613B9
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 07:52:25 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id nn3-20020a17090b38c300b001a03bb6c4ebso740790pjb.1
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 07:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4wFPm5RkDMkY2Lduta42NvuloKhG9SyfVtIypRwx22Q=;
        b=omliDnFkGyq8QgbtvjOskgJ1f7k6abYNM9RL453A3E5TXgPH1TlXx+uNs4Wao+p7YO
         ql+S4iRXpMjxIwvjP6O3lO47ybx4I9KhFNKXU13LcwnqHODbJh3jGIraBpjlgqLtvMpI
         wiITyKPue3Htyo/+hBVZ9EFVP86VTLxiuxhe+wzvM77QH+JLhUoQHtl0XwrmU9sHVI1Z
         riecEBdq1yYjtscBhVtFgT5kJBDBdglDMRNEI7ik/ETzwe3EWEWLU9yrMvGyC35Qf5Lj
         gWco2UipWoqhGLH5gWtohfNCX5FuAxaAKrXvvgJq5a19ebX6omjq+IpsHbGhQBn+rPPN
         7TJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4wFPm5RkDMkY2Lduta42NvuloKhG9SyfVtIypRwx22Q=;
        b=tqtqC4B6Anhgs9cdeR9aXRTcNuG94aierfglz8tiJsEQLXDICn6UfBd0LoFwR844X5
         1fHx0bO/AiiqDTQw0g8trp+n2SuXh05e0hninslOKQAqRNOesfRcteJiH3T24TdtjTwI
         rhV6i2p5fVCEgGI1qIxMP0kZqxp64tl8yvN+DU3Azo5TDPML+WT1YezAAHrP5PqCzasK
         FxQpwlnNXXZm+SEAsRKon3nYt3nF4RLRPvoz4MuNF2eYEus9qrWKP25U6Hr0q3HhcWHG
         nNJgnrRdBBaVyLfAF+0iWjd4BjWH8tBT+4ekYjl6qLGV+XDpqz1Lj6ue1Mrhj63h58jM
         QULA==
X-Gm-Message-State: AOAM530gP/dXGvtyRSwWpfjJIKtVoJD8iw9nVaL/GICitIEWQ1frRC7W
        klkA+b90NwbkFUwm7Ts1M816Pw==
X-Google-Smtp-Source: ABdhPJy2tjatpB0wPSWSJA/zTzNzkjkjikbyWa4dAWo075UCQgutCmw+p9Ly4T1dxP9VDtcTUyMvug==
X-Received: by 2002:a17:902:8b8b:b0:13d:e91c:a1b9 with SMTP id ay11-20020a1709028b8b00b0013de91ca1b9mr5604534plb.60.1634827944772;
        Thu, 21 Oct 2021 07:52:24 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id oc8sm6808817pjb.15.2021.10.21.07.52.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 07:52:24 -0700 (PDT)
Date:   Thu, 21 Oct 2021 14:52:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <laijs@linux.alibaba.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/4] KVM: X86: Fix tlb flush for tdp in
 kvm_invalidate_pcid()
Message-ID: <YXF+pG0yGA0TQZww@google.com>
References: <20211019110154.4091-1-jiangshanlai@gmail.com>
 <20211019110154.4091-2-jiangshanlai@gmail.com>
 <YW7jfIMduQti8Zqk@google.com>
 <da4dfc96-b1ad-024c-e769-29d3af289eee@linux.alibaba.com>
 <YXBfaqenOhf+M3eA@google.com>
 <55abc519-b528-ddaa-120d-8d157b520623@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55abc519-b528-ddaa-120d-8d157b520623@linux.alibaba.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 21, 2021, Lai Jiangshan wrote:
> 
> 
> On 2021/10/21 02:26, Sean Christopherson wrote:
> > On Wed, Oct 20, 2021, Lai Jiangshan wrote:
> > > On 2021/10/19 23:25, Sean Christopherson wrote:
> > > I just read some interception policy in vmx.c, if EPT=1 but vmx_need_pf_intercept()
> > > return true for some reasons/configs, #PF is intercepted.  But CR3 write is not
> > > intercepted, which means there will be an EPT fault _after_ (IIUC) the CR3 write if
> > > the GPA of the new CR3 exceeds the guest maxphyaddr limit.  And kvm queues a fault to
> > > the guest which is also _after_ the CR3 write, but the guest expects the fault before
> > > the write.
> > > 
> > > IIUC, it can be fixed by intercepting CR3 write or reversing the CR3 write in EPT
> > > violation handler.
> > 
> > KVM implicitly does the latter by emulating the faulting instruction.
> > 
> >    static int handle_ept_violation(struct kvm_vcpu *vcpu)
> >    {
> > 	...
> > 
> > 	/*
> > 	 * Check that the GPA doesn't exceed physical memory limits, as that is
> > 	 * a guest page fault.  We have to emulate the instruction here, because
> > 	 * if the illegal address is that of a paging structure, then
> > 	 * EPT_VIOLATION_ACC_WRITE bit is set.  Alternatively, if supported we
> > 	 * would also use advanced VM-exit information for EPT violations to
> > 	 * reconstruct the page fault error code.
> > 	 */
> > 	if (unlikely(allow_smaller_maxphyaddr && kvm_vcpu_is_illegal_gpa(vcpu, gpa)))
> > 		return kvm_emulate_instruction(vcpu, 0);
> > 
> > 	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
> >    }
> > 
> > and injecting a #GP when kvm_set_cr3() fails.
> 
> I think the EPT violation happens *after* the cr3 write.  So the instruction to be
> emulated is not "cr3 write".  The emulation will queue fault into guest though,
> recursive EPT violation happens since the cr3 exceeds maxphyaddr limit.

Doh, you're correct.  I think my mind wandered into thinking about what would
happen with PDPTRs and forgot to get back to normal MOV CR3.

So yeah, the only way to correctly handle this would be to intercept CR3 loads.
I'm guessing that would have a noticeable impact on guest performance.

Paolo, I'll leave this one for you to decide, we have pretty much written off
allow_smaller_maxphyaddr :-)
