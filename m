Return-Path: <kvm+bounces-10888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 237AA87192A
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 10:11:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CDB231F241E1
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 09:11:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF19F51C2B;
	Tue,  5 Mar 2024 09:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Uev3Od2R"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28EFB50263
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 09:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709629853; cv=none; b=oAmTnebXPSc+6eP1rnxOiwn0FZ4GMaWKiC5XPPosGNuU9xXH+fH3krzV9J8P3ntTJK64M4esBy6MYTH4BFE7ol+ifJj8gujCwwre5hKtUJe5VRZrnWg2LkSpcNKDM6LIBLBy5yEWHOhcpsYn2Kxc8bAW4PWKWkr9/i72dl5G6EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709629853; c=relaxed/simple;
	bh=rVIwlJM3IgwqSihvhW2HEaT8sLQNzBRHPyLxvk8Crcg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ErO4o1Zod10GqoooocP3JCDljO9ciABnIYIRNvymsAP7G56U3gkCVlxVYQHiCqv5Oy90EEooNNwpeDzOqeU5BpzNqkrqmL/Ak9gcyinRCPhQgxw+mWvgx0tSZEH0H8RqRxvljNDcIjmEzjZAJPU6ykbJ/0Xxsc91+KJAEyJve/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Uev3Od2R; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709629851; x=1741165851;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rVIwlJM3IgwqSihvhW2HEaT8sLQNzBRHPyLxvk8Crcg=;
  b=Uev3Od2RV2cQ/Zv4Iok1J7NCrgP85Oc94cyieGrLRiNS9uxoDIU66NY6
   QkBjYQqOtkfiWYHzzL4kENXk9vy66+HTNmEBzqgtVsmWmdImkGb6Bu/8K
   Qnrh2eVkz83Cv0A0RnQsKSsho9SKy4tTdlNAPDTfouxNEYRjSbmLUNwbR
   meMc6iYqglgKJaHThlOKiI+obA8f3Mi+2uaTu6oyViE3R10ni/78P1zGy
   djkf+nPY3hraA2nrrs0VV+LMNv1wazyps7euCHgGiQz9XpOlTz1ICI2x+
   +4vKlODwJf7Tng2GxY48/Pd65C1a0yey7KErZglo9HvKU9HS+3hqx3nhL
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11003"; a="29593503"
X-IronPort-AV: E=Sophos;i="6.06,205,1705392000"; 
   d="scan'208";a="29593503"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2024 01:10:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,205,1705392000"; 
   d="scan'208";a="13899085"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2024 01:10:50 -0800
Date: Tue, 5 Mar 2024 01:10:49 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
	qemu-devel@nongnu.org, Michael Roth <michael.roth@amd.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	isaku.yamahata@linux.intel.com, isaku.yamahata@intel.com
Subject: Re: [PATCH v5 08/65] kvm: handle KVM_EXIT_MEMORY_FAULT
Message-ID: <20240305091049.GA368614@ls.amr.corp.intel.com>
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
 <20240229063726.610065-9-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240229063726.610065-9-xiaoyao.li@intel.com>

On Thu, Feb 29, 2024 at 01:36:29AM -0500,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

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
> +                return 0;

The reference count leaks. Add memory_region_unref() is needed.

Otherwise looks good to me.
Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

