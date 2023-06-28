Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C52DF741C0A
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 00:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231573AbjF1W5Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 18:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231555AbjF1W5O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 18:57:14 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 476C510DA
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 15:57:12 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-56cf9a86277so412667b3.3
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 15:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687993031; x=1690585031;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hwgSA/+Q3RwZ/y/YZJGoooMBAh627PahKu/KzBnos0s=;
        b=Oskss3t+pC064I6YCeM23QPiq/UnvLj6LANVC7YxVDbWHJUnifSzqz29R96QnU+IdF
         wye1IcGLqykZvDZMmi8yOmpioxKLnKtiOrvp6LAw3PWIisM/3TMlr5OwTXiuq74MV7lF
         HZKIpqx/pjlhrjmmFTC2IsMbMD73e1rrEvyFi1KX996EXXw8/ci2mFWs9UKERmrvNeba
         79KN777V5kWTkiHBKFKzDMLFwwKsKt+ldSLBrgKrBL/C+xL6BeRFk9iU1LRTtMRhN/A7
         GBXSgjol6OyCKtuQaO2VyklYLzCuWI2VipFHkvD+LANt04oUTKjv3eQHmRVJwlB1ufrL
         efeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687993031; x=1690585031;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hwgSA/+Q3RwZ/y/YZJGoooMBAh627PahKu/KzBnos0s=;
        b=IMKz5ZhlY7KE61DpN9kn5iecWGcvgF16mjCbhBWdI27rnQxSfhIR8i8EpesHcc1gGB
         OTxI/rbL8lOWWPNa/9eRbC0VJ0l0XcJhawTRisrnlow/54Lkfl0Ws1AyI8rTGxfkqvux
         QXvLRTrnhR5iqB4TKh7BSQnavAcMCReNizKydFsfnZunl8a5iFO1ROQyTmk2w9ILZqyL
         vhxCf0CswgE2zyusaxLHdSab0CdgJ6DrvJSqwfkls37oQP8dE4arfiwtz2ugmEjfzXWE
         ypzib7Ee6nxD9k8MmqM1C8KBWnmj2KIhok5J3hFCpiASJpIr1VFaq4BpDXMhuMdRLqxd
         cHyg==
X-Gm-Message-State: AC+VfDyIa2JM7WelOyhca1b928QbW67rmvgCCk5QH2JiNNOa05/442rL
        f0eLKb7gPFGB9niT726NnOTGg4CcqoA=
X-Google-Smtp-Source: ACHHUZ7zCOG9RSK63m/viGHrTVnLManN+Bek2z4NKfPkzS1lEk61765VeWfKqH5jp32gijPhHUu9Ay6Hn6U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b1c5:0:b0:570:b1:ca37 with SMTP id
 p188-20020a81b1c5000000b0057000b1ca37mr14108433ywh.5.1687993031424; Wed, 28
 Jun 2023 15:57:11 -0700 (PDT)
Date:   Wed, 28 Jun 2023 15:57:09 -0700
In-Reply-To: <20230616023858.7503-1-yan.y.zhao@intel.com>
Mime-Version: 1.0
References: <20230616023101.7019-1-yan.y.zhao@intel.com> <20230616023858.7503-1-yan.y.zhao@intel.com>
Message-ID: <ZJy6xcIsOknHPQ9w@google.com>
Subject: Re: [PATCH v3 08/11] KVM: x86: move vmx code to get EPT memtype when
 CR0.CD=1 to x86 common code
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, chao.gao@intel.com, kai.huang@intel.com,
        robert.hoo.linux@gmail.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 16, 2023, Yan Zhao wrote:
> Move code in vmx.c to get cache disabled memtype when non-coherent DMA
> present to x86 common code.
> 
> This is the preparation patch for later implementation of fine-grained gfn
> zap for CR0.CD toggles when guest MTRRs are honored.
> 
> No functional change intended.
> 
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  arch/x86/kvm/mtrr.c    | 19 +++++++++++++++++++
>  arch/x86/kvm/vmx/vmx.c | 10 +++++-----
>  arch/x86/kvm/x86.h     |  1 +
>  3 files changed, 25 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
> index 3ce58734ad22..b35dd0bc9cad 100644
> --- a/arch/x86/kvm/mtrr.c
> +++ b/arch/x86/kvm/mtrr.c
> @@ -721,3 +721,22 @@ bool kvm_mtrr_check_gfn_range_consistency(struct kvm_vcpu *vcpu, gfn_t gfn,
>  
>  	return type == mtrr_default_type(mtrr_state);
>  }
> +
> +void kvm_mtrr_get_cd_memory_type(struct kvm_vcpu *vcpu, u8 *type, bool *ipat)

Hmm, I'm not convinced that this logic is subtle enough to warrant a common
helper with out params (I *really* don't like out params :-) ).

UC, or more specifically CR0.CD=1 on VMX without the quirk, is a super special case,
because to faithfully emulatee "No Fill" mode, KVM needs to ignore guest PAT (stupid WC).

I don't love having the same logic/assumptions in multiple places, but the CR0.CD=1
behavior is so rigidly tied to what KVM must do to that I think trying to provide a
common helper makes the code more complex than it needs to be.

If we open code the logic in the MTRR helper, than I think it can be distilled
down to:

	struct kvm_mtrr *mtrr_state = &vcpu->arch.mtrr_state;
	bool mtrr_enabled = mtrr_is_enabled(mtrr_state);
	u8 default_type;

	/*
	 * Faithfully emulating CR0.CD=1 on VMX requires ignoring guest PAT, as
	 * WC in the PAT overrides UC in the MTRRs.  Zap all SPTEs so that KVM
	 * will once again start honoring guest PAT.
	 */
	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
		return kvm_mtrr_zap_gfn_range(vcpu, gpa_to_gfn(0), gpa_to_gfn(~0ULL));

	default_type = mtrr_enabled ? mtrr_default_type(mtrr_state) :
				      mtrr_disabled_type(vcpu);

	if (default_type != MTRR_TYPE_WRBACK)
		return kvm_mtrr_zap_gfn_range(vcpu, gpa_to_gfn(0), gpa_to_gfn(~0ULL));

	if (mtrr_enabled) {
		if (gather_non_wb_fixed_mtrrs(vcpu, MTRR_TYPE_WRBACK))
			goto fail;

		if (gather_non_wb_var_mtrrs(vcpu, MTRR_TYPE_WRBACK))
			goto fail;

		kvm_zap_or_wait_mtrrs(vcpu->kvm);
	}

and this patch goes away.

> +{
> +	/*
> +	 * this routine is supposed to be called when guest mtrrs are honored
> +	 */
> +	if (unlikely(!kvm_mmu_honors_guest_mtrrs(vcpu->kvm))) {

I don't think this is worth checking, e.g. this would be WARN-worthy if it weren't
for an otherwise benign race with device (un)assignment.

> +		*type = MTRR_TYPE_WRBACK;
> +		*ipat = true;

> +	} else if (unlikely(!kvm_check_has_quirk(vcpu->kvm,

Eh, drop the "unlikely()" annotations.  AIUI, they almost never provide actual
performance benefits, and I dislike unnecessarily speculating on what userspace
is doing when it comes to code (though I 100% agree that this definitely unlikely)
