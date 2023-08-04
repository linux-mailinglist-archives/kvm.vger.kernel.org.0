Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 439CB770843
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 20:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbjHDSzb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 14:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbjHDSz1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 14:55:27 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9555FBA
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 11:55:25 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-58667d06607so25290957b3.1
        for <kvm@vger.kernel.org>; Fri, 04 Aug 2023 11:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691175325; x=1691780125;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NAPgIg7L4ziLXGFvzhNY7osXv5BuPJ5kgHsCha/MeAE=;
        b=09X1PUv7wpVwOes147v9SG1Z9gh2smyMNp1zr/AKW5J7WbIvI9peuAGdjUMF0DVZaN
         aveQQbAeGVvLVaOmRpdotnUfmY6/+glZY/8QXZk81Nw4eLGjgnNx+LsR/27PvBuNlAqa
         UAE4QP+cBygiZYxD1KyzcDLJZgL43r+Q0cw1lCxopxYALDbeVIKL22C/1jMrUc4whjg9
         gFzmcQEDLp3cyQe6ixy1lCwPk986b+m355poJdXzKb9cpeANB9fZ8uCB6ov7MUBxl6d6
         pwaRY2SwjsUwbYiY8FLiTJHvxkorxgvvTJKokzpT59chWGwK6zoyzCTI9XsE+Fr1LkaE
         oKmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691175325; x=1691780125;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NAPgIg7L4ziLXGFvzhNY7osXv5BuPJ5kgHsCha/MeAE=;
        b=XG+YGI0xFeG0QydbRhU1hmBQ0PdMKS1inOFbrNXxOVy7c5KghHnlSPPlJPKd1PlErG
         heo37VZf00vCV8TDpoJ4uvp0wI8td5qFVL/LI/Xrlf1bJgIhmzYbm7MvlDnWgOTI8M9J
         HNsu7XX15aOKp9YTsL1oEm0fCK8Iva4cdfkdwaZym30XfXF8c6kcqAWuq7lYLE8UXeIB
         xmj8nRVaLO30xGVtd70oa6roWUvo5mdlQo2ay2cGC7X7T+3evpk1oQNxtA4dKJz87mmm
         XT9mkOznIz6dhNsWAtTbZUewDVz97x8QdDL2vf4OAUZc3Rh2IFuVrko5TBfjISum0sUf
         4qLg==
X-Gm-Message-State: AOJu0YxnjcZTxMw+Hz+OXoRS2r2bQ8YCKc9t5hhdmbs+qC3brUPhrgwA
        DmiPYczZodA9Y0QYQpMUY07EKCiLICg=
X-Google-Smtp-Source: AGHT+IFExXfiQLDG+1YqUi84WVhwKGQeKxbGbbX5j1WutV1i3yIABmdTQnuznjCByAyoYcETU0Qsaf4SKqA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:441a:0:b0:584:4158:7f86 with SMTP id
 r26-20020a81441a000000b0058441587f86mr18476ywa.1.1691175324835; Fri, 04 Aug
 2023 11:55:24 -0700 (PDT)
Date:   Fri, 4 Aug 2023 11:55:23 -0700
In-Reply-To: <20230803042732.88515-9-weijiang.yang@intel.com>
Mime-Version: 1.0
References: <20230803042732.88515-1-weijiang.yang@intel.com> <20230803042732.88515-9-weijiang.yang@intel.com>
Message-ID: <ZM1JmxzyMgTLeEIy@google.com>
Subject: Re: [PATCH v5 08/19] KVM:x86: Report KVM supported CET MSRs as to-be-saved
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, peterz@infradead.org, john.allen@amd.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rick.p.edgecombe@intel.com, chao.gao@intel.com,
        binbin.wu@linux.intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 03, 2023, Yang Weijiang wrote:
> Add all CET MSRs including the synthesized GUEST_SSP to report list.
> PL{0,1,2}_SSP are independent to host XSAVE management with later
> patches. MSR_IA32_U_CET and MSR_IA32_PL3_SSP are XSAVE-managed on
> host side. MSR_IA32_S_CET/MSR_IA32_INT_SSP_TAB/MSR_KVM_GUEST_SSP
> are not XSAVE-managed.
> 
> When CET IBT/SHSTK are enumerated to guest, both user and supervisor
> modes should be supported for architechtural integrity, i.e., two
> modes are supported as both or neither.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/include/uapi/asm/kvm_para.h |  1 +
>  arch/x86/kvm/x86.c                   | 10 ++++++++++
>  arch/x86/kvm/x86.h                   | 10 ++++++++++
>  3 files changed, 21 insertions(+)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> index 6e64b27b2c1e..7af465e4e0bd 100644
> --- a/arch/x86/include/uapi/asm/kvm_para.h
> +++ b/arch/x86/include/uapi/asm/kvm_para.h
> @@ -58,6 +58,7 @@
>  #define MSR_KVM_ASYNC_PF_INT	0x4b564d06
>  #define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
>  #define MSR_KVM_MIGRATION_CONTROL	0x4b564d08
> +#define MSR_KVM_GUEST_SSP	0x4b564d09
>  
>  struct kvm_steal_time {
>  	__u64 steal;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 82b9f14990da..d68ef87fe007 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1463,6 +1463,9 @@ static const u32 msrs_to_save_base[] = {
>  
>  	MSR_IA32_XFD, MSR_IA32_XFD_ERR,
>  	MSR_IA32_XSS,
> +	MSR_IA32_U_CET, MSR_IA32_S_CET,
> +	MSR_IA32_PL0_SSP, MSR_IA32_PL1_SSP, MSR_IA32_PL2_SSP,
> +	MSR_IA32_PL3_SSP, MSR_IA32_INT_SSP_TAB, MSR_KVM_GUEST_SSP,
>  };
>  
>  static const u32 msrs_to_save_pmu[] = {
> @@ -7214,6 +7217,13 @@ static void kvm_probe_msr_to_save(u32 msr_index)
>  		if (!kvm_caps.supported_xss)
>  			return;
>  		break;
> +	case MSR_IA32_U_CET:
> +	case MSR_IA32_S_CET:
> +	case MSR_KVM_GUEST_SSP:
> +	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
> +		if (!kvm_is_cet_supported())
> +			return;
> +		break;
>  	default:
>  		break;
>  	}
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 82e3dafc5453..6e6292915f8c 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -362,6 +362,16 @@ static inline bool kvm_mpx_supported(void)
>  		== (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
>  }
>  
> +#define CET_XSTATE_MASK (XFEATURE_MASK_CET_USER)

This is funky.  As of this patch, KVM reports MSR_IA32_S_CET, a supervisor MSR,
but does not require XFEATURE_MASK_CET_KERNEL.  That eventually comes along with
"KVM:x86: Enable guest CET supervisor xstate bit support", but as of this patch
KVM is busted.

The whole cpuid_count() code in that patch shouldn't exist, so the easiest thing
is to just fold the KVM_SUPPORTED_XSS and CET_XSTATE_MASK changes from that patch
into this one.
