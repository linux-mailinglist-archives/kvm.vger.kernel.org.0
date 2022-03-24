Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6674E6886
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 19:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352433AbiCXSUJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 14:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351134AbiCXSUG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 14:20:06 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB76B0A4D;
        Thu, 24 Mar 2022 11:18:34 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id mp6-20020a17090b190600b001c6841b8a52so10136779pjb.5;
        Thu, 24 Mar 2022 11:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:0;136;0cfrom;
        bh=0EGnpmKX/Afxx+t6ThiAfqay0i13JN+dPpZZ6kF6r38=;
        b=hz9gnMIkTuT/jHMGeVE9G5Ec1qSJSbCjHMs6fB5udq3q54OD1Laju9EOhuGThzAH43
         ujtcS7yJtrkGx5hbdD+/HCwqxBXFsTokBRBKd8sFKwPtD2vA52th9WGAxkF+pCt+J9J7
         Br8OHYyEaKvC6RLQ83+W44/BPGfsT8yKdq983Vy3d2zGSfgyB7qHcVFWW5yGlcji/c62
         mAyz4VI1oBRyXMSuEEBNS0vET9wiioE04+j94ONEXVANYFbdy0zUwJZiqC7Oq8kduKK6
         xxGy+ilMI/uwUp17mwih0t87mpKIq44LHNlXjh0oQeyOoCnSoVbNxDvX9Em5CDpfyWUR
         4/1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:0;136;0cfrom;
        bh=0EGnpmKX/Afxx+t6ThiAfqay0i13JN+dPpZZ6kF6r38=;
        b=uLzFXlkzv5wGO2vHDAokSYIMSAF+/qr/2/2KltK08Q4XvRmdWHRw1Nh4vZ6uUlPBEU
         TumOkfWdUXhIwz+5F6TecfTjjR42JgW9WLQrT8RzloAc8l3bQsQaUI4FPgWMipyGONBD
         cJABkkkjZ6KBTHmC28aQLISVWFzhmCGC81pCLFsfHatRuXIFI0tpOCXSgHO9DYK4vJw6
         9xUbm71xB5yn2nqwr2qPWp8r+sro+xY9R9EnW6aEX44Ty+vt19R8OuqcIoOMpZjFkvQq
         wGEtNteiOFqn753FRH9wTvO7O0gDtnuN2TaFzUMX3DmKFll29bZ4+DKCQZ6EtYJQAh4l
         ILeA==
X-Gm-Message-State: AOAM5326Z03fYuI1O8Tx6ng9HuKt8GFMcF59ZU1Y1UIMVN79uRohcOUx
        jVd89XU1HD983mwZ+DVPMyE=
X-Google-Smtp-Source: ABdhPJzuYwUK/ixFgtm4b9a6pQZPRwN86hbcbaybj2IaFbFwM9ikvlSK9RAoMa56udS2fcr9SKgzTg==
X-Received: by 2002:a17:90b:3b81:b0:1c6:f22c:60f3 with SMTP id pc1-20020a17090b3b8100b001c6f22c60f3mr7779976pjb.109.1648145914233;
        Thu, 24 Mar 2022 11:18:34 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id l2-20020a056a0016c200b004f7e3181a41sm4368819pfc.98.2022.03.24.11.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 11:18:33 -0700 (PDT)
From:   isaku.yamahata@gmail.com
Date:   Thu, 24 Mar 2022 11:18:32 -0700
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dave.hansen@intel.com, seanjc@google.com, pbonzini@redhat.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, peterz@infradead.org,
        tony.luck@intel.com, ak@linux.intel.com, dan.j.williams@intel.com,
        isaku.yamahata@intel.com, isaku.yamahata@gmail.com
Subject: Re: [PATCH v2 17/21] x86/virt/tdx: Configure global KeyID on all
 packages
Message-ID: <20220324181832.GC1212881@ls.amr.corp.intel.com>
References: <cover.1647167475.git.kai.huang@intel.com>
 <c36456b0fd4bd50720bc8e8aa35fbb124185ae98.1647167475.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c36456b0fd4bd50720bc8e8aa35fbb124185ae98.1647167475.git.kai.huang@intel.com>
0;136;0cFrom: Isaku Yamahata <isaku.yamahata@gmail.com>
X-Spam-Status: No, score=-1.0 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 13, 2022 at 11:49:57PM +1300,
Kai Huang <kai.huang@intel.com> wrote:

> diff --git a/arch/x86/virt/vmx/tdx.c b/arch/x86/virt/vmx/tdx.c
> index e03dc3e420db..39b1b7d0417d 100644
> --- a/arch/x86/virt/vmx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx.c
> @@ -23,6 +23,7 @@
>  #include <asm/virtext.h>
>  #include <asm/e820/api.h>
>  #include <asm/pgtable.h>
> +#include <asm/smp.h>
>  #include <asm/tdx.h>
>  #include "tdx.h"
>  
> @@ -398,6 +399,47 @@ static int seamcall_on_each_cpu(struct seamcall_ctx *sc)
>  	return atomic_read(&sc->err);
>  }
>  
> +/*
> + * Call the SEAMCALL on one (any) cpu for each physical package in
> + * serialized way.  Note for serialized calls 'seamcall_ctx::err'
> + * doesn't have to be atomic, but for simplicity just reuse it
> + * instead of adding a new one.
> + *
> + * Return -ENXIO if IPI SEAMCALL wasn't run on any cpu, or -EFAULT
> + * when SEAMCALL fails, or -EPERM when the cpu where SEAMCALL runs
> + * on is not in VMX operation.  In case of -EFAULT, the error code
> + * of SEAMCALL is in 'struct seamcall_ctx::seamcall_ret'.
> + */
> +static int seamcall_on_each_package_serialized(struct seamcall_ctx *sc)
> +{
> +	cpumask_var_t packages;
> +	int cpu, ret;
> +
> +	if (!zalloc_cpumask_var(&packages, GFP_KERNEL))
> +		return -ENOMEM;

Memory leak. This should be freed before returning.


> +	for_each_online_cpu(cpu) {
> +		if (cpumask_test_and_set_cpu(topology_physical_package_id(cpu),
> +					packages))
> +			continue;
> +
> +		ret = smp_call_function_single(cpu, seamcall_smp_call_function,
> +				sc, true);
> +		if (ret)
> +			return ret;
> +
> +		/*
> +		 * Doesn't have to use atomic_read(), but it doesn't
> +		 * hurt either.
> +		 */
> +		ret = atomic_read(&sc->err);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
>  static inline bool p_seamldr_ready(void)
>  {
>  	return !!p_seamldr_info.p_seamldr_ready;
> @@ -1316,6 +1358,18 @@ static int config_tdx_module(struct tdmr_info **tdmr_array, int tdmr_num,
>  	return ret;
>  }
>  
> +static int config_global_keyid(u64 global_keyid)

global_keyid argument isn't used.  Is global variable tdx_global_keyid used?


> +{
> +	struct seamcall_ctx sc = { .fn = TDH_SYS_KEY_CONFIG };
> +
> +	/*
> +	 * TDH.SYS.KEY.CONFIG may fail with entropy error (which is
> +	 * a recoverable error).  Assume this is exceedingly rare and
> +	 * just return error if encountered instead of retrying.
> +	 */
> +	return seamcall_on_each_package_serialized(&sc);
> +}
> +
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
