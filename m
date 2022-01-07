Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7FE5487F7F
	for <lists+kvm@lfdr.de>; Sat,  8 Jan 2022 00:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231669AbiAGXmH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 18:42:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbiAGXmG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jan 2022 18:42:06 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9647DC06173E
        for <kvm@vger.kernel.org>; Fri,  7 Jan 2022 15:42:05 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id y9so6971453pgr.11
        for <kvm@vger.kernel.org>; Fri, 07 Jan 2022 15:42:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dl5NjrPyqtirGqh/44w+tOXwcC+wnrBXDnBxl8SYaOs=;
        b=Y47yKd48acltCAFbzaPkvvplMuEGDM8zkr59CRe4GzPOZbM6Y6Gw5IyJttHP8FZrau
         wQdnfzAzHqQhqWt65NFhLodOCyaeDDfG2pHlrFTo9Qoub8lR0RRbd15y5MNbWLnAcvqq
         AkCzTZCqnqx3W0l/za6lj3lppZHDBWBSwbzJoh4P9awe/QLQTOr9YSd1dBg9bJsRryXv
         UHhC4EY74xD+W9SQfZeT6EmrhzyJWDTOX8PF0PuxFG/Rk7QcSa1luANXQZupXdp015pI
         LPcEH+3AwWTsafuO/os5SIF4LfuoaVOfwR+a2nxa+BoyqDy6pQMIPi3/vg7xwc82sHKz
         xzig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dl5NjrPyqtirGqh/44w+tOXwcC+wnrBXDnBxl8SYaOs=;
        b=xRjt2AKNfX23LHT0uwU9iHjgY+ncHhq22sYd32nhGiKXIinsQE6eoLe6G+UV00xOsE
         HrPYBXFz2LEJgtBNkZD/eWJ+Q+hiJgdWjSFnWAiEGYl+yoNmCLffvPK0GPtV/krv8Iv8
         gGTv9BehaY6ZKDXoUzyQY0RESetPfyT+keLMS3QRxtOILSerfQm8YX+ZRDYNIgqsTn4u
         2GtggdugMtkLthLA4Z1wk4YoX1JZUeQKJ10vZwLT8UpWjOq+JaF1H6Uuzgk4ojAu4Twm
         2IolZ0BHlg6iPcV4YxuZi4OZapUQWH5r7OIHbvPbr7Pvk3dSeCZNzISx8BWv6rP5nXYu
         dRdg==
X-Gm-Message-State: AOAM530QQSlAdXLqxkoHtxQ85saaigLInO4OOYEqDtoGwl2PWBnD1v9V
        vSrBp2ns0gWv97S8fXdIv1OdrQ==
X-Google-Smtp-Source: ABdhPJzPRIFNYJhGqnUuIdQe/e5MBW+Jo0uHATwazr1k7KOnw4yas1RlTdSzYpZPOo7fjsVlB/N9BA==
X-Received: by 2002:a63:3c18:: with SMTP id j24mr2547358pga.204.1641598924961;
        Fri, 07 Jan 2022 15:42:04 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id na9sm92585pjb.0.2022.01.07.15.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 15:42:03 -0800 (PST)
Date:   Fri, 7 Jan 2022 23:42:00 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v2 3/5] KVM: SVM: fix race between interrupt delivery and
 AVIC inhibition
Message-ID: <YdjPyCRwZDoV11ox@google.com>
References: <20211213104634.199141-1-mlevitsk@redhat.com>
 <20211213104634.199141-4-mlevitsk@redhat.com>
 <YdTPvdY6ysjXMpAU@google.com>
 <628ac6d9b16c6b3a2573f717df0d2417df7caddb.camel@redhat.com>
 <6a11edec-c29a-95df-393e-363e1af46257@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a11edec-c29a-95df-393e-363e1af46257@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 07, 2022, Paolo Bonzini wrote:
> On 1/5/22 12:03, Maxim Levitsky wrote:
> > > > -	if (!vcpu->arch.apicv_active)
> > > > -		return -1;
> > > > -
> > > > +	/*
> > > > +	 * Below, we have to handle anyway the case of AVIC being disabled
> > > > +	 * in the middle of this function, and there is hardly any overhead
> > > > +	 * if AVIC is disabled.  So, we do not bother returning -1 and handle
> > > > +	 * the kick ourselves for disabled APICv.
> > > Hmm, my preference would be to keep the "return -1" even though apicv_active must
> > > be rechecked.  That would help highlight that returning "failure" after this point
> > > is not an option as it would result in kvm_lapic_set_irr() being called twice.
> > I don't mind either - this will fix the tracepoint I recently added to report the
> > number of interrupts that were delivered by AVIC/APICv - with this patch,
> > all of them count as such.
> 
> The reasoning here is that, unlike VMX, we have to react anyway to
> vcpu->arch.apicv_active becoming false halfway through the function.
> 
> Removing the early return means that there's one less case of load
> (mis)reordering that the reader has to check.

Yeah, I don't disagree, but the flip side is that without the early check, it's
not all that obvious that SVM must not return -1.  And when AVIC isn't supported
or is disabled at the module level, flowing into AVIC "specific" IRR logic is
a bit weird.  And the LAPIC code effectively becomes Intel-only.

To make everyone happy, and fix the tracepoint issue, what about moving delivery
into vendor code?  E.g. the below (incomplete), with SVM functions renamed so that
anything that isn't guaranteed to be AVIC specific uses svm_ instead of avic_.

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index baca9fa37a91..a9ac724c6305 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1096,14 +1096,7 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
                                                       apic->regs + APIC_TMR);
                }

-               if (static_call(kvm_x86_deliver_posted_interrupt)(vcpu, vector)) {
-                       kvm_lapic_set_irr(vector, apic);
-                       kvm_make_request(KVM_REQ_EVENT, vcpu);
-                       kvm_vcpu_kick(vcpu);
-               } else {
-                       trace_kvm_apicv_accept_irq(vcpu->vcpu_id, delivery_mode,
-                                                  trig_mode, vector);
-               }
+               static_call(kvm_x86_deliver_interrupt)(vcpu, vector);
                break;

        case APIC_DM_REMRD:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fe06b02994e6..1fadd14ea884 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4012,6 +4012,18 @@ static int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
        return 0;
 }

+static void vmx_deliver_interrupt(struct kvm_vcpu *vcpu, int vector)
+{
+       if (vmx_deliver_posted_interrupt(vcpu, vector)) {
+               kvm_lapic_set_irr(vector, apic);
+               kvm_make_request(KVM_REQ_EVENT, vcpu);
+               kvm_vcpu_kick(vcpu);
+       } else {
+               trace_kvm_apicv_accept_irq(vcpu->vcpu_id, delivery_mode,
+                                          trig_mode, vector);
+       }
+}
+
 /*
  * Set up the vmcs's constant host-state fields, i.e., host-state fields that
  * will not change in the lifetime of the guest.
@@ -7651,7 +7663,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
        .hwapic_isr_update = vmx_hwapic_isr_update,
        .guest_apic_has_interrupt = vmx_guest_apic_has_interrupt,
        .sync_pir_to_irr = vmx_sync_pir_to_irr,
-       .deliver_posted_interrupt = vmx_deliver_posted_interrupt,
+       .deliver_interrupt = vmx_deliver_interrupt,
        .dy_apicv_has_pending_interrupt = pi_has_pending_interrupt,

        .set_tss_addr = vmx_set_tss_addr,

