Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A153D60D2BB
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 19:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbiJYRrT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 13:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbiJYRrS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 13:47:18 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C46CBA266
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 10:47:17 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id w189so11107770pfw.4
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 10:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x6UfT0PkVqIEzg/b40U6Tv01tgKpXvFjmUedkL8F3Tg=;
        b=k9xkeoWG7NOtnMXuG+hqgpNBFiz/FSbXfzuE99SEhrJRcvzvqP80ltZHkPZPY9WSwI
         gNuPui67QMgeQuj+lRzNd5N5ILXaF5PsgCig6DpqUbx/X9OPHqiNJVnQyKkFA2ldMTHD
         piwSOkYwBqXD/Dk2IXhkQaSTt56Qx4vUjG+pB3JgVLfe/yY46rTrAbuSKZ7ZoSRM0N29
         cSzriVL/KShzU/XXfRAjFvvmYcYm2SVG/atD/P6NQoKq2BaO+4wkUiiiMwteyws3SDpo
         n1PMg7PZ5MF3G5N/TOK26D7h8fdbM29BXEjtGpj3sEiIyFkfwEKaR2PzCBGeRmoyO6Tp
         IZIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x6UfT0PkVqIEzg/b40U6Tv01tgKpXvFjmUedkL8F3Tg=;
        b=s1wy66dBPwyVqPznOL+3nxgWTunXfD0XDpAdR1odHOWoxucxnqamcIibQpDd0owlNh
         ByTdDH/hpv2cr9iBmWJhya2sFCee5zmJu+M+jv7KMymvxDR5F33OFhrNy1lsE4iFmB0A
         /AUOzaS8gHgurdRf4ANOZC3bVYuu5kGcywAC4EiRTNFjapeTBICePTlwcArzucXoibiC
         2Wo7wrV6fte2+2hREYvIHB+PBWNtmSTSysL+YWfL735cUbHECTjtuz/EGRaQsqZCkzED
         d4Wi1ufQ+Tk8Dsdo7eFeI05BolldeUo5Ve8WJWLch9yT+d4UHML1CyG2DdrVvg9nIGQg
         iOIA==
X-Gm-Message-State: ACrzQf2Xiq/G5gFf1XJfHveGGjsG8xwgD8RnFPDCA9IzQpNRsAPjKiBX
        bhVzpPIkQtVTFMSJhcrIM+LHZA==
X-Google-Smtp-Source: AMsMyM6syD6+lDTSRfRbcyIlniv5azX8Mx2fGe41xjA6NoF9ZiWiWSLmIYef4Sn3GEMHlbCIh03c/A==
X-Received: by 2002:a63:5144:0:b0:43b:ed4b:224 with SMTP id r4-20020a635144000000b0043bed4b0224mr34000005pgl.594.1666720036605;
        Tue, 25 Oct 2022 10:47:16 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u8-20020a170902e80800b001869394a372sm1464101plg.201.2022.10.25.10.47.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 10:47:16 -0700 (PDT)
Date:   Tue, 25 Oct 2022 17:47:12 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Gavin Shan <gshan@redhat.com>, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        peterx@redhat.com, will@kernel.org, catalin.marinas@arm.com,
        bgardon@google.com, shuah@kernel.org, andrew.jones@linux.dev,
        dmatlack@google.com, pbonzini@redhat.com, zhenyzha@redhat.com,
        james.morse@arm.com, suzuki.poulose@arm.com,
        alexandru.elisei@arm.com, shan.gavin@gmail.com
Subject: Re: [PATCH v6 3/8] KVM: Add support for using dirty ring in
 conjunction with bitmap
Message-ID: <Y1ghIKrAsRFwSFsO@google.com>
References: <20221011061447.131531-1-gshan@redhat.com>
 <20221011061447.131531-4-gshan@redhat.com>
 <Y1Hdc/UVta3A5kHM@google.com>
 <8635bhfvnh.wl-maz@kernel.org>
 <Y1LDRkrzPeQXUHTR@google.com>
 <87edv0gnb3.wl-maz@kernel.org>
 <Y1ckxYst3tc0LCqb@google.com>
 <Y1css8k0gtFkVwFQ@google.com>
 <878rl4gxzx.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878rl4gxzx.wl-maz@kernel.org>
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

On Tue, Oct 25, 2022, Marc Zyngier wrote:
> On Tue, 25 Oct 2022 01:24:19 +0100, Oliver Upton <oliver.upton@linux.dev> wrote:
> > > That's why I asked if it's possible for KVM to require a dirty_bitmap when KVM
> > > might end up collecting dirty information without a vCPU.  KVM is still
> > > technically prescribing a solution to userspace, but only because there's only
> > > one solution.
> > 
> > I was trying to allude to something like this by flat-out requiring
> > ring + bitmap on arm64.
> 
> And I claim that this is wrong. It may suit a particular use case, but
> that's definitely not a universal truth.

Agreed, KVM should not unconditionally require a dirty bitmap for arm64.

> > Otherwise, we'd either need to:
> > 
> >  (1) Document the features that explicitly depend on ring + bitmap (i.e.
> >  GIC ITS, whatever else may come) such that userspace sets up the
> >  correct configuration based on what its using. The combined likelihood
> >  of both KVM and userspace getting this right seems low.
> 
> But what is there to get wrong? Absolutely nothing.

I strongly disagree.  On x86, we've had two bugs escape where KVM attempted to
mark a page dirty without an active vCPU.

  2efd61a608b0 ("KVM: Warn if mark_page_dirty() is called without an active vCPU") 
  42dcbe7d8bac ("KVM: x86: hyper-v: Avoid writing to TSC page without an active vCPU")

Call us incompetent, but I have zero confidence that KVM will never unintentionally
add a path that invokes mark_page_dirty_in_slot() without a running vCPU.

By completely dropping the rule that KVM must have an active vCPU on architectures
that support ring+bitmap, those types of bugs will go silently unnoticed, and will
manifest as guest data corruption after live migration.

And ideally such bugs would detected without relying on userspace to enabling
dirty logging, e.g. the Hyper-V bug lurked for quite some time and was only found
when mark_page_dirty_in_slot() started WARNing.

I'm ok if arm64 wants to let userspace shoot itself in the foot with the ITS, but
I'm not ok dropping the protections in the common mark_page_dirty_in_slot().

One somewhat gross idea would be to let architectures override the "there must be
a running vCPU" rule, e.g. arm64 could toggle a flag in kvm->arch in its
kvm_write_guest_lock() to note that an expected write without a vCPU is in-progress:

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8c5c69ba47a7..d1da8914f749 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3297,7 +3297,10 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
        struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 
 #ifdef CONFIG_HAVE_KVM_DIRTY_RING
-       if (WARN_ON_ONCE(!vcpu) || WARN_ON_ONCE(vcpu->kvm != kvm))
+       if (!kvm_arch_allow_write_without_running_vcpu(kvm) && WARN_ON_ONCE(!vcpu))
+               return;
+
+       if (WARN_ON_ONCE(vcpu && vcpu->kvm != kvm))
                return;
 #endif
 
@@ -3305,10 +3308,10 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
                unsigned long rel_gfn = gfn - memslot->base_gfn;
                u32 slot = (memslot->as_id << 16) | memslot->id;
 
-               if (kvm->dirty_ring_size)
+               if (kvm->dirty_ring_size && vcpu)
                        kvm_dirty_ring_push(&vcpu->dirty_ring,
                                            slot, rel_gfn);
-               else
+               else if (memslot->dirty_bitmap)
                        set_bit_le(rel_gfn, memslot->dirty_bitmap);
        }
 }

