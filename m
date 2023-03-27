Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1BB6C9A3B
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 05:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232365AbjC0DeY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Mar 2023 23:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232380AbjC0Ddx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Mar 2023 23:33:53 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EA325244;
        Sun, 26 Mar 2023 20:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679888016; x=1711424016;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nxfAgc5ecFlYMIYq+Laj/P3oIvX7oAWJ+xSWuaR1CDs=;
  b=YwTkDZjidC7NLWLxL+b2imb5DCuUiBHRxUrSXI/eIWMIoefDiUaGyrtd
   MgXX3HSaYStWZWhLhR85gKdzvJwL47kMXHLASp0OjZeMEkOqWciIAjcw6
   PE0iWpCnlCJHXE2mDka87HcA820mtlmyPC4RKdWY7qovgO1+3f25BCf/v
   CJOGCKQ9du0Wq8ob2UyZvGck07POKKWLep1kTV6OFSjoolO3X2ufPJbUv
   xNAyFrZHjxcO9s8k86c+t6FltXBkWkCV7KjUwH3LL2txyBPH6JHJyVhMX
   8uGZiHvnemmI3041RLqRLVJFmgZFFJICuGm+iy9AIYeAexlHf1R8nRwV8
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="340197826"
X-IronPort-AV: E=Sophos;i="5.98,293,1673942400"; 
   d="scan'208";a="340197826"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2023 20:33:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="752538192"
X-IronPort-AV: E=Sophos;i="5.98,293,1673942400"; 
   d="scan'208";a="752538192"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.174.244]) ([10.249.174.244])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2023 20:33:34 -0700
Message-ID: <373823f7-00ba-070c-53c7-384d29889e40@intel.com>
Date:   Mon, 27 Mar 2023 11:33:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.0
Subject: Re: [PATCH 5/6] KVM: x86: Virtualize FLUSH_L1D and passthrough
 MSR_IA32_FLUSH_CMD
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jim Mattson <jmattson@google.com>
References: <20230322011440.2195485-1-seanjc@google.com>
 <20230322011440.2195485-6-seanjc@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20230322011440.2195485-6-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/22/2023 9:14 AM, Sean Christopherson wrote:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c83ec88da043..3c58dbae7b4c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3628,6 +3628,18 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   
>   		wrmsrl(MSR_IA32_PRED_CMD, PRED_CMD_IBPB);
>   		break;
> +	case MSR_IA32_FLUSH_CMD:
> +		if (!msr_info->host_initiated &&
> +		    !guest_cpuid_has(vcpu, X86_FEATURE_FLUSH_L1D))
> +			return 1;
> +
> +		if (!boot_cpu_has(X86_FEATURE_FLUSH_L1D) || (data & ~L1D_FLUSH))
> +			return 1;
> +		if (!data)
> +			break;
> +
> +		wrmsrl(MSR_IA32_FLUSH_CMD, L1D_FLUSH);
> +		break;

Then KVM provides the ability to flush the L1 data cache of host to 
userspace. Can it be exploited to degrade the host performance if 
userspace VMM keeps flushing the L1 data cache?
