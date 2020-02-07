Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51F95155AF8
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 16:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgBGPsc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 10:48:32 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:29247 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726936AbgBGPsb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 10:48:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581090510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xwuFs+d8bJwJhhJOajzZNm6jYesIdXdjH4QKPI8LzcM=;
        b=UKoR3ISb2Lg2z9n/UeNCSqQKZMMLtNWNZUfbEJcVrmT42pmTqwghij0Bb6BhJbDD5/kk/V
        lPAwdn6vK0N8QtGeiH1UAIPM1rg/ktupWOamw+UKW80gn84Vg0Mvpj7KMIalIKjB8vOPLM
        N29ODvB5mLitMTo1yzgaHtLO9aAh1k4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-NAvWHxUtOPGHi_Khtt1G0w-1; Fri, 07 Feb 2020 10:48:26 -0500
X-MC-Unique: NAvWHxUtOPGHi_Khtt1G0w-1
Received: by mail-wr1-f72.google.com with SMTP id j4so1448065wrs.13
        for <kvm@vger.kernel.org>; Fri, 07 Feb 2020 07:48:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=xwuFs+d8bJwJhhJOajzZNm6jYesIdXdjH4QKPI8LzcM=;
        b=b+WrPPza9RRB5hbPvB+yzGV+w93mlf7nPtFNaHTmdO9koSg88y8uUJFSwhS4J1OITF
         bqIdx/1otHnf/O+wEkCGXuWNQTTcqIKX1k1PZf1AUerthagE1COIFQo3S/1ojsfpccIt
         K1YPPqhD3UD4Eefw+f+57ZltJA1JxHPvyN2zt6MKCcrR+b1BmiVMOULiKlCde7AEC1lb
         3Wd2GGc6A7JAiHiPIBMm5+TeKnLZt1czJMKkgytVFJaFKg6AZRC7N52JPz8ZscCBnY/C
         JK2f0S7qHDFcKm/CeBrOkbHI30fUuK3eXJ0+kHRSqE6LQNRd9ReM+FhZFHjW21ctpPKM
         5UUg==
X-Gm-Message-State: APjAAAUyrZiWFU2zS9lDME+s7NgijGdnPXS7qGJTvueu3kUIpyi3aX0i
        zk29QEZgpHr2nb5CjB7fpJaF3uV7ViGBsrOLrs5V9DNd50kEEmIrXsEr5OWNAayrkXMRiFZLsZH
        Hzh44emKdcWld
X-Received: by 2002:adf:cd04:: with SMTP id w4mr5631196wrm.219.1581090504117;
        Fri, 07 Feb 2020 07:48:24 -0800 (PST)
X-Google-Smtp-Source: APXvYqz41NVY/PedM9n7Ys7gSqcfGjqvwYpzjm3X6C/T7/jBpkYp83BGA/BjCIhF9v9j1utS1ZenLA==
X-Received: by 2002:adf:cd04:: with SMTP id w4mr5631171wrm.219.1581090503877;
        Fri, 07 Feb 2020 07:48:23 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id a22sm3922661wmd.20.2020.02.07.07.48.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2020 07:48:23 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 07/61] KVM: x86: Check for CPUID 0xD.N support before validating array size
In-Reply-To: <20200201185218.24473-8-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-8-sean.j.christopherson@intel.com>
Date:   Fri, 07 Feb 2020 16:48:22 +0100
Message-ID: <87eev6qtyx.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Now that sub-leaf 1 is handled separately, verify the next sub-leaf is
> needed before rejecting KVM_GET_SUPPORTED_CPUID due to an insufficiently
> sized userspace array.
>
> Note, although this is technically a bug, it's not visible to userspace
> as KVM_GET_SUPPORTED_CPUID is guaranteed to fail on KVM_CPUID_SIGNATURE,
> which is hardcoded to be added after leaf 0xD.  The real motivation for
> the change is to tightly couple the nent/maxnent and do_host_cpuid()
> sequences in preparation for future cleanup.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index fc8540596386..fd9b29aa7abc 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -670,13 +670,14 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>  		entry[1].edx = 0;
>  
>  		for (idx = 2, i = 2; idx < 64; ++idx) {
> -			u64 mask = ((u64)1 << idx);
> +			if (!(supported & BIT_ULL(idx)))
> +				continue;
>  
>  			if (*nent >= maxnent)
>  				goto out;
>  
>  			do_host_cpuid(&entry[i], function, idx);
> -			if (entry[i].eax == 0 || !(supported & mask))
> +			if (entry[i].eax == 0)
>  				continue;
>  			if (WARN_ON_ONCE(entry[i].ecx & 1))
>  				continue;

The remaining WARN_ON_ONCE() is technically the same 'bug not visible to
userspace' :-)

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

