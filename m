Return-Path: <kvm+bounces-1977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E3B57EF8D9
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 21:50:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5DC6280D76
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 20:50:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07C46446DD;
	Fri, 17 Nov 2023 20:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PKoiebV/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F698D52
	for <kvm@vger.kernel.org>; Fri, 17 Nov 2023 12:50:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700254230; x=1731790230;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RFVvuGTL3ufLBRPYTUl62P95336f8JzOxnBgSPK8YSA=;
  b=PKoiebV/Lt/lnHVo+xMRZ0BhvtCFTBGP/d7cp+vKpJjR/R6jqFawF0NQ
   he0Az9d9DU8hQlDG+dXYr1uuRteX20d+/IDZVoQ2jGMIw2Na7ahue4kC+
   UvrO/TvN6rizOUUGMgsQnNs0OyJJUTp2eGeA+LyCz4rPWVQ7YryjhywwN
   8kIAm/32sKdKSQck0UXOxByA2AOdYb1IrRGTUmio44GqT1V2a7/BwutDV
   JSzxU6b0TJxh/+tIKNNwEx0RQbwVbx6LgmTUPHsOKYkecijUHtHB7P8F3
   6B0Yj1xJZOxYHwiu563/GgObSTTtVOHlA5nOe+Hua0nBb7dZl3DNAj7qt
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10897"; a="371544837"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="371544837"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2023 12:50:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10897"; a="742182242"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="742182242"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2023 12:50:28 -0800
Date: Fri, 17 Nov 2023 12:50:28 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>,
	Daniel P =?utf-8?B?LiBCZXJyYW5nw6k=?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	isaku.yamahata@linux.intel.com, isaku.yamahata@intel.com
Subject: Re: [PATCH v3 05/70] kvm: Enable KVM_SET_USER_MEMORY_REGION2 for
 memslot
Message-ID: <20231117205028.GB1645850@ls.amr.corp.intel.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
 <20231115071519.2864957-6-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231115071519.2864957-6-xiaoyao.li@intel.com>

On Wed, Nov 15, 2023 at 02:14:14AM -0500,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> From: Chao Peng <chao.p.peng@linux.intel.com>
> 
> Switch to KVM_SET_USER_MEMORY_REGION2 when supported by KVM.
> 
> With KVM_SET_USER_MEMORY_REGION2, QEMU can set up memory region that
> backend'ed both by hva-based shared memory and guest memfd based private
> memory.
> 
> Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  accel/kvm/kvm-all.c      | 56 ++++++++++++++++++++++++++++++++++------
>  accel/kvm/trace-events   |  2 +-
>  include/sysemu/kvm_int.h |  2 ++
>  3 files changed, 51 insertions(+), 9 deletions(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 9f751d4971f8..69afeb47c9c0 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -293,35 +293,69 @@ int kvm_physical_memory_addr_from_host(KVMState *s, void *ram,
>  static int kvm_set_user_memory_region(KVMMemoryListener *kml, KVMSlot *slot, bool new)
>  {
>      KVMState *s = kvm_state;
> -    struct kvm_userspace_memory_region mem;
> +    struct kvm_userspace_memory_region2 mem;
> +    static int cap_user_memory2 = -1;
>      int ret;
>  
> +    if (cap_user_memory2 == -1) {
> +        cap_user_memory2 = kvm_check_extension(s, KVM_CAP_USER_MEMORY2);
> +    }
> +
> +    if (!cap_user_memory2 && slot->guest_memfd >= 0) {
> +        error_report("%s, KVM doesn't support KVM_CAP_USER_MEMORY2,"
> +                     " which is required by guest memfd!", __func__);
> +        exit(1);
> +    }
> +
>      mem.slot = slot->slot | (kml->as_id << 16);
>      mem.guest_phys_addr = slot->start_addr;
>      mem.userspace_addr = (unsigned long)slot->ram;
>      mem.flags = slot->flags;
> +    mem.guest_memfd = slot->guest_memfd;
> +    mem.guest_memfd_offset = slot->guest_memfd_offset;
>  
>      if (slot->memory_size && !new && (mem.flags ^ slot->old_flags) & KVM_MEM_READONLY) {
>          /* Set the slot size to 0 before setting the slot to the desired
>           * value. This is needed based on KVM commit 75d61fbc. */
>          mem.memory_size = 0;
> -        ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION, &mem);
> +
> +        if (cap_user_memory2) {
> +            ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION2, &mem);
> +        } else {
> +            ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION, &mem);
> +	    }
>          if (ret < 0) {
>              goto err;
>          }
>      }
>      mem.memory_size = slot->memory_size;
> -    ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION, &mem);
> +    if (cap_user_memory2) {
> +        ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION2, &mem);
> +    } else {
> +        ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION, &mem);
> +    }
>      slot->old_flags = mem.flags;
>  err:
>      trace_kvm_set_user_memory(mem.slot >> 16, (uint16_t)mem.slot, mem.flags,
>                                mem.guest_phys_addr, mem.memory_size,
> -                              mem.userspace_addr, ret);
> +                              mem.userspace_addr, mem.guest_memfd,
> +                              mem.guest_memfd_offset, ret);
>      if (ret < 0) {
> -        error_report("%s: KVM_SET_USER_MEMORY_REGION failed, slot=%d,"
> -                     " start=0x%" PRIx64 ", size=0x%" PRIx64 ": %s",
> -                     __func__, mem.slot, slot->start_addr,
> -                     (uint64_t)mem.memory_size, strerror(errno));
> +        if (cap_user_memory2) {
> +                error_report("%s: KVM_SET_USER_MEMORY_REGION2 failed, slot=%d,"
> +                        " start=0x%" PRIx64 ", size=0x%" PRIx64 ","
> +                        " flags=0x%" PRIx32 ", guest_memfd=%" PRId32 ","
> +                        " guest_memfd_offset=0x%" PRIx64 ": %s",
> +                        __func__, mem.slot, slot->start_addr,
> +                        (uint64_t)mem.memory_size, mem.flags,
> +                        mem.guest_memfd, (uint64_t)mem.guest_memfd_offset,
> +                        strerror(errno));
> +        } else {
> +                error_report("%s: KVM_SET_USER_MEMORY_REGION failed, slot=%d,"
> +                            " start=0x%" PRIx64 ", size=0x%" PRIx64 ": %s",
> +                            __func__, mem.slot, slot->start_addr,
> +                            (uint64_t)mem.memory_size, strerror(errno));
> +        }
>      }
>      return ret;
>  }
> @@ -477,6 +511,9 @@ static int kvm_mem_flags(MemoryRegion *mr)
>      if (readonly && kvm_readonly_mem_allowed) {
>          flags |= KVM_MEM_READONLY;
>      }
> +    if (memory_region_has_guest_memfd(mr)) {
> +        flags |= KVM_MEM_PRIVATE;
> +    }

Nitpick: it was renamed to KVM_MEM_GUEST_MEMFD
As long as the value is defined to same value, it doesn't matter, though.
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

