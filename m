Return-Path: <kvm+bounces-12065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 95B5787F539
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 03:03:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DFCDAB21584
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 02:03:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F117E64CEC;
	Tue, 19 Mar 2024 02:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eD1Ti5Pa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3589964CC9
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 02:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710813824; cv=none; b=QR1pZmPFrx+fr/dPUQbOiu0m8AZoNTpW+ewtHeX0f2Rhv+ze4Pby6MeT0L5SuNHVwKBgb/WsiTcn1yIJx+8Fbf5B2fj5cBuQ5p+32+K4uhPclUBNCePobxu7/fZ0uGB5xCWUppJH/gXQ5ff7+NGe/QG37Ll1HkL8x9BppgOWHEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710813824; c=relaxed/simple;
	bh=MT/JxPiKOsnmhKLpcBFdnuxGzDTqr4tDTJXOqFIGdKQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WGurESXHKoix0j5bycrmkxGjM9HG+n2flNZtoTDAsafI5Hn7QtsSlAuNpuKB8rQZyXhe08AQW9XAAjf07URMPevgqolPUJ0TvczT9a+SEFnOlXkbNugZjASMSX+xb7iI+8HlyoXYj3fHferg0PDXy9YCVpYloBqQ1KONlQD1ebY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eD1Ti5Pa; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710813822; x=1742349822;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MT/JxPiKOsnmhKLpcBFdnuxGzDTqr4tDTJXOqFIGdKQ=;
  b=eD1Ti5PaO5JlZGdOk27KaPM46FaT2h3JqPexKZmlbT2v0ROONgIBzSUb
   8Bb6TXfKP+I/yrE8SV7P0BawiSsaBL87X1Dy1LD45nnZ5HLo1gs85SMne
   +lwk1+Uz3yyLPSsrRiv0SjJ2Vgioj/k5UijMxDsIoyv+a0VT/+/X5198f
   kn7GE2uyidoCNXrVD/STe/0EqUKhzD/C2ux71ZleOkOV2LZcZpsWLvU4r
   fLRmNJtM67TjqpXefegskkQ8CuAV+tkj4rE8j9G8lhz90CSVvK8x4tVwM
   P90NTu7vFkVFn3r+WKxSoZTVbbNPvzEn+cO0nCSHe2FihGwLWSEhy+LaF
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11017"; a="16384967"
X-IronPort-AV: E=Sophos;i="6.07,135,1708416000"; 
   d="scan'208";a="16384967"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 19:03:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,135,1708416000"; 
   d="scan'208";a="13544877"
Received: from leiwang7-mobl.ccr.corp.intel.com (HELO [10.124.244.145]) ([10.124.244.145])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 19:03:35 -0700
Message-ID: <5b4ba4d8-3e18-4feb-8cb6-f78d21da77f9@intel.com>
Date: Tue, 19 Mar 2024 10:03:32 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 06/65] kvm: Introduce support for memory_attributes
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
 <20240229063726.610065-7-xiaoyao.li@intel.com>
From: "Wang, Lei" <lei4.wang@intel.com>
In-Reply-To: <20240229063726.610065-7-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/29/2024 14:36, Xiaoyao Li wrote:> Introduce the helper functions to set the attributes of a range of
> memory to private or shared.
> 
> This is necessary to notify KVM the private/shared attribute of each gpa
> range. KVM needs the information to decide the GPA needs to be mapped at
> hva-based shared memory or guest_memfd based private memory.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
> Changes in v4:
> - move the check of kvm_supported_memory_attributes to the common
>   kvm_set_memory_attributes(); (Wang Wei)
> - change warn_report() to error_report() in kvm_set_memory_attributes()
>   and drop the __func__; (Daniel)
> ---
>  accel/kvm/kvm-all.c  | 44 ++++++++++++++++++++++++++++++++++++++++++++
>  include/sysemu/kvm.h |  3 +++
>  2 files changed, 47 insertions(+)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index cd0aa7545a1f..70d482a2c936 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -92,6 +92,7 @@ static bool kvm_has_guest_debug;
>  static int kvm_sstep_flags;
>  static bool kvm_immediate_exit;
>  static bool kvm_guest_memfd_supported;
> +static uint64_t kvm_supported_memory_attributes;
>  static hwaddr kvm_max_slot_size = ~0;
>  
>  static const KVMCapabilityInfo kvm_required_capabilites[] = {
> @@ -1304,6 +1305,46 @@ void kvm_set_max_memslot_size(hwaddr max_slot_size)
>      kvm_max_slot_size = max_slot_size;
>  }
>  
> +static int kvm_set_memory_attributes(hwaddr start, hwaddr size, uint64_t attr)
> +{
> +    struct kvm_memory_attributes attrs;
> +    int r;
> +
> +    if (kvm_supported_memory_attributes == 0) {
> +        error_report("No memory attribute supported by KVM\n");
> +        return -EINVAL;
> +    }
> +
> +    if ((attr & kvm_supported_memory_attributes) != attr) {
> +        error_report("memory attribute 0x%lx not supported by KVM,"
> +                     " supported bits are 0x%lx\n",
> +                     attr, kvm_supported_memory_attributes);
> +        return -EINVAL;
> +    }
> +
> +    attrs.attributes = attr;
> +    attrs.address = start;
> +    attrs.size = size;
> +    attrs.flags = 0;
> +
> +    r = kvm_vm_ioctl(kvm_state, KVM_SET_MEMORY_ATTRIBUTES, &attrs);
> +    if (r) {
> +        error_report("failed to set memory (0x%lx+%#zx) with attr 0x%lx error '%s'",
> +                     start, size, attr, strerror(errno));
> +    }
> +    return r;
> +}
> +
> +int kvm_set_memory_attributes_private(hwaddr start, hwaddr size)
> +{
> +    return kvm_set_memory_attributes(start, size, KVM_MEMORY_ATTRIBUTE_PRIVATE);
> +}
> +
> +int kvm_set_memory_attributes_shared(hwaddr start, hwaddr size)
> +{
> +    return kvm_set_memory_attributes(start, size, 0);
> +}
> +
>  /* Called with KVMMemoryListener.slots_lock held */
>  static void kvm_set_phys_mem(KVMMemoryListener *kml,
>                               MemoryRegionSection *section, bool add)
> @@ -2439,6 +2480,9 @@ static int kvm_init(MachineState *ms)
>  
>      kvm_guest_memfd_supported = kvm_check_extension(s, KVM_CAP_GUEST_MEMFD);
>  
> +    ret = kvm_check_extension(s, KVM_CAP_MEMORY_ATTRIBUTES);
> +    kvm_supported_memory_attributes = ret > 0 ? ret : 0;

kvm_check_extension() only returns non-negative value, so we can just

kvm_supported_memory_attributes = kvm_check_extension(s, KVM_CAP_MEMORY_ATTRIBUTES);

> +
>      if (object_property_find(OBJECT(current_machine), "kvm-type")) {
>          g_autofree char *kvm_type = object_property_get_str(OBJECT(current_machine),
>                                                              "kvm-type",
> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
> index 6cdf82de8372..8e83adfbbd19 100644
> --- a/include/sysemu/kvm.h
> +++ b/include/sysemu/kvm.h
> @@ -546,4 +546,7 @@ uint32_t kvm_dirty_ring_size(void);
>  bool kvm_hwpoisoned_mem(void);
>  
>  int kvm_create_guest_memfd(uint64_t size, uint64_t flags, Error **errp);
> +
> +int kvm_set_memory_attributes_private(hwaddr start, hwaddr size);
> +int kvm_set_memory_attributes_shared(hwaddr start, hwaddr size);
>  #endif

