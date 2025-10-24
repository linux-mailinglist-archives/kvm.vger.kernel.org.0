Return-Path: <kvm+bounces-61046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id CC868C07B72
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 20:21:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8ED854F7F6B
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 18:21:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 060FA348465;
	Fri, 24 Oct 2025 18:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I7RF7d/Y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6A5262FCB
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 18:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761330058; cv=none; b=STgbYj+ucK2KNjqim86yyM5KmF+svbUGIl0Jif4fXOefBwUz3M96p1uW0mtfwdfF55f+Eem/BiKstMC++O+O5CbpWnKaVkwtZrs+h5mKChvOgjDHZuWrH+m32zf9O8ufnBW1k1aGiFacc4FyCERA2zlyzBOaboFTnVNOnV9SP8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761330058; c=relaxed/simple;
	bh=dsTKYI2tavi9iR5GYwHm3XNJQdogM73BnjgCufX5w34=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nNyY5gIaBQzUDFGVs4kVjIWs+gMjT4BYFfsZWQr5IskbDDP0XVIQGZetmrLJbyClK8RfstxCCggxQkDwh9cgpUgsZxr0z1fIAwkIz+FGyLEswoPGnu3mIlaSKgwDwBsaIsXPrqPm3gOCR6vbPL1ZwUDC1qepznBpFqz/iaJdofo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I7RF7d/Y; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761330056; x=1792866056;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dsTKYI2tavi9iR5GYwHm3XNJQdogM73BnjgCufX5w34=;
  b=I7RF7d/Yx9x3wmr1XXeRTOdGC8pi275wruVOCB0WWm7MNiMNhZGSrbKb
   P78x0eImL4TWU0NU8qMHVJ4a6mAFFEjgn+uqPZQvx3TcTwI+jTyiT+Xnv
   yILr50+zVm0IUlbFClzhlSqzsbVSE7be7PbYKw6iPVPGt0TCGZL5M8CX1
   JbOAKJHpRekZ15a/f+2CqXi2wlKwpmuP6JFAz0oJm7MwXh9hw5GfCU9ae
   TxARZAWXNw81OUrKg+QGVMIDcgJJlDL8Ek272YNNLzsyFRUNpd/loWI7C
   baVNeP5dGagpV2rBxQ5pj2K4+jCGmb5Z1dRnOqoeHu/8Ppo0bxdNg//yU
   g==;
X-CSE-ConnectionGUID: ZcJNhcwIRf6YKmc2AC4pdA==
X-CSE-MsgGUID: jqVr0QihSnWb/GIV9VvRvQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63550955"
X-IronPort-AV: E=Sophos;i="6.19,253,1754982000"; 
   d="scan'208";a="63550955"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2025 11:20:56 -0700
X-CSE-ConnectionGUID: Sfbz+b2xRfOOmIF5BmsdkQ==
X-CSE-MsgGUID: /Hv5XVoGRCOJkJC5vJnBAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,253,1754982000"; 
   d="scan'208";a="188882449"
Received: from soc-cp83kr3.clients.intel.com (HELO [10.241.241.181]) ([10.241.241.181])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2025 11:20:55 -0700
Message-ID: <1bcebd76-877e-41eb-a21e-5a49c648fd37@intel.com>
Date: Fri, 24 Oct 2025 11:20:54 -0700
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
 Dapeng Mi <dapeng1.mi@intel.com>, Chenyi Qiang <chenyi.qiang@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, Farrah Chen <farrah.chen@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
 <20251024065632.1448606-5-zhao1.liu@intel.com>
Content-Language: en-US
From: "Chen, Zide" <zide.chen@intel.com>
In-Reply-To: <20251024065632.1448606-5-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/23/2025 11:56 PM, Zhao Liu wrote:
> - Move ARCH_LBR_NR_ENTRIES macro and LBREntry definition before XSAVE
>   areas definitions.
> - Reorder XSavesArchLBR (area 15) between XSavePKRU (area 9) and
>   XSaveXTILECFG (area 17), and reorder the related QEMU_BUILD_BUG_ON
>   check to keep the same ordering.
> 
> This makes xsave structures to be organized together and makes them
> clearer.
> 
> Tested-by: Farrah Chen <farrah.chen@intel.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

Reviewed-by: Zide Chen <zide.chen@intel.com>

> ---
>  target/i386/cpu.h | 38 +++++++++++++++++++-------------------
>  1 file changed, 19 insertions(+), 19 deletions(-)
> 
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 886a941e481c..ac527971d8cd 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -1652,6 +1652,14 @@ typedef struct {
>  
>  #define NB_OPMASK_REGS 8
>  
> +typedef struct {
> +    uint64_t from;
> +    uint64_t to;
> +    uint64_t info;
> +} LBREntry;
> +
> +#define ARCH_LBR_NR_ENTRIES 32
> +
>  /* CPU can't have 0xFFFFFFFF APIC ID, use that value to distinguish
>   * that APIC ID hasn't been set yet
>   */
> @@ -1729,24 +1737,6 @@ typedef struct XSavePKRU {
>      uint32_t padding;
>  } XSavePKRU;
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
>  /* Ext. save area 15: Arch LBR state */
>  typedef struct XSaveArchLBR {
>      uint64_t lbr_ctl;
> @@ -1757,6 +1747,16 @@ typedef struct XSaveArchLBR {
>      LBREntry lbr_records[ARCH_LBR_NR_ENTRIES];
>  } XSaveArchLBR;
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
>  QEMU_BUILD_BUG_ON(sizeof(XSaveAVX) != 0x100);
>  QEMU_BUILD_BUG_ON(sizeof(XSaveBNDREG) != 0x40);
>  QEMU_BUILD_BUG_ON(sizeof(XSaveBNDCSR) != 0x40);
> @@ -1764,9 +1764,9 @@ QEMU_BUILD_BUG_ON(sizeof(XSaveOpmask) != 0x40);
>  QEMU_BUILD_BUG_ON(sizeof(XSaveZMM_Hi256) != 0x200);
>  QEMU_BUILD_BUG_ON(sizeof(XSaveHi16_ZMM) != 0x400);
>  QEMU_BUILD_BUG_ON(sizeof(XSavePKRU) != 0x8);
> +QEMU_BUILD_BUG_ON(sizeof(XSaveArchLBR) != 0x328);
>  QEMU_BUILD_BUG_ON(sizeof(XSaveXTILECFG) != 0x40);
>  QEMU_BUILD_BUG_ON(sizeof(XSaveXTILEDATA) != 0x2000);
> -QEMU_BUILD_BUG_ON(sizeof(XSaveArchLBR) != 0x328);
>  
>  typedef struct ExtSaveArea {
>      uint32_t feature, bits;


