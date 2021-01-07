Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE0A2EE6A6
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 21:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbhAGUUS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 15:20:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbhAGUUS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 15:20:18 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BBE5C0612F4
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 12:19:38 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id x126so4573854pfc.7
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 12:19:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SZlEimO4YAkWtxdva4bxnoHuQClhYtsS69UscPllb+A=;
        b=RlsMFs4KjBCB+f5yJHtNjT/wxOFZnRr78VAoWkzR4IJ1Dj2eqR3aR83EL+qvwINVB1
         XJiEfd0TL9UnhCwf3m1jzELfhlAkSg61IDLcdV6qJqOVMh4Kbemd3a1XhXqvVHDqTy++
         LHoH15TTy/QucjUfuwxrjsxVJCEuCgYq0rCTIR5LDD6Ut8tI1dTdUIt+XSWIAHD6R9rB
         yCI9vqOkAuonQ9mTuxjGg0vIClJeSol9ppwr2CtaGx6WapBoNyKBFxm35NlX+ljoTeXb
         NvSwUoTqQVO3vTe8A2bNkoCSoefP19CNsrhAgNdBf7xz0zSAA1W81tqK/vXF0d9MIiKn
         4WEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SZlEimO4YAkWtxdva4bxnoHuQClhYtsS69UscPllb+A=;
        b=pehzt5j75+L7owKN3olJRrXCrT0NS/Vl5MwG+/REO9iWqdx08fBvc+roZUZJvWEyBB
         SNL9gAfJ3UQBrACV8jILEE97AqAwfU5Fh9K/PKLZX3rW3wrSF/8RanEyXJdBe1TMhwK6
         V3/9cxPE28FFpEcPOLFeUhPJgaHNebF2CC8vN/1Zvwr8yJrtreTG1M7rhiSXbMgcUTlG
         CrtcBbz3PKDAg4eQ0e03CK49EWLxokp3Eoppf9+hnT5g1uXT/fPNXgVkdJjaRFl+pCU1
         67EMtaoyCrMeUyk0jvPLuPIC6Gi63MyCATHZ3ku0eiAfDy52cBPkVwck0s/splx1GJNC
         nEWQ==
X-Gm-Message-State: AOAM532mU3vIq156paxDUtI8NxFZSnShXWgenb//VQ0lKaWkOYFCbNnb
        1MKeRiDhEQ/HZVmXIw5g8mcQ5w==
X-Google-Smtp-Source: ABdhPJxLNOJQnNDN+uN3rSRlA/QRDy9/dvVA3bNQP0tNQeLZb5+4qbAqAGCw8IwhLuvotH6+buWh9g==
X-Received: by 2002:a63:3ec9:: with SMTP id l192mr3528736pga.104.1610050777651;
        Thu, 07 Jan 2021 12:19:37 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id w27sm6547964pfq.104.2021.01.07.12.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 12:19:37 -0800 (PST)
Date:   Thu, 7 Jan 2021 12:19:30 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 2/4] KVM: nSVM: correctly restore nested_run_pending
 on migration
Message-ID: <X/ds0sUw/me4e/g1@google.com>
References: <20210107093854.882483-1-mlevitsk@redhat.com>
 <20210107093854.882483-3-mlevitsk@redhat.com>
 <98f35e0a-d82b-cac0-b267-00fcba00c185@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98f35e0a-d82b-cac0-b267-00fcba00c185@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 07, 2021, Paolo Bonzini wrote:
> On 07/01/21 10:38, Maxim Levitsky wrote:
> > The code to store it on the migration exists, but no code was restoring it.
> > 
> > One of the side effects of fixing this is that L1->L2 injected events
> > are no longer lost when migration happens with nested run pending.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >   arch/x86/kvm/svm/nested.c | 4 ++++
> >   1 file changed, 4 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index ee4f2082ad1bd..cc3130ab612e5 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -1200,6 +1200,10 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
> >   	 * in the registers, the save area of the nested state instead
> >   	 * contains saved L1 state.
> >   	 */
> > +
> > +	svm->nested.nested_run_pending =
> > +		!!(kvm_state->flags & KVM_STATE_NESTED_RUN_PENDING);
> > +
> >   	copy_vmcb_control_area(&hsave->control, &svm->vmcb->control);
> >   	hsave->save = *save;
> > 
> 
> Nice fix and we need to do it anyway.
> 
> That said, the v1 change had some appeal to it.

Which v1 change are you referring to?

> In the VMX case (if properly implemented) it would allow removing the weird
> nested_run_pending case from prepare_vmcs02_early.  I think it's a valuable
> invariant that there are no events in the VMCS after each KVM_RUN iteration,
> and this special case is breaking the invariant.

Hmm, as weird as that code is, I think it's actually the most architecturally
correct behavior.  Technically, the clearing of VM_ENTRY_INTR_INFO.VALID
shouldn't be visible in vmcs12 until a nested VM-Exit occurs, e.g. copying the
vmcs02 value to vmcs12 in vmx_get_nested_state() would work, but it's wrong at
the same time.  Ditto for L1 (or L2) writing vmcs12.VM_ENTRY_INTR_INFO while L2
is running (ignoring the SDM's very clear warning that doing so is bad); from
L1/L2's perspective, there is no VM-Entry so writing vmcs12.VM_ENTRY_INTR_INFO
should never generate an event in L2, even on CPUs without VMCS caching.
