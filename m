Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61C6E6C8270
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 17:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbjCXQfj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 12:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbjCXQf1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 12:35:27 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB4315143;
        Fri, 24 Mar 2023 09:35:25 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id 2adb3069b0e04-4dd9da1c068so31539e87.0;
        Fri, 24 Mar 2023 09:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679675723;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zhNxgaGOUjmDiGwyjq+ZlkgCOlvjaPQwX8R8JRImhRA=;
        b=pongAXN+we/0UwNbWK4fJFQgB6XH0yravDZ1qFwIQGqHfgaKj/1JCxMcGgBVtTJIGD
         g3Q/DEaUXtMpDbh0gIZ9au7d38ssvz2qfRwE8JaVU72D1nW/Jn6i5Wr2o8mlsaf84zAC
         bosg6Ca8AjO/DvH1C5+x/93rfVk4DtyZKcXx2M+PoJ6e9/DSCIGKPe5wC9BfoyURouaY
         BqQPYC7YiCD0oqVUmOBLHyQ4h1CyTFbwEw2XZYZ/i+cpe4dgllkqjyXwrf+OVqGRf11E
         /gFJcwk0vooYCkKZniy5/WTle02cygBQ5SzfndJwUP64ScGl1+MmN/BYIyQgjapaKzgR
         BQcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679675723;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zhNxgaGOUjmDiGwyjq+ZlkgCOlvjaPQwX8R8JRImhRA=;
        b=2L5ntr9SCITj186kjRGddJQh1tGfzQxUzn7gnlyL5aj4PxJo+mUx6lUr1U/Sr6f/Rd
         cXQwRIhjOobOweS1fx8dhgl6zWYY32VL+lJCejCjt6qOn+Oc8hWOGx2GcML7jWlaLt9c
         sAy3mOtg7HtOtMNFXwL43akTkz0Z9lmNQGruBP0R02AScwjodXYUaF5zLKN9/fah6aDX
         OWMPHrtXrbOSbcXhHUOG8WFASpUPkDenhXzTlFRPv6LWgvPNSN74T8PvoHwNP93D2VZP
         3+wWcreTWvR0j8SaTiDiD17HBOjFF9RFg55f2k53Tc5ZI3aYiHMCVEfiLQnF9OF7ncrw
         zrYw==
X-Gm-Message-State: AAQBX9eauquYKlAgkiQ+bSbiPyZe5kBCxXc3jRONuUu4rPIBpTz77fWi
        THk+qviHP29qHnW6iGNFXDk=
X-Google-Smtp-Source: AKy350Z78BDJq0gHi80wlSPkoxEVi54qvMplnHhaZro2l0MeE+/C3zwMCVmwPG2aM2BohhND3xj3Hg==
X-Received: by 2002:ac2:4946:0:b0:4b5:a7c7:9dc4 with SMTP id o6-20020ac24946000000b004b5a7c79dc4mr598086lfi.3.1679675723161;
        Fri, 24 Mar 2023 09:35:23 -0700 (PDT)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id b22-20020ac24116000000b004d887e0e9edsm3401962lfi.168.2023.03.24.09.35.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 09:35:23 -0700 (PDT)
Date:   Fri, 24 Mar 2023 18:35:21 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v13 014/113] x86/cpu: Add helper functions to
 allocate/free TDX private host key id
Message-ID: <20230324183521.000010ad.zhi.wang.linux@gmail.com>
In-Reply-To: <c88b3dc84d64f0e73039670acecbbb07dc5c6a54.1678643052.git.isaku.yamahata@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
        <c88b3dc84d64f0e73039670acecbbb07dc5c6a54.1678643052.git.isaku.yamahata@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 12 Mar 2023 10:55:38 -0700
isaku.yamahata@intel.com wrote:

> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> TDX private host key id (HKID) is assigned to guest TD.  The memory
> controller encrypts guest TD memory with the assigned TDX HKID.  Add helper
> functions to allocate/free TDX private HKID so that TDX KVM can manage it.
> 
^ This sentence should go to the below paragraph, which is "problem/way to go"
paragraph. For "background" paragraph, you can talk more about the usage of
HKID, like global/private HKID. Then you don't need to introduce them again in
the below paragraph and just talk about the solution.

