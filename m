Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82BE04BFE0F
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 17:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233853AbiBVQGf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 11:06:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233103AbiBVQGd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 11:06:33 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF3E15E6F7
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 08:06:07 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id p23so17419288pgj.2
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 08:06:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PN4lGesTddnviow4r7+6lHJGeDLnN2ibNu20g6SO+W8=;
        b=bd9jAe2Ajpm0SbuymJgd5XzFpvbGC/nFQjBZnnAP9tjCupBKMUq8fb2sT+X8tXHwWK
         fK3u2LrpIuQ1Z4fBuSGfbJSTgM4PEm+gy7zTpXg5yS+popTcthDE4godvVduUFm11rYB
         V75lkrpO8svhs1GwpvRn/jJ0Yc6DBI3pEKZWrqOdKOaGXlexWnNm7nfc/FjfkqKJwsa/
         0+6oZDOHvWN15RMrJ3OorCPwdaCz50EjozS0UZTjqjBPvjsLyOeskDvcS1XjVCdZY8eO
         6+PSSXOq+lsjeVVmV5N9YF4sPJGay7/F+3N+XoQNS69/bPUzLHIxgA5rxHNGO5MJKCEE
         naQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PN4lGesTddnviow4r7+6lHJGeDLnN2ibNu20g6SO+W8=;
        b=OeLXMmJ1Lj41AbQ7dPiXj2FKSywlz1IjlIDL90lLcr6aCrgiXlDMLHTDsTw4DbBgO+
         xZvLfcLuWGJIxOA2Ovb757d68WbW+sYWYq/XUz0a5LrNFYz9oD0rOKaNWOqkO1XmB0ri
         s0dO2GBBEEBknRJ6euB8PVsEQ3eaX+4J8P7dOxOvtPp/a1bfCOFp3pGzExswGkhgut0R
         p2IzVdV+aFVZuTQqooQXIDmTWa8dG8VKI8ouOvr6RNus9NsVlmm0bKdhW8OmCngOHCXf
         cCAq0l079FWkiMQAoDy/22uFMeWa3kESa7dFXaP5J9R+g3vB7JcYChsPYCEto2CuNXIP
         iWug==
X-Gm-Message-State: AOAM530Um/EKt5l+3HM1TNfj2TYW2JpP42p7BnNGfIchWW37YM61pZP8
        YBWSwm298fQyruzjS5ODGYwjSQ==
X-Google-Smtp-Source: ABdhPJwoZVFynaQa1koWl8gYVG5hYGSrPIiZ2t9n4gjnBu7W31CxJfDuB8hnd1EjMl7yKZ43+HL5Jg==
X-Received: by 2002:aa7:8882:0:b0:4e1:4531:e3c8 with SMTP id z2-20020aa78882000000b004e14531e3c8mr25411097pfe.76.1645545966769;
        Tue, 22 Feb 2022 08:06:06 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id o8sm18481834pfu.90.2022.02.22.08.06.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 08:06:06 -0800 (PST)
Date:   Tue, 22 Feb 2022 16:06:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 16/18] KVM: x86: introduce KVM_REQ_MMU_UPDATE_ROOT
Message-ID: <YhUJ6ojNQShwpZjv@google.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
 <20220217210340.312449-17-pbonzini@redhat.com>
 <YhATewkkO/l4P9UN@google.com>
 <7741eeb1-183c-b465-e0f1-852b47a98780@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7741eeb1-183c-b465-e0f1-852b47a98780@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Feb 19, 2022, Paolo Bonzini wrote:
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

Yeah, I'm referring to kvm_mmu_new_pgd().

> > I strongly prefer that we take a more conservative approach and fix 7+8, and then
> > tackle 1, 3, and 4+5 separately if someone cares enough about those flows to avoid
> > dropping roots.
> 
> The thing is, I want to get rid of kvm_mmu_reset_context() altogether. I
> dislike the fact that it kills the roots but still keeps them in the hash
> table, thus relying on separate syncing to avoid future bugs.  It's very
> unintuitive what is "reset" and what isn't.

I agree with all of the above, I just don't think that forcing the issue is going
to be a net positive in the long run.

> > Regarding KVM_REQ_MMU_RELOAD, that mess mostly goes away with my series to replace
> > that with KVM_REQ_MMU_FREE_OBSOLETE_ROOTS.  Obsolete TDP MMU roots will never get
> > a cache hit because the obsolete root will have an "invalid" role.  And if we care
> > about optimizing this with respect to a memslot (highly unlikely), then we could
> > add an MMU generation check in the cache lookup.  I was planning on posting that
> > series as soon as this one is queued, but I'm more than happy to speculatively send
> > a refreshed version that applies on top of this series.
> 
> Yes, please send a version on top of patches 1-13.  That can be reviewed and
> committed in parallel with the root_role changes.

Will do.
