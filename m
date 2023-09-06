Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74A92793573
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 08:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241831AbjIFGlO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 02:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235180AbjIFGlN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 02:41:13 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A32CFC;
        Tue,  5 Sep 2023 23:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693982464; x=1725518464;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RsYbEoQMorIDKJhNn8tK8oAOQZCO4LcPFT+r0555VJo=;
  b=mACK08PcQZ6QFb8DTYnjGCTiegS0UssxdBC6Z5gOIZ28NLj62CCCzMC7
   hiyZPcTgXFzvInKJ/tGdGqfEckpShzcjktnOFdx5wXFqKQZYrDjoj5om3
   iBmYWPW/aMxWSrcFMSJzGe4tMqbaMpvord20TYij1Nxzyg+y1G9xc4zgp
   cA/lISdYgmSi3zOKapi747+IsbybdBho5yWB0oPm6oHehdzw05OnaYbBi
   +KsBZcUZt9cO3lZwdOP6eji9usPeUIhgWhFipb/FQoguwVGpGJBaInIhZ
   8cFHPOmfBOfKhupTPULrETn6RyyTIs/bDcL3bMN/zVKsy21FFALrrNEyH
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10824"; a="375890324"
X-IronPort-AV: E=Sophos;i="6.02,231,1688454000"; 
   d="scan'208";a="375890324"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2023 23:41:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10824"; a="691192510"
X-IronPort-AV: E=Sophos;i="6.02,231,1688454000"; 
   d="scan'208";a="691192510"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.11.250]) ([10.93.11.250])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2023 23:41:02 -0700
Message-ID: <10bdaf6d-1c5c-6502-c340-db3f84bf74a1@intel.com>
Date:   Wed, 6 Sep 2023 14:40:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.15.0
Subject: Re: [PATCH] KVM: X86: Reduce calls to vcpu_load
To:     Hao Peng <flyingpenghao@gmail.com>, pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org
References: <CAPm50aLd5ZbAqd8O03fEm6UhHB_svfFLA19zBfgpDEQsQUhoGw@mail.gmail.com>
Content-Language: en-US
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <CAPm50aLd5ZbAqd8O03fEm6UhHB_svfFLA19zBfgpDEQsQUhoGw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/6/2023 2:24 PM, Hao Peng wrote:
> From: Peng Hao <flyingpeng@tencent.com>
> 
> The call of vcpu_load/put takes about 1-2us. Each
> kvm_arch_vcpu_create will call vcpu_load/put
> to initialize some fields of vmcs, which can be
> delayed until the call of vcpu_ioctl to process
> this part of the vmcs field, which can reduce calls
> to vcpu_load.

what if no vcpu ioctl is called after vcpu creation?

And will the first (it was second before this patch) vcpu_load() becomes 
longer? have you measured it?

I don't think it worth the optimization unless a strong reason.

> Signed-off-by: Peng Hao <flyingpeng@tencent.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  1 +
>   arch/x86/kvm/x86.c              | 21 ++++++++++++++++-----
>   2 files changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 9320019708f9..2f2dcd283788 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -984,6 +984,7 @@ struct kvm_vcpu_arch {
>          /* Flush the L1 Data cache for L1TF mitigation on VMENTER */
>          bool l1tf_flush_l1d;
> 
> +       bool initialized;
>          /* Host CPU on which VM-entry was most recently attempted */
>          int last_vmentry_cpu;
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4fd08a5e0e98..a3671a54e850 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -317,7 +317,20 @@ const struct kvm_stats_header kvm_vcpu_stats_header = {
>   u64 __read_mostly host_xcr0;
> 
>   static struct kmem_cache *x86_emulator_cache;
> +static int kvm_set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz);
> 
> +static inline bool kvm_vcpu_initialized(struct kvm_vcpu *vcpu)
> +{
> +       return vcpu->arch.initialized;
> +}
> +
> +static void kvm_vcpu_initial_reset(struct kvm_vcpu *vcpu)
> +{
> +       kvm_set_tsc_khz(vcpu, vcpu->kvm->arch.default_tsc_khz);
> +       kvm_vcpu_reset(vcpu, false);
> +       kvm_init_mmu(vcpu);
> +       vcpu->arch.initialized = true;
> +}
>   /*
>    * When called, it means the previous get/set msr reached an invalid msr.
>    * Return true if we want to ignore/silent this failed msr access.
> @@ -5647,6 +5660,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
> 
>          vcpu_load(vcpu);
> 
> +       if (!kvm_vcpu_initialized(vcpu))
> +               kvm_vcpu_initial_reset(vcpu);
> +
>          u.buffer = NULL;
>          switch (ioctl) {
>          case KVM_GET_LAPIC: {
> @@ -11930,11 +11946,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>          vcpu->arch.msr_platform_info = MSR_PLATFORM_INFO_CPUID_FAULT;
>          kvm_xen_init_vcpu(vcpu);
>          kvm_vcpu_mtrr_init(vcpu);
> -       vcpu_load(vcpu);
> -       kvm_set_tsc_khz(vcpu, vcpu->kvm->arch.default_tsc_khz);
> -       kvm_vcpu_reset(vcpu, false);
> -       kvm_init_mmu(vcpu);
> -       vcpu_put(vcpu);
>          return 0;
> 
>   free_guest_fpu:
> --
> 2.31.1

