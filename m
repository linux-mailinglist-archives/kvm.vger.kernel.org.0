Return-Path: <kvm+bounces-1978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C4A827EF91F
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 22:03:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 010D71C20E14
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 21:03:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A47C4642F;
	Fri, 17 Nov 2023 21:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cKJ0RPpg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E6DFB6
	for <kvm@vger.kernel.org>; Fri, 17 Nov 2023 13:03:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700254987; x=1731790987;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7JF/vWM+ZZeUdd9cPjB6/JC44J5sV6hwsvD6NCm73yU=;
  b=cKJ0RPpg5RZ6NAHFbVfkrywYNtlQPQJ07LZTdt5goiE3g9zyV2lj54tD
   qxK4p0FZviQF8mS7Y9I9oXTL8I9nj0xqIW3qmNmBGlrpB4lhYZuW0PbUz
   z4nwcItYDApSy2jsjM94EwwMkacBxoHpFqhxR/ZB2WszdSN/OqOVGZ7gm
   hENsx+4O0/E7/uBsErvv12th1l0TB7D6IJHrNG60tbjWavVpYPVvEgvjZ
   VNcBgavYg3l6ptS0iznmK+KkxPJs49srStOuj1KM2MymDGd0/mJnM6kWw
   taxyfHx+z3X/oSsNnmc11RvPEL9OpHNfYxSsZxKIdibb+AskYdkPCiogL
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10897"; a="391151602"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="391151602"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2023 13:03:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10897"; a="1013042135"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="1013042135"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2023 13:03:04 -0800
Date: Fri, 17 Nov 2023 13:03:04 -0800
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
Subject: Re: [PATCH v3 09/70] physmem: Introduce ram_block_convert_range()
 for page conversion
Message-ID: <20231117210304.GC1645850@ls.amr.corp.intel.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
 <20231115071519.2864957-10-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231115071519.2864957-10-xiaoyao.li@intel.com>

On Wed, Nov 15, 2023 at 02:14:18AM -0500,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> It's used for discarding opposite memory after memory conversion, for
> confidential guest.
> 
> When page is converted from shared to private, the original shared
> memory can be discarded via ram_block_discard_range();
> 
> When page is converted from private to shared, the original private
> memory is back'ed by guest_memfd. Introduce
> ram_block_discard_guest_memfd_range() for discarding memory in
> guest_memfd.
> 
> Originally-from: Isaku Yamahata <isaku.yamahata@intel.com>
> Codeveloped-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  include/exec/cpu-common.h |  2 ++
>  system/physmem.c          | 50 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 52 insertions(+)
> 
> diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
> index 41115d891940..de728a18eef2 100644
> --- a/include/exec/cpu-common.h
> +++ b/include/exec/cpu-common.h
> @@ -175,6 +175,8 @@ typedef int (RAMBlockIterFunc)(RAMBlock *rb, void *opaque);
>  
>  int qemu_ram_foreach_block(RAMBlockIterFunc func, void *opaque);
>  int ram_block_discard_range(RAMBlock *rb, uint64_t start, size_t length);
> +int ram_block_convert_range(RAMBlock *rb, uint64_t start, size_t length,
> +                            bool shared_to_private);
>  
>  #endif
>  
> diff --git a/system/physmem.c b/system/physmem.c
> index ddfecddefcd6..cd6008fa09ad 100644
> --- a/system/physmem.c
> +++ b/system/physmem.c
> @@ -3641,6 +3641,29 @@ err:
>      return ret;
>  }
>  
> +static int ram_block_discard_guest_memfd_range(RAMBlock *rb, uint64_t start,
> +                                               size_t length)
> +{
> +    int ret = -1;
> +
> +#ifdef CONFIG_FALLOCATE_PUNCH_HOLE
> +    ret = fallocate(rb->guest_memfd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
> +                    start, length);
> +
> +    if (ret) {
> +        ret = -errno;
> +        error_report("%s: Failed to fallocate %s:%" PRIx64 " +%zx (%d)",
> +                     __func__, rb->idstr, start, length, ret);
> +    }
> +#else
> +    ret = -ENOSYS;
> +    error_report("%s: fallocate not available %s:%" PRIx64 " +%zx (%d)",
> +                 __func__, rb->idstr, start, length, ret);
> +#endif
> +
> +    return ret;
> +}
> +
>  bool ramblock_is_pmem(RAMBlock *rb)
>  {
>      return rb->flags & RAM_PMEM;
> @@ -3828,3 +3851,30 @@ bool ram_block_discard_is_required(void)
>      return qatomic_read(&ram_block_discard_required_cnt) ||
>             qatomic_read(&ram_block_coordinated_discard_required_cnt);
>  }
> +
> +int ram_block_convert_range(RAMBlock *rb, uint64_t start, size_t length,
> +                            bool shared_to_private)
> +{
> +    if (!rb || rb->guest_memfd < 0) {
> +        return -1;
> +    }
> +
> +    if (!QEMU_PTR_IS_ALIGNED(start, qemu_host_page_size) ||
> +        !QEMU_PTR_IS_ALIGNED(length, qemu_host_page_size)) {
> +        return -1;
> +    }
> +
> +    if (!length) {
> +        return -1;
> +    }
> +
> +    if (start + length > rb->max_length) {
> +        return -1;
> +    }
> +
> +    if (shared_to_private) {
> +        return ram_block_discard_range(rb, start, length);
> +    } else {
> +        return ram_block_discard_guest_memfd_range(rb, start, length);
> +    }
> +}

Originally this function issued KVM_SET_MEMORY_ATTRIBUTES, the function name
mad sense. But now it doesn't, and it issues only punch hole. We should rename
it to represent what it actually does. discard_range?
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

