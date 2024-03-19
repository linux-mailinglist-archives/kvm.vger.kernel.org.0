Return-Path: <kvm+bounces-12066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 017AC87F548
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 03:15:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2168B1C2147D
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 02:15:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEBCD64CEF;
	Tue, 19 Mar 2024 02:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aIDqr/iB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6A856B77
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 02:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710814497; cv=none; b=PZqyOQwzZm4q9mONUPT4uSZwURzHSdVo2lcgrhsUvcS3ZWdoAzOO1qyTJm8jM1vlsnfzypF7tf0MJunBNGShVvxv5oOsdyO2N4P3DefkcbUJEobE1RHM0Gkb2QlE0MnSMQiRVq0I3Tdw75ZxFaEulwg0NHv7B7aIF7GvORZJm0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710814497; c=relaxed/simple;
	bh=GLhds+4K7dc7u246W/UoQ0WN87K/fN2ZmsoMZyd0Dag=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eZItY9DBF/eQKgSilIDNn5xiIAPlPiFpSycbN4SOh4cKvHgNXagvUzKdjzt7HlZiDEPiAkgNjUP8BuIeTsp/6PWwRfIoXxIaiiJThqyj+bcgcxR3tT5jc1I5JfW6bvLrDPwy9S/h3gYzapLA6ibyFiZsPOYCKvgUhztLwZoudSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aIDqr/iB; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710814496; x=1742350496;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GLhds+4K7dc7u246W/UoQ0WN87K/fN2ZmsoMZyd0Dag=;
  b=aIDqr/iBXtjmZ5qne4KOnMy2JvN/QH4IA3MnxLJIaZsbAHS2uqKtXy5S
   ZqJRntb0vGzF5M260Zzun5JoqsLZl77VueGNrAYajPrhSpc7YB0Nto1NF
   q0OGe2caj915o2ibfJuKz83P410VTbawappnk7bw/7+No1AUAWNPYyoXv
   w8y8z5NI8l6AGJyV2/jntpKeuyYTjoA3jF+grSc3Fv/GyQNEn1DRXGU0I
   kjZ9v/HCO/kSDBTN4AHlFhlbmX6Q1qce9mrzqv9O7OcHdH6jbUIN9jI6P
   YJGd++BAcdwc5Qk4Oj4Xi0x8ZQUfERF7aCPsSeCh+aHZ3btXxUXfNijSR
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11017"; a="31091301"
X-IronPort-AV: E=Sophos;i="6.07,135,1708416000"; 
   d="scan'208";a="31091301"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 19:14:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,135,1708416000"; 
   d="scan'208";a="44718549"
Received: from leiwang7-mobl.ccr.corp.intel.com (HELO [10.124.244.145]) ([10.124.244.145])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 19:14:49 -0700
Message-ID: <3d2655c7-74ad-49d9-a527-7648f8e565da@intel.com>
Date: Tue, 19 Mar 2024 10:14:47 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 08/65] kvm: handle KVM_EXIT_MEMORY_FAULT
Content-Language: en-US
To: Xiaoyao Li <xiaoyao.li@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 David Hildenbrand <david@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
 Cornelia Huck <cohuck@redhat.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, qemu-devel@nongnu.org,
 Michael Roth <michael.roth@amd.com>, Claudio Fontana <cfontana@suse.de>,
 Gerd Hoffmann <kraxel@redhat.com>, Isaku Yamahata
 <isaku.yamahata@gmail.com>, Chenyi Qiang <chenyi.qiang@intel.com>
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
 <20240229063726.610065-9-xiaoyao.li@intel.com>
