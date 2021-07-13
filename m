Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A92F3C7602
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 19:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233767AbhGMR5k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 13:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbhGMR5k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 13:57:40 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2112C0613DD
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 10:54:49 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id b8-20020a17090a4888b02901725eedd346so2604361pjh.4
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 10:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4rLu2gWL9X6epEYhyMYR4PfLAtHsOyBb4755WMvvHis=;
        b=V3xjmqU5HP5/2X9tDujOz7dc9tDOvaNmUDY8qSRN+oURG1WClxeaP2JjDN4eDgITb1
         NYedLwzF8noY75Pj1cT1QAjSq5B2sR679ia3j5ofoXXJxPMGMZAVBBtMN3F/CQYQ0cpI
         IRZ76iZwEULmquj8xwCSwUxYHf2sqFU8yU8wlCar9pyNrDphGCIaW1TkR8DUIls+hhQL
         VQa4hxoxcjPwtqM8dAGyeWnKHxUKia/PzCVVKnGIx29sXcDsOkL4FVAqta1SD7GEIuo3
         ++CMaXk9hF/PqP32ECbn7BBfu/7jSGzyp9pK1Y36CUK3T+yCb7HBA+DBGiRcO9d/WtWu
         jEhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4rLu2gWL9X6epEYhyMYR4PfLAtHsOyBb4755WMvvHis=;
        b=ie/pV3pwWUHN1A5zXbsN08PyUqUCrvEPuThGmp/Tk22/fhgATgidARGHyxxwVAKtN7
         G0RorKDoT6zeD1mWStrQHpv+lTN1dzNKf7VfcFDTkwKI08PJ+aNMlOKu2YhVUL3V4UUT
         xiRnZ7WH3XyH5U7eYC4ZmyTezbPjdurMvtk8nII/P1YVHjKAiC37MppBet3cy770qtZ9
         vh7yCZiAuEwTxg2ztAvCrBiV4f/efLe670/us4/EhiT2X7gyL1b+I/ziUGaRqoFUASVI
         TsJPrw2f0SJwSh4eqI/k5v0a9gxpXrQ9dzh/iVG+t6rQvkEFPn+AB/iAIQgl+V74/aJh
         pj/A==
X-Gm-Message-State: AOAM533pe18LmzGStk70+/fzwM+eXfyCRp/UUsenROMhDHC4ZaTIDv2F
        rX5OoNjp7qby7w0+i0pVBIU9gg==
X-Google-Smtp-Source: ABdhPJyYSDUXu5X+/x+G4/JIPF+YkjRAY7+UsVk9/gBK6s4iCbyyJwFblF7j9zT0u+WDPcVLWnGFQQ==
X-Received: by 2002:a17:90a:f698:: with SMTP id cl24mr449380pjb.79.1626198889117;
        Tue, 13 Jul 2021 10:54:49 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x7sm13629119pfc.96.2021.07.13.10.54.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jul 2021 10:54:48 -0700 (PDT)
Date:   Tue, 13 Jul 2021 17:54:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     isaku.yamahata@intel.com
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@gmail.com
Subject: Re: [RFC PATCH v2 01/69] KVM: TDX: introduce config for KVM TDX
 support
Message-ID: <YO3TZWtkwHBMRpYy@google.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <2f265006e5cee03a5a48448c51c3632391e58ec7.1625186503.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f265006e5cee03a5a48448c51c3632391e58ec7.1625186503.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 02, 2021, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Add new config KVM_INTEL_TDX for KVM TDX support.  This patch introduce
> a config only.  Later patch will implement feature depends on it.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/Kconfig | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index f6b93a35ce14..66622901bf7d 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -96,6 +96,17 @@ config X86_SGX_KVM
>  
>  	  If unsure, say N.
>  
> +config KVM_INTEL_TDX
> +	bool "Trusted Domain eXtensions(TDX) Host support"
> +	depends on KVM_INTEL && X86_64
> +	select FW_LOADER

Similar to patch 2, it's impossible to review this as is since the FW_LOADER
dependency is for the SEAMLDR side of things, which is not included in this
series.

> +
> +	help
> +	  Extends KVM on Intel processors to support Trusted Domain Extensions.
> +	  Intel Trust Domain eXtensions(TDX) is an architecture based on CPU
> +	  instructions and TDX module to deploy hardware-isolated virtual
> +	  machines(VMs) which is called Trust Domains(TDs).
> +
>  config KVM_AMD
>  	tristate "KVM for AMD processors support"
>  	depends on KVM
> -- 
> 2.25.1
> 
