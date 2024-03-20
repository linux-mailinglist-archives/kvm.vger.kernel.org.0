Return-Path: <kvm+bounces-12320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D22C38816DD
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 18:55:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8FF66283341
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 17:55:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89D776A35E;
	Wed, 20 Mar 2024 17:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dUW/zcXM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA326A328
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 17:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710957339; cv=none; b=bVJ2OCpunf19D6LHhYYqVIxiJBKQUes3mYmp2KVMITUAx3HCVzGI9ILeAO1BjrrY+mmk2jKdQ9T6KTA64sku2mHoQnZjOk6QgvHd309/TnDC3rf721LUJpqOBW/OPFz5tgVKDRiFOwuasAf5zEW5waUYeaO+n+v+WbXxeBTPOOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710957339; c=relaxed/simple;
	bh=jMWF46sbhfs/k1gmIhnSS7Ujnub/iP1jOCKSSBybAsg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hkd2Grt5a3DpSByr8lRJELSK3kAIkcJdSB+U1C1jNzvkKqIYvLnEZi9PhFcVLN0uyq0zLJOQDMw6HsiBAWQHSKIYXTDc2TuPf7uL0AXJFkyv5uOmXqE1+nW0NgigQauGFB4qUODYgStyHUDaQlWGsLsfkPnZzfpQd5T7a8NkOo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dUW/zcXM; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710957337; x=1742493337;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jMWF46sbhfs/k1gmIhnSS7Ujnub/iP1jOCKSSBybAsg=;
  b=dUW/zcXM5g2qsugM38f30+4O74gyqMVBMErf+mw7MtWNemTzrFD+zRUM
   atynWB4QnhNLBrv5m+7YWslFpRYMpzsCA0U84100ubOPiXFurm0p4Gsyz
   nMNownOuOa6NE9Q2sMHV1OffkF/3QoZo6coKPFDNOFqbJ0pGiVVLPF2RJ
   omYP0seOOKzWRtPO9rgxoqhYO8+VueUTHjpHVgw9CdbjcuGN4rHMfpP+d
   8ekgjEkPMzYFXU6VbRGCgwnTnT1XeG0i9LurEZRvVWzgs49dW2oS+L7UD
   +aOOGRVkW0TCoDpIoSYd5bIOD6YKQX142LkCisW9td6fe/63MkzuViwiQ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11019"; a="5840931"
X-IronPort-AV: E=Sophos;i="6.07,140,1708416000"; 
   d="scan'208";a="5840931"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2024 10:55:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,140,1708416000"; 
   d="scan'208";a="14634905"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2024 10:55:37 -0700
Date: Wed, 20 Mar 2024 10:55:35 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Daniel P =?utf-8?B?LiBCZXJyYW5nw6k=?= <berrange@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Isaku Yamahata <isaku.yamahata@linux.intel.com>,
	Brijesh Singh <brijesh.singh@amd.com>, isaku.yamahata@intel.com
Subject: Re: [PATCH v3 40/49] hw/i386/sev: Add function to get SEV metadata
 from OVMF header
Message-ID: <20240320175535.GF1994522@ls.amr.corp.intel.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-41-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240320083945.991426-41-michael.roth@amd.com>

On Wed, Mar 20, 2024 at 03:39:36AM -0500,
Michael Roth <michael.roth@amd.com> wrote:

> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> A recent version of OVMF expanded the reset vector GUID list to add
> SEV-specific metadata GUID. The SEV metadata describes the reserved
> memory regions such as the secrets and CPUID page used during the SEV-SNP
> guest launch.
> 
> The pc_system_get_ovmf_sev_metadata_ptr() is used to retieve the SEV
> metadata pointer from the OVMF GUID list.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  hw/i386/pc_sysfw_ovmf.c | 33 +++++++++++++++++++++++++++++++++
>  include/hw/i386/pc.h    | 26 ++++++++++++++++++++++++++
>  2 files changed, 59 insertions(+)
> 
> diff --git a/hw/i386/pc_sysfw_ovmf.c b/hw/i386/pc_sysfw_ovmf.c
> index 07a4c267fa..32efa34614 100644
> --- a/hw/i386/pc_sysfw_ovmf.c
> +++ b/hw/i386/pc_sysfw_ovmf.c
> @@ -35,6 +35,31 @@ static const int bytes_after_table_footer = 32;
>  static bool ovmf_flash_parsed;
>  static uint8_t *ovmf_table;
>  static int ovmf_table_len;
> +static OvmfSevMetadata *ovmf_sev_metadata_table;
> +
> +#define OVMF_SEV_META_DATA_GUID "dc886566-984a-4798-A75e-5585a7bf67cc"
> +typedef struct __attribute__((__packed__)) OvmfSevMetadataOffset {
> +    uint32_t offset;
> +} OvmfSevMetadataOffset;
> +
> +static void pc_system_parse_sev_metadata(uint8_t *flash_ptr, size_t flash_size)
> +{
> +    OvmfSevMetadata     *metadata;
> +    OvmfSevMetadataOffset  *data;
> +
> +    if (!pc_system_ovmf_table_find(OVMF_SEV_META_DATA_GUID, (uint8_t **)&data,
> +                                   NULL)) {
> +        return;
> +    }
> +
> +    metadata = (OvmfSevMetadata *)(flash_ptr + flash_size - data->offset);
> +    if (memcmp(metadata->signature, "ASEV", 4) != 0) {
> +        return;
> +    }
> +
> +    ovmf_sev_metadata_table = g_malloc(metadata->len);
> +    memcpy(ovmf_sev_metadata_table, metadata, metadata->len);
> +}
>  
>  void pc_system_parse_ovmf_flash(uint8_t *flash_ptr, size_t flash_size)
>  {
> @@ -90,6 +115,9 @@ void pc_system_parse_ovmf_flash(uint8_t *flash_ptr, size_t flash_size)
>       */
>      memcpy(ovmf_table, ptr - tot_len, tot_len);
>      ovmf_table += tot_len;
> +
> +    /* Copy the SEV metadata table (if exist) */
> +    pc_system_parse_sev_metadata(flash_ptr, flash_size);
>  }

Can we move this call to x86_firmware_configure() @ pc_sysfw.c, and move sev
specific bits to somewhere to sev specific file?  We don't have to parse sev
metadata for non-SEV case, right?

We don't have to touch common ovmf file. It also will be consistent with tdx
case.  TDX patch series adds tdx_parse_tdvf() to x86_firmware_configure().

thanks,

>  
>  /**
> @@ -159,3 +187,8 @@ bool pc_system_ovmf_table_find(const char *entry, uint8_t **data,
>      }
>      return false;
>  }
> +
> +OvmfSevMetadata *pc_system_get_ovmf_sev_metadata_ptr(void)
> +{
> +    return ovmf_sev_metadata_table;
> +}
> diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
> index fb1d4106e5..df9a61540d 100644
> --- a/include/hw/i386/pc.h
> +++ b/include/hw/i386/pc.h
> @@ -163,6 +163,32 @@ void pc_acpi_smi_interrupt(void *opaque, int irq, int level);
>  #define PCI_HOST_ABOVE_4G_MEM_SIZE     "above-4g-mem-size"
>  #define PCI_HOST_PROP_SMM_RANGES       "smm-ranges"
>  
> +typedef enum {
> +    SEV_DESC_TYPE_UNDEF,
> +    /* The section contains the region that must be validated by the VMM. */
> +    SEV_DESC_TYPE_SNP_SEC_MEM,
> +    /* The section contains the SNP secrets page */
> +    SEV_DESC_TYPE_SNP_SECRETS,
> +    /* The section contains address that can be used as a CPUID page */
> +    SEV_DESC_TYPE_CPUID,
> +
> +} ovmf_sev_metadata_desc_type;
> +
> +typedef struct __attribute__((__packed__)) OvmfSevMetadataDesc {
> +    uint32_t base;
> +    uint32_t len;
> +    ovmf_sev_metadata_desc_type type;
> +} OvmfSevMetadataDesc;
> +
> +typedef struct __attribute__((__packed__)) OvmfSevMetadata {
> +    uint8_t signature[4];
> +    uint32_t len;
> +    uint32_t version;
> +    uint32_t num_desc;
> +    OvmfSevMetadataDesc descs[];
> +} OvmfSevMetadata;
> +
> +OvmfSevMetadata *pc_system_get_ovmf_sev_metadata_ptr(void);
>  
>  void pc_pci_as_mapping_init(MemoryRegion *system_memory,
>                              MemoryRegion *pci_address_space);
> -- 
> 2.25.1
> 
> 

-- 
Isaku Yamahata <isaku.yamahata@intel.com>

