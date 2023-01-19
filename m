Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78258673170
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 06:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbjASF5y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 00:57:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbjASF5t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 00:57:49 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C4CBB
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 21:57:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674107865; x=1705643865;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=KNpPMwDpmt+Ckl2yr45xZwHLYpZDrRlQKvQEuuNl+Jc=;
  b=jJrGHmJ8MkqBHjN9kHgPccfJyvVmzDdxMPEA7JYFcD9V7O8JIsBqPS1I
   zX45Ke+1Gstj4DCRWgz9ZdFB5YDGVAhwaLUGSLbLcpG1M9l+vNUin2dyn
   rUhJ2H07lXmBLlMZJVY2hX7Vo10Xh85DjvZElY5YE031aP4EJw4nN0suK
   Ce6a+lxRl7E19ijaeAtII3Y7O0E4cBLfXDy0wNurhOqnsDePIj/4HywaN
   pj53xD515nQ/6B92/2ssPoM+Cj6E8Z0SHC0uRMuLSJEUvvpazM1w5V89G
   HC4vD55X4wOez6nHm1hejWfxoOyHKjOHloATFX+GPSah/Hj5uidDTn250
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="327277905"
X-IronPort-AV: E=Sophos;i="5.97,228,1669104000"; 
   d="scan'208";a="327277905"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 21:57:45 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="662006896"
X-IronPort-AV: E=Sophos;i="5.97,228,1669104000"; 
   d="scan'208";a="662006896"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.30.19]) ([10.255.30.19])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 21:57:43 -0800
Message-ID: <d635edea-e181-3498-ceff-72434ab856cf@intel.com>
Date:   Thu, 19 Jan 2023 13:57:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.6.1
Subject: Re: [RFC] KVM: x86: Give host userspace control for
 MSR_RAPL_POWER_UNIT and MSR_PKG_POWER_STATUS
Content-Language: en-US
To:     Anthony Harivel <aharivel@redhat.com>, kvm@vger.kernel.org
Cc:     rjarry@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        Christophe Fontaine <cfontain@redhat.com>
References: <20230118142123.461247-1-aharivel@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20230118142123.461247-1-aharivel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/18/2023 10:21 PM, Anthony Harivel wrote:
> Allow userspace to update the MSR_RAPL_POWER_UNIT and
> MSR_PKG_POWER_STATUS powercap registers. By default, these MSRs still
> return 0.
> 
> This enables VMMs running on top of KVM with access to energy metrics
> like /sys/devices/virtual/powercap/*/*/energy_uj to compute VMs power
> values in proportion with other metrics (e.g. CPU %guest, steal time,
> etc.) and periodically update the MSRs with ioctl KVM_SET_MSRS so that
> the guest OS can consume them using power metering tools.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Christophe Fontaine <cfontain@redhat.com>
> Signed-off-by: Anthony Harivel <aharivel@redhat.com>
> ---
> 
> Notes:
>      The main goal of this patch is to bring a first step to give energy
>      awareness to VMs.
>      
>      As of today, KVM always report 0 in these MSRs since the entire host
>      power consumption needs to be hidden from the guests. However, there is
>      no fallback mechanism for VMs to measure their power usage.
>      
>      The idea is to let the VMMs running on top of KVM periodically update
>      those MSRs with representative values of the VM's power consumption.
>      
>      If this solution is accepted, VMMs like QEMU will need to be patched to
>      set proper values in these registers and enable power metering in
>      guests.
>      
>      I am submitting this as an RFC to get input/feedback from a broader
>      audience who may be aware of potential side effects of such a mechanism.

Set aside how user space VMM emulate these 2 MSRs correctly, it can 
request the MSR READ to exit to user space via KVM_X86_SET_MSR_FILTER. 
So user space VMM can just enable the read filter of these 2 MSRs and 
provide the emulation itself.




