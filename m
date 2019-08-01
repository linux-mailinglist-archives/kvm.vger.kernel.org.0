Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1027E08F
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2019 18:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733181AbfHAQvO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Aug 2019 12:51:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:26210 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725804AbfHAQvN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Aug 2019 12:51:13 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Aug 2019 09:51:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,334,1559545200"; 
   d="scan'208";a="324300981"
Received: from rjwysock-mobl1.ger.corp.intel.com (HELO [10.249.145.65]) ([10.249.145.65])
  by orsmga004.jf.intel.com with ESMTP; 01 Aug 2019 09:51:11 -0700
Subject: Re: [PATCH] cpuidle-haltpoll: Enable kvm guest polling when dedicated
 physical CPUs are available
To:     Wanpeng Li <kernellwp@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Linux PM <linux-pm@vger.kernel.org>
References: <1564643196-7797-1-git-send-email-wanpengli@tencent.com>
From:   "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
Message-ID: <7b1e3025-f513-7068-32ac-4830d67b65ac@intel.com>
Date:   Thu, 1 Aug 2019 18:51:10 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1564643196-7797-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/1/2019 9:06 AM, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
>
> The downside of guest side polling is that polling is performed even
> with other runnable tasks in the host. However, even if poll in kvm
> can aware whether or not other runnable tasks in the same pCPU, it
> can still incur extra overhead in over-subscribe scenario. Now we can
> just enable guest polling when dedicated pCPUs are available.
>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>

Paolo, Marcelo, any comments?


> ---
>   drivers/cpuidle/cpuidle-haltpoll.c   | 3 ++-
>   drivers/cpuidle/governors/haltpoll.c | 2 +-
>   2 files changed, 3 insertions(+), 2 deletions(-)
>
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
> diff --git a/drivers/cpuidle/governors/haltpoll.c b/drivers/cpuidle/governors/haltpoll.c
> index 797477b..685c7007 100644
> --- a/drivers/cpuidle/governors/haltpoll.c
> +++ b/drivers/cpuidle/governors/haltpoll.c
> @@ -141,7 +141,7 @@ static struct cpuidle_governor haltpoll_governor = {
>   
>   static int __init init_haltpoll(void)
>   {
> -	if (kvm_para_available())
> +	if (kvm_para_available() && kvm_para_has_hint(KVM_HINTS_REALTIME))
>   		return cpuidle_register_governor(&haltpoll_governor);
>   
>   	return 0;


