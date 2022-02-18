Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 048F54BC24A
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 22:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239998AbiBRVpz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 16:45:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239992AbiBRVpy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 16:45:54 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0480725598
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 13:45:36 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id v13-20020a17090ac90d00b001b87bc106bdso13469732pjt.4
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 13:45:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JaeagXxuhD2kZkRTgNU1zWFrxImSXnIIvtWnxMCwcII=;
        b=Z1InYZJUStPQfviXgRDxLvua+UzOg5hswh4ibXD4czbaWWyBsrcAzuSsfUPetpYalb
         DS7vUjapdjku+Gh2MHu2Wua86gda6pxyUM66Nb5BvlXMNd5JGAHKqKwNLMGoGM/TntR+
         eKtGDs8udPDqha5/fk2j9UHLIrgcBjBuqDwhS1lifkfdg5mJs6f2eXXcA8mWCFEV7+Mk
         HUCXNTnYqbxTQ3voqdwipD46Rnjb6QtJPOiwIyDhbK02c9s4R0Qe0gNPdh4AUptcoWzc
         qddvkElPn7oyCBaxP1tAAdrIuNDmoSUAlcZBhJWXMKAXXuPosdTTBpfMgIfMfQaHMhBn
         UJLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JaeagXxuhD2kZkRTgNU1zWFrxImSXnIIvtWnxMCwcII=;
        b=x84dStfZ05HWvmTl3EAd6TN6ROOwByCkqSc1d3nBmdH2So7LMlYBcFI0Rn+nKcaEoP
         aMtuUCISrGaIvrJwlPbzVOQ55mGqpcjgeMsUBvpbzAfJr49DgnacwjIucFdfT6QnAbL8
         yWczA2XZutSr31pbT5WUPbO3L+oxE5Hj7nXg1KWRSFOb4B49Mxv/h4LCUeqe+dYwz+M6
         apXDgQPYCRzKX/aVrPHlRbix6H08t+6FddFMNTR+ajwh+61clgFmetDT3UdC+ScbtHLP
         k5CUGiqtZgHVrzYYLBKPEzt7dIVGKmZGs6fKzMg5byC1XNe+0TBZdN5nHrzVygO0GLG0
         DFMA==
X-Gm-Message-State: AOAM5300I+7FzwJtjgtemIGA0tOmPR3IEtG+RyVzWtXDCZpif77Gkie8
        hJ52qick9YtI8y0ViGuCPgCI0RbmVyP3AA==
X-Google-Smtp-Source: ABdhPJzqy+w0T5SGh21c6mr3YpBl5xDnECIpD9YzhBbG/uqEBUmA/IZ+Fig7ly1Bf4z5b3EyFdOUhQ==
X-Received: by 2002:a17:90b:104:b0:1b8:d212:9b8e with SMTP id p4-20020a17090b010400b001b8d2129b8emr14495377pjz.11.1645220735923;
        Fri, 18 Feb 2022 13:45:35 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id pg1sm299689pjb.31.2022.02.18.13.45.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 13:45:35 -0800 (PST)
Date:   Fri, 18 Feb 2022 21:45:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 16/18] KVM: x86: introduce KVM_REQ_MMU_UPDATE_ROOT
Message-ID: <YhATewkkO/l4P9UN@google.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
 <20220217210340.312449-17-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220217210340.312449-17-pbonzini@redhat.com>
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

On Thu, Feb 17, 2022, Paolo Bonzini wrote:
> Whenever KVM knows the page role flags have changed, it needs to drop
> the current MMU root and possibly load one from the prev_roots cache.
> Currently it is papering over some overly simplistic code by just
> dropping _all_ roots, so that the root will be reloaded by
> kvm_mmu_reload, but this has bad performance for the TDP MMU
> (which drops the whole of the page tables when freeing a root,
> without the performance safety net of a hash table).
> 
> To do this, KVM needs to do a more kvm_mmu_update_root call from
> kvm_mmu_reset_context.  Introduce a new request bit so that the call
> can be delayed until after a possible KVM_REQ_MMU_RELOAD, which would
> kill all hopes of finding a cached PGD.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Please no.

I really, really do not want to add yet another deferred-load in the nested
virtualization paths.  As Jim pointed out[1], KVM_REQ_GET_NESTED_STATE_PAGES should
never have been merged. And on that point, I've no idea how this new request will
interact with KVM_REQ_GET_NESTED_STATE_PAGE.  It may be a complete non-issue, but
I'd honestly rather not have to spend the brain power.

And I still do not like the approach of converting kvm_mmu_reset_context() wholesale
to not doing kvm_mmu_unload().  There are currently eight kvm_mmu_reset_context() calls:

  1.   nested_vmx_restore_host_state() - Only for a missed VM-Entry => VM-Fail
       consistency check, not at all a performance concern.

  2.   kvm_mmu_after_set_cpuid() - Still needs to unload.  Not a perf concern.

  3.   kvm_vcpu_reset() - Relevant only to INIT.  Not a perf concern, but could be
       converted manually to a different path without too much fuss.

  4+5. enter_smm() / kvm_smm_changed() - IMO, not a perf concern, but again could
       be converted manually if anyone cares.

  6.   set_efer() - Silly corner case that basically requires host userspace abuse
       of KVM APIs.  Not a perf concern.

  7+8. kvm_post_set_cr0/4() - These are the ones we really care about, and they
       can be handled quite trivially, and can even share much of the logic with
       kvm_set_cr3().

I strongly prefer that we take a more conservative approach and fix 7+8, and then
tackle 1, 3, and 4+5 separately if someone cares enough about those flows to avoid
dropping roots.

Regarding KVM_REQ_MMU_RELOAD, that mess mostly goes away with my series to replace
that with KVM_REQ_MMU_FREE_OBSOLETE_ROOTS.  Obsolete TDP MMU roots will never get
a cache hit because the obsolete root will have an "invalid" role.  And if we care
about optimizing this with respect to a memslot (highly unlikely), then we could
add an MMU generation check in the cache lookup.  I was planning on posting that
series as soon as this one is queued, but I'm more than happy to speculatively send
a refreshed version that applies on top of this series.

[1] https://lore.kernel.org/all/CALMp9eT2cP7kdptoP3=acJX+5_Wg6MXNwoDh42pfb21-wdXvJg@mail.gmail.com
[2] https://lore.kernel.org/all/20211209060552.2956723-1-seanjc@google.com
