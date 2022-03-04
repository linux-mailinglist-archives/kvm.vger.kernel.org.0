Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD5C4CD8A7
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 17:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240525AbiCDQL6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 11:11:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231852AbiCDQL4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 11:11:56 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 277341C8D92
        for <kvm@vger.kernel.org>; Fri,  4 Mar 2022 08:11:09 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id v1-20020a17090a088100b001bf25f97c6eso1758351pjc.0
        for <kvm@vger.kernel.org>; Fri, 04 Mar 2022 08:11:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DIyLQIOrxe8b/7rD2cOd+7Pkicu9JYWiuSVB/t6mS0M=;
        b=dDP+V5lR4moJsIzApLZrQyQafzXYPyN5cFQk1PR0KXVqOyl6GkoTkx9Tu267sjPLtY
         SoQtcHLqo43NwjxPKpt4kXrPFVzu4M7Hml7fm023r5NE0PaS6CjUnvLjhSGx69fiegpX
         nR3NEdbrIkkvDuJLKB1HOelnskUrjqSGg4R5Zk/32PI1JwQFvJYghYw7AXpznxawTnhb
         vRSrMdMud/K11sxaWuzemLThw8BUyyvz2Hvd1jdFAfw3LprM+pYjTDAc/FYX0EJTVijH
         uMwSg6dpDmGI2C7BEUipYpyTXEjy0QbMfrxbLhzwgSKsTFA5/KW8mvGm3wV4mkOy7WSE
         TcQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DIyLQIOrxe8b/7rD2cOd+7Pkicu9JYWiuSVB/t6mS0M=;
        b=jau7zMgNf4xqeSXxHThUyGbEbqXdN9FvUNYMU26BOZ4RjhPfCxuKjCPUpoucRs7HAU
         DYyR5BgVEjvTTs6XdHVwP82a9H8hUnmI4AniAke+G4TgG/URV6jtB54qXqLq8xcKhqrl
         q+znLKHX6br3l27e1GGQVOttnFmRDwNStMOqvF+I3pqSBAh//fxbGodUiDhnSB6d9/o6
         s3P8bbS/ggn5+vNY+xUkTMghJbGHQEHBZZFVhwaWUhbQ8VjsxckHQHN95iYwVCOuU8LV
         Yl0+pQ9giUTelWfpWF7lbCro1xaYAtCQXMbn8VXFP2JfIuAsONcgBhkZlEym9v5v8SRx
         oYwg==
X-Gm-Message-State: AOAM533vwY/TrwPw+XAo9pIdqvDIjKHJ+CYwGrXbGfMZZjjXv59l1qVM
        F1QJTZc4TQB4nwz7T9CF9De8Cw==
X-Google-Smtp-Source: ABdhPJwEwj6BCMzRENnDa2/rQYeINmokB/hH/kKvN307KtluG9RtP7D7bw0BbBJs2sgqDakanier9A==
X-Received: by 2002:a17:902:cf0d:b0:14f:e424:3579 with SMTP id i13-20020a170902cf0d00b0014fe4243579mr41950027plg.74.1646410268274;
        Fri, 04 Mar 2022 08:11:08 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h13-20020a056a00230d00b004f427ffd485sm6726838pfh.143.2022.03.04.08.11.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 08:11:07 -0800 (PST)
Date:   Fri, 4 Mar 2022 16:11:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v4 18/30] KVM: x86/mmu: Zap only TDP MMU leafs in
 kvm_zap_gfn_range()
Message-ID: <YiI6GJCsJERzHB8W@google.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
 <20220303193842.370645-19-pbonzini@redhat.com>
 <YiFoi8SjWiCHax0P@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YiFoi8SjWiCHax0P@google.com>
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

On Fri, Mar 04, 2022, Mingwei Zhang wrote:
> On Thu, Mar 03, 2022, Paolo Bonzini wrote:
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index f3939ce4a115..c71debdbc732 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -834,10 +834,8 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
> >  }
> >  
> >  /*
> > - * Tears down the mappings for the range of gfns, [start, end), and frees the
> > - * non-root pages mapping GFNs strictly within that range. Returns true if
> > - * SPTEs have been cleared and a TLB flush is needed before releasing the
> > - * MMU lock.
> > + * Zap leafs SPTEs for the range of gfns, [start, end). Returns true if SPTEs
> > + * have been cleared and a TLB flush is needed before releasing the MMU lock.
> 
> I think the original code does not _over_ zapping. But the new version
> does.

No, the new version doesn't overzap.

> Will that have some side effects? In particular, if the range is
> within a huge page (or HugeTLB page of various sizes), then we choose to
> zap it even if it is more than the range.

The old version did that too.  KVM _must_ zap a hugepage that overlaps the range,
otherwise the guest would be able to access memory that has been freed/moved.  If
the operation has unmapped a subset of a hugepage, KVM needs to zap and rebuild
the portions that are still valid using smaller pages.

> Regardless of side effect, I think we probably should mention that in
> the comments?
> > -		/*
> > -		 * If this is a non-last-level SPTE that covers a larger range
> > -		 * than should be zapped, continue, and zap the mappings at a
> > -		 * lower level, except when zapping all SPTEs.
> > -		 */
> > -		if (!zap_all &&
> > -		    (iter.gfn < start ||
> > -		     iter.gfn + KVM_PAGES_PER_HPAGE(iter.level) > end) &&
> > +		if (!is_shadow_present_pte(iter.old_spte) ||
> >  		    !is_last_spte(iter.old_spte, iter.level))

It's hard to see in the diff, but the key is the "!is_last_spte()" check.  The
check before was skipping non-leaf, a.k.a. shadow pages, if they weren't in the
range.  The new version _always_ skips shadow pages.  Hugepages will always
return true for is_last_spte() and will never be skipped.
