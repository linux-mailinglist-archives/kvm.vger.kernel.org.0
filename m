Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67DE34E67FB
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 18:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352371AbiCXRol (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 13:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234980AbiCXRok (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 13:44:40 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C5E558A;
        Thu, 24 Mar 2022 10:43:04 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id bx5so5317684pjb.3;
        Thu, 24 Mar 2022 10:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zHd8+qZy0Smvo9FxO0fgz17ixhYpOTzGIpc3wIWBa2o=;
        b=FYkppDS8i2JwD+JdvoQalwMerA/ICFYO2KHSkBKMchinxiGaw3GF7Wetmyb6L8kEdH
         RjeEQH/lchWxupG2z2obEktgefDjQIfmQOIWhYgy6oFuxLYo2ri+3ZUgEPRSXfomIFDW
         vOc6N747yx61peaC5ZEIZjIX975rgzyHCT5/NNSw/i/M7z4REFwE6C/nIxHtXKfhlTN1
         4KJtMMkudIV5mUd9GDzLeNvb644QdGIpQ1f6vQqKU1fGQVQ6L0U3QXGUtN1T0tZ89JCj
         6haiQc43FoEvpACZpehjhNHK/2MaE+1gfHzNt1SP3bv1f47u/3IOf9+n1Zz3tc2w5RS6
         wDfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zHd8+qZy0Smvo9FxO0fgz17ixhYpOTzGIpc3wIWBa2o=;
        b=3qfqeNE1zZVIB8UN/o9BEAN39i4kWqQFGPWFxy3X/1qUR5WzDckoCXskZalYMgetE8
         h+a6WEfTnWQ/v61QczHrBBv7mR+rZrMC25nhQyhDpagmwBhRr9YospJkFmuQ6Fn1p7yO
         vCoKA8OjND25pB3gFHoqb3J3lBF8dpaYdVwEj8HkrHx8Hp6YlooZ0Q0kEs7lqSQ7aAnE
         fo6R/pTGVG87v2AZqp+IV37/a0JfV0YxJPsZfSnzRb6MRCxb9vANjacQFqoWFm5RYfSB
         8pAuuHD+c+bFjumpAzy4s7Vd83CjPqxhSEst4B/i7DcFoJ6muL5Gho0MCfG/IAlKbR0k
         Vu/A==
X-Gm-Message-State: AOAM531G4ere6WrratWvNNn8MwA8PXPFowGK1RRGX7Ln85HmiQ338AfI
        hWK9chWzN8NUr60vTd/S0V8=
X-Google-Smtp-Source: ABdhPJxLCbwT/8lqNJOyH96LoummnFx4qlj5+HN3JvbH/EeAaY5X0Ovy+/+3GRd7EE9WroN3WzkQ2g==
X-Received: by 2002:a17:90b:4f4d:b0:1c7:5324:c6a0 with SMTP id pj13-20020a17090b4f4d00b001c75324c6a0mr19858154pjb.160.1648143783701;
        Thu, 24 Mar 2022 10:43:03 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id q9-20020a056a00088900b004e03b051040sm4640239pfj.112.2022.03.24.10.43.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 10:43:02 -0700 (PDT)
Date:   Thu, 24 Mar 2022 10:43:01 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dave.hansen@intel.com, seanjc@google.com, pbonzini@redhat.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, peterz@infradead.org,
        tony.luck@intel.com, ak@linux.intel.com, dan.j.williams@intel.com,
        isaku.yamahata@intel.com, isaku.yamahata@gmail.com
Subject: Re: [PATCH v2 09/21] x86/virt/tdx: Get information about TDX module
 and convertible memory
Message-ID: <20220324174301.GA1212881@ls.amr.corp.intel.com>
References: <cover.1647167475.git.kai.huang@intel.com>
 <98c1010509aa412e7f05b12187cacf40451d5246.1647167475.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98c1010509aa412e7f05b12187cacf40451d5246.1647167475.git.kai.huang@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 13, 2022 at 11:49:49PM +1300,
Kai Huang <kai.huang@intel.com> wrote:

> TDX provides increased levels of memory confidentiality and integrity.
> This requires special hardware support for features like memory
> encryption and storage of memory integrity checksums.  Not all memory
> satisfies these requirements.
> 
> As a result, TDX introduced the concept of a "Convertible Memory Region"
> (CMR).  During boot, the firmware builds a list of all of the memory
> ranges which can provide the TDX security guarantees.  The list of these
> ranges, along with TDX module information, is available to the kernel by
> querying the TDX module via TDH.SYS.INFO SEAMCALL.
> 
> Host kernel can choose whether or not to use all convertible memory
> regions as TDX memory.  Before TDX module is ready to create any TD
> guests, all TDX memory regions that host kernel intends to use must be
> configured to the TDX module, using specific data structures defined by
> TDX architecture.  Constructing those structures requires information of
> both TDX module and the Convertible Memory Regions.  Call TDH.SYS.INFO
> to get this information as preparation to construct those structures.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>  arch/x86/virt/vmx/tdx.c | 127 ++++++++++++++++++++++++++++++++++++++++
>  arch/x86/virt/vmx/tdx.h |  61 +++++++++++++++++++
>  2 files changed, 188 insertions(+)
> 
> diff --git a/arch/x86/virt/vmx/tdx.c b/arch/x86/virt/vmx/tdx.c
> index 4b0c285d844b..eb585bc5edda 100644
> --- a/arch/x86/virt/vmx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx.c
> @@ -80,6 +80,11 @@ static DEFINE_MUTEX(tdx_module_lock);
>  
>  static struct p_seamldr_info p_seamldr_info;
>  
> +/* Base address of CMR array needs to be 512 bytes aligned. */
> +static struct cmr_info tdx_cmr_array[MAX_CMRS] __aligned(CMR_INFO_ARRAY_ALIGNMENT);
> +static int tdx_cmr_num;
> +static struct tdsysinfo_struct tdx_sysinfo;
> +
>  static bool __seamrr_enabled(void)
>  {
>  	return (seamrr_mask & SEAMRR_ENABLED_BITS) == SEAMRR_ENABLED_BITS;
> @@ -468,6 +473,123 @@ static int tdx_module_init_cpus(void)
>  	return seamcall_on_each_cpu(&sc);
>  }
>  
> +static inline bool cmr_valid(struct cmr_info *cmr)
> +{
> +	return !!cmr->size;
> +}
> +
> +static void print_cmrs(struct cmr_info *cmr_array, int cmr_num,
> +		       const char *name)
> +{
> +	int i;
> +
> +	for (i = 0; i < cmr_num; i++) {
> +		struct cmr_info *cmr = &cmr_array[i];
> +
> +		pr_info("%s : [0x%llx, 0x%llx)\n", name,
> +				cmr->base, cmr->base + cmr->size);
> +	}
> +}
> +
> +static int sanitize_cmrs(struct cmr_info *cmr_array, int cmr_num)
> +{
> +	int i, j;
> +
> +	/*
> +	 * Intel TDX module spec, 20.7.3 CMR_INFO:
> +	 *
> +	 *   TDH.SYS.INFO leaf function returns a MAX_CMRS (32) entry
> +	 *   array of CMR_INFO entries. The CMRs are sorted from the
> +	 *   lowest base address to the highest base address, and they
> +	 *   are non-overlapping.
> +	 *
> +	 * This implies that BIOS may generate invalid empty entries
> +	 * if total CMRs are less than 32.  Skip them manually.
> +	 */
> +	for (i = 0; i < cmr_num; i++) {
> +		struct cmr_info *cmr = &cmr_array[i];
> +		struct cmr_info *prev_cmr = NULL;
> +
> +		/* Skip further invalid CMRs */
> +		if (!cmr_valid(cmr))
> +			break;
> +
> +		if (i > 0)
> +			prev_cmr = &cmr_array[i - 1];
> +
> +		/*
> +		 * It is a TDX firmware bug if CMRs are not
> +		 * in address ascending order.
> +		 */
> +		if (prev_cmr && ((prev_cmr->base + prev_cmr->size) >
> +					cmr->base)) {
> +			pr_err("Firmware bug: CMRs not in address ascending order.\n");
> +			return -EFAULT;
> +		}
> +	}
> +
> +	/*
> +	 * Also a sane BIOS should never generate invalid CMR(s) between
> +	 * two valid CMRs.  Sanity check this and simply return error in
> +	 * this case.
> +	 */
> +	for (j = i; j < cmr_num; j++)
> +		if (cmr_valid(&cmr_array[j])) {
> +			pr_err("Firmware bug: invalid CMR(s) among valid CMRs.\n");
> +			return -EFAULT;
> +		}

This check doesn't make sense because above i-for loop has break.

> +
> +	/*
> +	 * Trim all tail invalid empty CMRs.  BIOS should generate at
> +	 * least one valid CMR, otherwise it's a TDX firmware bug.
> +	 */
> +	tdx_cmr_num = i;
> +	if (!tdx_cmr_num) {
> +		pr_err("Firmware bug: No valid CMR.\n");
> +		return -EFAULT;
> +	}

Something strange.
Probably we'd like to check it by decrementing.
for (i = cmr_num; i >= 0; i--)
  if (!cmr_valid()) // if last invalid cmr
     tdx_cmr_num
  // more check. overlapping

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
