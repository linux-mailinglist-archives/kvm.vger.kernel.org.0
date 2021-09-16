Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69A7040E73B
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 19:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242566AbhIPRa5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 13:30:57 -0400
Received: from mail.skyhub.de ([5.9.137.197]:42316 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352754AbhIPR1j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Sep 2021 13:27:39 -0400
Received: from zn.tnic (p200300ec2f11c6001e49ea6afe1054f5.dip0.t-ipconnect.de [IPv6:2003:ec:2f11:c600:1e49:ea6a:fe10:54f5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5ED201EC01DF;
        Thu, 16 Sep 2021 19:26:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1631813168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=oOtmNTM2jr/g9JVg0OexwbFg2/pG+8cff5fWd4oubyk=;
        b=HA43ImuGZC1WGrvAhfNdFt6SUtTLcSGWTR/UJVK0nwQVPxc+EN+ytuygjgJvsDLf/v619f
        /mdq87L35kG6yS8syIKPfSYSI0oP8iaQEgeOJlWiTRfBbdN6rLm+JNU+WDuyQBUs5a0bmU
        GfQ50AjWPdgVTca2lYAIWjSFmICdB2A=
Date:   Thu, 16 Sep 2021 19:26:07 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 02/45] iommu/amd: Introduce function to check
 SEV-SNP support
Message-ID: <YUN+L0dlFMbC3bd4@zn.tnic>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-3-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210820155918.7518-3-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 20, 2021 at 10:58:35AM -0500, Brijesh Singh wrote:
> The SEV-SNP support requires that IOMMU must to enabled, see the IOMMU

s/must to/is/

> spec section 2.12 for further details. If IOMMU is not enabled or the
> SNPSup extended feature register is not set then the SNP_INIT command
> (used for initializing firmware) will fail.
> 
> The iommu_sev_snp_supported() can be used to check if IOMMU supports the

"can be used"?

Just say what is going to use it.

> SEV-SNP feature.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  drivers/iommu/amd/init.c | 30 ++++++++++++++++++++++++++++++
>  include/linux/iommu.h    |  9 +++++++++
>  2 files changed, 39 insertions(+)
> 
> diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
> index 46280e6e1535..bd420fb71126 100644
> --- a/drivers/iommu/amd/init.c
> +++ b/drivers/iommu/amd/init.c
> @@ -3320,3 +3320,33 @@ int amd_iommu_pc_set_reg(struct amd_iommu *iommu, u8 bank, u8 cntr, u8 fxn, u64
>  
>  	return iommu_pc_get_set_reg(iommu, bank, cntr, fxn, value, true);
>  }
> +
> +bool iommu_sev_snp_supported(void)
> +{
> +	struct amd_iommu *iommu;
> +
> +	/*
> +	 * The SEV-SNP support requires that IOMMU must be enabled, and is
> +	 * not configured in the passthrough mode.
> +	 */
> +	if (no_iommu || iommu_default_passthrough()) {
> +		pr_err("SEV-SNP: IOMMU is either disabled or configured in passthrough mode.\n");
> +		return false;
> +	}
> +
> +	/*
> +	 * Iterate through all the IOMMUs and verify the SNPSup feature is
> +	 * enabled.
> +	 */
> +	for_each_iommu(iommu) {
> +		if (!iommu_feature(iommu, FEATURE_SNP)) {
> +			pr_err("SNPSup is disabled (devid: %02x:%02x.%x)\n",
> +			       PCI_BUS_NUM(iommu->devid), PCI_SLOT(iommu->devid),
> +			       PCI_FUNC(iommu->devid));
> +			return false;
> +		}
> +	}
> +
> +	return true;
> +}
> +EXPORT_SYMBOL_GPL(iommu_sev_snp_supported);

That export is not needed.

> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 32d448050bf7..269abc17b2c3 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -604,6 +604,12 @@ struct iommu_sva *iommu_sva_bind_device(struct device *dev,
>  void iommu_sva_unbind_device(struct iommu_sva *handle);
>  u32 iommu_sva_get_pasid(struct iommu_sva *handle);
>  
> +#ifdef CONFIG_AMD_MEM_ENCRYPT
> +bool iommu_sev_snp_supported(void);
> +#else
> +static inline bool iommu_sev_snp_supported(void) { return false; }
> +#endif
> +
>  #else /* CONFIG_IOMMU_API */
>  
>  struct iommu_ops {};
> @@ -999,6 +1005,9 @@ static inline struct iommu_fwspec *dev_iommu_fwspec_get(struct device *dev)
>  {
>  	return NULL;
>  }
> +
> +static inline bool iommu_sev_snp_supported(void) { return false; }
> +

Most of those stubs and ifdeffery is not needed if you put the function
itself in

#ifdef CONFIG_AMD_MEM_ENCRYPT

...

#endif

as it is called by sev.c only, AFAICT, and latter is enabled by
CONFIG_AMD_MEM_ENCRYPT anyway.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
