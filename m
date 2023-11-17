Return-Path: <kvm+bounces-1976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AB757EF8BF
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 21:35:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3FD8A281162
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 20:35:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1542446D4;
	Fri, 17 Nov 2023 20:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PJKiANd9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53345D6D
	for <kvm@vger.kernel.org>; Fri, 17 Nov 2023 12:35:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700253330; x=1731789330;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ljCjq1+xc8Fj39kUso8LFL0h1hRR9SHQuzNazVjwe3Q=;
  b=PJKiANd9VI7ZA1msJJLoBNWbgt5QZbD2JOS5AjTE8B+pwyrOa3EO+P+I
   1jOFjqpuwoXLBJZYa69Tybu1MgCMXgJuyFP+k9g9/8YCT8oHep4XOmnK/
   4A4xCb8WSQhb9gNRxlqkx5CfXlBFuCoOv+RZdjS09IEk7KXxyWJzwJXFy
   NiAaP9GhogVdWidNA/TUSWZdGR4yYVTY6QcGqEjFd91yE8dEfVks+FrqW
   JOqsxjTMnycXetjPgakVLioyirOXHQVOOTWk0EMiHnOyGDIWjb4MIkmhQ
   t1WnV5vrdQ7Z9mmv2K7vuZpdrRguwokBrW/Bkslv+Vdwbf5V+2DApYc6D
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10897"; a="4449338"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="4449338"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2023 12:35:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10897"; a="759258431"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="759258431"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2023 12:35:29 -0800
Date: Fri, 17 Nov 2023 12:35:28 -0800
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
Subject: Re: [PATCH v3 02/70] RAMBlock: Add support of KVM private guest memfd
Message-ID: <20231117203528.GA1645850@ls.amr.corp.intel.com>
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
In-Reply-To: <20231115071519.2864957-3-xiaoyao.li@intel.com>

On Wed, Nov 15, 2023 at 02:14:11AM -0500,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

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

We should define kvm_create_guest_memfd() stub in accel/stub/kvm-stub.c.
We can remove this #ifdef.
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

