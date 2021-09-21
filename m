Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2E9413541
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 16:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233578AbhIUOZF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 10:25:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41392 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233545AbhIUOZE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Sep 2021 10:25:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632234216;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wDh0oMN6VwKrbIN4CU/frP4g1lxciAjNHJADjKyJ4Io=;
        b=cZHv9kaHe0DfJiYmioMSQzveuqtRSy1kxSIudYjWoIHg9XEKRdPmrcsDIZ5k1WlKwTpWPf
        7tHgg8U1V+7nBHLAqwZiGx0k0b+ZA0bSauayCauwrL8IxlGsjWbjTMaPc+c/Yk1fgqvOJU
        yL1ZsziD9QExEBl6v9MtIsKkaSOOPBo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-vLjKb52oOmG90gkUoKlNBg-1; Tue, 21 Sep 2021 10:23:33 -0400
X-MC-Unique: vLjKb52oOmG90gkUoKlNBg-1
Received: by mail-wr1-f70.google.com with SMTP id l9-20020adfc789000000b00160111fd4e8so3723512wrg.17
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 07:23:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=wDh0oMN6VwKrbIN4CU/frP4g1lxciAjNHJADjKyJ4Io=;
        b=EPXfQybC6Mm8X8Lu/ahJqsUvTLqbmD51y7OQ7yhHxGKeS2ADYo1xOhSesmU4tOFh0s
         EQVzp+xG6hLtuvBoTeV9JUhZ7ffzPt4BlBHkd3Z7k+8DCqkR8H0mMRfZd4lD13dREVFM
         jX/WKHIqU7lvkf3DWwbbRH4lnEaQslbhyYARu/IunllDYiEQCTQ1usTF7JZ+pj3feRbJ
         spWzE0iA6WTocmBxKHqPm84+AVzRVYCtX8c4wtirUfZwGCGQV2sibOshw4Vy8NsZquB8
         ajXf3FT7RyS16d5AhPm52UzN91qpjQKcYQi9r+uc/UpExnQT/d+e/tFbX5JpOO1EWVvt
         PRVQ==
X-Gm-Message-State: AOAM531uBZ+GDvh8XLt0suPQdVmqm+/mu9JK2MfBNGDTCeAnKsHNEueX
        S3Gl+PXoebIofrj9GKU64BxN1reahNDPdqYjLFFP10KxPvsLzk5tkJ61PT8hDs1A1VjGNcryZnA
        nlREPlj6kDiZ+
X-Received: by 2002:a05:600c:1552:: with SMTP id f18mr4829443wmg.184.1632234212186;
        Tue, 21 Sep 2021 07:23:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy8dBsUGmpSS/VnNnROL3eISK4+6sMfIjPu7vf/SpQmq1Qcp7XpNAZWxQfzCtY6FcM1lKR9/g==
X-Received: by 2002:a05:600c:1552:: with SMTP id f18mr4829420wmg.184.1632234212000;
        Tue, 21 Sep 2021 07:23:32 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id k6sm2873679wmo.37.2021.09.21.07.23.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 07:23:31 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v2 04/10] KVM: x86: Remove defunct setting of CR0.ET for
 guests during vCPU create
In-Reply-To: <20210921000303.400537-5-seanjc@google.com>
References: <20210921000303.400537-1-seanjc@google.com>
 <20210921000303.400537-5-seanjc@google.com>
Date:   Tue, 21 Sep 2021 16:23:30 +0200
Message-ID: <87zgs680t9.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> Drop code to set CR0.ET for the guest during initialization of the guest
> FPU.  The code was added as a misguided bug fix by commit 380102c8e431
> ("KVM Set the ET flag in CR0 after initializing FX") to resolve an issue
> where vcpu->cr0 (now vcpu->arch.cr0) was not correctly initialized on SVM
> systems.  While init_vmcb() did set CR0.ET, it only did so in the VMCB,
> and subtly did not update vcpu->cr0.  Stuffing CR0.ET worked around the
> immediate problem, but did not fix the real bug of vcpu->cr0 and the VMCB
> being out of sync.  That underlying bug was eventually remedied by commit
> 18fa000ae453 ("KVM: SVM: Reset cr0 properly on vcpu reset").
>
> No functional change intended.

fx_init() is only called from kvm_arch_vcpu_create() (and inlined later
in the series) a few lines before kvm_vcpu_reset() which stuffs CR0 with 
X86_CR0_ET too and it doesn't seem that arch.cr0 value is important in
between.

>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ab907a0b9eeb..e0bff5473813 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10628,8 +10628,6 @@ static void fx_init(struct kvm_vcpu *vcpu)
>  	 * Ensure guest xcr0 is valid for loading
>  	 */
>  	vcpu->arch.xcr0 = XFEATURE_MASK_FP;
> -
> -	vcpu->arch.cr0 |= X86_CR0_ET;
>  }
>  
>  void kvm_free_guest_fpu(struct kvm_vcpu *vcpu)

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

