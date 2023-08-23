Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2E378619E
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 22:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236376AbjHWUf0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Aug 2023 16:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236362AbjHWUfI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Aug 2023 16:35:08 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E90910D4
        for <kvm@vger.kernel.org>; Wed, 23 Aug 2023 13:35:06 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-58419550c3aso82663247b3.0
        for <kvm@vger.kernel.org>; Wed, 23 Aug 2023 13:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692822905; x=1693427705;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uNl0p1iobEmxtFFlFibwUb/5OsmeA37vr99AFPPjLyE=;
        b=FW4W9kB5t794YWDNQRCavhc2CvnpqUIaUwkp/ugL/Ukmp7NNX8jJc943HmoqQxWTZM
         eyyHkdxS2FICoRTYJzNOHpSi6dFgu54ZqOA0buCSFNYqJSeswqMy4zPTxwB4/Z4RHsgD
         84XvivdMj80UUIrZ1YpG82+/yGxcFDfevS/xjtHixzm57TO/2gPrHyzuBZ75t4CvpdZQ
         WjQOVGjBLDisH2xJ6535GVL8oz3cCqiHkklRgaKTGpgwXib/6di77oz1KVEx9XF7mWcP
         DKAKk/YhbKZKzsHeDeTTorcai534k6Y3PCRN0Sqtjz3ZzbHTwXZTaiWS/MMZkMzY8QvC
         34Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692822905; x=1693427705;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uNl0p1iobEmxtFFlFibwUb/5OsmeA37vr99AFPPjLyE=;
        b=MxG1+8HMEMOhLoiuNPbj3dwiAP599u5j/xin/fQhhHTEYQ3LVsZ+Ijlchjz3scGRxH
         OrlKja5ZKrXnh5qfrKUazurO2D3ycPzNywX0Yk+WFhdKRh65KW/GzTuueWjBR+Cclj7a
         7yGkv7KTFnPVLeJ7P+FAbWwuFtZChWeTESMV1IqZThTqUJXOLX7Uf1LgWejlqYXQm4hi
         OpXyaVX38aA2PNBmqITe2w5DvPolyNjd1rAFiog2I3/N0TizroiPJliwAg2C8sLoHQSh
         A1eTVYUgT1Bn7EwefRD+VFY3Us61uaZs74Ue3kqRKw5DDyd+eg2OBiGtvM5R8YfYNQBl
         m5+A==
X-Gm-Message-State: AOJu0Yz8OCvSb0pmKMr28HaWpw/TvFGm4iz0LvYDVjR/329hRE3BoRNc
        pTxfzPZwr0nWn64nyFpVJaYm9possnM=
X-Google-Smtp-Source: AGHT+IEgRo/wa5rLpZbO7TJkWXB1xqKmLZ71kIK/huj+vWB3upeFML3xInPXfY5rairb76D9+uV6RZ7y0sg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ad0d:0:b0:586:a58d:2e24 with SMTP id
 l13-20020a81ad0d000000b00586a58d2e24mr197643ywh.5.1692822905713; Wed, 23 Aug
 2023 13:35:05 -0700 (PDT)
Date:   Wed, 23 Aug 2023 13:35:04 -0700
In-Reply-To: <20230822080312.63514-1-likexu@tencent.com>
Mime-Version: 1.0
References: <20230822080312.63514-1-likexu@tencent.com>
Message-ID: <ZOZteOxJvq9v609G@google.com>
Subject: Re: [PATCH] KVM: x86: Allow exposure of VMware backdoor Pseudo-PMCs
 when !enable_pmu
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 22, 2023, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> Fix kvm_pmu_rdpmc() logic to allow exposure of VMware backdoor Pseudo-PMCs
> if pmu is globally disabled.
> 
> In this usage scenario, once vmware_backdoor is enabled, the VMs can fully
> utilize all of the vmware_backdoor-related resources, not just part of it,
> i.e., vcpu should always be able to access the VMware backdoor Pseudo-PMCs
> via RDPMC. Since the enable_pmu is more concerned with the visibility of
> hardware pmu resources on the host, fix it to decouple the two knobs.
>
> The test case vmware_backdoors from KUT is used for validation.

Is there a real world need for this?  Per commit 672ff6cff80c ("KVM: x86: Raise
#GP when guest vCPU do not support PMU"), KVM's behavior is intentional.  If there
is a real world need, then (a) that justification needs to be provided, (b) this
needs a Fixes:, and (c) this probably needs to be tagged for stable.

> Cc: Arbel Moshe <arbel.moshe@oracle.com>
> Cc: Liran Alon <liran.alon@oracle.com>
> Cc: Nikita Leshenko <nikita.leshchenko@oracle.com>

The expectation is that a Cc: in the changelog means the patch email is Cc'd to
that person, i.e. one of the purposes of Cc: here is to record that people who
might care about the patch have been made aware of its existence.  stable@ is
pretty much the only exception to that rule, as "Cc: stable@vger.kernel.org" is
really just a metadata tag for scripts.

FWIW, I believe Liran no longer works for Oracle, no idea about the others.

> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  arch/x86/kvm/pmu.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index edb89b51b383..c896328b2b5a 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -526,12 +526,12 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
>  	struct kvm_pmc *pmc;
>  	u64 mask = fast_mode ? ~0u : ~0ull;
>  
> -	if (!pmu->version)
> -		return 1;
> -
>  	if (is_vmware_backdoor_pmc(idx))
>  		return kvm_pmu_rdpmc_vmware(vcpu, idx, data);
>  
> +	if (!pmu->version)
> +		return 1;
> +
>  	pmc = static_call(kvm_x86_pmu_rdpmc_ecx_to_pmc)(vcpu, idx, &mask);
>  	if (!pmc)
>  		return 1;
> 
> base-commit: fff2e47e6c3b8050ca26656693caa857e3a8b740
> -- 
> 2.41.0
> 
