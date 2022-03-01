Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA71D4C94A6
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 20:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236103AbiCAToH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 14:44:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233526AbiCAToG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 14:44:06 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF4136B72
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 11:43:24 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id h17so8739241plc.5
        for <kvm@vger.kernel.org>; Tue, 01 Mar 2022 11:43:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ExyEERu3AkDFampoHdGKmwAuWIWkw1zHgxCYaeTfSN0=;
        b=iC7WOxSIu8qRR6xAcrTg7odgwEG5EAsNJ70vuhK1/2ktCqiGK6Q5fecfEbHPCbL1vU
         s0coRLTxAE8Y/sAtU58Hf34ruf7TUg9YYnjbRtVH7Kvtd2L+yFM0fF84YP/YgXnH8VmT
         Cvo5CS+v41uk/YyT9L5w85Ip8v3KGWnXSM2u45NimENXcCV2PBzUWpaoH6/bFIG201De
         JIdnfF8EKtfdNvHjsQtg/B5NjcNQZnhsKDHK1KaezZrf7j08xmMIV8MKCH7j+hWnOdl4
         OypLFbXtevRXdI9CiLe79n3mG0v8ZwRAWtvciUO8T6f7tXZKu8x53p74NHuGUV3G9WQ6
         FsEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ExyEERu3AkDFampoHdGKmwAuWIWkw1zHgxCYaeTfSN0=;
        b=UdwWvYw0pC7S11xgiN5HQryYZdbqfvR7bL/vP6LALq1MupbflXJMdkmPLLCxh6x6ah
         BqgKB5YvJH0XdsGgXtgLGXozN3DlbuqRGN8Z6U9rzpjXfGACKZk6NeaT/UQfXNCHpXiL
         K/6mqc1y6lTHMnvCCm7j+k9KAwQrHfPA6BTE5R5tAYHsFJ20eLsHguDtn4Z7Rr1AcPD+
         jBXnAeg5tdfm4KYjB1vw+D4rOA4Wja6K8RIx4K+6VChYMkpr9N4cTMcQGTU74QQkjJRK
         0O/4p23MGLIxrQhA3rpSVu1BaYvSw4Bv//K8IJ1Yf9qEd/o/m09aXkAmJmocdB9Iv2va
         JbmQ==
X-Gm-Message-State: AOAM533F8Pf9g1uQD2YJZx61eRR6k9KWU7nhZnvPBHUJtwGqp2ETGeAz
        QKmR3m5llCWdxOmXoIguitEA8Q==
X-Google-Smtp-Source: ABdhPJw666GK2ejmaGUqjIlBqKH6rwDnAltZH5Hn5HVEPhH/e3a3ftZx+jwZ75PDbxamFeFfcqfZ7w==
X-Received: by 2002:a17:902:ea81:b0:14f:a4ce:ef79 with SMTP id x1-20020a170902ea8100b0014fa4ceef79mr26855032plb.136.1646163804034;
        Tue, 01 Mar 2022 11:43:24 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v189-20020a6389c6000000b00372e3b6fe90sm13856320pgd.55.2022.03.01.11.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 11:43:23 -0800 (PST)
Date:   Tue, 1 Mar 2022 19:43:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Subject: Re: [PATCH v3 20/28] KVM: x86/mmu: Allow yielding when zapping GFNs
 for defunct TDP MMU root
Message-ID: <Yh53V23gSJ6jphnS@google.com>
References: <20220226001546.360188-1-seanjc@google.com>
 <20220226001546.360188-21-seanjc@google.com>
 <28276890-c90c-e9a9-3cab-15264617ef5a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28276890-c90c-e9a9-3cab-15264617ef5a@redhat.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 01, 2022, Paolo Bonzini wrote:
