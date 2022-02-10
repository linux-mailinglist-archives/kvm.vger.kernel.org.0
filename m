Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 817F04B023B
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 02:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbiBJB2a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 20:28:30 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:55296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232518AbiBJB14 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 20:27:56 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F0CF20199
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 17:27:47 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id c5-20020a17090a1d0500b001b904a7046dso5426294pjd.1
        for <kvm@vger.kernel.org>; Wed, 09 Feb 2022 17:27:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Yudl84hMQxfLHFinLSXzC02VLhYOexhpsfOokm5q7zI=;
        b=iFEW70mUyIL6xFZqNc3fyWHhA7kZK7m5jhoBEudtRgQuUlpyo3hymoFzHKr9RsO6/+
         NdEDJ00DowKRMIYQeISCJHTZ4mbIR5iP+hFQL8F17u1pOwXluhTtTtioMNMC60aY7nzC
         7FKKeheDXxy54qnX0IiS0kzvvEZufRLroLR5LVUPYKxeWFODnbwJ/93kvpDJyHV5RySB
         /9C/1IZTvdzM15USHlH1Awi4btfqLsxH9U99a4mXqV4TC1gswlZYuX8r2dXAqZIlJLTS
         6+/O9OH8A1wLHV0i58r75smombgDabG6r0Re34kGoX2hTQBvSKL632T9mRl6xQm7OhP3
         xfhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Yudl84hMQxfLHFinLSXzC02VLhYOexhpsfOokm5q7zI=;
        b=jyeSMyjDsD9WYuITdf3yOCPGX00POJ+Qfd08yq/VqyJLpfWLqy6pygRQmAlU6kRCaF
         jd92OJJ9RF3Kc+fYj1tHnBKDkAx6iuWQdYc3apmSf/Nv9Ts9WdsQ9hOu1r5agDpItB8d
         WPC4xIThHfAj4LOZu4KsR5WFBZ8/3tVs+HLq8GQcguC/y3YMit3urTbyNLGKSXnM9P2o
         W0yIlStOLJyMPxf7SZlrL30WTqlxGK5Gr6Iqs2zB7DsfQTOylUA72vS8i8xw3fpLFn9d
         Bx7GQU1NpmJIcM7wo3GEWqFsPMyY2DybYhw8eS8NHZFCI/skCZFOa9QWQkE76QCXnzY7
         lCsw==
X-Gm-Message-State: AOAM531LDaEkZ5A/xXWTRzffavQMIi0evD3UgH9pf8qiJ/5o/nI29GeX
        jpf/PIBm5WWHBvx3JxzZlGHYHrdG2wUozA==
X-Google-Smtp-Source: ABdhPJxrU1x5K4f/mXLdxnZ6HovUenwDypXBS9OnT3ytekHe8lLu1VHAQBCI4PBjKjp+rrZhlhUtiA==
X-Received: by 2002:a17:902:6905:: with SMTP id j5mr4775844plk.145.1644453012311;
        Wed, 09 Feb 2022 16:30:12 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id i3sm5521002pgq.65.2022.02.09.16.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 16:30:11 -0800 (PST)
Date:   Thu, 10 Feb 2022 00:30:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, vkuznets@redhat.com
Subject: Re: [PATCH 01/23] KVM: MMU: pass uses_nx directly to
 reset_shadow_zero_bits_mask
Message-ID: <YgRckLixnxa7hLqB@google.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
 <20220204115718.14934-2-pbonzini@redhat.com>
 <Yf1pk1EEBXj0O0/p@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yf1pk1EEBXj0O0/p@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 04, 2022, David Matlack wrote:
