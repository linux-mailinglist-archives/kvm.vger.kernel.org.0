Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3EAE723799
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 08:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235029AbjFFGZJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 02:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235348AbjFFGYq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 02:24:46 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1D2E1BC7;
        Mon,  5 Jun 2023 23:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686032615; x=1717568615;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CXtd0YeGNfY5a80bxilWa2DrAUjG4CbrDtjbo7HK6Rs=;
  b=Z+ATVHqLY17cvYx+ooqN97Agh/KFvDjyiQmKbnmAhcaMFk4Y1wNJFnhz
   rrvVSlWdf05L5XSfMIiubwe49DOMW7GEnOE5LEw4lXgrVlsxdkEzQ/a5f
   0GOjoc/5J47MKm5aZcg/wiM6EgqOxbIPa2me6mHuSjjNED0AshhGDlGl1
   3QPkZdAF6zVp6BbOqQ0hRaGhHFDayuYSaD5uxiQYHvUMi369KHHqkYVS7
   14cisUx+J7oBuOt3HvYm+rfmt4wihpFF8KQjVwPTVEcb/WfzjJrM9mhWz
   fjSn1smXOMLgp8/FhXeSL+tobyURtOnkRYyoXG9NT2vW3SK4egkLcaZA3
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="336201519"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="336201519"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 23:23:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="742017981"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="742017981"
Received: from zengguan-mobl1.ccr.corp.intel.com (HELO [10.249.170.218]) ([10.249.170.218])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 23:23:01 -0700
Message-ID: <c4166c88-1f99-37bd-bf7a-ac95ba6e82e7@intel.com>
Date:   Tue, 6 Jun 2023 14:22:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v1 3/6] KVM: VMX: Add new ops in kvm_x86_ops for LASS
 violation check
Content-Language: en-US
To:     "Gao, Chao" <chao.gao@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20230601142309.6307-1-guang.zeng@intel.com>
 <20230601142309.6307-4-guang.zeng@intel.com> <ZH1a2ep4o2xiI5wO@chao-email>
From:   Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <ZH1a2ep4o2xiI5wO@chao-email>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/5/2023 11:47 AM, Gao, Chao wrote:
> On Thu, Jun 01, 2023 at 10:23:06PM +0800, Zeng Guang wrote:
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 92d8e65fe88c..98666d1e7727 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1731,6 +1731,8 @@ struct kvm_x86_ops {
>> 	 * Returns vCPU specific APICv inhibit reasons
>> 	 */
>> 	unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct kvm_vcpu *vcpu);
>> +
>> +	bool (*check_lass)(struct kvm_vcpu *vcpu, u64 access, u64 la, u32 flags);
> It is better to declare the @la as gva_t since the address is a virtual address.
>
> Both @access and @flags provide additional informaiton about a memory access. I
> think we can drop one of them e.g. adding a new bit X86EMUL_F_IMPLICIT_ACCESS.
>
> Or maybe in the first place, we can just extend PFERR_? for SKIP_LASS/LAM
> behavior instead of adding another set of flags (X86EMUL_F_?). The benefit of
> adding new flags is they won't collide with future hardware extensions. I am not
> sure.
Make sense. Prefer to adding a new bit of X86EMUL flags.
PFERR_ is used for page fault case and actually not proper to be taken for
LASS/LAM usage.
