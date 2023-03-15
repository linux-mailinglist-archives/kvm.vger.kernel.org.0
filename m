Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0FE86BB7E1
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 16:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232480AbjCOPcz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 11:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231881AbjCOPcy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 11:32:54 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97C761E9CA
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 08:32:52 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id w5-20020a253005000000b00aedd4305ff2so20947274ybw.13
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 08:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678894371;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3TNqbTHQHmb2xkVyzid8TSYw/6ySfy0Rm3ZyMjb8K6Q=;
        b=OndTXsXmttnpBFbJTuj797Wr6Hb4uuRGsMxUUd4ZPEwngST2tq9jgqAbWGLkyoc3UF
         RUhNZhfsUQkTDYDwqU0/dV6JxWw+2ynyRmSEyI9Bwl+jseJfVeeW8gwLYFAhBZkUi1BZ
         Rjj2jXSvFfBsYnidGAkG4GJa5P/xduE4cZra/84msBr8gC3W7KhT495aCnKxRRdA4IIK
         43oHM+cyZfvAjiOrOoUR5FIcSA7otu9nwtxqBXBgNK3Oo5TKpFRdN2xa7qP1kSKnHJFw
         Z1bOTZoSAkx8hsqeuessy3+j2lwr6e+TM98ortsV9xdt+nOgsmHrWRNygXFqTvbbzcTi
         wdxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678894371;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3TNqbTHQHmb2xkVyzid8TSYw/6ySfy0Rm3ZyMjb8K6Q=;
        b=3Y2otQLpTYatYkgDlTVUw6QP5zl/hRWQ6hnfEfbMjsr5dqY1cxwalwXTGvJKRiXQ19
         hxwl6u6XehLBumKkgNAKIjE6h6bj7V33P1Yf4Fa+sjy7qkkjX6X4OCM42M74aI1lLxAr
         OV4z5d1SZp9iES/i5Dw4dOjoMj7FK6BJ08Dk6mr1SXl4/FH7YHH7HGFt6l4KH5sYJwke
         hN3fCfmofzzoOsLE9op1L/ty7nSFAq9A/Z7aEli/nCLnThrzl69PMUn9640Hf6zFvkRB
         ynFYkRm+g9awnvpAYbTamxvglSXm2Lb3CF06Lh96V042JcA4ulrl6MjrrJDYYuBZ+7K+
         3P7w==
X-Gm-Message-State: AO0yUKVHghuxeUPBsyEnuBk2AppHzhXJZNSiVjdQBJDj6mmFtSjDPn7B
        n20GKadezHqQWGUL0HLw/MPAlGszO5A=
X-Google-Smtp-Source: AK7set/iYt7e9mDhQyRut6LZI+RQO0U18hEgJBTShOBJit1b59iuVZXxUV2vD+RNR86XdMZiKEiV0PP1XPI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1205:b0:b3e:c715:c313 with SMTP id
 s5-20020a056902120500b00b3ec715c313mr2265866ybu.6.1678894371838; Wed, 15 Mar
 2023 08:32:51 -0700 (PDT)
Date:   Wed, 15 Mar 2023 08:32:50 -0700
In-Reply-To: <ZBEanQaJTCkjcDOn@yzhao56-desk.sh.intel.com>
Mime-Version: 1.0
References: <20230311002258.852397-1-seanjc@google.com> <20230311002258.852397-12-seanjc@google.com>
 <ZBEanQaJTCkjcDOn@yzhao56-desk.sh.intel.com>
Message-ID: <ZBHlIuhED8y3JIu1@google.com>
Subject: Re: [PATCH v2 11/27] KVM: x86/mmu: Don't rely on page-track mechanism
 to flush on memslot change
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, kvm@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 15, 2023, Yan Zhao wrote:
> On Fri, Mar 10, 2023 at 04:22:42PM -0800, Sean Christopherson wrote:
> ...
> > -static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
> > -			struct kvm_memory_slot *slot,
> > -			struct kvm_page_track_notifier_node *node)
> > -{
> > -	kvm_mmu_zap_all_fast(kvm);
> > -}
> > -
> >  int kvm_mmu_init_vm(struct kvm *kvm)
> >  {
> >  	struct kvm_page_track_notifier_node *node = &kvm->arch.mmu_sp_tracker;
> > @@ -6110,7 +6103,6 @@ int kvm_mmu_init_vm(struct kvm *kvm)
> >  	}
> >  
> >  	node->track_write = kvm_mmu_pte_write;
> > -	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
> >  	kvm_page_track_register_notifier(kvm, node);
> >  
> >  	kvm->arch.split_page_header_cache.kmem_cache = mmu_page_header_cache;
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index f706621c35b8..29dd6c97d145 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -12662,6 +12662,8 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
> >  void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
> >  				   struct kvm_memory_slot *slot)
> >  {
> > +	kvm_mmu_zap_all_fast(kvm);
> Could we still call kvm_mmu_invalidate_zap_pages_in_memslot() here?
> As I know, for TDX, its version of
> kvm_mmu_invalidate_zap_pages_in_memslot() is like
> 
> static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
>                         struct kvm_memory_slot *slot,
>                         struct kvm_page_track_notifier_node *node)
> {
>         if (kvm_gfn_shared_mask(kvm))
>                 kvm_mmu_zap_memslot(kvm, slot);
>         else
>                 kvm_mmu_zap_all_fast(kvm);
> }
> 
> Maybe this kind of judegment is better to be confined in mmu.c?

Hmm, yeah, I agree.  The only reason I exposed kvm_mmu_zap_all_fast() is because
kvm_mmu_zap_all() is already exposed for kvm_arch_flush_shadow_all() and it felt
weird/wrong to split those.  But that's the only usage of kvm_mmu_zap_all(), so
a better approach to maintain consistency would be to move
kvm_arch_flush_shadow_{all,memslot}() into mmu.c.  I'll do that in the next version.
