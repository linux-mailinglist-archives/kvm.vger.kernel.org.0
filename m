Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B289294E6E
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 16:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443427AbgJUOWz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 10:22:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33471 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437414AbgJUOWz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Oct 2020 10:22:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603290174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Yp3OQZh03TZtBBh//ZUnTZtHQGcv7MxFTpyYeikglDA=;
        b=Tf2ajQlivMTO8Pprr0Q2CBKodhfbFugjD6NBdLnM1HGiFquDfWqDixSi1kKoW5PAQdObq+
        AySWEX4tJRPh2wDekGzxdv82BD3mSIx9qHMMW2fu2GomLwyw7tZ7ka4+AP19gTpQ2Lgm5r
        zmhK0CpJscpK2liR3kNRyo2soBy12po=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-NulRydtMNH-ULPQS_q14nQ-1; Wed, 21 Oct 2020 10:22:51 -0400
X-MC-Unique: NulRydtMNH-ULPQS_q14nQ-1
Received: by mail-wm1-f69.google.com with SMTP id v14so1667228wmj.6
        for <kvm@vger.kernel.org>; Wed, 21 Oct 2020 07:22:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Yp3OQZh03TZtBBh//ZUnTZtHQGcv7MxFTpyYeikglDA=;
        b=D0lb2m0LH3KFGbO4txoK3Jp4+DdhGYeeiW0HZNsfPkQb1ycKYhXEnyHKcwbYgrLAI+
         CuEYmxPNwEBRV1+gBL6DIDWeH0ZtRz4s9TGTLvJ6tXXEiHwMIHbOMDq4whjWN8dsp5ug
         gZ1K93anhL77x8e//noUshCuzJ8GEa2atblKqywjZ2pL8XH0zea9Roow6HSR61XJ3LGK
         40fntsZ4HAHoGiy+Z9Enzy0KnEj9tfM1uBO9ZDCvq0FgzPoz8CVUXMX9BKN8YJWDOYxo
         PkIkispz4p0sV+OZ8931nl6ExREe95y1LpxuzSZtZzXp5siK4Qx4esiaDZFGAji31XiD
         miwA==
X-Gm-Message-State: AOAM532es1fm/f+n5Xjh1/lGbVXags+IdYrN/xuMOd1Hd2UkVLgxd94d
        TdNRWF7k2Tc0tRct3rDuOuR75QHVfn1gFRfHN8dvhsqSW3h4PBQSUhUZP8WKX7aKwxYuo9gPQOA
        ud7G4OAqq0Zqx
X-Received: by 2002:a7b:c762:: with SMTP id x2mr3947350wmk.102.1603290170046;
        Wed, 21 Oct 2020 07:22:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwzI0babsXTfkHvpBywnFhVI0rRhxJ+HbO+aHyxoWr0eH5bbHIxBdCFCtR3bE85jVIbhRKW+w==
X-Received: by 2002:a7b:c762:: with SMTP id x2mr3947334wmk.102.1603290169859;
        Wed, 21 Oct 2020 07:22:49 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id q8sm4168755wro.32.2020.10.21.07.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 07:22:48 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 09/10] KVM: VMX: Skip additional Hyper-V TLB EPTP flushes if one fails
In-Reply-To: <20201020215613.8972-10-sean.j.christopherson@intel.com>
References: <20201020215613.8972-1-sean.j.christopherson@intel.com> <20201020215613.8972-10-sean.j.christopherson@intel.com>
Date:   Wed, 21 Oct 2020 16:22:47 +0200
Message-ID: <87lffz4q14.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Skip additional EPTP flushes if one fails when processing EPTPs for
> Hyper-V's paravirt TLB flushing.  If _any_ flush fails, KVM falls back
> to a full global flush, i.e. additional flushes are unnecessary (and
> will likely fail anyways).
>
> Continue processing the loop unless a mismatch was already detected,
> e.g. to handle the case where the first flush fails and there is a
> yet-to-be-detected mismatch.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index a45a90d44d24..e0fea09a6e42 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -517,7 +517,11 @@ static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
>  			else
>  				mismatch = true;
>  
> -			ret |= hv_remote_flush_eptp(tmp_eptp, range);
> +			if (!ret)
> +				ret = hv_remote_flush_eptp(tmp_eptp, range);
> +
> +			if (ret && mismatch)
> +				break;
>  		}
>  		if (mismatch)
>  			kvm_vmx->hv_tlb_eptp = INVALID_PAGE;

In case my suggestion on PATCH5 gets dismissed,

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

