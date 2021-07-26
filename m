Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB0B3D6981
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 00:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233735AbhGZVqF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 17:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233598AbhGZVqE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jul 2021 17:46:04 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EDD2C061760
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 15:26:32 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id b6so14961957pji.4
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 15:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=namYQKEc6LjfFvdKjDiOTBAhTTq2wubKpAbKYJtluho=;
        b=Tf7/UpuUHCzOzpn1MHiobXdYtueM1adXTDyJ+B92y7AXNJh2VymNx8fCTH9w39StlG
         uNZS/XdU3r+t7gJlVY5nDC3fSSlWFxFN73frVsuQkZcJKqSUf9ByYnnxQG7rhGQ4Istm
         mBcyPCx1VHtAQatEMISUG7gK7L1/1ZAT8SQrgdh2/h613c3BIzYmQWS1oxfifDRd0Kqo
         yph7gxu88wBbg6/Bthm/TgxT5mpzWt1iBSC0qVehMlpnc54gd8bfkmACRYjEF3KL3pRL
         HDGy2jP0GprMnVOjDbAdoUQFWsNzHm9FIBUD82je2IbBYBIYQEK9Hq1j5njEEL4Jfnu+
         l5QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=namYQKEc6LjfFvdKjDiOTBAhTTq2wubKpAbKYJtluho=;
        b=cYqW89IUhZ7T76J8PyWG+QvtyrAgtNYNtzzkiyphHVi7J9vDt2fN1sCPg62jw9A74e
         70RuBdaBCZh65zhQFwg2FT1C1C/wZ5sGi3eWThy35g8nOT9HOk7g1/k3HF6pg9dRLLFK
         CnaYom6pW8KMbUwrLOigepQvA2wElU6LLsJqxn7Gq0mjo658N6JXz2lC0VLtoK9xriFv
         Hseq3qvn6yhes0/HLopunyCY4ix0b1qfrMlQ6l5TzmOZusweHhHJQg+VEztRBNR4+cCu
         edaM5xTWgdyfPGd0pHsfoPa7NQofU2hAtkc+5lwWtDovEHIckfwbl9fVRoYp/TepEoWX
         7OuA==
X-Gm-Message-State: AOAM530GAgqU4nYsaoiwHn0LI4KZDt1S7BYl09yWq6AiL5SvorE/5rPk
        uADA2acLWzMkumdr+06PlXK6hg==
X-Google-Smtp-Source: ABdhPJwIl//DRIpBqIbeyPbRpKgDw5po7Z1hKl9ZMS0lZqsZwxi6f1kr5btHlZjyG/v/bDOENrrqVQ==
X-Received: by 2002:a17:90b:17c5:: with SMTP id me5mr505322pjb.46.1627338391901;
        Mon, 26 Jul 2021 15:26:31 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q21sm1080436pff.55.2021.07.26.15.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 15:26:31 -0700 (PDT)
Date:   Mon, 26 Jul 2021 22:26:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v2 09/46] KVM: SVM: Drop a redundant init_vmcb() from
 svm_create_vcpu()
Message-ID: <YP82lPKKy3hLv1de@google.com>
References: <20210713163324.627647-1-seanjc@google.com>
 <20210713163324.627647-10-seanjc@google.com>
 <77b78927-77ca-39b8-8882-458fc3ec9ba8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77b78927-77ca-39b8-8882-458fc3ec9ba8@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 26, 2021, Paolo Bonzini wrote:
> On 13/07/21 18:32, Sean Christopherson wrote:
> > Drop an extra init_vmcb() from svm_create_vcpu(), svm_vcpu_reset() is
> > guaranteed to call init_vmcb() and there are no consumers of the VMCB
> > data between ->vcpu_create() and ->vcpu_reset().  Keep the call to
> > svm_switch_vmcb() as sev_es_create_vcpu() touches the current VMCB, but
> > hoist it up a few lines to associate the switch with the allocation of
> > vmcb01.
> > 
> > Reviewed-by: Reiji Watanabe <reijiw@google.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/x86/kvm/svm/svm.c | 4 +---
> >   1 file changed, 1 insertion(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 44248548be7d..cef9520fe77f 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -1431,15 +1431,13 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
> >   	svm->vmcb01.ptr = page_address(vmcb01_page);
> >   	svm->vmcb01.pa = __sme_set(page_to_pfn(vmcb01_page) << PAGE_SHIFT);
> > +	svm_switch_vmcb(svm, &svm->vmcb01);
> >   	if (vmsa_page)
> >   		svm->vmsa = page_address(vmsa_page);
> >   	svm->guest_state_loaded = false;
> > -	svm_switch_vmcb(svm, &svm->vmcb01);
> > -	init_vmcb(vcpu);
> > -
> >   	svm_init_osvw(vcpu);
> >   	vcpu->arch.microcode_version = 0x01000065;
> 
> While this patch makes sense, I'd rather not include it to reduce the part
> of the code in which svm->vmcb is NULL.

Not sure I follow.  The svm_switch_vmcb() is kept, and even moved earlier.
