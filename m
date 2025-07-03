Return-Path: <kvm+bounces-51378-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 26460AF6B19
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 09:10:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 66D297A6E29
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 07:08:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC9B7295528;
	Thu,  3 Jul 2025 07:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X9mYK9uX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837976AA7
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 07:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751526602; cv=none; b=KxnSmq5tVrUXtOE/a196huoQ0CSRW8bIx1KKr2wcKNL5Q0WX/iDaW721QlfRYKgBLeIY3D3GRx6MlPFpeN+qsjz7pATE2nrljPdeB3Z4HBdPu70uDtx039+EW2bG9+o6oHXnUhWwmKceA5ccUeubPOOtt7v/SA12jnScXC1Lwao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751526602; c=relaxed/simple;
	bh=gu1kuX+x3jm0OL9CsPf27CAWf+gZYn1R1xuY9NCmjHM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CjWOpMF4hVyjpnlplKjOO+yBgYSzSuMXF6gb0T3D9m9veIhj5TpejCwfV9Lu5jN8UwS0tqKIwAHjMK53DTr5xHXX616m3a3iR4DbjiYQp6D91Jg2tapYOuo3Id2dwIwRpqT6Q6gdfBe+6qnbJ9LrbXQdvGO7MjiGVeUvDX4BX4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X9mYK9uX; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751526601; x=1783062601;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gu1kuX+x3jm0OL9CsPf27CAWf+gZYn1R1xuY9NCmjHM=;
  b=X9mYK9uXcMDe1SD9ieD628Zxe1pm/18YFaEtuQ/Pg74z9GBFygY+I+UZ
   aDQAM5yyw8olbbJLJccDbb+/EpkmCg8IRXl6k084Yv/iEZPfODLBy2iLw
   l/iMfNpQFaw5TdygbYFqbQPuaLO/nyLYYTEZXZZwDnC43NTZkJjbVA5wj
   Ib0I5x/e1Oth1jzEQc3hdkhmdUdgLV33gCQ4ftvUZMswDPsUJtblHREyQ
   R4XUfvziKrgVsWkjm2g+tF57od8p7RkS64jfWwa7Xlra/8fya3mCPaR5L
   cfJ4NzwHnhIbCkTuhF/D3BdeHI3MDUiKH2WQSWkBU5GitKTClQrZdD6Dl
   g==;
X-CSE-ConnectionGUID: Jype11arQ6CwKqnSaRK/Bg==
X-CSE-MsgGUID: fRAncxoeRgKs4he6bRoQiw==
X-IronPort-AV: E=McAfee;i="6800,10657,11482"; a="64436707"
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="64436707"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 00:10:00 -0700
X-CSE-ConnectionGUID: 3hTdmM7uQUiRd006m8kR6w==
X-CSE-MsgGUID: dElb9iwPQmWOI4fDtepc7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="185313944"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.80]) ([10.124.240.80])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 00:09:55 -0700
Message-ID: <bd979e2d-e036-4a1a-bf8a-0098eadb4821@linux.intel.com>
Date: Thu, 3 Jul 2025 15:09:52 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/16] i386/cpu: Fix CPUID[0x80000006] for Intel CPU
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, "Michael S . Tsirkin"
 <mst@redhat.com>, =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Eduardo Habkost <eduardo@habkost.net>
Cc: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Babu Moger <babu.moger@amd.com>, Ewan Hai <ewanhai-oc@zhaoxin.com>,
 Pu Wen <puwen@hygon.cn>, Tao Su <tao1.su@intel.com>,
 Yi Lai <yi1.lai@intel.com>, Dapeng Mi <dapeng1.mi@intel.com>,
 qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20250620092734.1576677-1-zhao1.liu@intel.com>
 <20250620092734.1576677-9-zhao1.liu@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250620092734.1576677-9-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 6/20/2025 5:27 PM, Zhao Liu wrote:
