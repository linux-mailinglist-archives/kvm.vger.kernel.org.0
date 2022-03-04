Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73EAA4CDCDA
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 19:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241822AbiCDSnO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 13:43:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241803AbiCDSmy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 13:42:54 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5918D1D67C5
        for <kvm@vger.kernel.org>; Fri,  4 Mar 2022 10:42:06 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id ev16-20020a17090aead000b001bc3835fea8so8766852pjb.0
        for <kvm@vger.kernel.org>; Fri, 04 Mar 2022 10:42:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cs84OhdNH2h7DgkARusgjaWFEIKoZx5AjRkQCrMC5j8=;
        b=aGTrtWvd6UH8YtfZkGtNoARnSHTSDh4UY4tZDZNvJMlmEFkJYxhIcvMXqACOkW0g1v
         1IokoBvPvg16zTC1EsWQaK+oPkEZcjs15eO6NagRnYaVHPN8pSbmatDwCZ6NX+IfEUYI
         633XmQx2WpExkByBWzDqXNqhTOohAnUEf8FkhEM2veK2S3XCqK7C4IBSzeRxiHMuRi6U
         d7smNDELCqEQ/gyS3qlGj43skkygkHgB27Xs2NKpq/gHyGBvdhGl/A4nRKeWFSHwkePh
         E5jHjvbR8YxqwmNHmeukyR2qTz9arG2DhfVCc2i3MPzI0DumhvZxGR2kXeZZiGdITy8I
         OIfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cs84OhdNH2h7DgkARusgjaWFEIKoZx5AjRkQCrMC5j8=;
        b=nXWCXnN0kXoRTbbOZpedtqU4EHIeNCNWIyEbSPVjQlNfXofoePTk48DkDges+gEjtN
         u4tFVoV1+gCFNJtUp/tpmBsKceRP7tSMW/aXsFmpBH9EvJI+iEgGlibIj8E5DMarhMc0
         sM5Bf70HaMojDg4LCL/3v7h1kOks5wy1d28F5tRZItO3jUfLlju4asz1Re3GkYnEMZTi
         0NzTaByPgBCAlJ6uxWdJfFs8me/tUbzH/w53/xelcr5kYaqrzlb233v2qjKYev5NIBgP
         +RTILXAVI3MMalFE7RfHFHt4zVMRFcH1fvVXJiSnnJaw6XRD3E7X/TrsigPFDDt8qPlt
         +lQQ==
X-Gm-Message-State: AOAM5316rb1XFBKWx0hiBr6yOLIx0A36c2gTzUodDbhfgmi4Fb6ULhh+
        AIngmcy1k95V8wWHq3wlzmZrww==
X-Google-Smtp-Source: ABdhPJzUsAIKeeCKEhl8wC2iesiNcUfoqK1dobXEn8en9HwCN6ybgeB4VDiXEXBij2JMHDjc3am+xA==
X-Received: by 2002:a17:902:da91:b0:151:8e79:8307 with SMTP id j17-20020a170902da9100b001518e798307mr17407834plx.8.1646419325660;
        Fri, 04 Mar 2022 10:42:05 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id mu1-20020a17090b388100b001bedddf2000sm5471903pjb.14.2022.03.04.10.42.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 10:42:04 -0800 (PST)
Date:   Fri, 4 Mar 2022 18:42:01 +0000
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
Message-ID: <YiJdeaW7bLGmjSuf@google.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
 <20220303193842.370645-19-pbonzini@redhat.com>
 <YiFoi8SjWiCHax0P@google.com>
 <YiI6GJCsJERzHB8W@google.com>
 <YiJTyYIyBvGoczw+@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YiJTyYIyBvGoczw+@google.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 04, 2022, Mingwei Zhang wrote:
> On Fri, Mar 04, 2022, Sean Christopherson wrote:
> > On Fri, Mar 04, 2022, Mingwei Zhang wrote:
> > > On Thu, Mar 03, 2022, Paolo Bonzini wrote:
> > > > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > > > index f3939ce4a115..c71debdbc732 100644
> > > > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > > > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > > > @@ -834,10 +834,8 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
> > > >  }
> > > >  
> > > >  /*
> > > > - * Tears down the mappings for the range of gfns, [start, end), and frees the
> > > > - * non-root pages mapping GFNs strictly within that range. Returns true if
> > > > - * SPTEs have been cleared and a TLB flush is needed before releasing the
> > > > - * MMU lock.
> > > > + * Zap leafs SPTEs for the range of gfns, [start, end). Returns true if SPTEs
> > > > + * have been cleared and a TLB flush is needed before releasing the MMU lock.
> > > 
> > > I think the original code does not _over_ zapping. But the new version
> > > does.
> > 
> > No, the new version doesn't overzap.
> 
> It does overzap, but it does not matter and the semantic does not
> change.

Belaboring the point a bit... it very much matters, KVM must "overzap" for functional
correctness.  It's only an "overzap" from the perspective that KVM could thoeretically
shatter the hugepage then zap only the relevant small pages.  But it's not an overzap
in the sense that KVM absolutely has to zap the hugepage.  Even if KVM replaces it
with a shadow page, the hugepage is still being zapped, i.e. it's gone and KVM must do
a TLB flush regardless of whether or not there's a new mapping.
