Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADB3960ADCE
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 16:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232153AbiJXOfS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 10:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237266AbiJXOeO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 10:34:14 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E60413F60;
        Mon, 24 Oct 2022 06:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666616976; x=1698152976;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=H+UH4sWxAAafC5t6pknnfnxHhfMUxgyES/6UxjAPSZ0=;
  b=hy4I2kBIRmn5inwr3Cg49OmTZ7m/MPdFCoYqI4VepUH9JTw4YV6DKajS
   FFw5d3PqwENDXkuvF1V5qkUwAg9qW0oVz6EsoySzoRmomKoJpftthJCCt
   HpuFqPsyy6DjT47lHDVlVI8U8Php5TvzvcmK9mZ/FZ/Y2cfFfyIiArF9d
   F7vvOkm7UBGplwJCdxK2SoTFLueYDHqfjCQeM/RheLjakyLn7WZh1MEjG
   SN0PTjN+LGSwp6o78pi30WBXqdUYM5cNs3JSkOC0G1zJD7pps+ZWywxSI
   +YT9ub2mEVrxpKVcs5kUwc0KZ7OumQrZk7t6f3F1LyGE50kfXLMBiYdxc
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10510"; a="333996261"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="333996261"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 06:06:55 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10510"; a="662424350"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="662424350"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.30.136]) ([10.255.30.136])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 06:06:52 -0700
Message-ID: <d65ad6f3-1850-a82e-adaa-91657c38a6f4@intel.com>
Date:   Mon, 24 Oct 2022 21:06:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.3.3
Subject: Re: [PATCH] KVM: x86: Do not expose the host value of CPUID.8000001EH
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, jmattson@google.com
References: <20221022082643.1725875-1-pbonzini@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20221022082643.1725875-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/22/2022 4:26 PM, Paolo Bonzini wrote:
> Several fields of CPUID.8000001EH (ExtendedApicId in EAX[31:0],
> CoreId in EBX[7:0], NodeId in ECX[7:0]) vary on each processor,
> and it is simply impossible to fit the right values in the
> KVM_GET_SUPPORTED_CPUID API, in such a way that they can be
> passed to KVM_SET_CPUID2.
> 
> The most likely way to avoid confusion in the guest is to zero
> out all the values.  Userspace will most likely override it
> anyway if it want to present a specific topology to the guest.
> 
> This patch essentially reverts commit 382409b4c43e ("kvm: x86: Include
> CPUID leaf 0x8000001e in kvm's supported CPUID").

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/cpuid.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index a0292ba650df..380b71600a9e 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1193,6 +1193,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>   		entry->ebx = entry->ecx = entry->edx = 0;
>   		break;
>   	case 0x8000001e:
> +		/* Different on each processor, just hide it.  */
> +		entry->eax = entry->ebx = entry->ecx = 0;
> +		entry->edx = 0;
>   		break;
>   	case 0x8000001F:
>   		if (!kvm_cpu_cap_has(X86_FEATURE_SEV)) {

