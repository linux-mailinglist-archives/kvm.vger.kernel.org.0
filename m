Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B191B7366
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 13:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgDXLoH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 07:44:07 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:45583 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726668AbgDXLoH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Apr 2020 07:44:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587728646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TbNQCab5Ra8181T5/MK2gTcwXHvQ29jb9+DIlTHWC1I=;
        b=hhLHltQNoI3qvvJnAKXzhW2IbM4cwEzcjcV6wffpC+ZhlVASRbHMwLgJ7GgYQi/nk2MbcV
        QY7wMX4l7lVN/nbLoV1GjwgLmtH30zMS5qFzb1VlUINnVFz209e7rpk8qq8cFyZwlfJu7L
        qs2K6JZnZm0G8ONnokWQpflkRzPXqFM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-kWfaTk7bP9-fffa4SR7nBg-1; Fri, 24 Apr 2020 07:44:04 -0400
X-MC-Unique: kWfaTk7bP9-fffa4SR7nBg-1
Received: by mail-wr1-f72.google.com with SMTP id t8so4587542wrq.22
        for <kvm@vger.kernel.org>; Fri, 24 Apr 2020 04:44:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=TbNQCab5Ra8181T5/MK2gTcwXHvQ29jb9+DIlTHWC1I=;
        b=uGlIOPIQDtegrJicGJx+iWIIYK1IlG86CJE7ghRN6Kc3HiK4/9WGJRhlGtQzsZAvXF
         HUId0NxxJZpIkzLZO3AyraIgo03Hm8naXAtcF1zNbYe3I7hP7IcoKL4KtmSjri19WRd0
         rHYR04DKOQvo+1i1/k+6cRWL6lXsXW4miNKdLpqZ98scKxi7dV9cQYiuSXVHBZmt398Z
         aHnSxB1tOHd96P6oLx5IC+KIj95o3UJtF+1Vr4KkhqyGqGjWP3zQBCMirEzbfdhe0mIA
         VP5M5dNGZ9iuFXRh9OSdpmsxM//2rOL6ocLLBWDa3i4b0l/b2o93Z9Odwi080kiL/5qB
         OWIQ==
X-Gm-Message-State: AGi0PuZs8ftk4vs4/HE4F/82iEZvUh4bFB8IznFx6I0tIg+/itdiOsx7
        tTvRQsOZDusVlie+3rK5aoIGT5NyHfruHI0D7Y8osZKvZcctGYLCvNh9MWzB9QqEgeyiCsIgnpr
        vC4eqLhDKCtJC
X-Received: by 2002:a7b:c20f:: with SMTP id x15mr9286260wmi.2.1587728643008;
        Fri, 24 Apr 2020 04:44:03 -0700 (PDT)
X-Google-Smtp-Source: APiQypLKFseMgm1aFXaNx8PZ04efUG3ucG4ytcFQhbEAim7FsrEWHqfaBejy54arQOfgTO8Su3O2yA==
X-Received: by 2002:a7b:c20f:: with SMTP id x15mr9286230wmi.2.1587728642771;
        Fri, 24 Apr 2020 04:44:02 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id h1sm2625970wme.42.2020.04.24.04.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 04:44:02 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: nVMX: Store vmcs.EXIT_QUALIFICATION as an unsigned long, not u32
In-Reply-To: <20200423001127.13490-1-sean.j.christopherson@intel.com>
References: <20200423001127.13490-1-sean.j.christopherson@intel.com>
Date:   Fri, 24 Apr 2020 13:44:00 +0200
Message-ID: <87wo65nm67.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Use an unsigned long for 'exit_qual' in nested_vmx_reflect_vmexit(), the
> EXIT_QUALIFICATION field is naturally sized, not a 32-bit field.
>
> The bug is most easily observed by doing VMXON (or any VMX instruction)
> in L2 with a negative displacement, in which case dropping the upper
> bits on nested VM-Exit results in L1 calculating the wrong virtual
> address for the memory operand, e.g. "vmxon -0x8(%rbp)" yields:
>
>   Unhandled cpu exception 14 #PF at ip 0000000000400553
>   rbp=0000000000537000 cr2=0000000100536ff8
>
> Fixes: fbdd50250396d ("KVM: nVMX: Move VM-Fail check out of nested_vmx_exit_reflected()")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>
> Sadly (for me), I can't blame a mishandled merge on this one.  Even more
> embarassing is that this is actually the second instance where I botched
> the size for exit_qual, you'd think I'd have double-checked everything
> after the first one...
>
>  arch/x86/kvm/vmx/nested.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index f228339cd0a0..3f32f81f5c59 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5814,7 +5814,8 @@ bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	u32 exit_reason = vmx->exit_reason;
> -	u32 exit_intr_info, exit_qual;
> +	unsigned long exit_qual;
> +	u32 exit_intr_info;
>  
>  	WARN_ON_ONCE(vmx->nested.nested_run_pending);

Too late but

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

I also did 'git grep -W 'u32.*exit_qual' kvm/queue' and I can see a few
more places where 'exit_qual' is u32:
nested_vmx_check_guest_state()
nested_vmx_enter_non_root_mode()
vmx_set_nested_state()

Being too lazy to check an even if there are no immediate issues with
that, should we just use 'unsigned long' everywhere?

-- 
Vitaly

