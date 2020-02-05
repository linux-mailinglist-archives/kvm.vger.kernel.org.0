Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95A441532D9
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 15:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgBEO2v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 09:28:51 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:53676 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726208AbgBEO2v (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 09:28:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580912930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VVktf06+GZqAo22U81ichbfeIFv6sOB8dBH2Oa/AtXQ=;
        b=RGhSrmaKGsdewvxfAAbkfoOCXmHsk40IJKqVbuVVTlwiBfLJgCDaIzLAYgi/U0KXryj9Ch
        alYAp9b7y4CpxZBZW9UlsDOhTSWTL6GHwis5UoTIXVgck2zlPGlAj0nxJdlYwwn6DQS9ks
        4tEhz4y01kySVVpBTbPeOBLgOwHi0Qs=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-lmYcJSbWPe6mnR6sKBuS2Q-1; Wed, 05 Feb 2020 09:28:49 -0500
X-MC-Unique: lmYcJSbWPe6mnR6sKBuS2Q-1
Received: by mail-wr1-f69.google.com with SMTP id p8so1273873wrw.5
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 06:28:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VVktf06+GZqAo22U81ichbfeIFv6sOB8dBH2Oa/AtXQ=;
        b=oPNwP5Cb54U9q4ypNCb5t+I30EzdA2NHPSBSZoQkne3Ce2qEeTHNC4SPeN/dW8SLbb
         yYz08o/gavHVLY32kwpzPGAm79ds3J9PmBN8d9Hkwu3subDFHYpkupRcQ+myy7Ab/a74
         zYkd3Fzpt1Gd7YhbLivHr+siXfgZsgzp+ZccGPrVpAo+o4hbzRlY0LE5kGjHvywbqgyM
         MFJRkpNfxnkjCTdafk26jA9as0UCVGVVH/yjd7x5FXWEIOPBnA8YCdjNNpIaITWcDLE/
         fhx9FMQdzF22euyAnt0ZghEveU3I2bO4EnfXiOyynHd/pgmYjumMKOxTNVCRziaqsZ1k
         YaVA==
X-Gm-Message-State: APjAAAVMaoVGu7L4snKW0llWZgI5Uj1pouZ+rukdBcAWw9agyhhEU5dv
        XcSmtYujMls+3Z9PonvMSTeed/QpfiwLoJjMXI7gZnoWdhb8wA0/QpkdsLiimUCT6b07brDpomR
        GupM5gaaK4Zs5
X-Received: by 2002:a1c:740b:: with SMTP id p11mr6293068wmc.78.1580912928002;
        Wed, 05 Feb 2020 06:28:48 -0800 (PST)
X-Google-Smtp-Source: APXvYqxxT+e8hvj/MufgYJHCGifPCvbBShe4n/7zTciX41OS2hObKa3dxiQxvgkgaTmHXGd/bD/YTg==
X-Received: by 2002:a1c:740b:: with SMTP id p11mr6293031wmc.78.1580912927687;
        Wed, 05 Feb 2020 06:28:47 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a9f0:cbc3:a8a6:fc56? ([2001:b07:6468:f312:a9f0:cbc3:a8a6:fc56])
        by smtp.gmail.com with ESMTPSA id 18sm8243459wmf.1.2020.02.05.06.28.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2020 06:28:47 -0800 (PST)
Subject: Re: [PATCH] x86/kvm: do not setup pv tlb flush when not
 paravirtualized
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, wanpengli@tencent.com,
        vkuznets@redhat.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org
References: <20200131155655.49812-1-cascardo@canonical.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <11c6069b-1248-30b5-f69c-36f47755d75f@redhat.com>
Date:   Wed, 5 Feb 2020 15:28:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200131155655.49812-1-cascardo@canonical.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/01/20 16:56, Thadeu Lima de Souza Cascardo wrote:
> kvm_setup_pv_tlb_flush will waste memory and print a misguiding message
> when KVM paravirtualization is not available.
> 
> Intel SDM says that the when cpuid is used with EAX higher than the
> maximum supported value for basic of extended function, the data for the
> highest supported basic function will be returned.
> 
> So, in some systems, kvm_arch_para_features will return bogus data,
> causing kvm_setup_pv_tlb_flush to detect support for pv tlb flush.
> 
> Testing for kvm_para_available will work as it checks for the hypervisor
> signature.
> 
> Besides, when the "nopv" command line parameter is used, it should not
> continue as well, as kvm_guest_init will no be called in that case.
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> ---
>  arch/x86/kernel/kvm.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 81045aabb6f4..d817f255aed8 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -736,6 +736,9 @@ static __init int kvm_setup_pv_tlb_flush(void)
>  {
>  	int cpu;
>  
> +	if (!kvm_para_available() || nopv)
> +		return 0;
> +
>  	if (kvm_para_has_feature(KVM_FEATURE_PV_TLB_FLUSH) &&
>  	    !kvm_para_has_hint(KVM_HINTS_REALTIME) &&
>  	    kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
> 

Queued, thanks.

Paolo

