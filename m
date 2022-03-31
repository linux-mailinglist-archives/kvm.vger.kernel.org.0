Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2504ED144
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 03:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244637AbiCaBXG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 21:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352304AbiCaBXA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 21:23:00 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA5F62E699;
        Wed, 30 Mar 2022 18:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648689671; x=1680225671;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QKRTWdiGnee9ZO7InXWkfsawt1zuvqAXyHGl5Xwe2fQ=;
  b=d+MR2P5iypt3c/qA4QMTTAC4fDdax4HA03D0hi7/4eoKgmhSzwnDy9Ry
   SuOCro5k0GlxtB6neNdAWvwjJmVkD2bmd54wW2PqRLDrCDYoAdIUpYp6g
   dBgPe3BOihMpQHWI8uX2kWuSlDqLvyuyXwFx/N+hRL7V4LBHqSTePhqYH
   V37C5imvcDRsH2uThnEixa92Ka1cm6upEp6tKkm/24J/+01c0nN5/T1Eo
   M0vYfWHqhGk8QaG0sghwAvwxW5xsZ0yaYX2cXBDbk6rcTOcWWBfNPVabe
   tvjbe070Knr/C+dtF8b2JamvnhJ/gwJTXDUMdjiuBVG7rJlT2DtMmBR9q
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10302"; a="257265196"
X-IronPort-AV: E=Sophos;i="5.90,224,1643702400"; 
   d="scan'208";a="257265196"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2022 18:21:11 -0700
X-IronPort-AV: E=Sophos;i="5.90,224,1643702400"; 
   d="scan'208";a="654268188"
Received: from dhathawa-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.53.226])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2022 18:21:08 -0700
Message-ID: <2386151bc0a42b2eda895d85b459bf7930306694.camel@intel.com>
Subject: Re: [RFC PATCH v5 023/104] x86/cpu: Add helper functions to
 allocate/free MKTME keyid
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Thu, 31 Mar 2022 14:21:06 +1300
In-Reply-To: <a1d1e4f26c6ef44a557e873be2818e6a03e12038.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
         <a1d1e4f26c6ef44a557e873be2818e6a03e12038.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-03-04 at 11:48 -0800, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> MKTME keyid is assigned to guest TD.  The memory controller encrypts guest
> TD memory with key id.  Add helper functions to allocate/free MKTME keyid
> so that TDX KVM assign keyid.

Using MKTME keyid is wrong, at least not accurate I think.  We should use
explicitly use "TDX private KeyID", which is clearly documented in the spec:
  
https://software.intel.com/content/dam/develop/external/us/en/documents-tps/intel-tdx-cpu-architectural-specification.pdf

Also, description of IA32_MKTME_KEYID_PARTITIONING MSR clearly says TDX private
KeyIDs span the range (NUM_MKTME_KIDS+1) through
(NUM_MKTME_KIDS+NUM_TDX_PRIV_KIDS).  So please just use TDX private KeyID here.


> 
> Also export MKTME global keyid that is used to encrypt TDX module and its
> memory.

This needs explanation why the global keyID needs to be exported.

> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/asm/tdx.h |  6 ++++++
>  arch/x86/virt/vmx/tdx.c    | 33 ++++++++++++++++++++++++++++++++-
>  2 files changed, 38 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index 9a8dc6afcb63..73bb472bd515 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -139,6 +139,9 @@ int tdx_detect(void);
>  int tdx_init(void);
>  bool platform_has_tdx(void);
>  const struct tdsysinfo_struct *tdx_get_sysinfo(void);
> +u32 tdx_get_global_keyid(void);
> +int tdx_keyid_alloc(void);
> +void tdx_keyid_free(int keyid);
>  #else
>  static inline void tdx_detect_cpu(struct cpuinfo_x86 *c) { }
>  static inline int tdx_detect(void) { return -ENODEV; }
> @@ -146,6 +149,9 @@ static inline int tdx_init(void) { return -ENODEV; }
>  static inline bool platform_has_tdx(void) { return false; }
>  struct tdsysinfo_struct;
>  static inline const struct tdsysinfo_struct *tdx_get_sysinfo(void) { return NULL; }
> +static inline u32 tdx_get_global_keyid(void) { return 0; };
> +static inline int tdx_keyid_alloc(void) { return -EOPNOTSUPP; }
> +static inline void tdx_keyid_free(int keyid) { }
>  #endif /* CONFIG_INTEL_TDX_HOST */
>  
>  #endif /* !__ASSEMBLY__ */
> diff --git a/arch/x86/virt/vmx/tdx.c b/arch/x86/virt/vmx/tdx.c
> index e45f188479cb..d714106321d4 100644
> --- a/arch/x86/virt/vmx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx.c
> @@ -113,7 +113,13 @@ static int tdx_cmr_num;
>  static struct tdsysinfo_struct tdx_sysinfo;
>  
>  /* TDX global KeyID to protect TDX metadata */
> -static u32 tdx_global_keyid;
> +static u32 __read_mostly tdx_global_keyid;
> +
> +u32 tdx_get_global_keyid(void)
> +{
> +	return tdx_global_keyid;
> +}
> +EXPORT_SYMBOL_GPL(tdx_get_global_keyid);
>  
>  static bool enable_tdx_host;
>  
> @@ -189,6 +195,31 @@ static void detect_seam(struct cpuinfo_x86 *c)
>  		detect_seam_ap(c);
>  }
>  
> +/* TDX KeyID pool */
> +static DEFINE_IDA(tdx_keyid_pool);
> +
> +int tdx_keyid_alloc(void)
> +{
> +	if (WARN_ON_ONCE(!tdx_keyid_start || !tdx_keyid_num))
> +		return -EINVAL;
> +
> +	/* The first keyID is reserved for the global key. */
> +	return ida_alloc_range(&tdx_keyid_pool, tdx_keyid_start + 1,
> +			       tdx_keyid_start + tdx_keyid_num - 1,
> +			       GFP_KERNEL);
> +}
> +EXPORT_SYMBOL_GPL(tdx_keyid_alloc);
> +
> +void tdx_keyid_free(int keyid)
> +{
> +	/* keyid = 0 is reserved. */
> +	if (!keyid || keyid <= 0)
> +		return;
> +
> +	ida_free(&tdx_keyid_pool, keyid);
> +}
> +EXPORT_SYMBOL_GPL(tdx_keyid_free);
> +
>  static void detect_tdx_keyids_bsp(struct cpuinfo_x86 *c)
>  {
>  	u64 keyid_part;

