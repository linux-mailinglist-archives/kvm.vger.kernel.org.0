Return-Path: <kvm+bounces-50927-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48549AEABFD
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 02:50:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1BB223B667D
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 00:50:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 883C41F61C;
	Fri, 27 Jun 2025 00:50:22 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mx1.zhaoxin.com (MX1.ZHAOXIN.COM [210.0.225.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C4B14A82
	for <kvm@vger.kernel.org>; Fri, 27 Jun 2025 00:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.0.225.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750985422; cv=none; b=LXEUx8NgXZvOAKiphSpdZiP1LLtMOHQqZnqzLafCbja4Lk4h59yH5VXpuKY6GSvTKzSCVnBNMiwDatTZHOif6iJcjIpjJcDffMhk3M+luHWiaSlOdITa1DOpjF0OTuK2KEufeoC2tgIUYawt8cfPCWgogTNwRgQ1SzdcGH5xoW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750985422; c=relaxed/simple;
	bh=lfMUpFf409+bLEYJ6xQq1RO/178Cyu3mwvqICFPoKGU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Qpf7qRdbUP2Ig+2dedpArCErMSPBovxBjd///mrqjrOiqZNif0aa5BMdqct09hUkejowf067MRb9Wxi/oiS87XNvCGpckXuMnQdBjjGLBWhl7gL5+6dTC2SPxgmGzcocUBRXBGoKA8KEjQo0+EWBDKyTIl8bAxqkNMEDMYkumSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=210.0.225.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1750985404-086e23278359f30001-HEqcsx
Received: from ZXSHMBX3.zhaoxin.com (ZXSHMBX3.zhaoxin.com [10.28.252.165]) by mx1.zhaoxin.com with ESMTP id xI0nD2rHPPIPkhLW (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Fri, 27 Jun 2025 08:50:04 +0800 (CST)
X-Barracuda-Envelope-From: EwanHai-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.165
Received: from ZXSHMBX1.zhaoxin.com (10.28.252.163) by ZXSHMBX3.zhaoxin.com
 (10.28.252.165) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.44; Fri, 27 Jun
 2025 08:50:03 +0800
Received: from ZXSHMBX1.zhaoxin.com ([::1]) by ZXSHMBX1.zhaoxin.com
 ([fe80::2c07:394e:4919:4dc1%7]) with mapi id 15.01.2507.044; Fri, 27 Jun 2025
 08:50:03 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.165
Received: from [192.168.31.91] (10.28.66.62) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.44; Thu, 26 Jun
 2025 20:10:52 +0800
Message-ID: <fe3c59c0-446c-4e93-9a8b-32c5314df401@zhaoxin.com>
Date: Thu, 26 Jun 2025 20:10:51 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/16] i386/cpu: Consolidate CPUID 0x4 leaf
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, "Michael S . Tsirkin"
	<mst@redhat.com>, =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?=
	<berrange@redhat.com>, Igor Mammedov <imammedo@redhat.com>, Marcel Apfelbaum
	<marcel.apfelbaum@gmail.com>, Richard Henderson
	<richard.henderson@linaro.org>, Eduardo Habkost <eduardo@habkost.net>
X-ASG-Orig-Subj: Re: [PATCH 05/16] i386/cpu: Consolidate CPUID 0x4 leaf
CC: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Babu Moger
	<babu.moger@amd.com>, Pu Wen <puwen@hygon.cn>, Tao Su <tao1.su@intel.com>,
	"Yi Lai" <yi1.lai@intel.com>, Dapeng Mi <dapeng1.mi@intel.com>,
	<qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
References: <20250620092734.1576677-1-zhao1.liu@intel.com>
 <20250620092734.1576677-6-zhao1.liu@intel.com>
From: Ewan Hai <ewanhai-oc@zhaoxin.com>
In-Reply-To: <20250620092734.1576677-6-zhao1.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZXSHCAS1.zhaoxin.com (10.28.252.161) To
 zxbjmbx1.zhaoxin.com (10.29.252.163)
X-Moderation-Data: 6/27/2025 8:50:02 AM
X-Barracuda-Connect: ZXSHMBX3.zhaoxin.com[10.28.252.165]
X-Barracuda-Start-Time: 1750985404
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.35:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 4046
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.143446
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------



On 6/20/25 5:27 PM, Zhao Liu wrote:
> 
> 
> Modern Intel CPUs use CPUID 0x4 leaf to describe cache information
> and leave space in 0x2 for prefetch and TLBs (even TLB has its own leaf
> CPUID 0x18).
> 
> And 0x2 leaf provides a descriptor 0xFF to instruct software to check
> cache information in 0x4 leaf instead.
> 
> Therefore, follow this behavior to encode 0xFF when Intel CPU has 0x4
> leaf with "x-consistent-cache=true" for compatibility.
> 
> In addition, for older CPUs without 0x4 leaf, still enumerate the cache
> descriptor in 0x2 leaf, except the case that there's no descriptor
> matching the cache model, then directly encode 0xFF in 0x2 leaf. This
> makes sense, as in the 0x2 leaf era, all supported caches should have
> the corresponding descriptor.
> 
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
>   target/i386/cpu.c | 48 ++++++++++++++++++++++++++++++++++++-----------
>   1 file changed, 37 insertions(+), 11 deletions(-)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 2f895bf13523..a06aa1d629dc 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -223,7 +223,7 @@ struct CPUID2CacheDescriptorInfo cpuid2_cache_descriptors[] = {
>    * Return a CPUID 2 cache descriptor for a given cache.
>    * If no known descriptor is found, return CACHE_DESCRIPTOR_UNAVAILABLE
>    */
> -static uint8_t cpuid2_cache_descriptor(CPUCacheInfo *cache)
> +static uint8_t cpuid2_cache_descriptor(CPUCacheInfo *cache, bool *unmacthed)
>   {
>       int i;
> 
> @@ -240,9 +240,44 @@ static uint8_t cpuid2_cache_descriptor(CPUCacheInfo *cache)
>               }
>       }
> 
> +    *unmacthed |= true;
>       return CACHE_DESCRIPTOR_UNAVAILABLE;
>   }
> 
> +/* Encode cache info for CPUID[4] */

Maybe this should be /* Encode cache info for CPUID[2] */ ?
I'm not sure.

> +static void encode_cache_cpuid2(X86CPU *cpu,
> +                                uint32_t *eax, uint32_t *ebx,
> +                                uint32_t *ecx, uint32_t *edx)
> +{
> +    CPUX86State *env = &cpu->env;
> +    CPUCaches *caches = &env->cache_info_cpuid2;
> +    int l1d, l1i, l2, l3;
> +    bool unmatched = false;
> +
> +    *eax = 1; /* Number of CPUID[EAX=2] calls required */
> +    *ebx = *ecx = *edx = 0;
> +
> +    l1d = cpuid2_cache_descriptor(caches->l1d_cache, &unmatched);
> +    l1i = cpuid2_cache_descriptor(caches->l1i_cache, &unmatched);
> +    l2 = cpuid2_cache_descriptor(caches->l2_cache, &unmatched);
> +    l3 = cpuid2_cache_descriptor(caches->l3_cache, &unmatched);
> +
> +    if (!cpu->consistent_cache ||
> +        (env->cpuid_min_level < 0x4 && !unmatched)) {
> +        /*
> +         * Though SDM defines code 0x40 for cases with no L2 or L3. It's
> +         * also valid to just ignore l3's code if there's no l2.
> +         */
> +        if (cpu->enable_l3_cache) {
> +            *ecx = l3;
> +        }
> +        *edx = (l1d << 16) | (l1i <<  8) | l2;
> +    } else {
> +        *ecx = 0;
> +        *edx = CACHE_DESCRIPTOR_UNAVAILABLE;
> +    }
> +}
> +
>   /* CPUID Leaf 4 constants: */
> 
>   /* EAX: */
> @@ -7451,16 +7486,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>               *eax = *ebx = *ecx = *edx = 0;
>               break;
>           }
> -        *eax = 1; /* Number of CPUID[EAX=2] calls required */
> -        *ebx = 0;
> -        if (!cpu->enable_l3_cache) {
> -            *ecx = 0;
> -        } else {
> -            *ecx = cpuid2_cache_descriptor(env->cache_info_cpuid2.l3_cache);
> -        }
> -        *edx = (cpuid2_cache_descriptor(env->cache_info_cpuid2.l1d_cache) << 16) |
> -               (cpuid2_cache_descriptor(env->cache_info_cpuid2.l1i_cache) <<  8) |
> -               (cpuid2_cache_descriptor(env->cache_info_cpuid2.l2_cache));
> +        encode_cache_cpuid2(cpu, eax, ebx, ecx, edx);
>           break;
>       case 4:
>           /* cache info: needed for Core compatibility */
> --
> 2.34.1
> 


