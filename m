Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAA34C3056
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 16:51:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236383AbiBXPu7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 10:50:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233510AbiBXPu6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 10:50:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B2461D95D0
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 07:50:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645717827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jp/yMSlTvn3D/56VwEvq7WNBshS3m5GAHPXYoUU32sE=;
        b=NJUfQnIax2LcnOX7qb9D8IVIfgj7jIfV9mTqe10YKUeMFtTyjuzeVwreMFDayZ73Clf0UW
        20Xz9+k++6UK4h6emiUSrnlbLwLk9eX5Bdmqfsfke08dcpqxGEjlz5jXYK3aFU5FgcCYcM
        t43Fp7L1E3UHzx+qpL+wttvaJNV27dY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-392-6d4sK7tmOqqUhq6WKZ0tsA-1; Thu, 24 Feb 2022 10:50:26 -0500
X-MC-Unique: 6d4sK7tmOqqUhq6WKZ0tsA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B2D5801AB2;
        Thu, 24 Feb 2022 15:50:24 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CEBD98379C;
        Thu, 24 Feb 2022 15:50:22 +0000 (UTC)
Message-ID: <0c006613de3f809049dd021a84f50d76b4c9c73e.camel@redhat.com>
Subject: Re: [PATCH v2 16/18] KVM: x86: introduce KVM_REQ_MMU_UPDATE_ROOT
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Thu, 24 Feb 2022 17:50:21 +0200
In-Reply-To: <7741eeb1-183c-b465-e0f1-852b47a98780@redhat.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
         <20220217210340.312449-17-pbonzini@redhat.com>
         <YhATewkkO/l4P9UN@google.com>
         <7741eeb1-183c-b465-e0f1-852b47a98780@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-02-19 at 08:54 +0100, Paolo Bonzini wrote:
> On 2/18/22 22:45, Sean Christopherson wrote:
> > On Thu, Feb 17, 2022, Paolo Bonzini wrote:
> > > Whenever KVM knows the page role flags have changed, it needs to drop
> > > the current MMU root and possibly load one from the prev_roots cache.
> > > Currently it is papering over some overly simplistic code by just
> > > dropping _all_ roots, so that the root will be reloaded by
> > > kvm_mmu_reload, but this has bad performance for the TDP MMU
> > > (which drops the whole of the page tables when freeing a root,
> > > without the performance safety net of a hash table).
> > > 
> > > To do this, KVM needs to do a more kvm_mmu_update_root call from
> > > kvm_mmu_reset_context.  Introduce a new request bit so that the call
> > > can be delayed until after a possible KVM_REQ_MMU_RELOAD, which would
> > > kill all hopes of finding a cached PGD.
> > > 
> > > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > > ---
> > 
> > Please no.
> > 
> > I really, really do not want to add yet another deferred-load in the nested
> > virtualization paths.
> 
> This is not a deferred load, is it?  It's only kvm_mmu_new_pgd that is 
> deferred, but the PDPTR load is not.
> 
> I think I should first merge patches 1-13, then revisit the root_role 
> series (which only depends on the fast_pgd_switch and caching changes), 
> and then finally get back to this final part.  The reason is that 
> root_role is what enables the stale-root check that you wanted; and it's 
> easier to think about loading the guest PGD post-kvm_init_mmu if I can 
> show you the direction I'd like to have in general, and not leave things 
> half-done.
> 
> (Patch 17 is also independent and perhaps fixing a case of premature 
> optimization, so I'm inclined to merge it as well).
> 
> > As Jim pointed out[1], KVM_REQ_GET_NESTED_STATE_PAGES should
> > never have been merged. And on that point, I've no idea how this new request will
> > interact with KVM_REQ_GET_NESTED_STATE_PAGE.  It may be a complete non-issue, but
> > I'd honestly rather not have to spend the brain power.
> 
> Fair enough on the interaction, but I still think 
> KVM_REQ_GET_NESTED_STATE_PAGES is a good idea.  I don't think KVM should 
> access guest memory outside KVM_RUN, though there may be cases (possibly 
> some PV MSRs, if I had to guess) where it does.

KVM_REQ_GET_NESTED_STATE_PAGES is a real source of bugs, and a burden to maintain,
I fixed too many bugs in it, and it will only get worse with time, not to mention,
that without any proper tests, we are bound to access guest memory on
setting the nested state without anybody noticing.


Best regards,
	Maxim Levitsky

> 
> > And I still do not like the approach of converting kvm_mmu_reset_context() wholesale
> > to not doing kvm_mmu_unload().  There are currently eight kvm_mmu_reset_context() calls:
> > 
> >    1.   nested_vmx_restore_host_state() - Only for a missed VM-Entry => VM-Fail
> >         consistency check, not at all a performance concern.
> > 
> >    2.   kvm_mmu_after_set_cpuid() - Still needs to unload.  Not a perf concern.
> > 
> >    3.   kvm_vcpu_reset() - Relevant only to INIT.  Not a perf concern, but could be
> >         converted manually to a different path without too much fuss.
> > 
> >    4+5. enter_smm() / kvm_smm_changed() - IMO, not a perf concern, but again could
> >         be converted manually if anyone cares.
> > 
> >    6.   set_efer() - Silly corner case that basically requires host userspace abuse
> >         of KVM APIs.  Not a perf concern.
> > 
> >    7+8. kvm_post_set_cr0/4() - These are the ones we really care about, and they
> >         can be handled quite trivially, and can even share much of the logic with
> >         kvm_set_cr3().
> > 
> > I strongly prefer that we take a more conservative approach and fix 7+8, and then
> > tackle 1, 3, and 4+5 separately if someone cares enough about those flows to avoid
> > dropping roots.
> 
> The thing is, I want to get rid of kvm_mmu_reset_context() altogether. 
> I dislike the fact that it kills the roots but still keeps them in the 
> hash table, thus relying on separate syncing to avoid future bugs.  It's 
> very unintuitive what is "reset" and what isn't.
> 
> > Regarding KVM_REQ_MMU_RELOAD, that mess mostly goes away with my series to replace
> > that with KVM_REQ_MMU_FREE_OBSOLETE_ROOTS.  Obsolete TDP MMU roots will never get
> > a cache hit because the obsolete root will have an "invalid" role.  And if we care
> > about optimizing this with respect to a memslot (highly unlikely), then we could
> > add an MMU generation check in the cache lookup.  I was planning on posting that
> > series as soon as this one is queued, but I'm more than happy to speculatively send
> > a refreshed version that applies on top of this series.
> 
> Yes, please send a version on top of patches 1-13.  That can be reviewed 
> and committed in parallel with the root_role changes.
> 
> Paolo
> 
> > [1] https://lore.kernel.org/all/CALMp9eT2cP7kdptoP3=acJX+5_Wg6MXNwoDh42pfb21-wdXvJg@mail.gmail.com
> > [2] https://lore.kernel.org/all/20211209060552.2956723-1-seanjc@google.com


