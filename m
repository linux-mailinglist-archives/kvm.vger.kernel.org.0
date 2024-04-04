Return-Path: <kvm+bounces-13614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FE7A89906D
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 23:32:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 811031C2241F
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 21:32:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F5A513BC2A;
	Thu,  4 Apr 2024 21:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j9aGbkh5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72304745C2;
	Thu,  4 Apr 2024 21:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712266345; cv=none; b=p2CsPDPEQu0KmlVli4rr29Uz8RwkKgvbIEXvjwwzUpVufDt6ZuKylVoNgYcAYioeVETr+e3C7V5OJm4A5ziWOnDjL92fLcRQOisR0OcXS0VC/YMmLPLq5WDiac4XudNGCDO3QDgQRvHVvl5mPpI5oML9CroyEa6AMFzPJworUR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712266345; c=relaxed/simple;
	bh=PU3GpUgP7mgOH2EprnKYNebl4zKTrGXpc9EyLYKCIsU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nr7QnZkfqgHbK5yLwM8PixyJdR2CG6vojRNej+8lLsHZ87XqijXq7W8xLptufe1LNhBqMh89ESZFgzphvPTVUbylg3bLeo86IaFd8jZZdR7kDrrYRH2mcLTvTubJDj8OasBikEfRFWaaE8XOWFISWKqTtitdWIkC01C6y6dGVSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j9aGbkh5; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712266343; x=1743802343;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PU3GpUgP7mgOH2EprnKYNebl4zKTrGXpc9EyLYKCIsU=;
  b=j9aGbkh5RMv/VDyP7dn7//NLj5U4M01qi+PKzKrDq4vWpqbNQ2FrxUjS
   BgJ8BMaFKA4bhmq8cjDUubhLY7rqpSyZxp5CQ4eWeLg7t7Srs5h5iSRSU
   XEPXo+DXenQHEL7eauX6RFBVblC9/MhORELmCcXczQOiBnJRpVHcBx1vC
   eLesPmcVxm4AoQllHgeDQC8lhK4VXEnIqy7olPjtsyFkwlx9m5XZ8pDMs
   LKxVyQ5vcmekoJjqZxRNbsz67tjKk7kiMOKkrPIEC0hFEqX94iDl/teuU
   8Hfm6ItyTC6i1DDGGyeQxhE481FL2mcctvxY0kwKOntVM72tga7iXUEi1
   Q==;
X-CSE-ConnectionGUID: vNgdXWkNTvCNUMAH+a+kDg==
X-CSE-MsgGUID: G56XEN9vS+a0md6Xn+c/BQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11034"; a="7428854"
X-IronPort-AV: E=Sophos;i="6.07,180,1708416000"; 
   d="scan'208";a="7428854"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2024 14:32:23 -0700
X-CSE-ConnectionGUID: ArXsv8dST3KRbjBJ6jxefg==
X-CSE-MsgGUID: ojxRxX46SRyJfkFW8wCryQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,180,1708416000"; 
   d="scan'208";a="19520238"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2024 14:32:23 -0700
Date: Thu, 4 Apr 2024 14:32:22 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, michael.roth@amd.com,
	isaku.yamahata@intel.com, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v5 05/17] KVM: SEV: publish supported VMSA features
Message-ID: <20240404213222.GR2444378@ls.amr.corp.intel.com>
References: <20240404121327.3107131-1-pbonzini@redhat.com>
 <20240404121327.3107131-6-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240404121327.3107131-6-pbonzini@redhat.com>

On Thu, Apr 04, 2024 at 08:13:15AM -0400,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> Compute the set of features to be stored in the VMSA when KVM is
> initialized; move it from there into kvm_sev_info when SEV is initialized,
> and then into the initial VMSA.
> 
> The new variable can then be used to return the set of supported features
> to userspace, via the KVM_GET_DEVICE_ATTR ioctl.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  .../virt/kvm/x86/amd-memory-encryption.rst    | 12 ++++++++++
>  arch/x86/include/uapi/asm/kvm.h               |  9 +++++--
>  arch/x86/kvm/svm/sev.c                        | 24 +++++++++++++++++--
>  arch/x86/kvm/svm/svm.c                        |  1 +
>  arch/x86/kvm/svm/svm.h                        |  2 ++
>  5 files changed, 44 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> index 84335d119ff1..2ea648e4c97a 100644
> --- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> @@ -425,6 +425,18 @@ issued by the hypervisor to make the guest ready for execution.
>  
>  Returns: 0 on success, -negative on error
>  
> +Device attribute API
> +====================
> +
> +Attributes of the SEV implementation can be retrieved through the
> +``KVM_HAS_DEVICE_ATTR`` and ``KVM_GET_DEVICE_ATTR`` ioctls on the ``/dev/kvm``
> +device node, using group ``KVM_X86_GRP_SEV``.
> +
> +Currently only one attribute is implemented:
> +
> +* ``KVM_X86_SEV_VMSA_FEATURES``: return the set of all bits that
> +  are accepted in the ``vmsa_features`` of ``KVM_SEV_INIT2``.
> +
>  Firmware Management
>  ===================
>  
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index ef11aa4cab42..b7dc515f4c27 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -457,8 +457,13 @@ struct kvm_sync_regs {
>  
>  #define KVM_STATE_VMX_PREEMPTION_TIMER_DEADLINE	0x00000001
>  
> -/* attributes for system fd (group 0) */
> -#define KVM_X86_XCOMP_GUEST_SUPP	0
> +/* vendor-independent attributes for system fd (group 0) */
> +#define KVM_X86_GRP_SYSTEM		0
> +#  define KVM_X86_XCOMP_GUEST_SUPP	0
> +
> +/* vendor-specific groups and attributes for system fd */
> +#define KVM_X86_GRP_SEV			1
> +#  define KVM_X86_SEV_VMSA_FEATURES	0
>  
>  struct kvm_vmx_nested_state_data {
>  	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];

Thank you for updating those.  Only for constat and document part.
Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

