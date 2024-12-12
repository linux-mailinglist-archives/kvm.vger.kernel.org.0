Return-Path: <kvm+bounces-33672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 998DC9EFF24
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 23:16:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 54D5D288C8B
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 22:16:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D137F1AF0AF;
	Thu, 12 Dec 2024 22:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XprJ5TFk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C9F1D9341
	for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 22:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734041796; cv=none; b=JjLACxbFfIQOJppV3vpHGo7nTOXV2zw8lB6CsiTuYQjPDdrzEbxooOnQftgCtVyCP/Tr3Y47w074Tj73PhwfeW3KIjnvAAenlItD1ex+bYaO5qs5iYINJQl/9gDhMvb5N8pFVQIt3XdQP9SObzR8JBsCUUdnwUEQJhT7OcyTJ+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734041796; c=relaxed/simple;
	bh=L0kUO9Zc9aPn1M/kjfuUhl6rSW2X2XL2ry4fhK9++8E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OjIaujqZt3p/ZkPnpBdgzo8DMWm24wn3SJ+IgzO9z6KVLg1t7GBuhZF/iTIQ3ZdMXGBWptk2oeTkJ+tovpNGTyiyKwoOQc6Bw6LqDZekfPazbF8ForpnDTpotWvWvalutoQBUw2tnkQCfxb4f1+d4Zd9zUDBdDe5M1douEGp3r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XprJ5TFk; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734041793; x=1765577793;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=L0kUO9Zc9aPn1M/kjfuUhl6rSW2X2XL2ry4fhK9++8E=;
  b=XprJ5TFkpIzq/OHV0LaA4QDDCI63hCfWGo5NH0ekn7fTighdrOyVwmPT
   AtC/SmbRPajmUNQM/IzQxc0wdhQkRngmqAFItP1yvKYKiWS0dPePjnPWy
   7xebAP11pXNeCVzXKQUSmOxqm/A5+RruRYvi3AahP01nlwsP4RVP0UNT7
   4qiTmfRKU8k8Fuswdj2ba2bFagGCFOwuMgIcO2JoleFa7sAPahNkdwiqO
   6tIIA894q7/K+LnJvJahjy8IwNEMdJWWAKQx1dP2SD5Q1zJR9RADVMZFJ
   fnG50eavO3+vIpKDeCPEAqDauz5Zfp3AbTmUImGW29TTSIUl0QFORHq3k
   w==;
X-CSE-ConnectionGUID: xf/m+Xj6R5uMPsWKaFzz4g==
X-CSE-MsgGUID: Qa30NqZoRFWgDd69CB3uCA==
X-IronPort-AV: E=McAfee;i="6700,10204,11284"; a="34400008"
X-IronPort-AV: E=Sophos;i="6.12,229,1728975600"; 
   d="scan'208";a="34400008"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2024 14:16:33 -0800
X-CSE-ConnectionGUID: TRYlwhXoSOyJLm7Xz90EMg==
X-CSE-MsgGUID: i7NLU5X2Ro+s+BIZxKpnOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="100935842"
Received: from puneetse-mobl.amr.corp.intel.com (HELO localhost) ([10.125.110.112])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2024 14:16:31 -0800
Date: Thu, 12 Dec 2024 16:16:29 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Riku Voipio <riku.voipio@iki.fi>,
	Richard Henderson <richard.henderson@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, rick.p.edgecombe@intel.com,
	kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: [PATCH v6 35/60] i386/cpu: Introduce enable_cpuid_0x1f to force
 exposing CPUID 0x1f
Message-ID: <Z1tgvQdLeafHKXIe@iweiny-mobl>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-36-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241105062408.3533704-36-xiaoyao.li@intel.com>

On Tue, Nov 05, 2024 at 01:23:43AM -0500, Xiaoyao Li wrote:
> Currently, QEMU exposes CPUID 0x1f to guest only when necessary, i.e.,
> when topology level that cannot be enumerated by leaf 0xB, e.g., die or
> module level, are configured for the guest, e.g., -smp xx,dies=2.
> 
> However, TDX architecture forces to require CPUID 0x1f to configure CPU
> topology.
> 
> Introduce a bool flag, enable_cpuid_0x1f, in CPU for the case that
> requires CPUID leaf 0x1f to be exposed to guest.
> 
> Introduce a new function x86_has_cpuid_0x1f(), which is the warpper of
> cpu->enable_cpuid_0x1f and x86_has_extended_topo() to check if it needs
> to enable cpuid leaf 0x1f for the guest.

Could you elaborate on the relation between cpuid_0x1f and the extended
topology support?  I feel like x86_has_cpuid_0x1f() is a poor name for this
check.

Perhaps I'm just not understanding what is required here?

Ira

> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  target/i386/cpu.c     | 4 ++--
>  target/i386/cpu.h     | 9 +++++++++
>  target/i386/kvm/kvm.c | 2 +-
>  3 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 1ffbafef03e7..119b38bcb0c1 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -6731,7 +6731,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>          break;
>      case 0x1F:
>          /* V2 Extended Topology Enumeration Leaf */
> -        if (!x86_has_extended_topo(env->avail_cpu_topo)) {
> +        if (!x86_has_cpuid_0x1f(cpu)) {
>              *eax = *ebx = *ecx = *edx = 0;
>              break;
>          }
> @@ -7588,7 +7588,7 @@ void x86_cpu_expand_features(X86CPU *cpu, Error **errp)
>           * cpu->vendor_cpuid_only has been unset for compatibility with older
>           * machine types.
>           */
> -        if (x86_has_extended_topo(env->avail_cpu_topo) &&
> +        if (x86_has_cpuid_0x1f(cpu) &&
>              (IS_INTEL_CPU(env) || !cpu->vendor_cpuid_only)) {
>              x86_cpu_adjust_level(cpu, &env->cpuid_min_level, 0x1F);
>          }
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 59959b8b7a4d..dcc673262c06 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -2171,6 +2171,9 @@ struct ArchCPU {
>      /* Compatibility bits for old machine types: */
>      bool enable_cpuid_0xb;
>  
> +    /* Force to enable cpuid 0x1f */
> +    bool enable_cpuid_0x1f;
> +
>      /* Enable auto level-increase for all CPUID leaves */
>      bool full_cpuid_auto_level;
>  
> @@ -2431,6 +2434,12 @@ void host_cpuid(uint32_t function, uint32_t count,
>                  uint32_t *eax, uint32_t *ebx, uint32_t *ecx, uint32_t *edx);
>  bool cpu_has_x2apic_feature(CPUX86State *env);
>  
> +static inline bool x86_has_cpuid_0x1f(X86CPU *cpu)
> +{
> +    return cpu->enable_cpuid_0x1f ||
> +           x86_has_extended_topo(cpu->env.avail_cpu_topo);
> +}
> +
>  /* helper.c */
>  void x86_cpu_set_a20(X86CPU *cpu, int a20_state);
>  void cpu_sync_avx_hflag(CPUX86State *env);
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index dea0f83370d5..022809bad36e 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -1874,7 +1874,7 @@ uint32_t kvm_x86_build_cpuid(CPUX86State *env, struct kvm_cpuid_entry2 *entries,
>              break;
>          }
>          case 0x1f:
> -            if (!x86_has_extended_topo(env->avail_cpu_topo)) {
> +            if (!x86_has_cpuid_0x1f(env_archcpu(env))) {
>                  cpuid_i--;
>                  break;
>              }
> -- 
> 2.34.1
> 

