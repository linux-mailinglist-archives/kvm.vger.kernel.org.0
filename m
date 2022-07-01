Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3D865628B5
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 04:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232741AbiGACH2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 22:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232241AbiGACH1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 22:07:27 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63620523B5
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 19:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656641246; x=1688177246;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ds24FL4FdnQ4CfC9kGx+SV17YElVn8ikAcNhkE1ZgFw=;
  b=UO04GMf/h7Xb5AmNzKqq+xQ06TdH4vAz6C2VJ50VJ6k18amLnLn1jmzp
   fVost0Ww190eHJfyUb4zwG2+Etwu9YsbkYUq+LscKM8FJXrs7/mNGIdVp
   z0yHnDDh9ptfAsh/A9qEnYsqTzXeWhj6PFVjGUuvtrSCK0BHA5/gc7Bf/
   VBi5iKuAwOVwUjtv/vhz0xUOFryGAGV0CwjuoMa4EdSaFt58BSX6vc2Wj
   Msn4z8HQ4qNs6qKPhAc+mGU6BwkeE9fWEnXuFwNRBx190v7zyxkfBnAIH
   MXfL+k5weyEC+okHPE4ObOeQWrUMVjfo70aefl9508xy4NY3twxk6keVE
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="281291314"
X-IronPort-AV: E=Sophos;i="5.92,236,1650956400"; 
   d="scan'208";a="281291314"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 19:07:26 -0700
X-IronPort-AV: E=Sophos;i="5.92,236,1650956400"; 
   d="scan'208";a="596059757"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.169.250]) ([10.249.169.250])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 19:07:22 -0700
Message-ID: <958774eb-90df-34e9-e025-959c3eb60614@intel.com>
Date:   Fri, 1 Jul 2022 10:07:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.10.0
Subject: Re: [PATCH v5 4/8] KVM: x86: Add Corrected Machine Check Interrupt
 (CMCI) emulation to lapic.
Content-Language: en-US
To:     Jue Wang <juew@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Matlack <dmatlack@google.com>
Cc:     Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        Greg Thelen <gthelen@google.com>,
        Jiaqi Yan <jiaqiyan@google.com>
References: <20220610171134.772566-1-juew@google.com>
 <20220610171134.772566-5-juew@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220610171134.772566-5-juew@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/11/2022 1:11 AM, Jue Wang wrote:
...
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4790f0d7d40b..a08693808729 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4772,6 +4772,8 @@ static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
>   	/* Init IA32_MCi_CTL to all 1s */
>   	for (bank = 0; bank < bank_num; bank++)
>   		vcpu->arch.mce_banks[bank*4] = ~(u64)0;
> +	vcpu->arch.apic->nr_lvt_entries =
> +		KVM_APIC_MAX_NR_LVT_ENTRIES - !(mcg_cap & MCG_CMCI_P);

vcpu->arch.apic->nr_lvt_entries needs to be initialized as 
KVM_APIC_MAX_NR_LVT_ENTREIS - 1 when creating lapic.

What if userspace doesn't call KVM_X86_SETUP_MCE at all?

>   
>   	static_call(kvm_x86_setup_mce)(vcpu);
>   out:

