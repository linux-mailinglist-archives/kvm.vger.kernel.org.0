Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 946FB470514
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 17:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237810AbhLJQFd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 11:05:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237578AbhLJQFc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 11:05:32 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD468C0617A2
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 08:01:57 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id j11so8456610pgs.2
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 08:01:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NiYccNuLcNBRlC5KaB4he5MerECPJFjS2bdvaOZwdxE=;
        b=ogkDbjaAnKg5xZwOD9bqh6FZp+TRLVfLIcjKzm0RPCwEja/seXtKWbXqeBMbEWwJgP
         qEIpnceFAH50r1kbhP2C80Hp6Yc4QWtnpnfRdrLmARQS2S14pIa7QWSXTrnBBGXZvVim
         RADE8SwMmX4HxuqeZV8HyhyERMtCurKKvqTPJB8zkwTlZq4PNGvkbKUJGU/38S0QXtr/
         S0ooYd4ZObhWGasG4d5iFsgD6LQZFwN0ZVmE6pI3+pB8PFvXHBrNfhvoZXj6HJxvoWAu
         pJ/PvlOga9gjd/FpDId7xCYi1uYEb49TEF9DzjtN8JZmqKU6qk56vDLImWKBBMK0nKgF
         20gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NiYccNuLcNBRlC5KaB4he5MerECPJFjS2bdvaOZwdxE=;
        b=0H/JO2mUPYtzhAsNRGIHdkU/TsWXnyTs8lPLZWZV0McJUTtEhuxgFcBl7qqKRmriil
         rbfjZxDAPHRtO1QohxAGo+ipL09XTXiDoa8JO787OTKzep9+MME5L54udgvNgQXkdTEr
         2lP5pH2gX3mfHp6hsrc2bSwhz+GKrhLiGqvbLLmhrvzkZbVAmhunWJLD3zccbsU90tUz
         4N2MQUDldXG1ua3ds2ntZ8/MWf8kbCPHPHxqVY2B7ie66kSVEuoGKzT6lXTQFtL31suZ
         oiKRYvsCwhrIBY5PUwFPK8sGcQxV9M780WU/gFVdfysZGF6ahBQJSFgOjtoOWIdzeFBm
         8zIQ==
X-Gm-Message-State: AOAM532J7aX4Ect3lNs1/oisusk+pwU96R2rwJH1wgUG+xe+jg8Fo2OI
        6d97EjYoFXoImcbHx+oKbNPUFg==
X-Google-Smtp-Source: ABdhPJww/L2uC5TBriFHo4R9taIefxyHIVU5rsqIoQwKVt42zY+BdxT5q0u8bv70baR4ut3wwXiikg==
X-Received: by 2002:a65:6a45:: with SMTP id o5mr2860107pgu.273.1639152116894;
        Fri, 10 Dec 2021 08:01:56 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j13sm4097139pfc.151.2021.12.10.08.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 08:01:56 -0800 (PST)
Date:   Fri, 10 Dec 2021 16:01:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Subject: Re: [PATCH 1/7] KVM: x86: Retry page fault if MMU reload is pending
 and root has no sp
Message-ID: <YbN58FS67bEBOZZu@google.com>
References: <20211209060552.2956723-1-seanjc@google.com>
 <20211209060552.2956723-2-seanjc@google.com>
 <c94b3aec-981e-8557-ba29-0094b075b8e4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c94b3aec-981e-8557-ba29-0094b075b8e4@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 10, 2021, Paolo Bonzini wrote:
> On 12/9/21 07:05, Sean Christopherson wrote:
> > +	/* Special roots, e.g. pae_root, are not backed by shadow pages. */
> > +	if (sp && is_obsolete_sp(vcpu->kvm, sp))
> > +		return true;
> > +
> > +	/*
> > +	 * Roots without an associated shadow page are considered invalid if
> > +	 * there is a pending request to free obsolete roots.  The request is
> > +	 * only a hint that the current root_may_  be obsolete and needs to be
> > +	 * reloaded, e.g. if the guest frees a PGD that KVM is tracking as a
> > +	 * previous root, then __kvm_mmu_prepare_zap_page() signals all vCPUs
> > +	 * to reload even if no vCPU is actively using the root.
> > +	 */
> > +	if (!sp && kvm_test_request(KVM_REQ_MMU_RELOAD, vcpu))
> >   		return true;
> 
> Hmm I don't understand this (or maybe I do and I just don't like what I
> understand).
> 
> KVM_REQ_MMU_RELOAD is raised after kvm->arch.mmu_valid_gen is fixed (of
> course, otherwise the other CPU might just not see any obsoleted page
> from the legacy MMU), therefore any check on KVM_REQ_MMU_RELOAD is just
> advisory.

I disagree.  IMO, KVM should not be installing SPTEs into obsolete shadow pages,
which is what continuing on allows.  I don't _think_ it's problematic, but I do
think it's wrong.

> This is not a problem per se; in the other commit message you said,
> 
>     For other MMUs, the resulting behavior is far more convoluted,
>     though unlikely to be truly problematic.
> 
> but it's unnecessarily complicating the logic.  I'm more inclined to
> just play it simple and make the special roots process the page fault;
> Jiangshan's work should clean things up a bit:

Ya.

> --------- 8< -------------
> From 0c1e30d4e7e17692668d960452107f983dd2c9a9 Mon Sep 17 00:00:00 2001
> From: Paolo Bonzini <pbonzini@redhat.com>
> Date: Fri, 10 Dec 2021 07:41:02 -0500
> Subject: [PATCH] KVM: x86: Do not check obsoleteness of roots that have no sp
>  attached
> 
> The "special" roots, e.g. pae_root when KVM uses PAE paging, are not
> backed by a shadow page.  Running with TDP disabled or with nested NPT
> explodes spectaculary due to dereferencing a NULL shadow page pointer.
> Play nice with a NULL shadow page when checking for an obsolete root in
> is_page_fault_stale().
> 
> Fixes: a955cad84cda ("KVM: x86/mmu: Retry page fault if root is invalidated by memslot update")
> Cc: stable@vger.kernel.org
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Analyzed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e2e1d012df22..4a3bcdd3cfe7 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3987,7 +3987,17 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>  static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
>  				struct kvm_page_fault *fault, int mmu_seq)
>  {
> -	if (is_obsolete_sp(vcpu->kvm, to_shadow_page(vcpu->arch.mmu->root_hpa)))
> +	struct kvm_mmu_page *sp = to_shadow_page(vcpu->arch.mmu->root_hpa);
> +
> +	/*
> +	 * Special roots, e.g. pae_root, are not backed by shadow pages
> +	 * so there isn't an easy way to detect if they're obsolete.

Eh, for all intents and purposes, KVM_REQ_MMU_RELOAD very much says special roots
are obsolete.  The root will be unloaded, i.e. will no longer be used, i.e. is obsolete.

The other way to check for an invalid special root would be to treat it as obsolete
if any of its children in entries 0-3 are present and obsolete.  That would be more
precise, but it provides no benefit given KVM's current implementation.

I'm not completely opposed to doing nothing, but I do think it's silly to continue
on knowing that the work done by the page fault is all but gauranteed to be useless.

> +	 * If they are, any child SPTE created by the fault will be useless
> +	 * (they will instantly be treated as obsolete because they don't
> +	 * match the mmu_valid_gen); but they will not leak, so just play
> +	 * it simple.
> +	 */
> +	if (sp && is_obsolete_sp(vcpu->kvm, sp))
>  		return true;
>  	return fault->slot &&
