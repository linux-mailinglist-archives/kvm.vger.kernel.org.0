Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F39AA12E6D3
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2020 14:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728353AbgABNa5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jan 2020 08:30:57 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32015 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728343AbgABNa4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jan 2020 08:30:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577971856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZsBhJwwJv21RoNj2+tx20MPsedLMGWgIPllyzpaocXw=;
        b=h2RgF1xpviyLcmMMekEcYdpFQCm/g6Ji7uMh+2mqzjXzzOHeUCx/Z1ilBXd7kvrxcgkhFw
        HhAsdrpZVyKDUsmC3UspKkqEaPmRncImb/Bj8yTG90e6xbFTj05Idbxwk/oBG0iklLf18G
        0WqweFvVGF/h7B4s90o855Sg/PLMFOY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-D5wEPnjhNmmO_HtNaH2VWg-1; Thu, 02 Jan 2020 08:30:54 -0500
X-MC-Unique: D5wEPnjhNmmO_HtNaH2VWg-1
Received: by mail-wr1-f72.google.com with SMTP id v17so20034063wrm.17
        for <kvm@vger.kernel.org>; Thu, 02 Jan 2020 05:30:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ZsBhJwwJv21RoNj2+tx20MPsedLMGWgIPllyzpaocXw=;
        b=s5dgkZVGvvS5n8YpLWwkwZPvQ1cQZRZL7vHcLuGPMyl5ozuIKzSwtEoDxSiw0b/ShY
         CgHhJOw4nxYNvzT5hRYEVuN5E1rivp9wMSqD53O84g4MWKUX+R1T/ktS4L4ggIAxsLXv
         Zy6rwgDuXO8GtSm82MQd3UQUctPPTG9oXnfJtEra6KIbQUqNVC1vskH3A7FvtyH2VE1P
         o3tY16vpV1+UMVSSq+cbcMs8TLAojYpMvI8T4oB8nCm8oRX0u0kHffuNZxvMm34WLf+n
         S23n7HXaZpsFbWQxabxasrdQBI9A6PQNQHLBnLyp1IMv+1UrNfyCrg82axldKXgc1ch9
         1bbQ==
X-Gm-Message-State: APjAAAW5spVmRmc/eWkWGcIP6Iq5Q+CC1NQOQRKr+afp2m2Vujn/tih6
        mSYyNeFtBzeRVJbDUjfZXsVVuOhURT3+hbBIJIoiiLH4q8iT3OY5YLd3czbQr0hnKix+KUZWFZR
        5t5u7ZOFZY2+7
X-Received: by 2002:a5d:6901:: with SMTP id t1mr77009997wru.94.1577971853250;
        Thu, 02 Jan 2020 05:30:53 -0800 (PST)
X-Google-Smtp-Source: APXvYqwdUwZjrRwC+kY/eme4evBi91EVFOSdeA7R/8x+3GHU0hsElt9g82hKc60ZmQsjwClQc7mtPQ==
X-Received: by 2002:a5d:6901:: with SMTP id t1mr77009989wru.94.1577971853010;
        Thu, 02 Jan 2020 05:30:53 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id z8sm55295423wrq.22.2020.01.02.05.30.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2020 05:30:52 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     liran.alon@oracle.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, pbonzini@redhat.com,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Subject: Re: [PATCH] KVM: SVM: Fix potential memory leak in svm_cpu_init()
In-Reply-To: <1577931640-29420-1-git-send-email-linmiaohe@huawei.com>
References: <1577931640-29420-1-git-send-email-linmiaohe@huawei.com>
Date:   Thu, 02 Jan 2020 14:30:50 +0100
Message-ID: <878smq7zp1.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

linmiaohe <linmiaohe@huawei.com> writes:

> From: Miaohe Lin <linmiaohe@huawei.com>
>
> When kmalloc memory for sd->sev_vmcbs failed, we forget to free the page
> held by sd->save_area.
>
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  arch/x86/kvm/svm.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 8f1b715dfde8..89eb382e8580 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -1012,7 +1012,7 @@ static int svm_cpu_init(int cpu)
>  	r = -ENOMEM;
>  	sd->save_area = alloc_page(GFP_KERNEL);
>  	if (!sd->save_area)
> -		goto err_1;
> +		goto free_cpu_data;
>  
>  	if (svm_sev_enabled()) {
>  		r = -ENOMEM;

Not your fault but this assignment to 'r' seem to be redundant: it is
already set to '-ENOMEM' above, but this is also not perfect as ... 

> @@ -1020,14 +1020,16 @@ static int svm_cpu_init(int cpu)
>  					      sizeof(void *),
>  					      GFP_KERNEL);
>  		if (!sd->sev_vmcbs)
> -			goto err_1;
> +			goto free_save_area;
>  	}
>  
>  	per_cpu(svm_data, cpu) = sd;
>  
>  	return 0;
>  
> -err_1:
> +free_save_area:
> +	__free_page(sd->save_area);
> +free_cpu_data:
>  	kfree(sd);
>  	return r;

... '-ENOMEM' is actually the only possible outcome here. In case you'll
be re-submitting, I'd suggest we drop 'r' entirely and just reture
-ENOMEM here.

Anyways, your patch seems to be correct, so:

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

