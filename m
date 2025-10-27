Return-Path: <kvm+bounces-61133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C113DC0BF07
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 07:22:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2D4F04ECE59
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 06:22:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B2AE2DA771;
	Mon, 27 Oct 2025 06:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="alaPxMRE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58D5190685
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 06:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761546149; cv=none; b=kcpe3RTfA5Kq0PyzblI2/hQR4wk5EzuH/qysTUUA9KBwpuqPMfIkOFsYLbmqVN3uB1EgCxqh9P2pLCu6rbynj2omoxwXVGhw7WrWe08L4M//LIykoSd/wP8GNcOOyvYM9k9eWS+PJjArpj7Y4YEX5ZPt/3F6v1nBeP7O6nGa85Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761546149; c=relaxed/simple;
	bh=3VPzMuspd46+dnLbU6SilaPw+leRh3PT5Rh5N1rdaCw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DVd820SZCHudUuVPfV9+p4pwtSrniI6jpb+52dzmYGZNIgQF34NizoQW2dfFXusZfCFlME8i2riFCRiwBGaqYwJaG/v4ougqD5b63/48frvXDBPzcNJ7qupsDX2H9wuR1xJjtVasvg1xmx0+nDU93pe80w82YiAG+3w5mIYuSdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=alaPxMRE; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761546148; x=1793082148;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3VPzMuspd46+dnLbU6SilaPw+leRh3PT5Rh5N1rdaCw=;
  b=alaPxMRErMNVY0Pq25CAc1x7A+j3xT540buJg6kFOdUzaAib8J6HGV6s
   O87tuAC2aN/r0cuv8bkO4nw9i3JjfmsXMaAgEWyubANeVGrwTuVHslDex
   LoYJSa9DNca1wt956avWn02DvMRKanXK3WunpVa3lXhfmujawl7z4IFO3
   7egwrf5Vz95ala0+J42xOJvSPLeY9Pm1xthbSj6XcFE8xXontw6iUNg9r
   8bzUCnI2kUmgC0a2S2MHXVmRYa5pDiBJ9fKb2X9G11lRZVfoXEtvnNkeK
   2r/ozYLxH1Whf4gZbg/t5i0aWe0NvKPorXJi9B3Bcyq65kABZNVMhf+qO
   A==;
X-CSE-ConnectionGUID: LzJFL3hhQXit0+8FBTS1Dg==
X-CSE-MsgGUID: jzoL4AxLTMqfHIuc69iQAA==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="67485378"
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="67485378"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2025 23:22:27 -0700
X-CSE-ConnectionGUID: HTMaOrlySYKo/mgmPvXoVA==
X-CSE-MsgGUID: eS2q2BmTRXm5qdnGEverYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="184576018"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2025 23:22:23 -0700
Message-ID: <dcb87f98-bacd-4c57-9250-5122329ec400@intel.com>
Date: Mon, 27 Oct 2025 14:22:20 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/20] i386/cpu: Reorganize arch lbr structure
 definitions
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, Chao Gao
 <chao.gao@intel.com>, John Allen <john.allen@amd.com>,
 Babu Moger <babu.moger@amd.com>, Mathias Krause <minipli@grsecurity.net>,
 Dapeng Mi <dapeng1.mi@intel.com>, Zide Chen <zide.chen@intel.com>,
 Chenyi Qiang <chenyi.qiang@intel.com>, Farrah Chen <farrah.chen@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
 <20251024065632.1448606-5-zhao1.liu@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20251024065632.1448606-5-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/2025 2:56 PM, Zhao Liu wrote:
> - Move ARCH_LBR_NR_ENTRIES macro and LBREntry definition before XSAVE
>    areas definitions.

personally, I prefer not moving them. Putting them together is friendly 
and convenient when reading the code rather than bouncing through 
different parts.

But considering the existing cases of BNDReg and BNDCSReg, I'm fine with 
the movement.