> On 2/26/22 01:15, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 3031b42c27a6..b838cfa984ad 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -91,21 +91,66 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
> >   	WARN_ON(!root->tdp_mmu_page);
> > -	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> > -	list_del_rcu(&root->link);
> > -	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> > +	/*
> > +	 * Ensure root->role.invalid is read after the refcount reaches zero to
> > +	 * avoid zapping the root multiple times, e.g. if a different task
> > +	 * acquires a reference (after the root was marked invalid) and puts
> > +	 * the last reference, all while holding mmu_lock for read.  Pairs
> > +	 * with the smp_mb__before_atomic() below.
> > +	 */
> > +	smp_mb__after_atomic();
> > +
> > +	/*
> > +	 * Free the root if it's already invalid.  Invalid roots must be zapped
> > +	 * before their last reference is put, i.e. there's no work to be done,
> > +	 * and all roots must be invalidated (see below) before they're freed.
> > +	 * Re-zapping invalid roots would put KVM into an infinite loop (again,
> > +	 * see below).
> > +	 */
> > +	if (root->role.invalid) {
> > +		spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> > +		list_del_rcu(&root->link);
> > +		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> > +
> > +		call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
> > +		return;
> > +	}
> > +
> > +	/*
> > +	 * Invalidate the root to prevent it from being reused by a vCPU, and
> > +	 * so that KVM doesn't re-zap the root when its last reference is put
> > +	 * again (see above).
> > +	 */
> > +	root->role.invalid = true;
> > +
> > +	/*
> > +	 * Ensure role.invalid is visible if a concurrent reader acquires a
> > +	 * reference after the root's refcount is reset.  Pairs with the
> > +	 * smp_mb__after_atomic() above.
> > +	 */
> > +	smp_mb__before_atomic();
> 
> I have reviewed the series and I only have very minor comments... but this
> part is beyond me.  The lavish comments don't explain what is an
> optimization and what is a requirement, 

Ah, they're all requirements, but the invalid part also optimizes the case where
a root was marked invalid before its last reference was was ever put.

What I really meant to refer to by "zapping" was the entire sequence of restoring
the refcount to '1', zapping the root, and recursively re-dropping that ref.  Avoiding
that "zap" is a requirement, otherwise KVM would get stuck in an infinite loop.

> and after spending quite some time I wonder if all this should just be
> 
>         if (refcount_dec_not_one(&root->tdp_mmu_root_count))
>                 return;
> 
> 	if (!xchg(&root->role.invalid, true) {

The refcount being '1' means there's another task currently using root, marking
the root invalid will mean checks on the root's validity are non-deterministic
for the other task.  

> 	 	tdp_mmu_zap_root(kvm, root, shared);
> 
> 		/*
> 		 * Do not assume the refcount is still 1: because
> 		 * tdp_mmu_zap_root can yield, a different task
> 		 * might have grabbed a reference to this root.
> 		 *
> 	        if (refcount_dec_not_one(&root->tdp_mmu_root_count))

This is wrong, _this_ task can't drop a reference taken by the other task.

>         	        return;
> 	}
> 
> 	/*
> 	 * The root is invalid, and its reference count has reached
> 	 * zero.  It must have been zapped either in the "if" above or
> 	 * by someone else, and we're definitely the last thread to see
> 	 * it apart from RCU-protected page table walks.
> 	 */
> 	refcount_set(&root->tdp_mmu_root_count, 0);

Not sure what you intended here, KVM should never force a refcount to '0'.

> 	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> 	list_del_rcu(&root->link);
> 	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> 
> 	call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
> 
> (Yay for xchg's implicit memory barriers)

xchg() is a very good idea.  The smp_mb_*() stuff was carried over from the previous
version where this sequence set another flag in addition to role.invalid.

Is this less funky (untested)?

	/*
	 * Invalidate the root to prevent it from being reused by a vCPU while
	 * the root is being zapped, i.e. to allow yielding while zapping the
	 * root (see below).
	 *
	 * Free the root if it's already invalid.  Invalid roots must be zapped
	 * before their last reference is put, i.e. there's no work to be done,
	 * and all roots must be invalidated before they're freed (this code).
	 * Re-zapping invalid roots would put KVM into an infinite loop.
	 *
	 * Note, xchg() provides an implicit barrier to ensure role.invalid is
	 * visible if a concurrent reader acquires a reference after the root's
	 * refcount is reset.
	 */
	if (xchg(root->role.invalid, true))
		spin_lock(&kvm->arch.tdp_mmu_pages_lock);
		list_del_rcu(&root->link);
		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);

		call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
		return;
	}


