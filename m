Return-Path: <kvm+bounces-11652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 47C22879184
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 10:57:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C883E1F22212
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 09:57:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF26F78291;
	Tue, 12 Mar 2024 09:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QqH2FGc7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E1E33994
	for <kvm@vger.kernel.org>; Tue, 12 Mar 2024 09:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710237463; cv=none; b=rDLHw/PYVjw1RmV28TPTjmKKZL98x3Kt7iH4ZkcPTJMRSVsbftkH6rdgXMv6FrMSILNtmIZLSoGwBr2qa+skFA44srXiJL8IHcJbt02cpeAeONhD4TRGAKnsEZr4/QFH+Uqp+3nojglzqsprrZtF1lNhzZxiKPdenG+fLieHjGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710237463; c=relaxed/simple;
	bh=m4NiaKsQ27utBVnDv39yTWwqiXt/Umj7/8ZxBQI5cT4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QHjoZx43XgkFe6b6i6YvfozrWjm6m78W6Mc8mvxHMpI7/gHpP7KU9H7QWXwYX7RwHqQyKVCOU0PaGJ+fTjEmNcmiYTpGy5SKi6Ct/teXJphMotCYUtsIzrG+A5bgoftp3pnAF3YWs+OpobQp4l0+NpEwzzBXvB8SFA0lSyJr+ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QqH2FGc7; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710237461; x=1741773461;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=m4NiaKsQ27utBVnDv39yTWwqiXt/Umj7/8ZxBQI5cT4=;
  b=QqH2FGc755PnI6kmG5WbctvBV65VdzydfIXKBPlmQB6IC8HTuLHB8cS8
   yE+RHmdCu/vIDB3uclGPRPXScI4jp++aAY7LLu/y6xmXk6BIYt6kUW9rn
   Ss5B5MA1NvvFI4cTl7ReHNwNmR5E3FFawA8GPoKZ5NarXHIzZTf8ZMDYd
   uOiPIHvfopkQPY9LyPQ/intCTFHN2GRE3kGa6BM4ymVy3ZE1TYmb/+Exl
   hiCO21jqLmqDoR7mc0j8EWT1NLvs7FGGqVv/bnLMnmIhKrpNd41asHE5S
   9GVWI9qPWKgPPOySBIYOHDheqJ//zIFjHYOkmdOv6mtAVoHjIqZqm5h9B
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11010"; a="4808985"
X-IronPort-AV: E=Sophos;i="6.07,119,1708416000"; 
   d="scan'208";a="4808985"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2024 02:57:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,119,1708416000"; 
   d="scan'208";a="11550428"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa009.jf.intel.com with ESMTP; 12 Mar 2024 02:57:36 -0700
Date: Tue, 12 Mar 2024 18:11:24 +0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	qemu-devel@nongnu.org, kvm@vger.kernel.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Babu Moger <babu.moger@amd.com>, Yongwei Ma <yongwei.ma@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH v9 11/21] i386/cpu: Decouple CPUID[0x1F] subleaf with
 specific topology level
Message-ID: <ZfAqTEN8pvvgZ8IO@intel.com>
References: <20240227103231.1556302-1-zhao1.liu@linux.intel.com>
 <20240227103231.1556302-12-zhao1.liu@linux.intel.com>
 <005c1649-43d3-494f-951a-166e7200ffd5@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <005c1649-43d3-494f-951a-166e7200ffd5@intel.com>

On Mon, Mar 11, 2024 at 04:45:41PM +0800, Xiaoyao Li wrote:
> Date: Mon, 11 Mar 2024 16:45:41 +0800
> From: Xiaoyao Li <xiaoyao.li@intel.com>
> Subject: Re: [PATCH v9 11/21] i386/cpu: Decouple CPUID[0x1F] subleaf with
>  specific topology level
> 
> On 2/27/2024 6:32 PM, Zhao Liu wrote:
> > From: Zhao Liu <zhao1.liu@intel.com>
> > 
> > At present, the subleaf 0x02 of CPUID[0x1F] is bound to the "die" level.
> > 
> > In fact, the specific topology level exposed in 0x1F depends on the
> > platform's support for extension levels (module, tile and die).
> > 
> > To help expose "module" level in 0x1F, decouple CPUID[0x1F] subleaf
> > with specific topology level.
> > 
> > Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> 
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

