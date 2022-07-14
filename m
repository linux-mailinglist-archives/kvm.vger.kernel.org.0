Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9197C575408
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 19:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239522AbiGNR1h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 13:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238905AbiGNR1d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 13:27:33 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2729B5F128
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 10:27:32 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id v4-20020a17090abb8400b001ef966652a3so9237445pjr.4
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 10:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=utH2IS/VTX5JTS0QLCXRVyshNaT5RNL5Nc+i8BDtLmk=;
        b=rF12YwCEfFYueQbJLNdKUdSIPn3X/JN/wNW9JmI7PR/QSVfskRk9FLorv09enmrJEt
         yere3bNl9k4wIiAy3UIFX0nhGyeL3iiGzOo2xq5kJmAnDswrTOs6XPnVlRD4QWiQVwqr
         K1xBzJ0W/PDTuXHhjpGY7naObopY8/99iO1nXeOpgjmKlZUu05KTMg4j5BpdP5+oKLdN
         sR+Di65OwzZDZGewiMDnB8pr79dCMheqPr7XCMwS5NhOJKExYEDtSjDpfzAxDTWp89BU
         ET586gz+4uGrx4JfHzaZY/s1jVKBQbHZYv6l+rfWTc1+MEX+8vffY7kdUGBXWMUrwTnZ
         WLlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=utH2IS/VTX5JTS0QLCXRVyshNaT5RNL5Nc+i8BDtLmk=;
        b=ho1JkPkMOQ3u4Q/45cIjUxiGMP+O+bxRMG/UZqEL1l9iCc2lHyHUL8FwCo6SgDfnuh
         0+RCpQx+zVi6jqKYeMtHSg7tM0f1K7I9s8YQc5oI8PE5I/6d82WhdbmFa797ECDQxJaX
         wm70zE/iYGXkvuxeDHLVML+3X0hxfVWZiLNAvPk1zB5+vczM/7DsYlgW1krTDWMVfWQ1
         ccXuJcXwL1jgno+XUmkh/yZmb72GBtB2tsYLbQbLIuYRwLOz7LPoZ/9ZTdBQGQzTfKUJ
         xbuCSwAtpcpiiRKbLYtrizl6PX6ydYwQuIenmbzJiALTwiNZTwCHLHT/bl420xwfTzMT
         zCFQ==
X-Gm-Message-State: AJIora/K7sQf97XvAL3OZr1bBENVw3SZqscNLi05ExlgDlwC7QVCMDwv
        Ob/qrQq3dvpuvk44uoT/FaicBw==
X-Google-Smtp-Source: AGRyM1tZbMvh/IPB79aNcE/pjioSN87QQMJthXMeW7P+2OiAXSUEst9UtSeRYRzH1N/wOQJpKs+fAw==
X-Received: by 2002:a17:903:244d:b0:16c:52f1:ceb with SMTP id l13-20020a170903244d00b0016c52f10cebmr9808645pls.120.1657819651493;
        Thu, 14 Jul 2022 10:27:31 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id ik5-20020a170902ab0500b00168b113f222sm1726733plb.173.2022.07.14.10.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 10:27:30 -0700 (PDT)
Date:   Thu, 14 Jul 2022 17:27:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] KVM: x86: Clean up rmap zap helpers
Message-ID: <YtBR/x3CAEavwzMI@google.com>
References: <20220712015558.1247978-1-seanjc@google.com>
 <bc2c1af3-33ec-d97e-f604-12a991c7cd5e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc2c1af3-33ec-d97e-f604-12a991c7cd5e@redhat.com>
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

On Thu, Jul 14, 2022, Paolo Bonzini wrote:
> On 7/12/22 03:55, Sean Christopherson wrote:
> > Clean up the rmap helpers (mostly renames) to yield a more coherent set of
> > APIs, and to purge the irritating and inconsistent "rmapp" (p is for pointer)
> > nomenclature.
> > 
> > Patch 1 is a tangentially related fix for a benign bug.
> > 
> > Sean Christopherson (5):
> >    KVM: x86/mmu: Return a u64 (the old SPTE) from
> >      mmu_spte_clear_track_bits()
> >    KVM: x86/mmu: Rename rmap zap helpers to better show relationships
> >    KVM: x86/mmu: Remove underscores from __pte_list_remove()
> >    KVM: x86/mmu: Use innermost rmap zap helper when recycling rmaps
> >    KVM: x86/mmu: Drop the "p is for pointer" from rmap helpers
> > 
> >   arch/x86/kvm/mmu/mmu.c | 73 +++++++++++++++++++++---------------------
> >   1 file changed, 36 insertions(+), 37 deletions(-)
> > 
> > 
> > base-commit: b9b71f43683ae9d76b0989249607bbe8c9eb6c5c
> 
> I'm not sure I dig the ____, I'll take a closer look tomorrow or next week
> since it's dinner time here.

Yeah, I'm not a fan of it either.  And rereading things, my proposed names also
create an inconsistency; the zap path is the only user of kvm_handle_gfn_range()
that uses a plural "rmaps".

  $ git grep kvm_handle_gfn_range
  arch/x86/kvm/mmu/mmu.c:static __always_inline bool kvm_handle_gfn_range(struct kvm *kvm,
  arch/x86/kvm/mmu/mmu.c:         flush = kvm_handle_gfn_range(kvm, range, kvm_zap_rmaps);
  arch/x86/kvm/mmu/mmu.c:         flush = kvm_handle_gfn_range(kvm, range, kvm_set_pte_rmap);
  arch/x86/kvm/mmu/mmu.c:         young = kvm_handle_gfn_range(kvm, range, kvm_age_rmap);
  arch/x86/kvm/mmu/mmu.c:         young = kvm_handle_gfn_range(kvm, range, kvm_test_age_rmap);

Make "rmaps" plural is probably a mistake.  The helper zaps multiple SPTEs for a
given rmap list, but from a certain point of view it's just a single "rmap".

What about:

  kvm_zap_rmapp => kvm_zap_rmap    // to align with kvm_handle_gfn_range() usage
  kvm_zap_rmap  => __kvm_zap_rmap  // to pair with kvm_zap_rmap()
  
and

  pte_list_remove  => kvm_zap_one_rmap_spte  
  pte_list_destroy => kvm_zap_all_rmap_sptes

That will yield a better series too, as I can move patch 5 to be patch 2, then
split what was patch 2 (the rename) into separate patches to first align kvm_zap_rmap()
and __kvm_zap_rmap(), and then rename the pte_list_remove/destroy helpers.
