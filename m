Return-Path: <kvm+bounces-61047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 27B65C07BDD
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 20:27:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 71844427327
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 18:21:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0ECD348865;
	Fri, 24 Oct 2025 18:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y3fitmbV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B3B348450
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 18:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761330062; cv=none; b=JvVfTitqxr0JUm7DrcjGtjiAv7u3oL4zTdsuXcGpSj8TaWP0HUgU592IkQMwISLwYbzzJv6dSsTjM7jBmMB2OZP/Xs9uaIhFFORovkLRps2MpEzxlU8PL335qhoikmkZpOQpNn3MU99CgfRIvhBzaYyFLXg7BGMz07r5PK7ut+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761330062; c=relaxed/simple;
	bh=k0bKNFN0B0DwSby0hg8BRKJ31o3jyXYJrBr5Tg8C/Gk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sANj0xj0ri6BRKP5oT4RrI6JXZugYTE3omN7idRWvTRGK9X2EE16bp5TxzazLj/lJSX7wfQYbXNRN9DWW/OgwrVMKtOlH+ifU66efyCVfCiBWUoxgByxn5Xr2eSk7W76VyjOutrbG8CvcFGpq9O64NDeFMAD/uxXV+wIErGnbTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y3fitmbV; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761330060; x=1792866060;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=k0bKNFN0B0DwSby0hg8BRKJ31o3jyXYJrBr5Tg8C/Gk=;
  b=Y3fitmbVSBfrKsIRgOboTYMute1a6NoHaCS8JSGTwc1OZ5Mfi+9L57am
   1ziyX4j44L9wP1znfWsh1gqIVdy5N9bt0HvGDFtMLt4d2Rs5eNuNokLL7
   nC984Qx5lI4U38Ul0ARJKrJbZQxz/VADtD2Gl1floo4uYsxXcWZQrV8DO
   isbgBo3nBBTYvvq+z2MkmYLg9/xYHG86bkWPYpYULePsABxrEjeoseIc4
   SgZEY4CtYfSBP2h8hbZ6+TwwKMtVwBoYaySsaHNd7HpSnJxwoZoTw2cEp
   EigxsK6vXLGPWYi2FASL7lilQwyBQQHDJkeLt7P3iYhEezUy+dgR+1/t+
   A==;
X-CSE-ConnectionGUID: 7EL9X6G7QkO5yJcdvY+0Gw==
X-CSE-MsgGUID: 0cdFRFlOSQqn6fXxyJgLUQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63550962"
X-IronPort-AV: E=Sophos;i="6.19,253,1754982000"; 
   d="scan'208";a="63550962"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2025 11:21:00 -0700
X-CSE-ConnectionGUID: c8BeN2ToToylWoHyo6OlaA==
X-CSE-MsgGUID: hiQFBLg+RB2RwDzMTdD+kg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,253,1754982000"; 
   d="scan'208";a="188882489"
Received: from soc-cp83kr3.clients.intel.com (HELO [10.241.241.181]) ([10.241.241.181])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2025 11:20:59 -0700
Message-ID: <242b8c3f-72bd-44f5-94f9-186ef87697c8@intel.com>
Date: Fri, 24 Oct 2025 11:20:59 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/20] i386/cpu: Clean up arch lbr xsave struct and
 comment
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, Chao Gao
 <chao.gao@intel.com>, John Allen <john.allen@amd.com>,
 Babu Moger <babu.moger@amd.com>, Mathias Krause <minipli@grsecurity.net>,
 Dapeng Mi <dapeng1.mi@intel.com>, Chenyi Qiang <chenyi.qiang@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, Farrah Chen <farrah.chen@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
 <20251024065632.1448606-4-zhao1.liu@intel.com>
Content-Language: en-US
From: "Chen, Zide" <zide.chen@intel.com>
In-Reply-To: <20251024065632.1448606-4-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/23/2025 11:56 PM, Zhao Liu wrote:
> Arch LBR state is area 15, not 19. Fix this comment. And considerring
> other areas don't mention user or supervisor state, for consistent
> style, remove "Supervisor mode" from its comment.
> 
> Moreover, rename XSavesArchLBR to XSaveArchLBR since there's no need to
> emphasize XSAVES in naming; the XSAVE related structure is mainly
> used to represent memory layout.
> 
> In addition, arch lbr specifies its offset of xsave component as 0. But
> this cannot help on anything. The offset of ExtSaveArea is initialized
> by accelerators (e.g., hvf_cpu_xsave_init(), kvm_cpu_xsave_init() and
> x86_tcg_cpu_xsave_init()), so explicitly setting the offset doesn't
> work and CPUID 0xD encoding has already ensure supervisor states won't
> have non-zero offsets. Drop the offset initialization and its comment
> from the xsave area of arch lbr.
> 
> Tested-by: Farrah Chen <farrah.chen@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

Reviewed-by: Zide Chen <zide.chen@intel.com>


> ---
>  target/i386/cpu.c | 3 +--
>  target/i386/cpu.h | 8 ++++----
>  2 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index f0e179c2d235..b9a5a0400dea 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -2058,8 +2058,7 @@ ExtSaveArea x86_ext_save_areas[XSAVE_STATE_AREA_COUNT] = {
>      },
>      [XSTATE_ARCH_LBR_BIT] = {
>          .feature = FEAT_7_0_EDX, .bits = CPUID_7_0_EDX_ARCH_LBR,
> -        .offset = 0 /*supervisor mode component, offset = 0 */,
> -        .size = sizeof(XSavesArchLBR),
> +        .size = sizeof(XSaveArchLBR),
>      },
>      [XSTATE_XTILE_CFG_BIT] = {
>          .feature = FEAT_7_0_EDX, .bits = CPUID_7_0_EDX_AMX_TILE,
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index d0da9bfe58ce..886a941e481c 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -1747,15 +1747,15 @@ typedef struct {
>  
>  #define ARCH_LBR_NR_ENTRIES            32
>  
> -/* Ext. save area 19: Supervisor mode Arch LBR state */
> -typedef struct XSavesArchLBR {
> +/* Ext. save area 15: Arch LBR state */
> +typedef struct XSaveArchLBR {
>      uint64_t lbr_ctl;
>      uint64_t lbr_depth;
>      uint64_t ler_from;
>      uint64_t ler_to;
>      uint64_t ler_info;
>      LBREntry lbr_records[ARCH_LBR_NR_ENTRIES];
> -} XSavesArchLBR;
> +} XSaveArchLBR;
>  
>  QEMU_BUILD_BUG_ON(sizeof(XSaveAVX) != 0x100);
>  QEMU_BUILD_BUG_ON(sizeof(XSaveBNDREG) != 0x40);
> @@ -1766,7 +1766,7 @@ QEMU_BUILD_BUG_ON(sizeof(XSaveHi16_ZMM) != 0x400);
>  QEMU_BUILD_BUG_ON(sizeof(XSavePKRU) != 0x8);
>  QEMU_BUILD_BUG_ON(sizeof(XSaveXTILECFG) != 0x40);
>  QEMU_BUILD_BUG_ON(sizeof(XSaveXTILEDATA) != 0x2000);
> -QEMU_BUILD_BUG_ON(sizeof(XSavesArchLBR) != 0x328);
> +QEMU_BUILD_BUG_ON(sizeof(XSaveArchLBR) != 0x328);
>  
>  typedef struct ExtSaveArea {
>      uint32_t feature, bits;


