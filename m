Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 710FD575419
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 19:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232593AbiGNRfH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 13:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234085AbiGNRfD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 13:35:03 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00495F9B4
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 10:34:59 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id l124so2459207pfl.8
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 10:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+UmeF/zKy2EgY/Ayp0ssdqVszmHBG40XC+IoVrGUUC8=;
        b=TtTfFW50heWz3M9KmxpIh5ZORSxDEqdFk/6cZryo6xJ24fHcNAQul/WdDaJ2NOzxvN
         bjY2uLV1sfBNc+UqEWjQ64T3gKKRFKM8XzUd9o5VSG6TFIKivhhtjowpmcXXFpa8a+vj
         fztns+Y5GE4Ntm5tDH8iiSJGnLnXe+MwJCatnWi7hPb+81oY7mud/1VhFRoKup7AxL2t
         KynkRq48LT9HSW+eDx56DEh93P86qkdOYzFGx/Gl9sfiM0zEfDK3ieIhMuzB9WrpAqh0
         WX0EdSW1ivvNTxdzRluVBeg6sInXRN1Xpw7O+ukoWxhPq86RjaaapxclxjvIQGrea+bq
         nyNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+UmeF/zKy2EgY/Ayp0ssdqVszmHBG40XC+IoVrGUUC8=;
        b=2afQdiGBVIFUk2yyxOwz32SEXFIVEtsVP/tU6IoHfp9BLG34BJro/BrgXUhZHhW8gK
         eS1zqJ7QU4vkmEqecEeNcdPQ4g6Fj5z3Ezt9A99RIfQNPSLEH3dthqxKSW7xXHqLCyKW
         grk4kzYQO201Es8kZOqXuxaeynF9LNGV1Zn2W8KfOehxz6K2P4mOdVMaxz1s2GIFs0fT
         jnRxGkukjww9M3aHGRUFrraggjQcrL4FX9DTcLbvgnHt+7hICjlvD3uWP3yIC/1KZN3k
         byremTkA+KyK0CeUTJupED3RXEoH04uRJfZq8sOR2mLsDeVNiyhhx4S1M4zBoQw1JQpY
         jDww==
X-Gm-Message-State: AJIora99HLgIqDyacUOheZJk46bxTpZpbZ+Oozjy0DZMWYabFL8l4fFu
        6ireQglMZ7t6daXwCqaR24isww==
X-Google-Smtp-Source: AGRyM1vMS0BYzCICryLdhnZpwZ/tZ8VfMPREYr7Rc1DD1+INoY0hqkDBjpk2sqmML/l3SQwg/E7EvA==
X-Received: by 2002:a63:5810:0:b0:40d:77fb:1c25 with SMTP id m16-20020a635810000000b0040d77fb1c25mr8578514pgb.570.1657820099344;
        Thu, 14 Jul 2022 10:34:59 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id u1-20020a634701000000b004168945bdf4sm1565942pga.66.2022.07.14.10.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 10:34:58 -0700 (PDT)
Date:   Thu, 14 Jul 2022 17:34:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] KVM: x86: Clean up rmap zap helpers
Message-ID: <YtBTv4IVPtb+aXQV@google.com>
References: <20220712015558.1247978-1-seanjc@google.com>
 <bc2c1af3-33ec-d97e-f604-12a991c7cd5e@redhat.com>
 <YtBR/x3CAEavwzMI@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtBR/x3CAEavwzMI@google.com>
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

On Thu, Jul 14, 2022, Sean Christopherson wrote:
> On Thu, Jul 14, 2022, Paolo Bonzini wrote:
> > On 7/12/22 03:55, Sean Christopherson wrote:
> > > Clean up the rmap helpers (mostly renames) to yield a more coherent set of
> > > APIs, and to purge the irritating and inconsistent "rmapp" (p is for pointer)
> > > nomenclature.
> > > 
> > > Patch 1 is a tangentially related fix for a benign bug.
> > > 
> > > Sean Christopherson (5):
> > >    KVM: x86/mmu: Return a u64 (the old SPTE) from
> > >      mmu_spte_clear_track_bits()
> > >    KVM: x86/mmu: Rename rmap zap helpers to better show relationships
> > >    KVM: x86/mmu: Remove underscores from __pte_list_remove()
> > >    KVM: x86/mmu: Use innermost rmap zap helper when recycling rmaps
> > >    KVM: x86/mmu: Drop the "p is for pointer" from rmap helpers
> > > 
> > >   arch/x86/kvm/mmu/mmu.c | 73 +++++++++++++++++++++---------------------
> > >   1 file changed, 36 insertions(+), 37 deletions(-)
> > > 
> > > 
> > > base-commit: b9b71f43683ae9d76b0989249607bbe8c9eb6c5c
> > 
> > I'm not sure I dig the ____, I'll take a closer look tomorrow or next week
> > since it's dinner time here.
> 
> Yeah, I'm not a fan of it either.  And rereading things, my proposed names also
> create an inconsistency; the zap path is the only user of kvm_handle_gfn_range()
> that uses a plural "rmaps".
> 
>   $ git grep kvm_handle_gfn_range
>   arch/x86/kvm/mmu/mmu.c:static __always_inline bool kvm_handle_gfn_range(struct kvm *kvm,
>   arch/x86/kvm/mmu/mmu.c:         flush = kvm_handle_gfn_range(kvm, range, kvm_zap_rmaps);
>   arch/x86/kvm/mmu/mmu.c:         flush = kvm_handle_gfn_range(kvm, range, kvm_set_pte_rmap);
>   arch/x86/kvm/mmu/mmu.c:         young = kvm_handle_gfn_range(kvm, range, kvm_age_rmap);
>   arch/x86/kvm/mmu/mmu.c:         young = kvm_handle_gfn_range(kvm, range, kvm_test_age_rmap);
> 
> Make "rmaps" plural is probably a mistake.  The helper zaps multiple SPTEs for a
> given rmap list, but from a certain point of view it's just a single "rmap".
> 
> What about:
> 
>   kvm_zap_rmapp => kvm_zap_rmap    // to align with kvm_handle_gfn_range() usage
>   kvm_zap_rmap  => __kvm_zap_rmap  // to pair with kvm_zap_rmap()
>   
> and
> 
>   pte_list_remove  => kvm_zap_one_rmap_spte  
>   pte_list_destroy => kvm_zap_all_rmap_sptes
> 
> That will yield a better series too, as I can move patch 5 to be patch 2, then
> split what was patch 2 (the rename) into separate patches to first align kvm_zap_rmap()
> and __kvm_zap_rmap(), and then rename the pte_list_remove/destroy helpers.

And also:

  __kvm_zap_rmaps => kvm_rmap_zap_gfn_range

instead of renaming it to __kvm_zap_gfn_range() to make it clear that it zaps only
rmap-based MMUs, to align with kvm_rmap_zap_collapsible_sptes(), and to avoid the
plural "rmaps".
