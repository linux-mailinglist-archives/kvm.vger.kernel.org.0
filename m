Return-Path: <kvm+bounces-46141-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 93DF3AB30BC
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 09:46:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D137B189BAC7
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 07:46:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CA6F25525C;
	Mon, 12 May 2025 07:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G07hTV/O"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539492566D4
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 07:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747035989; cv=none; b=R81TVUKwu7Y64rrDbAi9IQpkFZvtZOF/p1/4QGtbsMhzK9ghWnrR+j7FJBQtoHbvTa663nG1G7U8Ela7sK3lf+aYT0KL9g61cSHijm2V+6EI7BLQ6cXAaEnUOo0E8TqfxCE/4zYysefofk2mc+Ez1R++XJaTckUTOKZMpre9aa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747035989; c=relaxed/simple;
	bh=iBK0lK8aZNneNniNfW/LpU9WpjK3D8Ahrjop4/GkZK0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lkg9s8YokU/Pjs4EVN7DHSlyUJVwmUJOnx4u3rRyYKYxN/P2KrH0AbJJLUSnH07LIQ0FX3qfrjHOMTnwgtP536KQGZh9IwiTHBjlKyuRTsJrqhjHSHuayKet5a8hh6MFZbTBg+X0Msz43FvQ1cgg19tPLyWQ/7ayi0HRb4N6gJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G07hTV/O; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747035987; x=1778571987;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=iBK0lK8aZNneNniNfW/LpU9WpjK3D8Ahrjop4/GkZK0=;
  b=G07hTV/O2znOw0CElnNwwynmop7FyLhnb+LMYeXn1wjF+1MSypbR2vjM
   4DyICq0yZTidP1Z1WoWlsCnNQQduPYEOxl6ONUzelBqFN7WeKKHRcJl00
   B5AsiTr5MvDq4sJBCiZaOVOH+btVr7IaAqefCGwX1k0F4M/nbjsREDFa7
   ZqMxpj/9gXBxbBfES/KRVJ3WSCDmk8nO2s50NT91oIRki7zy0k4VZ+o7A
   3NKi7jAvGbSagX6bWxuhTp1VUgAitBzCN+CaVDvgDRDORas6kRMWGRUqk
   vFL0+/iKIE28SCqbycJKzckqlQcvZ8E1ri5qsqc8zE9SDdNdnUWMnQiWV
   w==;
X-CSE-ConnectionGUID: irN4O8dERPiI/vZVp4Qyhg==
X-CSE-MsgGUID: ifSciN7jTKKDAOkysNA0Wg==
X-IronPort-AV: E=McAfee;i="6700,10204,11430"; a="48744428"
X-IronPort-AV: E=Sophos;i="6.15,281,1739865600"; 
   d="scan'208";a="48744428"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 00:46:27 -0700
X-CSE-ConnectionGUID: j59mCUCoTHuhaqL6Sbi2vg==
X-CSE-MsgGUID: EHcgkk8oR/SiWI3IT1I5ZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,281,1739865600"; 
   d="scan'208";a="142250312"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa004.jf.intel.com with ESMTP; 12 May 2025 00:46:23 -0700
Date: Mon, 12 May 2025 16:07:26 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Chenyi Qiang <chenyi.qiang@intel.com>
Cc: David Hildenbrand <david@redhat.com>,
	Alexey Kardashevskiy <aik@amd.com>, Peter Xu <peterx@redhat.com>,
	Gupta Pankaj <pankaj.gupta@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Williams Dan J <dan.j.williams@intel.com>,
	Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
Subject: Re: [PATCH v4 07/13] ram-block-attribute: Introduce
 RamBlockAttribute to manage RAMBLock with guest_memfd
Message-ID: <aCGsPh/A3sh0dDlI@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
 <20250407074939.18657-8-chenyi.qiang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250407074939.18657-8-chenyi.qiang@intel.com>

[snip]

> ---
>  include/exec/ramblock.h      |  24 +++
>  system/meson.build           |   1 +
>  system/ram-block-attribute.c | 282 +++++++++++++++++++++++++++++++++++
>  3 files changed, 307 insertions(+)
>  create mode 100644 system/ram-block-attribute.c

checkpatch.pl complains a lot about code line length:

total: 5 errors, 34 warnings, 324 lines checked

> diff --git a/include/exec/ramblock.h b/include/exec/ramblock.h
> index 0babd105c0..b8b5469db9 100644
> --- a/include/exec/ramblock.h
> +++ b/include/exec/ramblock.h
> @@ -23,6 +23,10 @@
>  #include "cpu-common.h"
>  #include "qemu/rcu.h"
>  #include "exec/ramlist.h"
> +#include "system/hostmem.h"
> +
> +#define TYPE_RAM_BLOCK_ATTRIBUTE "ram-block-attribute"
> +OBJECT_DECLARE_TYPE(RamBlockAttribute, RamBlockAttributeClass, RAM_BLOCK_ATTRIBUTE)

