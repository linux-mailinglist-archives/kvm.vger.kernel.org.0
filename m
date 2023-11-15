Return-Path: <kvm+bounces-1811-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 393627EC058
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 11:21:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A3C51C20A69
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 10:21:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD41EDDC9;
	Wed, 15 Nov 2023 10:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZcAgO0I2"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B415ECA74
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 10:21:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCFBACC
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 02:20:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700043659;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4x83Ctej6zvuKVcZtpJYw2bUVdMBmznjxcYoOZHI1t4=;
	b=ZcAgO0I2mHElCivjbSh8rL+dbfKv5eiOHz4YSfNk2KmCEUj13YX3GLjD0matWYSy1OoVUV
	eMlyb5FFcspmHhG1GT28n0fzgdzOXe8h5VEeBeNq3fWV3F3WN21h9JCYandrotzkYcf5s+
	vzZMQSr26geJ89wnyYNLjv7Onv9kEjc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-125-v7azYPKqOUOXmr57M4wemA-1; Wed, 15 Nov 2023 05:20:55 -0500
X-MC-Unique: v7azYPKqOUOXmr57M4wemA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D230185A780;
	Wed, 15 Nov 2023 10:20:54 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.144])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 27D3C1C060AE;
	Wed, 15 Nov 2023 10:20:47 +0000 (UTC)
Date: Wed, 15 Nov 2023 10:20:43 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>, Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: Re: [PATCH v3 02/70] RAMBlock: Add support of KVM private guest memfd
Message-ID: <ZVSbe4lryQyMVnMT@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
 <20231115071519.2864957-3-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231115071519.2864957-3-xiaoyao.li@intel.com>
User-Agent: Mutt/2.2.10 (2023-03-25)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

