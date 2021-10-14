Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3269042E19B
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 20:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233187AbhJNSuv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 14:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbhJNSuu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 14:50:50 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777B9C061753
        for <kvm@vger.kernel.org>; Thu, 14 Oct 2021 11:48:45 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id oa12-20020a17090b1bcc00b0019f715462a8so5436143pjb.3
        for <kvm@vger.kernel.org>; Thu, 14 Oct 2021 11:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZjimbiTSlE1l8ItQSDOS0TpKsqXd9vrfIa7epPZdvVk=;
        b=PBwp4PoA1EnlQv0jUTHwWnlic0D6ATh3iQtz91bHBcHPDgSModSG7bGRhyFyA0EsXv
         9nTSHsJC4+B/AxTSVK6HeC5Jzsywe7PQ6pON8oaNTCJCEXkJ0mCQez5O3Rspw+E6IICK
         AqYWJIDJyxSw8SFvRiEG4yHlWlZGXbwuDVOvXkLrXGB3HlET5hq62aa3iHOhn4uoXNiE
         +H6Y5WiXRfIs1iANYgEW14fpdqhwzNab+ZWeKWh8t9Xi1kwD/BuWs7nvTkLGBP/39vO+
         0t0YHkM+YT/wmIZWt6VKnEMk4v90Kj6C4MguqirpsFwoy3GzKCjg18beIrA/u1wc3lYr
         QpSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZjimbiTSlE1l8ItQSDOS0TpKsqXd9vrfIa7epPZdvVk=;
        b=0AoIBPyQcZyOPV/TZh/P4yU0NGoJLRrbmnEeu2gtmfFnh1tuI3Duyc591qFHcQK7gu
         O5YqhqAaUNrdCuf2+C6I07Xc32Dv9nPcUp2YNN8y4e1X3CaI3ilfDFodYo9cC1Hq9kkt
         Z3vL+F2t1eapBT1k5WkA7tOC9PTXst+9ykPlTMKtwV3KJGRKIYqqPngoGkGZd/ML4j6N
         3LN9Bhf8MYl4mV7TH9DVn8LiYKX3wCj7i4jJXEGVK/ky79n6QopUkzhS4t+0WR6bzSt6
         Ko1fXJ044c93rcsAvcof8WzGZWjilUo3UPMnOOA2dT+VJjchnOcB9Y+b+HOHkMFp3j6M
         cARg==
X-Gm-Message-State: AOAM532fYrMZbJT26fAvvZox1ryVBivdvE1mbGmTC8GSGucRPAwp86oB
        C3OJk0Jv7tnZNUYapHYwokrSUJWcfQNvug==
X-Google-Smtp-Source: ABdhPJwhA7ksW9z92Xq5XqnztwoOX3c3QuESYlEjpk1PyrX60Py2UUTGfOr6pQZpvHQh/42wMpQlBA==
X-Received: by 2002:a17:902:bb81:b0:12d:a7ec:3d85 with SMTP id m1-20020a170902bb8100b0012da7ec3d85mr6655532pls.17.1634237324850;
        Thu, 14 Oct 2021 11:48:44 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y142sm3133125pfc.169.2021.10.14.11.48.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 11:48:44 -0700 (PDT)
Date:   Thu, 14 Oct 2021 18:48:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] KVM: X86: Don't reset mmu context when X86_CR4_PCIDE
 1->0
Message-ID: <YWh7iMxaGp4366Gt@google.com>
References: <20210919024246.89230-1-jiangshanlai@gmail.com>
 <20210919024246.89230-2-jiangshanlai@gmail.com>
 <YWh7RH7HXQE34sFb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWh7RH7HXQE34sFb@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 14, 2021, Sean Christopherson wrote:
> On Sun, Sep 19, 2021, Lai Jiangshan wrote:
> > From: Lai Jiangshan <laijs@linux.alibaba.com>
> > 
> > X86_CR4_PCIDE doesn't participate in kvm_mmu_role, so the mmu context
> > doesn't need to be reset.  It is only required to flush all the guest
> > tlb.
> > 
> > Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> > ---
> >  arch/x86/kvm/x86.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 86539c1686fa..7494ea0e7922 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -116,6 +116,7 @@ static void enter_smm(struct kvm_vcpu *vcpu);
> >  static void __kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
> >  static void store_regs(struct kvm_vcpu *vcpu);
> >  static int sync_regs(struct kvm_vcpu *vcpu);
> > +static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu);
> >  
> >  static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
> >  static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
> > @@ -1042,9 +1043,10 @@ EXPORT_SYMBOL_GPL(kvm_is_valid_cr4);
> >  
> >  void kvm_post_set_cr4(struct kvm_vcpu *vcpu, unsigned long old_cr4, unsigned long cr4)
> >  {
> > -	if (((cr4 ^ old_cr4) & KVM_MMU_CR4_ROLE_BITS) ||
> > -	    (!(cr4 & X86_CR4_PCIDE) && (old_cr4 & X86_CR4_PCIDE)))
> > +	if ((cr4 ^ old_cr4) & KVM_MMU_CR4_ROLE_BITS)
> >  		kvm_mmu_reset_context(vcpu);
> > +	else if (!(cr4 & X86_CR4_PCIDE) && (old_cr4 & X86_CR4_PCIDE))
> > +		kvm_vcpu_flush_tlb_guest(vcpu);
> 
> Unless there's a corner case I'm missing, I would prefer this to use
> kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu) instead of calling
> kvm_vcpu_flush_tlb_guest() directly.  The odds of flushes actually being batched
> is low, it's more to document that kvm_post_set_cr4() _isn't_ special.

Forgot to say, with the change to KVM_REQ_TLB_FLUSH_GUEST:

Reviewed-by: Sean Christopherson <seanjc@google.com>
