Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E18E467A75A
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 01:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbjAYAKR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 19:10:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjAYAKQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 19:10:16 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0BE4474E4
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 16:10:15 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id v23so16402085plo.1
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 16:10:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kvQQY5R/smm2VpLt79RKnjfK0iF1mBHjWIkac6Aen1w=;
        b=DePKpPk+izzwBKxlN6VqyaCycZe6DgWRR0tmOk/Qy5d7YS05HX83MPEYVtNPSLLclj
         qZre+ZkAG7HUdzU1qJscs8RAa3BiuAJlF9fw8GKkz5rXiWOwMDD7FK0nR4BSL3YHF/sp
         UwbNZNzBvdEAnyLXw7W0w5xJg4VYFWMnNr6NzpdG+IZwcAH0pBN8ESPjUxqjZKLhoy/+
         3KJtQhMkBvy11jsxRXOTULAVH5BRjyy3Tj6DkzpIONTYBuEJ0kPVCTps5iSJrYKuAskP
         y0vA4ImMwi8WYqhBNFZNDUox5Sbq0hbSZ34aXC13ikv74oDNrRBDIdqFTJNdAPb1VInx
         EhEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kvQQY5R/smm2VpLt79RKnjfK0iF1mBHjWIkac6Aen1w=;
        b=5HeQ7TAvpPdy2dU3hA7meFsMXAxYtd9AzTN75jgGJKIhxQo5nd5l6XVzAxHt8+CsJ/
         sUnIJFSkBDRUBLABCi2wmmtmZiC6Mno0FLV+Z6lz1I8r4M/KmhUEpSrrr4LVMVJpI4++
         Z+ip7rvyWZvmZJgzGgGVXTI9UrR+NXssXO4hyVjh7JkbvxGROvg2gx9+zsXRdUIHwX1c
         NZqg3olnApcAKJxBw14XynmK1xlBU28DhBIRoKfuBDBr3YzxnuXmKu3jkBqjLJk2nCpP
         Bq7gfeZacOz9wWiPuoaBmmKbymdkyd47dsnx9lStg3r1X7gpUj+2Ba0F/wgc1DxWZJRg
         ztDA==
X-Gm-Message-State: AO0yUKUhl2/yOCCSP4wrs0w75IOWhmZhaf1gwSQtZyYcXcPrg/nA1EXm
        BY8J+1gCfMA1HYPS21gTvv096A==
X-Google-Smtp-Source: AK7set/jVpOixJjbQ2WRp5+nE0HpwuNbU1zpLJ9qSvLTawGNSnxn+fFUXp15uUUfsCklU1ALw/xoqw==
X-Received: by 2002:a05:6a21:998a:b0:b8:c859:7fc4 with SMTP id ve10-20020a056a21998a00b000b8c8597fc4mr501308pzb.1.1674605414680;
        Tue, 24 Jan 2023 16:10:14 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u4-20020a17090ae00400b0022bbad75af4sm139372pjy.2.2023.01.24.16.10.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 16:10:14 -0800 (PST)
Date:   Wed, 25 Jan 2023 00:10:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sandipan Das <sandipan.das@amd.com>
Subject: Re: [PATCH v3 6/8] KVM: x86/svm/pmu: Add AMD PerfMonV2 support
Message-ID: <Y9BzYzEjAwUA+wuy@google.com>
References: <20221111102645.82001-1-likexu@tencent.com>
 <20221111102645.82001-7-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221111102645.82001-7-likexu@tencent.com>
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

On Fri, Nov 11, 2022, Like Xu wrote:
On Fri, Nov 11, 2022, Like Xu wrote:
> @@ -162,20 +179,42 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
>  {
>       struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +     struct kvm_cpuid_entry2 *entry;
> +     union cpuid_0x80000022_ebx ebx;
>
> -     if (guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE))
> -             pmu->nr_arch_gp_counters = AMD64_NUM_COUNTERS_CORE;
> +     pmu->version = 1;
> +     if (kvm_cpu_cap_has(X86_FEATURE_AMD_PMU_V2) &&

Why check kvm_cpu_cap support?  I.e. what will go wrong if userspace enumerates
PMU v2 to the guest without proper hardware/KVM support.

If this is _necessary_ to protect the host kernel, then we should probably have
a helper to query PMU features, e.g.

static __always_inline bool guest_pmu_has(struct kvm_vcpu *vcpu,
                                          unsigned int x86_feature)
{
        return kvm_cpu_cap_has(x86_feature) &&
               guest_cpuid_has(vcpu, x86_feature);
}



> +         guest_cpuid_has(vcpu, X86_FEATURE_AMD_PMU_V2)) {
> +             pmu->version = 2;
> +             entry = kvm_find_cpuid_entry_index(vcpu, 0x80000022, 0);
> +             ebx.full = entry->ebx;
> +             pmu->nr_arch_gp_counters = min3((unsigned int)ebx.split.num_core_pmc,
> +                                             (unsigned int)kvm_pmu_cap.num_counters_gp,
> +                                             (unsigned int)KVM_AMD_PMC_MAX_GENERIC);

Blech.  This really shouldn't be necessary, KVM should tweak kvm_pmu_cap.num_counters_gp
as needed during initialization to ensure num_counters_gp doesn't exceed KVM's
internal limits.

Posted a patch[*], please take a look.  As mentioned in that thread, I'll somewhat
speculatively apply that series sooner than later so that you can use it a base
for this series (assuming the patch isn't busted).

[*] https://lore.kernel.org/all/20230124234905.3774678-2-seanjc@google.com

> +     }
> +
> +     /* Commitment to minimal PMCs, regardless of CPUID.80000022 */

Please expand this comment.  I'm still not entirely sure I've interpreted it correctly,
and I'm not sure that I agree with the code.

> +     if (kvm_cpu_cap_has(X86_FEATURE_PERFCTR_CORE) &&

AFAICT, checking kvm_cpu_cap_has() is an unrelated change.  Either it's a bug fix
and belongs in a separate patch, or it's unnecessary and should be dropped.

> +         guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE))
> +             pmu->nr_arch_gp_counters = max_t(unsigned int,
> +                                              pmu->nr_arch_gp_counters,
> +                                              AMD64_NUM_COUNTERS_CORE);
>       else
> -             pmu->nr_arch_gp_counters = AMD64_NUM_COUNTERS;
> +             pmu->nr_arch_gp_counters = max_t(unsigned int,
> +                                              pmu->nr_arch_gp_counters,
> +                                              AMD64_NUM_COUNTERS);

Using max() doesn't look right.  E.g. if KVM ends up running on some odd setup
where ebx.split.num_core_pmc/kvm_pmu_cap.num_counters_gp is less than
AMD64_NUM_COUNTERS_CORE or AMD64_NUM_COUNTERS.

Or more likely, if userspace says "only expose N counters to this guest".

Shouldn't this be something like?

	if (guest_cpuid_has(vcpu, X86_FEATURE_AMD_PMU_V2))
		pmu->nr_arch_gp_counters = min(ebx.split.num_core_pmc,
					       kvm_pmu_cap.num_counters_gp);
	else if (guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE))
		pmu->nr_arch_gp_counters = AMD64_NUM_COUNTERS_CORE;
	else
		pmu->nr_arch_gp_counters = AMD64_NUM_COUNTERSE;
