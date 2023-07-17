Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BAFA755E8D
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 10:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbjGQIe6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 04:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjGQIe5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 04:34:57 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C9AAB;
        Mon, 17 Jul 2023 01:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689582896; x=1721118896;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=p+2MBbp7DfMBY9uUpI0k2O5ka2dgnho/rcp7Fwl0hZs=;
  b=XarzJTBacxdc2F6QBpkgtPXhCiJgcs3cs8/E7ra5kwCMVRe6If1QhKWH
   8WKhlhTSBlXGDyYtejqqtuVnBIOlw9qIl8j605ReJns1RosS7T4yLImV7
   G6tAGHybmcMRaDdaahIvTv4Jo3Jkcj6i4bOb0WGSrsCYt01PpgFVtd87X
   LHz6ESDg10uevq48mRJPDvsk6piDHOl/m9yFkCd8BFA9qvDFPjjroJi0v
   iJosZEgfnLOAHFMEKsW5qD7nXn3i9ic6yPWe4en3lCotnqfZfT8lvTp3E
   Iuxeod+YKlyQMKBiwHG8AaUMJQShPJCPMXWoKnP4uB6PysnZhDHTNPVFI
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10773"; a="365918277"
X-IronPort-AV: E=Sophos;i="6.01,211,1684825200"; 
   d="scan'208";a="365918277"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2023 01:34:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10773"; a="1053817625"
X-IronPort-AV: E=Sophos;i="6.01,211,1684825200"; 
   d="scan'208";a="1053817625"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.6.77]) ([10.93.6.77])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2023 01:34:54 -0700
Message-ID: <5c7de6d5-7706-c4a5-7c41-146db1269aff@intel.com>
Date:   Mon, 17 Jul 2023 16:34:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.13.0
Subject: Re: [PATCH 3/4] intel_idle: Add support for using intel_idle in a VM
 guest using just hlt
To:     arjan@linux.intel.com, linux-pm@vger.kernel.org
Cc:     artem.bityutskiy@linux.intel.com, rafael@kernel.org,
        kvm <kvm@vger.kernel.org>, Dan Wu <dan1.wu@intel.com>
References: <20230605154716.840930-1-arjan@linux.intel.com>
 <20230605154716.840930-4-arjan@linux.intel.com>
Content-Language: en-US
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20230605154716.840930-4-arjan@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+ KVM maillist.

On 6/5/2023 11:47 PM, arjan@linux.intel.com wrote:
...
>   
> +static int __init intel_idle_vminit(const struct x86_cpu_id *id)
> +{
> +	int retval;
> +
> +	cpuidle_state_table = vmguest_cstates;
> +
> +	icpu = (const struct idle_cpu *)id->driver_data;
> +
> +	pr_debug("v" INTEL_IDLE_VERSION " model 0x%X\n",
> +		 boot_cpu_data.x86_model);
> +
> +	intel_idle_cpuidle_devices = alloc_percpu(struct cpuidle_device);
> +	if (!intel_idle_cpuidle_devices)
> +		return -ENOMEM;
> +
> +	intel_idle_cpuidle_driver_init(&intel_idle_driver);
> +
> +	retval = cpuidle_register_driver(&intel_idle_driver);
> +	if (retval) {
> +		struct cpuidle_driver *drv = cpuidle_get_driver();
> +		printk(KERN_DEBUG pr_fmt("intel_idle yielding to %s\n"),
> +		       drv ? drv->name : "none");
> +		goto init_driver_fail;
> +	}
> +
> +	retval = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "idle/intel:online",
> +				   intel_idle_cpu_online, NULL);
> +	if (retval < 0)
> +		goto hp_setup_fail;
> +
> +	return 0;
> +hp_setup_fail:
> +	intel_idle_cpuidle_devices_uninit();
> +	cpuidle_unregister_driver(&intel_idle_driver);
> +init_driver_fail:
> +	free_percpu(intel_idle_cpuidle_devices);
> +	return retval;
> +}
> +
>   static int __init intel_idle_init(void)
>   {
>   	const struct x86_cpu_id *id;
> @@ -2074,6 +2195,8 @@ static int __init intel_idle_init(void)
>   	id = x86_match_cpu(intel_idle_ids);
>   	if (id) {
>   		if (!boot_cpu_has(X86_FEATURE_MWAIT)) {
> +			if (boot_cpu_has(X86_FEATURE_HYPERVISOR))
> +				return intel_idle_vminit(id);

It leads to below MSR access error on SPR.

[    4.158636] unchecked MSR access error: RDMSR from 0xe2 at rIP: 
0xffffffffbcaeebed (intel_idle_init_cstates_icpu.constprop.0+0x2dd/0x5a0)
[    4.174991] Call Trace:
[    4.179611]  <TASK>
[    4.183610]  ? ex_handler_msr+0x11e/0x150
[    4.190624]  ? fixup_exception+0x17e/0x3c0
[    4.197648]  ? gp_try_fixup_and_notify+0x1d/0xc0
[    4.205579]  ? exc_general_protection+0x1bb/0x410
[    4.213620]  ? asm_exc_general_protection+0x26/0x30
[    4.221624]  ? __pfx_intel_idle_init+0x10/0x10
[    4.228588]  ? intel_idle_init_cstates_icpu.constprop.0+0x2dd/0x5a0
[    4.238632]  ? __pfx_intel_idle_init+0x10/0x10
[    4.246632]  ? __pfx_intel_idle_init+0x10/0x10
[    4.253616]  intel_idle_vminit.isra.0+0xf5/0x1d0
[    4.261580]  ? __pfx_intel_idle_init+0x10/0x10
[    4.269670]  ? __pfx_intel_idle_init+0x10/0x10
[    4.274605]  do_one_initcall+0x50/0x230
[    4.279873]  do_initcalls+0xb3/0x130
[    4.286535]  kernel_init_freeable+0x255/0x310
[    4.293688]  ? __pfx_kernel_init+0x10/0x10
[    4.300630]  kernel_init+0x1a/0x1c0
[    4.305681]  ret_from_fork+0x29/0x50
[    4.312700]  </TASK>

On Intel SPR, the call site is

intel_idle_vminit()
   -> intel_idle_cpuidle_driver_init()
     -> intel_idle_init_cstates_icpu()
       -> spr_idle_state_table_update()
         -> rdmsrl(MSR_PKG_CST_CONFIG_CONTROL, msr);

However, current KVM doesn't provide emulation for 
MSR_PKG_CST_CONFIG_CONTROL. It leads to #GP on accessing.

>   			pr_debug("Please enable MWAIT in BIOS SETUP\n");
>   			return -ENODEV;
>   		}

