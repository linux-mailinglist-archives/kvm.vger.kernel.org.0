Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6A76393368
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 18:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237255AbhE0QPs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 12:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237222AbhE0QO7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 May 2021 12:14:59 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBAF6C061763
        for <kvm@vger.kernel.org>; Thu, 27 May 2021 09:13:18 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id y202so947959pfc.6
        for <kvm@vger.kernel.org>; Thu, 27 May 2021 09:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=J7NodHI/4ogkySI3kWvt8rbHLbkuIslVZywQJ/42H7Y=;
        b=l6KsMCfVq5g8ogHhM+YmDOFeh8qACcoDKm82bZMH1b66stkbsAn5ifYKF6rvz1WMir
         5/rxPFFtIc2Npsniz4LRvE119BJy2MYJ3L23fNMYQIUqcoi+rI9RxDxNpewMjL0Y2VFo
         KtLC1EaWPAUbFoNvOZZOwDHaSElZsopziOyzF8RjeIxhAPy4qe/4BYdr+lLEjCNerPmS
         SFaeRfvJwEDRImLYO4fy1BQ/ot4957Hs+7qArGYckqxOb+iqnvSle8fJqbcGyXMBkBRJ
         23E6/zFEOYRQiS764hMmqiLGfWff03m37MKSnAvJGZxVYHM23HmM627SwBSeYnTZuMw0
         mpJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=J7NodHI/4ogkySI3kWvt8rbHLbkuIslVZywQJ/42H7Y=;
        b=KoLZ7KIOO3sUth8IiFJWh+JqRWg1xo2HqYzzkmMkxdMr05ewbFnJrb4ffiv2iuPM5W
         LuIC7nz/3wHqpN557eHh+0L9Riw7KTkBkPqranvCxxxLnFWa5lJBmNjGMapqN6Ll/8rW
         7N1tmOGV8M2RE0fyayidF4Lx65vLGsG/06PaOkMJwgVgDvXWkio8r+a/1zFG/BXhRkaU
         knbvrkN28FYEfKrrGMw3OpbqGpIav3Q5KcOahV82VkDyOWlToCgw92rbc/Z9Y/dxKrXQ
         FqZpRxgDXfQX6l8lRgsD7AFvIgro3nBf1oZt/MucI3y2FLP/1CD6KStr+zlRsA6QEQHC
         g2Fg==
X-Gm-Message-State: AOAM532RNVG7reWGBR2nTFuVDBZU2OoSBw/BIvrRk6UA/jGRkplBBMI6
        9Iw3yMSBTdxlMrLFyTZlmrWKYg==
X-Google-Smtp-Source: ABdhPJwM80E7LO/berGR063hc+myV9kW/nwuUU6EBlsdq7ogSFFU0S57o5WLHGW/VR4nMGkXccFmKw==
X-Received: by 2002:a63:f50:: with SMTP id 16mr4297573pgp.373.1622131998175;
        Thu, 27 May 2021 09:13:18 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id 4sm2028793pji.14.2021.05.27.09.13.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 09:13:17 -0700 (PDT)
Date:   Thu, 27 May 2021 16:13:13 +0000
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
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: X86: fix tlb_flush_guest()
Message-ID: <YK/FGYejaIu6EzSn@google.com>
References: <20210527023922.2017-1-jiangshanlai@gmail.com>
 <78ad9dff-9a20-c17f-cd8f-931090834133@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78ad9dff-9a20-c17f-cd8f-931090834133@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Maxim - A proper fix for this bug might fix your shadow paging + win10 boot
         issue, this also affects the KVM_REQ_HV_TLB_FLUSH used for HyperV PV
	 flushing.

On Thu, May 27, 2021, Paolo Bonzini wrote:
> On 27/05/21 04:39, Lai Jiangshan wrote:
> > From: Lai Jiangshan <laijs@linux.alibaba.com>
> > 
> > For KVM_VCPU_FLUSH_TLB used in kvm_flush_tlb_multi(), the guest expects
> > the hypervisor do the operation that equals to native_flush_tlb_global()
> > or invpcid_flush_all() in the specified guest CPU.
> > 
> > When TDP is enabled, there is no problem to just flush the hardware
> > TLB of the specified guest CPU.
> > 
> > But when using shadowpaging, the hypervisor should have to sync the
> > shadow pagetable at first before flushing the hardware TLB so that
> > it can truely emulate the operation of invpcid_flush_all() in guest.
> 
> Can you explain why?

KVM's unsync logic hinges on guest TLB flushes.  For page permission modifications
that require a TLB flush to take effect, e.g. making a writable page read-only,
KVM waits until the guest explicitly does said flush to propagate the changes to
the shadow page tables.  E.g. failure to sync PTEs could result in a read-only 4k
page being writable when the guest expects it to be read-only.

> Also it is simpler to handle this in kvm_vcpu_flush_tlb_guest, using "if
> (tdp_enabled).  This provides also a single, good place to add a comment
> with the explanation of what invalid entries KVM_REQ_RELOAD is presenting.

Ya.  

KVM_REQ_MMU_RELOAD is overkill, nuking the shadow page tables will completely
offset the performance gains of the paravirtualized flush.

And making a request won't work without revamping the order of request handling
in vcpu_enter_guest(), e.g. KVM_REQ_MMU_RELOAD and KVM_REQ_MMU_SYNC are both
serviced before KVM_REQ_STEAL_UPDATE.

Cleaning up and documenting the MMU related requests is on my todo list, but the
immediate fix should be tiny and I can do my cleanups on top.

I believe the minimal fix is:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 81ab3b8f22e5..b0072063f9bf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3072,6 +3072,9 @@ static void kvm_vcpu_flush_tlb_all(struct kvm_vcpu *vcpu)
 static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
 {
        ++vcpu->stat.tlb_flush;
+
+       if (!tdp_enabled)
+               kvm_mmu_sync_roots(vcpu);
        static_call(kvm_x86_tlb_flush_guest)(vcpu);
 }
 