> Per SDM, Intel supports CPUID[0x80000006]. But only L2 information is
> encoded in ECX (note that L2 associativity field encodings rules
> consistent with AMD are used), all other fields are reserved.
>
> Therefore, make the following changes to CPUID[0x80000006]:
>  * Rename AMD_ENC_ASSOC to X86_ENC_ASSOC since Intel also uses the same
>    rules. (While there are some slight differences between the rules in
>    AMD APM v4.07 no.40332 and those in the current QEMU, generally they
>    are consistent.)
>  * Check the vendor in CPUID[0x80000006] and just encode L2 to ECX for
>    Intel.
>  * Assert L2's lines_per_tag is not 0 for AMD, and assert it is 0 for
>    Intel.
>  * Apply the encoding change of Intel for Zhaoxin as well [1].
>
> This fix also resolves the FIXME of legacy_l2_cache_amd:
>
> /*FIXME: CPUID leaf 0x80000006 is inconsistent with leaves 2 & 4 */
>
> In addition, per AMD's APM, update the comment of CPUID[0x80000006].
>
> [1]: https://lore.kernel.org/qemu-devel/c522ebb5-04d5-49c6-9ad8-d755b8998988@zhaoxin.com/
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
> Changes since RFC:
>  * Check vendor_cpuid_only_v2 instead of vendor_cpuid_only.
>  * Move lines_per_tag assert check into encode_cache_cpuid80000006().
> ---
>  target/i386/cpu.c | 42 +++++++++++++++++++++++++++---------------
>  1 file changed, 27 insertions(+), 15 deletions(-)
>
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index df40d1362566..0b292aa2e07b 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -506,8 +506,8 @@ static uint32_t encode_cache_cpuid80000005(CPUCacheInfo *cache)
>  
>  #define ASSOC_FULL 0xFF
>  
> -/* AMD associativity encoding used on CPUID Leaf 0x80000006: */
> -#define AMD_ENC_ASSOC(a) (a <=   1 ? a   : \
> +/* x86 associativity encoding used on CPUID Leaf 0x80000006: */
> +#define X86_ENC_ASSOC(a) (a <=   1 ? a   : \
>                            a ==   2 ? 0x2 : \
>                            a ==   4 ? 0x4 : \
>                            a ==   8 ? 0x6 : \
> @@ -526,23 +526,26 @@ static uint32_t encode_cache_cpuid80000005(CPUCacheInfo *cache)
>   */
>  static void encode_cache_cpuid80000006(CPUCacheInfo *l2,
>                                         CPUCacheInfo *l3,
> -                                       uint32_t *ecx, uint32_t *edx)
> +                                       uint32_t *ecx, uint32_t *edx,
> +                                       bool lines_per_tag_supported)
>  {
>      assert(l2->size % 1024 == 0);
>      assert(l2->associativity > 0);
> -    assert(l2->lines_per_tag > 0);
> -    assert(l2->line_size > 0);

why remove the assert for l2->line_size?


> +    assert(lines_per_tag_supported ?
> +           l2->lines_per_tag > 0 : l2->lines_per_tag == 0);
>      *ecx = ((l2->size / 1024) << 16) |
> -           (AMD_ENC_ASSOC(l2->associativity) << 12) |
> +           (X86_ENC_ASSOC(l2->associativity) << 12) |
>             (l2->lines_per_tag << 8) | (l2->line_size);
>  
> +    /* For Intel, EDX is reserved. */
>      if (l3) {
>          assert(l3->size % (512 * 1024) == 0);
>          assert(l3->associativity > 0);
> -        assert(l3->lines_per_tag > 0);
> +        assert(lines_per_tag_supported ?
> +               l3->lines_per_tag > 0 : l3->lines_per_tag == 0);
>          assert(l3->line_size > 0);
>          *edx = ((l3->size / (512 * 1024)) << 18) |
> -               (AMD_ENC_ASSOC(l3->associativity) << 12) |
> +               (X86_ENC_ASSOC(l3->associativity) << 12) |
>                 (l3->lines_per_tag << 8) | (l3->line_size);
>      } else {
>          *edx = 0;
> @@ -711,7 +714,6 @@ static CPUCacheInfo legacy_l2_cache = {
>      .share_level = CPU_TOPOLOGY_LEVEL_CORE,
>  };
>  
> -/*FIXME: CPUID leaf 0x80000006 is inconsistent with leaves 2 & 4 */
>  static CPUCacheInfo legacy_l2_cache_amd = {
>      .type = UNIFIED_CACHE,
>      .level = 2,
> @@ -7906,23 +7908,33 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>          *edx = encode_cache_cpuid80000005(env->cache_info_amd.l1i_cache);
>          break;
>      case 0x80000006:
> -        /* cache info (L2 cache) */
> +        /* cache info (L2 cache/TLB/L3 cache) */
>          if (cpu->cache_info_passthrough) {
>              x86_cpu_get_cache_cpuid(index, 0, eax, ebx, ecx, edx);
>              break;
>          }
> -        *eax = (AMD_ENC_ASSOC(L2_DTLB_2M_ASSOC) << 28) |
> +
> +        if (cpu->vendor_cpuid_only_v2 &&
> +            (IS_INTEL_CPU(env) || IS_ZHAOXIN_CPU(env))) {
> +            *eax = *ebx = 0;
> +            encode_cache_cpuid80000006(env->cache_info_cpuid4.l2_cache,
> +                                       NULL, ecx, edx, false);
> +            break;
> +        }
> +
> +        *eax = (X86_ENC_ASSOC(L2_DTLB_2M_ASSOC) << 28) |
>                 (L2_DTLB_2M_ENTRIES << 16) |
> -               (AMD_ENC_ASSOC(L2_ITLB_2M_ASSOC) << 12) |
> +               (X86_ENC_ASSOC(L2_ITLB_2M_ASSOC) << 12) |
>                 (L2_ITLB_2M_ENTRIES);
> -        *ebx = (AMD_ENC_ASSOC(L2_DTLB_4K_ASSOC) << 28) |
> +        *ebx = (X86_ENC_ASSOC(L2_DTLB_4K_ASSOC) << 28) |
>                 (L2_DTLB_4K_ENTRIES << 16) |
> -               (AMD_ENC_ASSOC(L2_ITLB_4K_ASSOC) << 12) |
> +               (X86_ENC_ASSOC(L2_ITLB_4K_ASSOC) << 12) |
>                 (L2_ITLB_4K_ENTRIES);
> +
>          encode_cache_cpuid80000006(env->cache_info_amd.l2_cache,
>                                     cpu->enable_l3_cache ?
>                                     env->cache_info_amd.l3_cache : NULL,
> -                                   ecx, edx);
> +                                   ecx, edx, true);
>          break;
>      case 0x80000007:
>          *eax = 0;

