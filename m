Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36313523C07
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 19:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242498AbiEKRzX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 13:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234595AbiEKRzV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 13:55:21 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 143406D865
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 10:55:21 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id v11so2625214pff.6
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 10:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=V6SyBqfC4CityKWPK9AYP+Ctddqj89S4Oyqs7ymKWJU=;
        b=kag6meWblwbgPa3m5tdyr6t2aLwgSgh+npUpqkAyEcdDrj1+knMPdhFReUt8nyPk07
         MJqn/SNcPQIFNbrMWkPcGsyFbze/aRGWp22ebIRExPfDnJwpmZYeZX9sTDByRr1Cfkds
         C5c8M0p/G5r3mJCCqnurY7jVANZ/BPtVSnpRjwaHRWgc3nZv0YU9K+WzcT+8QP1uLp+d
         M0bFx+zznVUFkLIz23CMSEXbryvbf0T+c285p6MbtvO3LHKplm+PBTCDqbxTmrQGtuOb
         CgGDpbpRDrB7TCacrkhOWdC9yNrNpfMnUAi0SmosAj2HGvVX1elmD1bl7ZHORGllcTu4
         BAiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=V6SyBqfC4CityKWPK9AYP+Ctddqj89S4Oyqs7ymKWJU=;
        b=FHev5POwNI1KqeokVS8OSv1gJm8YXdywsb6rrVmUws3u8TQyapbIfLy6z/jjhRoAI2
         r4RfeJYMVYXjCeOrXUFMd0iRdvX49fG2jqjunFYI9UyhRQR7oEc8BLTtNXSdkyh/v3jC
         ErmnZUU6MYh1Xy74aDCfGitpV3z5FtUYi94HMGbIqvoEg+U6nPegjEindsyONGvV//kY
         jdi2JwUlL5gIRcrO/Ue5HIrOMcpIhyQ/WPPmf2i8br5g7UbIb3GbMg0D5Xw0TYyZF5nH
         94kL966Ekhsv7FWDEi2PEQ/PuIscqAVmz5mdrLWujkKRr4uq3+FXQo7Jvu3zkZOiWT6X
         d2pg==
X-Gm-Message-State: AOAM533WrE7Zb3kUHWXddxt/PuyFZTmlf0rtRFerqj2jI7YHjsGGetX9
        o4efTVj47PLSRwq9cDwxFlVu+Q==
X-Google-Smtp-Source: ABdhPJwxgjFPVBIy+/dA7NhEnaK/WZAoWlpoDfcz7NiceKRqPqePEq/DgZxNyUPhtkXQwsJfcbCTpQ==
X-Received: by 2002:a05:6a00:21c2:b0:4fe:81f:46c7 with SMTP id t2-20020a056a0021c200b004fe081f46c7mr26026059pfj.5.1652291720417;
        Wed, 11 May 2022 10:55:20 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id n5-20020a634005000000b003c14af5061asm167310pga.50.2022.05.11.10.55.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 10:55:20 -0700 (PDT)
Date:   Wed, 11 May 2022 17:55:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jue Wang <juew@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/4] KVM: x86: Add LVTCMCI support.
Message-ID: <Ynv4hLFQMPaQ4yYs@google.com>
References: <20220412223134.1736547-1-juew@google.com>
 <20220412223134.1736547-3-juew@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412223134.1736547-3-juew@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 12, 2022, Jue Wang wrote:
> This feature is only enabled when the vCPU has opted in to enable
> MCG_CMCI_P.

Again, waaaay too terse.  What is CMCI?  What does "support" mean since an astute
reader will notice that it's impossible for MCG_CMCI_P to be set.  How/when will
the vCPU (which is wrong no?  doesn't userspace do the write?) be able to opt-in?

> Signed-off-by: Jue Wang <juew@google.com>
> ---
>  arch/x86/kvm/lapic.c | 33 ++++++++++++++++++++++++++-------
>  arch/x86/kvm/lapic.h |  7 ++++++-
>  2 files changed, 32 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 2c770e4c0e6c..0b370ccd11a1 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -27,6 +27,7 @@
>  #include <linux/math64.h>
>  #include <linux/slab.h>
>  #include <asm/processor.h>
> +#include <asm/mce.h>
>  #include <asm/msr.h>
>  #include <asm/page.h>
>  #include <asm/current.h>
> @@ -364,9 +365,14 @@ static inline int apic_lvt_nmi_mode(u32 lvt_val)
>  	return (lvt_val & (APIC_MODE_MASK | APIC_LVT_MASKED)) == APIC_DM_NMI;
>  }
>  
> +static inline bool kvm_is_cmci_supported(struct kvm_vcpu *vcpu)
> +{
> +	return vcpu->arch.mcg_cap & MCG_CMCI_P;
> +}
> +
>  static inline int kvm_apic_get_nr_lvt_entries(struct kvm_vcpu *vcpu)

I think it makes sense to take @apic here, not @vcpu, since this is an APIC-specific
helper.  kvm_apic_set_version() will need to be modified to not call
kvm_apic_get_nr_lvt_entries() until after it has verified the local APIC is in-kernel,
but IMO that's a good thing.

>  {
> -	return KVM_APIC_MAX_NR_LVT_ENTRIES;
> +	return KVM_APIC_MAX_NR_LVT_ENTRIES - !kvm_is_cmci_supported(vcpu);
>  }
>  
>  void kvm_apic_set_version(struct kvm_vcpu *vcpu)
