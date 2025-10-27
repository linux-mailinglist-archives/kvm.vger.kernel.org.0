Return-Path: <kvm+bounces-61132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id ED9C5C0BE88
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 07:08:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 2A1743424BD
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 06:08:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0697C2DAFBB;
	Mon, 27 Oct 2025 06:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bE0PYOmP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744032DA740
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 06:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761545304; cv=none; b=u2Zo4h71caOh8vT9GvAI9tM60FTcAdyIN3RRh+vNCvrJQvhlsH7N5Vjd7cYVcRKnVuKnKjt6tNtHel1qUKPufEzTjQKg7sj9jvEDxhGYnX8jDH7sNfPjtb6C+v5HvXz8QRHn3UltJkL5KykoV/SeLeocCMecFaA9fiXwXMElyl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761545304; c=relaxed/simple;
	bh=9aPOXXMZhxckm5IZ7JpMj9IGhEIB7o2FEzlDFbTBEoU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=On4UHIrDs3C4C2y0nwLQlsrpc+Pz163YJrv/qSw1XxsfuaIcqViq8yirXBRppTtsNZvgZQ7tl4ulVt2/cvdz0ACkb7Y96vk8wKDcxni7UBY9/OOvYWpPJudfUzzT5W8wgKgsDlvc/g+3vMkx2aKyHPJYyCd75KA1izvpNYf+YjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bE0PYOmP; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761545302; x=1793081302;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9aPOXXMZhxckm5IZ7JpMj9IGhEIB7o2FEzlDFbTBEoU=;
  b=bE0PYOmPqtxfVwZftVbF3jdcKZgpG2xRb14h0K12tQxXT7Cb/MBsCn3W
   84a7v/TmWbQd2Pp5Y7iWQslfN20MfTB7r3pHszYHreb/UtZtbUPotCOY4
   vg1DRbAdODHkMUR8XP2Slb6GbSfcbd4vxQWt5MSS9wtZevUjZxz2NRopt
   bbAxNEvOLpModeHsp+l1bd3T38kARRgd37IV0odYSvIOI86sNR/6KYELp
   AygbIWnF/1lpLh/5zHalF7FtDcYm02rftgiKNwXGdkV/SbXVrwYodHssj
   6VXHfevYuP910857MatG9LcUi5DrgfNb2FExLTfoa9h0+LgFavklm1AEQ
   Q==;
X-CSE-ConnectionGUID: UXQKxtG+T0mlXcCPzT+Xqg==
X-CSE-MsgGUID: x0Sq3I9fS1GuOGu96w63xw==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63524745"
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="63524745"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2025 23:08:22 -0700
X-CSE-ConnectionGUID: lhf6TAAkRSe+kOxDaTi8jA==
X-CSE-MsgGUID: IV3fH1M7RyWUH2aTni8zmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="184571603"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2025 23:08:18 -0700
Message-ID: <9d72b723-aeef-474c-8e46-3b8dc027774d@intel.com>
Date: Mon, 27 Oct 2025 14:08:13 +0800
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
 Dapeng Mi <dapeng1.mi@intel.com>, Zide Chen <zide.chen@intel.com>,
 Chenyi Qiang <chenyi.qiang@intel.com>, Farrah Chen <farrah.chen@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
 <20251024065632.1448606-4-zhao1.liu@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20251024065632.1448606-4-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/2025 2:56 PM, Zhao Liu wrote:
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

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   target/i386/cpu.c | 3 +--
>   target/i386/cpu.h | 8 ++++----
>   2 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index f0e179c2d235..b9a5a0400dea 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -2058,8 +2058,7 @@ ExtSaveArea x86_ext_save_areas[XSAVE_STATE_AREA_COUNT] = {
>       },
>       [XSTATE_ARCH_LBR_BIT] = {
>           .feature = FEAT_7_0_EDX, .bits = CPUID_7_0_EDX_ARCH_LBR,
> -        .offset = 0 /*supervisor mode component, offset = 0 */,
> -        .size = sizeof(XSavesArchLBR),
> +        .size = sizeof(XSaveArchLBR),
>       },
>       [XSTATE_XTILE_CFG_BIT] = {
>           .feature = FEAT_7_0_EDX, .bits = CPUID_7_0_EDX_AMX_TILE,
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index d0da9bfe58ce..886a941e481c 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -1747,15 +1747,15 @@ typedef struct {
>   
>   #define ARCH_LBR_NR_ENTRIES            32
>   
> -/* Ext. save area 19: Supervisor mode Arch LBR state */
> -typedef struct XSavesArchLBR {
> +/* Ext. save area 15: Arch LBR state */
> +typedef struct XSaveArchLBR {
>       uint64_t lbr_ctl;
>       uint64_t lbr_depth;
>       uint64_t ler_from;
>       uint64_t ler_to;
>       uint64_t ler_info;
>       LBREntry lbr_records[ARCH_LBR_NR_ENTRIES];
> -} XSavesArchLBR;
> +} XSaveArchLBR;
>   
>   QEMU_BUILD_BUG_ON(sizeof(XSaveAVX) != 0x100);
>   QEMU_BUILD_BUG_ON(sizeof(XSaveBNDREG) != 0x40);
> @@ -1766,7 +1766,7 @@ QEMU_BUILD_BUG_ON(sizeof(XSaveHi16_ZMM) != 0x400);
>   QEMU_BUILD_BUG_ON(sizeof(XSavePKRU) != 0x8);
>   QEMU_BUILD_BUG_ON(sizeof(XSaveXTILECFG) != 0x40);
>   QEMU_BUILD_BUG_ON(sizeof(XSaveXTILEDATA) != 0x2000);
> -QEMU_BUILD_BUG_ON(sizeof(XSavesArchLBR) != 0x328);
> +QEMU_BUILD_BUG_ON(sizeof(XSaveArchLBR) != 0x328);
>   
>   typedef struct ExtSaveArea {
>       uint32_t feature, bits;