From: "Wang, Lei" <lei4.wang@intel.com>
In-Reply-To: <20240229063726.610065-9-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/29/2024 14:36, Xiaoyao Li wrote:
> From: Chao Peng <chao.p.peng@linux.intel.com>
> 
> When geeting KVM_EXIT_MEMORY_FAULT exit, it indicates userspace needs to
> do the memory conversion on the RAMBlock to turn the memory into desired
> attribute, i.e., private/shared.
> 
> Currently only KVM_MEMORY_EXIT_FLAG_PRIVATE in flags is valid when
> KVM_EXIT_MEMORY_FAULT happens.
> 
> Note, KVM_EXIT_MEMORY_FAULT makes sense only when the RAMBlock has
> guest_memfd memory backend.
> 
> Note, KVM_EXIT_MEMORY_FAULT returns with -EFAULT, so special handling is
> added.
> 
> When page is converted from shared to private, the original shared
> memory can be discarded via ram_block_discard_range(). Note, shared
> memory can be discarded only when it's not back'ed by hugetlb because
> hugetlb is supposed to be pre-allocated and no need for discarding.
> 
> Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> 
> ---
> Changes in v4:
> - open-coded ram_block_discard logic;
> - change warn_report() to error_report(); (Daniel)
> ---
>  accel/kvm/kvm-all.c | 94 ++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 84 insertions(+), 10 deletions(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 70d482a2c936..87e4275932a7 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -2903,6 +2903,68 @@ static void kvm_eat_signals(CPUState *cpu)
>      } while (sigismember(&chkset, SIG_IPI));
>  }
>  
> +static int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
> +{
> +    MemoryRegionSection section;
> +    ram_addr_t offset;
> +    MemoryRegion *mr;
> +    RAMBlock *rb;
> +    void *addr;
> +    int ret = -1;
> +
> +    if (!QEMU_PTR_IS_ALIGNED(start, qemu_host_page_size) ||
> +        !QEMU_PTR_IS_ALIGNED(size, qemu_host_page_size)) {
> +        return -1;
> +    }
> +
> +    if (!size) {
> +        return -1;
> +    }
> +
> +    section = memory_region_find(get_system_memory(), start, size);
> +    mr = section.mr;
> +    if (!mr) {
> +        return -1;
> +    }
> +
> +    if (memory_region_has_guest_memfd(mr)) {
> +        if (to_private) {
> +            ret = kvm_set_memory_attributes_private(start, size);
> +        } else {
> +            ret = kvm_set_memory_attributes_shared(start, size);
> +        }
> +
> +        if (ret) {
> +            memory_region_unref(section.mr);
> +            return ret;
> +        }
> +
> +        addr = memory_region_get_ram_ptr(mr) + section.offset_within_region;
> +        rb = qemu_ram_block_from_host(addr, false, &offset);
> +
> +        if (to_private) {
> +            if (rb->page_size != qemu_host_page_size) {
> +                /*
> +                * shared memory is back'ed by  hugetlb, which is supposed to be
> +                * pre-allocated and doesn't need to be discarded
> +                */

Nit: comment indentation is broken here.

> +                return 0;
> +            } else {
> +                ret = ram_block_discard_range(rb, offset, size);
> +            }
> +        } else {
> +            ret = ram_block_discard_guest_memfd_range(rb, offset, size);
> +        }
> +    } else {
> +        error_report("Convert non guest_memfd backed memory region "
> +                    "(0x%"HWADDR_PRIx" ,+ 0x%"HWADDR_PRIx") to %s",

Same as above.

> +                    start, size, to_private ? "private" : "shared");
> +    }
> +
> +    memory_region_unref(section.mr);
> +    return ret;
> +}
> +
>  int kvm_cpu_exec(CPUState *cpu)
>  {
>      struct kvm_run *run = cpu->kvm_run;
> @@ -2970,18 +3032,20 @@ int kvm_cpu_exec(CPUState *cpu)
>                  ret = EXCP_INTERRUPT;
>                  break;
>              }
> -            fprintf(stderr, "error: kvm run failed %s\n",
> -                    strerror(-run_ret));
> +            if (!(run_ret == -EFAULT && run->exit_reason == KVM_EXIT_MEMORY_FAULT)) {
> +                fprintf(stderr, "error: kvm run failed %s\n",
> +                        strerror(-run_ret));
>  #ifdef TARGET_PPC
> -            if (run_ret == -EBUSY) {
> -                fprintf(stderr,
> -                        "This is probably because your SMT is enabled.\n"
> -                        "VCPU can only run on primary threads with all "
> -                        "secondary threads offline.\n");
> -            }
> +                if (run_ret == -EBUSY) {
> +                    fprintf(stderr,
> +                            "This is probably because your SMT is enabled.\n"
> +                            "VCPU can only run on primary threads with all "
> +                            "secondary threads offline.\n");
> +                }
>  #endif
> -            ret = -1;
> -            break;
> +                ret = -1;
> +                break;
> +            }
>          }
>  
>          trace_kvm_run_exit(cpu->cpu_index, run->exit_reason);
> @@ -3064,6 +3128,16 @@ int kvm_cpu_exec(CPUState *cpu)
>                  break;
>              }
>              break;
> +        case KVM_EXIT_MEMORY_FAULT:
> +            if (run->memory_fault.flags & ~KVM_MEMORY_EXIT_FLAG_PRIVATE) {
> +                error_report("KVM_EXIT_MEMORY_FAULT: Unknown flag 0x%" PRIx64,
> +                             (uint64_t)run->memory_fault.flags);
> +                ret = -1;
> +                break;
> +            }
> +            ret = kvm_convert_memory(run->memory_fault.gpa, run->memory_fault.size,
> +                                     run->memory_fault.flags & KVM_MEMORY_EXIT_FLAG_PRIVATE);
> +            break;
>          default:
>              ret = kvm_arch_handle_exit(cpu, run);
>              break;