> Also export the global TDX private HKID that is used to encrypt TDX module,
> its memory and some dynamic data (TDR).  When VMM releasing encrypted page
> to reuse it, the page needs to be flushed with the used HKID.  VMM needs
> the global TDX private HKID to flush such pages.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/asm/tdx.h  | 12 ++++++++++++
>  arch/x86/virt/vmx/tdx/tdx.c | 34 +++++++++++++++++++++++++++++++++-
>  2 files changed, 45 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index 6c01ab572c1f..7d99a48a98cc 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -104,6 +104,16 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
>  bool platform_tdx_enabled(void);
>  int tdx_cpu_enable(void);
>  int tdx_enable(void);
> +/*
> + * Key id globally used by TDX module: TDX module maps TDR with this TDX global
> + * key id.  TDR includes key id assigned to the TD.  Then TDX module maps other
> + * TD-related pages with the assigned key id.  TDR requires this TDX global key
> + * id for cache flush unlike other TD-related pages.
> + */
> +extern u32 tdx_global_keyid __ro_after_init;
> +int tdx_guest_keyid_alloc(void);
> +void tdx_guest_keyid_free(int keyid);
> +
>  u64 __seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
>  	       struct tdx_module_output *out);
>  #else	/* !CONFIG_INTEL_TDX_HOST */
> @@ -112,6 +122,8 @@ static inline int tdx_cpu_enable(void) { return -EINVAL; }
>  static inline int tdx_enable(void)  { return -EINVAL; }
>  static inline u64 __seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
>  			     struct tdx_module_output *out) { return TDX_SEAMCALL_UD; };
> +static inline int tdx_guest_keyid_alloc(void) { return -EOPNOTSUPP; }
> +static inline void tdx_guest_keyid_free(int keyid) { }
>  #endif	/* CONFIG_INTEL_TDX_HOST */
>  
>  #endif /* !__ASSEMBLY__ */
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index ee94a7327d93..3251fdf74667 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -33,7 +33,8 @@
>  #include <asm/tdx.h>
>  #include "tdx.h"
>  
> -static u32 tdx_global_keyid __ro_after_init;
> +u32 tdx_global_keyid __ro_after_init;
> +EXPORT_SYMBOL_GPL(tdx_global_keyid);
>  static u32 tdx_guest_keyid_start __ro_after_init;
>  static u32 tdx_nr_guest_keyids __ro_after_init;
>  
> @@ -138,6 +139,31 @@ static struct notifier_block tdx_memory_nb = {
>  	.notifier_call = tdx_memory_notifier,
>  };
>  
> +/* TDX KeyID pool */
> +static DEFINE_IDA(tdx_guest_keyid_pool);
> +
> +int tdx_guest_keyid_alloc(void)
> +{
> +	if (WARN_ON_ONCE(!tdx_guest_keyid_start || !tdx_nr_guest_keyids))
> +		return -EINVAL;
> +
> +	/* The first keyID is reserved for the global key. */
> +	return ida_alloc_range(&tdx_guest_keyid_pool, tdx_guest_keyid_start + 1,
> +			       tdx_guest_keyid_start + tdx_nr_guest_keyids - 1,
> +			       GFP_KERNEL);
> +}
> +EXPORT_SYMBOL_GPL(tdx_guest_keyid_alloc);
> +
> +void tdx_guest_keyid_free(int keyid)
> +{
> +	/* keyid = 0 is reserved. */
> +	if (WARN_ON_ONCE(keyid <= 0))
> +		return;
> +
> +	ida_free(&tdx_guest_keyid_pool, keyid);
> +}
> +EXPORT_SYMBOL_GPL(tdx_guest_keyid_free);
> +
>  static int __init tdx_init(void)
>  {
>  	u32 tdx_keyid_start, nr_tdx_keyids;
> @@ -1218,6 +1244,12 @@ static int init_tdx_module(void)
>  	if (ret)
>  		goto out_free_pamts;
>  
> +	/*
> +	 * Reserve the first TDX KeyID as global KeyID to protect
> +	 * TDX module metadata.
> +	 */
> +	tdx_global_keyid = tdx_keyid_start;
> +
>  	/* Initialize TDMRs to complete the TDX module initialization */
>  	ret = init_tdmrs(&tdmr_list);
>  

