Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6B4357D638
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 23:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233766AbiGUVng (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 17:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiGUVnf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 17:43:35 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F899369D
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 14:43:34 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id t2-20020a17090a4e4200b001f21572f3a4so2595729pjl.0
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 14:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v5w1CEKb5lWaIk8RLPJBXF3xB963/QpWk9gTmTbgykg=;
        b=isGV8ExNkQux68fByCMrRCn/Ib1blLrzg5miI3ReclIgLUD6qmn/x5GCSk6mvX/uJ5
         Ue6bMGLfZbiUELfj+mBcHGP1BMzzPpYwe3nn5JdLCZsgP8EkMx/kt8GphI/g27MhLDQX
         RGD+uGJkNsKLbBpl4/JfsedDxApzHXSEIh0+ATnR7olgvTQzfubJeGyS5v8DR2naX43/
         sewoZLRVgvUNSvx/yrbzMPzbXgITtzh/X3Nk1Fh128igd8ICEJK3CnSDuteegER9LjFH
         nf7AmjF4VTO1lbwBpRVmmetY4nrSFIchLi5w8l02A+ATduxf6FqAK42q1sGWYxQNPyln
         ABXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v5w1CEKb5lWaIk8RLPJBXF3xB963/QpWk9gTmTbgykg=;
        b=v30FuscD2lN4CUkd+VgBSIlxLKWOHqDp4P6teeRN7zFYLvu++pXRMugOOSoEFNKFVn
         cr6HzPX1o8LD31VoyJ73IAQ9ZrF9O//QPoj6OLevTiraQq7jYBRQ+L4fA4wE6KjzzmuS
         YKlXu3pzfk/AdvVWfhqLFDSbbTEFVYDXIkNEXMUdl8F7CEKwuqdSZTcJQEIOl2WynUlh
         Ngdcqj71xGkQA/NLmi2u/Zc+t4NCClmjH4YwQEWoVRJJ2Drh5W471cHIq+jwhuCw5Oeu
         jucswOVfGY0qhRj5f1MIsytquNLzAGMFIZsN6Y+RHLpeTOqh9pdU/A/eOUtXm8dP9Iw3
         GLPA==
X-Gm-Message-State: AJIora9JkvAW75UhHg/lT5ht+PXccbW8EfXVWasc7SDDlcW7J5GnyVvT
        U965LXqMwDX3KT6o5jgHEpKmQQ==
X-Google-Smtp-Source: AGRyM1uXHR8jTjhjsgoyXO5G6sQw0lYkq5kWNncOHLdm3Ou0iyCqrzkrlwq6KM+SaA1K00u/imd6mw==
X-Received: by 2002:a17:90a:bb94:b0:1f2:19f0:b01e with SMTP id v20-20020a17090abb9400b001f219f0b01emr514168pjr.46.1658439814017;
        Thu, 21 Jul 2022 14:43:34 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id d2-20020a17090a3b0200b001f1abb8de2bsm3865842pjc.49.2022.07.21.14.43.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 14:43:33 -0700 (PDT)
Date:   Thu, 21 Jul 2022 21:43:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 01/25] KVM: x86: hyper-v: Expose access to debug MSRs
 in the partition privilege flags
Message-ID: <YtnIgQOPbcZOQK2D@google.com>
References: <20220714091327.1085353-1-vkuznets@redhat.com>
 <20220714091327.1085353-2-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220714091327.1085353-2-vkuznets@redhat.com>
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

On Thu, Jul 14, 2022, Vitaly Kuznetsov wrote:
> For some features, Hyper-V spec defines two separate CPUID bits: one
> listing whether the feature is supported or not and another one showing
> whether guest partition was granted access to the feature ("partition
> privilege mask"). 'Debug MSRs available' is one of such features. Add
> the missing 'access' bit.
> 
> Fixes: f97f5a56f597 ("x86/kvm/hyper-v: Add support for synthetic debugger interface")
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/hyperv.c             | 1 +
>  include/asm-generic/hyperv-tlfs.h | 2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index e2e95a6fccfd..e08189211d9a 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -2496,6 +2496,7 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>  			ent->eax |= HV_MSR_RESET_AVAILABLE;
>  			ent->eax |= HV_MSR_REFERENCE_TSC_AVAILABLE;
>  			ent->eax |= HV_ACCESS_FREQUENCY_MSRS;
> +			ent->eax |= HV_ACCESS_DEBUG_MSRS;
>  			ent->eax |= HV_ACCESS_REENLIGHTENMENT;

Doesn't KVM also need to switch to enforcing the "access" flag?

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index c284a605e453..ca91547034e4 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1282,7 +1282,7 @@ static bool hv_check_msr_access(struct kvm_vcpu_hv *hv_vcpu, u32 msr)
        case HV_X64_MSR_SYNDBG_OPTIONS:
        case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
                return hv_vcpu->cpuid_cache.features_edx &
-                       HV_FEATURE_DEBUG_MSRS_AVAILABLE;
+                       HV_ACCESS_DEBUG_MSRS;
        default:
                break;
        }

