Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9763D580847
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 01:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237265AbiGYXdV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 19:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237421AbiGYXdS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 19:33:18 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7876126AF2
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 16:33:17 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id q22so6539208pgt.9
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 16:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZQyRxqGM1W/LS0ssRps7WJXXzo4kRUKS7bNZtUe51CI=;
        b=nD1BmdVcHA3I/t+9230v3W5nFsOePTrhYHGv1QgVncGS6DjjdzdUlg0mB28F2w17he
         wLIwFt2t1dozuJkNbrYtPWRQKfBx2GA6EQRPMLVO5IBGIyYkvHpjqIa6DwjXaLl15cks
         o1vVz7YidMp46YVb/IJoMUHFevN7f18woJ3vqb1msw37nMZ1WMQDEUfiCZekJKT2B3g+
         /V4sFLBnFXPB7bJpDxO1U8rWzwNquDh13PZXl2rPZVcUBUgi5Vp7svlCGze6dANvD2Ow
         eZI6QTIWPbeTOhqOGkng55MBfyQiuvBtWJwJA4h6yEK8FAfmGad8EtpVPzP9xiMtjFmc
         JcSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZQyRxqGM1W/LS0ssRps7WJXXzo4kRUKS7bNZtUe51CI=;
        b=Jk+nMWeCMJTUNe9JKXDfafizLSqPJeK3++zmS6+c7jZUlGmwCniUABgJYOZMlpm9m+
         XF9W+zeT4xKbZ3NB0gD7HdwuNu/VjRsGQF9J6AmfBadcDxW6eKzGMhr0CgPgVtnQAc+G
         mZ9qRzNcpMTj7cbLN0nYiqcxmhGjEF9vUhXX1dFpWCOCdCerNDTDrVwm+4PEr3Lc32pM
         bb6V0viFigqzha/DsLrlfQhsob7BkQWWUslUYpDp6bX2gpTxzPjWsMXg56CORRSAEFDl
         tCaB4gSEFzl+WFQ1cZmJWZ4zW77I/ebVXsvFwd4aKD5k0+0fYEehtyfEAGK5Dwiysb0a
         jKMQ==
X-Gm-Message-State: AJIora/oFh1oDrtZ4hOweSqhqp9+vpnaE5u6Sc5oAFMIH3rvC9giKbPD
        8R8AkCEiaomhpyL6r4mx35WIGg==
X-Google-Smtp-Source: AGRyM1sMXhCPTxflahi4xB99ucQ9r1TYGMPJzX8LIjoubSDlVEHm0UejmNXeAe5WrFC09nN3obvhWQ==
X-Received: by 2002:a05:6a00:134e:b0:52a:d5b4:19bb with SMTP id k14-20020a056a00134e00b0052ad5b419bbmr14826941pfu.45.1658791996740;
        Mon, 25 Jul 2022 16:33:16 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a8-20020a17090a6d8800b001f24c08c3fesm7573683pjk.1.2022.07.25.16.33.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 16:33:16 -0700 (PDT)
Date:   Mon, 25 Jul 2022 23:33:12 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2 5/6] KVM: x86/mmu: Add helper to convert SPTE value to
 its shadow page
Message-ID: <Yt8oOHvNO2nnBQwM@google.com>
References: <20220723012325.1715714-1-seanjc@google.com>
 <20220723012325.1715714-6-seanjc@google.com>
 <Yt8mCI7MFhZbT+5R@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yt8mCI7MFhZbT+5R@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 25, 2022, David Matlack wrote:
> On Sat, Jul 23, 2022 at 01:23:24AM +0000, Sean Christopherson wrote:
> > Add a helper to convert a SPTE to its shadow page to deduplicate a
> > variety of flows and hopefully avoid future bugs, e.g. if KVM attempts to
> > get the shadow page for a SPTE without dropping high bits.
> > 
> > Opportunistically add a comment in mmu_free_root_page() documenting why
> > it treats the root HPA as a SPTE.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> [...]
> > --- a/arch/x86/kvm/mmu/spte.h
> > +++ b/arch/x86/kvm/mmu/spte.h
> > @@ -207,6 +207,23 @@ static inline int spte_index(u64 *sptep)
> >   */
> >  extern u64 __read_mostly shadow_nonpresent_or_rsvd_lower_gfn_mask;
> >  
> > +static inline struct kvm_mmu_page *to_shadow_page(hpa_t shadow_page)
> > +{
> > +	struct page *page = pfn_to_page((shadow_page) >> PAGE_SHIFT);
> > +
> > +	return (struct kvm_mmu_page *)page_private(page);
> > +}
> > +
> > +static inline struct kvm_mmu_page *spte_to_sp(u64 spte)
> > +{
> > +	return to_shadow_page(spte & SPTE_BASE_ADDR_MASK);
> > +}
> 
> spte_to_sp() and sptep_to_sp() are a bit hard to differentiate visually.

Yeah, I balked a bit when making the change, but couldn't come up with a better
alternative.

> Maybe spte_to_child_sp() or to_child_sp()?

I like to_child_sp().  Apparently I have a mental block when it comes to parent
vs. child pages and never realized that sptep_to_sp() gets the "parent" but
spte_to_sp() gets the "child".  That indeed makes spte_to_sp() a bad name.

