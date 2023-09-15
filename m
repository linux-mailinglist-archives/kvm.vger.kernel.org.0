Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8092A7A1386
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 04:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbjIOCEr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 22:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbjIOCEq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 22:04:46 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A43C71AE
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 19:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694743482; x=1726279482;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gNbd2uMO56K/Am9d6XoS/Yc3/dZvvXn/e4usolVRnMA=;
  b=JZfTblx1yhg9PJz3+zsKiFMJru1yMmD1GLnx7QirgGfO4kw5+064FZOx
   cwc+yiXg+GH9auQv/bct1RyBN+0/DqZVw9pPHmXIsZex9uXWNDasIrPnf
   +5Np/7fVGlt5UM4Fsq+hLF2wnEI28SHdjQpxi10qJYCAr1wK0KY5JZajp
   ++ZhDtwVmPu/X/kgzw5YPdG7SAnFIfhvdvh7vrcNTC4Iz2pCvnpoEuvtn
   wHROf2OodQbwDlHyvkS9ejbpvscNwZSA7pveY0WkZxGUuMA7zWCXrmyiN
   ujFdDIAbQuBcVjR88Kcf83rWcYhx0S9ok0B7cIwSvBO4YkRKmSO4JsTXO
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="410076117"
X-IronPort-AV: E=Sophos;i="6.02,147,1688454000"; 
   d="scan'208";a="410076117"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 19:04:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="694553407"
X-IronPort-AV: E=Sophos;i="6.02,147,1688454000"; 
   d="scan'208";a="694553407"
Received: from leiwang7-mobl.ccr.corp.intel.com (HELO [10.93.2.122]) ([10.93.2.122])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 19:04:30 -0700
Message-ID: <bd1eca88-98f4-718f-4d40-c2ea40f65d95@intel.com>
Date:   Fri, 15 Sep 2023 10:04:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.15.1
Subject: Re: [RFC PATCH v2 02/21] RAMBlock: Add support of KVM private gmem
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        Sean Christopherson <seanjc@google.com>,
        Claudio Fontana <cfontana@suse.de>
References: <20230914035117.3285885-1-xiaoyao.li@intel.com>
 <20230914035117.3285885-3-xiaoyao.li@intel.com>
From:   "Wang, Lei" <lei4.wang@intel.com>
Content-Language: en-US
In-Reply-To: <20230914035117.3285885-3-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/14/2023 11:50, Xiaoyao Li wrote:
> From: Chao Peng <chao.p.peng@linux.intel.com>
> 
> Add KVM gmem support to RAMBlock so both normal hva based memory
> and kvm gmem fd based private memory can be associated in one RAMBlock.
> 
> Introduce new flag RAM_KVM_GMEM. It calls KVM ioctl to create private
> gmem for the RAMBlock when it's set.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>

Kindly reminding the author's Signed-off-by is missing.