Thanks!

> Besides, some nits below.
>

[snip]

> > +static void encode_topo_cpuid1f(CPUX86State *env, uint32_t count,
> > +                                X86CPUTopoInfo *topo_info,
> > +                                uint32_t *eax, uint32_t *ebx,
> > +                                uint32_t *ecx, uint32_t *edx)
> > +{
> > +    X86CPU *cpu = env_archcpu(env);
> > +    unsigned long level;
> > +    uint32_t num_threads_next_level, offset_next_level;
> > +
> > +    assert(count + 1 < CPU_TOPO_LEVEL_MAX);
> > +
> > +    /*
> > +     * Find the No.count topology levels in avail_cpu_topo bitmap.
> > +     * Start from bit 0 (CPU_TOPO_LEVEL_INVALID).
> 
> AFAICS, it starts from bit 1 (CPU_TOPO_LEVEL_SMT). Because the initial value
> of level is CPU_TOPO_LEVEL_INVALID, but the first round of the loop is to
> find the valid bit starting from (level + 1).

Yes, this description is much clearer.

> > +     */
> > +    level = CPU_TOPO_LEVEL_INVALID;
> > +    for (int i = 0; i <= count; i++) {
> > +        level = find_next_bit(env->avail_cpu_topo,
> > +                              CPU_TOPO_LEVEL_PACKAGE,
> > +                              level + 1);
> > +
> > +        /*
> > +         * CPUID[0x1f] doesn't explicitly encode the package level,
> > +         * and it just encode the invalid level (all fields are 0)
> > +         * into the last subleaf of 0x1f.
> > +         */
> 
> QEMU will never set bit CPU_TOPO_LEVEL_PACKAGE in env->avail_cpu_topo.

In the patch 9 [1], I set the CPU_TOPO_LEVEL_PACKAGE in bitmap. This
level is a basic topology level in general, so it's worth being set.

Only in Intel's 0x1F, it doesn't have a corresponding type, and where
I use it as a termination condition for 0x1F encoding (not an error case).

[1]: https://lore.kernel.org/qemu-devel/20240227103231.1556302-10-zhao1.liu@linux.intel.com/

> So I think we should assert() it instead of fixing it silently.
> 
> > +        if (level == CPU_TOPO_LEVEL_PACKAGE) {
> > +            level = CPU_TOPO_LEVEL_INVALID;
> > +            break;
> > +        }
> > +    }
> > +
> > +    if (level == CPU_TOPO_LEVEL_INVALID) {
> > +        num_threads_next_level = 0;
> > +        offset_next_level = 0;
> > +    } else {
> > +        unsigned long next_level;
> 
> please define it at the beginning of the function. e.g.,

Okay, I'll put the declaration of "next_level" at the beginning of this
function with a current variable "level".

> 
> > +        next_level = find_next_bit(env->avail_cpu_topo,
> > +                                   CPU_TOPO_LEVEL_PACKAGE,
> > +                                   level + 1);
> > +        num_threads_next_level = num_threads_by_topo_level(topo_info,
> > +                                                           next_level);
> > +        offset_next_level = apicid_offset_by_topo_level(topo_info,
> > +                                                        next_level);
> > +    }
> > +
> > +    *eax = offset_next_level;
> > +    *ebx = num_threads_next_level;
> > +    *ebx &= 0xffff; /* The count doesn't need to be reliable. */
> 
> we can combine them together. e.g.,
> 
> *ebx = num_threads_next_level & 0xffff; /* ... */
> 
> > +    *ecx = count & 0xff;
> > +    *ecx |= cpuid1f_topo_type(level) << 8;
> 
> Ditto,
> 
> *ecx = count & 0xff | cpuid1f_topo_type(level) << 8;

OK, will combine these.

> > +    *edx = cpu->apic_id;
> > +
> > +    assert(!(*eax & ~0x1f));
> > +}
> > +

