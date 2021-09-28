Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6D041BA4F
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 00:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243291AbhI1W0S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 18:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243153AbhI1W0G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 18:26:06 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D66BEC0617BC
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 15:23:45 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id bb10so130936plb.2
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 15:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=l3yJFNQhpQQjT2n8nhSzgm70VdXRHR0GUh1aWIMK9Ro=;
        b=JjW3Rw/QrbkmGlARc27sQqxhIAPzCby5xWxB1R7jDVX754jpM/k051X4gtAsrdW+Lm
         rUbJRoCrYARJ6sLIndnkY7cizuKAWPEtiMBDhbgMm8Gb+FMLvmfcPI6JrGSv1+d2wdLL
         nddphNljETjJrPo5pxvlmqw9k264MKM5g5ktkOCcpIfynFmd6y39DVKtvNFflfgxf2s2
         qjecxZztBVXr/RYy1s9rEPbmi36RAHFr6uxOrDflfX5S+HdKxdw6sjodcfaQ5Dan8tTV
         TCpYs+yibX3VpTb1pJ1DfCZdpWLTfll9M3rCvMlT3bUGnyIAiZfEfRUy4DJ7zr0HvQQe
         2aUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=l3yJFNQhpQQjT2n8nhSzgm70VdXRHR0GUh1aWIMK9Ro=;
        b=mDxBD6h5I0w3iH4l5uzxhCKfzCk2LXSdRcYjfQn35tqFfZ3/RgQBSroX/yge9qui3h
         l4F0BoozQJE5ABnl4NSj8Twha4AmPK/P2UFAwWJHD900cP/gZ39vt5L5LXjRrzKt/NW9
         aGSATqX0NyGTE7aiY1cW7SZt3zfqRB40hmuAzDmzS1FX8oms47Sqn5WLWuWqV4g0jlR5
         N2brWO4pLlzI+04pRgyBK6ivAZzOXmSPXVRATEMsc28ih3GWEYYgYGEwHFVJyMJLva2J
         0LlYljOOev1jtbaVkEa55Ap5XenVbLyEFEyuPYgWpb7RZ40GbDRFugJ+5IbftCbVwt4i
         ZJpw==
X-Gm-Message-State: AOAM530iJHaIstGLjycOYGKXNxUmzdbwsueZkokXuEKRpP4S4V+zF1Ny
        +7Ammd/MpmLWOMrtb54LTUN3rQ==
X-Google-Smtp-Source: ABdhPJzDHGOPtyMLQUah+/AinT9/mI/VC/378GrrgAQ2xdT7wY98L55jHudOrKTbZqVa9ZZzSEcaBw==
X-Received: by 2002:a17:90a:e16:: with SMTP id v22mr2556179pje.209.1632867825079;
        Tue, 28 Sep 2021 15:23:45 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id in23sm3455680pjb.57.2021.09.28.15.23.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 15:23:44 -0700 (PDT)
Date:   Tue, 28 Sep 2021 22:23:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] nSVM: introduce smv->nested.save to cache save
 area fields
Message-ID: <YVOV7EucFzF5S6So@google.com>
References: <20210903102039.55422-1-eesposit@redhat.com>
 <20210903102039.55422-3-eesposit@redhat.com>
 <fbb40bb8c12715c0aa9d6a113784f8a21603e2b3.camel@redhat.com>
 <82acae8f-6b27-928f-0c00-1df8fc9d26b8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82acae8f-6b27-928f-0c00-1df8fc9d26b8@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 28, 2021, Paolo Bonzini wrote:
> On 12/09/21 12:39, Maxim Levitsky wrote:
> > On Fri, 2021-09-03 at 12:20 +0200, Emanuele Giuseppe Esposito wrote:
> > > This is useful in next patch, to avoid having temporary
> > > copies of vmcb12 registers and passing them manually.
> > 
> > This is NOT what I had in mind, but I do like that idea very much,
> > IMHO this is much better than what I had in mind!
> > 
> > The only thing that I would change is that I woudn't reuse 'struct vmcb_save_area'
> > for the copy, as this both wastes space (minor issue),
> > and introduces a chance of someone later using non copied
> > fields from it (can cause a bug later on).
> > 
> > I would just define a new struct for that (but keep same names
> > for readability)
> > 
> > Maybe something like 'struct vmcb_save_area_cached'?
> 
> I agree, I like this too.  However, it needs a comment that this new struct
> is not kept up-to-date, and is only valid until enter_svm_guest_mode.
> 
> I might even propose a
> 
> #ifdef CONFIG_DEBUG_KERNEL
> 	memset(&svm->nested.save, 0xaf, sizeof(svm->nested.save));
> #endif
> 
> but there are no uses of CONFIG_DEBUG_KERNEL in all of Linux so it's
> probably not the way one should use that symbol.  Can anybody think of a
> similar alternative?  Or should the memset simply be unconditional?

I still think this doesn't go far enough to prevent TOCTOU bugs, and in general
KVM lacks a coherent design/approach in this area.  Case in point, the next patch
fails to handle at least one, probably more, TOCTOU bugs.  CR3 is checked using
KVM's copy (svm->nested.save)

	/*
	 * These checks are also performed by KVM_SET_SREGS,
	 * except that EFER.LMA is not checked by SVM against
	 * CR0.PG && EFER.LME.
	 */
	if ((save->efer & EFER_LME) && (save->cr0 & X86_CR0_PG)) {
		if (CC(!(save->cr4 & X86_CR4_PAE)) ||
		    CC(!(save->cr0 & X86_CR0_PE)) ||
		    CC(kvm_vcpu_is_illegal_gpa(vcpu, save->cr3)))
			return false;
	}

but KVM prepares vmcb02 and the MMU using the CR3 value directly from vmcb12.

	nested_vmcb02_prepare_control(svm);
	nested_vmcb02_prepare_save(svm, vmcb12);

	ret = nested_svm_load_cr3(&svm->vcpu, vmcb12->save.cr3,
				  nested_npt_enabled(svm), true);

I assume there is similar badness in nested_vmcb02_prepare_save()'s usage of
vmcb12, but even if there isn't, IMO that it's even a question/possibility means
KVM is broken.  I.e. KVM should fully unmap L1's vmcb12 before doing _anything_.
(1) map, (2) copy, (3) unmap, (4) check, (5) consume.  Yes, there are performance
gains to be had (or lost), but we need a fully correct/functional baseline before
we start worrying about performance.  E.g. the copy at step (2) can be optimized
to copy only data that is not marked cleaned, but first we should have a version
of KVM that has no optimizations and just copies the entire vmcb (or at least the
chunks KVM consumes).

On a related topic, this would be a good opportunity to resolve the naming
discrepancies between VMX and SVM.  VMX generally refers to vmcs12 as KVM's copy
of L1's VMCS, whereas SVM generally refers to vmcb12 as the "direct" mapping of
L1's VMCB.  I'd prefer to go with VMX's terminology, i.e. rework nSVM to refer to
the copy as vmcb12, but I'm more than a bit biased since I've spent so much time
in nVMX,