> - Reorder XSavesArchLBR (area 15) between XSavePKRU (area 9) and
>    XSaveXTILECFG (area 17), and reorder the related QEMU_BUILD_BUG_ON
>    check to keep the same ordering.

This reorder is good.

> This makes xsave structures to be organized together and makes them
> clearer.
> 
> Tested-by: Farrah Chen <farrah.chen@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   target/i386/cpu.h | 38 +++++++++++++++++++-------------------
>   1 file changed, 19 insertions(+), 19 deletions(-)
> 
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 886a941e481c..ac527971d8cd 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -1652,6 +1652,14 @@ typedef struct {
>   
>   #define NB_OPMASK_REGS 8
>   
> +typedef struct {
> +    uint64_t from;
> +    uint64_t to;
> +    uint64_t info;
> +} LBREntry;
> +
> +#define ARCH_LBR_NR_ENTRIES 32
> +
>   /* CPU can't have 0xFFFFFFFF APIC ID, use that value to distinguish
>    * that APIC ID hasn't been set yet
>    */
> @@ -1729,24 +1737,6 @@ typedef struct XSavePKRU {
>       uint32_t padding;
>   } XSavePKRU;
>   
> -/* Ext. save area 17: AMX XTILECFG state */
> -typedef struct XSaveXTILECFG {
> -    uint8_t xtilecfg[64];
> -} XSaveXTILECFG;
> -
> -/* Ext. save area 18: AMX XTILEDATA state */
> -typedef struct XSaveXTILEDATA {
> -    uint8_t xtiledata[8][1024];
> -} XSaveXTILEDATA;
> -
> -typedef struct {
> -       uint64_t from;
> -       uint64_t to;
> -       uint64_t info;
> -} LBREntry;
> -
> -#define ARCH_LBR_NR_ENTRIES            32
> -
>   /* Ext. save area 15: Arch LBR state */
>   typedef struct XSaveArchLBR {
>       uint64_t lbr_ctl;
> @@ -1757,6 +1747,16 @@ typedef struct XSaveArchLBR {
>       LBREntry lbr_records[ARCH_LBR_NR_ENTRIES];
>   } XSaveArchLBR;
>   
> +/* Ext. save area 17: AMX XTILECFG state */
> +typedef struct XSaveXTILECFG {
> +    uint8_t xtilecfg[64];
> +} XSaveXTILECFG;
> +
> +/* Ext. save area 18: AMX XTILEDATA state */
> +typedef struct XSaveXTILEDATA {
> +    uint8_t xtiledata[8][1024];
> +} XSaveXTILEDATA;
> +
>   QEMU_BUILD_BUG_ON(sizeof(XSaveAVX) != 0x100);
>   QEMU_BUILD_BUG_ON(sizeof(XSaveBNDREG) != 0x40);
>   QEMU_BUILD_BUG_ON(sizeof(XSaveBNDCSR) != 0x40);
> @@ -1764,9 +1764,9 @@ QEMU_BUILD_BUG_ON(sizeof(XSaveOpmask) != 0x40);
>   QEMU_BUILD_BUG_ON(sizeof(XSaveZMM_Hi256) != 0x200);
>   QEMU_BUILD_BUG_ON(sizeof(XSaveHi16_ZMM) != 0x400);
>   QEMU_BUILD_BUG_ON(sizeof(XSavePKRU) != 0x8);
> +QEMU_BUILD_BUG_ON(sizeof(XSaveArchLBR) != 0x328);
>   QEMU_BUILD_BUG_ON(sizeof(XSaveXTILECFG) != 0x40);
>   QEMU_BUILD_BUG_ON(sizeof(XSaveXTILEDATA) != 0x2000);
> -QEMU_BUILD_BUG_ON(sizeof(XSaveArchLBR) != 0x328);
>   
>   typedef struct ExtSaveArea {
>       uint32_t feature, bits;


