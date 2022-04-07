Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D88444F7242
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 04:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239444AbiDGCtD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 22:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231719AbiDGCtD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 22:49:03 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C3F20E94F
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 19:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649299624; x=1680835624;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2UEuQrDHOfOzQMemRxGuH5+xTZQPxUP8PXaL37pxIA8=;
  b=VHOGp2ai0u9b9fyEGls8klAmrlC8V+z82sQlUbZLTbro/vMVw3ovPdJx
   7AHgVvOmQM5sP87qDr6ezrhL9y/1jHCyjwYyBEiSYT1D+3tsutngblLRo
   IvAnvZW+RAduZHD16yJvIWpKHqdJLnctRxkeWse0X4tZ8xDgaqIlQR+nR
   XXnqM1xNzocWZSaZ9skVjr9L3vAdrWugTP1A2wvDt2U+yCcF4IyztINAY
   77YnWBg9Nnv2pgUnZ+2p5gqoJx+9Gibr9Fx9xVYAGvNsoEC/6RuYcdvFa
   oysV/yo5QUA26oug/J6ErzZNz+v0qL3UDUvlRJym9rl4Zm3+719InxJME
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10309"; a="243347230"
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="243347230"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 19:46:43 -0700
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="722770004"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.28.125]) ([10.255.28.125])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 19:46:41 -0700
Message-ID: <8785e6a8-5723-ac13-1ea5-7cd6242cb331@intel.com>
Date:   Thu, 7 Apr 2022 10:46:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [PATCH RESEND v1] trace: Split address space and slot id in
 trace_kvm_set_user_memory()
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, mtosatti@redhat.com,
        richard.henderson@linaro.org
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org
References: <20220310122215.804233-1-xiaoyao.li@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20220310122215.804233-1-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/10/2022 8:22 PM, Xiaoyao Li wrote:
> The upper 16 bits of kvm_userspace_memory_region::slot are
> address space id. Parse it separately in trace_kvm_set_user_memory().

Hi QEMU maintainers,

I think this patch is simple and straightforward. Please take your time 
to look at it.

Thanks,
-Xiaoyao

> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
> Resend:
>   - rebase to 2048c4eba2b4 ("Merge remote-tracking branch 'remotes/philmd/tags/pmbus-20220308' into staging")
> ---
>   accel/kvm/kvm-all.c    | 5 +++--
>   accel/kvm/trace-events | 2 +-
>   2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 0e66ebb49717..6b9fd943494b 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -379,8 +379,9 @@ static int kvm_set_user_memory_region(KVMMemoryListener *kml, KVMSlot *slot, boo
>       ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION, &mem);
>       slot->old_flags = mem.flags;
>   err:
> -    trace_kvm_set_user_memory(mem.slot, mem.flags, mem.guest_phys_addr,
> -                              mem.memory_size, mem.userspace_addr, ret);
> +    trace_kvm_set_user_memory(mem.slot >> 16, (uint16_t)mem.slot, mem.flags,
> +                              mem.guest_phys_addr, mem.memory_size,
> +                              mem.userspace_addr, ret);
>       if (ret < 0) {
>           error_report("%s: KVM_SET_USER_MEMORY_REGION failed, slot=%d,"
>                        " start=0x%" PRIx64 ", size=0x%" PRIx64 ": %s",
> diff --git a/accel/kvm/trace-events b/accel/kvm/trace-events
> index 399aaeb0ec75..14ebfa1b991c 100644
> --- a/accel/kvm/trace-events
> +++ b/accel/kvm/trace-events
> @@ -15,7 +15,7 @@ kvm_irqchip_update_msi_route(int virq) "Updating MSI route virq=%d"
>   kvm_irqchip_release_virq(int virq) "virq %d"
>   kvm_set_ioeventfd_mmio(int fd, uint64_t addr, uint32_t val, bool assign, uint32_t size, bool datamatch) "fd: %d @0x%" PRIx64 " val=0x%x assign: %d size: %d match: %d"
>   kvm_set_ioeventfd_pio(int fd, uint16_t addr, uint32_t val, bool assign, uint32_t size, bool datamatch) "fd: %d @0x%x val=0x%x assign: %d size: %d match: %d"
> -kvm_set_user_memory(uint32_t slot, uint32_t flags, uint64_t guest_phys_addr, uint64_t memory_size, uint64_t userspace_addr, int ret) "Slot#%d flags=0x%x gpa=0x%"PRIx64 " size=0x%"PRIx64 " ua=0x%"PRIx64 " ret=%d"
> +kvm_set_user_memory(uint16_t as, uint16_t slot, uint32_t flags, uint64_t guest_phys_addr, uint64_t memory_size, uint64_t userspace_addr, int ret) "AddrSpace#%d Slot#%d flags=0x%x gpa=0x%"PRIx64 " size=0x%"PRIx64 " ua=0x%"PRIx64 " ret=%d"
>   kvm_clear_dirty_log(uint32_t slot, uint64_t start, uint32_t size) "slot#%"PRId32" start 0x%"PRIx64" size 0x%"PRIx32
>   kvm_resample_fd_notify(int gsi) "gsi %d"
>   kvm_dirty_ring_full(int id) "vcpu %d"

