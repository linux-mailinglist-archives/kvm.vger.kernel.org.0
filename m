Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0E8A7FB7
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 11:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729831AbfIDJsR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 05:48:17 -0400
Received: from mga05.intel.com ([192.55.52.43]:13728 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728259AbfIDJsR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 05:48:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Sep 2019 02:48:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,465,1559545200"; 
   d="scan'208";a="334155828"
Received: from rjwysock-mobl1.ger.corp.intel.com (HELO [10.249.130.107]) ([10.249.130.107])
  by orsmga004.jf.intel.com with ESMTP; 04 Sep 2019 02:48:14 -0700
Subject: Re: [PATCH v2] cpuidle-haltpoll: Enable kvm guest polling when
 dedicated physical CPUs are available
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Linux PM <linux-pm@vger.kernel.org>
References: <1567068597-22419-1-git-send-email-wanpengli@tencent.com>
From:   "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
Message-ID: <a70aeec2-1572-ea09-a0c5-299cd70ddc8a@intel.com>
Date:   Wed, 4 Sep 2019 11:48:13 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1567068597-22419-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/29/2019 10:49 AM, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
>
> The downside of guest side polling is that polling is performed even
> with other runnable tasks in the host. However, even if poll in kvm
> can aware whether or not other runnable tasks in the same pCPU, it
> can still incur extra overhead in over-subscribe scenario. Now we can
> just enable guest polling when dedicated pCPUs are available.
>
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>

As stated before, I'm going to queue up this change for 5.4, with the 
Paolo's ACK.

BTW, in the future please CC power management changes to 
linux-pm@vger.kernel.org for easier handling.

> --
> v1 -> v2:
>   * export kvm_arch_para_hints to fix haltpoll driver build as module error
>   * just disable haltpoll driver instead of both driver and governor
>     since KVM_HINTS_REALTIME is not defined in other arches, and governor
>     doesn't depend on x86, to fix the warning on powerpc
>
>   arch/x86/kernel/kvm.c              | 1 +
>   drivers/cpuidle/cpuidle-haltpoll.c | 3 ++-
>   2 files changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index f48401b..68463c1 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -711,6 +711,7 @@ unsigned int kvm_arch_para_hints(void)
>   {
>   	return cpuid_edx(kvm_cpuid_base() | KVM_CPUID_FEATURES);
>   }
> +EXPORT_SYMBOL_GPL(kvm_arch_para_hints);
>   
>   static uint32_t __init kvm_detect(void)
>   {
> diff --git a/drivers/cpuidle/cpuidle-haltpoll.c b/drivers/cpuidle/cpuidle-haltpoll.c
> index 9ac093d..7aee38a 100644
> --- a/drivers/cpuidle/cpuidle-haltpoll.c
> +++ b/drivers/cpuidle/cpuidle-haltpoll.c
> @@ -53,7 +53,8 @@ static int __init haltpoll_init(void)
>   
>   	cpuidle_poll_state_init(drv);
>   
> -	if (!kvm_para_available())
> +	if (!kvm_para_available() ||
> +		!kvm_para_has_hint(KVM_HINTS_REALTIME))
>   		return 0;
>   
>   	ret = cpuidle_register(&haltpoll_driver, NULL);