On Wed, Nov 15, 2023 at 02:14:11AM -0500, Xiaoyao Li wrote:
> Add KVM guest_memfd support to RAMBlock so both normal hva based memory
> and kvm guest memfd based private memory can be associated in one RAMBlock.
> 
> Introduce new flag RAM_GUEST_MEMFD. When it's set, it calls KVM ioctl to
> create private guest_memfd during RAMBlock setup.
> 
> Note, RAM_GUEST_MEMFD is supposed to be set for memory backends of
> confidential guests, such as TDX VM. How and when to set it for memory
> backends will be implemented in the following patches.
> 
> Introduce memory_region_has_guest_memfd() to query if the MemoryRegion has
> KVM guest_memfd allocated.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
> Changes in v3:
> - rename gmem to guest_memfd;
> - close(guest_memfd) when RAMBlock is released; (Daniel P. Berrangé)
> - Suqash the patch that introduces memory_region_has_guest_memfd().
> ---
>  accel/kvm/kvm-all.c     | 24 ++++++++++++++++++++++++
>  include/exec/memory.h   | 13 +++++++++++++
>  include/exec/ramblock.h |  1 +
>  include/sysemu/kvm.h    |  2 ++
>  system/memory.c         |  5 +++++
>  system/physmem.c        | 27 ++++++++++++++++++++++++---
>  6 files changed, 69 insertions(+), 3 deletions(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index c1b40e873531..9f751d4971f8 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -101,6 +101,7 @@ bool kvm_msi_use_devid;
>  bool kvm_has_guest_debug;
>  static int kvm_sstep_flags;
>  static bool kvm_immediate_exit;
> +static bool kvm_guest_memfd_supported;
>  static hwaddr kvm_max_slot_size = ~0;
>  
>  static const KVMCapabilityInfo kvm_required_capabilites[] = {
> @@ -2397,6 +2398,8 @@ static int kvm_init(MachineState *ms)
>      }
>      s->as = g_new0(struct KVMAs, s->nr_as);
>  
> +    kvm_guest_memfd_supported = kvm_check_extension(s, KVM_CAP_GUEST_MEMFD);
> +
>      if (object_property_find(OBJECT(current_machine), "kvm-type")) {
>          g_autofree char *kvm_type = object_property_get_str(OBJECT(current_machine),
>                                                              "kvm-type",
> @@ -4078,3 +4081,24 @@ void query_stats_schemas_cb(StatsSchemaList **result, Error **errp)
>          query_stats_schema_vcpu(first_cpu, &stats_args);
>      }
>  }
> +
> +int kvm_create_guest_memfd(uint64_t size, uint64_t flags, Error **errp)
> +{
> +    int fd;
> +    struct kvm_create_guest_memfd guest_memfd = {
> +        .size = size,
> +        .flags = flags,
> +    };
> +
> +    if (!kvm_guest_memfd_supported) {
> +        error_setg(errp, "KVM doesn't support guest memfd\n");
> +        return -EOPNOTSUPP;

Returning an errno value is unusual when we have an 'Error **errp' parameter
for reporting, and the following codepath merely returns -1, so this is
inconsistent. Just return -1 here too.

> +    }
> +
> +    fd = kvm_vm_ioctl(kvm_state, KVM_CREATE_GUEST_MEMFD, &guest_memfd);
> +    if (fd < 0) {
> +        error_setg_errno(errp, errno, "%s: error creating kvm guest memfd\n", __func__);

I'd prefer an explicit 'return -1' here, even though 'fd' is technically going
to be -1 already.

Also including __func__ in the error message is not really needed IMHO

> +    }
> +
> +    return fd;
> +}
> diff --git a/include/exec/memory.h b/include/exec/memory.h
> index 831f7c996d9d..f780367ab1bd 100644
> --- a/include/exec/memory.h
> +++ b/include/exec/memory.h
> @@ -243,6 +243,9 @@ typedef struct IOMMUTLBEvent {
>  /* RAM FD is opened read-only */
>  #define RAM_READONLY_FD (1 << 11)
>  
> +/* RAM can be private that has kvm gmem backend */
> +#define RAM_GUEST_MEMFD   (1 << 12)
> +
>  static inline void iommu_notifier_init(IOMMUNotifier *n, IOMMUNotify fn,
>                                         IOMMUNotifierFlag flags,
>                                         hwaddr start, hwaddr end,
> @@ -1702,6 +1705,16 @@ static inline bool memory_region_is_romd(MemoryRegion *mr)
>   */
>  bool memory_region_is_protected(MemoryRegion *mr);
>  
> +/**
> + * memory_region_has_guest_memfd: check whether a memory region has guest_memfd
> + *     associated
> + *
> + * Returns %true if a memory region's ram_block has valid guest_memfd assigned.
> + *
> + * @mr: the memory region being queried
> + */
> +bool memory_region_has_guest_memfd(MemoryRegion *mr);
> +
>  /**
>   * memory_region_get_iommu: check whether a memory region is an iommu
>   *
> diff --git a/include/exec/ramblock.h b/include/exec/ramblock.h
> index 69c6a5390293..0a17ba882729 100644
> --- a/include/exec/ramblock.h
> +++ b/include/exec/ramblock.h
> @@ -41,6 +41,7 @@ struct RAMBlock {
>      QLIST_HEAD(, RAMBlockNotifier) ramblock_notifiers;
>      int fd;
>      uint64_t fd_offset;
> +    int guest_memfd;
>      size_t page_size;
>      /* dirty bitmap used during migration */
>      unsigned long *bmap;
> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
> index d61487816421..fedc28c7d17f 100644
> --- a/include/sysemu/kvm.h
> +++ b/include/sysemu/kvm.h
> @@ -538,4 +538,6 @@ bool kvm_arch_cpu_check_are_resettable(void);
>  bool kvm_dirty_ring_enabled(void);
>  
>  uint32_t kvm_dirty_ring_size(void);
> +
> +int kvm_create_guest_memfd(uint64_t size, uint64_t flags, Error **errp);
>  #endif
> diff --git a/system/memory.c b/system/memory.c
> index 304fa843ea12..69741d91bbb7 100644
> --- a/system/memory.c
> +++ b/system/memory.c
> @@ -1862,6 +1862,11 @@ bool memory_region_is_protected(MemoryRegion *mr)
>      return mr->ram && (mr->ram_block->flags & RAM_PROTECTED);
>  }
>  
> +bool memory_region_has_guest_memfd(MemoryRegion *mr)
> +{
> +    return mr->ram_block && mr->ram_block->guest_memfd >= 0;
> +}
> +
>  uint8_t memory_region_get_dirty_log_mask(MemoryRegion *mr)
>  {
>      uint8_t mask = mr->dirty_log_mask;
> diff --git a/system/physmem.c b/system/physmem.c
> index fc2b0fee0188..0af2213cbd9c 100644
> --- a/system/physmem.c
> +++ b/system/physmem.c
> @@ -1841,6 +1841,20 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
>          }
>      }
>  
> +#ifdef CONFIG_KVM
> +    if (kvm_enabled() && new_block->flags & RAM_GUEST_MEMFD &&
> +        new_block->guest_memfd < 0) {
> +        /* TODO: to decide if KVM_GUEST_MEMFD_ALLOW_HUGEPAGE is supported */
> +        uint64_t flags = 0;
> +        new_block->guest_memfd = kvm_create_guest_memfd(new_block->max_length,
> +                                                        flags, errp);
> +        if (new_block->guest_memfd < 0) {
> +            qemu_mutex_unlock_ramlist();
> +            return;
> +        }
> +    }
> +#endif
> +
>      new_ram_size = MAX(old_ram_size,
>                (new_block->offset + new_block->max_length) >> TARGET_PAGE_BITS);
>      if (new_ram_size > old_ram_size) {
> @@ -1903,7 +1917,7 @@ RAMBlock *qemu_ram_alloc_from_fd(ram_addr_t size, MemoryRegion *mr,
>      /* Just support these ram flags by now. */
>      assert((ram_flags & ~(RAM_SHARED | RAM_PMEM | RAM_NORESERVE |
>                            RAM_PROTECTED | RAM_NAMED_FILE | RAM_READONLY |
> -                          RAM_READONLY_FD)) == 0);
> +                          RAM_READONLY_FD | RAM_GUEST_MEMFD)) == 0);
>  
>      if (xen_enabled()) {
>          error_setg(errp, "-mem-path not supported with Xen");
> @@ -1938,6 +1952,7 @@ RAMBlock *qemu_ram_alloc_from_fd(ram_addr_t size, MemoryRegion *mr,
>      new_block->used_length = size;
>      new_block->max_length = size;
>      new_block->flags = ram_flags;
> +    new_block->guest_memfd = -1;
>      new_block->host = file_ram_alloc(new_block, size, fd, !file_size, offset,
>                                       errp);
>      if (!new_block->host) {
> @@ -2016,7 +2031,7 @@ RAMBlock *qemu_ram_alloc_internal(ram_addr_t size, ram_addr_t max_size,
>      Error *local_err = NULL;
>  
>      assert((ram_flags & ~(RAM_SHARED | RAM_RESIZEABLE | RAM_PREALLOC |
> -                          RAM_NORESERVE)) == 0);
> +                          RAM_NORESERVE| RAM_GUEST_MEMFD)) == 0);
>      assert(!host ^ (ram_flags & RAM_PREALLOC));
>  
>      size = HOST_PAGE_ALIGN(size);
> @@ -2028,6 +2043,7 @@ RAMBlock *qemu_ram_alloc_internal(ram_addr_t size, ram_addr_t max_size,
>      new_block->max_length = max_size;
>      assert(max_size >= size);
>      new_block->fd = -1;
> +    new_block->guest_memfd = -1;
>      new_block->page_size = qemu_real_host_page_size();
>      new_block->host = host;
>      new_block->flags = ram_flags;
> @@ -2050,7 +2066,7 @@ RAMBlock *qemu_ram_alloc_from_ptr(ram_addr_t size, void *host,
>  RAMBlock *qemu_ram_alloc(ram_addr_t size, uint32_t ram_flags,
>                           MemoryRegion *mr, Error **errp)
>  {
> -    assert((ram_flags & ~(RAM_SHARED | RAM_NORESERVE)) == 0);
> +    assert((ram_flags & ~(RAM_SHARED | RAM_NORESERVE | RAM_GUEST_MEMFD)) == 0);
>      return qemu_ram_alloc_internal(size, size, NULL, NULL, ram_flags, mr, errp);
>  }
>  
> @@ -2078,6 +2094,11 @@ static void reclaim_ramblock(RAMBlock *block)
>      } else {
>          qemu_anon_ram_free(block->host, block->max_length);
>      }
> +
> +    if (block->guest_memfd >= 0) {
> +        close(block->guest_memfd);
> +    }
> +
>      g_free(block);
>  }
>  
> -- 
> 2.34.1
> 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


