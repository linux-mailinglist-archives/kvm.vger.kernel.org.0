Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAA634CB02B
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 21:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244251AbiCBUsT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 15:48:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237054AbiCBUsQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 15:48:16 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C152412601
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 12:47:31 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id i1so2629131plr.2
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 12:47:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=w2++eX0uxoFYGn6KsfxgmKtFhWBbHG1cFniS6G65R/8=;
        b=ZvIT3UHrIkyHs392SzCJH5dcOt5KKLuzWyEeIFZOeA2qaJiPK7ton6Y6Lr1ivan4Js
         UzcI337HwVIoduHg/JgXtl2CQGrDZmUSf3ucbmrtJ6IgtSvNqsQw36nM9FV52EIaWM4b
         nNaiaF1+GKtFMTHQmBdtFfqVv6D55x5mgDz3jaj/0PN4CGVqdFbUWNqbbt7gXCxUwNEZ
         da1NehZYGkvWBSXYrG4bJB5le52dQRBSQDyWXcguuRqdmtaZ4BLJPrvK2Xn/b+IdPCLb
         oKjS+t4qWNIvM64IklH38agjF+NntHojUc4Pfaf5e5zzZCaWU8He9HomqZ7O07yFoHYc
         1kCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=w2++eX0uxoFYGn6KsfxgmKtFhWBbHG1cFniS6G65R/8=;
        b=oZKHyL10FbE0kz+Uvj2Qg6IHsJR8mFnBu8uYSCw+2Cd7OGaHxAnP5oqS5bdHOyz/NB
         5RGG4W6TpLxqJcLQdUcgk+/Sg68KRsbF/0C1GStNhgdkQpGHURGLmj0DDl9q/38fYQvs
         yPePr7DwzWOiNNusM8mGwgRZz+d4BFrBXFJ5x6QFwTqVL/nlLQbJREjkySzV8b7WFXbs
         a3a22lT/hmigoKc31xh3u0QdgZeV8guhMaHav6NRVrzW/ebraqnqTPMCY1nbXn3mVSTN
         z1obkZdZ7phcr7/sS7Q5acZjc+uLCdzQi/v1geb2FOxS8xYC+Jgf0aodt9z5QyhiokAt
         9Elg==
X-Gm-Message-State: AOAM5335vyELHejZfm4TZAfcMAP0eq51hMiVwPtlace6pOosXetEncuh
        jFOcaPYcWYB8uLhwRqplY8URjg==
X-Google-Smtp-Source: ABdhPJxkbHtoXR7YSBFfm/MXCJjH0S84GP7djHmq1H20YYhQpwJ2f0WnZE7RRove22yTCjGhMKM0DQ==
X-Received: by 2002:a17:90b:4595:b0:1be:db22:8327 with SMTP id hd21-20020a17090b459500b001bedb228327mr1644495pjb.99.1646254051075;
        Wed, 02 Mar 2022 12:47:31 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v23-20020a17090a521700b001bbfc181c93sm5892971pjh.19.2022.03.02.12.47.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 12:47:30 -0800 (PST)
Date:   Wed, 2 Mar 2022 20:47:26 +0000
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
Subject: Re: [PATCH v3 22/28] KVM: x86/mmu: Zap defunct roots via
 asynchronous worker
Message-ID: <Yh/X3m1rjYaY2s0z@google.com>
References: <20220226001546.360188-1-seanjc@google.com>
 <20220226001546.360188-23-seanjc@google.com>
 <b9270432-4ee8-be8e-8aa1-4b09992f82b8@redhat.com>
 <Yh+xA31FrfGoxXLB@google.com>
 <f4189f26-eff9-9fd0-40a1-69ac7759dedf@redhat.com>
 <Yh/GoUPxMRyFqFc5@google.com>
 <442859af-6454-b15e-b2ad-0fc7c4e22909@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <442859af-6454-b15e-b2ad-0fc7c4e22909@redhat.com>
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

On Wed, Mar 02, 2022, Paolo Bonzini wrote:
> On 3/2/22 20:33, Sean Christopherson wrote:
> > What about that idea?  Put roots invalidated by "fast zap" on_another_  list?
> > My very original idea of moving the roots to a separate list didn't work because
> > the roots needed to be reachable by the mmu_notifier.  But we could just add
> > another list_head (inside the unsync_child_bitmap union) and add the roots to
> > _that_  list.
> 
> Perhaps the "separate list" idea could be extended to have a single worker
> for all kvm_tdp_mmu_put_root() work, and then indeed replace
> kvm_tdp_mmu_zap_invalidated_roots() with a flush of _that_ worker.  The
> disadvantage is a little less parallelism in zapping invalidated roots; but
> what is good for kvm_tdp_mmu_zap_invalidated_roots() is just as good for
> kvm_tdp_mmu_put_root(), I suppose.  If one wants separate work items, KVM
> could have its own workqueue, and then you flush that workqueue.
> 
> For now let's do it the simple but ugly way.  Keeping
> next_invalidated_root() does not make things worse than the status quo, and
> further work will be easier to review if it's kept separate from this
> already-complex work.

Oof, that's not gonna work.  My approach here in v3 doesn't work either.  I finally
remembered why I had the dedicated tdp_mmu_defunct_root flag and thus the smp_mb_*()
dance.

kvm_tdp_mmu_zap_invalidated_roots() assumes that it was gifted a reference to
_all_ invalid roots by kvm_tdp_mmu_invalidate_all_roots().  This works in the
current code base only because kvm->slots_lock is held for the entire duration,
i.e. roots can't become invalid between the end of kvm_tdp_mmu_invalidate_all_roots()
and the end of kvm_tdp_mmu_zap_invalidated_roots().

Marking a root invalid in kvm_tdp_mmu_put_root() breaks that assumption, e.g. if a
new root is created and then dropped, it will be marked invalid but the "fast zap"
will not have a reference.  The "defunct" flag prevents this scenario by allowing
the "fast zap" path to identify invalid roots for which it did not take a reference.
By virtue of holding a reference, "fast zap" also guarantees that the roots it needs
to invalidate and put can't become defunct.

My preference would be to either go back to a variant of v2, or to implement my
"second list" idea.  

I also need to figure out why I didn't encounter errors in v3, because I distinctly
remember underflowing the refcount before adding the defunct flag...