> On Fri, Feb 04, 2022 at 06:56:56AM -0500, Paolo Bonzini wrote:
> > reset_shadow_zero_bits_mask has a very unintuitive way of deciding
> > whether the shadow pages will use the NX bit.  The function is used in
> > two cases, shadow paging and shadow NPT; shadow paging has a use for
> > EFER.NX and needs to force it enabled, while shadow NPT only needs it
> > depending on L1's setting.
> > 
> > The actual root problem here is that is_efer_nx, despite being part
> > of the "base" role, only matches the format of the shadow pages in the
> > NPT case.  For now, just remove the ugly variable initialization and move
> > the call to reset_shadow_zero_bits_mask out of shadow_mmu_init_context.
> > The parameter can then be removed after the root problem in the role
> > is fixed.
> > 
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> Reviewed-by: David Matlack <dmatlack@google.com>
> 
> (I agree this commit makes no functional change.)

There may not be a functional change, but it drops an optimization and contributes
to making future code/patches more fragile due to making it harder to understand
the relationship between shadow_mmu_init_context() and __kvm_mmu_new_pgd().

> > @@ -4829,8 +4820,6 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
> >  
> >  	reset_guest_paging_metadata(vcpu, context);
> >  	context->shadow_root_level = new_role.base.level;
> > -
> > -	reset_shadow_zero_bits_mask(vcpu, context);

This is guarded by:

	if (new_role.as_u64 == context->mmu_role.as_u64)
		return;

> >  }
> >  
> >  static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
> > @@ -4841,6 +4830,16 @@ static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
> >  		kvm_calc_shadow_mmu_root_page_role(vcpu, regs, false);
> >  
> >  	shadow_mmu_init_context(vcpu, context, regs, new_role);
> > +
> > +	/*
> > +	 * KVM uses NX when TDP is disabled to handle a variety of scenarios,
> > +	 * notably for huge SPTEs if iTLB multi-hit mitigation is enabled and
> > +	 * to generate correct permissions for CR0.WP=0/CR4.SMEP=1/EFER.NX=0.
> > +	 * The iTLB multi-hit workaround can be toggled at any time, so assume
> > +	 * NX can be used by any non-nested shadow MMU to avoid having to reset
> > +	 * MMU contexts.  Note, KVM forces EFER.NX=1 when TDP is disabled.
> > +	 */
> > +	reset_shadow_zero_bits_mask(vcpu, context, true);

Whereas this will compute the mask even if the role doesn't change.  I say that
matters later on because then this sequence:

	shadow_mmu_init_context(vcpu, context, &regs, new_role);
	reset_shadow_zero_bits_mask(vcpu, context, is_efer_nx(context));
	__kvm_mmu_new_pgd(vcpu, nested_cr3, new_role.base);

becomes even more difficult to untangle.

And looking at where this series ends up, I don't understand the purpose of this
change.  Patch 18 essentially reverts this patch, and I see nothing in between
that will break without the temporary change.   That patch becomes:

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 02e6d256805d..f9c96de1189d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4408,7 +4408,7 @@ static void reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
         * NX can be used by any non-nested shadow MMU to avoid having to reset
         * MMU contexts.  Note, KVM forces EFER.NX=1 when TDP is disabled.
         */
-       bool uses_nx = is_efer_nx(context) || !tdp_enabled;
+       bool uses_nx = context->mmu_role.efer_nx;

        /* @amd adds a check on bit of SPTEs, which KVM shouldn't use anyways. */
        bool is_amd = true;

though it needs to update the comment as well.

> >  }
> >  
> >  static union kvm_mmu_role
> > @@ -4872,6 +4871,7 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
> >  	__kvm_mmu_new_pgd(vcpu, nested_cr3, new_role.base);
> >  
> >  	shadow_mmu_init_context(vcpu, context, &regs, new_role);
> > +	reset_shadow_zero_bits_mask(vcpu, context, is_efer_nx(context));
> 
> Out of curiousity, how does KVM mitigate iTLB multi-hit when shadowing
> NPT and the guest has not enabled EFER.NX?
> 
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_init_shadow_npt_mmu);
> >  
> > -- 
> > 2.31.1
> > 
> > 
