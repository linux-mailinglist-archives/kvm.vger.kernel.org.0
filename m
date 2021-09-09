Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1935E4044E8
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 07:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350711AbhIIFVI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 01:21:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39137 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350690AbhIIFVH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Sep 2021 01:21:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631164797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SRkJG9EGhC8VgYdl6gsAldPi2RC6qHvYq1zbEFWdBEM=;
        b=S5j/53HwI+W5xUWgmFm1tk8FyNPo4Ej2YWgsEZQeFR1AHryJYpz4W8fU8taw6zFmB7l/M9
        oeRNT37dlWopf9u3wrWJC7T7qTxRpoD+J8oKoPUlB6ZNZe2LqUvjizypIG3UimXUFQTeZl
        Lthdlsjjt1eWDkcSVQ9n+fvQqxesAEY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-0rAakD9KOgerqg71Old_hA-1; Thu, 09 Sep 2021 01:19:56 -0400
X-MC-Unique: 0rAakD9KOgerqg71Old_hA-1
Received: by mail-wm1-f70.google.com with SMTP id x125-20020a1c3183000000b002e73f079eefso393363wmx.0
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 22:19:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=SRkJG9EGhC8VgYdl6gsAldPi2RC6qHvYq1zbEFWdBEM=;
        b=PsSFFgMnVSdVQLpGRxmFWDMxbKMp0vpzbcl+yexY43p61Hac1pomMLXX/FZAH15B03
         itp0qNVxb4p7q2r2lNitmNrnOFufOJeUAh0hW/eqDg+KWRCvB+rBUE0Ss9p/h9pl7Bnr
         +H5bvKj4oSEyHJSYDIeq8q0Mez/qLaoch0PCG961qUPaKWsw2GPLlSgQsIuxghvyDbdw
         xDN9nrBRIICH2GIdOHZ+/Xp8s9Zo2gPq3EANAj4+9kJ0GWd7XNme8GhUnm2V30d68EN4
         eHqqdmThG9siag3QqDmEIL4sAMTYNVFaw41+Y8Awt+wF4PTtfTHejvlE4b0urcB7Wn24
         4TQw==
X-Gm-Message-State: AOAM532N4AbTGf+gYmWFGp3yXxufZEyoqE3i3nB8pppXcRuk171nxIA2
        Ump87vHStghfc4uM3LzB3RE3WzEtuAPNwQO8f41xdvRuv1wwEfzT29sY6o4qHnKKwSi+lLIXAyN
        hBTVnfzpAK9jw
X-Received: by 2002:adf:d191:: with SMTP id v17mr1195123wrc.345.1631164795424;
        Wed, 08 Sep 2021 22:19:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwWu7mHKu8Bu/+CN9d6SsQc3M72VjMeAtWgfEflP6tjJsSvyBKJOOGDH6D6mh8Lte/+vUA/LQ==
X-Received: by 2002:adf:d191:: with SMTP id v17mr1195110wrc.345.1631164795270;
        Wed, 08 Sep 2021 22:19:55 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id g5sm611728wrq.80.2021.09.08.22.19.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 22:19:54 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>, seanjc@google.com,
        pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Subject: Re: [PATCH] KVM: nVMX: Reset vmxon_ptr upon VMXOFF emulation.
In-Reply-To: <20210909124846.13854-1-yu.c.zhang@linux.intel.com>
References: <20210909124846.13854-1-yu.c.zhang@linux.intel.com>
Date:   Thu, 09 Sep 2021 07:19:53 +0200
Message-ID: <874kau496u.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Yu Zhang <yu.c.zhang@linux.intel.com> writes:

> From: Vitaly Kuznetsov <vkuznets@redhat.com>
>
> Currently, 'vmx->nested.vmxon_ptr' is not reset upon VMXOFF
> emulation. This is not a problem per se as we never access
> it when !vmx->nested.vmxon. But this should be done to avoid
> any issue in the future.
>
> Also, initialize the vmxon_ptr when vcpu is created.
>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Thanks but even Suggested-by: would be enough :-)

> Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 1 +
>  arch/x86/kvm/vmx/vmx.c    | 1 +
>  2 files changed, 2 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 90f34f12f883..e4260f67caac 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -289,6 +289,7 @@ static void free_nested(struct kvm_vcpu *vcpu)
>  	kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
>  
>  	vmx->nested.vmxon = false;
> +	vmx->nested.vmxon_ptr = -1ull;
>  	vmx->nested.smm.vmxon = false;
>  	free_vpid(vmx->nested.vpid02);
>  	vmx->nested.posted_intr_nv = -1;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 0c2c0d5ae873..9a3e35c038f2 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6886,6 +6886,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
>  
>  	vcpu_setup_sgx_lepubkeyhash(vcpu);
>  
> +	vmx->nested.vmxon_ptr = -1ull;
>  	vmx->nested.posted_intr_nv = -1;
>  	vmx->nested.current_vmptr = -1ull;
>  	vmx->nested.hv_evmcs_vmptr = EVMPTR_INVALID;

-- 
Vitaly

