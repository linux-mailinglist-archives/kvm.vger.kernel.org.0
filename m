Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 463BD6BA3F4
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 01:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbjCOAPv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 20:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbjCOAPu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 20:15:50 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1106328EB0
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 17:15:41 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id u4-20020a170902bf4400b0019e30a57694so9748811pls.20
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 17:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678839340;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tvZxfB6yW4h1ZDKB2+b07upHiYOYO1aOg2Oekdn4lzU=;
        b=HW8bAoJIAwBxOsF/ivIrp/zwal3b5SpPy0T7iNpJ8tXhaw9MxKoGeXtwR/ZJVQP09F
         oSdC4XFoXpQnyytP0m9VisjOYNXaaLcoua35lb+NFSteN5oAs5S9/8KaBflNenvMECXO
         6pWWVj1yOYXzXPrN8LaclSmLRwedGCUk0gkyCSRqAdIEE71nLtNeFTe9FLsmLNhimLWc
         a2XbF7REh1z3OaUggmHHOnOYJbTxGfPpuLGACyxUCtjvdVM/8B0vqS2HjWaPRZ07fJ78
         aMIyD4vrwYaNFqhxPfgYaChb7+H8u/vKp5957ZIMEmVH4gj2Ven/E/v8rzqkEd6g3p+L
         G/Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678839340;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tvZxfB6yW4h1ZDKB2+b07upHiYOYO1aOg2Oekdn4lzU=;
        b=BdInnyHG1YZ3D+YHJw+YCSi7FvegbWNsydfICSENMjKAEkybSudjeCn3OvqFZGpViF
         OjUSHGalwgxprp6kPqQuMo1kiVHhWFluQWvBpTh0n8/kSFfQFLvJGtARmL+tAINfNCw6
         7dujuGeBTxMQFGWdTp/ygZ3nkM2PV/iDyyBYFtjgx4saCLtjJgs1n6O1Ux4nCYHNvexI
         sJwbSv9BtfyxcAJ2DbXdUDkC3VqE+UQBl9gKiRranO7L8LiQpQDOX2Gp8fzup5/cqEOA
         l9QLijc+4j5EZKqaUgXBj18Xgx27Z7eOpMSykFkRCAfPaK1qyymwfA0H2HqpYoZyrrep
         Et6A==
X-Gm-Message-State: AO0yUKVzxsmv1wZWOuCgOsDAg/REgks2oKbBT7FBirlGZ7P4Eo8WqdFr
        q2QQbaspQ0ACNi8fAbCvvDMBsDMFR6E=
X-Google-Smtp-Source: AK7set+JRRptlTiTcfUcDHtGAg8IyGusTf5StVwESSGtxFE5BPH+AtiNzmsWremolmbF5/E/bkyK4WGPGik=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:b55e:0:b0:502:e1c4:d37b with SMTP id
 u30-20020a63b55e000000b00502e1c4d37bmr13760314pgo.12.1678839340395; Tue, 14
 Mar 2023 17:15:40 -0700 (PDT)
Date:   Tue, 14 Mar 2023 17:15:39 -0700
In-Reply-To: <20230215121231.43436-1-lirongqing@baidu.com>
Mime-Version: 1.0
References: <20230215121231.43436-1-lirongqing@baidu.com>
Message-ID: <ZBEOK6ws9wGqof3O@google.com>
Subject: Re: [PATCH] x86/kvm: refine condition for checking vCPU preempted
From:   Sean Christopherson <seanjc@google.com>
To:     lirongqing@baidu.com
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
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

+Paolo, Wanpeng, and Vitaly

In the future, use get_maintainers.pl to build To: and Cc: so that the right folks
see the patch.  Not everyone habitually scours the KVM list. :-)

On Wed, Feb 15, 2023, lirongqing@baidu.com wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> Check whether vcpu is preempted or not when HLT is trapped or there
> is not realtime hint.

Please explain _why_ there's no need to check for preemption in this setup.  What
may be obvious to you isn't necessarily obvious to reviewers or readers.

> In other words, it is unnecessary to check preemption if HLT is not
> intercepted and guest has realtime hint
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  arch/x86/kernel/kvm.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 1cceac5..1a2744d 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -820,8 +820,10 @@ static void __init kvm_guest_init(void)
>  		has_steal_clock = 1;
>  		static_call_update(pv_steal_clock, kvm_steal_clock);
>  
> -		pv_ops.lock.vcpu_is_preempted =
> -			PV_CALLEE_SAVE(__kvm_vcpu_is_preempted);
> +		if (kvm_para_has_feature(KVM_FEATURE_PV_UNHALT) ||

Rather than have the guest rely on host KVM behavior clearing PV_UNHALT when HLT
is passed through), would it make sense to add something like KVM_HINTS_HLT_PASSTHROUGH
to more explicitly tell the guest that HLT isn't intercepted?

> +		     !kvm_para_has_hint(KVM_HINTS_REALTIME))

Misaligned indentation (one too many spaces).

> +			pv_ops.lock.vcpu_is_preempted =
> +				PV_CALLEE_SAVE(__kvm_vcpu_is_preempted);
>  	}
>  
>  	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
> -- 
> 2.9.4
> 
