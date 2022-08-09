Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B34258D458
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 09:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237901AbiHIHQp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 03:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236554AbiHIHQn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 03:16:43 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9034320BC7;
        Tue,  9 Aug 2022 00:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660029402; x=1691565402;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=kN3AiDLfCB7xaHjL4RjTVvZ38gIhqA9fc7KA5S545+k=;
  b=j2zqk8Cwg0LOJXkDKxj3VRGJTjUEQwvlS+sptScb78fSMSa6dN7+tSDt
   yj8o5qAhny2n6Hal1L0ANY2r+XcMee9hI+ZbAugeg64YD54gXhUkL1JW2
   GrSiwt8XU2MWLgU9XL5qfk/TNaL1cbuXbP0SNvWw7elIyryp8oIHnjM0l
   hWK9AMXDEl5NphhKxCot4ke0lyh8OVMYKCNGBMoqqM6VVl+1Nd0uIQJAy
   tL1NMQeAA9dM9kPFnzThQZ1yCybjwE5CiqTUxOrhtRGBbQWVm1XpwHzcd
   U5WC6ri3O5cxHjSXHdz4z4YQ9K0WXxaRTnhaP98YaeIWHm/g38lKXjv+f
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10433"; a="271158486"
X-IronPort-AV: E=Sophos;i="5.93,223,1654585200"; 
   d="scan'208";a="271158486"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2022 00:16:42 -0700
X-IronPort-AV: E=Sophos;i="5.93,223,1654585200"; 
   d="scan'208";a="672786175"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.249.171.147]) ([10.249.171.147])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2022 00:16:40 -0700
Message-ID: <dacf1c28-88c2-d0f4-b6aa-5556101eca86@linux.intel.com>
Date:   Tue, 9 Aug 2022 15:16:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH v8 003/103] KVM: Refactor CPU compatibility check on
 module initialization
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
 <4092a37d18f377003c6aebd9ced1280b0536c529.1659854790.git.isaku.yamahata@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <4092a37d18f377003c6aebd9ced1280b0536c529.1659854790.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2022/8/8 6:00, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> TDX module requires its initialization.  It requires VMX to be enabled.
> Although there are several options of when to initialize it, the choice is
> the initialization time of the KVM kernel module.  There is no usable
> arch-specific hook for the TDX module to utilize during the KVM kernel module
> initialization.  The code doesn't enable/disable hardware (VMX in TDX case)
> during the kernel module initialization.  Add a hook for enabling hardware,
> arch-specific initialization, and disabling hardware during KVM kernel
> module initialization to make a room for TDX module initialization.  The
> current KVM enables hardware when the first VM is created and disables
> hardware when the last VM is destroyed.  When no VM is running, hardware is
> disabled.  To follow these semantics, the kernel module initialization needs
> to disable hardware. Opportunistically refactor the code to enable/disable
> hardware.
>
> Add hadware_enable_all() and hardware_disable_all() to kvm_init() and
> introduce a new arch-specific callback function,
> kvm_arch_post_hardware_enable_setup, for arch to do arch-specific
> initialization that requires hardware_enable_all().  Opportunistically,
> move kvm_arch_check_processor_compat() to to hardware_enabled_nolock().
> TDX module initialization code will go into
> kvm_arch_post_hardware_enable_setup().
>
> This patch reorders some function calls as below from (*) (**) (A) and (B)
> to (A) (B) and (*).  Here (A) and (B) depends on (*), but not (**).  By
> code inspection, only mips and VMX has the code of (*).  No other
No other or other?


> arch has empty (*).  So refactor mips and VMX and eliminate the
> necessity hook for (*) instead of adding an unused hook.
>
> Before this patch:
> - Arch module initialization
>    - kvm_init()
>      - kvm_arch_init()
>      - kvm_arch_check_processor_compat() on each CPUs
>    - post-arch-specific initialization -- (*): (A) and (B) depends on this
>    - post-arch-specific initialization -- (**): no dependency to (A) and (B)
>
> - When creating/deleting the first/last VM
>     - kvm_arch_hardware_enable() on each CPUs -- (A)
>     - kvm_arch_hardware_disable() on each CPUs -- (B)
>
> After this patch:
> - Arch module initialization
>    - kvm_init()
>      - kvm_arch_init()
>      - arch-specific initialization -- (*)
>      - kvm_arch_check_processor_compat() on each CPUs
>      - kvm_arch_hardware_enable() on each CPUs -- (A)


Maybe also put the new added kvm_arch_post_hardware_enable_setup here?
After all, this is the purpose of this patch.


>      - kvm_arch_hardware_disable() on each CPUs -- (B)
>    - post-arch-specific initialization  -- (**)
>
> - When creating/deleting the first/last VM (no logic change)
>     - kvm_arch_hardware_enable() on each CPUs -- (A)
>     - kvm_arch_hardware_disable() on each CPUs -- (B)
>
