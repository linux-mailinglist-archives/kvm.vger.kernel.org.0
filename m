Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 500A5393376
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 18:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237309AbhE0QRO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 12:17:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237201AbhE0QQY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 May 2021 12:16:24 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57802C061574
        for <kvm@vger.kernel.org>; Thu, 27 May 2021 09:14:41 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id x18so936061pfi.9
        for <kvm@vger.kernel.org>; Thu, 27 May 2021 09:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yOo3xovVcNidUoYcJvwEMktoREV2uEDIl9X3bGysEBc=;
        b=wPZmXvapgn/51ASZhLJUL63xsdBMSjDE+rrAxuGBvRwJfAGUekxAPZP21IpR1jIKtC
         wfcwgNkDFuA0ceiPPX0rwcAMwGDKQfLTs1fXJmFl3Jb6h+noBl/Vt2+pmG4/GxHmOSQc
         yQJzEtxvAEFHjumfhkIT0s7QxPvY/VFSPlug0TN20G1wFKcAOhWHJ1oNjmv6IvVILQIh
         KCdKufezbQpT9lmc43Nhs6DK9MCvwVdoRKcQe1TR+ueu/FYLGZ3oNsuYqGrrk2htzhz+
         QE9x6NROG0bZXuiiPliMlyiyf7wFvqmf98ZG+YNjIdw5obNTsbGcUq223NT9xzBUy8gq
         BmxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yOo3xovVcNidUoYcJvwEMktoREV2uEDIl9X3bGysEBc=;
        b=gDPbk8f7fEV4CoTY6/fH3tkC5FH3+aM4/xOWppw+ClEdHnBsOChNITmgA2UFqtZm7m
         TJYBK9Alujz1JzNpEptryDpTTpmA0dYjvvxVw1dM+sH11n1DNFb9PNPOjLS2FDdgSfSu
         1ebM3R0oXdva5RdYH2OKcRA5FchturhtsACr5qoATmu9vWb+6y4ShK67g6VGtvYsnR0k
         moX1emxMlzpoCr669Mklq3+3eijU57Ztu0YR88t8T6XCimfGfKqlRT1eo6LklnWNXcC9
         sdKiisrrmhXMu/uXRKnw53VqJO51gb5+IKEj6m1abMZWl0v5Z0JisbzPmaYo3rcIbap0
         JlLQ==
X-Gm-Message-State: AOAM530i+8DoN33H7TBQxLbUIB2lYEdyjl55W+q3YO3geYutgthcpBuh
        xILRgHPEcO5sh+SCo/4M7nXFFQ==
X-Google-Smtp-Source: ABdhPJwO4u09Vlb10kRNsBTLVudmy4YUu4FG9TKwzWOozj3DQGU3n6rMDWSF7M/AMVz92mCTFYklzg==
X-Received: by 2002:a62:1cd4:0:b029:2d9:f0ef:2b42 with SMTP id c203-20020a621cd40000b02902d9f0ef2b42mr4374930pfc.36.1622132080684;
        Thu, 27 May 2021 09:14:40 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id o134sm2310639pfd.58.2021.05.27.09.14.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 09:14:40 -0700 (PDT)
Date:   Thu, 27 May 2021 16:14:36 +0000
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
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: X86: fix tlb_flush_guest()
Message-ID: <YK/FbFzKhZEmI40C@google.com>
References: <20210527023922.2017-1-jiangshanlai@gmail.com>
 <78ad9dff-9a20-c17f-cd8f-931090834133@redhat.com>
 <YK/FGYejaIu6EzSn@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YK/FGYejaIu6EzSn@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Maxim for real this time...

On Thu, May 27, 2021, Sean Christopherson wrote:
> +Maxim - A proper fix for this bug might fix your shadow paging + win10 boot
>          issue, this also affects the KVM_REQ_HV_TLB_FLUSH used for HyperV PV
> 	 flushing.
> 
> On Thu, May 27, 2021, Paolo Bonzini wrote:
> > On 27/05/21 04:39, Lai Jiangshan wrote:
> > > From: Lai Jiangshan <laijs@linux.alibaba.com>
> > > 
> > > For KVM_VCPU_FLUSH_TLB used in kvm_flush_tlb_multi(), the guest expects
> > > the hypervisor do the operation that equals to native_flush_tlb_global()
> > > or invpcid_flush_all() in the specified guest CPU.
> > > 
> > > When TDP is enabled, there is no problem to just flush the hardware
> > > TLB of the specified guest CPU.
> > > 
> > > But when using shadowpaging, the hypervisor should have to sync the
> > > shadow pagetable at first before flushing the hardware TLB so that
> > > it can truely emulate the operation of invpcid_flush_all() in guest.
> > 
> > Can you explain why?
> 
> KVM's unsync logic hinges on guest TLB flushes.  For page permission modifications
> that require a TLB flush to take effect, e.g. making a writable page read-only,
> KVM waits until the guest explicitly does said flush to propagate the changes to
> the shadow page tables.  E.g. failure to sync PTEs could result in a read-only 4k
> page being writable when the guest expects it to be read-only.
> 
> > Also it is simpler to handle this in kvm_vcpu_flush_tlb_guest, using "if
> > (tdp_enabled).  This provides also a single, good place to add a comment
> > with the explanation of what invalid entries KVM_REQ_RELOAD is presenting.
> 
> Ya.  
> 
> KVM_REQ_MMU_RELOAD is overkill, nuking the shadow page tables will completely
> offset the performance gains of the paravirtualized flush.
> 
> And making a request won't work without revamping the order of request handling
> in vcpu_enter_guest(), e.g. KVM_REQ_MMU_RELOAD and KVM_REQ_MMU_SYNC are both
> serviced before KVM_REQ_STEAL_UPDATE.
> 
> Cleaning up and documenting the MMU related requests is on my todo list, but the
> immediate fix should be tiny and I can do my cleanups on top.
> 
> I believe the minimal fix is:
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 81ab3b8f22e5..b0072063f9bf 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3072,6 +3072,9 @@ static void kvm_vcpu_flush_tlb_all(struct kvm_vcpu *vcpu)
>  static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
>  {
>         ++vcpu->stat.tlb_flush;
> +
> +       if (!tdp_enabled)
> +               kvm_mmu_sync_roots(vcpu);
>         static_call(kvm_x86_tlb_flush_guest)(vcpu);
>  }
>  
> 