> ---
>  accel/kvm/kvm-all.c     | 17 +++++++++++++++++
>  include/exec/memory.h   |  3 +++
>  include/exec/ramblock.h |  1 +
>  include/sysemu/kvm.h    |  2 ++
>  softmmu/physmem.c       | 18 +++++++++++++++---
>  5 files changed, 38 insertions(+), 3 deletions(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 60aacd925393..185ae16d9620 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -4225,3 +4225,20 @@ void query_stats_schemas_cb(StatsSchemaList **result, Error **errp)
>          query_stats_schema_vcpu(first_cpu, &stats_args);
>      }
>  }
> +
> +int kvm_create_guest_memfd(uint64_t size, uint64_t flags, Error **errp)
> +{
> +    int fd;
> +    struct kvm_create_guest_memfd gmem = {
> +        .size = size,
> +        /* TODO: to decide whether KVM_GUEST_MEMFD_ALLOW_HUGEPAGE is supported */
> +        .flags = flags,
> +    };
> +
> +    fd = kvm_vm_ioctl(kvm_state, KVM_CREATE_GUEST_MEMFD, &gmem);
> +    if (fd < 0) {
> +        error_setg_errno(errp, errno, "%s: error creating kvm gmem\n", __func__);
> +    }
> +
> +    return fd;
> +}
> diff --git a/include/exec/memory.h b/include/exec/memory.h
> index 68284428f87c..227cb2578e95 100644
> --- a/include/exec/memory.h
> +++ b/include/exec/memory.h
> @@ -235,6 +235,9 @@ typedef struct IOMMUTLBEvent {
>  /* RAM is an mmap-ed named file */
>  #define RAM_NAMED_FILE (1 << 9)
>  
> +/* RAM can be private that has kvm gmem backend */
> +#define RAM_KVM_GMEM    (1 << 10)
> +
>  static inline void iommu_notifier_init(IOMMUNotifier *n, IOMMUNotify fn,
>                                         IOMMUNotifierFlag flags,
>                                         hwaddr start, hwaddr end,
> diff --git a/include/exec/ramblock.h b/include/exec/ramblock.h
> index 69c6a5390293..0d158b3909c9 100644
> --- a/include/exec/ramblock.h
> +++ b/include/exec/ramblock.h
> @@ -41,6 +41,7 @@ struct RAMBlock {
>      QLIST_HEAD(, RAMBlockNotifier) ramblock_notifiers;
>      int fd;
>      uint64_t fd_offset;
> +    int gmem_fd;
>      size_t page_size;
>      /* dirty bitmap used during migration */
>      unsigned long *bmap;
> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
> index 115f0cca79d1..f5b74c8dd8c5 100644
> --- a/include/sysemu/kvm.h
> +++ b/include/sysemu/kvm.h
> @@ -580,4 +580,6 @@ bool kvm_arch_cpu_check_are_resettable(void);
>  bool kvm_dirty_ring_enabled(void);
>  
>  uint32_t kvm_dirty_ring_size(void);
> +
> +int kvm_create_guest_memfd(uint64_t size, uint64_t flags, Error **errp);
>  #endif
> diff --git a/softmmu/physmem.c b/softmmu/physmem.c
> index 3df73542e1fe..2d98a88f41f0 100644
> --- a/softmmu/physmem.c
> +++ b/softmmu/physmem.c
> @@ -1824,6 +1824,16 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
>          }
>      }
>  
> +    if (kvm_enabled() && new_block->flags & RAM_KVM_GMEM &&
> +        new_block->gmem_fd < 0) {
> +        new_block->gmem_fd = kvm_create_guest_memfd(new_block->max_length,
> +                                                    0, errp);
> +        if (new_block->gmem_fd < 0) {
> +            qemu_mutex_unlock_ramlist();
> +            return;
> +        }
> +    }
> +
>      new_ram_size = MAX(old_ram_size,
>                (new_block->offset + new_block->max_length) >> TARGET_PAGE_BITS);
>      if (new_ram_size > old_ram_size) {
> @@ -1885,7 +1895,7 @@ RAMBlock *qemu_ram_alloc_from_fd(ram_addr_t size, MemoryRegion *mr,
>  
>      /* Just support these ram flags by now. */
>      assert((ram_flags & ~(RAM_SHARED | RAM_PMEM | RAM_NORESERVE |
> -                          RAM_PROTECTED | RAM_NAMED_FILE)) == 0);
> +                          RAM_PROTECTED | RAM_NAMED_FILE | RAM_KVM_GMEM)) == 0);
>  
>      if (xen_enabled()) {
>          error_setg(errp, "-mem-path not supported with Xen");
> @@ -1920,6 +1930,7 @@ RAMBlock *qemu_ram_alloc_from_fd(ram_addr_t size, MemoryRegion *mr,
>      new_block->used_length = size;
>      new_block->max_length = size;
>      new_block->flags = ram_flags;
> +    new_block->gmem_fd = -1;
>      new_block->host = file_ram_alloc(new_block, size, fd, readonly,
>                                       !file_size, offset, errp);
>      if (!new_block->host) {
> @@ -1978,7 +1989,7 @@ RAMBlock *qemu_ram_alloc_internal(ram_addr_t size, ram_addr_t max_size,
>      Error *local_err = NULL;
>  
>      assert((ram_flags & ~(RAM_SHARED | RAM_RESIZEABLE | RAM_PREALLOC |
> -                          RAM_NORESERVE)) == 0);
> +                          RAM_NORESERVE| RAM_KVM_GMEM)) == 0);
>      assert(!host ^ (ram_flags & RAM_PREALLOC));
>  
>      size = HOST_PAGE_ALIGN(size);
> @@ -1990,6 +2001,7 @@ RAMBlock *qemu_ram_alloc_internal(ram_addr_t size, ram_addr_t max_size,
>      new_block->max_length = max_size;
>      assert(max_size >= size);
>      new_block->fd = -1;
> +    new_block->gmem_fd = -1;
>      new_block->page_size = qemu_real_host_page_size();
>      new_block->host = host;
>      new_block->flags = ram_flags;
> @@ -2012,7 +2024,7 @@ RAMBlock *qemu_ram_alloc_from_ptr(ram_addr_t size, void *host,
>  RAMBlock *qemu_ram_alloc(ram_addr_t size, uint32_t ram_flags,
>                           MemoryRegion *mr, Error **errp)
>  {
> -    assert((ram_flags & ~(RAM_SHARED | RAM_NORESERVE)) == 0);
> +    assert((ram_flags & ~(RAM_SHARED | RAM_NORESERVE | RAM_KVM_GMEM)) == 0);
>      return qemu_ram_alloc_internal(size, size, NULL, NULL, ram_flags, mr, errp);
>  }
>  
