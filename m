Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D96EF4CC797
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 22:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbiCCVHG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 16:07:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbiCCVHF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 16:07:05 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC9656C31
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 13:06:18 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id k1so5832083pfu.2
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 13:06:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2YMrVvHSLKMUXF8Ea2QMnfFfSxJo6UWFNMRbgeXxqeE=;
        b=iLh9Uof2STE41+Pazpe52q7YPYnjVuXTGIKG2qt7gZLHGjyaekOqGyJmUPTkGjlS8r
         EJJfxLF4rNGL0QWrLHXsHvddL4TEef5lC3/WYctfvgDKnxG6XFTEojH6CIAfivPS9xRf
         +nPoRfrdQSjBLLFu42qbswyg2XLvxkBk7vIfxuG2mHc7QeqxK3o4BnD5zazFVMzdKAGI
         1VCbG2oVjx4iZYyDX2oP2ql6hcRvY3PX8Olk78oPlbOQZBBbjfIv4ZguX1Kqj8Rre9/8
         iLT/GYp9cLlADOltBKYpKZ2ncJzw4CmI5SGvHiSV2e00nix38oDOvY1tLFA+hne3Ik/1
         2g2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2YMrVvHSLKMUXF8Ea2QMnfFfSxJo6UWFNMRbgeXxqeE=;
        b=QqZ0fJm8GWvs0Ug8755brRGxvcGVwa8mULc0XouAGFANIdW9sTslU2Cvg/VJb9bomA
         oVpi1bj6F3iII/U6RcsSV2SdbH/SaBcW34tP7jhPafP3NZBA/MBVtrxKCgaFRlsu4i4G
         zhgNGC1cXD6nn/ZSKlzJeYZzrMLPimVOv7p8UEhT4oz7OnxDxQU2sjZMsy8idTOc7+Lv
         GAnn9ZyAAz86A92wFbNgkdxt8xVPZBHC7g96csQB0QRVEtkyqp8Z4+h5fed0f8RjqNUa
         7Vna9pEamnt0aPvMPn8U6av/eIR69zDnvg4HZwwZKM+aL6s2bej1FxoML9aQ72a/yYBO
         hUEg==
X-Gm-Message-State: AOAM531GDktaX3eTMXc+Z7wYDmpMJKCdUsrOK0dQs+x/Rl7lzHkKGL1j
        sx2aPbkCTs0Q5vT8mnObKDxfbA==
X-Google-Smtp-Source: ABdhPJyXLwATznnV51/fVrD0KmuL+No2Ds3ngqbWVyYstKSPQYxINhnVgp4v1ZDcB3OW/pvxawCUQA==
X-Received: by 2002:a05:6a00:1954:b0:4e1:f25:ce41 with SMTP id s20-20020a056a00195400b004e10f25ce41mr40083511pfk.44.1646341578069;
        Thu, 03 Mar 2022 13:06:18 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u19-20020a056a00099300b004e16e381696sm3480827pfg.195.2022.03.03.13.06.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 13:06:17 -0800 (PST)
Date:   Thu, 3 Mar 2022 21:06:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Subject: Re: [PATCH v4 21/30] KVM: x86/mmu: Zap invalidated roots via
 asynchronous worker
Message-ID: <YiEtxt6pQHtemFkm@google.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
 <20220303193842.370645-22-pbonzini@redhat.com>
 <YiErEoIMDZy94HIH@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YiErEoIMDZy94HIH@google.com>
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

On Thu, Mar 03, 2022, Sean Christopherson wrote:
> On Thu, Mar 03, 2022, Paolo Bonzini wrote:
> > +	root->tdp_mmu_async_data = kvm;
> > +	INIT_WORK(&root->tdp_mmu_async_work, tdp_mmu_zap_root_work);
> > +	queue_work(kvm->arch.tdp_mmu_zap_wq, &root->tdp_mmu_async_work);
> > +}
> > +
> > +static inline bool kvm_tdp_root_mark_invalid(struct kvm_mmu_page *page)
> > +{
> > +	union kvm_mmu_page_role role = page->role;
> > +	role.invalid = true;
> > +
> > +	/* No need to use cmpxchg, only the invalid bit can change.  */
> > +	role.word = xchg(&page->role.word, role.word);
> > +	return role.invalid;
> 
> This helper is unused.  It _could_ be used here, but I think it belongs in the
> next patch.  Critically, until zapping defunct roots creates the invariant that
> invalid roots are _always_ zapped via worker, kvm_tdp_mmu_invalidate_all_roots()
> must not assume that an invalid root is queued for zapping.  I.e. doing this
> before the "Zap defunct roots" would be wrong:
> 
> 	list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link) {
> 		if (kvm_tdp_root_mark_invalid(root))
> 			continue;
> 
> 		if (WARN_ON_ONCE(!kvm_tdp_mmu_get_root(root)));
> 			continue;
> 
> 		tdp_mmu_schedule_zap_root(kvm, root);
> 	}

Gah, lost my train of thought and forgot that this _can_ re-queue a root even in
this patch, it just can't it just can't re-queue a root that is _currently_ queued.

The re-queue scenario happens if a root is queued and zapped, but is kept alive
by a vCPU that hasn't yet put its reference.  If another memslot comes along before
the (sleeping) vCPU drops its reference, this will re-queue the root.

It's not a major problem in this patch as it's a small amount of wasted effort,
but it will be an issue when the "put" path starts using the queue, as that will
create a scenario where a memslot update (or NX toggle) can come along while a
defunct root is in the zap queue.

Checking for role.invalid is wrong (as above), so for this patch I think the
easiest thing is to use tdp_mmu_async_data as a sentinel that the root was zapped
in the past and doesn't need to be re-zapped.

/*
 * Mark each TDP MMU root as invalid to prevent vCPUs from reusing a root that
 * is about to be zapped, e.g. in response to a memslots update.  The actual
 * zapping is performed asynchronously, so a reference is taken on all roots.
 * Using a separate workqueue makes it easy to ensure that the destruction is
 * performed before the "fast zap" completes, without keeping a separate list
 * of invalidated roots; the list is effectively the list of work items in
 * the workqueue.
 *
 * Skip roots that were already queued for zapping, the "fast zap" path is the
 * only user of the zap queue and always flushes the queue under slots_lock,
 * i.e. the queued zap is guaranteed to have completed already.
 *
 * Because mmu_lock is held for write, it should be impossible to observe a
 * root with zero refcount,* i.e. the list of roots cannot be stale.
 *
 * This has essentially the same effect for the TDP MMU
 * as updating mmu_valid_gen does for the shadow MMU.
 */
void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
{
	struct kvm_mmu_page *root;

	lockdep_assert_held_write(&kvm->mmu_lock);
	list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link) {
		if (root->tdp_mmu_async_data)
			continue;

		if (WARN_ON_ONCE(!kvm_tdp_mmu_get_root(root)))
			continue;

		root->role.invalid = true;
		tdp_mmu_schedule_zap_root(kvm, root);
	}
}