Could we use "OBJECT_DECLARE_SIMPLE_TYPE" here? Since I find class
doesn't have any virtual method.

>  struct RAMBlock {
>      struct rcu_head rcu;
> @@ -90,5 +94,25 @@ struct RAMBlock {
>       */
>      ram_addr_t postcopy_length;
>  };
> +
> +struct RamBlockAttribute {
> +    Object parent;
> +
> +    MemoryRegion *mr;
> +
> +    /* 1-setting of the bit represents the memory is populated (shared) */
> +    unsigned shared_bitmap_size;
> +    unsigned long *shared_bitmap;
> +
> +    QLIST_HEAD(, PrivateSharedListener) psl_list;
> +};
> +
> +struct RamBlockAttributeClass {
> +    ObjectClass parent_class;
> +};

With OBJECT_DECLARE_SIMPLE_TYPE, this class definition is not needed.

> +int ram_block_attribute_realize(RamBlockAttribute *attr, MemoryRegion *mr);
> +void ram_block_attribute_unrealize(RamBlockAttribute *attr);
> +
>  #endif
>  #endif
> diff --git a/system/meson.build b/system/meson.build
> index 4952f4b2c7..50a5a64f1c 100644
> --- a/system/meson.build
> +++ b/system/meson.build
> @@ -15,6 +15,7 @@ system_ss.add(files(
>    'dirtylimit.c',
>    'dma-helpers.c',
>    'globals.c',
> +  'ram-block-attribute.c',

This new file is missing a MAINTAINERS entry.

>    'memory_mapping.c',
>    'qdev-monitor.c',
>    'qtest.c',

[snip]

> +static size_t ram_block_attribute_get_block_size(const RamBlockAttribute *attr)
> +{
> +    /*
> +     * Because page conversion could be manipulated in the size of at least 4K or 4K aligned,
> +     * Use the host page size as the granularity to track the memory attribute.
> +     */
> +    g_assert(attr && attr->mr && attr->mr->ram_block);
> +    g_assert(attr->mr->ram_block->page_size == qemu_real_host_page_size());
> +    return attr->mr->ram_block->page_size;

What about using qemu_ram_pagesize() instead of accessing
ram_block->page_size directly?

Additionally, maybe we can add a simple helper to get page size from
RamBlockAttribute.

> +}
> +

[snip]

> +static void ram_block_attribute_psm_register_listener(GenericStateManager *gsm,
> +                                                      StateChangeListener *scl,
> +                                                      MemoryRegionSection *section)
> +{
> +    RamBlockAttribute *attr = RAM_BLOCK_ATTRIBUTE(gsm);
> +    PrivateSharedListener *psl = container_of(scl, PrivateSharedListener, scl);
> +    int ret;
> +
> +    g_assert(section->mr == attr->mr);
> +    scl->section = memory_region_section_new_copy(section);
> +
> +    QLIST_INSERT_HEAD(&attr->psl_list, psl, next);
> +
> +    ret = ram_block_attribute_for_each_shared_section(attr, section, scl,
> +                                                      ram_block_attribute_notify_shared_cb);
> +    if (ret) {
> +        error_report("%s: Failed to register RAM discard listener: %s", __func__,
> +                     strerror(-ret));

There will be 2 error messages: one is the above, and another is from
ram_block_attribute_for_each_shared_section().

Could we just exit to handle this error?

> +    }
> +}
> +
> +static void ram_block_attribute_psm_unregister_listener(GenericStateManager *gsm,
> +                                                        StateChangeListener *scl)
> +{
> +    RamBlockAttribute *attr = RAM_BLOCK_ATTRIBUTE(gsm);
> +    PrivateSharedListener *psl = container_of(scl, PrivateSharedListener, scl);
> +    int ret;
> +
> +    g_assert(scl->section);
> +    g_assert(scl->section->mr == attr->mr);
> +
> +    ret = ram_block_attribute_for_each_shared_section(attr, scl->section, scl,
> +                                                      ram_block_attribute_notify_private_cb);
> +    if (ret) {
> +        error_report("%s: Failed to unregister RAM discard listener: %s", __func__,
> +                     strerror(-ret));

Ditto.

> +    }
> +
> +    memory_region_section_free_copy(scl->section);
> +    scl->section = NULL;
> +    QLIST_REMOVE(psl, next);
> +}
> +

