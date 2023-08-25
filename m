Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 257C3789241
	for <lists+kvm@lfdr.de>; Sat, 26 Aug 2023 01:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbjHYXOG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 19:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjHYXNj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 19:13:39 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC4C2109
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 16:13:37 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-592210fe8easo21562277b3.3
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 16:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693005217; x=1693610017;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mXOlGjifwRm9fg7hTXE/rz1Wme42tUm1XrOC0JB+9Q8=;
        b=2cubMG1JtOHdNv9vgCy5f8bpoGerZiDjQ8wXuFsWqR+LXbT/kj2/d4hkzQnUcg9Ebt
         nDwmsBujABM/QbrV1B2qzYiaZ7VNmTRApY0dWvwKagqOHgzvZijvJlp+iPb5E4HifUwK
         Kay7Tpdkn55k3D747zRvQzDUHu3ghHOBANeaNLE15ywfXyGyFHQaMY6QkRK6eaY2k8X7
         YWPj9EY2aJvyKyGEsZVv3Bc2R1y201vbq80VOam9+c+apA2iCht6K6wbAr8aC8vRWWYf
         qoRRpnnqIFMxWphx4/5c8quRWukrd0MoVpb4XrBMkzFuPLqZRqQ8FV6Jnc8wX9SWu6W8
         K/Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693005217; x=1693610017;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mXOlGjifwRm9fg7hTXE/rz1Wme42tUm1XrOC0JB+9Q8=;
        b=cd+lgp3mPimDDKx47sL5jHC3ujmSRjLxiv4MOTWeioAqQ2TPd3xU2XtnaOlthIv9Tz
         qGfnCV+NlHKqmDfofJdoIHTHioo+9PkFGa8CcPw2Uyhu2dV+tTdJrt5vQ60vYGHvy8Ne
         o8WwpictKE11oud3cB+f3aJRfp5XjDQsiwG1J4zgtaOvMDrQVQOT3OdKmjmNrjQvOMTW
         8L8/Y+rGX2aTLwzAxfu3fX/dmWQfRjxtkTbylLG3NRPd0RUaSem4NdLejwGqHQfiWwrr
         nTZRpH6HLoGuNynLbH/0wqXii41Panj+xhtm0PrWlu9g5dfO/ZOkMvOVuJj/HQJxcfDf
         iUXg==
X-Gm-Message-State: AOJu0Yw0Nzb3599qjlyFfc3ARkg94nxVmYus1Qm+G819BAbDTasBVGSh
        k72oBMDZVR2BVTmoWHIUoPNXUkUDHvo=
X-Google-Smtp-Source: AGHT+IEaimltfTnfAvarN6RAOsGe8t1ZPLlajiHA42tm+nb2GrmPAJK7tgMCOd+4IGMy/c6vbCCgYpEgy8k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ae55:0:b0:589:a3d3:2f60 with SMTP id
 g21-20020a81ae55000000b00589a3d32f60mr538584ywk.8.1693005217055; Fri, 25 Aug
 2023 16:13:37 -0700 (PDT)
Date:   Fri, 25 Aug 2023 16:13:35 -0700
In-Reply-To: <20230714065530.20748-1-yan.y.zhao@intel.com>
Mime-Version: 1.0
References: <20230714064656.20147-1-yan.y.zhao@intel.com> <20230714065530.20748-1-yan.y.zhao@intel.com>
Message-ID: <ZOk1n3ssdU7bXalP@google.com>
Subject: Re: [PATCH v4 10/12] KVM: x86/mmu: fine-grained gfn zap when guest
 MTRRs are honored
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, chao.gao@intel.com, kai.huang@intel.com,
        robert.hoo.linux@gmail.com, yuan.yao@linux.intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 14, 2023, Yan Zhao wrote:
>  void kvm_honors_guest_mtrrs_zap_on_cd_toggle(struct kvm_vcpu *vcpu)
>  {
> -	return kvm_mtrr_zap_gfn_range(vcpu, gpa_to_gfn(0), gpa_to_gfn(~0ULL));
> +	struct kvm_mtrr *mtrr_state = &vcpu->arch.mtrr_state;
> +	bool mtrr_enabled = mtrr_is_enabled(mtrr_state);
> +	u8 default_mtrr_type;
> +	bool cd_ipat;
> +	u8 cd_type;
> +
> +	kvm_honors_guest_mtrrs_get_cd_memtype(vcpu, &cd_type, &cd_ipat);
> +
> +	default_mtrr_type = mtrr_enabled ? mtrr_default_type(mtrr_state) :
> +			    mtrr_disabled_type(vcpu);
> +
> +	if (cd_type != default_mtrr_type || cd_ipat)
> +		return kvm_mtrr_zap_gfn_range(vcpu, gpa_to_gfn(0), gpa_to_gfn(~0ULL));

Why does this use use the MTRR version but the failure path does not?  Ah, because
trying to allocate in the failure path will likely fail to allocate memory.  With
a statically sized array, we can just special case the 0 => -1 case.  Actually,
we can do that regardless, it just doesn't need a dedicated flag if we use an
array.

Using the MTRR version on failure (array is full) means that other vCPUs can see
that everything is being zapped and go straight to waitin.

> +
> +	/*
> +	 * If mtrr is not enabled, it will go to zap all above if the default

Pronouns again.  Maybe this?

	/*
	 * The default MTRR type has already been checked above, if MTRRs are
	 * disabled there are no other MTRR types to consider.
	 */

> +	 * type does not equal to cd_type;
> +	 * Or it has no need to zap if the default type equals to cd_type.
> +	 */
> +	if (mtrr_enabled) {

To save some indentation:

	if (!mtrr_enabled)
		return;


> +		if (prepare_zaplist_fixed_mtrr_of_non_type(vcpu, default_mtrr_type))
> +			goto fail;
> +
> +		if (prepare_zaplist_var_mtrr_of_non_type(vcpu, default_mtrr_type))
> +			goto fail;
> +
> +		kvm_zap_or_wait_mtrr_zap_list(vcpu->kvm);
> +	}
> +	return;
> +fail:
> +	kvm_clear_mtrr_zap_list(vcpu->kvm);
> +	/* resort to zapping all on failure*/
> +	kvm_zap_gfn_range(vcpu->kvm, gpa_to_gfn(0), gpa_to_gfn(~0ULL));
> +	return;
>  }
> -- 
> 2.17.1
> 
