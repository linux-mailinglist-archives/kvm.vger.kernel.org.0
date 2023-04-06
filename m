Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1A4B6DA646
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 01:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbjDFXqC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 19:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237197AbjDFXpt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 19:45:49 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 322F5A2
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 16:45:48 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 8-20020a250508000000b00b7c653a0a4aso33009584ybf.23
        for <kvm@vger.kernel.org>; Thu, 06 Apr 2023 16:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680824747;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DaYHJStM+TYBK1P7E0zU6EMtALdZ0CRygZGLPtB7ENU=;
        b=sdQg8FBAz0C18VlkTgoy2p4dkvRhR3Dp5cD/n9t72TKfIz4++VuY6I0zizOWXImkex
         5+y/Vabl7NIcgd5bqwMRoP1foI5RdcPykxdrwS5h5W+vK4vHPA8iLGhhY/9eVLuVq7LJ
         rtXg/mtVt9/r0W/Gp02waHB87xYmYMMz8N5axYeH/t2g2MnPv1YBxt/SWiBleWxMoFGP
         W3PxnAfZRNMkO7j6pzoITRkT1ZqBrOR+8KIzFodb0nnSN1VaH/DlH/QrDZHfRWfRZVKo
         Yrf6iQHYbsOnRC492U2M0GHL//h9DtWuy7jCbTsLjwzskfU9dgX750rcnCeVqwQ4SSH0
         nslg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680824747;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DaYHJStM+TYBK1P7E0zU6EMtALdZ0CRygZGLPtB7ENU=;
        b=os4dtRdXGt2Lrxm6kG4llk/OVsbAgms3xz5zRxtijmaA8FNvkeu6enM6SFSGe9/zkg
         IqDsBMLhMZsnJWsDjZlOxdh1uyrzLZdOsxpN0IWi9K4M/wN0Uydp8iCRunvb8kfV0pG2
         DOO/AdRU/juMjjOgYr2YEgVA7ypalx8hsf1zOM4G2PBcEAFeHAIW8ngEeTbpmINsjbet
         XzNqs+wRUangxH+Mfod49YETHXEoQQHQ8gHsRA4joPvJFBumqa4WPnj1otEtGReClpH2
         2zKHCgdijf087RhAmRlJD4UugPTuWI1+9yUopDD1f+K4YfkH44vCwnSttqVnoIOS7qo/
         1VMA==
X-Gm-Message-State: AAQBX9cA0y8LMdTC2hA81LNsVqNcoYomHLGZZLk8jUEKiYtyunySySgA
        5WTAzx05DdXN/OOlgMPzTyukNIUvrd4=
X-Google-Smtp-Source: AKy350aGZUwtNydkHSBPRgLpLi6ohpNqAzeLjaYjPafLp+dQcPbHRHTzLfpOT7GD88Jr8srfRmEqlpGvWgI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:cf49:0:b0:b8b:fca4:7454 with SMTP id
 f70-20020a25cf49000000b00b8bfca47454mr140186ybg.4.1680824747496; Thu, 06 Apr
 2023 16:45:47 -0700 (PDT)
Date:   Thu, 6 Apr 2023 16:45:46 -0700
In-Reply-To: <20230214050757.9623-6-likexu@tencent.com>
Mime-Version: 1.0
References: <20230214050757.9623-1-likexu@tencent.com> <20230214050757.9623-6-likexu@tencent.com>
Message-ID: <ZC9Zqn/+J5vaXKfo@google.com>
Subject: Re: [PATCH v4 05/12] KVM: x86/pmu: Error when user sets the
 GLOBAL_STATUS reserved bits
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 14, 2023, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> If the user space sets reserved bits when restoring the MSR_CORE_
> PERF_GLOBAL_STATUS register, these bits will be accidentally returned
> when the guest runs a read access to this register, and cannot be cleared
> up inside the guest, which makes the guest's PMI handler very confused.

The changelog needs to state what the patch actually does.

> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  arch/x86/kvm/vmx/pmu_intel.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 904f832fc55d..aaea25d2cae8 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -397,7 +397,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  			reprogram_fixed_counters(pmu, data);
>  		break;
>  	case MSR_CORE_PERF_GLOBAL_STATUS:
> -		if (!msr_info->host_initiated)
> +		if (!msr_info->host_initiated || (data & pmu->global_ovf_ctrl_mask))

This is wrong.  Bits 60:58 are reserved in IA32_PERF_GLOBAL_OVF_CTRL, but are
ASCI, CTR_FREEZE, and LBR_FREEZE respectively in MSR_CORE_PERF_GLOBAL_STATUS.

>  			return 1; /* RO MSR */
>  
>  		pmu->global_status = data;
> -- 
> 2.39.1
> 
