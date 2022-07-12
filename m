Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 356205710C7
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 05:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbiGLDXl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 23:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbiGLDXk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 23:23:40 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 296731088;
        Mon, 11 Jul 2022 20:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657596218; x=1689132218;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Z12SMYSX+r064B/+tjd3g8dC+r9/P1KHbIvSeKh7MKs=;
  b=Py9SB1wFCZ91XPxrVIYVItCDxPsvfv150I2e+KbfcdXr8Mmvfn02d0Zh
   a9ZjVs5KIEVXqffzHCUgSY0n8WA2xXwrP6GaQmxrasAFyCdcIbxRY2UEn
   Llqg65MHRZ0aQuWynAOboZSKzFV1UXdJ0q8OpF4M/GkOcf0zFPabKlpKH
   4Uc4qh9BE2QzmzpdXoeJD+OnxMIdGZgJ69zEPdOLa4lIBo07OYq/v99JY
   R4ojW02kxzIDNxFwqT4FxB9MQSiQ6UQqAuInjsDcJ+XzQsSAnyZnSb39Z
   29OsOVaocXZwiKR3RTSq0m/6oVwugrzizWpXzHGfakptmBUQs8YfRV8y1
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10405"; a="282378005"
X-IronPort-AV: E=Sophos;i="5.92,264,1650956400"; 
   d="scan'208";a="282378005"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 20:23:37 -0700
X-IronPort-AV: E=Sophos;i="5.92,264,1650956400"; 
   d="scan'208";a="570025962"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.169.11]) ([10.249.169.11])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 20:23:36 -0700
Message-ID: <34935bcd-0a5a-e239-d434-42187f94ad09@intel.com>
Date:   Tue, 12 Jul 2022 11:23:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH] KVM: VMX: Update PT MSR intercepts during filter change
 iff PT in host+guest
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220712015838.1253995-1-seanjc@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220712015838.1253995-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/12/2022 9:58 AM, Sean Christopherson wrote:
> Update the Processor Trace (PT) MSR intercepts during a filter change if
> and only if PT may be exposed to the guest, i.e. only if KVM is operating
> in the so called "host+guest" mode where PT can be used simultaneously by
> both the host and guest.  If PT is in system mode, the host is the sole
> owner of PT and the MSRs should never be passed through to the guest.
> 
> Luckily the missed check only results in unnecessary work, as select RTIT
> MSRs are passed through only when RTIT tracing is enabled "in" the guest,
> and tracing can't be enabled in the guest when KVM is in system mode
> (writes to guest.MSR_IA32_RTIT_CTL are disallowed).

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> Cc: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 74ca64e97643..e6ab2c2c4d3b 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4004,7 +4004,9 @@ static void vmx_msr_filter_changed(struct kvm_vcpu *vcpu)
>   			vmx_disable_intercept_for_msr(vcpu, msr, MSR_TYPE_W);
>   	}
>   
> -	pt_update_intercept_for_msr(vcpu);
> +	/* PT MSRs can be passed through iff PT is exposed to the guest. */
> +	if (vmx_pt_mode_is_host_guest())
> +		pt_update_intercept_for_msr(vcpu);
>   }
>   
>   static inline void kvm_vcpu_trigger_posted_interrupt(struct kvm_vcpu *vcpu,
> 
> base-commit: 5406e590ac8fa33e390616031370806cdbcc5791

