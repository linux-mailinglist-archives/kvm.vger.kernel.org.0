Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 699FD720B53
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 23:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236474AbjFBV7t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 17:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236476AbjFBV7n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 17:59:43 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DCCD1BC
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 14:59:40 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bad0f5d6a7dso3797155276.0
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 14:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685743179; x=1688335179;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jGxEiotWLzwUbrpEsm09duSVOTfBP8nhMxpsEIBv9AM=;
        b=RatgOEB1Qs31VQX0pSi0j15AImVbeDEiOql8hmK6kBwgfn00cqbIxJG0FDFO1gHUQ2
         nDjmDEV4PN5EMd1UMyohRnl0fAFzQb27LmfVxj5lVfxvaYJfE2GOdjPLZioznK1xzHtl
         dyW93uOWsdH5ml1/QCSrc7OudaFT16nTpK0a4Czp40DJqCjwTcQcovSuF4V5elP9rDjC
         /sn5kcLSIdUGOCKrlCrOQhT0j77GsIM2oTeNhT9wcZOUhuwv7gYDSArZ1R4x9LUAxANS
         3wun+Ea4RWN2DmE1hL9GtfvSmSCzQllv7d9n5tonjyxpD/qzI66c5y16MigclPuf5BDc
         JoBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685743179; x=1688335179;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jGxEiotWLzwUbrpEsm09duSVOTfBP8nhMxpsEIBv9AM=;
        b=VT+bieKWeW1gMRBUrWk+lkz+WXKy688q2QfBTWNQGOJd4a2QLyD8oYZz+qxsposueg
         E5fN3jveDFARhEW/901BvxpInYplER17NqX/Cx5lxLs1Dn/ENknNpiEg+T1umfC5SIAv
         bcrDX8W5rHHjw/qmGrAZRaM6QwxFQkf8Cgpuaw7cOyCF+CydUR0D2cJ+crUq7cD5pfGB
         MW2IQnAHV2xhfv9hThVrPw7gbPrjx7DVihG3t4cvblPNVwGIyM+OGCUGyzJUMuL2lNYf
         QLsM60ZNseu8fmVU5Kum2GWQKAVrCSpePYr5qXH1b4gL0LZ6Pj0Mvp3XMCc0UjROio4v
         JSSw==
X-Gm-Message-State: AC+VfDy1NiBM5EETE8QZpMgCyYBfk6ZS6I+A3UX3xHbZsTcly65hx+A+
        D9gVyF2QHhQXjw9L5i5QWPzLyEeVNPs=
X-Google-Smtp-Source: ACHHUZ63zEcaq1eF7LToIr7itsZKQKOsQRgviEl7PORljn6cZEoHjcbg8QkG9axunZDsxeeS8Y7fGwZve/M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:7e47:0:b0:ba8:5c44:194b with SMTP id
 z68-20020a257e47000000b00ba85c44194bmr2557986ybc.13.1685743179563; Fri, 02
 Jun 2023 14:59:39 -0700 (PDT)
Date:   Fri, 2 Jun 2023 14:59:38 -0700
In-Reply-To: <20230530060423.32361-3-likexu@tencent.com>
Mime-Version: 1.0
References: <20230530060423.32361-1-likexu@tencent.com> <20230530060423.32361-3-likexu@tencent.com>
Message-ID: <ZHpmSurIoDvGpIxG@google.com>
Subject: Re: [PATCH v6 02/10] KVM: x86/pmu: Return #GP if user sets the
 GLOBAL_STATUS reserved bits
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 30, 2023, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> Return #GP if KVM user space attempts to set a reserved bit for guest.

It's not a #GP, it's simply an error.

> If the user space sets reserved bits when restoring the MSR_CORE_
> PERF_GLOBAL_STATUS register, these bits will be accidentally returned
> when the guest runs a read access to this register, and cannot be cleared
> up inside the guest, which makes the guest's PMI handler very confused.
> 
> Note, reusing global_ovf_ctrl_mask as global_status_mask will be broken
> if KVM supports higher versions of Intel arch pmu.
> 
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  arch/x86/kvm/vmx/pmu_intel.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 1f9c3e916a21..343b3182b7f4 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -399,7 +399,11 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  			reprogram_fixed_counters(pmu, data);
>  		break;
>  	case MSR_CORE_PERF_GLOBAL_STATUS:
> -		if (!msr_info->host_initiated)
> +		/*
> +		 * Caution, the assumption here is that some of the bits (such as
> +		 * ASCI, CTR_FREEZE, and LBR_FREEZE) are not yet supported by KVM.
> +		 */

A comment wasn't what I had in mind when I objected to "good enough"[*].  Luckily,
there's no need to add another mask.  After rereading the SDM, there isn't actually
a divergence between GLOBAL_STATUS and GLOBAL_OVF_CTRL, Intel just renamed GLOBAL_OVF_CTRL
to GLOBAL_STATUS_RESET and for some asinine reason, added separate entries in the
architectural MSRs table instead of adding a redirect.

I'll post and slot in a patch to do s/global_ovf_ctrl_mask/global_status, along
with a comment explaining the rename and how the "reset" MSR is always tied to the
status MSR, regardless of what it's named.

[*] https://lore.kernel.org/all/37a18b89-c0c3-4c88-7f07-072573ac0c92@gmail.com
