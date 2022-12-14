Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7709464CD64
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 16:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238852AbiLNPwQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 10:52:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238520AbiLNPvz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 10:51:55 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B1522BFF
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 07:48:49 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id o1-20020a17090a678100b00219cf69e5f0so7605623pjj.2
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 07:48:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WaLTjgWRihQN7b0MKycoZ8sfbj+ZIdN/5VH6BQ1zJG8=;
        b=XMynpH/QE30AFbSvvPWWkgXqBXOOP1Y7o2E1+jU1ZROwcipnsl43BYfWKz9UVtbJUD
         FVLlZIdq+s3UiL8JKNXsew7gpKRWx7wcggHKte6wQJLKVPXiwjDE/qbEqakc4+d/kCU2
         o2eGMGvttgdi6SdN1OzsUGW4UtjOjHLCxTiM4PTKChd0mM4LYT3q+33OqzLuUQhMe/y6
         CHMJs7HG9S6fYMPMLqzpe5LeKmvI//Ft+/64Ru0nYaHW0Q7FnON5kHJKF4RqxzQH3SYj
         Ivi5e5hKL/gNehXywqTOr8RChJeVoEFJydOfZFfxG/tuCv6bs8GG84qEb5uroMjXovOr
         Zsgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WaLTjgWRihQN7b0MKycoZ8sfbj+ZIdN/5VH6BQ1zJG8=;
        b=KS0sUp9J8PRaNLp1RP8aQya8cOs0c6eqE/hcjuZqZur5lp58/EU+dgJHgdqetOdL3T
         ZPx8VlDoltZSwgapLEburxG51effSY1+LWAI4qbRM3iurzn2gZQ3YL+nVZ9lnNbFzM2F
         myV2vdRPnG70uVbicFEXdYG0ZLRdLNTJOr9EFOMDnK6rNfvsTBF2bbVN6dKmGhktJ7/D
         RvdMrhErNnMjIfCQVxBx319/EA/et6ZKO0QE0R/QyhkybIFX8Pmvv3deGRlNYeK3cp18
         B3C79wtx9B0zL4SZjsxAnjbYEvyHTVSuW0fR0cIZlRhss5pwEEBFdKFiXndSs8WRPtGw
         k+cg==
X-Gm-Message-State: ANoB5plkTlOK9Vbw+3N0QMTv+j0YX+evdY5N8ln612Ftp1fs82sn5QaC
        SvcS5AisNFWQHnjCfFGnMVAnmQ==
X-Google-Smtp-Source: AA0mqf6vsR5Xz/LK0X/Dvs2lGxaCS6gbU8Zhg3GtAbtn/rjmbDaH9Nm6wzVn56Lrw2ZzX9gI59k7qw==
X-Received: by 2002:a05:6a21:2d8f:b0:a7:882e:3a18 with SMTP id ty15-20020a056a212d8f00b000a7882e3a18mr576516pzb.1.1671032929053;
        Wed, 14 Dec 2022 07:48:49 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b28-20020aa78edc000000b0056b2e70c2f5sm57481pfr.25.2022.12.14.07.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 07:48:48 -0800 (PST)
Date:   Wed, 14 Dec 2022 15:48:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg Thelen <gthelen@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Subject: Re: [PATCH 0/5] KVM: x86/mmu: TDP MMU fixes for 6.2
Message-ID: <Y5nwXDS38UzavS7n@google.com>
References: <20221213033030.83345-1-seanjc@google.com>
 <acb8adfc5a2ace34010dc70d5ccd2821ff0a1ecb.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acb8adfc5a2ace34010dc70d5ccd2821ff0a1ecb.camel@linux.intel.com>
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

On Wed, Dec 14, 2022, Robert Hoo wrote:
> On Tue, 2022-12-13 at 03:30 +0000, Sean Christopherson wrote:
> > Fix three fatal TDP MMU bugs introduced in 6.2,
> 
> introduced in 6.1? or earlier?

6.2, or more precisely, code sitting in kvm/next that will hopefully become part
of 6.2-rc1.

> >  harden related code,
> > and clean up kvm_tdp_mmu_map() to eliminate the need for gotos.
> > 
> > Sean Christopherson (5):
> >   KVM: x86/mmu: Don't attempt to map leaf if target TDP MMU SPTE is
> >     frozen
> >   KVM: x86/mmu: Map TDP MMU leaf SPTE iff target level is reached
> >   KVM: x86/mmu: Re-check under lock that TDP MMU SP hugepage is
> >     disallowed
> >   KVM: x86/mmu: Don't install TDP MMU SPTE if SP has unexpected level
> >   KVM: x86/mmu: Move kvm_tdp_mmu_map()'s prolog and epilog to its
> > caller
> > 
> >  arch/x86/kvm/mmu/mmu.c          |  9 +++++++-
> >  arch/x86/kvm/mmu/mmu_internal.h |  1 -
> >  arch/x86/kvm/mmu/tdp_mmu.c      | 39 +++++++++++++++--------------
> > ----
> >  3 files changed, 26 insertions(+), 23 deletions(-)
> > 
> > 
> > base-commit: 51229fd7872f82af07498aef5c79ad51baf81ea0
> 
> I cannot find this base commit in my tree, where I just pulled to
> latest queue yesterday. But find this series can be applied to this
> latest queue as well.

Ya, I have an extra commit in my local repo sitting on top of kvm/queue so that
my standard builds don't fail.

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index cc3e8c7d0850..2c7f2a26421e 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -898,6 +898,7 @@ bool kvm_hv_assist_page_enabled(struct kvm_vcpu *vcpu)
                return false;
        return vcpu->arch.pv_eoi.msr_val & KVM_MSR_ENABLED;
 }
+EXPORT_SYMBOL_GPL(kvm_hv_assist_page_enabled);
 
 int kvm_hv_get_assist_page(struct kvm_vcpu *vcpu)
 {
